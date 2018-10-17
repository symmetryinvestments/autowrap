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
            ret ~= "    public static Functions {" ~ newline;
            ret ~= csns.functions;
            foreach(agg; aggregates.byValue()) {
                ret ~= agg.toString();
            }
            ret ~= "    }" ~ newline ~ newline;
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
        functions = string.init;
        methods = string.init;
        properties = string.init;
    }

    public override string toString() {
        char[] ret;
        ret.reserve(32_768);
        if (isStruct) {
            ret ~= "    public struct " ~ camelToPascalCase(this.name) ~ " {" ~ newline;
        } else {
            ret ~= "    public class " ~ camelToPascalCase(this.name) ~ " {" ~ newline;
        }
        ret ~= constructors ~ newline;
        ret ~= functions ~ newline;
        ret ~= methods ~ newline;
        ret ~= properties;
        ret ~= "    }" ~ newline ~ newline;
        return cast(immutable)ret;
    }
}

public string writeCSharpFile(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string libraryName ="csharp";
/*
    foreach(agg; AllAggregates!Modules) {
        alias modName = agg.moduleName;
        alias aggName = agg.name;
        static if (is(agg == struct)) {
            csharpAggregate csAgg = getAggregate(modName, aggName, true);
        } else {
            csharpAggregate csAgg = getAggregate(modName, aggName, false);
        }

        static if(hasMember!(T, "__ctor")) {
            alias constructors = AliasSeq!(__traits(getOverloads, agg, "__ctor"));
        } else {
            alias constructors = AliasSeq!();
        }
        alias ParametersTuple(alias F) = Tuple!(Parameters!F);
        alias constructorParamTuples = staticMap!(ParametersTuple, constructors);
        pragma(msg, constructorParamTuples);
    }
*/
    foreach(func; AllFunctions!Modules) {
        alias modName = func.moduleName;
        alias funcName = func.name;
        csharpNamespace ns = getNamespace(modName);

        alias returnType = ReturnType!(__traits(getMember, func.module_, func.name));
        alias returnTypeStr = fullyQualifiedName!(ReturnType!(__traits(getMember, func.module_, func.name)));
        alias paramTypes = Parameters!(__traits(getMember, func.module_, func.name));
        alias paramNames = ParameterIdentifierTuple!(__traits(getMember, func.module_, func.name));
        enum bool isNothrow = (functionAttributes!(__traits(getMember, func.module_, func.name)) & FunctionAttribute.nothrow_) == FunctionAttribute.nothrow_;
        const string interfaceName = getDlangInterfaceName(modName, null, funcName);
        const string methodName = getCSharpMethodName(null, funcName);
        string retType = getReturnType(returnTypeStr, isNothrow);
        string funcStr = "        [DllImport(\"%s\", EntryPoint = \"%s\", CallingConvention = CallingConvention.Cdecl))]".format(libraryName, interfaceName) ~ newline;
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
        funcStr ~= "        public static %s %s(".format(getCSharpInterfaceType(returnTypeStr), methodName);
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= getCSharpInterfaceType(fullyQualifiedName!(paramTypes[pc])) ~ " " ~ paramNames[pc] ~ ", ";
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ") {" ~ newline;
        funcStr ~= "            var dlang_ret = dlang_%s(".format(methodName);
        static foreach(pc; 0..paramNames.length) {
            funcStr ~= paramNames[pc] ~ ", ";
        }
        if (paramNames.length > 0) {
            funcStr = funcStr[0..$-2];
        }
        funcStr ~= ");" ~ newline;
        if (!isNothrow) {
            funcStr ~= "            if (!string.IsNullOrEmpty(dlang_ret.error)) throw new DLangException(dlang_ret.error);" ~ newline;
            if (!is(returnType == void)) {
                funcStr ~= "            return dlang_ret.value;" ~ newline;
            }
        } else {
            if (!is(returnType == void)) {
                funcStr ~= "            return dlang_ret;" ~ newline;
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
    //ret ~= writeCSharpBoilerplate(libraryName, string.init);
    return cast(immutable)ret;
}

private string getDLangInterfaceType(string type) {
    //Types that require special marshalling types
    if (type[$-2..$] == "[]") return "slice";
    else if (type == stringTypeString) return "dlang_string";
    else if (type == wstringTypeString) return "dlang_wstring";
    else if (type == dstringTypeString) return "dlang_dstring";
    else if (type == boolTypeString) return "bool";
    //else if (type == dateTimeTypeString) return "dlang_datetime";
    //else if (type == sysTimeTypeString) return "dlang_systime";
    //else if (type == uuidTypeString) return "dlang_uuid";

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
    string postfix = string.init;
    if (type[$-2..$] == "[]") postfix = "[]";
    //Types that require special marshalling types
    if(type == stringTypeString) return "string" ~ postfix;
    else if (type == wstringTypeString) return "string" ~ postfix;
    else if (type == dstringTypeString) return "string" ~ postfix;
    else if (type == boolTypeString) return "bool" ~ postfix;
    //else if (type == dateTimeTypeString) return "DateTime";
    //else if (type == sysTimeTypeString) return "DateTimeOffset";
    //else if (type == uuidTypeString) return "Guid";

    //Types that can be marshalled by default
    else if (type == charTypeString) return "byte" ~ postfix;
    else if (type == wcharTypeString) return "char" ~ postfix;
    else if (type == dcharTypeString) return "uint" ~ postfix;
    else if (type == ubyteTypeString) return "byte" ~ postfix;
    else if (type == byteTypeString) return "sbyte" ~ postfix;
    else if (type == ushortTypeString) return "ushort" ~ postfix;
    else if (type == shortTypeString) return "short" ~ postfix;
    else if (type == uintTypeString) return "uint" ~ postfix;
    else if (type == intTypeString) return "int" ~ postfix;
    else if (type == ulongTypeString) return "ulong" ~ postfix;
    else if (type == longTypeString) return "long" ~ postfix;
    else if (type == floatTypeString) return "float" ~ postfix;
    else if (type == doubleTypeString) return "double" ~ postfix;
    else return getCSharpName(type);
}

private string getReturnType(string type, bool isNothrow) {
    if(isNothrow) {
        return getDLangInterfaceType(type);
    } else {
        string rtname = format("return_%s_error", getDLangInterfaceType(type));
        //These types have predefined C# types.
        if(type == boolTypeString || type == stringTypeString || type == wstringTypeString || type == dstringTypeString) {
            return rtname;
        }

        string rt = "    [StructLayout(LayoutKind.Sequential)]
    public struct %s {
        public %s value;
        public dlang_wstring error;
    }".format(rtname, getDLangInterfaceType(type)) ~ newline;

        if ((rtname in returnTypes) is null) {
            returnTypes[rtname] = rt;
        }
        return rtname;
    }
}

private string getCSharpMethodName(string aggName, string funcName) {
    import std.string : split;
    string name = string.init;

    if (aggName !is null && aggName != string.init) {
        name ~= camelToPascalCase(aggName) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name;
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
    internal struct dlang_string {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF8.GetString((byte*)ptr.ToPointer(), length.ToInt32());
            }
        }

        public void Dispose()
        {
            Functions.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_string str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_string(string str)
        {
            return Functions.CreateString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_wstring {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.Unicode.GetString((byte*)ptr.ToPointer(), length.ToInt32()*2);
            }
        }

        public void Dispose()
        {
            Functions.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_wstring str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_wstring(string str)
        {
            return Functions.CreateWString(str);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_dstring : IDisposable {
        private IntPtr length;
        private IntPtr ptr;

        public override string ToString() {
            unsafe {
                return System.Text.Encoding.UTF32.GetString((byte*)ptr.ToPointer(), length.ToInt32()*4);
            }
        }

        public void Dispose()
        {
            Functions.ReleaseMemory(ptr);
        }

        public static implicit operator string(dlang_dstring str)
        {
            return str.ToString();
        }

        public static implicit operator dlang_dstring(string str)
        {
            return Functions.CreateDString(str);
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

    [StructLayout(LayoutKind.Sequential)]
    internal struct dlang_slice<T> : IDisposable
        where T : unmanaged
    {
        private readonly slice ptr;

        private dlang_slice(IntPtr ptr, IntPtr length) {
            this.ptr = new slice(ptr, length);
        }

        public dlang_slice(slice ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            ptr.Dispose();
        }

        public static implicit operator dlang_slice<T>(Span<T> slice) {
            unsafe {
                fixed (T* temp = slice) {
                    IntPtr tptr = new IntPtr((void*)temp);
                    return new dlang_slice<T>(tptr, new IntPtr(slice.Length));
                }
            }
        }

        public static implicit operator Span<T>(dlang_slice<T> slice) {
            unsafe {
                return new Span<T>(slice.ptr.ptr.ToPointer(), slice.ptr.length.ToInt32());
            }
        }

        internal slice ToSlice() {
            return ptr;
        }
    }

    public abstract class DLangObject : IDisposable {
        protected readonly IntPtr ptr;
        internal IntPtr Pointer => ptr;

        protected DLangObject(IntPtr ptr) {
            this.ptr = ptr;
        }

        public void Dispose() {
            Functions.ReleaseMemory(ptr);
        }
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_void_error {
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_bool_error {
        [MarshalAs(UnmanagedType.Bool)] public bool value;
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_string_error {
        public dlang_string value;
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_wstring_error {
        public dlang_wstring value;
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_dstring_error {
        public dlang_dstring value;
        public dlang_wstring error;
    }

    [StructLayout(LayoutKind.Sequential)]
    internal struct return_slice_error {
        public slice value;
        public dlang_wstring error;
    }

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

        /// Support Functions
        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_string CreateString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createWString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_wstring CreateWString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_createDString\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern dlang_dstring CreateDString([MarshalAs(UnmanagedType.LPWStr)]string str);

        [DllImport(\"%1$s\", EntryPoint = \"autowrap_csharp_release\", CallingConvention = CallingConvention.Cdecl)]
        internal static extern void ReleaseMemory(IntPtr ptr);

        [DllImport(\"%1$s\", EntryPoint = \"rt_init\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeInitialize();  

        [DllImport(\"%1$s\", EntryPoint = \"rt_term\", CallingConvention = CallingConvention.Cdecl)]
        public static extern int DRuntimeTerminate();  
    }

%3$s

}".format(libraryName, rootNamespace, returnTypesStr);
}