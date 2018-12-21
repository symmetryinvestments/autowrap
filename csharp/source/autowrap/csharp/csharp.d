module autowrap.csharp.csharp;

import scriptlike : interp, _interp_text;

import autowrap.csharp.common : LibraryName, RootNamespace;
import autowrap.reflection : isModule;

import std.ascii : newline;
import std.meta: allSatisfy;
import std.string : format;

private string[string] returnTypes;
private CSharpNamespace[string] namespaces;
private csharpRange rangeDef;

enum string voidTypeString = "void";
enum string stringTypeString = "string";
enum string wstringTypeString = "wstring";
enum string dstringTypeString = "dstring";
enum string boolTypeString = "bool";
enum string dateTimeTypeString = "DateTime";
enum string sysTimeTypeString = "SysTime";
enum string uuidTypeString = "UUID";
enum string charTypeString = "char";
enum string wcharTypeString = "wchar";
enum string dcharTypeString = "dchar";
enum string ubyteTypeString = "ubyte";
enum string byteTypeString = "byte";
enum string ushortTypeString = "ushort";
enum string shortTypeString = "short";
enum string uintTypeString = "uint";
enum string intTypeString = "int";
enum string ulongTypeString = "ulong";
enum string longTypeString = "long";
enum string floatTypeString = "float";
enum string doubleTypeString = "double";
enum string sliceTypeString = "slice";

enum string dllImportString = "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]" ~ newline;
enum string externFuncString = "        internal static extern %1$s %2$s(%3$s);" ~ newline;

enum int fileReservationSize = 33_554_432;
enum int aggregateReservationSize = 32_768;

//Class used for language built-in reference semantics.
private final class CSharpNamespace {
    public string namespace;
    public string functions;
    public CSharpAggregate[string] aggregates;

    public this(string ns) {
        namespace = ns;
        functions = string.init;
    }

    public override string toString() {
        string ret;
        foreach(csns; namespaces.byValue()) {
            ret ~= "namespace " ~ csns.namespace ~ " {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Autowrap;

    public static class Functions {
" ~ csns.functions ~ "
    }" ~ newline ~ newline;
            foreach(agg; aggregates.byValue()) {
                ret ~= agg.toString();
            }
            ret ~= "}" ~ newline;
        }
        return cast(immutable)ret;
    }
}

//Class used for language built-in reference semantics.
private final class CSharpAggregate {
    public string name;
    public bool isStruct;
    public string constructors;
    public string functions;
    public string methods;
    public string properties;

    public this (string name, bool isStruct) {
        this.name = name;
        this.isStruct = isStruct;
        this.constructors = string.init;
        this.functions = string.init;
        this.methods = string.init;
        this.properties = string.init;
    }

    public override string toString() {
        import autowrap.csharp.common : camelToPascalCase;

        char[] ret;
        ret.reserve(aggregateReservationSize);
        ret ~= "    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]" ~ newline;
        if (isStruct) {
            ret ~= "    [StructLayout(LayoutKind.Sequential)]" ~ newline;
            ret ~= mixin(interp!"    public struct ${camelToPascalCase(this.name)} {${newline}");
        } else {
            ret ~= mixin(interp!"    public class ${camelToPascalCase(this.name)} : DLangObject {${newline}");
            ret ~= mixin(interp!"        public static implicit operator IntPtr(${camelToPascalCase(this.name)} ret) { return ret.DLangPointer; }${newline}");
            ret ~= mixin(interp!"        public static implicit operator ${camelToPascalCase(this.name)}(IntPtr ret) { return new ${camelToPascalCase(this.name)}(ret); }${newline}");
        }
        if (functions != string.init) ret ~= functions ~ newline;
        if (constructors != string.init) ret ~= constructors ~ newline;
        if (methods != string.init) ret ~= methods ~ newline;
        if (properties != string.init) ret ~= properties;
        ret ~= "    }" ~ newline ~ newline;
        return cast(immutable)ret;
    }
}

public struct csharpRange {
    public string constructors = string.init;
    public string enumerators = string.init;
    public string functions = string.init;
    public string getters = string.init;
    public string setters = string.init; 
    public string appendValues = string.init;
    public string appendArrays = string.init;
    public string sliceEnd = string.init;
    public string sliceRange = string.init;

    public string toString() {
        immutable string boilerplate = import("Ranges.cs");
        return boilerplate.format(functions, constructors, getters, setters, sliceEnd, sliceRange, appendValues, appendArrays, enumerators);
    }
}

