module autowrap.csharp.common;

package string getInterfaceTypeString(TypeInfo type) {
    import std.datetime : DateTime;

    if (typeid(DateTime) == type) {
        return type.toString();
    }

    return type.toString();
}

package string getDlangInterfaceName(string moduleName, string aggName, string funcName) {
    import std.string : split;
    string name = "autowrap_csharp_";

    foreach(string namePart; moduleName.split(".")) {
        name ~= camelToPascalCase(namePart) ~ "_";
    }
    if (aggName !is null && aggName != string.init) {
        name ~= camelToPascalCase(aggName) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name;
}

package string getDlangInterfaceName(string fqn, string funcName) {
    import std.string : split;
    string name = "autowrap_csharp_";

    foreach(string namePart; fqn.split(".")) {
        name ~= camelToPascalCase(namePart) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name;
}

package string camelToPascalCase(string camel) {
    import std.uni : toUpper;
    import std.conv : to;
    return to!string(camel[0].toUpper) ~ camel[1..$];
}
