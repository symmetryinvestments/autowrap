module autowrap.excel;


public import autowrap.types: Modules, Module, isModule,
    LibraryName, PreModuleInitCode, PostModuleInitCode, RootNamespace;


string wrapDlang(
    autowrap.types.LibraryName libraryName,
    Modules modules,
    RootNamespace _ = RootNamespace(), // ignored in this backend
    PreModuleInitCode preModuleInitCode = PreModuleInitCode(),    // ignored in this backend
    PostModuleInitCode postModuleInitCode = PostModuleInitCode(), // ignored in this backend
    )()
    @safe pure
{
    import std.algorithm: map;
    import std.array: join;

    mixin(`return wrapAll!(`, modules.value.map!(a => `"` ~ a.name ~ `"`).join(`, `), `;`);
}


string wrapAll(Modules...)(in string mainModule = __MODULE__) {
    if(!__ctfe) return "";

    import xlld: wrapAll_ = wrapAll;
    import std.typecons: Yes;

    return
        "import xlld;\n" ~
        wrapAll_!Modules(Yes.onlyExports, Yes.pascalCase, mainModule);
}