public string generateCSharp(Modules...)(LibraryName libraryName, RootNamespace rootNamespace) if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection : AllAggregates;
    import std.traits : moduleName;
    generateSliceBoilerplate(libraryName.value);

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        const string aggName = __traits(identifier, agg);
        CSharpAggregate csagg = getAggregate(getCSharpName(modName), getCSharpName(aggName), !is(agg == class));

        generateRangeDef!agg(libraryName.value);

        generateConstructors!agg(libraryName.value, csagg);

        generateMethods!agg(libraryName.value, csagg);

        generateProperties!agg(libraryName.value, csagg);

        generateFields!agg(libraryName.value, csagg);
    }

    generateFunctions!Modules(libraryName.value);

    char[] ret;
    ret.reserve(fileReservationSize);
    foreach(csns; namespaces.byValue()) {
        ret ~= csns.toString();
    }

    ret ~= newline ~ writeCSharpBoilerplate(libraryName.value, rootNamespace.value);

    return cast(immutable)ret;
}

private void generateConstructors(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == struct)) {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : fullyQualifiedName, hasMember, Parameters, ParameterIdentifierTuple;
    import std.meta: AliasSeq;

    const string aggName = __traits(identifier, T);
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
        const string interfaceName = getDLangInterfaceName(fqn, "__ctor");
        const string methodName = getCSharpMethodInterfaceName(aggName, "__ctor");
        string ctor = dllImportString.format(libraryName, interfaceName);
        ctor ~= mixin(interp!"        private static extern ${getDLangReturnType(aggName, is(T == class))} dlang_${methodName}(");
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == class)) {
                ctor ~= mixin(interp!"IntPtr ${paramNames[pc]}, ");
            } else {
                ctor ~= mixin(interp!"${is(paramTypes[pc] == bool) ? \"[MarshalAs(UnmanagedType.Bool)]\" : string.init}${getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
            }
        }
        if (paramNames.length > 0) {
            ctor = ctor[0..$-2];
        }
        ctor ~= ");" ~ newline;
        ctor ~= mixin(interp!"        public ${getCSharpName(aggName)}(");
        static foreach(pc; 0..paramNames.length) {
            ctor ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
        }
        if (paramNames.length > 0) {
            ctor = ctor[0..$-2];
        }
        if (is(T == class)) {
            ctor ~= mixin(interp!") : base(dlang_${methodName}(");
            static foreach(pc; 0..paramNames.length) {
                static if (is(paramTypes[pc] == string)) {
                    ctor ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
                } else static if (is(paramTypes[pc] == wstring)) {
                    ctor ~= mixin(interp!"SharedFunctions.CreateWString(${paramNames[pc]}), ");
                } else static if (is(paramTypes[pc] == dstring)) {
                    ctor ~= mixin(interp!"SharedFunctions.CreateDString(${paramNames[pc]}), ");
                } else {
                    ctor ~= mixin(interp!"${paramNames[pc]}, ");
                }
            }
            if (paramNames.length > 0) {
                ctor = ctor[0..$-2];
            }
            ctor ~= ")";
        }
        ctor ~= ") { }" ~ newline;
        csagg.constructors ~= ctor;
    }
    if (is(T == class)) {
        csagg.constructors ~= mixin(interp!"        internal ${getCSharpName(aggName)}(IntPtr ptr) : base(ptr) { }${newline}");
    }
}

