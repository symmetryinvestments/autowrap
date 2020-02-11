import autowrap;

enum str = wrapDlang!(
    LibraryName("std_variant"),
    Modules(
        Yes.alwaysExport,
        "std.variant",
        )
    );

// pragma(msg, str);
mixin(str);
