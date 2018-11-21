module autowrap.csharp.csharp;

import autowrap.csharp.common : camelToPascalCase, getDLangSliceInterfaceName, getDLangInterfaceName;
import autowrap.reflection : AllFunctions, AllAggregates, isModule;

import std.ascii : newline;
import std.meta: allSatisfy, AliasSeq;
import std.traits : isArray, fullyQualifiedName, moduleName, isFunction, Fields, FieldNameTuple, hasMember, functionAttributes, FunctionAttribute, ReturnType, Parameters, ParameterIdentifierTuple;
import std.string : format, replace;

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

private class CSharpNamespace {
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

private class CSharpAggregate {
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
        char[] ret;
        ret.reserve(aggregateReservationSize);
        ret ~= "    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]" ~ newline;
        if (isStruct) {
            ret ~= "    [StructLayout(LayoutKind.Sequential)]" ~ newline;
            ret ~= "    public struct " ~ camelToPascalCase(this.name) ~ " {" ~ newline;
        } else {
            ret ~= "    public class " ~ camelToPascalCase(this.name) ~ " : DLangObject {" ~ newline;
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
        return "    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    internal class RangeFunctions {
" ~ functions ~ "
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    public class Range<T> : IEnumerable<T> {
        private slice _slice;
        private DStringType _type;
        private IList<string> _strings;

        internal slice ToSlice(DStringType type = DStringType.None) {
            if (type == DStringType.None && _strings != null) {
                throw new TypeAccessException(\"Cannot pass a range of strings to a non-string range.\");
            }

            if (_strings == null) {
                return _slice;
            } else {
                _type = type;
                if (_type == DStringType._string) {
                    _slice = RangeFunctions.String_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.String_AppendValue(_slice, SharedFunctions.CreateString(s));
                    }
                } else if (_type == DStringType._wstring) {
                    _slice = RangeFunctions.Wstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Wstring_AppendValue(_slice, SharedFunctions.CreateWstring(s));
                    }
                } else if (_type == DStringType._dstring) {
                    _slice = RangeFunctions.Dstring_Create(new IntPtr(_strings.Count()));
                    foreach(var s in _strings) {
                        _slice = RangeFunctions.Dstring_AppendValue(_slice, SharedFunctions.CreateDstring(s));
                    }
                }
                _strings = null;
                return _slice;
            }
        }
        public long Length => _strings?.Count ?? _slice.length.ToInt64();

        internal Range(slice range, DStringType type = DStringType.None) {
            this._slice = range;
            this._type = type;
        }

        public Range(IEnumerable<string> strings) {
            this._strings = new List<string>(strings);
        }

        public Range(long capacity = 0) {
" ~ constructors ~ "
            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
        }
        ~Range() {
            SharedFunctions.ReleaseMemory(_slice.ptr);
        }
        public T this[long i] {
            get {
" ~ getters ~ "
                else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
            }
            set {
" ~ setters ~ "
            }
        }
        public Range<T> Slice(long begin) {
" ~ sliceEnd ~ "
            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
        }
        public Range<T> Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException(\"Value for parameter 'end' is greater than that length of the slice.\");
            }
" ~ sliceRange ~ "
            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
        }
        public static Range<T> operator +(Range<T> range, T value) {
" ~ appendValues ~ "
            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
        }
        public static Range<T> operator +(Range<T> range, Range<T> source) {
" ~ appendArrays ~ "
            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");
        }
        public IEnumerator<T> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
" ~ enumerators ~ "
            }
        }
        public static implicit operator T[](Range<T> slice) {
            return slice.ToArray();
        }
        public static implicit operator Range<T>(T[] array) {
            var vs = new Range<T>(array.Length);
            foreach(var t in array) {
                vs += t;
            }
            return vs;
        }
        public static implicit operator List<T>(Range<T> slice) {
            return new List<T>(slice.ToArray());
        }
        public static implicit operator Range<T>(List<T> array) {
            var vs = new Range<T>(array.Count);
            foreach(var t in array) {
                vs += t;
            }
            return vs;
        }
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }";
    }
}