private void generateMethods(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == interface) || is(T == struct)) {
    import autowrap.csharp.common : camelToPascalCase, getDLangInterfaceName;
    import std.traits : isArray, fullyQualifiedName, isFunction, functionAttributes, FunctionAttribute, ReturnType, Parameters, ParameterIdentifierTuple;
    import std.conv : to;

    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;

    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }
        const string methodName = camelToPascalCase(cast(string)m);
        const string methodInterfaceName = getCSharpMethodInterfaceName(aggName, cast(string)m);

        static if (is(typeof(__traits(getMember, T, m)))) {
            foreach(oc, mo; __traits(getOverloads, T, m)) {
                static if(isFunction!mo) {
                    string exp = string.init;
                    enum bool isProperty = cast(bool)(functionAttributes!mo & FunctionAttribute.property);
                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = fullyQualifiedName!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;
                    const string interfaceName = getDLangInterfaceName(fqn, m) ~ to!string(oc);

                    exp ~= dllImportString.format(libraryName, interfaceName);
                    exp ~= "        private static extern ";
                    if (!is(returnType == void)) {
                        exp ~= getDLangReturnType(returnTypeStr, is(returnType == class));
                    } else {
                        exp ~= "return_void_error";
                    }
                    exp ~= mixin(interp!" dlang_${methodInterfaceName}(");
                    if (is(T == struct)) {
                        exp ~= mixin(interp!"ref ${getDLangInterfaceType(fqn)} __obj__, ");
                    } else if (is(T == class) || is(T == interface)) {
                        exp ~= "IntPtr __obj__, ";
                    }
                    static foreach(pc; 0..paramNames.length) {
                        if (is(paramTypes[pc] == class)) {
                            exp ~= mixin(interp!"IntPtr ${paramNames[pc]}, ");
                        } else {
                            exp ~= mixin(interp!"${getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
                        }
                    }
                    exp = exp[0..$-2];
                    exp ~= ");" ~ newline;
                    if (!isProperty) {
                        exp ~= mixin(interp!"        public ${methodName == \"ToString\" ? \"override \" : string.init}${getCSharpInterfaceType(returnTypeStr)} ${methodName}(");
                        static foreach(pc; 0..paramNames.length) {
                            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                                exp ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
                            } else if (isArray!(paramTypes[pc])) {
                                exp ~= mixin(interp!"Range<${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))}> ${paramNames[pc]}, ");
                            } else {
                                exp ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
                            }
                        }
                        if (paramNames.length > 0) {
                            exp = exp[0..$-2];
                        }
                        exp ~= ") {" ~ newline;
                        exp ~= mixin(interp!"            var dlang_ret = dlang_${methodInterfaceName}(${is(T == struct) ? \"ref \" : string.init}this, ");
                        static foreach(pc; 0..paramNames.length) {
                            static if (is(paramTypes[pc] == string)) {
                                exp ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
                            } else static if (is(paramTypes[pc] == wstring)) {
                                exp ~= mixin(interp!"SharedFunctions.CreateWstring(${paramNames[pc]}), ");
                            } else static if (is(paramTypes[pc] == dstring)) {
                                exp ~= mixin(interp!"SharedFunctions.CreateDstring(${paramNames[pc]}), ");
                            } else {
                                exp ~= paramNames[pc] ~ ", ";
                            }
                        }
                        exp = exp[0..$-2];
                        exp ~= ");" ~ newline;
                        if (!is(returnType == void)) {
                            if (is(returnType == string)) {
                                exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);" ~ newline;
                            } else if (is(returnType == wstring)) {
                                exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._wstring);" ~ newline;
                            } else if (is(returnType == dstring)) {
                                exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._dstring);" ~ newline;
                            } else {
                                exp ~= "            return dlang_ret;" ~ newline;
                            }
                        }
                        exp ~= "        }" ~ newline;
                    }
                    csagg.methods ~= exp;
                }
            }
        }
    }
}

private void generateProperties(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == interface) || is(T == struct)) {
    import autowrap.csharp.common : camelToPascalCase;
    import std.traits : isArray, fullyQualifiedName, functionAttributes, FunctionAttribute, ReturnType, Parameters;

    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;

    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }
        const string methodName = camelToPascalCase(cast(string)m);
        const string methodInterfaceName = getCSharpMethodInterfaceName(aggName, cast(string)m);

        static if (is(typeof(__traits(getMember, T, m)))) {
            const olc = __traits(getOverloads, T, m).length;
            static if(olc > 0 && olc <= 2) {
                bool isProperty = false;
                bool propertyGet = false;
                bool propertySet = false;
                foreach(mo; __traits(getOverloads, T, m)) {
                    static if (cast(bool)(functionAttributes!mo & FunctionAttribute.property)) {
                        isProperty = true;
                        alias returnType = ReturnType!mo;
                        alias paramTypes = Parameters!mo;
                        if (paramTypes.length == 0) {
                            propertyGet = true;
                        } else {
                            propertySet = true;
                        }
                    }
                }

                if (isProperty) {
                    string prop = string.init;
                    alias propertyType = ReturnType!(__traits(getOverloads, T, m)[0]);
                    if (is(propertyType == string) || is(propertyType == wstring) || is(propertyType == dstring)) {
                        prop = mixin(interp!"        public string ${methodName} { ");
                    } else if (isArray!(propertyType)) {
                        prop = mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!propertyType)}> ${methodName} { ");
                    } else {
                        prop = mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!propertyType)} ${methodName} { ");
                    }
                    if (propertyGet) {
                        if (is(propertyType == string)) {
                            prop ~= mixin(interp!"get => SharedFunctions.SliceToString(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._string);");
                        } else if (is(propertyType == wstring)) {
                            prop ~= mixin(interp!"get => SharedFunctions.SliceToString(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._wstring);");
                        } else if (is(propertyType == dstring)) {
                            prop ~= mixin(interp!"get => SharedFunctions.SliceToString(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._dstring);");
                        } else if (is(propertyType == string[])) {
                            prop ~= mixin(interp!"get => new Range<${getCSharpInterfaceType(fullyQualifiedName!propertyType)}>(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._string); ");
                        } else if (is(propertyType == wstring[])) {
                            prop ~= mixin(interp!"get => new Range<${getCSharpInterfaceType(fullyQualifiedName!propertyType)}>(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._wstring); ");
                        } else if (is(propertyType == dstring[])) {
                            prop ~= mixin(interp!"get => new Range<${getCSharpInterfaceType(fullyQualifiedName!propertyType)}>(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType._dstring); ");
                        } else if (isArray!(propertyType)) {
                            prop ~= mixin(interp!"get => new Range<${getCSharpInterfaceType(fullyQualifiedName!propertyType)}>(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this), DStringType.None); ");
                        } else if (is(propertyType == class)) {
                            prop ~= mixin(interp!"get => new ${getCSharpInterfaceType(fullyQualifiedName!propertyType)}(dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this)); ");
                        } else {
                            prop ~= mixin(interp!"get => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this); ");
                        }
                    }
                    if (propertySet) {
                        if (is(propertyType == string)) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(this, SharedFunctions.CreateString(value));");
                        } else if (is(propertyType == wstring)) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(this, SharedFunctions.CreateWstring(value));");
                        } else if (is(propertyType == dstring)) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(this, SharedFunctions.CreateDstring(value));");
                        } else if (is(propertyType == string[])) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this, value.ToSlice(DStringType._string)); ");
                        } else if (is(propertyType == wstring[])) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this, value.ToSlice(DStringType._wstring)); ");
                        } else if (is(propertyType == dstring[])) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this, value.ToSlice(DStringType._dstring)); ");
                        } else if (isArray!(propertyType)) {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this, value.ToSlice()); ");
                        } else {
                            prop ~= mixin(interp!"set => dlang_${methodInterfaceName}(${is(T == class) ? string.init : \"ref \"}this, value); ");
                        }
                    }
                    prop ~= "}" ~ newline;
                    csagg.properties ~= prop;
                }
            }
        }
    }
}

