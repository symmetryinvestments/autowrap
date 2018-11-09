module autowrap.csharp.csharp;

import autowrap.csharp.boilerplate;
import autowrap.csharp.common;
import autowrap.reflection;

import std.ascii;
import std.datetime;
import std.traits;
import std.string;
import std.uuid;

import std.stdio;

private __gshared string[string] returnTypes;
private __gshared csharpNamespace[string] namespaces;
private __gshared csharpRange rangeDef;

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

private class csharpNamespace {
    public string namespace;
    public string functions;
    public csharpAggregate[string] aggregates;

    public this(string ns) {
        namespace = ns;
        functions = string.init;
    }

    public override string toString() {
        char[] ret;
        ret.reserve(1_048_576);
        foreach(csns; namespaces.byValue()) {
            ret ~= "namespace " ~ csns.namespace ~ " {" ~newline;
            ret ~= "    using System;" ~ newline;
            ret ~= "    using System.Collections.Generic;" ~ newline;
            ret ~= "    using System.Linq;" ~ newline;
            ret ~= "    using System.Reflection;" ~ newline;
            ret ~= "    using System.Runtime.InteropServices;" ~ newline;
            ret ~= "    using Autowrap;" ~ newline ~ newline;
            ret ~= "    public static class Functions {" ~ newline;
            ret ~= csns.functions;
            ret ~= "    }" ~ newline ~ newline;
            foreach(agg; aggregates.byValue()) {
                ret ~= agg.toString();
            }
            ret ~= "}" ~ newline;
        }
        return cast(immutable)ret;
    }
}

private class csharpAggregate {
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
        ret.reserve(32_768);
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
        char[] ret;
        ret.reserve(32_768);
        ret ~= "    internal class RangeFunctions {" ~ newline;
        ret ~= functions;
        ret ~= "    }" ~ newline ~ newline;
        ret ~= "    public class Range<T> : IEnumerable<T> {" ~ newline;
        ret ~= "        private slice _slice;" ~ newline;
        ret ~= "        private DStringType _type;" ~ newline;
        ret ~= "        private IList<string> _strings;" ~ newline ~ newline;

        ret ~= "        internal slice ToSlice(DStringType type = DStringType.None) {" ~ newline;
        ret ~= "            if (type == DStringType.None && _strings != null) {" ~ newline;
        ret ~= "                throw new TypeAccessException(\"Cannot pass a range of strings to a non-string range.\");" ~ newline;
        ret ~= "            }" ~ newline;

        ret ~= "            if (_strings == null) {" ~ newline;
        ret ~= "                return _slice;" ~ newline;
        ret ~= "            } else {" ~ newline;
        ret ~= "                _type = type;" ~ newline;
        ret ~= "                if (_type == DStringType._string) {" ~ newline;
        ret ~= "                    _slice = RangeFunctions.dlang_slice_String_Create(new IntPtr(_strings.Count()));" ~ newline;
        ret ~= "                    foreach(var s in _strings) {" ~ newline;
        ret ~= "                        _slice = RangeFunctions.dlang_slice_String_AppendValue(_slice, SharedFunctions.CreateString(s));" ~ newline;
        ret ~= "                    }" ~ newline;
        ret ~= "                } else if (_type == DStringType._wstring) {" ~ newline;
        ret ~= "                    _slice = RangeFunctions.dlang_slice_Wstring_Create(new IntPtr(_strings.Count()));" ~ newline;
        ret ~= "                    foreach(var s in _strings) {" ~ newline;
        ret ~= "                        _slice = RangeFunctions.dlang_slice_Wstring_AppendValue(_slice, SharedFunctions.CreateWString(s));" ~ newline;
        ret ~= "                    }" ~ newline;
        ret ~= "                } else if (_type == DStringType._dstring) {" ~ newline;
        ret ~= "                    _slice = RangeFunctions.dlang_slice_Dstring_Create(new IntPtr(_strings.Count()));" ~ newline;
        ret ~= "                    foreach(var s in _strings) {" ~ newline;
        ret ~= "                        _slice = RangeFunctions.dlang_slice_Dstring_AppendValue(_slice, SharedFunctions.CreateDString(s));" ~ newline;
        ret ~= "                    }" ~ newline;
        ret ~= "                }" ~ newline;
        ret ~= "                _strings = null;" ~ newline;
        ret ~= "                return _slice;" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public long Length => _strings?.Count ?? _slice.length.ToInt64();" ~ newline;

