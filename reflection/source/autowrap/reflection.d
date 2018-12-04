module autowrap.reflection;

import std.meta: allSatisfy;
import std.traits: isArray, Unqual, moduleName;
import std.typecons: Flag, No;

private alias I(alias T) = T;
private enum isString(alias T) = is(typeof(T) == string);
enum isModule(alias T) = is(Unqual!(typeof(T)) == Module);

/**
   The list of modules to automatically wrap for consumption by other languages.
 */
struct Modules {
    import autowrap.reflection: Module;
    import std.traits: Unqual;
    import std.meta: allSatisfy;

    Module[] value;

    this(A...)(auto ref A modules) {

        foreach(module_; modules) {
            static if(is(Unqual!(typeof(module_)) == Module))
                value ~= module_;
            else static if(is(Unqual!(typeof(module_)) == string))
                value ~= Module(module_);
            else
                static assert(false, "Modules must either be `string` or `Module`");
        }
    }
}

/**
   A module to automatically wrap.
   Usually not needed since a string will do, but is useful when trying to export
   all functions from a module by using Module("mymodule", Yes.alwaysExport)
   instead of "mymodule"
 */
struct Module {
    import std.typecons: Flag, No;

    string name;
    Flag!"alwaysExport" alwaysExport = No.alwaysExport;

    string toString() @safe pure const {
        import std.conv: text;
        import std.string: capitalize;
        return text(`Module("`, name, `", `, text(alwaysExport).capitalize, `.alwaysExport)`);
    }
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

    import std.meta: Filter, staticMap;

    template Function(string memberName) {
        static if(__traits(compiles, I!(__traits(getMember, module_, memberName)))) {
            alias member = I!(__traits(getMember, module_, memberName));

            static if(isExportFunction!(member, alwaysExport)) {
                alias Function = FunctionSymbol!(memberName, module_, moduleName!member, member);
            } else {
                alias Function = void;
            }
        } else {
            alias Function = void;
        }
    }

    template notVoid(A...) if(A.length == 1) {
        alias T = A[0];
        enum notVoid = !is(T == void);
    }

    alias Functions = Filter!(notVoid, staticMap!(Function, __traits(allMembers, module_)));
}

template FunctionSymbol(string N, alias M, string MN, alias S) {
    alias name = N;
    alias module_ = M;
    alias moduleName = MN;
    alias symbol = S;
}

template AllAggregates(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;

    enum module_(string name) = Module(name);
    enum Modules = staticMap!(module_, ModuleNames);

    alias AllAggregates = AllAggregates!(staticMap!(module_, ModuleNames));
}

template AllAggregates(Modules...) if(allSatisfy!(isModule, Modules)) {

    import std.meta: NoDuplicates, Filter;
    import std.traits: isCopyable, Unqual;
    import std.datetime: Date, DateTime;

    // definitions
    alias aggregates = AggregateDefinitionsInModules!Modules;

    // return and parameter types
    alias functionTypes = FunctionTypesInModules!Modules;

    alias copyables = Filter!(isCopyable, NoDuplicates!(aggregates, functionTypes));

    template notAlreadyWrapped(T) {
        alias Type = Unqual!T;
        enum notAlreadyWrapped = !is(Type == Date) && !is(Type == DateTime);
    }

    alias notWrapped = Filter!(notAlreadyWrapped, copyables);
    alias public_ = Filter!(isPublicSymbol, notWrapped);

    alias AllAggregates = public_;
}

private template AggregateDefinitionsInModules(Modules...) if(allSatisfy!(isModule, Modules)) {
    import std.meta: staticMap;
    alias AggregateDefinitionsInModules = staticMap!(AggregateDefinitionsInModule, Modules);
}