private void generateFields(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == interface) || is(T == struct)) {
    import autowrap.csharp.common : getDLangInterfaceName;
    import std.traits : isArray, fullyQualifiedName, Fields, FieldNameTuple;

    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;
    alias fieldTypes = Fields!T;
    alias fieldNames = FieldNameTuple!T;
    if (is(T == class) || is(T == interface)) {
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_get"));
                csagg.properties ~= mixin(interp!"        private static extern ${getDLangReturnType(fullyQualifiedName!(fieldTypes[fc]), true)} dlang_${fieldNames[fc]}_get(IntPtr ptr);${newline}");
                if (is(fieldTypes[fc] == bool)) {
                    csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set"));
                    csagg.properties ~= mixin(interp!"        private static extern void dlang_${fieldNames[fc]}_set(IntPtr ptr, [MarshalAs(UnmanagedType.Bool)] ${getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} value);${newline}");
                } else if (is(fieldTypes[fc] == class)) {
                    csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set"));
                    csagg.properties ~= mixin(interp!"        private static extern void dlang_${fieldNames[fc]}_set(IntPtr ptr, IntPtr value);${newline}");
                } else {
                    csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set"));
                    csagg.properties ~= mixin(interp!"        private static extern void dlang_${fieldNames[fc]}_set(IntPtr ptr, ${getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} value);${newline}");
                }

                if (is(fieldTypes[fc] == string)) {
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(dlang_${fieldNames[fc]}_get(this), DStringType._string); set => dlang_${fieldNames[fc]}_set(this, SharedFunctions.CreateString(value)); }${newline}");
                } else if (is(fieldTypes[fc] == wstring)) {
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(dlang_${fieldNames[fc]}_get(this), DStringType._wstring); set => dlang_${fieldNames[fc]}_set(this, SharedFunctions.CreateWstring(value)); }${newline}");
                } else if (is(fieldTypes[fc] == dstring)) {
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(dlang_${fieldNames[fc]}_get(this), DStringType._dstring); set => dlang_${fieldNames[fc]}_set(this, SharedFunctions.CreateDstring(value)); }${newline}");
                } else if (is(fieldTypes[fc] == string[])) {
                    csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}> ${getCSharpName(fieldNames[fc])} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}>(dlang_${fieldNames[fc]}_get(this), DStringType._string); set => dlang_${fieldNames[fc]}_set(this, value.ToSlice(DStringType._string)); }${newline}");
                } else if (is(fieldTypes[fc] == wstring[])) {
                    csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}> ${getCSharpName(fieldNames[fc])} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}>(dlang_${fieldNames[fc]}_get(this), DStringType._wstring); set => dlang_${fieldNames[fc]}_set(this, value.ToSlice(DStringType._wstring)); }${newline}");
                } else if (is(fieldTypes[fc] == dstring[])) {
                    csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}> ${getCSharpName(fieldNames[fc])} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}>(dlang_${fieldNames[fc]}_get(this), DStringType._dstring); set => dlang_${fieldNames[fc]}_set(this, value.ToSlice(DStringType._dstring)); }${newline}");
                } else if (isArray!(fieldTypes[fc])) {
                    csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}> ${getCSharpName(fieldNames[fc])} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}>(dlang_${fieldNames[fc]}_get(this), DStringType.None); set => dlang_${fieldNames[fc]}_set(this, value.ToSlice()); }${newline}");
                } else if (is(fieldTypes[fc] == class)) {
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => new ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}(dlang_${fieldNames[fc]}_get(this)); set => dlang_${fieldNames[fc]}_set(this, value); }${newline}");
                } else {
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => dlang_${fieldNames[fc]}_get(this); set => dlang_${fieldNames[fc]}_set(this, value); }${newline}");
                }
            }
        }
    } else if(is(T == struct)) {
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                if (is(fieldTypes[fc] == string) || is(fieldTypes[fc] == wstring) || is(fieldTypes[fc] == dstring)) {
                    csagg.properties ~= mixin(interp!"        private slice _${getCSharpName(fieldNames[fc])};${newline}");
                    if (is(fieldTypes[fc] == string)) {
                        csagg.properties ~= mixin(interp!"        public string ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(_${getCSharpName(fieldNames[fc])}, DStringType._${fullyQualifiedName!(fieldTypes[fc])}); set => _${getCSharpName(fieldNames[fc])} = SharedFunctions.CreateString(value); }${newline}");
                    } else if (is(fieldTypes[fc] == wstring)) {
                        csagg.properties ~= mixin(interp!"        public string ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(_${getCSharpName(fieldNames[fc])}, DStringType._${fullyQualifiedName!(fieldTypes[fc])}); set => _${getCSharpName(fieldNames[fc])} = SharedFunctions.CreateWstring(value); }${newline}");
                    } else if (is(fieldTypes[fc] == dstring)) {
                        csagg.properties ~= mixin(interp!"        public string ${getCSharpName(fieldNames[fc])} { get => SharedFunctions.SliceToString(_${getCSharpName(fieldNames[fc])}, DStringType._${fullyQualifiedName!(fieldTypes[fc])}); set => _${getCSharpName(fieldNames[fc])} = SharedFunctions.CreateDstring(value); }${newline}");
                    }
                } else if (is(fieldTypes[fc] == bool)) {
                    csagg.properties ~= mixin(interp!"        [MarshalAs(UnmanagedType.U1)] public ${getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])};${newline}");
                } else if (is(fieldTypes[fc] == class)) {
                    csagg.properties ~= mixin(interp!"        private IntPtr _${getCSharpName(fieldNames[fc])};${newline}");
                    csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])} { get => new ${getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc]))}(_${fieldNames[fc]}); set => _${fieldNames[fc]} = value); }${newline}");
                } else {
                    csagg.properties ~= mixin(interp!"        public ${getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))} ${getCSharpName(fieldNames[fc])};${newline}");
                }
            }
        }
    }
}

