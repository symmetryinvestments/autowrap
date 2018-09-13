namespace Autowrap.CSharp {
    using Mono.Unix;
    using System;
    using System.IO;
    using System.Reflection;
    using System.Runtime.InteropServices;

    public static class Methods {
        static Methods() {
            Stream stream = null;
            var outputName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "libautowrap.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "libautowrap.so" : "autowrap.dll";

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.libautowrap.dylib");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.libautowrap.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.libautowrap.x86.so");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.libautowrap.x64.dll");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("Autowrap.CSharp.libautowrap.x86.dll");
            }
            if (stream != null) {
                using(var file = new FileStream(outputName, FileMode.OpenOrCreate, FileAccess.Write)) {
                    stream.CopyTo(file);
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                        var ufi = new UnixFileInfo(outputName);
                        ufi.FileAccessPermissions |= FileAccessPermissions.UserExecute | FileAccessPermissions.GroupExecute | FileAccessPermissions.OtherExecute; 
                    }
                }
            } else {
                throw new DllNotFoundException($"The required native assembly was not found for the current operating system and process architecture.");
            }

            DRuntimeInitialize();
        }

        /// Support Methods
        [DllImport("autowrap", EntryPoint = "autowrap_csharp_dlang_getError", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangWString GetError(ulong errorId);

        [DllImport("autowrap", EntryPoint = "autowrap_csharp_dlang_createString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangString CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("autowrap", EntryPoint = "autowrap_csharp_dlang_createWString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangWString CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("autowrap", EntryPoint = "autowrap_csharp_dlang_createDString", CallingConvention = CallingConvention.Cdecl)]
        public static extern DLangDString CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("autowrap", EntryPoint = "autowrap_csharp_dlang_release", CallingConvention = CallingConvention.Cdecl)]
        public static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("autowrap", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  

        [DllImport("autowrap", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  
    }
}