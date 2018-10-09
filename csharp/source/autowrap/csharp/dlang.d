module autowrap.csharp.dlang;

import autowrap.csharp.boilerplate;
import autowrap.csharp.common;
import autowrap.reflection;

import std.ascii;
import std.traits;
import std.string;

///  Wrap global functions from multiple modules
public string wrapDLangFreeFunctions(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string ret = string.init;

    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        enum isNothrow = functionAttributes!(__traits(getMember, func.module_, func.name)) & FunctionAttribute.nothrow_;
        const string interfaceName = getDlangInterfaceName(modName, null, funcName);
        string retType = string.init;
        string funcStr = "extern(C) export ";

        if (!isNothrow) {
            retType = retType ~ "errorValue!(" ~ returnTypeStr ~ ")";
        } else {
            retType = returnTypeStr;
        }

        funcStr ~= retType ~ " " ~ interfaceName ~ "(";
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= fullyQualifiedName!(paramTypes[pc]) ~ " " ~ paramNames[pc] ~ ", ";
        }
        funcStr = funcStr[0..$-2];
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
            funcStr ~= "return " ~ retType ~ "(ex);" ~ newline;
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
