module autowrap.csharp;

public import autowrap.csharp.boilerplate;
public import autowrap.csharp.csharp;
public import autowrap.csharp.dlang;
public import autowrap.csharp.common;
public import autowrap.types : Modules, Module, LibraryName, RootNamespace, OutputFileName;
public import std.typecons : Yes, No;


string wrapDlang(
    autowrap.types.LibraryName libraryName,
    Modules modules,
    RootNamespace rootNamespace,
    )()
    @safe pure
{
    import std.string: capitalize;
    return wrapDlang!(
        libraryName,
        modules,
        rootNamespace,
        OutputFileName(libraryName.value.capitalize ~ ".cs")
    );
}


string wrapDlang(
    autowrap.types.LibraryName libraryName,
    Modules modules,
    RootNamespace rootNamespace,
    OutputFileName outputFile,
    )()
    @safe pure
{
    assert(__ctfe);

    return wrapCSharp(modules, outputFile, libraryName, rootNamespace);
}