private void generateFunctions(Modules...)(string libraryName) if(allSatisfy!(isModule, Modules)) {
    import autowrap.csharp.common : getDLangInterfaceName;
    import autowrap.reflection: AllFunctions;
    import std.traits : isArray, fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple;

    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;
        CSharpNamespace ns = getNamespace(getCSharpName(modName));

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        const string methodName = getCSharpMethodInterfaceName(null, funcName);
        string retType = getDLangReturnType(returnTypeStr, is(returnType == class));
        string funcStr = dllImportString.format(libraryName, interfaceName) ~ newline;
        funcStr ~= mixin(interp!"        private static extern ${retType} dlang_${methodName}(");
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= mixin(interp!"${is(paramTypes[pc] == bool) ? \"[MarshalAs(UnmanagedType.Bool)]\" : string.init}${getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ");" ~ newline;
        if (is(returnType == string) || is(returnType == wstring) || is(returnType == dstring)) {
            funcStr ~= mixin(interp!"        public static string ${methodName}(");
        } else if (isArray!(returnType)) {
            funcStr ~= mixin(interp!"        public static Range<${getCSharpInterfaceType(returnTypeStr)}> ${methodName}(");
        } else {
            funcStr ~= mixin(interp!"        public static ${getCSharpInterfaceType(returnTypeStr)} ${methodName}(");
        }
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                funcStr ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
            } else if (isArray!(paramTypes[pc])) {
                funcStr ~= mixin(interp!"Range<${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))}> ${paramNames[pc]}, ");
            } else {
                funcStr ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc]))} ${paramNames[pc]}, ");
            }
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ") {" ~ newline;
        funcStr ~= mixin(interp!"            var dlang_ret = dlang_${methodName}(");
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == string)) {
                funcStr ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
            } else if (is(paramTypes[pc] == wstring)) {
                funcStr ~= mixin(interp!"SharedFunctions.CreateWString(${paramNames[pc]}), ");
            } else if (is(paramTypes[pc] == dstring)) {
                funcStr ~= mixin(interp!"SharedFunctions.CreateDString(${paramNames[pc]}), ");
            } else if (isArray!(paramTypes[pc])) {
                funcStr ~= mixin(interp!"${paramNames[pc]}.ToSlice(), ");
            } else {
                funcStr ~= mixin(interp!"${paramNames[pc]}, ");
            }
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ");" ~ newline;
        if (is(returnType == void)) {
            funcStr ~= "            dlang_ret.EnsureValid();" ~ newline;
        } else {
            if (is(returnType == string)) {
                funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);" ~ newline;
            } else if (is(returnType == wstring)) {
                funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._wstring);" ~ newline;
            } else if (is(returnType == dstring)) {
                funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._dstring);" ~ newline;
            } else if (is(returnType == string[])) {
                funcStr ~= mixin(interp!"            return new Range<${getCSharpInterfaceType(returnTypeStr)}>(dlang_ret, DStringType._string);${newline}");
            } else if (is(returnType == wstring[])) {
                funcStr ~= mixin(interp!"            return new Range<${getCSharpInterfaceType(returnTypeStr)}>(dlang_ret, DStringType._wstring);${newline}");
            } else if (is(returnType == dstring[])) {
                funcStr ~= mixin(interp!"            return new Range<${getCSharpInterfaceType(returnTypeStr)}>(dlang_ret, DStringType._dstring);${newline}");
            } else if (isArray!(returnType)) {
                funcStr ~= mixin(interp!"            return new Range<${getCSharpInterfaceType(returnTypeStr)}>(dlang_ret, DStringType.None);${newline}");
            } else {
                funcStr ~= "            return dlang_ret;" ~ newline;
            }
        }
        funcStr ~= "        }" ~ newline;
        ns.functions ~= funcStr;
    }
}

