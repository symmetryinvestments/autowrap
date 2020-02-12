import autowrap;

enum str = wrapDlang!(
    LibraryName("std_windows"),
    Modules(
        Yes.alwaysExport,
        "std.windows.charset",
        "std.windows.registry",
        "std.windows.syserror",
        )
    );

// pragma(msg, str);
mixin(str);
