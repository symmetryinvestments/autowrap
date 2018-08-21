namespace csharp {

    using System.Runtime.InteropServices;

    public static class library {
        static library() {
            DRuntimeInitialize();
        }

        [DllImport("csharp", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  
        [DllImport("csharp", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  

        [DllImport("csharp", EntryPoint = "cswrap_freeFunction", CallingConvention = CallingConvention.Cdecl)]  
        public static extern int FreeFunction(int value);  

        [DllImport("csharp", EntryPoint = "cswrap_stringFunction", CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static extern string StringFunction([MarshalAs(UnmanagedType.LPWStr)]string value);  
    }

}