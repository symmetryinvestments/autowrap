import autowrap;


enum str = wrapDlang!(
    LibraryName("std_net"),
    Modules(
        Yes.alwaysExport,
        "std.net.curl",
        "std.net.isemail",
    )
);

// pragma(msg, str);
mixin(str);
