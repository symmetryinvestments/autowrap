import autowrap;

enum str = wrapDlang!(
    LibraryName("std_typetuple"),
    Modules(
        Yes.alwaysExport,
        "std.typetuple",
        )
    );

// pragma(msg, str);
mixin(str);
