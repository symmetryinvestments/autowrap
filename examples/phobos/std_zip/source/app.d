import autowrap;

enum str = wrapDlang!(
    LibraryName("std_zip"),
    Modules(
        Yes.alwaysExport,
        "std.zip",
        )
    );

// pragma(msg, str);
mixin(str);
