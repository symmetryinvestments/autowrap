import autowrap;

enum str = wrapDlang!(
    LibraryName("std_uuid"),
    Modules(
        Yes.alwaysExport,
        "std.uuid",
        )
    );

// pragma(msg, str);
mixin(str);
