import autowrap.python;
import std.typecons: Yes;

mixin(
    wrapAll(
        LibraryName("numpytests"),
        Modules(
            Module("ints", Yes.alwaysExport),
            Module("floats", Yes.alwaysExport),
            Module("complex", Yes.alwaysExport),
            Module("dates", Yes.alwaysExport),
            Module("arrays", Yes.alwaysExport),
        ),
    )
);
