import autowrap;


enum str = wrapDlang!(
    LibraryName("std_numeric"),
    Modules(
        Yes.alwaysExport,
        "std.numeric",
    )
);

// pragma(msg, str);
mixin(str);
