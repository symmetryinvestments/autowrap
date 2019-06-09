module autowrap.csharp.csharp;

import scriptlike : interp, _interp_text;

import autowrap.csharp.common : LibraryName, RootNamespace, OutputFileName;
import autowrap.reflection : isModule, Modules;

import std.ascii : newline;
import std.meta: allSatisfy;
import std.string : format;
import std.typecons : Tuple;

private string[string] returnTypes;
private CSharpNamespace[string] namespaces;
private csharpRange rangeDef;

enum string voidTypeString = "void";
enum string stringTypeString = "string";
enum string wstringTypeString = "wstring";
enum string dstringTypeString = "dstring";
enum string boolTypeString = "bool";
enum string dateTimeTypeString = "std.datetime.date.DateTime";
enum string sysTimeTypeString = "std.datetime.systime.SysTime";
enum string dateTypeString = "std.datetime.date.Date";
enum string timeOfDayTypeString = "std.datetime.date.TimeOfDay";
enum string durationTypeString = "core.time.Duration";
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
        string ret = "namespace " ~ namespace ~ " {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Autowrap;

    public static class Functions {
" ~ functions ~ "
    }" ~ newline ~ newline;
            foreach(agg; aggregates.byValue()) {
                ret ~= agg.toString();
            }
            ret ~= "}" ~ newline;
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
    import core.time : Duration;
    import autowrap.csharp.common : isDateTimeType, verifySupported;
    import autowrap.reflection : AllAggregates;

    generateSliceBoilerplate(libraryName.value);

    static foreach(Agg; AllAggregates!Modules)
    {
        static if(verifySupported!Agg && !isDateTimeType!Agg)
        {
            generateRangeDef!Agg(libraryName.value);
            generateConstructors!Agg(libraryName.value);
            generateMethods!Agg(libraryName.value);
            generateProperties!Agg(libraryName.value);
            generateFields!Agg(libraryName.value);
        }
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

private void generateConstructors(T)(string libraryName) if (is(T == class) || is(T == struct)) {
    import autowrap.csharp.common : getDLangInterfaceName, numDefaultArgs, verifySupported;

    import std.algorithm : among;
    import std.conv : to;
    import std.format : format;
    import std.meta: AliasSeq, Filter;
    import std.traits : moduleName, fullyQualifiedName, hasMember, Parameters, ParameterIdentifierTuple;

    alias fqn = fullyQualifiedName!T;
    const string aggName = __traits(identifier, T);
    CSharpAggregate csagg = getAggregate(getCSharpName(moduleName!T), getCSharpName(aggName), !is(T == class));

    //Generate constructor methods
    static if(hasMember!(T, "__ctor") && __traits(getProtection, __traits(getMember, T, "__ctor")).among("export", "public"))
    {
        foreach(i, c; __traits(getOverloads, T, "__ctor"))
        {
            if (__traits(getProtection, c).among("export", "public"))
            {
                alias paramNames = ParameterIdentifierTuple!c;
                alias ParamTypes = Parameters!c;

                static if(Filter!(verifySupported, ParamTypes).length != ParamTypes.length)
                    continue;

                static foreach(nda; 0 .. numDefaultArgs!c + 1)
                {{
                    enum numParams = ParamTypes.length - nda;

                    enum interfaceName = format("%s%s_%s", getDLangInterfaceName(fqn, "__ctor"), i, numParams);
                    enum methodInterfaceName = format("%s%s_%s", getCSharpMethodInterfaceName(aggName, "__ctor"), i, numParams);

                    string ctor = dllImportString.format(libraryName, interfaceName);
                    ctor ~= mixin(interp!"        private static extern ${getDLangReturnType!(T, T)()} dlang_${methodInterfaceName}(");

                    static foreach(pc; 0 .. numParams)
                    {
                        if (is(ParamTypes[pc] == class))
                            ctor ~= mixin(interp!"IntPtr ${paramNames[pc]}, ");
                        else
                            ctor ~= mixin(interp!"${is(ParamTypes[pc] == bool) ? \"[MarshalAs(UnmanagedType.Bool)]\" : string.init}${getDLangInterfaceType!(ParamTypes[pc], T)()} ${paramNames[pc]}, ");
                    }

                    if (numParams != 0)
                        ctor = ctor[0 .. $ - 2];

                    ctor ~= ");" ~ newline;
                    ctor ~= mixin(interp!"        public ${getCSharpName(aggName)}(");
                    static foreach(pc; 0 .. numParams)
                        ctor ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))} ${paramNames[pc]}, ");

                    if (numParams != 0)
                        ctor = ctor[0 .. $ - 2];

                    static if (is(T == class))
                        ctor ~= mixin(interp!") : base(dlang_${methodInterfaceName}(");
                    else static if(is(T == struct))
                    {
                        ctor ~= ") {" ~ newline;
                        ctor ~= mixin(interp!"            this = dlang_${methodInterfaceName}(");
                    }
                    else
                        static assert(false, "Somehow, this type has a constructor even though it is neither a class nor a struct: " ~ T.stringof);

                    static foreach(pc; 0 .. numParams)
                    {
                        static if (is(ParamTypes[pc] == string))
                            ctor ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
                        else static if (is(ParamTypes[pc] == wstring))
                            ctor ~= mixin(interp!"SharedFunctions.CreateWString(${paramNames[pc]}), ");
                        else static if (is(ParamTypes[pc] == dstring))
                            ctor ~= mixin(interp!"SharedFunctions.CreateDString(${paramNames[pc]}), ");
                        else
                            ctor ~= mixin(interp!"${paramNames[pc]}, ");
                    }

                    if (numParams != 0)
                        ctor = ctor[0 .. $ - 2];

                    ctor ~= ")";

                    static if (is(T == class))
                        ctor ~= ") { }" ~ newline;
                    else
                    {
                        ctor ~= ";" ~ newline;
                        ctor ~= "        }" ~ newline;
                    }

                    csagg.constructors ~= ctor;
                }}
            }
        }
    }

    if (is(T == class))
        csagg.constructors ~= mixin(interp!"        internal ${getCSharpName(aggName)}(IntPtr ptr) : base(ptr) { }${newline}");
}

