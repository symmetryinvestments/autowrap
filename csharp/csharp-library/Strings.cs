namespace Autowrap.CSharp {
    using System;
    using System.Reflection;
    using System.Runtime.InteropServices;

    [StructLayout(LayoutKind.Sequential)]
    public struct DLangString {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF8.GetString((byte*)ptr.ToPointer(), length.ToInt32());
            }
        }

        public void Dispose()
        {
            Methods.ReleaseMemory(ptr);
        }

        public static implicit operator string(DLangString str)
        {
            return str.ToString();
        }

        public static implicit operator DLangString(string str)
        {
            return Methods.CreateString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct DLangWString {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.Unicode.GetString((byte*)ptr.ToPointer(), length.ToInt32()*2);
            }
        }

        public void Dispose()
        {
            Methods.ReleaseMemory(ptr);
        }

        public static implicit operator string(DLangWString str)
        {
            return str.ToString();
        }

        public static implicit operator DLangWString(string str)
        {
            return Methods.CreateWString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct DLangDString : IDisposable {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF32.GetString((byte*)ptr.ToPointer(), length.ToInt32()*4);
            }
        }

        public void Dispose()
        {
            Methods.ReleaseMemory(ptr);
        }

        public static implicit operator string(DLangDString str)
        {
            return str.ToString();
        }

        public static implicit operator DLangDString(string str)
        {
            return Methods.CreateDString(str);
        }
    }
}
