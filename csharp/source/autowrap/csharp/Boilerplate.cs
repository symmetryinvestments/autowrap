namespace Autowrap {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct slice {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    internal enum DStringType : int {
        None = 0,
        _string = 1,
        _wstring = 2,
        _dstring = 4,
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public abstract class DLangObject {
        private readonly IntPtr _ptr;
        internal protected IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        ~DLangObject() {
            SharedFunctions.ReleaseMemory(_ptr);
        }
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator bool(return_bool_error ret) { ret.EnsureValid(); return ret._value != 0; }
        private byte _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator slice(return_slice_error ret) { ret.EnsureValid(); return ret._value; }
        private slice _value;
        private slice _error;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct datetime {
        public datetime(long ticks, long offset) {
            this._ticks = ticks;
            this._offset = offset;
        }
        public static implicit operator datetime(DateTime ret) { return new datetime(ret.Ticks, 0L); }
        public static implicit operator datetime(DateTimeOffset ret) { return new datetime(ret.Ticks, ret.Offset.Ticks); }
        public static implicit operator datetime(TimeSpan ret) { return new datetime(ret.Ticks, 0L); }
        public static implicit operator DateTime(datetime ret) { return new DateTime(ret._ticks, DateTimeKind.Local); }
        public static implicit operator DateTimeOffset(datetime ret) { return new DateTimeOffset(ret._ticks, new TimeSpan(ret._offset)); }
        public static implicit operator TimeSpan(datetime ret) { return new TimeSpan(ret._ticks); }
        private long _ticks;
        private long _offset;
    }

    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_datetime_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator DateTime(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        public static implicit operator DateTimeOffset(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        public static implicit operator TimeSpan(return_datetime_error ret) { ret.EnsureValid(); return ret._value; }
        private datetime _value;
        private slice _error;
    }

%3$s    [GeneratedCodeAttribute("Autowrap", "1.0.0.0")]
    public static class SharedFunctions {
        static SharedFunctions() {
            Stream stream = null;
            var outputName = Path.Combine(Environment.CurrentDirectory, RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "lib%1$s.dylib" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "lib%1$s.so" : "lib%1$s.dll");

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("%2$s.lib%1$s.dylib");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("%2$s.lib%1$s.x64.so");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("%2$s.lib%1$s.x86.so");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("%2$s.%1$s.x64.dll");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("%2$s.%1$s.x86.dll");
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
                throw new DllNotFoundException($"The required native assembly is unavailable for the current operating system and process architecture.");
            }

            DRuntimeInitialize();
        }

        internal static string SliceToString(slice str, DStringType type) {
            try {
                unsafe {
                    var bytes = (byte*)str.ptr.ToPointer();
                    if (bytes == null) {
                        return null;
                    }
                    if (type == DStringType._string) {
                        return String.Copy(System.Text.Encoding.UTF8.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else if (type == DStringType._wstring) {
                        return String.Copy(System.Text.Encoding.Unicode.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else if (type == DStringType._dstring) {
                        return String.Copy(System.Text.Encoding.UTF32.GetString(bytes, str.length.ToInt32()*(int)type));
                    } else {
                        throw new UnauthorizedAccessException("Unable to convert D string to C# string: Unrecognized string type.");
                    }
                }
            } finally {
                SharedFunctions.ReleaseMemory(str.ptr);
            }
        }

        // Support Functions
        [DllImport("%1$s", EntryPoint = "autowrap_csharp_createString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("%1$s", EntryPoint = "autowrap_csharp_createWString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateWstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("%1$s", EntryPoint = "autowrap_csharp_createDString", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateDstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport("%1$s", EntryPoint = "autowrap_csharp_release", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport("%1$s", EntryPoint = "rt_init", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();

        [DllImport("%1$s", EntryPoint = "rt_term", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();
    }

%4$s
}
