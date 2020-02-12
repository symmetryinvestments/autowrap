import autowrap;

enum str = wrapDlang!(
    LibraryName("std_mathspecial"),
    Modules(
        Yes.alwaysExport,
        "std.mathspecial",
        )
    );

// pragma(msg, str);
mixin(str);
