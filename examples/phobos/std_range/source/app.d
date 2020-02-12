import autowrap;

enum str = wrapDlang!(
    LibraryName("std_range"),
    Modules(
        Yes.alwaysExport,
        "std.range.interfaces",
        "std.range.primitives",
        )
    );

// pragma(msg, str);
mixin(str);
