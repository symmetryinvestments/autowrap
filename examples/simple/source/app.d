version(Have_autowrap_pynih)
    import autowrap.pynih;
else
    import autowrap.python;

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