public string generateCSharp(Modules...)(string libraryName, string rootNamespace) if(allSatisfy!(isModule, Modules)) {
    generateSliceBoilerplate(libraryName);

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        const string aggName = __traits(identifier, agg);
        CSharpAggregate csagg = getAggregate(getCSharpName(modName), getCSharpName(aggName), !is(agg == class));

        generateRangeDef!agg(libraryName);

        generateConstructors!agg(libraryName, csagg);

        generateMethods!agg(libraryName, csagg);

        generateProperties!agg(libraryName, csagg);

        generateFields!agg(libraryName, csagg);
    }

    generateFunctions!Modules(libraryName);

    char[] ret;
    ret.reserve(fileReservationSize);
    foreach(csns; namespaces.byValue()) {
        ret ~= csns.toString();
    }

    ret ~= newline ~ writeCSharpBoilerplate(libraryName, rootNamespace);

    return cast(immutable)ret;
}

private void generateConstructors(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == struct)) {
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
        enum isNothrow = functionAttributes!c & FunctionAttribute.nothrow_;
        const string interfaceName = getDLangInterfaceName(fqn, "__ctor");
        const string methodName = getCSharpMethodInterfaceName(aggName, "__ctor");
        string ctor = dllImportString.format(libraryName, interfaceName);
        if (is(T == class)) {
            ctor ~= "        private static extern %s dlang_%s(".format(getDLangReturnType(aggName, isNothrow, true), methodName);
        } else if (is(T == struct)) {
            ctor ~= "        private static extern %s dlang_%s(".format(methodName);
        }
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == class)) {
                ctor ~= "IntPtr " ~ paramNames[pc] ~ ", ";
            } else {
                if (is(paramTypes[pc] == bool)) ctor ~= "[MarshalAs(UnmanagedType.Bool)]";
                ctor ~= getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
            }
        }
        if (paramNames.length > 0) {
            ctor = ctor[0..$-2];
        }
        ctor ~= ");" ~ newline;
        ctor ~= "        public " ~ getCSharpName(aggName) ~ "(";
        static foreach(pc; 0..paramNames.length) {
            ctor ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
        }
        if (paramNames.length > 0) {
            ctor = ctor[0..$-2];
        }
        if (is(T == class)) {
            ctor ~= ") : base(dlang_%s(".format(methodName);
            static foreach(pc; 0..paramNames.length) {
                static if (is(paramTypes[pc] == string)) {
                    ctor ~= "SharedFunctions.CreateString(" ~ paramNames[pc] ~ "), ";
                } else static if (is(paramTypes[pc] == wstring)) {
                    ctor ~= "SharedFunctions.CreateWString(" ~ paramNames[pc] ~ "), ";
                } else static if (is(paramTypes[pc] == dstring)) {
                    ctor ~= "SharedFunctions.CreateDString(" ~ paramNames[pc] ~ "), ";
                } else {
                    ctor ~= paramNames[pc] ~ ", ";
                }
            }
            if (paramNames.length > 0) {
                ctor = ctor[0..$-2];
            }
            ctor ~= ")) { ";
        } else if (is(T == struct)) {
        }
        ctor ~= "}" ~ newline;
        csagg.constructors ~= ctor;
    }
    if (is(T == class)) {
        csagg.constructors ~= "        internal %s(IntPtr ptr) : base(ptr) { }".format(getCSharpName(aggName)) ~ newline;
    }
}

