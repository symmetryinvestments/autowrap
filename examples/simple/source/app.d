version(Have_autowrap_pynih)
    import autowrap.pynih;
else
    import autowrap.python;

mixin(
    wrapAll(
        LibraryName("simple"),
        Modules(
            "prefix", "adder", "structs", "templates", "api",
            Module("wrap_all", Yes.alwaysExport)
        ),
    )
);
