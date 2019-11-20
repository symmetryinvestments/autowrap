module autowrap.csharp;

public import autowrap.csharp.boilerplate;
public import autowrap.csharp.csharp;
public import autowrap.csharp.dlang;
public import autowrap.csharp.common;
public import autowrap.types : Modules, Module, LibraryName, RootNamespace, OutputFileName;
public import std.typecons : Yes, No;


string wrapDlang(
    in Modules modules,
    in autowrap.types.LibraryName libraryName,
    in RootNamespace rootNamespace,
    )
    @safe pure
{
    import std.string: capitalize;
    return wrapDlang(modules, libraryName, rootNamespace, OutputFileName(libraryName.value.capitalize));
}


string wrapDlang(
    in Modules modules,
    in autowrap.types.LibraryName libraryName,
    in RootNamespace rootNamespace,
    in OutputFileName outputFile,
    )
    @safe pure
{
    assert(__ctfe);

    return wrapCSharp(modules, outputFile, libraryName, rootNamespace);
}
