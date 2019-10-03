version(Have_autowrap_pynih)
    import autowrap.pynih;
else version(Have_autowrap_csharp)
    import autowrap.csharp;
else
    import autowrap.python;

enum str = wrapDlang!(
    LibraryName("numpytests"),
    Modules(
        Module("ints", Yes.alwaysExport),
        Module("floats", Yes.alwaysExport),
        Module("complex", Yes.alwaysExport),
        Module("dates", Yes.alwaysExport),
        Module("arrays", Yes.alwaysExport),
    ),
);
// pragma(msg, str);
mixin(str);