private void generateMethods(T)(string libraryName)
    if (is(T == class) || is(T == interface) || is(T == struct))
{
    import autowrap.csharp.common : getDLangInterfaceName, numDefaultArgs, verifySupported;

    import std.algorithm.comparison : among;
    import std.conv : to;
    import std.format : format;
    import std.meta : AliasSeq, Filter;
    import std.traits : moduleName, isDynamicArray, fullyQualifiedName, isFunction, functionAttributes, FunctionAttribute,
                        ReturnType, Parameters, ParameterIdentifierTuple;

    alias fqn = fullyQualifiedName!T;
    const string aggName = __traits(identifier, T);
    CSharpAggregate csagg = getAggregate(getCSharpName(moduleName!T), getCSharpName(aggName), !is(T == class));

    foreach(m; __traits(allMembers, T))
    {
        static if (!m.among("__ctor", "toHash", "opEquals", "opCmp", "factory") &&
                   is(typeof(__traits(getMember, T, m))))
        {
            enum methodName = getCSMemberName(aggName, cast(string)m);

            foreach(oc, mo; __traits(getOverloads, T, m))
            {
                static if(isFunction!mo)
                {
                    static foreach(nda; 0 .. numDefaultArgs!mo + 1)
                    {{
                        alias RT = ReturnType!mo;
                        alias ParamTypes = Parameters!mo;
                        alias Types = AliasSeq!(RT, ParamTypes);

                        static if(Filter!(verifySupported, Types).length != Types.length)
                            continue;
                        else
                        {
                            enum numParams = ParamTypes.length - nda;
                            alias paramNames = ParameterIdentifierTuple!mo;

                            enum dlangInterfaceName = format("%s%s_%s", getDLangInterfaceName(fqn, m), oc, numParams);
                            enum methodInterfaceName = format("dlang_%s", getCSharpMethodInterfaceName(aggName, cast(string)m));

                            string exp = dllImportString.format(libraryName, dlangInterfaceName);
                            exp ~= "        private static extern ";

                            if (!is(RT == void))
                                exp ~= getDLangReturnType!(RT, T)();
                            else
                                exp ~= "return_void_error";

                            exp ~= mixin(interp!" ${methodInterfaceName}(");

                            if (is(T == struct))
                                exp ~= mixin(interp!"ref ${getDLangInterfaceType!(T, T)()} __obj__, ");
                            else if (is(T == class) || is(T == interface))
                                exp ~= "IntPtr __obj__, ";

                            static foreach(pc; 0 .. numParams)
                            {
                                if (is(ParamTypes[pc] == class))
                                    exp ~= mixin(interp!"IntPtr ${paramNames[pc]}, ");
                                else
                                    exp ~= mixin(interp!"${getDLangInterfaceType!(ParamTypes[pc], T)()} ${paramNames[pc]}, ");
                            }

                            exp = exp[0 .. $-2];
                            exp ~= ");" ~ newline;

                            if ((functionAttributes!mo & FunctionAttribute.property) == 0)
                            {
                                enum returnTypeStr = fullyQualifiedName!RT;

                                exp ~= mixin(interp!`        public ${methodName == "ToString" ? "override " : ""}${getCSharpInterfaceType(returnTypeStr)} ${methodName}(`);
                                static foreach(pc; 0 .. numParams)
                                {
                                    if (is(ParamTypes[pc] == string) || is(ParamTypes[pc] == wstring) || is(ParamTypes[pc] == dstring))
                                        exp ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))} ${paramNames[pc]}, ");
                                    else if (isDynamicArray!(ParamTypes[pc]))
                                        exp ~= mixin(interp!"Range<${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))}> ${paramNames[pc]}, ");
                                    else
                                        exp ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))} ${paramNames[pc]}, ");
                                }

                                if (numParams != 0)
                                    exp = exp[0 .. $-2];

                                exp ~= ") {" ~ newline;
                                exp ~= mixin(interp!`            var dlang_ret = ${methodInterfaceName}(${is(T == struct) ? "ref " : ""}this, `);

                                static foreach(pc; 0 .. numParams)
                                {
                                    static if (is(ParamTypes[pc] == string))
                                        exp ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
                                    else static if (is(ParamTypes[pc] == wstring))
                                        exp ~= mixin(interp!"SharedFunctions.CreateWstring(${paramNames[pc]}), ");
                                    else static if (is(ParamTypes[pc] == dstring))
                                        exp ~= mixin(interp!"SharedFunctions.CreateDstring(${paramNames[pc]}), ");
                                    else
                                        exp ~= paramNames[pc] ~ ", ";
                                }

                                exp = exp[0 .. $-2];
                                exp ~= ");" ~ newline;

                                if (!is(RT == void))
                                {
                                    if (is(RT == string))
                                        exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);" ~ newline;
                                    else if (is(RT == wstring))
                                        exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._wstring);" ~ newline;
                                    else if (is(RT == dstring))
                                        exp ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._dstring);" ~ newline;
                                    else
                                        exp ~= "            return dlang_ret;" ~ newline;
                                }

                                exp ~= "        }" ~ newline;
                            }

                            csagg.methods ~= exp;
                        }
                    }}
                }
            }
        }
    }
}

