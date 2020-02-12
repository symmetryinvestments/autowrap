import autowrap;

enum str = wrapDlang!(
    LibraryName("std_functional"),
    Modules(
        Yes.alwaysExport,
        "std.functional",
        )
    );

// pragma(msg, str);
mixin(str);
