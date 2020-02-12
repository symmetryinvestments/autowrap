import autowrap;

enum str = wrapDlang!(
    LibraryName("std_format"),
    Modules(
        Yes.alwaysExport,
        "std.format",
        )
    );

// pragma(msg, str);
mixin(str);
