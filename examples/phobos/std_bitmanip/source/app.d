import autowrap;

enum str = wrapDlang!(
    LibraryName("std_bitmanip"),
    Modules(
        Yes.alwaysExport,
        "std.bitmanip",
        )
    );

// pragma(msg, str);
mixin(str);
