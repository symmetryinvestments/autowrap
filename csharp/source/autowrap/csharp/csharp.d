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
private __gshared csharpSlice valueSlice;
private __gshared csharpSlice refSlice;

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
            ret ~= "    using System.Collections;" ~ newline;
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

public struct csharpSlice {
    public string constructors = string.init;
    public string enumerators = string.init;
    public string functions = string.init;
    public string getters = string.init;
    public string setters = string.init; 
    public string appendValues = string.init;
    public string appendArrays = string.init;
    public string sliceEnd = string.init;
    public string sliceRange = string.init;

    public string toString(bool isRef) {
        char[] ret;
        ret.reserve(32_768);
        if (isRef) {
            ret ~= "    public class RefSlice<T> : IEnumerable<T> where T : DLangObject {" ~ newline;
        } else {
            ret ~= "    public class ValueSlice<T> : IEnumerable<T> where T : struct {" ~ newline;
        }
        ret ~= "        private readonly slice _slice;" ~ newline;
        ret ~= "        internal %sSlice(slice dslice) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= "            this._slice = dslice;" ~ newline; 
        ret ~= "        }" ~ newline;
        ret ~= "        internal slice ToSlice() => _slice;" ~ newline;
        ret ~= "        public long Length => _slice.length.ToInt64();" ~ newline  ~ newline;
        ret ~= "        public %sSlice(long capacity = 0) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= constructors;
        ret ~= "            throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public T this[long i] {" ~ newline;
        ret ~= "            get {" ~ newline;
        ret ~= getters;
        ret ~= "                throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= "            set {" ~ newline;
        ret ~= setters;
        ret ~= "            }" ~ newline;
        ret ~= "        }" ~ newline;
        ret ~= "        public %sSlice<T> Slice(long begin) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= sliceEnd;
        ret ~= "            throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public %sSlice<T> Slice(long begin, long end) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= "            if (end > _slice.length.ToInt64()) {" ~ newline;
        ret ~= "                throw new IndexOutOfRangeException(\"Value for parameter 'end' is greater than that length of the slice.\");" ~ newline;
        ret ~= "            }" ~ newline;
        ret ~= sliceRange;
        ret ~= "            throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public static %1$sSlice<T> operator +(%1$sSlice<T> dslice, T value) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= appendValues;
        ret ~= "            throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public static %1$sSlice<T> operator +(%1$sSlice<T> dslice, %1$sSlice<T> value) {".format(isRef ? "Ref" : "Value") ~ newline;
        ret ~= appendArrays;
        ret ~= "            throw new TypeAccessException($\"Slice does not support type: {typeof(T).ToString()}\");" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        public IEnumerator<T> GetEnumerator() {" ~ newline;
        ret ~= "            for(long i = 0; i < _slice.length.ToInt64(); i++) {" ~ newline;
        ret ~= enumerators;
        ret ~= "            }" ~ newline;
        ret ~= "        }" ~ newline ~ newline;
        ret ~= "        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();" ~ newline;
        ret ~= "    }" ~ newline;
        return cast(immutable)ret;
    }
}

public string writeCSharpFile(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string libraryName ="csharp";
    generateValueSliceBoilerplate(libraryName);

    foreach(agg; AllAggregates!Modules) {
        alias modName = moduleName!agg;
        const string aggName = __traits(identifier, agg);
        alias fqn = fullyQualifiedName!agg;
        csharpAggregate csagg = getAggregate(getCSharpName(modName), getCSharpName(aggName), !is(agg == class));

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
                    ctor ~= paramNames[pc] ~ ", ";
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
            csagg.constructors ~= "        private %s(IntPtr ptr) : base(ptr) { }".format(getCSharpName(aggName)) ~ newline;
        }

        //Generate range creation method
        if (is(agg == class)) {
            generateRefSlice!agg(libraryName);
        } else if (is(agg == struct)) {
            generateValueSlice!agg(libraryName);
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
                        exp ~= getDLangReturnType(returnTypeStr, isNothrow);
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
                            pragma(msg, paramTypes[pc])
                            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                                exp ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
                            } else if (isArray!(paramTypes[pc]) && (is(ArrayElementType!(paramTypes[pc]) == string) || is(ArrayElementType!(paramTypes[pc]) == wstring) || is(ArrayElementType!(paramTypes[pc]) == dstring))) {
                                exp ~= "StringSlice " ~ paramNames[pc] ~ ", ";
                            } else if (isArray!(paramTypes[pc]) && is(ArrayElementType!(paramTypes[pc]) == class)) {
                                exp ~= "RefSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
                            } else if (isArray!(paramTypes[pc]) && is(ArrayElementType!(paramTypes[pc]) == struct)) {
                                exp ~= "ValueSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
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
                            exp ~= paramNames[pc] ~ ", ";
                        }
                        exp = exp[0..$-2];
                        exp ~= ");" ~ newline;
                        if (!isNothrow) {
                            exp ~= "            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);" ~ newline;
                            if (!is(returnType == void)) {
                                exp ~= "            return dlang_ret.value;" ~ newline;
                            }
                        } else {
                            if (!is(returnType == void)) {
                                exp ~= "            return dlang_ret;" ~ newline;
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
                if (isArray!(propertyType) && (is(ArrayElementType!(propertyType) == string) || is(ArrayElementType!(propertyType) == wstring) || is(ArrayElementType!(propertyType) == dstring))) {
                    prop = "        public StringSlice " ~ methodName ~ " { ";
                } else if (isArray!(propertyType) && is(ArrayElementType!(propertyType) == class)) {
                    prop = "        public RefSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ "> " ~ methodName ~ " { ";
                } else if (isArray!(propertyType)) {
                    prop = "        public ValueSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ "> " ~ methodName ~ " { ";
                } else {
                    prop = "        public " ~ getCSharpInterfaceType(fullyQualifiedName!propertyType) ~ " " ~ methodName ~ " { ";
                }
                if (propertyGet) {
                    if (isArray!(propertyType) && (is(ArrayElementType!(propertyType) == string) || is(ArrayElementType!(propertyType) == wstring) || is(ArrayElementType!(propertyType) == dstring))) {
                        prop ~= "get => new StringSlice(dlang_%1$s(%3$s)%2$s); ".format(methodInterfaceName, !propertyNoThrow ? ".value" : string.init, is(agg == class) ? "DLangPointer" : "ref this");
                    } else if (isArray!(propertyType) && is(ArrayElementType!(propertyType) == class)) {
                        prop ~= "get => new RefSlice<%4$s>(dlang_%1$s(%3$s)%2$s); ".format(methodInterfaceName, !propertyNoThrow ? ".value" : string.init, is(agg == class) ? "DLangPointer" : "ref this", getCSharpInterfaceType(fullyQualifiedName!propertyType));
                    } else if (isArray!(propertyType)) {
                        prop ~= "get => new ValueSlice<%4$s>(dlang_%1$s(%3$s)%2$s); ".format(methodInterfaceName, !propertyNoThrow ? ".value" : string.init, is(agg == class) ? "DLangPointer" : "ref this", getCSharpInterfaceType(fullyQualifiedName!propertyType));
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
                    if (is(fieldTypes[fc] == string) || is(fieldTypes[fc] == wstring) || is(fieldTypes[fc] == dstring)) {
                        csagg.properties ~= "        public %2$s %3$s { get => dlang_%1$s_get(DLangPointer); set => dlang_%1$s_set(DLangPointer, value); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (isArray!(fieldTypes[fc]) && (is(ArrayElementType!(fieldTypes[fc]) == string) || is(ArrayElementType!(fieldTypes[fc]) == wstring) || is(ArrayElementType!(fieldTypes[fc]) == dstring))) {
                        csagg.properties ~= "        public StringSlice %3$s { get => new StringSlice(dlang_%1$s_get(DLangPointer)); set => dlang_%1$s_set(DLangPointer, value.ToSlice()); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (isArray!(fieldTypes[fc]) && is(ArrayElementType!(fieldTypes[fc]) == class)) {
                        csagg.properties ~= "        public RefSlice<%2$s> %3$s { get => new RefSlice<%2$s>(dlang_%1$s_get(DLangPointer)); set => dlang_%1$s_set(DLangPointer, value.ToSlice()); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else if (isArray!(fieldTypes[fc]) && is(ArrayElementType!(fieldTypes[fc]) == struct)) {
                        csagg.properties ~= "        public ValueSlice<%2$s> %3$s { get => new ValueSlice<%2$s>(dlang_%1$s_get(DLangPointer)); set => dlang_%1$s_set(DLangPointer, value.ToSlice()); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    } else {
                        csagg.properties ~= "        public %2$s %3$s { get => dlang_%1$s_get(DLangPointer); set => dlang_%1$s_set(DLangPointer, value); }".format(fieldNames[fc], getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])), getCSharpName(fieldNames[fc])) ~ newline;
                    }
                }
            }
        } else if(is(agg == struct)) {
            static foreach(fc; 0..fieldTypes.length) {
                static if (is(typeof(__traits(getMember, agg, fieldNames[fc])))) {
                    csagg.properties ~= "        public " ~ getCSharpInterfaceType(fullyQualifiedName!(fieldTypes[fc])) ~ " " ~ getCSharpName(fieldNames[fc]) ~ ";" ~ newline;
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
        string retType = getDLangReturnType(returnTypeStr, isNothrow);
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
        if (isArray!(returnType) && (is(ArrayElementType!(returnType) == string) || is(ArrayElementType!(returnType) == wstring) || is(ArrayElementType!(returnType) == dstring))) {
            funcStr ~= "        public static StringSlice %s(".format(methodName);
        } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == class)) {
            funcStr ~= "        public static RefSlice<%s> %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == struct)) {
            funcStr ~= "        public static ValueSlice<%s> %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        } else {
            funcStr ~= "        public static %s %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        }
        static foreach(pc; 0..paramNames.length) {
            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                funcStr ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
            } else if (isArray!(paramTypes[pc]) && (is(ArrayElementType!(paramTypes[pc]) == string) || is(ArrayElementType!(paramTypes[pc]) == wstring) || is(ArrayElementType!(paramTypes[pc]) == dstring))) {
                funcStr ~= "StringSlice " ~ paramNames[pc] ~ ", ";
            } else if (isArray!(paramTypes[pc]) && is(ArrayElementType!(paramTypes[pc]) == class)) {
                funcStr ~= "RefSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
            } else if (isArray!(paramTypes[pc]) && is(ArrayElementType!(paramTypes[pc]) == struct)) {
                funcStr ~= "ValueSlice<" ~ getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ "> " ~ paramNames[pc] ~ ", ";
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
            if (is(paramTypes[pc] == string) || is(paramTypes[pc] == wstring) || is(paramTypes[pc] == dstring)) {
                funcStr ~= paramNames[pc] ~ ", ";
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
                if (isArray!(returnType) && (is(ArrayElementType!(returnType) == string) || is(ArrayElementType!(returnType) == wstring) || is(ArrayElementType!(returnType) == dstring))) {
                    funcStr ~= "            return new StringSlice(dlang_ret.value);" ~ newline;
                } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == class)) {
                    funcStr ~= "            return new RefSlice<%s>(dlang_ret.value);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
                } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == struct)) {
                    funcStr ~= "            return new ValueSlice<%s>(dlang_ret.value);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
                } else {
                    funcStr ~= "            return dlang_ret.value;" ~ newline;
                }
            }
        } else {
            if (!is(returnType == void)) {
                if (isArray!(returnType) && (is(ArrayElementType!(returnType) == string) || is(ArrayElementType!(returnType) == wstring) || is(ArrayElementType!(returnType) == dstring))) {
                    funcStr ~= "            return new StringSlice(dlang_ret);" ~ newline;
                } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == class)) {
                    funcStr ~= "            return new RefSlice<%s>(dlang_ret);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
                } else if (isArray!(returnType) && is(ArrayElementType!(returnType) == struct)) {
                    funcStr ~= "            return new ValueSlice<%s>(dlang_ret);".format(getCSharpInterfaceType(returnTypeStr)) ~ newline;
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

    ret ~= newline ~ writeCSharpBoilerplate(libraryName, "Kaleidic");

    return cast(immutable)ret;
}

private string getDLangInterfaceType(string type) {
    //Types that require special marshalling types
    if (type[$-2..$] == "[]") return "slice";
    else if (type == stringTypeString) return "dstring";
    else if (type == wstringTypeString) return "dstring";
    else if (type == dstringTypeString) return "dstring";
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

private string getDLangReturnType(string type, bool isNothrow) {
    import std.stdio;
    if(isNothrow) {
        return getDLangInterfaceType(type);
    } else {
        string rtname = getReturnErrorTypeName(getDLangInterfaceType(type));
        //These types have predefined C# types.
        if(type == voidTypeString || type == boolTypeString || type == stringTypeString || type == wstringTypeString || type == dstringTypeString || rtname == "return_slice_error") {
            return rtname;
        }

        const string typeStr = "    [StructLayout(LayoutKind.Sequential)]
    internal struct %s {
        public %s value;
        public dstring error;
    }".format(rtname, getDLangInterfaceType(type)) ~ newline;

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

private void generateValueSlice(T)(string libraryName) {
    alias fqn = fullyQualifiedName!T;
    const string csn = getCSharpName(fqn);

    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Create")) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(IntPtr capacity);".format(getCSharpMethodInterfaceName(fqn, "Create")) ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Get")) ~ newline;
    valueSlice.functions ~= "        internal static extern %2$s dlang_slice_%1$s(slice dslice, IntPtr index);".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Set")) ~ newline;
    valueSlice.functions ~= "        internal static extern void dlang_slice_%1$s(slice dslice, IntPtr index, %2$s value);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Slice")) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, IntPtr begin, IntPtr end);".format(getCSharpMethodInterfaceName(fqn, "Slice")) ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Append")) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, %2$s value);".format(getCSharpMethodInterfaceName(fqn, "Append"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Append")) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, slice array);".format(getCSharpMethodInterfaceName(fqn, "Append")) ~ newline;
    valueSlice.constructors ~= "            else if (typeof(T) == typeof(%2$s)) this._slice = Functions.dlang_slice_%1$s(new IntPtr(capacity));".format(getCSharpMethodInterfaceName(fqn, "Create"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.enumerators ~= "                else if (typeof(T) == typeof(%2$s)) yield return (T)(object)Functions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.getters ~= "                else if (typeof(T) == typeof(%2$s)) return (T)(object)Functions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.setters ~= "                else if (typeof(T) == typeof(%2$s)) Functions.dlang_slice_%1$s(_slice, new IntPtr(i), (%2$s)(object)value);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.sliceEnd ~= "            else if (typeof(T) == typeof(%2$s)) return new ValueSlice<T>(Functions.dlang_slice_%1$s(_slice, new IntPtr(begin), _slice.length));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.sliceRange ~= "            else if (typeof(T) == typeof(%2$s)) return new ValueSlice<T>(Functions.dlang_slice_%1$s(_slice, new IntPtr(begin), new IntPtr(end)));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.appendValues ~= "            else if (typeof(T) == typeof(%2$s)) return new ValueSlice<T>(Functions.dlang_slice_%1$s(dslice._slice, (%2$s)(object)value));".format(getCSharpMethodInterfaceName(fqn, "Append"), getCSharpInterfaceType(fqn)) ~ newline;
    valueSlice.appendArrays ~= "            else if (typeof(T) == typeof(%2$s)) return new ValueSlice<T>(Functions.dlang_slice_%1$s(dslice._slice, value._slice));".format(getCSharpMethodInterfaceName(fqn, "Append"), getCSharpInterfaceType(fqn)) ~ newline;
}

private void generateRefSlice(T)(string libraryName) {
    alias fqn = fullyQualifiedName!T;
    const string csn = getCSharpName(fqn);

    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Create")) ~ newline;
    refSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(IntPtr capacity);".format(getCSharpMethodInterfaceName(fqn, "Create")) ~ newline;
    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Get")) ~ newline;
    refSlice.functions ~= "        internal static extern IntPtr dlang_slice_%1$s(slice dslice, IntPtr index);".format(getCSharpMethodInterfaceName(fqn, "Get")) ~ newline;
    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Set")) ~ newline;
    refSlice.functions ~= "        internal static extern void dlang_slice_%1$s(slice dslice, IntPtr index, IntPtr value);".format(getCSharpMethodInterfaceName(fqn, "Set")) ~ newline;
    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Slice")) ~ newline;
    refSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, IntPtr begin, IntPtr end);".format(getCSharpMethodInterfaceName(fqn, "Slice")) ~ newline;
    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Append")) ~ newline;
    refSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, IntPtr value);".format(getCSharpMethodInterfaceName(fqn, "Append")) ~ newline;
    refSlice.functions ~= "        [DllImport(\"%1$s\", EntryPoint = \"%2$s\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName, getDLangSliceInterfaceName(fqn, "Append")) ~ newline;
    refSlice.functions ~= "        internal static extern slice dlang_slice_%1$s(slice dslice, slice array);".format(getCSharpMethodInterfaceName(fqn, "Append")) ~ newline;
    refSlice.constructors ~= "            %3$sif (typeof(T) == typeof(%2$s)) this._slice = Functions.dlang_slice_%1$s(new IntPtr(capacity));".format(getCSharpMethodInterfaceName(fqn, "Create"), getCSharpInterfaceType(fqn), refSlice.constructors != string.init ? "else " : string.init) ~ newline;
    refSlice.enumerators ~= "                %3$sif (typeof(T) == typeof(%2$s)) yield return (T)(object)Functions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn), refSlice.enumerators != string.init ? "else " : string.init) ~ newline;
    refSlice.getters ~= "                %3$sif (typeof(T) == typeof(%2$s)) return (T)(object)Functions.dlang_slice_%1$s(_slice, new IntPtr(i));".format(getCSharpMethodInterfaceName(fqn, "Get"), getCSharpInterfaceType(fqn), refSlice.getters != string.init ? "else " : string.init) ~ newline;
    refSlice.setters ~= "                %3$sif (typeof(T) == typeof(%2$s)) Functions.dlang_slice_%1$s(_slice, new IntPtr(i), value.DLangPointer);".format(getCSharpMethodInterfaceName(fqn, "Set"), getCSharpInterfaceType(fqn), refSlice.setters != string.init ? "else " : string.init) ~ newline;
    refSlice.sliceEnd ~= "            %3$sif (typeof(T) == typeof(%2$s)) return new RefSlice<T>(Functions.dlang_slice_%1$s(_slice, new IntPtr(begin), _slice.length));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn), refSlice.sliceEnd != string.init ? "else " : string.init) ~ newline;
    refSlice.sliceRange ~= "            %3$sif (typeof(T) == typeof(%2$s)) return new RefSlice<T>(Functions.dlang_slice_%1$s(_slice, new IntPtr(begin), new IntPtr(end)));".format(getCSharpMethodInterfaceName(fqn, "Slice"), getCSharpInterfaceType(fqn), refSlice.sliceRange != string.init ? "else " : string.init) ~ newline;
    refSlice.appendValues ~= "            %3$sif (typeof(T) == typeof(%2$s)) return new RefSlice<T>(Functions.dlang_slice_%1$s(dslice._slice, value.DLangPointer));".format(getCSharpMethodInterfaceName(fqn, "Append"), getCSharpInterfaceType(fqn), refSlice.appendValues != string.init ? "else " : string.init) ~ newline;
    refSlice.appendArrays ~= "            %3$sif (typeof(T) == typeof(%2$s)) return new RefSlice<T>(Functions.dlang_slice_%1$s(dslice._slice, value._slice));".format(getCSharpMethodInterfaceName(fqn, "Append"), getCSharpInterfaceType(fqn), refSlice.appendArrays != string.init ? "else " : string.init) ~ newline;
}

