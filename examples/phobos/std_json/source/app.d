import autowrap;

enum str = wrapDlang!(
    LibraryName("std_json"),
    Modules(
        Yes.alwaysExport,
        "std.json",
        )
    );

// pragma(msg, str);
mixin(str);
