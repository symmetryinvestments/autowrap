import autowrap;

enum str = wrapDlang!(
    LibraryName("std_exception"),
    Modules(
        Yes.alwaysExport,
        "std.exception",
        )
    );

// pragma(msg, str);
mixin(str);