private string getDLangInterfaceType(string type) {
    if (type[$-2..$] == "[]") return "slice";

    switch(type) {
        //Types that require special marshalling types
        case voidTypeString: return "void";
        case stringTypeString: return "slice";
        case wstringTypeString: return "slice";
        case dstringTypeString: return "slice";
        case dateTimeTypeString: return "slice";
        case sysTimeTypeString: return "slice";
        case boolTypeString: return "bool";

        //Types that can be marshalled by default
        case charTypeString: return "byte";
        case wcharTypeString: return "char";
        case dcharTypeString: return "uint";
        case ubyteTypeString: return "byte";
        case byteTypeString: return "sbyte";
        case ushortTypeString: return "ushort";
        case shortTypeString: return "short";
        case uintTypeString: return "uint";
        case intTypeString: return "int";
        case ulongTypeString: return "ulong";
        case longTypeString: return "long";
        case floatTypeString: return "float";
        case doubleTypeString: return "double";
        default: return getCSharpName(type);
    }
}

private string getCSharpInterfaceType(string type) {
    if (type[$-2..$] == "[]") type = type[0..$-2];

    switch (type) {
        //Types that require special marshalling types
        case voidTypeString: return "void";
        case stringTypeString: return "string";
        case wstringTypeString: return "string";
        case dstringTypeString: return "string";
        case dateTimeTypeString: return "DateTime";
        case sysTimeTypeString: return "DateTimeOffset";
        case boolTypeString: return "bool";

        //Types that can be marshalled by default
        case charTypeString: return "byte";
        case wcharTypeString: return "char";
        case dcharTypeString: return "uint";
        case ubyteTypeString: return "byte";
        case byteTypeString: return "sbyte";
        case ushortTypeString: return "ushort";
        case shortTypeString: return "short";
        case uintTypeString: return "uint";
        case intTypeString: return "int";
        case ulongTypeString: return "ulong";
        case longTypeString: return "long";
        case floatTypeString: return "float";
        case doubleTypeString: return "double";
        default: return getCSharpName(type);
    }
}

private string getDLangReturnType(string type, bool isClass) {
    import std.stdio;

    string rtname = getReturnErrorTypeName(getDLangInterfaceType(type));
    //These types have predefined C# types.
    if(type == voidTypeString || type == boolTypeString || type == stringTypeString || type == wstringTypeString || type == dstringTypeString || rtname == "return_slice_error") {
        return rtname;
    }

    string typeStr = "    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct " ~ rtname ~ " {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
";

    if (isClass) {
        typeStr ~= mixin(interp!"        public static implicit operator IntPtr(${rtname} ret) { ret.EnsureValid(); return ret._value; }${newline}");
        typeStr ~= "        private IntPtr _value;" ~ newline;
    } else {
        typeStr ~= mixin(interp!"        public static implicit operator ${getCSharpInterfaceType(type)}(${rtname} ret) { ret.EnsureValid(); return ret._value; }${newline}");
        typeStr ~= mixin(interp!"        private ${getCSharpInterfaceType(type)} _value;${newline}");
    }
    typeStr ~= "        private slice _error;" ~ newline;
    typeStr ~= "    }" ~ newline ~ newline;

    if ((rtname in returnTypes) is null) {
        returnTypes[rtname] = typeStr;
    }
    return rtname;
}

