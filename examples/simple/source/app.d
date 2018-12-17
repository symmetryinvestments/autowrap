version(WrapPython)
{
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
}

version(WrapCSharp)
{
	import autowrap.csharp;
	mixin(
	    wrapCSharp(
		Modules(
		    "prefix", "adder", "structs", "templates", "api",
		    Module("wrap_all") // , Yes.alwaysExport),
		),
		OutputFileName("simple.cs"),
		LibraryName("simple"),
		RootNamespace("simple")
	    )
	);
}

version(WrapExcel)
{
	import xlld:wrapAll;

	mixin(
	    wrapAll!(
		    "prefix", "adder", "structs", "templates", "api","wrap_all"
		),
        );
}

