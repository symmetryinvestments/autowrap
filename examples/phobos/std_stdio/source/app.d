import autowrap;


enum str = wrapDlang!(
    LibraryName("std_stdio"),
    Modules(
        Yes.alwaysExport,
        "std.stdio",
    )
);

// pragma(msg, str);
mixin(str);
