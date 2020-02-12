import autowrap;

enum str = wrapDlang!(
    LibraryName("std_complex"),
    Modules(
        Yes.alwaysExport,
        "std.complex",
        )
    );

// pragma(msg, str);
mixin(str);
