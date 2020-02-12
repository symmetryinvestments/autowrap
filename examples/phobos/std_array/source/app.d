import autowrap;

enum str = wrapDlang!(
    LibraryName("std_array"),
    Modules(
        Yes.alwaysExport,
        "std.array",
        )
    );

// pragma(msg, str);
mixin(str);
