import autowrap;


enum str = wrapDlang!(
    LibraryName("std_random"),
    Modules(
        Yes.alwaysExport,
        "std.random",
    )
);

// pragma(msg, str);
mixin(str);
