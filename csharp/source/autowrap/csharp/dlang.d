module autowrap.csharp.dlang;

import autowrap.csharp.boilerplate;
import autowrap.reflection;

import std.ascii;
import std.traits;
import std.string;

///  Wrap global functions from multiple modules
public string wrapDLangFreeFunctions(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string ret = string.init;

    foreach(func; AllFunctions!Modules) {
        pragma(msg, typeof(func));
        alias modName = func.moduleName;
        pragma(msg, modName);
        alias funcName = func.name;
        pragma(msg, funcName);

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        pragma(msg, returnType);
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        pragma(msg, returnTypeStr);
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        pragma(msg, paramTypes);
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        pragma(msg, paramNames);
        enum isNothrow = functionAttributes!(__traits(getMember, func.module_, func.name)) & FunctionAttribute.nothrow_;
        pragma(msg, isNothrow);
        const string interfaceName = getDlangInterfaceName(modName, null, funcName);
        //pragma(msg, interfaceName);
        string retType = string.init;
        string funcStr = "extern(C) export ";

        if (!isNothrow) {
            retType = retType ~ "exportValue!(" ~ returnTypeStr ~ ")";
        } else {
            retType = returnTypeStr;
        }

        funcStr ~= retType ~ " " ~ interfaceName ~ "(";
/*        for(int i = 0; i < paramTypes.length; i++) {
            funcStr ~= fullyQualifiedName!paramTypes[i++] ~ " " ~ pName ~ ", ";
        }
        int pc = 0;
        foreach(pName; paramNames) {
            funcStr ~= fullyQualifiedName!paramTypes[pc++] ~ " " ~ pName ~ ", ";
        }
        funcStr = funcStr[0..$-2];*/
        funcStr ~= ") nothrow {" ~ newline;
        funcStr ~= "import " ~ modName ~ " : " ~ func.name ~ ";" ~ newline;
        if (!isNothrow) {
            funcStr ~= "try { " ~ newline;
            funcStr ~= "return " ~ retType ~ "(" ~ func.name ~ "(";
            foreach(pName; paramNames) {
                funcStr ~= pName ~ ", ";
            }
            funcStr = funcStr[0..$-2];
            funcStr ~= "));" ~ newline;
            funcStr ~= "} catch (Exception ex) {" ~ newline;
            funcStr ~= "return " ~ retType ~ "(string.init, ex);" ~ newline;
            funcStr ~= "}" ~ newline;
        } else {
            funcStr ~= retType ~ " temp = " ~ func.name ~ "(";
            foreach(pName; paramNames) {
                funcStr ~= pName ~ ", ";
            }
            funcStr = funcStr[0..$-2];
            funcStr ~= ");" ~ newline;
            if (isArray!(returnType) || is(returnType == class) || is(returnType == interface)) {
                funcStr ~= "pinPointer(cast(void*)temp.ptr);" ~ newline;
            }
            funcStr ~= "return temp;" ~ newline;
        }
        funcStr ~= "}" ~ newline;

        ret ~= funcStr;
    }

    return ret;
}

private string getInterfaceTypeString(TypeInfo type) {
    import std.datetime : DateTime;

    if (typeid(DateTime) == type) {
        return type.toString();
    }

    return type.toString();
}

private string getDlangInterfaceName(string moduleName, string aggName, string funcName) {
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

private string camelToPascalCase(string camel) {
    import std.uni : toUpper;
    import std.conv : to;
    return to!string(camel[0].toUpper) ~ camel[1..$];
}