private template AggregateDefinitionsInModule(Module module_) {

    mixin(`import dmodule  = ` ~ module_.name ~ `;`);
    import std.meta: Filter, staticMap, NoDuplicates, AliasSeq;

    alias Member(string memberName) = Symbol!(dmodule, memberName);
    alias members = staticMap!(Member, __traits(allMembers, dmodule));
    alias aggregates = Filter!(isUserAggregate, members);
    alias recursives = staticMap!(RecursiveAggregates, aggregates);
    alias all = AliasSeq!(aggregates, recursives);
    alias AggregateDefinitionsInModule = NoDuplicates!all;
}


// All return and parameter types of the functions in the given modules
private template FunctionTypesInModules(Modules...) if(allSatisfy!(isModule, Modules)) {
    import std.meta: staticMap;
    alias FunctionTypesInModules = staticMap!(FunctionTypesInModule, Modules);
}


// All return and parameter types of the functions in the given module
private template FunctionTypesInModule(Module module_) {

    mixin(`import dmodule  = ` ~ module_.name ~ `;`);
    import autowrap.reflection: isExportFunction;
    import std.traits: ReturnType, Parameters;
    import std.meta: Filter, staticMap, AliasSeq, NoDuplicates;

    alias Member(string memberName) = Symbol!(dmodule, memberName);
    alias members = staticMap!(Member, __traits(allMembers, dmodule));
    enum isWantedExportFunction(alias F) = isExportFunction!(F, module_.alwaysExport);
    alias functions = Filter!(isWantedExportFunction, members);

    // all return types of all functions
    alias returns = NoDuplicates!(Filter!(isUserAggregate, staticMap!(PrimordialType, staticMap!(ReturnType, functions))));
    // recurse on the types in `returns` to also wrap the aggregate types of the members
    alias recursiveReturns = NoDuplicates!(staticMap!(RecursiveAggregates, returns));
    // all of the parameters types of all of the functions
    alias params = NoDuplicates!(Filter!(isUserAggregate, staticMap!(PrimordialType, staticMap!(Parameters, functions))));
    // recurse on the types in `params` to also wrap the aggregate types of the members
    alias recursiveParams = NoDuplicates!(staticMap!(RecursiveAggregates, returns));
    // chain all types
    alias functionTypes = AliasSeq!(returns, recursiveReturns, params, recursiveParams);

    alias FunctionTypesInModule = NoDuplicates!(Filter!(isUserAggregate, functionTypes));
}


private template RecursiveAggregates(T) {
    mixin RecursiveAggregateImpl!(T, RecursiveAggregateHelper);
    alias RecursiveAggregates = RecursiveAggregateImpl;
}

// Only exists because if RecursiveAggregate recurses using itself dmd complains.
// So instead, we ping-pong between identical templates.
private template RecursiveAggregateHelper(T) {
    mixin RecursiveAggregateImpl!(T, RecursiveAggregates);
    alias RecursiveAggregateHelper = RecursiveAggregateImpl;
}

/**
   Only exists because if RecursiveAggregate recurses using itself dmd complains.
   Instead there's a canonical implementation and we ping-pong between two
   templates that mix this in.
 */
private mixin template RecursiveAggregateImpl(T, alias Other) {
    import std.meta: staticMap, Filter, AliasSeq, NoDuplicates;
    import std.traits: isInstanceOf, Unqual;
    import std.typecons: Typedef, TypedefType;
    import std.datetime: Date;

    static if(isInstanceOf!(Typedef, T)) {
        alias RecursiveAggregateImpl = TypedefType!T;
    } else static if (is(T == Date)) {
        alias RecursiveAggregateImpl = Date;
    } else static if(isUserAggregate!T) {
        alias AggMember(string memberName) = Symbol!(T, memberName);
        alias members = staticMap!(AggMember, __traits(allMembers, T));
        enum isNotMe(U) = !is(Unqual!T == Unqual!U);

        alias types = staticMap!(Type, members);
        alias primordials = staticMap!(PrimordialType, types);
        alias userAggregates = Filter!(isUserAggregate, primordials);
        alias aggregates = NoDuplicates!(Filter!(isNotMe, userAggregates));

        static if(aggregates.length == 0)
            alias RecursiveAggregateImpl = T;
        else
            alias RecursiveAggregateImpl = AliasSeq!(aggregates, staticMap!(Other, aggregates));
    } else
        alias RecursiveAggregatesImpl = T;
}


