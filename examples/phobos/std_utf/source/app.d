import autowrap;

enum str = wrapDlang!(
    LibraryName("std_utf"),
    Modules(
        Yes.alwaysExport,
        "std.utf",
        )
    );

// pragma(msg, str);
mixin(str);