private void generateMethods(T)(string libraryName, CSharpAggregate csagg) if (is(T == class) || is(T == interface) || is(T == struct)) {
    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;

    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }
        const string methodName = camelToPascalCase(cast(string)m);
        const string methodInterfaceName = getCSharpMethodInterfaceName(aggName, cast(string)m);

        static if (is(typeof(__traits(getMember, T, m)))) {
            foreach(mo; __traits(getOverloads, T, m)) {
                static if(isFunction!mo) {
                    string exp = string.init;
                    enum bool isNothrow = cast(bool)(functionAttributes!mo & FunctionAttribute.nothrow_);
                    enum bool isProperty = cast(bool)(functionAttributes!mo & FunctionAttribute.property);
                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = fullyQualifiedName!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;

                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    exp ~= dllImportString.format(libraryName, interfaceName);
                    exp ~= "        private static extern ";
                    if (!is(returnType == void)) {
                        static if (is(returnType == class)) {
                            exp ~= getDLangReturnType(returnTypeStr, isNothrow, true);
                        } else {
                            exp ~= getDLangReturnType(returnTypeStr, isNothrow, false);
                        }
                    } else {
                        exp ~= "return_void_error";
                    }
                    exp ~= " dlang_" ~ methodInterfaceName ~ "(";
                    if (is(T == struct)) {
                        exp ~= "ref " ~ getDLangInterfaceType(fqn) ~ " __obj__, ";
                    } else if (is(T == class) || is(T == interface)) {
                        exp ~= "IntPtr __obj__, ";
                    }
                    static foreach(pc; 0..paramNames.length) {
                        if (is(paramTypes[pc] == class)) {
                            exp ~= "IntPtr " ~ paramNames[pc] ~ ", ";
                        } else {
                            exp ~= getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
                        }
                    }
                    exp = exp[0..$-2];
                    exp ~= ");" ~ newline;
                    if (!isProperty) {
                        if (methodName == "ToString") {
                            exp ~= "        public override %s %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
                        } else {
                            exp ~= "        public %s %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
                        }
                        static foreach(pc; 0..paramNames.length) {
                            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                                exp ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
                            } else if (isArray!(paramTypes[pc])) {
                                exp ~= "Range<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
                            } else {
                                exp ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
                            }
                        }
                        if (paramNames.length > 0) {
                            exp = exp[0..$-2];
                        }
                        exp ~= ") {" ~ newline;
                        if (is(T == class)) {
                            if (isNothrow && is(returnType == void)) {
                                exp ~= "            dlang_%s(DLangPointer, ".format(methodInterfaceName);
                            } else {
                                exp ~= "            var dlang_ret = dlang_%s(DLangPointer, ".format(methodInterfaceName);
                            }
                        } else {
                            if (isNothrow && is(returnType == void)) {
                                exp ~= "            dlang_%s(ref this, ".format(methodInterfaceName);
                            } else {
                                exp ~= "            var dlang_ret = dlang_%s(ref this, ".format(methodInterfaceName);
                            }
                        }
                        static foreach(pc; 0..paramNames.length) {
                            static if (is(paramTypes[pc] == string)) {
                                exp ~= "SharedFunctions.CreateString(" ~ paramNames[pc] ~ "), ";
                            } else static if (is(paramTypes[pc] == wstring)) {
                                exp ~= "SharedFunctions.CreateWstring(" ~ paramNames[pc] ~ "), ";
                            } else static if (is(paramTypes[pc] == dstring)) {
                                exp ~= "SharedFunctions.CreateDstring(" ~ paramNames[pc] ~ "), ";
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
    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;

    foreach(m; __traits(allMembers, T)) {
        if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
            continue;
        }
        const string methodName = camelToPascalCase(cast(string)m);
        const string methodInterfaceName = getCSharpMethodInterfaceName(aggName, cast(string)m);

        static if (is(typeof(__traits(getMember, T, m)))) {
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

            const olc = __traits(getOverloads, T, m).length;
            static if(olc > 0) {
                if (isProperty) {
                    string prop = string.init;
                    alias propertyType = ReturnType!(__traits(getOverloads, T, m)[0]);
                    if (isArray!(propertyType)) {
                        prop = "        public Range<" ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ "> " ~ methodName ~ " { ";
                    } else {
                        prop = "        public " ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ " " ~ methodName ~ " { ";
                    }
                    if (propertyGet) {
                        if (isArray!(propertyType)) {
                            prop ~= "get => new Range<%3$s>(dlang_%1$s(%2$s)); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this", getCSharpInterfaceType(fullyQualifiedName!propertyType));
                        } else if (is(propertyType == class)) {
                            prop ~= "get => new %3$s(dlang_%1$s(%2$s)); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this", getCSharpInterfaceType(fullyQualifiedName!propertyType));
                        } else {
                            prop ~= "get => dlang_%1$s(%2$s); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this");
                        }
                    }
                    if (propertySet) {
                        if (isArray!(propertyType)) {
                            prop ~= "set => dlang_%1$s(%2$s, value.ToSlice()); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this");
                        } else if (is(propertyType == class)) {
                            prop ~= "set => dlang_%1$s(%2$s, value.DLangPointer); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this");
                        } else {
                            prop ~= "set => dlang_%1$s(%2$s, value); ".format(methodInterfaceName, is(T == class) ? "DLangPointer" : "ref this");
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
    const string aggName = __traits(identifier, T);
    alias fqn = fullyQualifiedName!T;
    alias fieldTypes = Fields!T;
    alias fieldNames = FieldNameTuple!T;
    if (is(T == class) || is(T == interface)) {
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_get"));
                csagg.properties ~= "        private static extern %s dlang_%s_get(IntPtr ptr);".format(getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc])), fieldNames[fc]) ~ newline;
                csagg.properties ~= dllImportString.format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set"));
                csagg.properties ~= "        private static extern void dlang_%s_set(IntPtr ptr, %s value);".format(fieldNames[fc], getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))) ~ newline;
                if (is(fieldTypes[fc] == string)) {
                    csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._string); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateString(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                } else if (is(fieldTypes[fc] == wstring)) {
                    csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._wstring); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateWstring(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                } else if (is(fieldTypes[fc] == dstring)) {
                    csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._dstring); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateDstring(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                } else if (isArray!(fieldTypes[fc])) {
                    csagg.properties ~= "        public Range<%2$s> %3$s { get => new Range<%2$s>(dlang_%1$s_get(DLangPointer)); set => dlang_%1$s_set(DLangPointer, value.ToSlice()); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                } else {
                    csagg.properties ~= "        public %2$s %3$s { get => dlang_%1$s_get(DLangPointer); set => dlang_%1$s_set(DLangPointer, value); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                }
            }
        }
    } else if(is(T == struct)) {
        static foreach(fc; 0..fieldTypes.length) {
            static if (is(typeof(__traits(getMember, T, fieldNames[fc])))) {
                if (is(fieldTypes[fc] == string) || is(fieldTypes[fc] == wstring) || is(fieldTypes[fc] == dstring)) {
                    csagg.properties ~= "        private slice _" ~ getCSharpName(fieldNames[fc]) ~ ";" ~ newline;
                    if (is(fieldTypes[fc] == string)) {
                        csagg.properties ~= "        public string %1$s { get => SharedFunctions.SliceToString(_%1$s, DStringType._%2$s); set => _%1$s = SharedFunctions.CreateString(value); }".format(getCSharpName(fieldNames[fc]), fullyQualifiedName!(fieldTypes[fc])) ~ newline;
                    } else if (is(fieldTypes[fc] == wstring)) {
                        csagg.properties ~= "        public string %1$s { get => SharedFunctions.SliceToString(_%1$s, DStringType._%2$s); set => _%1$s = SharedFunctions.CreateWstring(value); }".format(getCSharpName(fieldNames[fc]), fullyQualifiedName!(fieldTypes[fc])) ~ newline;
                    } else if (is(fieldTypes[fc] == dstring)) {
                        csagg.properties ~= "        public string %1$s { get => SharedFunctions.SliceToString(_%1$s, DStringType._%2$s); set => _%1$s = SharedFunctions.CreateDstring(value); }".format(getCSharpName(fieldNames[fc]), fullyQualifiedName!(fieldTypes[fc])) ~ newline;
                    }
                } else {
                    csagg.properties ~= "        public " ~ getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc])) ~ " " ~ getCSharpName(fieldNames[fc]) ~ ";" ~ newline;
                }
            }
        }
    }
}

