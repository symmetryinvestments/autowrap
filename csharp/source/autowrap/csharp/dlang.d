module autowrap.csharp.dlang;

import scriptlike : interp, _interp_text;

import core.time : Duration;
import std.datetime : Date, DateTime, SysTime, TimeOfDay, TimeZone;
import std.ascii : newline;
import std.meta : allSatisfy;

import autowrap.csharp.boilerplate;
import autowrap.csharp.common : getDLangInterfaceType;
import autowrap.reflection : isModule, PrimordialType;

enum string methodSetup = "        thread_attachThis();
        rt_moduleTlsCtor();
        scope(exit) rt_moduleTlsDtor();
        scope(exit) thread_detachThis();";


// Wrap global functions from multiple modules
public string wrapDLang(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : isDateTimeType;
    import autowrap.reflection : AllAggregates;
    import std.traits : fullyQualifiedName, moduleName;
    import std.meta : AliasSeq;

    string ret = string.init;
    ret ~= "import core.thread : thread_attachThis, thread_detachThis;" ~ newline;
    ret ~= "extern(C) void rt_moduleTlsCtor();" ~ newline;
    ret ~= "extern(C) void rt_moduleTlsDtor();" ~ newline;
    foreach(mod; Modules) {
        ret ~= mixin(interp!"import ${mod.name};${newline}");
    }
    ret ~= newline;

    static foreach(t; AliasSeq!(string, wstring, dstring, bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double, datetime)) {
        ret ~= generateSliceMethods!t();
    }

    alias aggregates = AllAggregates!Modules;
    static foreach(agg; aggregates) {
        static if (!isDateTimeType!agg) {
            ret ~= generateSliceMethods!agg();
            ret ~= generateConstructors!agg();
            ret ~= generateMethods!agg();
            ret ~= generateFields!agg();
        }
    }

    ret ~= generateFunctions!Modules();

    return ret;
}

private string generateConstructors(T)() {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : fullyQualifiedName, hasMember, Parameters, ParameterIdentifierTuple;
    import std.meta : AliasSeq;
    import std.algorithm : among;

    string ret = string.init;
    alias fqn = getDLangInterfaceType!T;

    //Generate constructor methods
    static if(hasMember!(T, "__ctor") && __traits(getProtection, __traits(getMember, T, "__ctor")).among("export", "public")) {
        foreach(c; __traits(getOverloads, T, "__ctor")) {
            if (__traits(getProtection, c).among("export", "public")) {
                alias paramNames = ParameterIdentifierTuple!c;
                alias paramTypes = Parameters!c;
                string exp = "extern(C) export ";
                const string interfaceName = getDLangInterfaceName(fqn, "__ctor");

                exp ~= mixin(interp!"returnValue!(${fqn}) ${interfaceName}(");

                static foreach(pc; 0..paramNames.length) {
                    exp ~= mixin(interp!"${getDLangInterfaceType!(paramTypes[pc])} ${paramNames[pc]}, ");
                }
                if (paramTypes.length > 0) {
                    exp = exp[0..$-2];
                }
                exp ~= ") nothrow {" ~ newline;
                exp ~= "    try {" ~ newline;
                exp ~= methodSetup ~ newline;
                if (is(T == class)) {
                    exp ~= mixin(interp!"        ${fqn} __temp__ = new ${fqn}(");
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= mixin(interp!"${paramNames[pc]}, ");
                    }
                    if (paramTypes.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                    exp ~= "        pinPointer(cast(void*)__temp__);" ~ newline;
                    exp ~= mixin(interp!"        return returnValue!(${fqn})(__temp__);${newline}");
                } else if (is(T == struct)) {
                    exp ~= mixin(interp!"        return ${fqn}(");
                    foreach(pn; paramNames) {
                        exp ~= mixin(interp!"${pn}, ");
                    }
                    if (paramTypes.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                }
                exp ~= "    } catch (Exception __ex__) {" ~ newline;
                exp ~= mixin(interp!"        return returnValue!(${fqn})(__ex__);${newline}");
                exp ~= "    }" ~ newline;
                exp ~= "}" ~ newline;
                ret ~= exp;
            }
        }
    }

    return ret;
}

private string generateMethods(T)() {
    import autowrap.csharp.common : isDateTimeType, isDateTimeArrayType, getDLangInterfaceName;
    import std.traits : isFunction, fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple;
    import std.conv : to;
    import std.algorithm : among;

    string ret = string.init;
    alias fqn = getDLangInterfaceType!T;
    foreach(m; __traits(allMembers, T)) {
        if (m.among("__ctor", "toHash", "opEquals", "opCmp", "factory")) {
            continue;
        }

        static if (is(typeof(__traits(getMember, T, m)))) {
            foreach(oc, mo; __traits(getOverloads, T, m)) {
                const bool isMethod = isFunction!mo;

                static if(isMethod && __traits(getProtection, mo).among("export", "public")) {
                    string exp = string.init;
                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = getDLangInterfaceType!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;

                    exp ~= "extern(C) export ";
                    static if (!is(returnType == void)) {
                        exp ~= mixin(interp!"returnValue!(${returnTypeStr})");
                    } else {
                        exp ~= "returnVoid";
                    }
                    exp ~= mixin(interp!" ${interfaceName}${oc}(");
                    if (is(T == struct)) {
                        exp ~= mixin(interp!"ref ${fqn} __obj__, ");
                    } else {
                        exp ~= mixin(interp!"${fqn} __obj__, ");
                    }
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= mixin(interp!"${getDLangInterfaceType!(paramTypes[pc])} ${paramNames[pc]}, ");
                    }
                    exp = exp[0..$-2];
                    exp ~= ") nothrow {" ~ newline;
                    exp ~= "    try {" ~ newline;
                    exp ~= methodSetup ~ newline;
                    exp ~= "        ";
                    if (!is(returnType == void)) {
                        exp ~= "auto __result__ = ";
                    }
                    exp ~= mixin(interp!"__obj__.${m}(");
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= mixin(interp!"${generateParameter!(paramTypes[pc])(paramNames[pc])}, ");
                    }
                    if (paramNames.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                    static if (isDateTimeType!returnType || isDateTimeArrayType!returnType) {
                        exp ~= mixin(interp!"        return returnValue!(${returnTypeStr})(${generateReturn!returnType(\"__result__\")});${newline}");
                    } else static if (!is(returnType == void)) {
                        exp ~= mixin(interp!"        return returnValue!(${returnTypeStr})(__result__);${newline}");
                    } else {
                        exp ~= "        return returnVoid();" ~ newline;
                    }
                    exp ~= "    } catch (Exception __ex__) {" ~ newline;
                    if (!is(returnType == void)) {
                        exp ~= mixin(interp!"        return returnValue!(${returnTypeStr})(__ex__);${newline}");
                    } else {
                        exp ~= "        return returnVoid(__ex__);" ~ newline;
                    }
                    exp ~= "    }" ~ newline;
                    exp ~= "}" ~ newline;
                    ret ~= exp;
                }
            }
        }
    }

    return ret;
}

