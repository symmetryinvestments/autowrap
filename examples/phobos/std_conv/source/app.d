import autowrap;

enum str = wrapDlang!(
    LibraryName("std_conv"),
    Modules(
        Yes.alwaysExport,
        "std.conv",
        )
    );

// pragma(msg, str);
mixin(str);