private void generateProperties(T)(string libraryName)
    if (is(T == class) || is(T == interface) || is(T == struct))
{
    import autowrap.csharp.common : verifySupported;

    import std.algorithm.comparison : among;
    import std.format : format;
    import std.meta : AliasSeq, Filter, staticIndexOf;
    import std.traits : moduleName, isDynamicArray, fullyQualifiedName;

    enum fqn = fullyQualifiedName!T;
    enum aggName = __traits(identifier, T);
    CSharpAggregate csagg = getAggregate(getCSharpName(moduleName!T), getCSharpName(aggName), !is(T == class));

    foreach(m; __traits(allMembers, T))
    {
        static if (!m.among("__ctor", "toHash", "opEquals", "opCmp", "factory") &&
                   is(typeof(__traits(getMember, T, m))))
        {
            enum methodName = getCSMemberName(aggName, cast(string)m);

            alias GType = GetterPropertyType!(T, m);
            alias STypes = SetterPropertyTypes!(T, m);

            static if(GType.length == 1)
            {
                alias PT = GType[0];
                enum getterInterfaceName = format("dlang_%s", getCSharpMethodInterfaceName(aggName, cast(string)m));

                static if(staticIndexOf!(PT, STypes) != -1)
                    enum setterInterfaceName = format("dlang_%s", getCSharpMethodInterfaceName(aggName, cast(string)m));
            }
            else static if(STypes.length == 1)
            {
                alias PT = STypes[0];
                enum setterInterfaceName = format("dlang_%s", getCSharpMethodInterfaceName(aggName, cast(string)m));
            }

            static if(is(PT) && verifySupported!PT)
            {
                static if (is(PT == string) || is(PT == wstring) || is(PT == dstring))
                    string prop = mixin(interp!"        public string ${methodName} { ");
                else static if (isDynamicArray!PT)
                    string prop = mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!PT)}> ${methodName} { ");
                else
                    string prop = mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!PT)} ${methodName} { ");

                static if (is(typeof(getterInterfaceName)))
                {
                    static if (is(PT == string))
                        prop ~= mixin(interp!`get => SharedFunctions.SliceToString(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._string);`);
                    else static if (is(PT == wstring))
                        prop ~= mixin(interp!`get => SharedFunctions.SliceToString(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._wstring);`);
                    else static if (is(PT == dstring))
                        prop ~= mixin(interp!`get => SharedFunctions.SliceToString(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._dstring);`);
                    else static if (is(PT == string[]))
                        prop ~= mixin(interp!`get => new Range<string>(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._string); `);
                    else static if (is(PT == wstring[]))
                        prop ~= mixin(interp!`get => new Range<string>(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._wstring); `);
                    else static if (is(PT == dstring[]))
                        prop ~= mixin(interp!`get => new Range<string>(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType._dstring); `);
                    else static if (isDynamicArray!PT)
                        prop ~= mixin(interp!`get => new Range<${getCSharpInterfaceType(fullyQualifiedName!PT)}>(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this), DStringType.None); `);
                    else static if (is(PT == class))
                        prop ~= mixin(interp!`get => new ${getCSharpInterfaceType(fullyQualifiedName!PT)}(${getterInterfaceName}(${is(T == class) ? "" : "ref "}this)); `);
                    else
                        prop ~= mixin(interp!`get => ${getterInterfaceName}(${is(T == class) ? "" : "ref "}this); `);
                }

                static if (is(typeof(setterInterfaceName)))
                {
                    static if (is(PT == string))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(this, SharedFunctions.CreateString(value));`);
                    else static if (is(PT == wstring))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(this, SharedFunctions.CreateWstring(value));`);
                    else static if (is(PT == dstring))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(this, SharedFunctions.CreateDstring(value));`);
                    else static if (is(PT == string[]))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(${is(T == class) ? "" : "ref "}this, value.ToSlice(DStringType._string)); `);
                    else static if (is(PT == wstring[]))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(${is(T == class) ? "" : "ref "}this, value.ToSlice(DStringType._wstring)); `);
                    else static if (is(PT == dstring[]))
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(${is(T == class) ? "" : "ref "}this, value.ToSlice(DStringType._dstring)); `);
                    else static if (isDynamicArray!PT)
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(${is(T == class) ? "" : "ref "}this, value.ToSlice()); `);
                    else
                        prop ~= mixin(interp!`set => ${setterInterfaceName}(${is(T == class) ? "" : "ref "}this, value); `);
                }

                prop ~= "}" ~ newline;
                csagg.properties ~= prop;
            }
        }
    }
}

private void generateFields(T)(string libraryName) if (is(T == class) || is(T == interface) || is(T == struct)) {
    import autowrap.csharp.common : getDLangInterfaceName, verifySupported;
    import std.traits : moduleName, isDynamicArray, fullyQualifiedName, Fields, FieldNameTuple;

    alias fqn = fullyQualifiedName!T;
    const string aggName = __traits(identifier, T);
    CSharpAggregate csagg = getAggregate(getCSharpName(moduleName!T), getCSharpName(aggName), !is(T == class));

    alias FieldTypes = Fields!T;
    alias fieldNames = FieldNameTuple!T;

    if (is(T == class) || is(T == interface))
    {
        static foreach(fc; 0..FieldTypes.length)
        {{
            alias FT = FieldTypes[fc];
            static if(verifySupported!FT)
            {
                alias fn = fieldNames[fc];
                static if (is(typeof(__traits(getMember, T, fn))))
                {
                    csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fn ~ "_get"));
                    csagg.properties ~= mixin(interp!"        private static extern ${getDLangReturnType!(FT, T)} dlang_${fn}_get(IntPtr ptr);${newline}");
                    if (is(FT == bool)) {
                        csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fn ~ "_set"));
                        csagg.properties ~= mixin(interp!"        private static extern void dlang_${fn}_set(IntPtr ptr, [MarshalAs(UnmanagedType.Bool)] ${getDLangInterfaceType!(FT, T)()} value);${newline}");
                    } else if (is(FT == class)) {
                        csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fn ~ "_set"));
                        csagg.properties ~= mixin(interp!"        private static extern void dlang_${fn}_set(IntPtr ptr, IntPtr value);${newline}");
                    } else {
                        csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fn ~ "_set"));
                        csagg.properties ~= mixin(interp!"        private static extern void dlang_${fn}_set(IntPtr ptr, ${getDLangInterfaceType!(FT, T)()} value);${newline}");
                    }

                    string memberName = getCSMemberName(aggName, fn);

                    if (is(FT == string)) {
                        csagg.properties ~= mixin(interp!"        public string ${memberName} { get => SharedFunctions.SliceToString(dlang_${fn}_get(this), DStringType._string); set => dlang_${fn}_set(this, SharedFunctions.CreateString(value)); }${newline}");
                    } else if (is(FT == wstring)) {
                        csagg.properties ~= mixin(interp!"        public string ${memberName} { get => SharedFunctions.SliceToString(dlang_${fn}_get(this), DStringType._wstring); set => dlang_${fn}_set(this, SharedFunctions.CreateWstring(value)); }${newline}");
                    } else if (is(FT == dstring)) {
                        csagg.properties ~= mixin(interp!"        public string ${memberName} { get => SharedFunctions.SliceToString(dlang_${fn}_get(this), DStringType._dstring); set => dlang_${fn}_set(this, SharedFunctions.CreateDstring(value)); }${newline}");
                    } else if (is(FT == string[])) {
                        csagg.properties ~= mixin(interp!"        public Range<string> ${memberName} { get => new Range<string>(dlang_${fn}_get(this), DStringType._string); set => dlang_${fn}_set(this, value.ToSlice(DStringType._string)); }${newline}");
                    } else if (is(FT == wstring[])) {
                        csagg.properties ~= mixin(interp!"        public Range<string> ${memberName} { get => new Range<string>(dlang_${fn}_get(this), DStringType._wstring); set => dlang_${fn}_set(this, value.ToSlice(DStringType._wstring)); }${newline}");
                    } else if (is(FT == dstring[])) {
                        csagg.properties ~= mixin(interp!"        public Range<string> ${memberName} { get => new Range<string>(dlang_${fn}_get(this), DStringType._dstring); set => dlang_${fn}_set(this, value.ToSlice(DStringType._dstring)); }${newline}");
                    } else if (isDynamicArray!FT) {
                        csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(FT))}> ${memberName} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(FT))}>(dlang_${fn}_get(this), DStringType.None); set => dlang_${fn}_set(this, value.ToSlice()); }${newline}");
                    } else if (is(FT == class)) {
                        csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(FT))} ${memberName} { get => new ${getCSharpInterfaceType(fullyQualifiedName!(FT))}(dlang_${fn}_get(this)); set => dlang_${fn}_set(this, value); }${newline}");
                    } else {
                        csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(FT))} ${memberName} { get => dlang_${fn}_get(this); set => dlang_${fn}_set(this, value); }${newline}");
                    }
                }
            }
        }}
    }
    else if(is(T == struct))
    {
        static foreach(fc; 0..FieldTypes.length)
        {{
            alias FT = FieldTypes[fc];
            static if(verifySupported!FT)
            {
                alias fn = fieldNames[fc];
                static if (is(typeof(__traits(getMember, T, fn))))
                {
                    auto nameTuple = getCSFieldNameTuple(aggName, fn);
                    auto pubName = nameTuple.public_;
                    auto privName = nameTuple.private_;

                    if (isDynamicArray!FT) {
                        csagg.properties ~= mixin(interp!"        private slice ${privName};${newline}");
                        if (is(FT == string)) {
                            csagg.properties ~= mixin(interp!"        public string ${pubName} { get => SharedFunctions.SliceToString(${privName}, DStringType._string); set => ${privName} = SharedFunctions.CreateString(value); }${newline}");
                        } else if (is(FT == wstring)) {
                            csagg.properties ~= mixin(interp!"        public string ${pubName} { get => SharedFunctions.SliceToString(${privName}, DStringType._wstring); set => ${privName} = SharedFunctions.CreateWstring(value); }${newline}");
                        } else if (is(FT == dstring)) {
                            csagg.properties ~= mixin(interp!"        public string ${pubName} { get => SharedFunctions.SliceToString(${privName}, DStringType._dstring); set => ${privName} = SharedFunctions.CreateDstring(value); }${newline}");
                        } else if (is(FT == string[])) {
                            csagg.properties ~= mixin(interp!"        public Range<string> ${pubName} { get => new Range<string>(_${fn}, DStringType._string); set => _${fn} = value.ToSlice(DStringType._string); }${newline}");
                        } else if (is(FT == wstring[])) {
                            csagg.properties ~= mixin(interp!"        public Range<string> ${pubName} { get => new Range<string>(_${fn}, DStringType._wstring); set => _${fn} = value.ToSlice(DStringType._wstring); }${newline}");
                        } else if (is(FT == dstring[])) {
                            csagg.properties ~= mixin(interp!"        public Range<string> ${pubName} { get => new Range<string>(_${fn}, DStringType._dstring); set => _${fn} = value.ToSlice(DStringType._dstring); }${newline}");
                        } else {
                            csagg.properties ~= mixin(interp!"        public Range<${getCSharpInterfaceType(fullyQualifiedName!(FT))}> ${pubName} { get => new Range<${getCSharpInterfaceType(fullyQualifiedName!(FT))}>(_${fn}, DStringType.None); set => _${fn} = value.ToSlice(); }${newline}");
                        }
                    } else if (is(FT == bool)) {
                        csagg.properties ~= mixin(interp!"        [MarshalAs(UnmanagedType.U1)] public ${getDLangInterfaceType!(FT, T)()} ${pubName};${newline}");
                    } else if (is(FT == class)) {
                        csagg.properties ~= mixin(interp!"        private IntPtr ${privName};${newline}");
                        csagg.properties ~= mixin(interp!"        public ${getCSharpInterfaceType(fullyQualifiedName!(FT))} ${pubName} { get => new ${getCSharpInterfaceType(fullyQualifiedName!(FT))}(_${fn}); set => _${fn} = value); }${newline}");
                    } else {
                        csagg.properties ~= mixin(interp!"        public ${getDLangInterfaceType!(FT, T)()} ${pubName};${newline}");
                    }
                }
            }
        }}
    }
}

private void generateFunctions(Modules...)(string libraryName)
    if(allSatisfy!(isModule, Modules))
{
    import autowrap.csharp.common : getDLangInterfaceName, numDefaultArgs, verifySupported;
    import autowrap.reflection: AllFunctions;

    import std.format : format;
    import std.meta : AliasSeq, Filter;
    import std.traits : isDynamicArray, fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple;

    foreach(func; AllFunctions!Modules)
    {
        foreach(oc, overload; __traits(getOverloads, func.module_, func.name))
        {
            alias RT = ReturnType!overload;
            alias ParamTypes = Parameters!overload;
            alias Types = AliasSeq!(RT, ParamTypes);

            static if(Filter!(verifySupported, Types).length != Types.length)
                continue;
            else
            {
                static foreach(nda; 0 .. numDefaultArgs!overload + 1)
                {{
                    enum numParams = ParamTypes.length - nda;
                    enum interfaceName = format("%s%s_%s", getDLangInterfaceName(func.moduleName, null, func.name), oc, numParams);
                    enum methodName = getCSharpMethodInterfaceName(null, func.name);
                    enum methodInterfaceName = format("dlang_%s", methodName);

                    enum returnTypeStr = getCSharpInterfaceType(fullyQualifiedName!RT);
                    alias paramNames = ParameterIdentifierTuple!overload;

                    string retType = getDLangReturnType!RT();
                    string funcStr = dllImportString.format(libraryName, interfaceName) ~ newline;
                    funcStr ~= mixin(interp!"        private static extern ${retType} ${methodInterfaceName}(");
                    static foreach(pc; 0 .. numParams)
                        funcStr ~= mixin(interp!"${is(ParamTypes[pc] == bool) ? \"[MarshalAs(UnmanagedType.Bool)]\" : string.init}${getDLangInterfaceType!(ParamTypes[pc])()} ${paramNames[pc]}, ");

                    if (numParams != 0)
                        funcStr = funcStr[0 .. $ - 2];

                    funcStr ~= ");" ~ newline;

                    if (is(RT == string) || is(RT == wstring) || is(RT == dstring))
                        funcStr ~= mixin(interp!"        public static string ${methodName}(");
                    else if (isDynamicArray!RT)
                        funcStr ~= mixin(interp!"        public static Range<${returnTypeStr}> ${methodName}(");
                    else
                        funcStr ~= mixin(interp!"        public static ${returnTypeStr} ${methodName}(");

                    static foreach(pc; 0 .. numParams)
                    {
                        if (is(ParamTypes[pc] == string) || is(ParamTypes[pc] == wstring) || is(ParamTypes[pc] == dstring))
                            funcStr ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))} ${paramNames[pc]}, ");
                        else if (isDynamicArray!(ParamTypes[pc]))
                            funcStr ~= mixin(interp!"Range<${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))}> ${paramNames[pc]}, ");
                        else
                            funcStr ~= mixin(interp!"${getCSharpInterfaceType(fullyQualifiedName!(ParamTypes[pc]))} ${paramNames[pc]}, ");
                    }

                    if (numParams != 0)
                        funcStr = funcStr[0 .. $ - 2];

                    funcStr ~= ") {" ~ newline;
                    funcStr ~= mixin(interp!"            var dlang_ret = ${methodInterfaceName}(");

                    static foreach(pc; 0 .. numParams)
                    {
                        if (is(ParamTypes[pc] == string))
                            funcStr ~= mixin(interp!"SharedFunctions.CreateString(${paramNames[pc]}), ");
                        else if (is(ParamTypes[pc] == wstring))
                            funcStr ~= mixin(interp!"SharedFunctions.CreateWString(${paramNames[pc]}), ");
                        else if (is(ParamTypes[pc] == dstring))
                            funcStr ~= mixin(interp!"SharedFunctions.CreateDString(${paramNames[pc]}), ");
                        else if (isDynamicArray!(ParamTypes[pc]))
                            funcStr ~= mixin(interp!"${paramNames[pc]}.ToSlice(), ");
                        else
                            funcStr ~= mixin(interp!"${paramNames[pc]}, ");
                    }

                    if (numParams != 0)
                        funcStr = funcStr[0 .. $ - 2];

                    funcStr ~= ");" ~ newline;

                    if (is(RT == void))
                        funcStr ~= "            dlang_ret.EnsureValid();" ~ newline;
                    else
                    {
                        if (is(RT == string))
                            funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._string);" ~ newline;
                        else if (is(RT == wstring))
                            funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._wstring);" ~ newline;
                        else if (is(RT == dstring))
                            funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret, DStringType._dstring);" ~ newline;
                        else if (is(RT == string[]))
                            funcStr ~= mixin(interp!"            return new Range<string>(dlang_ret, DStringType._string);${newline}");
                        else if (is(RT == wstring[]))
                            funcStr ~= mixin(interp!"            return new Range<string>(dlang_ret, DStringType._wstring);${newline}");
                        else if (is(RT == dstring[]))
                            funcStr ~= mixin(interp!"            return new Range<string>(dlang_ret, DStringType._dstring);${newline}");
                        else if (isDynamicArray!RT)
                            funcStr ~= mixin(interp!"            return new Range<${returnTypeStr}>(dlang_ret, DStringType.None);${newline}");
                        else
                            funcStr ~= "            return dlang_ret;" ~ newline;
                    }

                    funcStr ~= "        }" ~ newline;

                    getNamespace(getCSharpName(func.moduleName)).functions ~= funcStr;
                }}
            }
        }
    }
}

private string getDLangInterfaceType(T, Parent...)()
    if(Parent.length <= 1)
{
    import std.traits : fullyQualifiedName, isBuiltinType;

    static if(!isBuiltinType!T && Parent.length == 1)
    {
        static if(is(T == Parent[0]))
            enum typeName = __traits(identifier, T);
        else
            enum typeName = fullyQualifiedName!T;
    }
    else
        enum typeName = fullyQualifiedName!T;

    if (typeName[$-2..$] == "[]") return "slice";

    switch(typeName)
    {
        //Types that require special marshalling types
        case voidTypeString: return "void";
        case stringTypeString: return "slice";
        case wstringTypeString: return "slice";
        case dstringTypeString: return "slice";
        case sysTimeTypeString: return "datetime";
        case dateTimeTypeString: return "datetime";
        case timeOfDayTypeString: return "datetime";
        case dateTypeString: return "datetime";
        case durationTypeString: return "datetime";
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
        default: return getCSharpName(typeName);
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
        case sysTimeTypeString: return "DateTimeOffset";
        case dateTimeTypeString: return "DateTime";
        case timeOfDayTypeString: return "DateTime";
        case dateTypeString: return "DateTime";
        case durationTypeString: return "TimeSpan";
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

private string getDLangReturnType(T, Parent...)()
    if(Parent.length <= 1)
{
    import std.algorithm : among;
    import std.traits : fullyQualifiedName;

    enum rtname = getReturnErrorTypeName(getDLangInterfaceType!T());

    static if(Parent.length == 1)
    {
        static if(is(T == Parent[0]))
            enum typeName = __traits(identifier, T);
        else
            enum typeName = fullyQualifiedName!T;
    }
    else
        enum typeName = fullyQualifiedName!T;

    //These types have predefined C# types.
    if (typeName.among(dateTypeString, dateTimeTypeString, sysTimeTypeString, timeOfDayTypeString, durationTypeString,
        voidTypeString, boolTypeString, stringTypeString, wstringTypeString, dstringTypeString) || rtname == "return_slice_error") {
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

    static if (is(T == class) || is(T == interface))
    {
        typeStr ~= mixin(interp!"        public static implicit operator IntPtr(${rtname} ret) { ret.EnsureValid(); return ret._value; }${newline}");
        typeStr ~= "        private IntPtr _value;" ~ newline;
    }
    else
    {
        typeStr ~= mixin(interp!"        public static implicit operator ${getCSharpInterfaceType(typeName)}(${rtname} ret) { ret.EnsureValid(); return ret._value; }${newline}");
        typeStr ~= mixin(interp!"        private ${getCSharpInterfaceType(typeName)} _value;${newline}");
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

    if (aggName == "DateTime" || aggName == "DateTimeOffset" || aggName == "TimeSpan") {
        aggName = "Datetime";
    }

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
    if (is(T == class) || is(T == interface))
    {
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format(getDLangReturnType!T(), getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("return_void_error", getCSharpMethodInterfaceName(fqn, "Set"), "slice dslice, IntPtr index, IntPtr value");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "AppendValue"), "slice dslice, IntPtr value");
        rangeDef.getters ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return (T)(object)new ${getCSharpInterfaceType(fqn)}(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i)));${newline}");
        rangeDef.enumerators ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) yield return (T)(object)new ${getCSharpInterfaceType(fqn)}(RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i)));${newline}");
    }
    else
    {
        enum dlangIT = getDLangInterfaceType!T;
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format(getDLangReturnType!T(), getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("return_void_error", getCSharpMethodInterfaceName(fqn, "Set"), mixin(interp!"slice dslice, IntPtr index, ${dlangIT} value"));
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("return_slice_error", getCSharpMethodInterfaceName(fqn, "AppendValue"), mixin(interp!"slice dslice, ${dlangIT} value"));
        rangeDef.getters ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) return (T)(object)(${getCSharpInterfaceType(fqn)})RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i));${newline}");
        rangeDef.enumerators ~= mixin(interp!"                else if (typeof(T) == typeof(${getCSharpInterfaceType(fqn)})) yield return (T)(object)(${getCSharpInterfaceType(fqn)})RangeFunctions.${getCSharpMethodInterfaceName(fqn, \"Get\")}(_slice, new IntPtr(i));${newline}");
    }
}

private void generateSliceBoilerplate(string libraryName) {
    import std.datetime: DateTime, SysTime, Duration;

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

    generateRangeDef!DateTime(libraryName);
    generateRangeDef!SysTime(libraryName);
    generateRangeDef!Duration(libraryName);
}

private string writeCSharpBoilerplate(string libraryName, string rootNamespace) {
    string returnTypesStr = string.init;
    foreach(string rt; returnTypes.byValue) {
        returnTypesStr ~= rt;
    }
    immutable string boilerplate = import("Boilerplate.cs");
    return boilerplate.format(libraryName, rootNamespace, returnTypesStr, rangeDef.toString());
}

// C# doesn't allow members to have the same name as the class or struct,
// because it would conflict with how they name constructors.
string getCSMemberName(string dlangTypeName, string dlangMemberName)
{
    import autowrap.csharp.common : camelToPascalCase;
    string retval = camelToPascalCase(dlangMemberName);
    if(retval == getCSharpName(dlangTypeName))
        retval ~= "_";
    return retval;
}

Tuple!(string, "public_", string, "private_") getCSFieldNameTuple(string dlangTypeName, string dlangFieldName)
{
    import std.typecons : tuple;
    auto memberName = getCSMemberName(dlangTypeName, dlangFieldName);
    return typeof(return)(memberName, "_" ~ memberName);
}

private template GetterPropertyType(T, string memberName)
{
    import std.meta : AliasSeq, staticMap;
    import std.traits : fullyQualifiedName;

    alias GetterPropertyType = staticMap!(GetterType, __traits(getOverloads, T, memberName));
    static assert(GetterPropertyType.length <= 1,
                  "It should not be possible to have multiple getters with the same name. " ~
                  fullyQualifiedName!T ~ "." ~ memberName);

    static template GetterType(alias func)
    {
        import std.traits : FunctionAttribute, functionAttributes, Parameters, ReturnType;

        static if((functionAttributes!func & FunctionAttribute.property) != 0 &&
                  !is(ReturnType!func == void) &&
                  Parameters!func.length == 0)
        {
            alias GetterType = ReturnType!func;
        }
        else
            alias GetterType = AliasSeq!();
    }
}

// This does ignore getters which return by ref, but they can be checked by
// looking at the getter, and it wouldn't work to use such a function as a
// setter without an extra D function around it to call it, which we don't
// currently do. But even if we wanted to handle such a case, it's simpler to
// check the getter than to treat it as another setter.
private template SetterPropertyTypes(T, string memberName)
{
    import std.meta : AliasSeq, staticMap;

    alias SetterPropertyTypes = staticMap!(SetterType, __traits(getOverloads, T, memberName));

    static template SetterType(alias func)
    {
        import std.traits : FunctionAttribute, functionAttributes, Parameters, ReturnType;

        alias ParamTypes = Parameters!func;

        static if(ParamTypes.length == 1 && (functionAttributes!func & FunctionAttribute.property) != 0)
            alias SetterType = ParamTypes;
        else
            alias SetterType = AliasSeq!();
    }
}

// Unfortunately, while these tests have been tested on their own, they don't
// currently run as part of autowrap's tests, because dub test doesn't work for
// the csharp folder, and the top level one does not run them.
unittest
{
    import std.meta : AliasSeq;

    static struct S
    {
        @property void noprop() { assert(0); }
        @property void noprop(int, int) { assert(0); }
        @property int noprop(int, int) { assert(0); }

        int noprop2() { assert(0); }
        void noprop2(string) { assert(0); }
        int noprop2(int) { assert(0); }
        bool noprop2(float) { assert(0); }

        @property int getter() { assert(0); }
        @property void getter(int, int) { assert(0); }
        @property string getter(string, int) { assert(0); }

        @property ref string getter2() { assert(0); }
        void getter2(string) { assert(0); }
        ref int getter2(int) { assert(0); }
        bool getter2(float) { assert(0); }

        @property string setter(int) { assert(0); }
        @property string setter(float, bool) { assert(0); }
        @property int setter(bool, int) { assert(0); }

        int setter2() { assert(0); }
        @property void setter2(string) { assert(0); }
        @property int setter2(int) { assert(0); }
        @property bool setter2(wstring, bool) { assert(0); }
        @property bool setter2(float) { assert(0); }

        @property int both() { assert(0); }
        @property void both(string) { assert(0); }
        @property int both(int) { assert(0); }
        @property bool both(float) { assert(0); }
    }

    static assert(GetterPropertyType!(S, "noprop").length == 0);
    static assert(SetterPropertyTypes!(S, "noprop").length == 0);

    static assert(GetterPropertyType!(S, "noprop2").length == 0);
    static assert(SetterPropertyTypes!(S, "noprop2").length == 0);

    static assert(is(GetterPropertyType!(S, "getter") == AliasSeq!int));
    static assert(SetterPropertyTypes!(S, "getter").length == 0);

    static assert(is(GetterPropertyType!(S, "getter2") == AliasSeq!string));
    static assert(SetterPropertyTypes!(S, "getter2").length == 0);

    static assert(GetterPropertyType!(S, "setter").length == 0);
    static assert(is(SetterPropertyTypes!(S, "setter") == AliasSeq!int));

    static assert(GetterPropertyType!(S, "setter2").length == 0);
    static assert(is(SetterPropertyTypes!(S, "setter2") == AliasSeq!(string, int, float)));

    static assert(is(GetterPropertyType!(S, "both") == AliasSeq!int));
    static assert(is(SetterPropertyTypes!(S, "both") == AliasSeq!(string, int, float)));
}

private template isNotVoid(T...)
    if(T.length == 1)
{
    enum isNotVoid = !is(T[0] == void);
}
