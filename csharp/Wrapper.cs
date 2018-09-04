namespace csharp {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.InteropServices;

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

        public dlang_slice(IntPtr ptr, IntPtr length) {
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
        private readonly slice ptr;

        public dlang_refslice(IntPtr ptr, IntPtr length) {
            this.ptr = new slice(ptr, length);
        }

        public void Dispose() {
            ptr.Dispose();
        }

        internal slice ToSlice() {
            return ptr;
        }
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
        private readonly IntPtr ptr;
        internal IntPtr Pointer => ptr;

        protected DLangBase(IntPtr ptr) {
            this.ptr = ptr;
        }

        public void Dispose()
        {
            library.ReleaseMemory(ptr);
        }
    }

    public static class library {
        static library() {
            DRuntimeInitialize();
        }

/// Support Methods

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_string CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createWString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_wstring CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_createDString", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_dstring CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "cswrap_dlang_release", CallingConvention = CallingConvention.Cdecl)]
        public static extern dlang_dstring ReleaseMemory(IntPtr ptr);

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

    }
}
