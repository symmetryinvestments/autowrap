import autowrap;

enum str = wrapDlang!(
    LibraryName("std_typecons"),
    Modules(
        Yes.alwaysExport,
        "std.typecons",
        )
    );

// pragma(msg, str);
mixin(str);