private string getCSharpMethodInterfaceName(string aggName, string funcName) {
    import autowrap.csharp.common : camelToPascalCase;
    import std.string : split;
    import std.string : replace;

    string name = string.init;
    if (aggName !is null && aggName != string.init) {
        name ~= camelToPascalCase(aggName) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name.replace(".", "_");
}

private string getReturnErrorTypeName(string aggName) {
    import std.string : split;
    import std.array : join;
    return mixin(interp!"return_${aggName.split(\".\").join(\"_\")}_error");
}

private string getCSharpName(string dlangName) {
    import autowrap.csharp.common : camelToPascalCase;
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;
    return dlangName.split(".").map!camelToPascalCase.join(".");
}

private CSharpNamespace getNamespace(string name) {
    return namespaces.require(name, new CSharpNamespace(name));
}

private CSharpAggregate getAggregate(string namespace, string name, bool isStruct) {
    CSharpNamespace ns = namespaces.require(namespace, new CSharpNamespace(namespace));
    return ns.aggregates.require(name, new CSharpAggregate(name, isStruct));
}

private void generateRangeDef(T)(string libraryName) {
    import autowrap.csharp.common : getDLangSliceInterfaceName;
    import std.traits : fullyQualifiedName;

    alias fqn = fullyQualifiedName!T;
    const string csn = getCSharpName(fqn);

    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Create"));
    rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "Create"), "IntPtr capacity");
    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Slice"));
    rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "Slice"), "slice dslice, IntPtr begin, IntPtr end");
    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendSlice"));
    rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "AppendSlice"), "slice dslice, slice array");
    rangeDef.constructors ~= mixin(interp!"            else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) this._slice = RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Create\")}(new IntPtr(capacity));${newline}");
    rangeDef.sliceEnd ~= mixin(interp!"            else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return new Range<T>(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Slice\")}(_slice, new IntPtr(begin), _slice.length), DStringType.None);${newline}");
    rangeDef.sliceRange ~= mixin(interp!"            else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return new Range<T>(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Slice\")}(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);${newline}");
    rangeDef.setters ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Set\")}(_slice, new IntPtr(i), (${getCSharpInterfaceType(fqn)})(object)value);${newline}");
    rangeDef.appendValues ~= mixin(interp!"            else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) { this._slice = RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"AppendValue\")}(this._slice, (${getCSharpInterfaceType(fqn)})(object)value); }${newline}");
    rangeDef.appendArrays ~= mixin(interp!"            else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) { range._slice = RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"AppendSlice\")}(range._slice, source._slice); return range; }${newline}");
    if (is(T == class) || is(T == interface)) {
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format(getDLangReturnType(fqn, true), getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("return_void_error", getCSharpMethodInterfaceName(fqn, "Set"), "slice dslice, IntPtr index, IntPtr value");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "AppendValue"), "slice dslice, IntPtr value");
        rangeDef.getters ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return (T)(object)new ${getCSharpInterfaceType(fqn)}(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i)));${newline}");
        rangeDef.enumerators ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) yield return (T)(object)new ${getCSharpInterfaceType(fqn)}(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i)));${newline}");
    } else {
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format(getDLangReturnType(fqn, false), getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("return_void_error", getCSharpMethodInterfaceName(fqn, "Set"), mixin(interp!"slice dslice, IntPtr index, ${getCSharpInterfaceType(fqn)} value"));
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "AppendValue"), mixin(interp!"slice dslice, ${getCSharpInterfaceType(fqn)} value"));
        rangeDef.getters ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return (T)(object)(${getCSharpInterfaceType(fqn)})RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i));${newline}");
        rangeDef.enumerators ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) yield return (T)(object)(${getCSharpInterfaceType(fqn)})RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i));${newline}");
    }
}

