import autowrap;

enum str = wrapDlang!(
    LibraryName("std_outbuffer"),
    Modules(
        Yes.alwaysExport,
        "std.outbuffer",
        )
    );

// pragma(msg, str);
mixin(str);
