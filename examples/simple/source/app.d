import autowrap.python;
mixin(
    wrapAll(LibraryName("simple"),
            Modules("prefix", "adder", "structs", "templates", "api",
                    Module("wrap_all", Yes.alwaysExport)
            ),
        )
    );
