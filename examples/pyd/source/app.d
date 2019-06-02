version(Have_autowrap_pynih)
    import autowrap.pynih;
else
    import autowrap.python;

version(Have_autowrap_pynih) {
    enum str = wrapDlang!(
        LibraryName("pyd"),
        Modules(
            Module("arraytest", Yes.alwaysExport),
            Module("inherit", Yes.alwaysExport),
            Module("testdll", Yes.alwaysExport),
            Module("def", Yes.alwaysExport),
            Module("struct_wrap", Yes.alwaysExport),
            Module("const_", Yes.alwaysExport),
            Module("class_wrap", Yes.alwaysExport),
        ),
    );
    pragma(msg, str);
    mixin(str);
} else {
    mixin(
        wrapAll(
            LibraryName("pyd"),
            Modules(
                Module("arraytest", Yes.alwaysExport),
                Module("inherit", Yes.alwaysExport),
                Module("testdll", Yes.alwaysExport),
                Module("def", Yes.alwaysExport),
                Module("struct_wrap", Yes.alwaysExport),
                Module("const_", Yes.alwaysExport),
                Module("class_wrap", Yes.alwaysExport),
            ),
        )
    );
}
