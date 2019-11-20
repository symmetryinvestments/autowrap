import autowrap;

enum str = wrapDlang!(
    LibraryName("numpytests"),
    Modules(
        Module("ints", Yes.alwaysExport),
        Module("floats", Yes.alwaysExport),
        Module("complex", Yes.alwaysExport),
        Module("dates", Yes.alwaysExport),
        Module("arrays", Yes.alwaysExport),
    ),
);
// pragma(msg, str);
mixin(str);
