namespace Autowrap.CSharp {
    using System;

    public abstract class DLangBase : IDisposable {
        protected readonly IntPtr ptr;
        internal IntPtr Pointer => ptr;

        protected DLangBase(IntPtr ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            Methods.ReleaseMemory(ptr);
        }
    }
}
