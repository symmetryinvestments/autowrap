module autowrap.csharp.dlang;

import autowrap.csharp.boilerplate;
import autowrap.csharp.common;
import autowrap.reflection;

import std.ascii;
import std.conv;
import std.traits;
import std.typecons;
import std.string;

///  Wrap global functions from multiple modules
public string wrapDLang(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string ret = string.init;

    foreach(mod; Modules) {
        ret ~= "import " ~ mod.name ~ ";" ~ newline;
    }
    ret ~= newline;

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        alias fqn = fullyQualifiedName!agg;

        static if(hasMember!(agg, "__ctor")) {
            alias constructors = AliasSeq!(__traits(getOverloads, agg, "__ctor"));
        } else {
            alias constructors = AliasSeq!();
        }

        //Generate constructor methods
        foreach(c; constructors) {
            alias paramNames = ParameterIdentifierTuple!c;
            alias paramTypes = Parameters!c;
            string exp = "extern(C) export ";
            enum isNothrow = functionAttributes!c & FunctionAttribute.nothrow_;
            const string interfaceName = getDlangInterfaceName(fqn, "__ctor");

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
            if (is(agg == class)) {
                exp ~= "        " ~ fqn ~ " __temp__ = new " ~ fqn ~ "(";
                foreach(pn; paramNames) {
                    exp ~= pn ~ ", ";
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
            } else if (is(agg == struct)) {
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

        //Generate range creation method
        ret ~= "extern(C) export returnValue!(" ~ fqn ~ "[]) " ~ getDlangInterfaceName(fqn, "CreateSlice") ~ "(ulong capacity) nothrow {" ~ newline;
        ret ~= "    try {" ~ newline;
        ret ~= "        " ~ fqn ~ "[] __temp__ = new " ~ fqn ~ "[capacity];" ~ newline;
        ret ~= "        pinPointer(cast(void*)__temp__.ptr);" ~ newline;
        ret ~= "        return returnValue!(" ~ fqn ~ "[])(__temp__);" ~ newline;
        ret ~= "    } catch (Exception __ex__) {" ~ newline;
        ret ~= "        return returnValue!(" ~ fqn ~ "[])(__ex__);" ~ newline;
        ret ~= "    }" ~ newline;
        ret ~= "}" ~ newline;

        //Generate range append method
        if (is(agg == class)) {
            ret ~= "extern(C) export returnValue!(" ~ fqn ~ "[]) " ~ getDlangInterfaceName(fqn, "AppendSlice") ~ "(" ~ fqn ~ "[] slice, void* append) nothrow {" ~ newline;
            ret ~= "    try {" ~ newline;
            ret ~= "        slice ~= cast(" ~ fqn ~ ")append;" ~ newline;
        } else if (is(agg == struct)) {
            ret ~= "extern(C) export returnValue!(" ~ fqn ~ "[]) " ~ getDlangInterfaceName(fqn, "AppendSlice") ~ "(" ~ fqn ~ "[] slice, " ~ fqn ~ " append) nothrow {" ~ newline;
            ret ~= "    try {" ~ newline;
            ret ~= "        slice ~= append;" ~ newline;
        }
        ret ~= "        return returnValue!(" ~ fqn ~ "[])(slice);" ~ newline;
        ret ~= "    } catch (Exception __ex__) {" ~ newline;
        ret ~= "        return returnValue!(" ~ fqn ~ "[])(__ex__);" ~ newline ;
        ret ~= "    }" ~ newline;
        ret ~= "}" ~ newline;

        foreach(m; __traits(allMembers, agg)) {
            if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
                continue;
            }

            static if (is(typeof(__traits(getMember, agg, m)))) {
            foreach(mo; __traits(getOverloads, agg, m)) {
                const bool isMethod = isFunction!mo;

                static if(isMethod) {
                    string exp = string.init;
                    const string interfaceName = getDlangInterfaceName(fqn, m);

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
                    if (is(agg == struct)) {
                        exp ~= fqn ~ "* __obj__, ";
                    } else if (is(agg == class) || is(agg == interface)) {
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
                    if (is(agg == struct)) {
                        if (!is(returnType == void)) {
                            exp ~= "        auto __result__ = ";
                        } else {
                            exp ~= "        ";
                        }
                        exp ~= "(*__obj__)." ~ m ~ "(";
                    } else if (is(agg == class) || is(agg == interface)) {
                        exp ~= "        " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
                        if (!is(returnType == void)) {
                            exp ~= "        auto __result__ = ";
                        } else {
                            exp ~= "        ";
                        }
                        exp ~= "__temp__." ~ m ~ "(";
                    }
                    foreach(pName; paramNames) {
                        exp ~= pName ~ ", ";
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

        if (is(agg == class) || is(agg == interface)) {
        alias fieldTypes = Fields!agg;
        alias fieldNames = FieldNameTuple!agg;
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, agg, fieldNames[fc])))) {
            ret ~= "extern(C) export " ~ fullyQualifiedName!(fieldTypes[fc]) ~ " " ~ getDlangInterfaceName(fqn, fieldNames[fc] ~ "_get") ~ "(void* __obj__) nothrow {" ~ newline;
            ret ~= "    " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
            ret ~= "    return __temp__." ~ fieldNames[fc] ~ ";" ~ newline;
            ret ~= "}" ~ newline;
            ret ~= "extern(C) export void " ~ getDlangInterfaceName(fqn, fieldNames[fc] ~ "_set") ~ "(void* __obj__, " ~ fullyQualifiedName!(fieldTypes[fc]) ~ " value) nothrow {" ~ newline;
            ret ~= "    " ~ fqn ~ " __temp__ = cast(" ~ fqn ~ ")__obj__;" ~ newline;
            ret ~= "    __temp__." ~ fieldNames[fc] ~ " = value;" ~ newline;
            ret ~= "}" ~ newline;
            }
        }
        }
    }

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
        //funcStr ~= "    import " ~ modName ~ " : " ~ func.name ~ ";" ~ newline;
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
                foreach(pName; paramNames) {
                    funcStr ~= pName ~ ", ";
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
            foreach(pName; paramNames) {
                funcStr ~= pName ~ ", ";
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
