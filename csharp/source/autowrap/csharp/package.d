module autowrap.csharp;

import std.string: capitalize;

public import autowrap.csharp.boilerplate;
public import autowrap.csharp.csharp;
public import autowrap.csharp.dlang;
public import autowrap.csharp.common;
public import autowrap.types : Modules, Module, LibraryName, RootNamespace, OutputFileName;
public import std.typecons : Yes, No;


string wrapDlang(
    LibraryName libraryName,
    Modules modules,
    RootNamespace rootNamespace = RootNamespace(),
    OutputFileName outputFile = OutputFileName(libraryName.value.capitalize ~ ".cs")
    )()
    @safe pure
{
    assert(__ctfe);
    return wrapCSharp(modules, outputFile, libraryName, rootNamespace);
}