private void generateFunctions(Modules...)(string libraryName) if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;

    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;
        CSharpNamespace ns = getNamespace(getCSharpName(modName));

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        enum bool isNothrow = (functionAttributes!(__traits(getMember, func.module_, func.name)) & FunctionAttribute.nothrow_) == FunctionAttribute.nothrow_;
        const string interfaceName = getDLangInterfaceName(modName, null, funcName);
        const string methodName = getCSharpMethodInterfaceName(null, funcName);
        static if (is(returnType == class)) {
            string retType = getDLangReturnType(returnTypeStr, isNothrow, true);
        } else {
            string retType = getDLangReturnType(returnTypeStr, isNothrow, false);
        }
        string funcStr = "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, interfaceName) ~ newline;
        if (returnTypeStr == boolTypeString && isNothrow) {
            funcStr ~= "        [return: MarshalAs(UnmanagedType.Bool)]";
        }
        funcStr ~= "        private static extern %s dlang_%s(".format(retType, methodName);
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == bool)) funcStr ~= "[MarshalAs(UnmanagedType.Bool)]";
            funcStr ~= getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ");" ~ newline;
        if (is(returnType == string) || is(returnType == wstring) || is(returnType == dstring)) {
            funcStr ~= "        public static string %s(".format(methodName);
        } else if (isArray!(returnType)) {
            funcStr ~= "        public static Range<%s> %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        } else {
            funcStr ~= "        public static %s %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        }
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                funcStr ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
            } else if (isArray!(paramTypes[pc])) {
                funcStr ~= "Range<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
            } else {
                funcStr ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
            }
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ") {" ~ newline;
        if (isNothrow && is(returnType == void)) {
            funcStr ~= "            dlang_%s(".format(methodName);
        } else { 
            funcStr ~= "            var dlang_ret = dlang_%s(".format(methodName);
        }
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == string)) {
                funcStr ~= "SharedFunctions.CreateString(" ~ paramNames[pc] ~ "), ";
            } else if (is(paramTypes[pc] == wstring)) {
                funcStr ~= "SharedFunctions.CreateWString(" ~ paramNames[pc] ~ "), ";
            } else if (is(paramTypes[pc] == dstring)) {
                funcStr ~= "SharedFunctions.CreateDString(" ~ paramNames[pc] ~ "), ";
            } else if (isArray!(paramTypes[pc])) {
                funcStr ~= paramNames[pc] ~ ".ToSlice(), ";
            } else {
                funcStr ~= paramNames[pc] ~ ", ";
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
            } else if (isArray!(returnType)) {
                funcStr ~= "            return new Range<%s>(dlang_ret);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
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

private string getDLangReturnType(string type, bool isNothrow, bool isClass) {
    import std.stdio;
    if(isNothrow) {
        return getDLangInterfaceType(type);
    } else {
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
            typeStr ~= "        public static implicit operator IntPtr(%s ret) { ret.EnsureValid(); return ret._value; }".format(rtname) ~ newline;
            typeStr ~= "        private IntPtr _value;" ~ newline;
        } else {
            typeStr ~= "        public static implicit operator %s(%s ret) { ret.EnsureValid(); return ret._value; }".format(getCSharpInterfaceType(type), rtname) ~ newline;
            typeStr ~= "        private %s _value;".format(getCSharpInterfaceType(type)) ~ newline;
        }
        typeStr ~= "        private slice _error;" ~ newline;
        typeStr ~= "    }" ~ newline ~ newline;

        if ((rtname in returnTypes) is null) {
            returnTypes[rtname] = typeStr;
        }
        return rtname;
    }
}

