import autowrap;

enum str = wrapDlang!(
    LibraryName("std_bigint"),
    Modules(
        Yes.alwaysExport,
        "std.bigint",
        )
    );

// pragma(msg, str);
mixin(str);
