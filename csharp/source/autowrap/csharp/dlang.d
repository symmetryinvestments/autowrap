module autowrap.csharp.dlang;

import autowrap.csharp.common : camelToPascalCase, getDLangSliceInterfaceName, getDLangInterfaceName;
import autowrap.reflection : AllFunctions, AllAggregates, isModule;

import std.ascii : newline;
import std.traits : isArray, fullyQualifiedName, moduleName, isFunction, Fields, FieldNameTuple, hasMember, functionAttributes, FunctionAttribute, ReturnType, Parameters, ParameterIdentifierTuple;
import std.meta : allSatisfy, AliasSeq;

// Wrap global functions from multiple modules
public string wrapDLang(Modules...)() if(allSatisfy!(isModule, Modules)) {
    string ret = string.init;

    foreach(mod; Modules) {
        ret ~= "import " ~ mod.name ~ ";" ~ newline;
    }
    ret ~= newline;

    ret ~= generateSliceMethods!string();
    ret ~= generateSliceMethods!wstring();
    ret ~= generateSliceMethods!dstring();

    ret ~= generateSliceMethods!bool();
    ret ~= generateSliceMethods!byte();
    ret ~= generateSliceMethods!ubyte();
    ret ~= generateSliceMethods!short();
    ret ~= generateSliceMethods!ushort();
    ret ~= generateSliceMethods!int();
    ret ~= generateSliceMethods!uint();
    ret ~= generateSliceMethods!long();
    ret ~= generateSliceMethods!ulong();
    ret ~= generateSliceMethods!float();
    ret ~= generateSliceMethods!double();

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
        enum isNothrow = functionAttributes!c & FunctionAttribute.nothrow_;
        const string interfaceName = getDLangInterfaceName(fqn, "__ctor");

        if (!isNothrow) {
            exp ~= "returnValue!(" ~ fqn ~ ")";
        } else {
            exp ~= fqn;
        }
        exp ~= " " ~ interfaceName ~ "(";

        static foreach(pc; 0..paramNames.length) {
            exp ~= fullyQualifiedName!(paramTypes[pc]) ~ " " ~ paramNames[pc] ~ ", ";
        }
        if (paramTypes.length > 0) {
            exp = exp[0..$-2];
        }
        exp ~= ") nothrow {" ~ newline;
        if (!isNothrow) {
            exp ~= "    try {" ~ newline;
        }
        if (is(T == class)) {
            exp ~= "        import std.stdio : writeln;" ~ newline;
            exp ~= "        " ~ fqn ~ " __temp__ = new " ~ fqn ~ "(";
            static foreach(pc; 0..paramNames.length) {
                exp ~= paramNames[pc] ~ ", ";
            }
            if (paramTypes.length > 0) {
                exp = exp[0..$-2];
            }
            exp ~= ");" ~ newline;
            exp ~= "        pinPointer(cast(void*)__temp__);" ~ newline;
            if (!isNothrow) {
                exp ~= "        return returnValue!(" ~ fqn ~ ")(__temp__);" ~ newline;
            } else {
                exp ~= "        return __temp__;" ~ newline;
            }
        } else if (is(T == struct)) {
            exp ~= "        return " ~ fqn ~ "(";
            foreach(pn; paramNames) {
                exp ~= pn ~ ", ";
            }
            if (paramTypes.length > 0) {
                exp = exp[0..$-2];
            }
            exp ~= ");" ~ newline;
        }
        if (!isNothrow) {
            exp ~= "    } catch (Exception __ex__) {" ~ newline;
            exp ~= "        return returnValue!(" ~ fqn ~ ")(__ex__);" ~ newline;
            exp ~= "    }" ~ newline;
        }
        exp ~= "}" ~ newline;
        ret ~= exp;
    }

    return ret;
}