private string getCSharpMethodInterfaceName(string aggName, string funcName) {
    import std.string : split;
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
    return "return_" ~ aggName.split(".").join("_") ~ "_error";
}

private string getCSharpName(string dlangName) {
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
    alias fqn = fullyQualifiedName!T;
    const string csn = getCSharpName(fqn);

    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Create"));
    rangeDef.functions ~= externFuncString.format("slice", getCSharpMethodInterfaceName(fqn, "Create"), "IntPtr capacity");
    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Slice"));
    rangeDef.functions ~= externFuncString.format("slice", getCSharpMethodInterfaceName(fqn, "Slice"), "slice dslice, IntPtr begin, IntPtr end");
    rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendSlice"));
    rangeDef.functions ~= externFuncString.format("slice", getCSharpMethodInterfaceName(fqn, "AppendSlice"), "slice dslice, slice array");
    rangeDef.constructors ~= "            else if (typeof(T) == typeof(%2$s)) this._slice = RangeFunctions.%1$s(new IntPtr(capacity));".format(getCSharpMethodInterfaceName(fqn, "Create"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(%2$s)) return new Range<T>(RangeFunctions.%1$s(_slice, new IntPtr(begin), _slice.length));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(%2$s)) return new Range<T>(RangeFunctions.%1$s(_slice, new IntPtr(begin), new IntPtr(end)));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.%1$s(range._slice, source._slice); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendSlice"), getCSharpInterfaceType(fqn)) ~ newline;
    if (is(T == class) || is(T == interface)) {
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format("IntPtr", getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("void", getCSharpMethodInterfaceName(fqn, "Set"), "slice dslice, IntPtr index, IntPtr value");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("slice", getCSharpMethodInterfaceName(fqn, "AppendValue"), "slice dslice, IntPtr value");
        rangeDef.getters ~= "                else if (typeof(T) == typeof(%2$s)) return (T)(object)new %2$s(RangeFunctions.%1$s(_slice, new IntPtr(i)));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.setters ~= "                else if (typeof(T) == typeof(%2$s)) RangeFunctions.%1$s(_slice, new IntPtr(i), ((DLangObject)(object)value).DLangPointer);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.appendValues ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.%1$s(range._slice, ((DLangObject)(object)value).DLangPointer); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendValue"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.enumerators ~= "                else if (typeof(T) == typeof(%2$s)) yield return (T)(object)new %2$s(RangeFunctions.%1$s(_slice, new IntPtr(i)));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    } else {
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Get"));
        rangeDef.functions ~= externFuncString.format(getCSharpInterfaceType(fqn), getCSharpMethodInterfaceName(fqn, "Get"), "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "Set"));
        rangeDef.functions ~= externFuncString.format("void", getCSharpMethodInterfaceName(fqn, "Set"), "slice dslice, IntPtr index, %1$s value".format(getCSharpInterfaceType(fqn)));
        rangeDef.functions ~= dllImportString.format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue"));
        rangeDef.functions ~= externFuncString.format("slice", getCSharpMethodInterfaceName(fqn, "AppendValue"), "slice dslice, %1$s value".format(getCSharpInterfaceType(fqn)));
        rangeDef.getters ~= "                else if (typeof(T) == typeof(%2$s)) return (T)(object)RangeFunctions.%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.setters ~= "                else if (typeof(T) == typeof(%2$s)) RangeFunctions.%1$s(_slice, new IntPtr(i), (%2$s)(object)value);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.appendValues ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.%1$s(range._slice, (%2$s)(object)value); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendValue"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.enumerators ~= "                else if (typeof(T) == typeof(%2$s)) yield return (T)(object)RangeFunctions.%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    }
}

private void generateSliceBoilerplate(string libraryName) {
    void generateStringBoilerplate(string dlangType, string csharpType) {
        rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._" ~ dlangType ~ ") yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions." ~ csharpType ~ "_Get(_slice, new IntPtr(i)), DStringType._" ~ dlangType ~ ");" ~ newline;
        rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._" ~ dlangType ~ ") return (T)(object)SharedFunctions.SliceToString(RangeFunctions." ~ csharpType ~ "_Get(_slice, new IntPtr(i)), DStringType._" ~ dlangType ~ ");" ~ newline;
        rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._" ~ dlangType ~ ") RangeFunctions." ~ csharpType ~ "_Set(_slice, new IntPtr(i), SharedFunctions.Create" ~ csharpType ~ "((string)(object)value));" ~ newline;
        rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._" ~ dlangType ~ ") return new Range<T>(RangeFunctions." ~ csharpType ~ "_Slice(_slice, new IntPtr(begin), _slice.length), _type);" ~ newline;
        rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._" ~ dlangType ~ ") return new Range<T>(RangeFunctions." ~ csharpType ~ "_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);" ~ newline;
        rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._" ~ dlangType ~ ") { range._slice = RangeFunctions." ~ csharpType ~ "_AppendValue(range._slice, SharedFunctions.Create" ~ csharpType ~ "((string)(object)value)); return range; }" ~ newline;
        rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._" ~ dlangType ~ ") { range._slice = RangeFunctions." ~ csharpType ~ "_AppendSlice(range._slice, source._slice); return range; }" ~ newline;

        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_Create");
        rangeDef.functions ~= externFuncString.format("slice", "" ~ csharpType ~ "_Create", "IntPtr capacity");
        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_Get");
        rangeDef.functions ~= externFuncString.format("slice", "" ~ csharpType ~ "_Get", "slice dslice, IntPtr index");
        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_Set");
        rangeDef.functions ~= externFuncString.format("void", "" ~ csharpType ~ "_Set", "slice dslice, IntPtr index, slice value");
        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_Slice");
        rangeDef.functions ~= externFuncString.format("slice", "" ~ csharpType ~ "_Slice", "slice dslice, IntPtr begin, IntPtr end");
        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_AppendValue");
        rangeDef.functions ~= externFuncString.format("slice", "" ~ csharpType ~ "_AppendValue", "slice dslice, slice value");
        rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_" ~ csharpType ~ "_AppendSlice");
        rangeDef.functions ~= externFuncString.format("slice", "" ~ csharpType ~ "_AppendSlice", "slice dslice, slice array");
    }

    //bool
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Create");
    rangeDef.functions ~= externFuncString.format("slice", "Bool_Create", "IntPtr capacity");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Get");
    rangeDef.functions ~= "        [return: MarshalAs(UnmanagedType.Bool)]" ~ newline;
    rangeDef.functions ~= externFuncString.format("bool", "Bool_Get", "slice dslice, IntPtr index");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Set");
    rangeDef.functions ~= externFuncString.format("void", "Bool_Set", "slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_Slice");
    rangeDef.functions ~= externFuncString.format("slice", "Bool_Slice", "slice dslice, IntPtr begin, IntPtr end");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_AppendValue");
    rangeDef.functions ~= externFuncString.format("slice", "Bool_AppendValue", "slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value");
    rangeDef.functions ~= dllImportString.format(libraryName, "autowrap_csharp_Bool_AppendSlice");
    rangeDef.functions ~= externFuncString.format("slice", "Bool_AppendSlice", "slice dslice, slice array");
    rangeDef.constructors ~= "            if (typeof(T) == typeof(bool)) this._slice = RangeFunctions.Bool_Create(new IntPtr(capacity));" ~ newline;
    rangeDef.enumerators ~= "                if (typeof(T) == typeof(bool)) yield return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.getters ~= "                if (typeof(T) == typeof(bool)) return (T)(object)RangeFunctions.Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.setters ~= "                if (typeof(T) == typeof(bool)) RangeFunctions.Bool_Set(_slice, new IntPtr(i), (bool)(object)value);" ~ newline;
    rangeDef.sliceEnd ~= "            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), _slice.length));" ~ newline;
    rangeDef.sliceRange ~= "            if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.Bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)));" ~ newline;
    rangeDef.appendValues ~= "            if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.Bool_AppendValue(range._slice, (bool)(object)value); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.Bool_AppendSlice(range._slice, source._slice); return range; }" ~ newline;

    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) yield return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) _strings[(int)i] = (string)(object)value;" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { foreach(T s in source) range._strings.Add((string)(object)s); return range; }" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { range._strings.Add((string)(object)value); return range; }" ~ newline;

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

    return "namespace Autowrap {
    using System;
    using System.CodeDom.Compiler;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct slice {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    internal enum DStringType : int {
        None = 0,
        _string = 1,
        _wstring = 2,
        _dstring = 4,
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    public abstract class DLangObject {
        private readonly IntPtr _ptr;
        internal protected IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        ~DLangObject() {
            SharedFunctions.ReleaseMemory(_ptr);
        }
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        private slice _error;
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator bool(return_bool_error ret) { ret.EnsureValid(); return ret._value; }
        [MarshalAs(UnmanagedType.Bool)] public bool _value;
        private slice _error;
    }

    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        private void EnsureValid() {
            var errStr = SharedFunctions.SliceToString(_error, DStringType._wstring);
            if (!string.IsNullOrEmpty(errStr)) throw new DLangException(errStr);
        }
        public static implicit operator slice(return_slice_error ret) { ret.EnsureValid(); return ret._value; }
        private slice _value;
        private slice _error;
    }

%3$s    [GeneratedCodeAttribute(\"Autowrap\", \"1.0.0.0\")]
    internal static class SharedFunctions {
        static SharedFunctions() {
            Stream stream = null;
            var outputName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? \"lib%1$s.dylib\" : RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? \"lib%1$s.so\" : \"%1$s.dll\";

            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(\"%2$s.lib%1$s.dylib\");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(\"%2$s.lib%1$s.x64.so\");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(\"%2$s.lib%1$s.x86.so\");
            }
            if (Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(\"%2$s.%1$s.x64.dll\");
            }
            if (!Environment.Is64BitProcess && RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(\"%2$s.%1$s.x86.dll\");
            }
            if (stream != null) {
                using(var file = new FileStream(outputName, FileMode.OpenOrCreate, FileAccess.Write)) {
                    stream.CopyTo(file);
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
                        var ufi = new UnixFileInfo(outputName);
                        ufi.FileAccessPermissions |= FileAccessPermissions.UserExecute | FileAccessPermissions.GroupExecute | FileAccessPermissions.OtherExecute; 
                    }
                }
            } else {
                throw new DllNotFoundException($\"The required native assembly is unavailable for the current operating system and process architecture.\");
            }

            DRuntimeInitialize();
        }

        internal static string SliceToString(slice str, DStringType type) {
            unsafe {
                var bytes = (byte*)str.ptr.ToPointer();
                if (bytes == null) {
                    return null;
                }
                if (type == DStringType._string) {
                    return System.Text.Encoding.UTF8.GetString(bytes, str.length.ToInt32()*(int)type);
                } else if (type == DStringType._wstring) {
                    return System.Text.Encoding.Unicode.GetString(bytes, str.length.ToInt32()*(int)type);
                } else if (type == DStringType._dstring) {
                    return System.Text.Encoding.UTF32.GetString(bytes, str.length.ToInt32()*(int)type);
                } else {
                    throw new UnauthorizedAccessException(\"Unable to convert D string to C# string: Unrecognized string type.\");
                }
            }
        }

        // Support Functions
        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createWString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateWstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createDString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateDstring([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_release\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport(\"%1$s\", EntryPoint = \"rt_init\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();

        [DllImport(\"%1$s\", EntryPoint = \"rt_term\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();
    }

%4$s}".format(libraryName, rootNamespace, returnTypesStr, rangeDef.toString());
}