import autowrap.python;

mixin(
    wrapAll(
        LibraryName("simple"),
        Modules(
            "prefix", "adder", "structs", "templates", "api", "issues",
            Module("wrap_all", Yes.alwaysExport)
        ),
    )
);
