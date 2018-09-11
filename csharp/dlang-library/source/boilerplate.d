module autowrap.csharp.boilerplate;

public wchar* getCSharpString(string str) @trusted {
    import std.utf;
    import core.stdc.stdlib;

    wstring wstr = toUTF16(str);
    wchar* temp = cast(wchar*) malloc(wstr.length * wchar.sizeof + 1);
    for(int i = 0; i < wstr.length; i++) {
        temp[i] = wstr[i];
    }
    temp[wstr.length] = 0;

    return temp;
}

//Shared library boilerplate for windows
version(Windows) {

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

}