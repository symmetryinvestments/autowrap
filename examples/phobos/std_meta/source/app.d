import autowrap;

enum str = wrapDlang!(
    LibraryName("std_meta"),
    Modules(
        Yes.alwaysExport,
        "std.meta",
        )
    );

// pragma(msg, str);
mixin(str);
