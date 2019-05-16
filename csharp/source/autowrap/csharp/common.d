module autowrap.csharp.common;

public import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration, TimeZone;
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

package string getDLangInterfaceType(T)() {
    import std.traits : fullyQualifiedName;
    if (isDateTimeType!T) {
        return "datetime";
    } else if (isDateTimeArrayType!T) {
        return "datetime[]";
    } else {
        return fullyQualifiedName!T;
    }
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
    return to!string(camel[0].toUpper) ~ camel[1..$];
}
