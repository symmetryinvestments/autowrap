import autowrap;

enum str = wrapDlang!(
    LibraryName("std_uni"),
    Modules(
        Yes.alwaysExport,
        "std.uni",
        )
    );

// pragma(msg, str);
mixin(str);
