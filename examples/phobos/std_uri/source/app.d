import autowrap;

enum str = wrapDlang!(
    LibraryName("std_uri"),
    Modules(
        Yes.alwaysExport,
        "std.uri",
        )
    );

// pragma(msg, str);
mixin(str);
