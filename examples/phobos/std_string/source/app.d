import autowrap;

enum str = wrapDlang!(
    LibraryName("std_string"),
    Modules(
        Yes.alwaysExport,
        "std.string",
        )
    );

// pragma(msg, str);
mixin(str);
