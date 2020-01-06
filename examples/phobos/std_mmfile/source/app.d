import autowrap;


enum str = wrapDlang!(
    LibraryName("std_mmfile"),
    Modules(
        Yes.alwaysExport,
        "std.mmfile",
    )
);

// pragma(msg, str);
mixin(str);
