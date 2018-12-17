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