private void generateValueSliceBoilerplate(string libraryName) {
    //bool
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_bool_Create(IntPtr capacity);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        [return: MarshalAs(UnmanagedType.Bool)]" ~ newline;
    valueSlice.functions ~= "        internal static extern bool dlang_slice_bool_Get(slice dslice, IntPtr index);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern void dlang_slice_bool_Set(slice dslice, IntPtr index, [MarshalAs(UnmanagedType.Bool)] bool value);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_bool_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Append\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_bool_Append(slice dslice, [MarshalAs(UnmanagedType.Bool)] bool value);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Bool_Append\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_bool_Append(slice dslice, slice array);" ~ newline;
    valueSlice.constructors ~= "            if (typeof(T) == typeof(bool)) this._slice = Functions.dlang_slice_bool_Create(new IntPtr(capacity));" ~ newline;
    valueSlice.enumerators ~= "                if (typeof(T) == typeof(bool)) yield return (T)(object)Functions.dlang_slice_bool_Get(_slice, new IntPtr(i));" ~ newline;
    valueSlice.getters ~= "                if (typeof(T) == typeof(bool)) return (T)(object)Functions.dlang_slice_bool_Get(_slice, new IntPtr(i));" ~ newline;
    valueSlice.setters ~= "                if (typeof(T) == typeof(bool)) Functions.dlang_slice_bool_Set(_slice, new IntPtr(i), (bool)(object)value);" ~ newline;
    valueSlice.sliceEnd ~= "            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Slice(_slice, new IntPtr(begin), _slice.length));" ~ newline;
    valueSlice.sliceRange ~= "            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Slice(_slice, new IntPtr(begin), new IntPtr(end)));" ~ newline;
    valueSlice.appendValues ~= "            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Append(dslice._slice, (bool)(object)value));" ~ newline;
    valueSlice.appendArrays ~= "            if (typeof(T) == typeof(bool)) return new ValueSlice<T>(Functions.dlang_slice_bool_Append(dslice._slice, value._slice));" ~ newline;

    //string
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Create\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_Dstring_Create(IntPtr capacity);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Get\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        [return: MarshalAs(UnmanagedType.Bool)]" ~ newline;
    valueSlice.functions ~= "        internal static extern dstring dlang_slice_Dstring_Get(slice dslice, IntPtr index);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Set\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern void dlang_slice_Dstring_Set(slice dslice, IntPtr index, dstring value);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Slice\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_Dstring_Slice(slice dslice, IntPtr begin, IntPtr end);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Append\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_Dstring_Append(slice dslice, dstring value);" ~ newline;
    valueSlice.functions ~= "        [DllImport(\"%s\", EntryPoint = \"autowrap_csharp_slice_Dstring_Append\", CallingConvention = CallingConvention.Cdecl)]".format(libraryName) ~ newline;
    valueSlice.functions ~= "        internal static extern slice dlang_slice_Dstring_Append(slice dslice, slice array);" ~ newline;

    generateValueSlice!byte(libraryName);
    generateValueSlice!ubyte(libraryName);
    generateValueSlice!short(libraryName);
    generateValueSlice!ushort(libraryName);
    generateValueSlice!int(libraryName);
    generateValueSlice!uint(libraryName);
    generateValueSlice!long(libraryName);
    generateValueSlice!ulong(libraryName);
    generateValueSlice!float(libraryName);
    generateValueSlice!double(libraryName);
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
    internal struct dstring {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.Unicode.GetString((byte*)ptr.ToPointer(), length.ToInt32()*2);
            }
        }

        public void Release()
        {
            Functions.ReleaseMemory(ptr);
        }

        public static implicit operator string(dstring str)
        {
            return str.ToString();
        }

        public static implicit operator dstring(string str)
        {
            return Functions.CreateString(str);
        }
    }

    internal struct slice : IDisposable {
        internal IntPtr length;
        internal IntPtr ptr;

        public slice(IntPtr ptr, IntPtr length)
        {
            this.ptr = ptr;
            this.length = length;
        }

        public void Dispose()
        {
            Functions.ReleaseMemory(ptr);
        }
    }

    public abstract class DLangObject : IDisposable {
        private readonly IntPtr _ptr;
        internal protected IntPtr DLangPointer => _ptr;

        protected DLangObject(IntPtr ptr) {
            this._ptr = ptr;
        }

        public void Dispose() {
            Functions.ReleaseMemory(_ptr);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        [MarshalAs(UnmanagedType.Bool)] public bool value;
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_dstring_error {
        public dstring value;
        public dstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        public slice value;
        public dstring error;
    }

%3$s
    internal static class Functions {
        static Functions() {
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
                throw new DllNotFoundException($\"The required native assembly was not found for the current operating system and process architecture.\");
            }

            DRuntimeInitialize();
        }

        // ValueSlice Functions
%6$s
        // RefSlice Functions
%7$s
        // Support Functions
        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dstring CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_release\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport(\"%1$s\", EntryPoint = \"rt_init\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  

        [DllImport(\"%1$s\", EntryPoint = \"rt_term\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  
    }

    public class StringSlice : IEnumerable<string> {
        private readonly slice _slice;
        internal StringSlice(slice dslice) {
            this._slice = dslice;
        }
        internal slice ToSlice() => _slice;
        public long Length => _slice.length.ToInt64();

        public StringSlice(long capacity = 0) {
            this._slice = Functions.dlang_slice_Dstring_Create(new IntPtr(capacity));
        }

        public string this[long i] {
            get {
                return Functions.dlang_slice_Dstring_Get(_slice, new IntPtr(i));
            }
            set {
                Functions.dlang_slice_Dstring_Set(_slice, new IntPtr(i), value);
            }
        }
        public StringSlice Slice(long begin) {
            return new StringSlice(Functions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), _slice.length));
        }

        public StringSlice Slice(long begin, long end) {
            if (end > _slice.length.ToInt64()) {
                throw new IndexOutOfRangeException(\"Value for parameter 'end' is greater than that length of the slice.\");
            }
            return new StringSlice(Functions.dlang_slice_Dstring_Slice(_slice, new IntPtr(begin), new IntPtr(end)));
        }

        public static StringSlice operator +(StringSlice dslice, string value) {
            return new StringSlice(Functions.dlang_slice_Dstring_Append(dslice._slice, value));
        }

        public static StringSlice operator +(StringSlice dslice, StringSlice value) {
            return new StringSlice(Functions.dlang_slice_Dstring_Append(dslice._slice, value._slice));
        }

        public IEnumerator<string> GetEnumerator() {
            for(long i = 0; i < _slice.length.ToInt64(); i++) {
                yield return Functions.dlang_slice_Dstring_Get(_slice, new IntPtr(i));
            }
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => this.GetEnumerator();
    }

%4$s
%5$s}".format(libraryName, rootNamespace, returnTypesStr, valueSlice.toString(false), refSlice.toString(true), valueSlice.functions, refSlice.functions);
}