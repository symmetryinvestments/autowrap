import autowrap;


enum str = wrapDlang!(
    LibraryName("std_math"),
    Modules(
        Yes.alwaysExport,
        "std.math",
    )
);

// pragma(msg, str);
mixin(str);
