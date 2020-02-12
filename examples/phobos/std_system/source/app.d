import autowrap;

enum str = wrapDlang!(
    LibraryName("std_system"),
    Modules(
        Yes.alwaysExport,
        "std.system",
        )
    );

// pragma(msg, str);
mixin(str);
