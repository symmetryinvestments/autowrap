import autowrap.python;
import std.typecons: Yes;

mixin(
    wrapAll(
        LibraryName("pyd"),
        Modules(
            Module("arraytest", Yes.alwaysExport),
        ),
    )
);
