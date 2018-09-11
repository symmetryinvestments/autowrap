namespace Autowrap.CSharp {
    using System;
    using System.Reflection;
    using System.Runtime.InteropServices;

    public static class Methods {
        static Methods() {
            DRuntimeInitialize();
        }

        /// Support Methods
        [DllImport("csharp", EntryPoint = "autowrap_cswrap_dlang_getError", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangWString GetError(ulong errorId);

        [DllImport("csharp", EntryPoint = "autowrap_cswrap_dlang_createString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangString CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_cswrap_dlang_createWString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangWString CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_cswrap_dlang_createDString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangDString CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("csharp", EntryPoint = "autowrap_cswrap_dlang_release", CallingConvention = CallingConvention.Cdecl)]
        public static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("csharp", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  
        [DllImport("csharp", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  
    }
}