module autowrap.csharp.dlang;

import scriptlike : interp, interp_text;

import autowrap.reflection : isModule;
import std.ascii : newline;
import std.meta : allSatisfy;

enum string methodSetup = "        thread_attachThis();
        rt_moduleTlsCtor();
        scope(exit) rt_moduleTlsDtor();
        scope(exit) thread_detachThis();";

// Wrap global functions from multiple modules
public string wrapDLang(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : getDLangInterfaceName;
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

    static foreach(t; AliasSeq!(string, wstring, dstring, bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double)) {
        ret ~= generateSliceMethods!t();
    }

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        alias fqn = fullyQualifiedName!agg;

        ret ~= generateSliceMethods!agg();

        ret ~= generateConstructors!agg();

        ret ~= generateMethods!agg();

        ret ~= generateFields!agg();
    }

    ret ~= generateFunctions!Modules();

    return ret;
}

private string generateConstructors(T)() {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : fullyQualifiedName, hasMember, Parameters, ParameterIdentifierTuple;
    import std.meta : AliasSeq;

    string ret = string.init;
    alias fqn = fullyQualifiedName!T;
    static if(hasMember!(T, "__ctor")) {
        alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
    } else {
        alias constructors = AliasSeq!();
    }

    //Generate constructor methods
    foreach(c; constructors) {
        alias paramNames = ParameterIdentifierTuple!c;
        alias paramTypes = Parameters!c;
        string exp = "extern(C) export ";
        const string interfaceName = getDLangInterfaceName(fqn, "__ctor");

        exp ~= mixin(interp!"returnValue!(${fqn})");
        exp ~= mixin(interp!" ${interfaceName}(");

        static foreach(pc; 0..paramNames.length) {
            exp ~= mixin(interp!"${fullyQualifiedName!(paramTypes[pc])} ${paramNames[pc]}, ");
        }
        if (paramTypes.length > 0) {
            exp = exp[0..$-2];
        }
        exp ~= ") nothrow {" ~ newline;
        exp ~= "    try {" ~ newline;
        exp ~= methodSetup ~ newline;
        if (is(T == class)) {
            exp ~= "        import std.stdio : writeln;" ~ newline;
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

    return ret;
}

private string generateMethods(T)() {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : isFunction, fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple;
    import std.conv : to;

    string ret = string.init;
    alias fqn = fullyQualifiedName!T;
    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }

        static if (is(typeof(__traits(getMember, T, m)))) {
            foreach(oc, mo; __traits(getOverloads, T, m)) {
                const bool isMethod = isFunction!mo;

                static if(isMethod) {
                    string exp = string.init;
                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = fullyQualifiedName!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;

                    exp ~= "extern(C) export ";
                    if (!is(returnType == void)) {
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
                        exp ~= mixin(interp!"${fullyQualifiedName!(paramTypes[pc])} ${paramNames[pc]}, ");
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
                        exp ~= mixin(interp!"${paramNames[pc]}, ");
                    }
                    if (paramNames.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                    if (!is(returnType == void)) {
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
    alias fqn = fullyQualifiedName!T;
    if (is(T == class) || is(T == interface)) {
        alias fieldTypes = Fields!T;
        alias fieldNames = FieldNameTuple!T;
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                ret ~= mixin(interp!"extern(C) export returnValue!(${fullyQualifiedName!(fieldTypes[fc])}) ${getDLangInterfaceName(fqn, fieldNames[fc] ~ \"_get\")}(${fqn} __obj__) nothrow {${newline}");
                ret ~= generateMethodErrorHandling(mixin(interp!"        return returnValue!(${fullyQualifiedName!(fieldTypes[fc])})(__obj__.${fieldNames[fc]});"), mixin(interp!"returnValue!(${fullyQualifiedName!(fieldTypes[fc])})"));
                ret ~= "}" ~ newline;
                ret ~= mixin(interp!"extern(C) export returnVoid ${getDLangInterfaceName(fqn, fieldNames[fc] ~ \"_set\")}(${fqn} __obj__, ${fullyQualifiedName!(fieldTypes[fc])} value) nothrow {${newline}");
                ret ~= generateMethodErrorHandling(mixin(interp!"        __obj__.${fieldNames[fc]} = value;${newline}        return returnVoid();"), "returnVoid");
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
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        string retType = string.init;
        string funcStr = "extern(C) export ";

        if (!is(returnType == void)) {
            retType ~= mixin(interp!"returnValue!(${returnTypeStr})");
        } else {
            retType ~= "returnVoid";
        }

        funcStr ~= mixin(interp!"${retType} ${interfaceName}(");
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= mixin(interp!"${fullyQualifiedName!(paramTypes[pc])} ${paramNames[pc]}, ");
        }
        if(paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ") nothrow {" ~ newline;
        funcStr ~= "    try {" ~ newline;
        funcStr ~= methodSetup ~ newline;
        if (!is(returnType == void)) {
            funcStr ~= mixin(interp!"        return ${retType}(${func.name}(");
            foreach(pName; paramNames) {
                funcStr ~= mixin(interp!"${pName}, ");
            }
            if(paramNames.length > 0) {
                funcStr = funcStr[0..$-2];
            }
            funcStr ~= "));" ~ newline;
        } else {
            funcStr ~= mixin(interp!"${func.name}(");
            static foreach(pc; 0..paramNames.length) {
                funcStr ~= mixin(interp!"${paramNames[pc]}, ");
            }
            if(paramNames.length > 0) {
                funcStr = funcStr[0..$-2];
            }
            funcStr ~= ");" ~ newline;
            funcStr ~= "        return returnVoid();" ~ newline;
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
    alias fqn = fullyQualifiedName!T;

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
