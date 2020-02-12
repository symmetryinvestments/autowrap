import autowrap;

enum str = wrapDlang!(
    LibraryName("std_socket"),
    Modules(
        Yes.alwaysExport,
        "std.socket",
        )
    );

// pragma(msg, str);
mixin(str);
