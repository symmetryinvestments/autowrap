module autowrap.csharp.common;

import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration;

public enum isDateTimeType(T) = is(T == Date) || is(T == DateTime) || is(T == SysTime) || is(T == TimeOfDay) || is(T == Duration);
public enum isDateTimeArrayType(T) = is(T == Date[]) || is(T == DateTime[]) || is(T == SysTime[]) || is(T == TimeOfDay[]) || is(T == Duration[]);

enum string[] excludedMethods = ["toHash", "opEquals", "opCmp", "factory", "__ctor"];

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
                import core.time : Duration, hours, minutes, seconds;
                Duration t = hours(value.hour) + minutes(value.minute) + seconds(value.second);
                this.ticks = t.total!"hnsecs";
                this.offset = 0;
            }

            public this(SysTime value) {
                this.ticks = value.stdTime;
                this.offset = value.utcOffset.total!"hnsecs";
            }
        }
    };
}

package string getDLangInterfaceType(T)() {
    import std.traits : fullyQualifiedName;
    import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration;
    if (is(T == Date) || is(T == DateTime) || is(T == SysTime) || is(T == TimeOfDay) || is(T == Duration)) {
        return "datetime";
    } else if (is(T == Date[]) || is(T == DateTime[]) || is(T == SysTime[]) || is(T == TimeOfDay[]) || is(T == Duration[])) {
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
        fqn = "datetime";
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
