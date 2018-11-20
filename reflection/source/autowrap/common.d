module autowrap.common;

/**
   Returns a string to be mixed in that defines DllMain, needed on Windows.
 */
public string dllMainMixinStr() @safe pure {
    return q{

        import core.sys.windows.windows: HINSTANCE, BOOL, ULONG, LPVOID;

        __gshared HINSTANCE g_hInst;

        extern (Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved) {

            import core.sys.windows.windows;
            import core.sys.windows.dll;

            switch (ulReason)  {

                case DLL_PROCESS_ATTACH:
                    g_hInst = hInstance;
                    dll_process_attach(hInstance, true);
                break;

                case DLL_PROCESS_DETACH:
                    dll_process_detach(hInstance, true);
                    break;

                case DLL_THREAD_ATTACH:
                    dll_thread_attach(true, true);
                    break;

                case DLL_THREAD_DETACH:
                    dll_thread_detach(true, true);
                    break;

                default:
            }

            return true;
        }
    };
}