private string generateMethods(T)() {
    string ret = string.init;
    alias fqn = fullyQualifiedName!T;
    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }

        static if (is(typeof(__traits(getMember, T, m)))) {
            foreach(mo; __traits(getOverloads, T, m)) {
                const bool isMethod = isFunction!mo;

                static if(isMethod) {
                    string exp = string.init;
                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    enum isNothrow = functionAttributes!mo & FunctionAttribute.nothrow_;
                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = fullyQualifiedName!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;

                    exp ~= "extern(C) export ";
                    if (!isNothrow) {
                        if (!is(returnType == void)) {
                            exp ~= "returnValue!(" ~ returnTypeStr ~ ")";
                        } else {
                            exp ~= "returnVoid";
                        }
                    } else {
                        exp ~= returnTypeStr;
                    }
                    exp ~= " " ~ interfaceName ~ "(";
                    if (is(T == struct)) {
                        exp ~= fqn ~ "* __obj__, ";
                    } else if (is(T == class) || is(T == interface)) {
                        exp ~= "void* __obj__, ";
                    }
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= fullyQualifiedName!(paramTypes[pc]) ~ " " ~ paramNames[pc] ~ ", ";
                    }
                    exp = exp[0..$-2];
                    exp ~= ") nothrow {" ~ newline;
                    if (!isNothrow) {
                        exp ~= "    try {" ~ newline;
                    }
                    if (is(T == struct)) {
                        if (!is(returnType == void)) {
                            exp ~= "        auto __result__ = ";
                        } else {
                            exp ~= "        ";
                        }
                        exp ~= "(*__obj__)." ~ m ~ "(";
                    } else if (is(T == class) || is(T == interface)) {
                        exp ~= "        " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
                        if (!is(returnType == void)) {
                            exp ~= "        auto __result__ = ";
                        } else {
                            exp ~= "        ";
                        }
                        exp ~= "__temp__." ~ m ~ "(";
                    }
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= paramNames[pc] ~ ", ";
                    }
                    if (paramNames.length > 0) {
                        exp = exp[0..$-2];
                    }
                    exp ~= ");" ~ newline;
                    if (!is(returnType == void)) {
                        exp ~= "        return returnValue!(" ~ returnTypeStr ~ ")(__result__);" ~ newline;
                    } else {
                        exp ~= "        return returnVoid();" ~ newline;
                    }
                    if (!isNothrow) {
                        exp ~= "    } catch (Exception __ex__) {" ~ newline;
                        if (!is(returnType == void)) {
                            exp ~= "        return returnValue!(" ~ returnTypeStr ~ ")(__ex__);" ~ newline;
                        } else {
                            exp ~= "        return returnVoid(__ex__);" ~ newline;
                        }
                        exp ~= "    }" ~ newline;
                    }
                    exp ~= "}" ~ newline;
                    ret ~= exp;
                } else {
                }
            }
        }
    }

    return ret;
}

private string generateFields(T)() {
    string ret = string.init;
    alias fqn = fullyQualifiedName!T;
    if (is(T == class) || is(T == interface)) {
        alias fieldTypes = Fields!T;
        alias fieldNames = FieldNameTuple!T;
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                ret ~= "extern(C) export " ~ fullyQualifiedName!(fieldTypes[fc]) ~ " " ~ getDLangInterfaceName(fqn, fieldNames[fc] ~ "_get") ~ "(void* __obj__) nothrow {" ~ newline;
                ret ~= "    " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
                ret ~= "    return __temp__." ~ fieldNames[fc] ~ ";" ~ newline;
                ret ~= "}" ~ newline;
                ret ~= "extern(C) export void " ~ getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set") ~ "(void* __obj__, " ~ fullyQualifiedName!(fieldTypes[fc]) ~ " value) nothrow {" ~ newline;
                ret ~= "    " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
                ret ~= "    __temp__." ~ fieldNames[fc] ~ " = value;" ~ newline;
                ret ~= "}" ~ newline;
            }
        }
    }
    return ret;
}

private string generateFunctions(Modules...)() if(allSatisfy!(isModule, Modules)) {
    string ret = string.init;
    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        enum isNothrow = functionAttributes!(__traits(getMember, func.module_, func.name)) & FunctionAttribute.nothrow_;
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        string retType = string.init;
        string funcStr = "extern(C) export ";

        if (!isNothrow) {
            if (!is(returnType == void)) {
                retType = retType ~ "returnValue!(" ~ returnTypeStr ~ ")";
            } else {
                retType = retType ~ "returnVoid";
            }
        } else {
            retType = returnTypeStr;
        }

        funcStr ~= retType ~ " " ~ interfaceName ~ "(";
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= fullyQualifiedName!(paramTypes[pc]) ~ " " ~ paramNames[pc] ~ ", ";
        }
        funcStr = funcStr[0..$-2];
        funcStr ~= ") nothrow {" ~ newline;
        if (!isNothrow) {
            funcStr ~= "    try {" ~ newline;
            if (!is(returnType == void)) {
                funcStr ~= "        return " ~ retType ~ "(" ~ func.name ~ "(";
                foreach(pName; paramNames) {
                    funcStr ~= pName ~ ", ";
                }
                funcStr = funcStr[0..$-2];
                funcStr ~= "));" ~ newline;
            } else {
                funcStr ~= func.name ~ "(";
                static foreach(pc; 0..paramNames.length) {
                    funcStr ~= paramNames[pc] ~ ", ";
                }
                funcStr = funcStr[0..$-2];
                funcStr ~= ");" ~ newline;
                funcStr ~= "        return returnVoid();" ~ newline;
            }
            funcStr ~= "    } catch (Exception __ex__) {" ~ newline;
            funcStr ~= "        return " ~ retType ~ "(__ex__);" ~ newline;
            funcStr ~= "    }" ~ newline;
        } else {
            funcStr ~= "    " ~ retType ~ " __temp__ = " ~ func.name ~ "(";
            static foreach(pc; 0..paramNames.length) {
                funcStr ~= paramNames[pc] ~ ", ";
            }
            funcStr = funcStr[0..$-2];
            funcStr ~= ");" ~ newline;
            if (isArray!(returnType)) {
                funcStr ~= "    pinPointer(cast(void*)__temp__.ptr);" ~ newline;
            }
            else if (is(returnType == class) || is(returnType == interface)) {
                funcStr ~= "    pinPointer(cast(void*)__temp__);" ~ newline;
            }
            funcStr ~= "    return __temp__;" ~ newline;
        }
        funcStr ~= "}" ~ newline;

        ret ~= funcStr;
    }

    return ret;
}

