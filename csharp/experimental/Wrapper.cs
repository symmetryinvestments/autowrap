namespace csharp {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;

    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct dlang_string {
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
    public struct dlang_wstring {
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
    public struct dlang_dstring : IDisposable {
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

    public struct slice : IDisposable {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }

        public void Dispose()
        {
            library.ReleaseMemory(ptr);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct dlang_slice<T> : IDisposable
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
            ptr.Dispose();
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
    public struct dlang_refslice<T> : IDisposable
        where T : DLangBase
    {
        private readonly dlang_slice<IntPtr> ptr;

        private dlang_refslice(dlang_slice<IntPtr> ptr) {
            this.ptr = ptr;
        }

        public dlang_refslice(slice ptr) {
            this.ptr = new dlang_slice<IntPtr>(ptr);
        }

        public void Dispose() {
            ptr.Dispose();
        }

        public static implicit operator dlang_refslice<T>(T[] slice) {
            dlang_slice<IntPtr> t = slice.Select(a => a.Pointer).ToArray().AsSpan();
            return new dlang_refslice<T>(t);
        }

        public static implicit operator T[](dlang_refslice<T> slice) {
            Span<IntPtr> t = slice.ptr;
            Type ti = typeof(T);
            var ci = ti.GetConstructor(BindingFlags.Instance |BindingFlags.NonPublic, null, new[] { typeof(IntPtr) }, null);
            var ol = new List<T>();
            foreach(var ip in t.ToArray()) {
                ol.Add((T)ci.Invoke(new object[] {ip}));
            }
            return ol.ToArray();
        }

        internal slice ToSlice() {
            return ptr.ToSlice();
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct ErrorString
    {
        public dlang_string value;
        public ulong errorId;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S1 {
        public float value;
        public S2 nestedStruct;

        public float getValue() {
            return library.S1_GetValue(ref this);
        }

        public void setNestedStruct(S2 nested) {
            library.S1_SetNestedStruct(ref this, ref nested);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct S2 {
        public int value;
        public dlang_string str;

        public S2(int v, string s) {
            this.value = v;
            this.str = s;
        }
    }

    public abstract class DLangBase : IDisposable {
        protected readonly IntPtr ptr;
        internal IntPtr Pointer => ptr;

        protected DLangBase(IntPtr ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            library.ReleaseMemory(ptr);
        }
    }

    public class C1 : DLangBase {
        public C1() : base(library.C1__ctor()) { }
        private C1(IntPtr ptr) : base(ptr) { }

        public S2 Hidden {
            get { return library.C1_Get_GetHidden(this.ptr); }
            set { library.C1_Set_SetHidden(this.ptr, value); }
        }

        public string StringValue {
            get { return library.C1_Get_StringValue(this.ptr); }
            set { library.C1_Set_StringValue(this.ptr, value); }
        }

        public int IntValue {
            get { return library.C1_Get_IntValue(this.ptr); }
            set { library.C1_Set_IntValue(this.ptr, value); }
        }

        public string TestMemberFunc(string value, S1 test) {
            return library.C1_TestMemberFunc(this.ptr, value, test);
        }
    }

    public static class library {
        static library() {
            DRuntimeInitialize();
        }

/// Support Methods
        [DllImport("csharp", EntryPoint = "cswrap_getError", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_wstring GetError(ulong errorId);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_string CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createWString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_wstring CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createDString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_dstring CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

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
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static extern string StringFunction([MarshalAs(UnmanagedType.LPWStr)]string value);  

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
                slice = library.C1_AppendRange(slice, t.Pointer);
                Console.WriteLine($"Class Ref: {t.Pointer.ToInt64()}");
            }
            Console.WriteLine($"Array Ref: {slice.ptr.ToInt64()}");
            var ret = new dlang_refslice<C1>(ClassRangeFunction(slice));
            return ret;
        }

        [DllImport("csharp", EntryPoint = "cswrap_testErrorMessage", CallingConvention = CallingConvention.Cdecl)]
        private static extern ErrorString wrap_TestErrorMessage(bool throwError);
        public static string TestErrorMessage(bool throwError) {
            var ret = library.wrap_TestErrorMessage(throwError);
            if (ret.errorId != 0) {
                throw new DLangException(library.GetError(ret.errorId));
            }
            return ret.value;
        }

        [DllImport("csharp", EntryPoint = "cswrap_s1_createRange", CallingConvention = CallingConvention.Cdecl)]  
        public static extern slice S1_CreateRange();

        [DllImport("csharp", EntryPoint = "cswrap_s1_getValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern float S1_GetValue(ref S1 cswrap_s1);

        [DllImport("csharp", EntryPoint = "cswrap_s1_setNestedStruct", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void S1_SetNestedStruct(ref S1 cswrap_s1, ref S2 nested);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_string_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        public static extern dlang_string DLang_String_StringFunction(dlang_string value);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_wstring_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        public static extern dlang_wstring DLang_WString_StringFunction(dlang_wstring value);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_dstring_stringFunction", CallingConvention = CallingConvention.Cdecl)]  
        public static extern dlang_dstring DLang_DString_StringFunction(dlang_dstring value);

        [DllImport("csharp", EntryPoint = "cswrap_c1__ctor", CallingConvention = CallingConvention.Cdecl)]  
        public static extern IntPtr C1__ctor();

        [DllImport("csharp", EntryPoint = "cswrap_c1_createRange", CallingConvention = CallingConvention.Cdecl)]  
        public static extern slice C1_CreateRange(int capacity);

        [DllImport("csharp", EntryPoint = "cswrap_c1_appendRange", CallingConvention = CallingConvention.Cdecl)]  
        public static extern slice C1_AppendRange(slice ptr, IntPtr appendPtr);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_getHidden", CallingConvention = CallingConvention.Cdecl)]  
        public static extern S2 C1_Get_GetHidden(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_setHidden", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void C1_Set_SetHidden(IntPtr cswrap_c1, S2 value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_stringValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern dlang_string C1_Get_StringValue(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_stringValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void C1_Set_StringValue(IntPtr cswrap_c1, dlang_string value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_get_intValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern int C1_Get_IntValue(IntPtr cswrap_c1);

        [DllImport("csharp", EntryPoint = "cswrap_c1_set_intValue", CallingConvention = CallingConvention.Cdecl)]  
        public static extern void C1_Set_IntValue(IntPtr cswrap_c1, int value);

        [DllImport("csharp", EntryPoint = "cswrap_c1_testMemberFunc", CallingConvention = CallingConvention.Cdecl)]  
        public static extern dlang_string C1_TestMemberFunc(IntPtr cswrap_c1, dlang_string test, S1 value);
    }
}
