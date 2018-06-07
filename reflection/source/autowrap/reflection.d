module autowrap.reflection;


import std.meta: allSatisfy;
import std.traits: isArray;


private alias I(alias T) = T;
private enum isString(alias T) = is(typeof(T) == string);


template AllFunctions(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;
    alias AllFunctions = staticMap!(Functions, ModuleNames);
}


template Functions(string moduleName) {
    mixin(`import module_ = ` ~ moduleName ~ `;`);
    alias Functions = Functions!module_;
}


template Functions(alias module_) if(!is(typeof(module_) == string)) {

    import std.meta: Filter, staticMap;

    template Function(string memberName) {
        static if(__traits(compiles, I!(__traits(getMember, module_, memberName)))) {
            alias member = I!(__traits(getMember, module_, memberName));
            static if(isExportFunction!member)
                alias Function = member;
            else
                alias Function = void;
        } else
            alias Function = void;
    }

    template notVoid(A...) if(A.length == 1) {
        alias T = A[0];
        enum notVoid = !is(T == void);
    }

    alias Functions = Filter!(notVoid, staticMap!(Function, __traits(allMembers, module_)));
}


template AllAggregates(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {

    import std.meta: NoDuplicates, Filter;
    import std.traits: isCopyable;

    // definitions
    alias aggregates = AggregatesInModules!ModuleNames;

    // return and parameter types
    alias functionTypes = FunctionTypesInModules!ModuleNames;

    alias AllAggregates = Filter!(isCopyable, NoDuplicates!(aggregates, functionTypes));
}

private template AggregatesInModules(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;
    alias AggregatesInModules = staticMap!(AggregatesInModuleName, ModuleNames);
}

private template AggregatesInModuleName(string moduleName) {

    mixin(`import module_  = ` ~ moduleName ~ `;`);
    import std.meta: Filter, staticMap;

    alias Member(string memberName) = Symbol!(module_, memberName);
    alias members = staticMap!(Member, __traits(allMembers, module_));
    alias AggregatesInModuleName = Filter!(isUserAggregate, members);
}


// All return and parameter types of the functions in the given modules
private template FunctionTypesInModules(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;
    alias FunctionTypesInModules = staticMap!(FunctionTypesInModuleName, ModuleNames);
}

// All return and parameter types of the functions in the given module
private template FunctionTypesInModuleName(string moduleName) {

    mixin(`import module_  = ` ~ moduleName ~ `;`);
    import autowrap.reflection: isExportFunction;
    import std.traits: ReturnType, Parameters;
    import std.meta: Filter, staticMap, AliasSeq, NoDuplicates;

    alias Member(string memberName) = Symbol!(module_, memberName);
    alias members = staticMap!(Member, __traits(allMembers, module_));
    alias functions = Filter!(isExportFunction, members);

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
    alias FunctionTypesInModuleName = NoDuplicates!(Filter!(isUserAggregate, functionTypes));
}

private template RecursiveAggregates(T) {
    import std.meta: staticMap, Filter, AliasSeq, NoDuplicates;
    import std.traits: isInstanceOf;
    import std.typecons: Typedef, TypedefType;
    import std.datetime: Date;

    static if(isInstanceOf!(Typedef, T)) {
        alias RecursiveAggregates = TypedefType!T;
    } else static if (is(T == Date)) {
        alias RecursiveAggregates = Date;
    } else static if(isUserAggregate!T) {
        alias AggMember(string memberName) = Symbol!(T, memberName);
        alias members = staticMap!(AggMember, __traits(allMembers, T));
        alias types = staticMap!(Type, members);
        alias aggregates = NoDuplicates!(Filter!(isUserAggregate, staticMap!(PrimordialType, types)));

        static if(aggregates.length == 0)
            alias RecursiveAggregates = T;
        else
            alias RecursiveAggregates = AliasSeq!(aggregates, staticMap!(RecursiveAggregateHelper, aggregates));
    } else
        alias RecursiveAggregates = T;

}

// Only exists because if RecursiveAggregate recurses using itself dmd complains.
// So instead, we ping-pong between identical templates.
private template RecursiveAggregateHelper(T) {
    import std.meta: staticMap, Filter, AliasSeq, NoDuplicates;
    import std.traits: isInstanceOf;
    import std.typecons: Typedef, TypedefType;
    import std.datetime: Date;

    static if(isInstanceOf!(Typedef, T)) {
        alias RecursiveAggregates = TypedefType!T;
    } else static if (is(T == Date)) {
        alias RecursiveAggregates = Date;
    } else static if(isUserAggregate!T) {
        alias AggMember(string memberName) = Symbol!(T, memberName);
        alias members = staticMap!(AggMember, __traits(allMembers, T));
        alias types = staticMap!(Type, members);
        alias aggregates = NoDuplicates!(Filter!(isUserAggregate, staticMap!(PrimordialType, types)));

        static if(aggregates.length == 0)
            alias RecursiveAggregateHelper = T;
        else
            alias RecursiveAggregateHelper = AliasSeq!(aggregates, staticMap!(RecursiveAggregates, aggregates));
    } else
        alias RecursiveAggregatesHelper = T;
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


package template isExportFunction(alias F) {
    import std.traits: isFunction;

    version(AutowrapAlwaysExport) {
        enum linkage = __traits(getLinkage, F);
        enum isExportFunction = isFunction!F && linkage != "C" && linkage != "C++";
    } else
        enum isExportFunction = isFunction!F && __traits(getProtection, F) == "export";
}
