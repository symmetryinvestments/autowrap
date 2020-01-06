import autowrap;

enum str = wrapDlang!(
    LibraryName("std_math"),
    Modules(
        Module("std.math", Yes.alwaysExport, Ignore("rndtonl")),
    )
);

// pragma(msg, str);
mixin(str);
