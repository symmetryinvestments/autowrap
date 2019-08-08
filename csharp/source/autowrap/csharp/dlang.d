module autowrap.csharp.dlang;

import scriptlike : interp, _interp_text;

import core.time : Duration;
import std.datetime : Date, DateTime, SysTime, TimeOfDay, TimeZone;
import std.ascii : newline;
import std.meta : allSatisfy;
import std.range.primitives;

import autowrap.csharp.boilerplate;
import autowrap.reflection : isModule, PrimordialType;

enum string methodSetup = "        thread_attachThis();
        rt_moduleTlsCtor();
        scope(exit) rt_moduleTlsDtor();
        scope(exit) thread_detachThis();";


// Wrap global functions from multiple modules
public string wrapDLang(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : isDateTimeType;
    import autowrap.reflection : AllAggregates;

    import std.algorithm.iteration : map;
    import std.algorithm.sorting : sort;
    import std.array : array;
    import std.format : format;
    import std.meta : AliasSeq;
    import std.traits : fullyQualifiedName;

    string ret;
    string[] imports = [Modules].map!(a => a.name)().array();

    static foreach(T; AliasSeq!(string, wstring, dstring, bool, byte, ubyte, short, ushort, int, uint, long, ulong, float, double, datetime)) {
        ret ~= generateSliceMethods!T(imports);
    }

    static foreach(Agg; AllAggregates!Modules)
    {
        static if(verifySupported!Agg && !isDateTimeType!Agg)
        {
            ret ~= generateSliceMethods!Agg(imports);
            ret ~= generateConstructors!Agg(imports);
            ret ~= generateMethods!Agg(imports);
            ret ~= generateFields!Agg(imports);
        }
    }

    ret ~= generateFunctions!Modules(imports);

    string top = "import core.thread : thread_attachThis, thread_detachThis;" ~ newline;
    top ~= "extern(C) void rt_moduleTlsCtor();" ~ newline;
    top ~= "extern(C) void rt_moduleTlsDtor();" ~ newline;

    foreach(i; sort(imports))
        top ~= format("import %s;%s", i, newline);

    return top ~ "\n" ~ ret;
}

// This is to deal with the cases where the parameter name is the same as a
// module or pacakage name, which results in errors if the full path name is
// used inside the function (e.g. in the return type is prefix.Prefix, and the
// parameter is named prefix).
private enum AdjParamName(string paramName) = paramName ~ "_param";

