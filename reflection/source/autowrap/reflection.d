module autowrap.reflection;


public import autowrap.types: isModule, Modules, Module;
import std.meta: allSatisfy;
import std.typecons: Flag, No;


private enum isString(alias T) = is(typeof(T) == string);


template AllFunctions(Modules modules) {
    import std.algorithm: map;
    import std.array: join;
    import std.typecons: Yes, No;  // needed for Module.toString in the mixin

    enum modulesList = modules.value.map!(a => a.toString).join(", ");
    mixin(`alias AllFunctions = AllFunctions!(`, modulesList, `);`);
}

template AllFunctions(Modules...) if(allSatisfy!(isString, Modules)) {
    import std.meta: staticMap;
    enum module_(string name) = Module(name);
    alias AllFunctions = staticMap!(Functions, staticMap!(module_, Modules));
}

template AllFunctions(Modules...) if(allSatisfy!(isModule, Modules)) {
    import std.meta: staticMap;
    alias AllFunctions = staticMap!(Functions, Modules);
}

template Functions(Module module_) {
    mixin(`import dmodule = ` ~ module_.name ~ `;`);
    alias Functions = Functions!(dmodule, module_.alwaysExport);
}

template Functions(alias module_, Flag!"alwaysExport" alwaysExport = No.alwaysExport)
    if(!is(typeof(module_) == string))
{
    import mirror.meta: MirrorModule = Module, FunctionSymbol;
    import std.meta: staticMap, Filter;
    import std.traits: moduleName;

    alias mod = MirrorModule!(moduleName!module_);
    enum isExport(alias F) = isExportFunction!(F.symbol, alwaysExport);

    alias Functions = Filter!(isExport, mod.FunctionsBySymbol);
}


template AllAggregates(Modules modules) {
    import std.algorithm: map;
    import std.array: join;
    import std.typecons: Yes, No;  // needed for Module.toString in the mixin

    enum modulesList = modules.value.map!(a => a.toString).join(", ");
    mixin(`alias AllAggregates = AllAggregates!(`, modulesList, `);`);
}

template AllAggregates(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;

    enum module_(string name) = Module(name);
    enum Modules = staticMap!(module_, ModuleNames);

    alias AllAggregates = AllAggregates!(staticMap!(module_, ModuleNames));
}

template AllAggregates(Modules...) if(allSatisfy!(isModule, Modules)) {
    import std.meta: Filter, NoDuplicates, staticMap;
    import std.traits: isCopyable;

    alias AllAggregates = Filter!(isCopyable, NoDuplicates!(staticMap!(AllAggregatesInModule, Modules)));
}

private template AllAggregatesInModule(Module module_) {
    import mirror.meta: MirrorModule = Module;
    import std.meta: NoDuplicates, Filter, staticMap;

    alias mod = MirrorModule!(module_.name);

    alias AllAggregatesInModule =
        NoDuplicates!(
            Filter!(isUserAggregate,
                    staticMap!(PrimordialType, mod.AllAggregates)));
}


// if a type is a struct or a class
template isUserAggregate(A...) if(A.length == 1) {
    import std.datetime;
    import std.traits: Unqual, isInstanceOf;
    import std.typecons: Tuple;

    alias T = A[0];

    enum isUserAggregate =
        !is(Unqual!T == DateTime) &&
        !is(Unqual!T == Date) &&
        !is(Unqual!T == TimeOfDay) &&
        !isInstanceOf!(Tuple, T) &&
        (is(T == struct) || is(T == class));
}


// T -> T, T[] -> T, T[][] -> T, T* -> T
template PrimordialType(T) {
    import mirror.traits: FundamentalType;
    import std.traits: Unqual;
    alias PrimordialType = Unqual!(FundamentalType!T);
}


package template isExportFunction(alias F, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    import std.traits: isFunction;

    static if(!isFunction!F)
        enum isExportFunction = false;
    else {
        version(AutowrapAlwaysExport) {
            enum linkage = __traits(getLinkage, F);
            enum isExportFunction = linkage != "C" && linkage != "C++";
        } else version(AutowrapAlwaysExportC) {
            enum linkage = __traits(getLinkage, F);
            enum isExportFunction = linkage == "C" || linkage == "C++";
        } else
            enum isExportFunction = isExportSymbol!(F, alwaysExport);
    }
}


private template isExportSymbol(alias S, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    static if(__traits(compiles, __traits(getProtection, S)))
        enum isExportSymbol = isPublicSymbol!S && (alwaysExport || __traits(getProtection, S) == "export");
    else
        enum isExportSymbol = false;
}


private template isPublicSymbol(alias S) {
    enum isPublicSymbol = __traits(getProtection, S) == "export" || __traits(getProtection, S) == "public";
}
