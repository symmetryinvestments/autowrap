import autowrap;


enum str = wrapDlang!(
    LibraryName("std_datetime"),
    Modules(
        Yes.alwaysExport,
        "std.file",
    )
);

// pragma(msg, str);
mixin(str);
