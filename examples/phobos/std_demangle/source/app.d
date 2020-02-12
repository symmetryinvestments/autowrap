import autowrap;

enum str = wrapDlang!(
    LibraryName("std_demangle"),
    Modules(
        Yes.alwaysExport,
        "std.demangle",
        )
    );

// pragma(msg, str);
mixin(str);
