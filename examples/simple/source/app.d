import autowrap.python;
import api:preModuleInitCode,postModuleInitCode;
mixin(
    wrapAll(
        LibraryName("simple"),
        Modules(
            "prefix", "adder", "structs", "templates",
	       Module("api",Yes.alwaysExport),
            Module("wrap_all", Yes.alwaysExport)
        ),
	preModuleInitCode,
	postModuleInitCode,
    )
);
