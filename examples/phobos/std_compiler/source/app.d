import autowrap;

enum str = wrapDlang!(
    LibraryName("std_compiler"),
    Modules(
        Yes.alwaysExport,
        "std.compiler",
        )
    );

// pragma(msg, str);
mixin(str);
