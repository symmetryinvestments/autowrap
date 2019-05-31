version(Have_autowrap_pynih)
    import autowrap.pynih;
else
    import autowrap.python;

version(Have_autowrap_pynih) {
    enum str = wrapDlang!(
        LibraryName("simple"),
        Modules(
            "prefix",
            "adder",
            "structs",
            "templates",
            "api",
            Module("wrap_all", Yes.alwaysExport)
        ),
    );

    //pragma(msg,str);
    mixin(str);
}
else
    mixin(
        wrapAll(
            LibraryName("simple"),
            Modules(
                "prefix", "adder", "structs", "templates", "api",
                Module("wrap_all", Yes.alwaysExport)
            ),
        )
    );