private template Type(T...) if(T.length == 1) {
    static if(is(T[0]))
        alias Type = T[0];
    else
        alias Type = typeof(T[0]);
}

// if a type is a struct or a class
package template isUserAggregate(A...) if(A.length == 1) {
    import std.datetime;
    import std.traits: Unqual, isInstanceOf;
    import std.typecons: Tuple;
    alias T = A[0];

    enum isUserAggregate =
        !is(Unqual!T == DateTime) &&
        !isInstanceOf!(Tuple, T) &&
        (is(T == struct) || is(T == class));
}

@("DateTime is not a user aggregate")
@safe pure unittest {
    import std.datetime: DateTime;
    static assert(!isUserAggregate!DateTime);
}

@("Tuple is not a user aggregate")
@safe pure unittest {
    import std.typecons: Tuple;
    static assert(!isUserAggregate!(Tuple!(int, double)));
}

// Given a parent (module, struct, ...) and a memberName, alias the actual member,
// or void if not possible
package template Symbol(alias parent, string memberName) {
    static if(__traits(compiles, I!(__traits(getMember, parent, memberName))))
        alias Symbol = I!(__traits(getMember, parent, memberName));
    else
        alias Symbol = void;
}


// T -> T, T[] -> T, T[][] -> T
private template PrimordialType(T) if(isArray!T) {
    import std.range.primitives: ElementType;
    static if(isArray!(ElementType!T))
        alias PrimordialType = PrimordialType!(ElementType!T);
    else
        alias PrimordialType = ElementType!T;
}


// T -> T, T[] -> T, T[][] -> T
private template PrimordialType(T) if(!isArray!T) {
    alias PrimordialType = T;
}


@("PrimordialType")
unittest {
    static assert(is(PrimordialType!int == int));
    static assert(is(PrimordialType!(int[]) == int));
    static assert(is(PrimordialType!(int[][]) == int));
    static assert(is(PrimordialType!(double[][]) == double));
    static assert(is(PrimordialType!(string[][]) == dchar));
}


package template isExportFunction(alias F, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    import std.traits: isFunction;

    version(AutowrapAlwaysExport) {
        enum linkage = __traits(getLinkage, F);
        enum isExportFunction = isFunction!F && linkage != "C" && linkage != "C++";
    } else {
        enum isExportFunction = isFunction!F && isExportSymbol!(F, alwaysExport);
    }
}


private template isExportSymbol(alias S, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    import std.traits: isFunction;

    version(AutowrapAlwaysExport)
        enum isExportSymbol = isPublicSymbol!S;
    else
        enum isExportSymbol = isPublicSymbol!S && (alwaysExport || __traits(getProtection, S) == "export");
}

private template isPublicSymbol(alias S) {
    enum isPublicSymbol = __traits(getProtection, S) == "export" || __traits(getProtection, S) == "public";
}


@("24")
@safe pure unittest {
    import std.typecons: Yes;
    import std.traits: fullyQualifiedName;
    import std.meta: staticMap, AliasSeq;

    alias functions = AllFunctions!(Module("not_public", Yes.alwaysExport));
    enum FunctionName(alias F) = fullyQualifiedName!(F.symbol);
    alias functionNames = staticMap!(FunctionName, functions);
    static assert(functionNames == AliasSeq!("not_public.fun0"));

    alias aggregates = AllAggregates!(Module("not_public", Yes.alwaysExport));
    alias aggNames = staticMap!(fullyQualifiedName, aggregates);
    static assert(aggNames == AliasSeq!("not_public.Public"));
}
