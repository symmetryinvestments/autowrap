import autowrap;

enum str = wrapDlang!(
    LibraryName("std_signals"),
    Modules(
        Yes.alwaysExport,
        "std.signals",
        )
    );

// pragma(msg, str);
mixin(str);
