import autowrap;

enum str = wrapDlang!(
    LibraryName("std_regex"),
    Modules(
        Yes.alwaysExport,
        "std.regex",
        )
    );

// pragma(msg, str);
mixin(str);
