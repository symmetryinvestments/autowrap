import autowrap;

enum str = wrapDlang!(
    LibraryName("std_traits"),
    Modules(
        Yes.alwaysExport,
        "std.traits",
        )
    );

// pragma(msg, str);
mixin(str);
