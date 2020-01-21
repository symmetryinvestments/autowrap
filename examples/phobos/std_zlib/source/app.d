import autowrap;

enum str = wrapDlang!(
    LibraryName("std_zlib"),
    Modules(
        Yes.alwaysExport,
        "std.zlib",
        )
    );

// pragma(msg, str);
mixin(str);
