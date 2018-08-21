namespace csharp {
    using System;

    using System.Runtime.InteropServices;

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_string {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF8.GetString((byte*)ptr.ToPointer(), length.ToInt32());
            }
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
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_dstring {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF32.GetString((byte*)ptr.ToPointer(), length.ToInt32()*4);
            }
        }
    }

    public struct S2 {

    }

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