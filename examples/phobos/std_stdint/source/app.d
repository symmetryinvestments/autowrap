import autowrap;

enum str = wrapDlang!(
    LibraryName("std_stdint"),
    Modules(
        Yes.alwaysExport,
        "std.stdint",
        )
    );

// pragma(msg, str);
mixin(str);
