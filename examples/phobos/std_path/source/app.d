import autowrap;

enum str = wrapDlang!(
    LibraryName("std_path"),
    Modules(
        Yes.alwaysExport,
        "std.path",
        )
    );

// pragma(msg, str);
mixin(str);
