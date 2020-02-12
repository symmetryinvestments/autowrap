import autowrap;

enum str = wrapDlang!(
    LibraryName("std_csv"),
    Modules(
        Yes.alwaysExport,
        "std.csv",
        )
    );

// pragma(msg, str);
mixin(str);