private string generateFields(T)() {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : fullyQualifiedName, Fields, FieldNameTuple;

    string ret = string.init;
    alias fqn = getDLangInterfaceType!T;
    if (is(T == class) || is(T == interface)) {
        alias fieldTypes = Fields!T;
        alias fieldNames = FieldNameTuple!T;
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                ret ~= mixin(interp!"extern(C) export returnValue!(${getDLangInterfaceType!(fieldTypes[fc])}) ${getDLangInterfaceName(fqn, fieldNames[fc] ~ \"_get\")}(${fqn} __obj__) nothrow {${newline}");
                ret ~= generateMethodErrorHandling(mixin(interp!"        auto __value__ = __obj__.${fieldNames[fc]};${newline}        return returnValue!(${getDLangInterfaceType!(fieldTypes[fc])})(${generateReturn!(fieldTypes[fc])(\"__value__\")});"), mixin(interp!"returnValue!(${getDLangInterfaceType!(fieldTypes[fc])})"));
                ret ~= "}" ~ newline;
                ret ~= mixin(interp!"extern(C) export returnVoid ${getDLangInterfaceName(fqn, fieldNames[fc] ~ \"_set\")}(${fqn} __obj__, ${getDLangInterfaceType!(fieldTypes[fc])} value) nothrow {${newline}");
                ret ~= generateMethodErrorHandling(mixin(interp!"        __obj__.${fieldNames[fc]} = ${generateParameter!(fieldTypes[fc])(\"value\")};${newline}        return returnVoid();"), "returnVoid");
                ret ~= "}" ~ newline;
            }
        }
    }
    return ret;
}

private string generateFunctions(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : getDLangInterfaceName;
    import autowrap.reflection: AllFunctions;
    import std.traits : fullyQualifiedName, hasMember, functionAttributes, FunctionAttribute, ReturnType, Parameters, ParameterIdentifierTuple;

    string ret = string.init;
    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = getDLangInterfaceType!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        string retType = string.init;
        string funcStr = "extern(C) export ";

        static if (!is(returnType == void)) {
            retType ~= mixin(interp!"returnValue!(${returnTypeStr})");
        } else {
            retType ~= "returnVoid";
        }

        funcStr ~= mixin(interp!"${retType} ${interfaceName}(");
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= mixin(interp!"${getDLangInterfaceType!(paramTypes[pc])} ${paramNames[pc]}, ");
        }
        if(paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ") nothrow {" ~ newline;
        funcStr ~= "    try {" ~ newline;
        funcStr ~= methodSetup ~ newline;
        funcStr ~= "        ";
        if (!is(returnType == void)) {
            funcStr ~= mixin(interp!"auto __return__ = ${func.name}(");
        } else {
            funcStr ~= mixin(interp!"${func.name}(");
        }
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= mixin(interp!"${generateParameter!(paramTypes[pc])(paramNames[pc])}, ");
        }
        if(paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ");" ~ newline;
        if (!is(returnType == void)) {
            funcStr ~= mixin(interp!"        return ${retType}(${generateReturn!(returnType)(\"__return__\")});${newline}");
        } else {
            funcStr ~= mixin(interp!"        return ${retType}();${newline}");
        }
        funcStr ~= "    } catch (Exception __ex__) {" ~ newline;
        funcStr ~= mixin(interp!"        return ${retType}(__ex__);${newline}");
        funcStr ~= "    }" ~ newline;
        funcStr ~= "}" ~ newline;

        ret ~= funcStr;
    }

    return ret;
}

