module autowrap.csharp.common;

public struct LibraryName {
    string value;
}

public struct RootNamespace {
    string value;
}

public string generateSharedTypes() {
    return q{
        extern(C) export struct datetime {
            long ticks;
            long offset;

            public this(Duration value) {
                this.ticks = value.total!"hnsecs";
                this.offset = 0;
            }

            public this(DateTime value) {
                this.ticks = SysTime(value).stdTime;
                this.offset = 0;
            }

            public this(Date value) {
                this.ticks = SysTime(value).stdTime;
                this.offset = 0;
            }

            public this(TimeOfDay value) {
                Duration t = dur!"hours"(value.hour) + dur!"minutes"(value.minute) + dur!"seconds"(value.second);
                this.ticks = value.total!"hnsecs";
                this.offset = 0;
            }

            public this(SysTime value) {
                this.ticks = value.stdTime;
                this.offset = value.utcOffset.total!"hnsecs";
            }
        }
    };
}

package string getInterfaceTypeString(T)() {
    import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration;
    import std.traits : fullyQualifiedName;

    if (is(T == DateTime) || is(T == SysTime) || is(T == Date) || is(T == TimeOfDay) || is(T == Duration)) {
        return "datetime";
    }

    return fullyQualifiedName!T;
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
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;
    string name = "autowrap_csharp_slice_";

    name ~= fqn.split(".").map!camelToPascalCase.join("_");
    name ~= camelToPascalCase(funcName);
    return name;
}

public string camelToPascalCase(string camel) {
    import std.uni : toUpper;
    import std.conv : to;
    return to!string(camel[0].toUpper) ~ camel[1..$];
}
