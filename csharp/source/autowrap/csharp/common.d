module autowrap.csharp.common;

public import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration, TimeZone;
public import std.range.primitives;
public import std.traits : Unqual;

public enum isDateTimeType(T) = is(T == Unqual!Date) || is(T == Unqual!DateTime) || is(T == Unqual!SysTime) || is(T == Unqual!TimeOfDay) || is(T == Unqual!Duration) || is(T == Unqual!TimeZone);
public enum isDateTimeArrayType(T) = is(T == Unqual!(Date[])) || is(T == Unqual!(DateTime[])) || is(T == Unqual!(SysTime[])) || is(T == Unqual!(TimeOfDay[])) || is(T == Unqual!(Duration[])) || is(T == Unqual!(TimeZone[]));

enum string[] excludedMethods = ["toHash", "opEquals", "opCmp", "factory", "__ctor"];

public struct LibraryName {
    string value;
}

public struct RootNamespace {
    string value;
}

public struct OutputFileName {
    string value;
}

package string getDLangInterfaceName(string moduleName, string aggName, string funcName) {
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;

    string name = "autowrap_csharp_";
    name ~= moduleName.split(".").map!camelToPascalCase.join("_");

    if (aggName != string.init) {
        name ~= camelToPascalCase(aggName) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name;
}

package string getDLangInterfaceName(string fqn, string funcName) {
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;
    string name = "autowrap_csharp_";

    name ~= fqn.split(".").map!camelToPascalCase.join("_");
    name ~= camelToPascalCase(funcName);
    return name;
}

package string getDLangSliceInterfaceName(string fqn, string funcName) {
    import std.algorithm : map, among;
    import std.string : split;
    import std.array : join;

    string name = "autowrap_csharp_slice_";

    if (fqn.among("core.time.Duration", "std.datetime.systime.SysTime", "std.datetime.date.DateTime", "autowrap.csharp.dlang.datetime")) {
        fqn = "Autowrap_Csharp_Boilerplate_Datetime";
    }

    name ~= fqn.split(".").map!camelToPascalCase.join("_");
    name ~= camelToPascalCase(funcName);
    return name;
}

public string camelToPascalCase(string camel) {
    import std.uni : toUpper;
    import std.conv : to;
    import std.range : dropOne;
    return to!string(camel.front.toUpper()) ~ camel.dropOne();
}

package template verifySupported(T)
{
    static if(isSupportedType!T)
        enum verifySupported = true;
    else
    {
        pragma(msg, T.stringof ~ " is not currently supported by autowrap's C#");
        enum verifySupported = false;
    }
}

package template numDefaultArgs(alias func)
{
    import std.meta : Filter;
    import std.traits : ParameterDefaults;

    enum numDefaultArgs = Filter!(isNotVoid, ParameterDefaults!func).length;

    private static template isNotVoid(values...)
        if(values.length == 1)
    {
        enum isNotVoid = !is(values[0] == void);
    }
}

// Unfortunately, while these tests have been tested on their own, they don't
// currently run as part of autowrap's tests, because dub test doesn't work for
// the csharp folder, and the top level one does not run them.
unittest
{
    import std.meta : AliasSeq;

    static void foo1() {}
    static void foo2(int) {}
    static void foo3(int, string) {}
    static void foo4(int, string, int) {}

    foreach(f; AliasSeq!(foo1, foo2, foo3, foo4))
        static assert(numDefaultArgs!f == 0);

    static void foo5(int i = 42) {}
    static void foo6(int, string s = "hello") {}
    static void foo7(int, string, int j = 97) {}

    foreach(f; AliasSeq!(foo5, foo6, foo7))
        static assert(numDefaultArgs!f == 1);

    static void foo9(int i = 42, string s = "hello") {}
    static void foo10(int, string s = "hello", int j = 97) {}

    foreach(f; AliasSeq!(foo9, foo10))
        static assert(numDefaultArgs!f == 2);

    static void foo11(int i = 42, string s = "hello", int j = 97) {}

    static assert(numDefaultArgs!foo11 == 3);
}

package template isSupportedType(T)
{
    import std.range.primitives : ElementType;
    import std.traits : isBoolean, isDynamicArray, isIntegral, isSomeChar, TemplateOf, Unqual;

    static if(isIntegral!T || isBoolean!T || isSomeChar!T ||
              is(Unqual!T == float) || is(Unqual!T == double) || is(T == void))
    {
        enum isSupportedType = true;
    }
    else static if(isDynamicArray!T)
    {
        alias E = ElementType!T;
        enum isSupportedType = is(E == string) || is(E == wstring) || is(E == dstring) ||
                               !isDynamicArray!E && isSupportedType!E;
    }
    else static if(is(T == struct) || is(T == class) || is(T == interface))
        enum isSupportedType = !is(typeof(TemplateOf!T));
    else
        enum isSupportedType = false;
}

// Unfortunately, while these tests have been tested on their own, they don't
// currently run as part of autowrap's tests, because dub test doesn't work for
// the csharp folder, and the top level one does not run them.
unittest
{
    import std.meta : AliasSeq;
    import std.typecons : Tuple;

    static struct S {}
    static class C {}

    foreach(T; AliasSeq!(byte, ubyte, const ubyte, immutable ubyte, short, ushort, int, uint, long, ulong,
                         float, double, bool, char, wchar, dchar, string, wstring, dstring, S, S[], C, int[],
                         string[], wstring[], dstring[], void))
    {
        static assert(isSupportedType!T, T.stringof);
    }
    foreach(T; AliasSeq!(int*, int*[], int[][], int[][][], int[int], cfloat, cdouble, creal, ifloat, idouble, ireal,
                         Tuple!int, Tuple!(string, string)))
    {
        static assert(!isSupportedType!T, T.stringof);
    }
}
