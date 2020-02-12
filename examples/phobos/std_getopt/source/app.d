import autowrap;

enum str = wrapDlang!(
    LibraryName("std_getopt"),
    Modules(
        Yes.alwaysExport,
        "std.getopt",
        )
    );

// pragma(msg, str);
mixin(str);
