namespace Autowrap.CSharp {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;

    public struct Slice : IDisposable {
        internal IntPtr length;
        internal IntPtr ptr;

        public Slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }

        public void Dispose()
        {
            Methods.ReleaseMemory(ptr);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct DLangSlice<T> : IDisposable
        where T : unmanaged
    {
        private readonly Slice ptr;

        private DLangSlice(IntPtr ptr, IntPtr length) {
            this.ptr = new Slice(ptr, length);
        }

        public DLangSlice(Slice ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            ptr.Dispose();
        }

        public static implicit operator DLangSlice<T>(Span<T> slice) {
            unsafe {
                fixed (T* temp = slice) {
                    IntPtr tptr = new IntPtr((void*)temp);
                    return new DLangSlice<T>(tptr, new IntPtr(slice.Length));
                }
            }
        }

        public static implicit operator Span<T>(DLangSlice<T> slice) {
            unsafe {
                return new Span<T>(slice.ptr.ptr.ToPointer(), slice.ptr.length.ToInt32());
            }
        }

        internal Slice ToSlice() {
            return ptr;
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct DLangRefSlice<T> : IDisposable
        where T : DLangBase
    {
        private readonly DLangSlice<IntPtr> ptr;

        private DLangRefSlice(DLangSlice<IntPtr> ptr) {
            this.ptr = ptr;
        }

        public DLangRefSlice(Slice ptr) {
            this.ptr = new DLangSlice<IntPtr>(ptr);
        }

        public void Dispose() {
            ptr.Dispose();
        }

        public static implicit operator DLangRefSlice<T>(T[] slice) {
            DLangSlice<IntPtr> t = slice.Select(a => a.Pointer).ToArray().AsSpan();
            return new DLangRefSlice<T>(t);
        }

        public static implicit operator T[](DLangRefSlice<T> slice) {
            Span<IntPtr> t = slice.ptr;
            Type ti = typeof(T);
            var ci = ti.GetConstructor(BindingFlags.Instance | BindingFlags.NonPublic, null, new[] { typeof(IntPtr) }, null);
            var ol = new List<T>();
            foreach(var ip in t.ToArray()) {
                ol.Add((T)ci.Invoke(new object[] {ip}));
            }
            return ol.ToArray();
        }

        internal Slice ToSlice() {
            return ptr.ToSlice();
        }
    }

}