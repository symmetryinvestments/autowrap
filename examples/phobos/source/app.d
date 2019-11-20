import autowrap;

enum str = wrapDlang!(
    LibraryName("phobos"),
    Modules(
        Module("std.socket", Yes.alwaysExport),
    ),
);

// pragma(msg, str);
mixin(str);
