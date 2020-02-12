import autowrap;

enum str = wrapDlang!(
    LibraryName("std_base64"),
    Modules(
        Yes.alwaysExport,
        "std.base64",
        )
    );

// pragma(msg, str);
mixin(str);