        ret ~= "        internal Range(slice range, DStringType type = DStringType.None) {" ~ newline;
        ret ~= "            this._slice = range;" ~ newline;
        ret ~= "            this._type = type;" ~ newline;
        ret ~= "        }" ~ newline ~ newline;

        ret ~= "        public Range(IEnumerable<string> strings) {" ~ newline;
        ret ~= "            this._strings = new List<string>(strings);" ~ newline;
        ret ~= "        }" ~ newline ~ newline;

        ret ~= "        public Range(long capacity = 0) {" ~ newline;
        ret ~= constructors;
        ret ~= "            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        ~Range() {" ~ newline;
        ret ~= "            SharedFunctions.ReleaseMemory(_slice.ptr);" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public T this[long i] {" ~ newline;
        ret ~= "            get {" ~ newline;
        ret ~= getters;
        ret ~= "                else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= "            set {" ~ newline;
        ret ~= setters;
        ret ~= "            }" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public Range<T> Slice(long begin) {" ~ newline;
        ret ~= sliceEnd;
        ret ~= "            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public Range<T> Slice(long begin, long end) {" ~ newline;
        ret ~= "            if (end > _slice.length.ToInt64()) {" ~ newline;
        ret ~= "                throw new IndexOutOfRangeException(\"Value for parameter 'end' is greater than that length of the slice.\");" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= sliceRange;
        ret ~= "            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public static Range<T> operator +(Range<T> range, T value) {" ~ newline;
        ret ~= appendValues;
        ret ~= "            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public static Range<T> operator +(Range<T> range, Range<T> source) {" ~ newline;
        ret ~= appendArrays;
        ret ~= "            else throw new TypeAccessException($\"Range does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public IEnumerator<T> GetEnumerator() {" ~ newline;
        ret ~= "            for(long i = 0; i < _slice.length.ToInt64(); i++) {" ~ newline;
        ret ~= enumerators;
        ret ~= "            }" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public static implicit operator T[](Range<T> slice) {" ~ newline;
        ret ~= "            return slice.ToArray();" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public static implicit operator Range<T>(T[] array) {" ~ newline;
        ret ~= "            var vs = new Range<T>(array.Length);" ~ newline;
        ret ~= "            foreach(var t in array) {" ~ newline;
        ret ~= "                vs += t;" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= "            return vs;" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public static implicit operator List<T>(Range<T> slice) {" ~ newline;
        ret ~= "            return new List<T>(slice.ToArray());" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public static implicit operator Range<T>(List<T> array) {" ~ newline;
        ret ~= "            var vs = new Range<T>(array.Count);" ~ newline;
        ret ~= "            foreach(var t in array) {" ~ newline;
        ret ~= "                vs += t;" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= "            return vs;" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();" ~ newline ~ newline;
        ret ~= "    }" ~ newline;
        return cast(immutable)ret;
    }
}

public string writeCSharpFile(Modules...)(string libraryName, string rootNamespace) if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    generateSliceBoilerplate(libraryName);

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        const string aggName = __traits(identifier, agg);
        alias fqn = fullyQualifiedName!agg;
        csharpAggregate csagg = getAggregate(getCSharpName(modName), getCSharpName(aggName), !is(agg == class));

        //Generate range creation method
        generateRangeDef!agg(libraryName);

        static if(hasMember!(agg, "__ctor")) {
            alias constructors = AliasSeq!(__traits(getOverloads, agg, "__ctor"));
        } else {
            alias constructors = AliasSeq!();
        }

        //Generate constructor methods
        foreach(c; constructors) {
            alias paramNames = ParameterIdentifierTuple!c;
            alias paramTypes = Parameters!c;
            const string interfaceName = getDLangInterfaceName(fqn, "__ctor");
            const string methodName = getCSharpMethodInterfaceName(aggName, "__ctor");
            string ctor = "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, interfaceName) ~ newline;
            if (is(agg == class)) {
                ctor ~= "        private static extern IntPtr dlang_%s(".format(methodName);
            } else if (is(agg == struct)) {
                ctor ~= "        private static extern %s dlang_%s(".format(methodName);
            }
            static foreach(pc; 0..paramNames.length) {
                if (is(paramTypes[pc] == bool)) ctor ~= "[MarshalAs(UnmanagedType.Bool)]";
                ctor ~= getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
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
            if (is(agg == class)) {
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
            } else if (is(agg == struct)) {
            }
            ctor ~= "}" ~ newline;
            csagg.constructors ~= ctor;
        }
        if (is(agg == class)) {
            csagg.constructors ~= "        internal %s(IntPtr ptr) : base(ptr) { }".format(getCSharpName(aggName)) ~ newline;
        }

        foreach(m; __traits(allMembers, agg)) {
            if (m == "__ctor" || m == "toHash" || m == "opEquals" || m == "opCmp" || m == "factory") {
                continue;
            }
            const string methodName = camelToPascalCase(cast(string)m);
            const string methodInterfaceName = getCSharpMethodInterfaceName(aggName, cast(string)m);

            static if (is(typeof(__traits(getMember, agg, m)))) {
            foreach(mo; __traits(getOverloads, agg, m)) {
                static if(isFunction!mo) {
                    string exp = string.init;
                    enum bool isNothrow = cast(bool)(functionAttributes!mo & FunctionAttribute.nothrow_);
                    enum bool isProperty = cast(bool)(functionAttributes!mo & FunctionAttribute.property);
                    alias returnType = ReturnType!mo;
                    alias returnTypeStr = fullyQualifiedName!returnType;
                    alias paramTypes = Parameters!mo;
                    alias paramNames = ParameterIdentifierTuple!mo;

                    const string interfaceName = getDLangInterfaceName(fqn, m);

                    exp ~= "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, interfaceName) ~ newline;
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
                    if (is(agg == struct)) {
                        exp ~= "ref " ~ getDLangInterfaceType(fqn) ~ " __obj__, ";
                    } else if (is(agg == class) || is(agg == interface)) {
                        exp ~= "IntPtr __obj__, ";
                    }
                    static foreach(pc; 0..paramNames.length) {
                        exp ~= getDLangInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
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
                        if (is(agg == class)) {
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
                                exp ~= "SharedFunctions.CreateWString(" ~ paramNames[pc] ~ "), ";
                            } else static if (is(paramTypes[pc] == dstring)) {
                                exp ~= "SharedFunctions.CreateDString(" ~ paramNames[pc] ~ "), ";
                            } else {
                                exp ~= paramNames[pc] ~ ", ";
                            }
                        }
                        exp = exp[0..$-2];
                        exp ~= ");" ~ newline;
                        if (!isNothrow) {
                            exp ~= "            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);" ~ newline;
                            if (!is(returnType == void)) {
                                if (is(returnType == string)) {
                                    exp ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._string);" ~ newline;
                                } else if (is(returnType == wstring)) {
                                    exp ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._wstring);" ~ newline;
                                } else if (is(returnType == dstring)) {
                                    exp ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._dstring);" ~ newline;
                                } else {
                                    exp ~= "            return dlang_ret.value;" ~ newline;
                                }
                            }
                        } else {
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
                        }
                        exp ~= "        }" ~ newline;
                    }
                    csagg.methods ~= exp;
                }
            }

            bool isProperty = false;
            bool propertyGet = false;
            bool propertySet = false;
            bool propertyNoThrow = false;
            foreach(mo; __traits(getOverloads, agg, m)) {
            static if (cast(bool)(functionAttributes!mo & FunctionAttribute.property)) {
                isProperty = true;
                alias returnType = ReturnType!mo;
                alias paramTypes = Parameters!mo;
                if (paramTypes.length == 0) {
                    propertyGet = true;
                    static if (cast(bool)(functionAttributes!mo & FunctionAttribute.nothrow_)) {
                        propertyNoThrow = true;
                    }
                } else {
                    propertySet = true;
                }
            }
            }

            const olc = __traits(getOverloads, agg, m).length;
            static if(olc > 0) {
            if (isProperty) {
                string prop = string.init;
                alias propertyType = ReturnType!(__traits(getOverloads, agg, m)[0]);
                if (isArray!(propertyType)) {
                    prop = "        public Range<" ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ "> " ~ methodName ~ " { ";
                } else {
                    prop = "        public " ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ " " ~ methodName ~ " { ";
                }
                if (propertyGet) {
                    if (isArray!(propertyType)) {
                        prop ~= "get => new Range<%4$s>(dlang_%1$s(%3$s)%2$s); ".format(methodInterfaceName, !propertyNoThrow ? ".value" : string.init, is(agg == class) ? "DLangPointer" : "ref this", getCSharpInterfaceType(fullyQualifiedName!propertyType));
                    } else {
                        prop ~= "get => dlang_%1$s(%3$s)%2$s; ".format(methodInterfaceName, !propertyNoThrow ? ".value" : string.init, is(agg == class) ? "DLangPointer" : "ref this");
                    }
                }
                if (propertySet) {
                    if (isArray!(propertyType)) {
                        prop ~= "set => dlang_%1$s(%2$s, value.ToSlice()); ".format(methodInterfaceName, is(agg == class) ? "DLangPointer" : "ref this");
                    } else {
                        prop ~= "set => dlang_%1$s(%2$s, value); ".format(methodInterfaceName, is(agg == class) ? "DLangPointer" : "ref this");
                    }
                }
                prop ~= "}" ~ newline;
                csagg.properties ~= prop;
            }
            }
            }
        }

        alias fieldTypes = Fields!agg;
        alias fieldNames = FieldNameTuple!agg;
        if (is(agg == class) || is(agg == interface)) {
            static foreach(fc; 0..fieldTypes.length) {
                static if (is(typeof(__traits(getMember, agg, fieldNames[fc])))) {
                    csagg.properties ~= "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_get")) ~ newline;
                    csagg.properties ~= "        private static extern %s dlang_%s_get(IntPtr ptr);".format(getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc])), fieldNames[fc]) ~ newline;
                    csagg.properties ~= "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangInterfaceName(fqn, fieldNames[fc] ~ "_set")) ~ newline;
                    csagg.properties ~= "        private static extern void dlang_%s_set(IntPtr ptr, %s value);".format(fieldNames[fc], getDLangInterfaceType(fullyQualifiedName!(fieldTypes[fc]))) ~ newline;
                    if (is(fieldTypes[fc] == string)) {
                        csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._string); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateString(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (is(fieldTypes[fc] == wstring)) {
                        csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._wstring); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateWString(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (is(fieldTypes[fc] == dstring)) {
                        csagg.properties ~= "        public %2$s %3$s { get => SharedFunctions.SliceToString(dlang_%1$s_get(DLangPointer), DStringType._dstring); set => dlang_%1$s_set(DLangPointer, SharedFunctions.CreateDString(value)); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (isArray!(fieldTypes[fc])) {
                        csagg.properties ~= "        public Range<%2$s> %3$s { get => new Range<%2$s>(dlang_%1$s_get(DLangPointer)); set => dlang_%1$s_set(DLangPointer, value.ToSlice()); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else {
                        csagg.properties ~= "        public %2$s %3$s { get => dlang_%1$s_get(DLangPointer); set => dlang_%1$s_set(DLangPointer, value); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    }
                }
            }
        } else if(is(agg == struct)) {
            static foreach(fc; 0..fieldTypes.length) {
                static if (is(typeof(__traits(getMember, agg, fieldNames[fc])))) {
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

    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;
        csharpNamespace ns = getNamespace(getCSharpName(modName));

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
        if (!isNothrow) {
            funcStr ~= "            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);" ~ newline;
            if (!is(returnType == void)) {
                if (is(returnType == string)) {
                    funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._string);" ~ newline;
                } else if (is(returnType == wstring)) {
                    funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._wstring);" ~ newline;
                } else if (is(returnType == dstring)) {
                    funcStr ~= "            return SharedFunctions.SliceToString(dlang_ret.value, DStringType._dstring);" ~ newline;
                } else if (isArray!(returnType)) {
                    funcStr ~= "            return new Range<%s>(dlang_ret.value);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
                } else {
                    funcStr ~= "            return dlang_ret.value;" ~ newline;
                }
            }
        } else {
            if (!is(returnType == void)) {
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
        }
        funcStr ~= "        }" ~ newline;
        ns.functions ~= funcStr;
    }

    char[] ret;
    ret.reserve(33_554_432);
    foreach(csns; namespaces.byValue()) {
        ret ~= csns.toString();
    }

    ret ~= newline ~ writeCSharpBoilerplate(libraryName, rootNamespace);

    return cast(immutable)ret;
}

private string getDLangInterfaceType(string type) {
    //Types that require special marshalling types
    if (type[$-2..$] == "[]") return "slice";
    else if (type == stringTypeString) return "slice";
    else if (type == wstringTypeString) return "slice";
    else if (type == dstringTypeString) return "slice";
    else if (type == boolTypeString) return "bool";
    //else if (type == dateTimeTypeString) return "datetime";
    //else if (type == sysTimeTypeString) return "systime";
    //else if (type == uuidTypeString) return "uuid";

    //Types that can be marshalled by default
    else if (type == charTypeString) return "byte";
    else if (type == wcharTypeString) return "char";
    else if (type == dcharTypeString) return "uint";
    else if (type == ubyteTypeString) return "byte";
    else if (type == byteTypeString) return "sbyte";
    else if (type == ushortTypeString) return "ushort";
    else if (type == shortTypeString) return "short";
    else if (type == uintTypeString) return "uint";
    else if (type == intTypeString) return "int";
    else if (type == ulongTypeString) return "ulong";
    else if (type == longTypeString) return "long";
    else if (type == floatTypeString) return "float";
    else if (type == doubleTypeString) return "double";
    else return getCSharpName(type);
}

private string getCSharpInterfaceType(string type) {
    //Types that require special marshalling types
    if (type[$-2..$] == "[]") type = type[0..$-2];
    if(type == voidTypeString) return "void";
    else if(type == stringTypeString) return "string";
    else if (type == wstringTypeString) return "string";
    else if (type == dstringTypeString) return "string";
    else if (type == boolTypeString) return "bool";
    //else if (type == dateTimeTypeString) return "DateTime";
    //else if (type == sysTimeTypeString) return "DateTimeOffset";
    //else if (type == uuidTypeString) return "Guid" 

    //Types that can be marshalled by default
    else if (type == charTypeString) return "byte";
    else if (type == wcharTypeString) return "char";
    else if (type == dcharTypeString) return "uint";
    else if (type == ubyteTypeString) return "byte";
    else if (type == byteTypeString) return "sbyte";
    else if (type == ushortTypeString) return "ushort";
    else if (type == shortTypeString) return "short";
    else if (type == uintTypeString) return "uint";
    else if (type == intTypeString) return "int";
    else if (type == ulongTypeString) return "ulong";
    else if (type == longTypeString) return "long";
    else if (type == floatTypeString) return "float";
    else if (type == doubleTypeString) return "double";
    else return getCSharpName(type);
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

        string typeStr = "    [StructLayout(LayoutKind.Sequential)]" ~ newline;
        typeStr ~= "    internal struct %s {".format(rtname) ~ newline;
        if (isClass) {
            typeStr ~= "        private IntPtr _value;" ~ newline;
            typeStr ~= "        public %1$s value => new %1$s(_value);".format(getCSharpInterfaceType(type)) ~ newline;
        } else {
            typeStr ~= "        public %s value;".format(getCSharpInterfaceType(type)) ~ newline;
        }
        typeStr ~= "        private slice _error;" ~ newline;
        typeStr ~= "        public string error => SharedFunctions.SliceToString(_error, DStringType._wstring);" ~ newline;
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
    string name = "return_";

    string[] parts = aggName.toLower().split(".");
    foreach(string p; parts) {
        name ~= p ~ "_";
    }
    return name ~ "error";
}

private string getCSharpName(string dlangName) {
    import std.string : split;
    string[] parts = dlangName.split(".");
    string ns = string.init;
    foreach(string p; parts) {
        ns ~= camelToPascalCase(p) ~ ".";
    }
    ns = ns[0..$-1];
    return ns;
}

private csharpNamespace getNamespace(string name) {
    return namespaces.require(name, new csharpNamespace(name));
}

private csharpAggregate getAggregate(string namespace, string name, bool isStruct) {
    csharpNamespace ns = namespaces.require(namespace, new csharpNamespace(namespace));
    return ns.aggregates.require(name, new csharpAggregate(name, isStruct));
}

private void generateRangeDef(T)(string libraryName) {
    alias fqn = fullyQualifiedName!T;
    const string csn = getCSharpName(fqn);

    rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Create")) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_%1$s(IntPtr capacity);".format(getCSharpMethodInterfaceName(fqn, "Create")) ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Get")) ~ newline;
    rangeDef.functions ~= "        internal static extern %2$s dlang_slice_%1$s(slice dslice, IntPtr index);".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Slice")) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, IntPtr begin, IntPtr end);".format(getCSharpMethodInterfaceName(fqn, "Slice")) ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "AppendSlice")) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, slice array);".format(getCSharpMethodInterfaceName(fqn, "AppendSlice")) ~ newline;
    if (is(T == class) || is(T == interface)) {
        rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Set")) ~ newline;
        rangeDef.functions ~= "        internal static extern void dlang_slice_%1$s(slice dslice, IntPtr index, IntPtr value);".format(getCSharpMethodInterfaceName(fqn, "Set")) ~ newline;
        rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue")) ~ newline;
        rangeDef.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, IntPtr value);".format(getCSharpMethodInterfaceName(fqn, "AppendValue")) ~ newline;
    } else {
        rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Set")) ~ newline;
        rangeDef.functions ~= "        internal static extern void dlang_slice_%1$s(slice dslice, IntPtr index, %2$s value);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "AppendValue")) ~ newline;
        rangeDef.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, %2$s value);".format(getCSharpMethodInterfaceName(fqn, "AppendValue"), getCSharpInterfaceType(fqn)) ~ newline;
    }
    rangeDef.constructors ~= "            else if (typeof(T) == typeof(%2$s)) this._slice = RangeFunctions.dlang_slice_%1$s(new IntPtr(capacity));".format(getCSharpMethodInterfaceName(fqn, "Create"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(%2$s)) yield return (T)(object)RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(%2$s)) return (T)(object)RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(%2$s)) return new Range<T>(RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(begin), _slice.length));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(%2$s)) return new Range<T>(RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(begin), new IntPtr(end)));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.dlang_slice_%1$s(range._slice, source._slice); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendSlice"), getCSharpInterfaceType(fqn)) ~ newline;
    if (is(T == class) || is(T == interface)) {
        rangeDef.setters ~= "                else if (typeof(T) == typeof(%2$s)) RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(i), ((DLangObject)(object)value).DLangPointer);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.appendValues ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.dlang_slice_%1$s(range._slice, ((DLangObject)(object)value).DLangPointer); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendValue"), getCSharpInterfaceType(fqn)) ~ newline;
    } else {
        rangeDef.setters ~= "                else if (typeof(T) == typeof(%2$s)) RangeFunctions.dlang_slice_%1$s(_slice, new IntPtr(i), (%2$s)(object)value);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
        rangeDef.appendValues ~= "            else if (typeof(T) == typeof(%2$s)) { range._slice = RangeFunctions.dlang_slice_%1$s(range._slice, (%2$s)(object)value); return range; }".format(getCSharpMethodInterfaceName(fqn, "AppendValue"), getCSharpInterfaceType(fqn)) ~ newline;
    }
}

