import autowrap;

enum str = wrapDlang!(
    LibraryName("std_ascii"),
    Modules(
        Yes.alwaysExport,
        "std.ascii",
        )
    );

// pragma(msg, str);
mixin(str);