private string generateSliceMethods(T)() {
    import autowrap.csharp.common : getDLangSliceInterfaceName;
    import std.traits : fullyQualifiedName;
    string ret = string.init;
    alias fqn = getDLangInterfaceType!T;

    //Generate slice creation method
    ret ~= mixin(interp!"extern(C) export returnValue!(${fqn}[]) ${getDLangSliceInterfaceName(fqn, \"Create\")}(size_t capacity) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        ${fqn}[] __temp__;${newline}        __temp__.reserve(capacity);${newline}        pinPointer(cast(void*)__temp__.ptr);${newline}        return returnValue!(${fqn}[])(__temp__);"), mixin(interp!"returnValue!(${fqn}[])"));
    ret ~= "}" ~ newline;

    //Generate slice method
    ret ~= mixin(interp!"extern(C) export returnValue!(${fqn}[]) ${getDLangSliceInterfaceName(fqn, \"Slice\")}(${fqn}[] slice, size_t begin, size_t end) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        ${fqn}[] __temp__ = slice[begin..end];${newline}        pinPointer(cast(void*)__temp__.ptr);${newline}        return returnValue!(${fqn}[])(__temp__);"), mixin(interp!"returnValue!(${fqn}[])"));
    ret ~= "}" ~ newline;

    //Generate get method
    ret ~= mixin(interp!"extern(C) export returnValue!(${fqn}) ${getDLangSliceInterfaceName(fqn, \"Get\")}(${fqn}[] slice, size_t index) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        return returnValue!(${fqn})(slice[index]);"), mixin(interp!"returnValue!(${fqn})"));
    ret ~= "}" ~ newline;

    //Generate set method
    ret ~= mixin(interp!"extern(C) export returnVoid ${getDLangSliceInterfaceName(fqn, \"Set\")}(${fqn}[] slice, size_t index, ${fqn} set) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        slice[index] = set;${newline}        return returnVoid();"), "returnVoid");
    ret ~= "}" ~ newline;

    //Generate item append method
    ret ~= mixin(interp!"extern(C) export returnValue!(${fqn}[]) ${getDLangSliceInterfaceName(fqn, \"AppendValue\")}(${fqn}[] slice, ${fqn} append) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        return returnValue!(${fqn}[])(slice ~= append);"), mixin(interp!"returnValue!(${fqn}[])"));
    ret ~= "}" ~ newline;

    //Generate slice append method
    ret ~= mixin(interp!"extern(C) export returnValue!(${fqn}[]) ${getDLangSliceInterfaceName(fqn, \"AppendSlice\")}(${fqn}[] slice, ${fqn}[] append) nothrow {${newline}");
    ret ~= generateMethodErrorHandling(mixin(interp!"        return returnValue!(${fqn}[])(slice ~= append);"), mixin(interp!"returnValue!(${fqn}[])"));
    ret ~= "}" ~ newline;

    return ret;
}

private string generateMethodErrorHandling(string insideCode, string returnType) {
    string ret = string.init;
    ret ~= "    try {" ~ newline;
    ret ~= methodSetup ~ newline;
    ret ~= insideCode ~ newline;
    ret ~= "    } catch (Exception __ex__) {" ~ newline;
    ret ~= mixin(interp!"        return ${returnType}(__ex__);${newline}");
    ret ~= "    }" ~ newline;
    return ret;
}

private string generateParameter(T)(string name) {
    import autowrap.csharp.common : isDateTimeType, isDateTimeArrayType;
    import std.datetime : DateTime, Date, TimeOfDay, SysTime, Duration;
    import std.traits : fullyQualifiedName;

    alias fqn = fullyQualifiedName!(PrimordialType!T);
    static if (isDateTimeType!T) {
        return mixin(interp!"fromDatetime!(${fqn})(${name})");
    } else static if (isDateTimeArrayType!T) {
        return mixin(interp!"fromDatetime1DArray!(${fqn})(${name})");
    } else {
        return name;
    }
}

private string generateReturn(T)(string name) {
    import autowrap.csharp.common : isDateTimeType, isDateTimeArrayType;
    import std.datetime : DateTime, Date, TimeOfDay, SysTime, Duration;
    import std.traits : fullyQualifiedName;

    alias fqn = fullyQualifiedName!(PrimordialType!T);
    static if (isDateTimeType!T) {
        return mixin(interp!"toDatetime!(${fqn})(${name})");
    } else static if (isDateTimeArrayType!T) {
        return mixin(interp!"toDatetime1DArray!(${fqn})(${name})");
    } else {
        return name;
    }
}
