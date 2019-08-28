version(Have_autowrap_pynih)
    import autowrap.pynih;
else version(Have_autowrap_csharp)
    import autowrap.csharp;
else
    import autowrap.python;


enum str = wrapDlang!(
    LibraryName("issues"),
    Modules(
        "issues",
    ),
);
// pragma(msg, str);
mixin(str);