private string generateConstructors(T)(ref string[] imports) {
    import autowrap.csharp.common : getDLangInterfaceName, getDLangInterfaceType;

    import std.algorithm.comparison : among;
    import std.meta : Filter, staticMap;
    import std.traits : fullyQualifiedName, hasMember, Parameters, ParameterIdentifierTuple;

    string ret;
    alias fqn = getDLangInterfaceType!T;

    //Generate constructor methods
    static if(hasMember!(T, "__ctor") && __traits(getProtection, __traits(getMember, T, "__ctor")).among("export", "public")) {
        foreach(c; __traits(getOverloads, T, "__ctor")) {
            if (__traits(getProtection, c).among("export", "public")) {
                alias paramNames = staticMap!(AdjParamName, ParameterIdentifierTuple!c);
                alias ParamTypes = Parameters!c;

                static if(Filter!(verifySupported, ParamTypes).length != ParamTypes.length)
                    continue;
                addImports!ParamTypes(imports);

                string exp = "extern(C) export ";
                const string interfaceName = getDLangInterfaceName(fqn, "__ctor");

                exp ~= mixin(interp!"returnValue!(${fqn}) ${interfaceName}(");

                static foreach(pc; 0..paramNames.length) {
                    exp ~= mixin(interp!"${getDLangInterfaceType!(ParamTypes[pc])} ${paramNames[pc]}, ");
                }
                if (ParamTypes.length > 0) {
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
                    if (ParamTypes.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                    exp ~= "        pinPointer(cast(void*)__temp__);" ~ newline;
                    exp ~= mixin(interp!"        return returnValue!(${fqn})(__temp__);${newline}");
                } else if (is(T == struct)) {
                    exp ~= mixin(interp!"        return returnValue!(${fqn})(${fqn}(");
                    foreach(pn; paramNames) {
                        exp ~= mixin(interp!"${pn}, ");
                    }
                    if (ParamTypes.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= "));" ~ newline;
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

private string generateMethods(T)(ref string[] imports) {
    import autowrap.csharp.common : isDateTimeType, isDateTimeArrayType, getDLangInterfaceName, getDLangInterfaceType;

    import std.algorithm.comparison : among;
    import std.meta : AliasSeq, Filter, staticMap;
    import std.traits : isFunction, fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple;

    string ret;
    alias fqn = getDLangInterfaceType!T;

    foreach(m; __traits(allMembers, T))
    {
        if (m.among("__ctor", "toHash", "opEquals", "opCmp", "factory"))
            continue;

        static if (is(typeof(__traits(getMember, T, m))))
        {
            foreach(oc, mo; __traits(getOverloads, T, m))
            {
                enum isMethod = isFunction!mo;

                static if(isMethod && __traits(getProtection, mo).among("export", "public"))
                {
                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    alias RT = ReturnType!mo;
                    alias returnTypeStr = getDLangInterfaceType!RT;
                    alias ParamTypes = Parameters!mo;
                    alias paramNames = staticMap!(AdjParamName, ParameterIdentifierTuple!mo);
                    alias Types = AliasSeq!(RT, ParamTypes);

                    static if(Filter!(verifySupported, Types).length != Types.length)
                        continue;
                    else
                    {
                        addImports!Types(imports);

                        string exp = "extern(C) export ";
                        static if (!is(RT == void)) {
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
                            exp ~= mixin(interp!"${getDLangInterfaceType!(ParamTypes[pc])} ${paramNames[pc]}, ");
                        }
                        exp = exp[0..$-2];
                        exp ~= ") nothrow {" ~ newline;
                        exp ~= "    try {" ~ newline;
                        exp ~= methodSetup ~ newline;
                        exp ~= "        ";
                        if (!is(RT == void)) {
                            exp ~= "auto __result__ = ";
                        }
                        exp ~= mixin(interp!"__obj__.${m}(");
                        static foreach(pc; 0..paramNames.length) {
                            exp ~= mixin(interp!"${generateParameter!(ParamTypes[pc])(paramNames[pc])}, ");
                        }
                        if (paramNames.length > 0) {
                            exp = exp[0..$-2];
                        }
                        exp ~= ");" ~ newline;
                        static if (isDateTimeType!RT || isDateTimeArrayType!RT) {
                            exp ~= mixin(interp!"        return returnValue!(${returnTypeStr})(${generateReturn!RT(\"__result__\")});${newline}");
                        } else static if (!is(RT == void)) {
                            exp ~= mixin(interp!"        return returnValue!(${returnTypeStr})(__result__);${newline}");
                        } else {
                            exp ~= "        return returnVoid();" ~ newline;
                        }
                        exp ~= "    } catch (Exception __ex__) {" ~ newline;
                        if (!is(RT == void)) {
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
    }

    return ret;
}

private string generateFields(T)(ref string[] imports) {
    import autowrap.csharp.common : getDLangInterfaceName, getDLangInterfaceType;

    import std.traits : fullyQualifiedName, Fields, FieldNameTuple;

    string ret;
    alias fqn = getDLangInterfaceType!T;
    if (is(T == class) || is(T == interface))
    {
        alias FieldTypes = Fields!T;
        alias fieldNames = FieldNameTuple!T;
        static foreach(fc; 0 .. FieldTypes.length)
        {{
            alias fn = fieldNames[fc];
            static if (is(typeof(__traits(getMember, T, fn))))
            {
                alias FT = FieldTypes[fc];
                static if(verifySupported!FT)
                {
                    addImport!FT(imports);

                    ret ~= mixin(interp!"extern(C) export returnValue!(${getDLangInterfaceType!FT}) ${getDLangInterfaceName(fqn, fn ~ \"_get\")}(${fqn} __obj__) nothrow {${newline}");
                    ret ~= generateMethodErrorHandling(mixin(interp!"        auto __value__ = __obj__.${fn};${newline}        return returnValue!(${getDLangInterfaceType!FT})(${generateReturn!FT(\"__value__\")});"), mixin(interp!"returnValue!(${getDLangInterfaceType!FT})"));
                    ret ~= "}" ~ newline;
                    ret ~= mixin(interp!"extern(C) export returnVoid ${getDLangInterfaceName(fqn, fn ~ \"_set\")}(${fqn} __obj__, ${getDLangInterfaceType!FT} value) nothrow {${newline}");
                    ret ~= generateMethodErrorHandling(mixin(interp!"        __obj__.${fn} = ${generateParameter!FT(\"value\")};${newline}        return returnVoid();"), "returnVoid");
                    ret ~= "}" ~ newline;
                }
            }
        }}
    }
    return ret;
}

private string generateFunctions(Modules...)(ref string[] imports) if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : getDLangInterfaceName, getDLangInterfaceType;
    import autowrap.reflection: AllFunctions;

    import std.meta : AliasSeq, Filter, staticMap;
    import std.traits : fullyQualifiedName, hasMember, functionAttributes, FunctionAttribute,
                        ReturnType, Parameters, ParameterIdentifierTuple;

    string ret;

    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;

        alias RT = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = getDLangInterfaceType!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias ParamTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = staticMap!(AdjParamName, ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name)));
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        alias Types = AliasSeq!(RT, ParamTypes);

        static if(Filter!(verifySupported, Types).length != Types.length)
            continue;
        else
        {
            addImports!Types(imports);

            string retType;
            string funcStr = "extern(C) export ";

            static if (!is(RT == void)) {
                retType ~= mixin(interp!"returnValue!(${returnTypeStr})");
            } else {
                retType ~= "returnVoid";
            }

            funcStr ~= mixin(interp!"${retType} ${interfaceName}(");
            static foreach(pc; 0..paramNames.length) {
                funcStr ~= mixin(interp!"${getDLangInterfaceType!(ParamTypes[pc])} ${paramNames[pc]}, ");
            }
            if(paramNames.length > 0) {
                funcStr = funcStr[0..$-2];
            }
            funcStr ~= ") nothrow {" ~ newline;
            funcStr ~= "    try {" ~ newline;
            funcStr ~= methodSetup ~ newline;
            funcStr ~= "        ";
            if (!is(RT == void)) {
                funcStr ~= mixin(interp!"auto __return__ = ${func.name}(");
            } else {
                funcStr ~= mixin(interp!"${func.name}(");
            }
            static foreach(pc; 0..paramNames.length) {
                funcStr ~= mixin(interp!"${generateParameter!(ParamTypes[pc])(paramNames[pc])}, ");
            }
            if(paramNames.length > 0) {
                funcStr = funcStr[0..$-2];
            }
            funcStr ~= ");" ~ newline;
            if (!is(RT == void)) {
                funcStr ~= mixin(interp!"        return ${retType}(${generateReturn!RT(\"__return__\")});${newline}");
            } else {
                funcStr ~= mixin(interp!"        return ${retType}();${newline}");
            }
            funcStr ~= "    } catch (Exception __ex__) {" ~ newline;
            funcStr ~= mixin(interp!"        return ${retType}(__ex__);${newline}");
            funcStr ~= "    }" ~ newline;
            funcStr ~= "}" ~ newline;

            ret ~= funcStr;
        }
    }

    return ret;
}

private string generateSliceMethods(T)(ref string[] imports) {
    import autowrap.csharp.common : getDLangSliceInterfaceName, getDLangInterfaceType;

    import std.traits : fullyQualifiedName, moduleName,  TemplateOf;

    addImport!T(imports);

    alias fqn = getDLangInterfaceType!T;

    //Generate slice creation method
    string ret = mixin(interp!"extern(C) export returnValue!(${fqn}[]) ${getDLangSliceInterfaceName(fqn, \"Create\")}(size_t capacity) nothrow {${newline}");
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
    string ret = "    try {" ~ newline;
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

private void addImports(T...)(ref string[] imports)
{
    foreach(U; T)
        addImport!U(imports);
}

private void addImport(T)(ref string[] imports)
{
    import std.algorithm.searching : canFind;
    import std.traits : isBuiltinType, isDynamicArray, moduleName;

    static assert(isSupportedType!T, "missing check for supported type");

    static if(isDynamicArray!T)
        addImport!(ElementType!T)(imports);
    else static if(!isBuiltinType!T)
    {
        enum mod = moduleName!T;
        if(!mod.empty && !imports.canFind(mod))
            imports ~= mod;
    }
}

private template verifySupported(T)
{
    static if(isSupportedType!T)
        enum verifySupported = true;
    else
    {
        pragma(msg, T.stringof ~ " is not currently supported by autowrap's C#");
        enum verifySupported = false;
    }
}

private template isSupportedType(T)
{
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

// Unfortunately, these aren't actually tested yet, because dub test doesn't work
// for the csharp folder, and the top level one does not run them.
unittest
{
    import std.meta : AiasSeq;
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
                         Tuple!int, Tuple(string, string)))
    {
        static assert(isSupportedType!T, T.stringof);
    }
}
