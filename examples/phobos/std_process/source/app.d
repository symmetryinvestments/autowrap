import autowrap;


enum str = wrapDlang!(
    LibraryName("std_process"),
    Modules(
        Yes.alwaysExport,
        "std.process",
    )
);

// pragma(msg, str);
mixin(str);


version(Have_autowrap_pyd) {
    /**
       Otherwise there's a linker error
     */
    private void hack() {
        import std.stdio: File;
        auto id = typeid(File("/tmp/foo").lockingBinaryWriter);
    }
}