private string generateSliceMethods(T)() {
    string ret = string.init;
    alias fqn = fullyQualifiedName!T;

    //Generate slice creation method
    ret ~= "extern(C) export " ~ fqn ~ "[] " ~ getDLangSliceInterfaceName(fqn, "Create") ~ "(size_t capacity) nothrow {" ~ newline;
    ret ~= "    " ~ fqn ~ "[] __temp__;" ~ newline;
    ret ~= "    __temp__.reserve(capacity);" ~ newline;
    ret ~= "    pinPointer(cast(void*)__temp__.ptr);" ~ newline;
    ret ~= "    return (__temp__);" ~ newline;
    ret ~= "}" ~ newline;

    //Generate slice method
    ret ~= "extern(C) export " ~ fqn ~ "[] " ~ getDLangSliceInterfaceName(fqn, "Slice") ~ "(" ~ fqn ~ "[] slice, size_t begin, size_t end) nothrow {" ~ newline;
    ret ~= "    " ~ fqn ~ "[] __temp__ = slice[begin..end];" ~ newline;
    ret ~= "    pinPointer(cast(void*)__temp__.ptr);" ~ newline;
    ret ~= "    return __temp__;" ~ newline;
    ret ~= "}" ~ newline;

    //Generate get method
    ret ~= "extern(C) export " ~ fqn ~ " " ~ getDLangSliceInterfaceName(fqn, "Get") ~ "(" ~ fqn ~ "[] slice, size_t index) nothrow {" ~ newline;
    ret ~= "    return slice[index];" ~ newline;
    ret ~= "}" ~ newline;

    //Generate set method
    if (is(T == class)) {
        ret ~= "extern(C) export void " ~ getDLangSliceInterfaceName(fqn, "Set") ~ "(" ~ fqn ~ "[] slice, size_t index, void* set) nothrow {" ~ newline;
        ret ~= "    slice[index] = cast(" ~ fqn ~ ")set;" ~ newline;
    } else {
        ret ~= "extern(C) export void " ~ getDLangSliceInterfaceName(fqn, "Set") ~ "(" ~ fqn ~ "[] slice, size_t index, " ~ fqn ~ " set) nothrow {" ~ newline;
        ret ~= "    slice[index] = set;" ~ newline;
    }
    ret ~= "}" ~ newline;

    //Generate item append method
    if (is(T == class)) {
        ret ~= "extern(C) export " ~ fqn ~ "[] " ~ getDLangSliceInterfaceName(fqn, "AppendValue") ~ "(" ~ fqn ~ "[] slice, void* append) nothrow {" ~ newline;
        ret ~= "    return (slice ~= cast(" ~ fqn ~ ")append);" ~ newline;
    } else {
        ret ~= "extern(C) export " ~ fqn ~ "[] " ~ getDLangSliceInterfaceName(fqn, "AppendValue") ~ "(" ~ fqn ~ "[] slice, " ~ fqn ~ " append) nothrow {" ~ newline;
        ret ~= "    return (slice ~= append);" ~ newline;
    }
    ret ~= "}" ~ newline;

    //Generate slice append method
    ret ~= "extern(C) export " ~ fqn ~ "[] " ~ getDLangSliceInterfaceName(fqn, "AppendSlice") ~ "(" ~ fqn ~ "[] slice, " ~ fqn ~ "[] append) nothrow {" ~ newline;
    ret ~= "    return (slice ~= append);" ~ newline;
    ret ~= "}" ~ newline;

    return ret;
}
