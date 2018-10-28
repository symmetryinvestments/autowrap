namespace csharp {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_string {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF8.GetString((byte*)ptr.ToPointer(), length.ToInt32());
            }
        }

        public void Dispose()
        {
            library.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_string str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_string(string str)
        {
            return library.CreateString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_wstring {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.Unicode.GetString((byte*)ptr.ToPointer(), length.ToInt32()*2);
            }
        }

        public void Dispose()
        {
            library.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_wstring str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_wstring(string str)
        {
            return library.CreateWString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_dstring : IDisposable {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF32.GetString((byte*)ptr.ToPointer(), length.ToInt32()*4);
            }
        }

        public void Dispose()
        {
            library.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_dstring str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_dstring(string str)
        {
            return library.CreateDString(str);
        }
    }

    internal struct slice {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }

        public void Release()
        {
            library.ReleaseMemory(ptr);
        }

        internal static T[] ToArray<T>(slice dslice)
            where T : unmanaged {
            Span<T> span = new dlang_slice<T>(dslice);
            return span.ToArray();
        }
    }

    public class RefSlice<T> : IEnumerable<T>
        where T : DLangObject {
        private slice _slice;
        internal RefSlice(slice dslice) {
            this._slice = dslice;
        }

        private static extern IntPtr dlang_slice_C1_Get(slice dslice, IntPtr index);
        private static extern void dlang_slice_C1_Set(slice dslice, IntPtr index, IntPtr value);
        private static extern slice dlang_slice_C1_Slice(IntPtr begin, IntPtr end);
        private static extern slice dlang_slice_C1_Append(slice dslice, IntPtr value);

        public T this[long i] {
            get {
                if (typeof(T) == typeof(C1)) return (T)(DLangObject)new C1(dlang_slice_C1_Get(this._slice, new IntPtr(i)));
                throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
            }
            set {
                if (typeof(T) == typeof(C1)) dlang_slice_C1_Set(this._slice, new IntPtr(i), value.DLangPointer);
            }
        }

        public static RefSlice<T> operator +(RefSlice<T> dslice, T value) {
            if (typeof(T) == typeof(C1)) return new RefSlice<T>(dlang_slice_C1_Append(dslice._slice, value.DLangPointer));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public RefSlice<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                if (typeof(T) == typeof(S1)) yield return (T)(object)new C1(dlang_slice_C1_Get(_slice, new IntPtr(i)));
            }
        }
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }

    public class ValueSlice<T> : IEnumerable<T>
        where T : unmanaged {
        private readonly slice _slice;
        internal ValueSlice(slice dslice) {
            this._slice = dslice;
        }
        public long Length => _slice.length.ToInt64();

        public ValueSlice(long capacity = 0) {
            if (typeof(T) == typeof(S1)) this._slice = dlang_slice_S1_Create(new IntPtr(capacity));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                if (typeof(T) == typeof(S1)) yield return (T)(object)dlang_slice_S1_Get(_slice, new IntPtr(i));
            }
        }
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        private static extern slice dlang_slice_S1_Create(IntPtr capacity);
        private static extern S1 dlang_slice_S1_Get(slice dslice, IntPtr index);
        private static extern void dlang_slice_S1_Set(slice dslice, IntPtr index, S1 value);
        private static extern slice dlang_slice_S1_Slice(IntPtr begin, IntPtr end);
        private static extern slice dlang_slice_S1_Append(slice dslice, S1 value);
        private static extern slice dlang_slice_S1_Append(slice dslice, slice array);

        public T this[long i] {
            get {
                if (typeof(T) == typeof(S1)) return (T)(object)dlang_slice_S1_Get(this._slice, new IntPtr(i));
                throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
            }
            set {
                if (typeof(T) == typeof(S1)) dlang_slice_S1_Set(this._slice, new IntPtr(i), (S1)(object)value);
            }
        }

        public static ValueSlice<T> operator +(ValueSlice<T> dslice, T value) {
            if (typeof(T) == typeof(S1)) return new ValueSlice<T>(dlang_slice_S1_Append(dslice._slice, (S1)(object)value));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public static ValueSlice<T> operator +(ValueSlice<T> dslice, ValueSlice<T> value) {
            if (typeof(T) == typeof(S1)) return new ValueSlice<T>(dlang_slice_S1_Append(dslice._slice, value._slice));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public ValueSlice<T> Slice(long begin) {
            if (typeof(T) == typeof(S1)) return new ValueSlice<T>(dlang_slice_S1_Slice(new IntPtr(begin), _slice.length));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }

        public ValueSlice<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException("Value for parameter 'end' is greater than that length of the slice.");
            }
            if (typeof(T) == typeof(S1)) return new ValueSlice<T>(dlang_slice_S1_Slice(new IntPtr(begin), new IntPtr(end)));
            throw new TypeAccessException($"Slice does not support type: {typeof(T).ToString()}");
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_slice<T> : IDisposable
        where T : unmanaged
    {
        private readonly slice ptr;

        private dlang_slice(IntPtr ptr, IntPtr length) {
            this.ptr = new slice(ptr, length);
        }

        public dlang_slice(slice ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            ptr.Release();
        }

        public static implicit operator dlang_slice<T>(Span<T> slice) {
            unsafe {
                fixed (T* temp = slice) {
                    IntPtr tptr = new IntPtr((void*)temp);
                    return new dlang_slice<T>(tptr, new IntPtr(slice.Length));
                }
            }
        }

        public static implicit operator Span<T>(dlang_slice<T> slice) {
            unsafe {
                return new Span<T>(slice.ptr.ptr.ToPointer(), slice.ptr.length.ToInt32());
            }
        }

        internal slice ToSlice() {
            return ptr;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct ErrorString
    {
        public dlang_string value;
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S1 {
        public float value;
        public S2 nestedStruct;

        public float getValue() {
            return library.S1_GetValue(ref this);
        }

        public void setNestedStruct(S2 nested) {
            library.S1_SetNestedStruct(ref this, nested);
        }

        internal static S1[] SliceToArray(slice dlang_slice) {
            Span<S1> span = new dlang_slice<S1>(dlang_slice);
            return span.ToArray();
        }

        internal static slice ArrayToSlice(S1[] array) {
            Span<S1> span = array;
            dlang_slice<S1> dls = span;
            return dls.ToSlice();
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S2 {
        public int value;
        private dlang_string _str;
        public string str { get => _str; set => _str = value; }

        public S2(int v, string s) {
            this.value = v;
            this._str = s;
        }
    }

    public abstract class DLangObject : IDisposable {
        protected readonly IntPtr _ptr;
        internal IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        public void Dispose() {
            library.ReleaseMemory(_ptr);
        }
    }

    public class C1 : DLangObject {
        public C1() : base(library.C1__ctor()) { }
        internal C1(IntPtr ptr) : base(ptr) { }

        public S2 Hidden { get => library.C1_Get_GetHidden(DLangPointer); set => library.C1_Set_SetHidden(DLangPointer, value); }

        public string StringValue {
            get { return library.C1_Get_StringValue(DLangPointer); }
            set { library.C1_Set_StringValue(DLangPointer, value); }
        }

        public int IntValue {
            get { return library.C1_Get_IntValue(DLangPointer); }
            set { library.C1_Set_IntValue(DLangPointer, value); }
        }

        public string TestMemberFunc(string value, S1 test) {
            return library.C1_TestMemberFunc(DLangPointer, value, test);
        }

        internal static C1[] SliceToArray(slice dslice) {
            Span<IntPtr> span = new dlang_slice<IntPtr>(dslice);
            return span.ToArray().Select(a => new C1(a)).ToArray();
        }

        internal static slice ArrayToSlice(C1[] array) {
            dlang_slice<IntPtr> slice = array.Select(a => a.DLangPointer).ToArray().AsSpan();
            return slice.ToSlice();
        }

    }

    public static class library {
        static library() {
            Stream stream = null;
            var outputName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "libcsharp.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "libcsharp.so" : "csharp.dll";

            var names = Assembly.GetExecutingAssembly().GetManifestResourceNames();
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.libcsharp.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("csharp.libcsharp.x86.so");
            }
            if (stream != null) {
                using(var file = new FileStream(outputName, FileMode.OpenOrCreate, FileAccess.Write)) {
                    stream.CopyTo(file);
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                        var ufi = new Mono.Unix.UnixFileInfo(outputName);
                        ufi.FileAccessPermissions |= FileAccessPermissions.UserExecute | FileAccessPermissions.GroupExecute | FileAccessPermissions.OtherExecute; 
                    }
                }
            }
            else {
                throw new DllNotFoundException($"The required native assembly was not found for the current operating system and process architecture.");
            }

            DRuntimeInitialize();
        }

/// Support Methods
        //[DllImport("csharp", EntryPoint = "cswrap_getError", CallingConvention = CallingConvention.Cdecl)]
        //public static extern dlang_wstring GetError(ulong errorId);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_string CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createWString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_wstring CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createDString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_dstring CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_release", CallingConvention = CallingConvention.Cdecl)]
        public static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("csharp", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();
        [DllImport("csharp", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();

/// Library Methods

        [DllImport("csharp", EntryPoint = "cswrap_freeFunction", CallingConvention = CallingConvention.Cdecl)]  
        public static extern int FreeFunction(int value);  

        [DllImport("csharp", EntryPoint = "cswrap_stringFunction", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_string StringFunction(dlang_string value);  

        [DllImport("csharp", EntryPoint = "cswrap_arrayFunction", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice ArrayFunction(slice array);
        public static S2[] ArrayFunction(S2[] array) {
            dlang_slice<S2> slice = array.AsSpan();
            var ret = new dlang_slice<S2>(ArrayFunction(slice.ToSlice()));
            Span<S2> t = ret;
            return t.ToArray();
        }

        [DllImport("csharp", EntryPoint = "cswrap_classRangeFunction", CallingConvention = CallingConvention.Cdecl)]
        private static extern slice ClassRangeFunction(slice array);
        public static C1[] ClassRangeFunction(C1[] array) {
            var slice = library.C1_CreateRange(array.Length);
            foreach(var t in array) {
                slice = library.C1_AppendRange(slice, t.DLangPointer);
            }
            //return new dlang_refslice<C1>(ClassRangeFunction(slice));
            return null;
        }

        [DllImport("csharp", EntryPoint = "cswrap_testErrorMessage", CallingConvention = CallingConvention.Cdecl)]
        private static extern ErrorString wrap_TestErrorMessage(bool throwError);
        public static string TestErrorMessage(bool throwError) {
            var ret = library.wrap_TestErrorMessage(throwError);
            if (!string.IsNullOrEmpty(ret.error)) {
                throw new DLangException(ret.error);
            }
            return ret.value;
        }

        [DllImport("csharp", EntryPoint = "cswrap_s1_createRange", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice S1_CreateRange();

        [DllImport("csharp", EntryPoint = "cswrap_s1_getValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern float S1_GetValue(ref S1 cswrap_s1);

        [DllImport("csharp", EntryPoint = "cswrap_s1_setNestedStruct", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void S1_SetNestedStruct(ref S1 cswrap_s1, S2 nested);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_string_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern dlang_string DLang_String_StringFunction(dlang_string value);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_wstring_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern dlang_wstring DLang_WString_StringFunction(dlang_wstring value);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_dstring_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern dlang_dstring DLang_DString_StringFunction(dlang_dstring value);

        [DllImport("csharp", EntryPoint = "cswrap_c1__ctor", CallingConvention = CallingConvention.Cdecl)]  
        public static extern IntPtr C1__ctor();

        [DllImport("csharp", EntryPoint = "cswrap_c1_createRange", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern slice C1_CreateRange(int capacity);

        [DllImport("csharp", EntryPoint = "cswrap_c1_appendRange", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern slice C1_AppendRange(slice ptr, IntPtr appendPtr);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_getHidden", CallingConvention = CallingConvention.Cdecl)]  
        public static extern S2 C1_Get_GetHidden(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_setHidden", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void C1_Set_SetHidden(IntPtr cswrap_c1, S2 value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_stringValue", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern dlang_string C1_Get_StringValue(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_stringValue", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern void C1_Set_StringValue(IntPtr cswrap_c1, dlang_string value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_intValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern int C1_Get_IntValue(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_intValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void C1_Set_IntValue(IntPtr cswrap_c1, int value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_testMemberFunc", CallingConvention = CallingConvention.Cdecl)]  
        internal static extern dlang_string C1_TestMemberFunc(IntPtr cswrap_c1, dlang_string test, S1 value);
    }
}
