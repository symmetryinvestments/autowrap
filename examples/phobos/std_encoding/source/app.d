import autowrap;

enum str = wrapDlang!(
    LibraryName("std_encoding"),
    Modules(
        Yes.alwaysExport,
        "std.encoding",
        )
    );

// pragma(msg, str);
mixin(str);