private void generateSliceBoilerplate(string libraryName) {
    void generateStringBoilerplate(string dlangType, string csharpType) {
        rangeDef.enumerators ~= mixin(interp!"                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.${csharpType}_Get(_slice, new IntPtr(i)), DStringType._${dlangType});${newline}");
        rangeDef.getters ~= mixin(interp!"                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.${csharpType}_Get(_slice, new IntPtr(i)), DStringType._${dlangType});${newline}");
        rangeDef.setters ~= mixin(interp!"                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) RangeFunctions.${csharpType}_Set(_slice, new IntPtr(i), SharedFunctions.Create${csharpType}((string)(object)value));${newline}");
        rangeDef.sliceEnd ~= mixin(interp!"            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) return new Range<T>(RangeFunctions.${csharpType}_Slice(_slice, new IntPtr(begin), _slice.length), _type);${newline}");
        rangeDef.sliceRange ~= mixin(interp!"            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) return new Range<T>(RangeFunctions.${csharpType}_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);${newline}");
        rangeDef.appendValues ~= mixin(interp!"            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._${dlangType}) { _slice = RangeFunctions.${csharpType}_AppendValue(_slice, SharedFunctions.Create${csharpType}((string)(object)value)); }${newline}");
        rangeDef.appendArrays ~= mixin(interp!"            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._${dlangType}) { range._slice = RangeFunctions.${csharpType}_AppendSlice(range._slice, source._slice); return range; }${newline}");

        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_Create"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", csharpType ~ "_Create", "IntPtr capacity");
        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_Get"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", csharpType ~ "_Get", "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_Set"));
        rangeDef.functions ~= externFuncString.format("return_void_error", csharpType ~ "_Set", "slice dslice, IntPtr index, slice value");
        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_Slice"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", csharpType ~ "_Slice", "slice dslice, IntPtr begin, IntPtr end");
        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_AppendValue"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", csharpType ~ "_AppendValue", "slice dslice, slice value");
        rangeDef.functions ~= dllImportString.format(libraryName, mixin(interp!"autowrap_csharp_${csharpType}_AppendSlice"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", csharpType ~ "_AppendSlice", "slice dslice, slice array");
    }

    //bool
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Create");
    rangeDef.functions ~= externFuncString.format("return_slice_error", "Bool_Create", "IntPtr capacity");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Get");
    rangeDef.functions ~= "        [return: MarshalAs(UnmanagedType.Bool)]" ~ newline;
    rangeDef.functions ~= externFuncString.format("return_bool_error", "Bool_Get", "slice dslice, IntPtr index");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Set");
    rangeDef.functions ~= externFuncString.format("return_void_error", "Bool_Set", "slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Slice");
    rangeDef.functions ~= externFuncString.format("return_slice_error", "Bool_Slice", "slice dslice, IntPtr begin, IntPtr end");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_AppendValue");
    rangeDef.functions ~= externFuncString.format("return_slice_error", "Bool_AppendValue", "slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_AppendSlice");
    rangeDef.functions ~= externFuncString.format("return_slice_error", "Bool_AppendSlice", "slice dslice, slice array");
    rangeDef.constructors ~= "            if (typeof(T) == typeof(bool)) this._slice = RangeFunctions.Bool_Create(new IntPtr(capacity));" ~ newline;
    rangeDef.enumerators ~= "                if (typeof(T) == typeof(bool)) yield return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.getters ~= "                if (typeof(T) == typeof(bool)) return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.setters ~= "                if (typeof(T) == typeof(bool)) RangeFunctions.Bool_Set(_slice, new IntPtr(i), (bool)(object)value);" ~ newline;
    rangeDef.sliceEnd ~= "            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), _slice.length), DStringType.None);" ~ newline;
    rangeDef.sliceRange ~= "            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)), DStringType.None);" ~ newline;
    rangeDef.appendValues ~= "            if (typeof(T) == typeof(bool)) { this._slice = RangeFunctions.Bool_AppendValue(this._slice, (bool)(object)value); }" ~ newline;
    rangeDef.appendArrays ~= "            if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.Bool_AppendSlice(range._slice, source._slice); return range; }" ~ newline;

    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) yield return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) _strings[(int)i] = (string)(object)value;" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>((IEnumerable<T>)_strings.Skip((int)begin));" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>((IEnumerable<T>)_strings.Skip((int)begin).Take((int)end - (int)begin));" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && this._strings != null && this._type == DStringType.None) { this._strings.Add((string)(object)value); }" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { foreach(T s in source) range._strings.Add((string)(object)s); return range; }" ~ newline;

    generateStringBoilerplate("string", "String");
    generateStringBoilerplate("wstring", "Wstring");
    generateStringBoilerplate("dstring", "Dstring");

    generateRangeDef!byte(libraryName);
    generateRangeDef!ubyte(libraryName);
    generateRangeDef!short(libraryName);
    generateRangeDef!ushort(libraryName);
    generateRangeDef!int(libraryName);
    generateRangeDef!uint(libraryName);
    generateRangeDef!long(libraryName);
    generateRangeDef!ulong(libraryName);
    generateRangeDef!float(libraryName);
    generateRangeDef!double(libraryName);
}

private string writeCSharpBoilerplate(string libraryName, string rootNamespace) {
    string returnTypesStr = string.init;
    foreach(string rt; returnTypes.byValue) {
        returnTypesStr ~= rt;
    }
    immutable string boilerplate = import("Boilerplate.cs");
    return boilerplate.format(libraryName, rootNamespace, returnTypesStr, rangeDef.toString());
}