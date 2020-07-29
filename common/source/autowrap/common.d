module autowrap.common;

/**
   Returns a string to be mixed in that defines DllMain, needed on Windows.
 */
public string dllMainMixinStr() @safe pure {
    return q{

        static if (!is(DllMainDefined)) {
            enum DllMainDefined;

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
    };
}


/// Converts an identifier from camelCase or PascalCase to snake_case.
string toSnakeCase(in string str) @safe pure {

    import std.algorithm: all, map;
    import std.ascii: isUpper;

    if(str.all!isUpper) return str;

    string ret;

    string convert(in size_t index, in char c) {
        import std.ascii: isLower, toLower;

        const prefix = index == 0 ? "" : "_";
        const isHump =
            (index == 0 && c.isUpper) ||
            (index > 0 && c.isUpper && str[index - 1].isLower);

        return isHump ? prefix ~ c.toLower : "" ~ c;
    }

    foreach(i, c; str) {
        ret ~= convert(i, c);
    }

    return ret;
}


version(AutowrapStrict)
    enum AlwaysTry = true;
else
    enum AlwaysTry = false;