private void generateSliceBoilerplate(string libraryName) {
    rangeDef.enumerators ~= "                if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) yield return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_String_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_Wstring_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) yield return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_Dstring_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.getters ~= "                if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return (T)(object)_strings[(int)i];" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_String_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_Wstring_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return (T)(object)SharedFunctions.SliceToString(RangeFunctions.dlang_slice_Dstring_Get(_slice, new IntPtr(i)), DStringType._string);" ~ newline;
    rangeDef.setters ~= "                if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) _strings[(int)i] = (string)(object)value;" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) RangeFunctions.dlang_slice_String_Set(_slice, new IntPtr(i), SharedFunctions.CreateString((string)(object)value));" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) RangeFunctions.dlang_slice_Wstring_Set(_slice, new IntPtr(i), SharedFunctions.CreateWString((string)(object)value));" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) RangeFunctions.dlang_slice_Dstring_Set(_slice, new IntPtr(i), SharedFunctions.CreateDString((string)(object)value));" ~ newline;
    rangeDef.sliceEnd ~= "            if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.dlang_slice_String_Slice(_slice, new IntPtr(begin), _slice.length), _type);" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.dlang_slice_Wstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), _slice.length), _type);" ~ newline;
    rangeDef.sliceRange ~= "            if (typeof(T) == typeof(string) && _strings != null && _type == DStringType.None) return new Range<T>(_strings.Skip((int)begin));" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._string) return new Range<T>(RangeFunctions.dlang_slice_String_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._wstring) return new Range<T>(RangeFunctions.dlang_slice_Wstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(string) && _strings == null && _type == DStringType._dstring) return new Range<T>(RangeFunctions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)), _type);" ~ newline;
    rangeDef.appendValues ~= "            if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { range._strings.Add((string)(object)value); return range; }" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._string) { range._slice = RangeFunctions.dlang_slice_String_AppendValue(range._slice, SharedFunctions.CreateString((string)(object)value)); return range; }" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._wstring) { range._slice = RangeFunctions.dlang_slice_Wstring_AppendValue(range._slice, SharedFunctions.CreateWString((string)(object)value)); return range; }" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._dstring) { range._slice = RangeFunctions.dlang_slice_Dstring_AppendValue(range._slice, SharedFunctions.CreateDString((string)(object)value)); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            if (typeof(T) == typeof(string) && range._strings != null && range._type == DStringType.None) { foreach(T s in source) range._strings.Add((string)(object)s); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._string) { range._slice = RangeFunctions.dlang_slice_String_AppendSlice(range._slice, source._slice); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._wstring) { range._slice = RangeFunctions.dlang_slice_Wstring_AppendSlice(range._slice, source._slice); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(string) && range._strings == null && range._type == DStringType._dstring) { range._slice = RangeFunctions.dlang_slice_Dstring_AppendSlice(range._slice, source._slice); return range; }" ~ newline;

    //string
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_String_Create(IntPtr capacity);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_String_Get(slice dslice, IntPtr index);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern void dlang_slice_String_Set(slice dslice, IntPtr index, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_String_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_AppendValue\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_String_AppendValue(slice dslice, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_String_AppendSlice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_String_AppendSlice(slice dslice, slice array);" ~ newline;

    //wstring
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Wstring_Create(IntPtr capacity);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Wstring_Get(slice dslice, IntPtr index);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern void dlang_slice_Wstring_Set(slice dslice, IntPtr index, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Wstring_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_AppendValue\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Wstring_AppendValue(slice dslice, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Wstring_AppendSlice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Wstring_AppendSlice(slice dslice, slice array);" ~ newline;

    //dstring
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Dstring_Create(IntPtr capacity);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Dstring_Get(slice dslice, IntPtr index);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern void dlang_slice_Dstring_Set(slice dslice, IntPtr index, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Dstring_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_AppendValue\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Dstring_AppendValue(slice dslice, slice value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_AppendSlice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Dstring_AppendSlice(slice dslice, slice array);" ~ newline;

    //bool
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Bool_Create(IntPtr capacity);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        [return: MarshalAs(UnmanagedType.Bool)]" ~ newline;
    rangeDef.functions ~= "        internal static extern bool dlang_slice_Bool_Get(slice dslice, IntPtr index);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern void dlang_slice_Bool_Set(slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Bool_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_AppendValue\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Bool_AppendValue(slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value);" ~ newline;
    rangeDef.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_AppendSlice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    rangeDef.functions ~= "        internal static extern slice dlang_slice_Bool_AppendSlice(slice dslice, slice array);" ~ newline;
    rangeDef.constructors ~= "            if (typeof(T) == typeof(bool)) this._slice = RangeFunctions.dlang_slice_Bool_Create(new IntPtr(capacity));" ~ newline;
    rangeDef.enumerators ~= "                else if (typeof(T) == typeof(bool)) yield return (T)(object)RangeFunctions.dlang_slice_Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.getters ~= "                else if (typeof(T) == typeof(bool)) return (T)(object)RangeFunctions.dlang_slice_Bool_Get(_slice, new IntPtr(i));" ~ newline;
    rangeDef.setters ~= "                else if (typeof(T) == typeof(bool)) RangeFunctions.dlang_slice_Bool_Set(_slice, new IntPtr(i), (bool)(object)value);" ~ newline;
    rangeDef.sliceEnd ~= "            else if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.dlang_slice_Bool_Slice(_slice, new IntPtr(begin), _slice.length));" ~ newline;
    rangeDef.sliceRange ~= "            else if (typeof(T) == typeof(bool)) return new Range<T>(RangeFunctions.dlang_slice_Bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)));" ~ newline;
    rangeDef.appendValues ~= "            else if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.dlang_slice_Bool_AppendValue(range._slice, (bool)(object)value); return range; }" ~ newline;
    rangeDef.appendArrays ~= "            else if (typeof(T) == typeof(bool)) { range._slice = RangeFunctions.dlang_slice_Bool_AppendSlice(range._slice, source._slice); return range; }" ~ newline;

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

//This needs to be written last
private string writeCSharpBoilerplate(string libraryName, string rootNamespace) {
    string returnTypesStr = string.init;
    foreach(string rt; returnTypes.byValue) {
        returnTypesStr ~= rt;
    }

    return "namespace Autowrap {
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using Mono.Unix;

    public class DLangException : Exception {
        public string DLangExceptionText { get; }
        public DLangException(string dlang) : base() {
            DLangExceptionText = dlang;
        }
    }

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

    internal enum DStringType : int {
        None = 0,
        _string = 1,
        _wstring = 2,
        _dstring = 4,
    }

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

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        private slice _error;
        public string error => SharedFunctions.SliceToString(_error, DStringType._wstring);
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        [MarshalAs(UnmanagedType.Bool)] public bool value;
        private slice _error;
        public string error => SharedFunctions.SliceToString(_error, DStringType._wstring);
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        public slice value;
        private slice _error;
        public string error => SharedFunctions.SliceToString(_error, DStringType._wstring);
    }

%3$s    internal static class SharedFunctions {
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
        internal static extern slice CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createDString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern slice CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_release\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport(\"%1$s\", EntryPoint = \"rt_init\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();

        [DllImport(\"%1$s\", EntryPoint = \"rt_term\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();
    }

%4$s}".format(libraryName, rootNamespace, returnTypesStr, rangeDef.toString());
}