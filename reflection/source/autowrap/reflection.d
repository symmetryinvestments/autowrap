module autowrap.reflection;


import std.meta: allSatisfy;
import std.traits: isArray, Unqual, moduleName, isCallable;
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
    template isWantedExportFunction(T...) if(T.length == 1) {
        import std.traits: isSomeFunction;
        alias F = T[0];
        static if(isSomeFunction!F)
            enum isWantedExportFunction = isExportFunction!(F, module_.alwaysExport);
        else
            enum isWantedExportFunction = false;
    }
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
        alias RecursiveAggregateImpl = T;
}


// must be a global template for staticMap
private template Type(T...) if(T.length == 1) {
    import std.traits: isSomeFunction;
    import std.meta: AliasSeq;

    static if(isSomeFunction!(T[0]))
        alias Type = AliasSeq!();
    else static if(is(T[0]))
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


version(TestingAutowrap) {
    import std.datetime: DateTime;
    static assert(!isUserAggregate!DateTime);
}

version(TestingAutowrap) {
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


// T -> T, T[] -> T, T[][] -> T, T* -> T
template PrimordialType(T) if(isArray!T) {

    import std.range.primitives: ElementEncodingType;
    import std.traits: Unqual;

    static if(isArray!(ElementEncodingType!T))
        alias PrimordialType = PrimordialType!(ElementEncodingType!T);
    else
        alias PrimordialType = Unqual!(ElementEncodingType!T);
}


// T -> T, T[] -> T, T[][] -> T, T* -> T
template PrimordialType(T) if(!isArray!T) {

    import std.traits: isPointer, PointerTarget, Unqual;

    static if(isPointer!T) {
        static if(isPointer!(PointerTarget!T))
            alias PrimordialType = PrimordialType!(PointerTarget!T);
        else
            alias PrimordialType = Unqual!(PointerTarget!T);
    } else
        alias PrimordialType = Unqual!T;
}


version(TestingAutowrap) {
    static assert(is(PrimordialType!int == int));
    static assert(is(PrimordialType!(int[]) == int));
    static assert(is(PrimordialType!(int[][]) == int));
    static assert(is(PrimordialType!(double[][]) == double));
    static assert(is(PrimordialType!(string[][]) == char));
    static assert(is(PrimordialType!(int*) == int));
    static assert(is(PrimordialType!(int**) == int));
}


package template isExportFunction(alias F, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    import std.traits: isFunction;

    version(AutowrapAlwaysExport) {
        static if(isFunction!F) {
            enum linkage = __traits(getLinkage, F);
            enum isExportFunction = linkage != "C" && linkage != "C++";
        } else
            enum isExportFunction = false;
    } else version(AutowrapAlwaysExportC) {
        static if(isFunction!F) {
            enum linkage = __traits(getLinkage, F);
            enum isExportFunction = linkage == "C" || linkage == "C++";
        } else
            enum isExportFunction = false;

    } else {
        enum isExportFunction = isFunction!F && isExportSymbol!(F, alwaysExport);
    }
}


private template isExportSymbol(alias S, Flag!"alwaysExport" alwaysExport = No.alwaysExport) {
    version(AutowrapAlwaysExport)
        enum isExportSymbol = isPublicSymbol!S;
    else
        enum isExportSymbol = isPublicSymbol!S && (alwaysExport || __traits(getProtection, S) == "export");
}

private template isPublicSymbol(alias S) {
    enum isPublicSymbol = __traits(getProtection, S) == "export" || __traits(getProtection, S) == "public";
}


template PublicFieldNames(T) {
    import std.meta: Filter, AliasSeq;
    import std.traits: FieldNameTuple;

    enum isPublic(string fieldName) = __traits(getProtection, __traits(getMember, T, fieldName)) == "public";
    alias publicFields = Filter!(isPublic, FieldNameTuple!T);

    // FIXME - See #54
    static if(is(T == class))
        alias PublicFieldNames = AliasSeq!();
    else
        alias PublicFieldNames = publicFields;
}


template PublicFieldTypes(T) {
    import std.meta: staticMap;

    alias fieldType(string name) = typeof(__traits(getMember, T, name));

    alias PublicFieldTypes = staticMap!(fieldType, PublicFieldNames!T);
}


template Properties(functions...) {
    import std.meta: Filter;
    alias Properties = Filter!(isProperty, functions);
}


template isProperty(alias F) {
    import std.traits: functionAttributes, FunctionAttribute;
    enum isProperty = functionAttributes!F & FunctionAttribute.property;
}


template isStatic(alias F) {
    import std.traits: hasStaticMember;
    enum isStatic = hasStaticMember!(__traits(parent, F), __traits(identifier, F));
}


@("isStatic")
@safe pure unittest {
    static struct Struct {
        int foo();
        static int bar();
    }

    static assert(!isStatic!(Struct.foo));
    static assert( isStatic!(Struct.bar));
}


// From a function symbol to an AliasSeq of `Parameter`
template FunctionParameters(A...) if(A.length == 1 && isCallable!(A[0])) {
    import std.traits: Parameters, ParameterIdentifierTuple, ParameterDefaults;
    import std.meta: staticMap, aliasSeqOf;
    import std.range: iota;

    alias F = A[0];

    alias parameter(size_t i) = Parameter!(
        Parameters!F[i],
        ParameterIdentifierTuple!F[i],
        ParameterDefaults!F[i]
    );

    alias FunctionParameters = staticMap!(parameter, aliasSeqOf!(Parameters!F.length.iota));
}


template Parameter(T, string id, D...) if(D.length == 1) {
    alias Type = T;
    enum identifier = id;

    static if(is(D[0] == void))
        alias Default = void;
    else
        enum Default = D[0];
}

template isParameter(alias T) {
    import std.traits: TemplateOf;
    enum isParameter = __traits(isSame, TemplateOf!T, Parameter);
}


template NumDefaultParameters(A...) if(A.length == 1 && isCallable!(A[0])) {
    import std.meta: Filter;
    import std.traits: ParameterDefaults;

    alias F = A[0];

    template notVoid(T...) if(T.length == 1) {
        enum notVoid = !is(T[0] == void);
    }

    enum NumDefaultParameters = Filter!(notVoid, ParameterDefaults!F).length;
}


template NumRequiredParameters(A...) if(A.length == 1 && isCallable!(A[0])) {
    import std.traits: Parameters;
    alias F = A[0];
    enum NumRequiredParameters = Parameters!F.length - NumDefaultParameters!F;
}


template BinaryOperators(T) {
    import std.meta: staticMap, Filter, AliasSeq;
    import std.traits: hasMember;

    // See https://dlang.org/spec/operatoroverloading.html#binary
    private alias overloadable = AliasSeq!(
        "+", "-",  "*",  "/",  "%", "^^",  "&",
        "|", "^", "<<", ">>", ">>>", "~", "in",
    );

    static if(hasMember!(T, "opBinary") || hasMember!(T, "opBinaryRight")) {

        private enum hasOperatorDir(BinOpDir dir, string op) = is(typeof(probeOperator!(T, functionName(dir), op)));
        private enum hasOperator(string op) =
            hasOperatorDir!(BinOpDir.left, op)
            || hasOperatorDir!(BinOpDir.right, op);

        alias ops = Filter!(hasOperator, overloadable);

        template toBinOp(string op) {
            enum hasLeft  = hasOperatorDir!(BinOpDir.left, op);
            enum hasRight = hasOperatorDir!(BinOpDir.right, op);

            static if(hasLeft && hasRight)
                enum toBinOp = BinaryOperator(op, BinOpDir.left | BinOpDir.right);
            else static if(hasLeft)
                enum toBinOp = BinaryOperator(op, BinOpDir.left);
            else static if(hasRight)
                enum toBinOp = BinaryOperator(op, BinOpDir.right);
            else
                static assert(false);
        }

        alias BinaryOperators = staticMap!(toBinOp, ops);
    } else
        alias BinaryOperators = AliasSeq!();
}

///
@("BinaryOperators")
@safe pure unittest {

    static struct Number {
        int i;
        Number opBinary(string op)(Number other) if(op == "+") {
            return Number(i + other.i);
        }
        Number opBinary(string op)(Number other) if(op == "-") {
            return Number(i - other.i);
        }
        Number opBinaryRight(string op)(int other) if(op == "+") {
            return Number(i + other);
        }
    }

    static assert(
        [BinaryOperators!Number] ==
        [
            BinaryOperator("+", BinOpDir.left | BinOpDir.right),
            BinaryOperator("-", BinOpDir.left),
        ]
    );
}


/**
   Tests if T has a template function named `funcName`
   with a string template parameter `op`.
 */
private auto probeOperator(T, string funcName, string op)() {
    import std.traits: Parameters;

    mixin(`alias func = T.` ~ funcName ~ `;`);
    alias P = Parameters!(func!op);

    mixin(`return T.init.` ~ funcName ~ `!op(P.init);`);
}



struct BinaryOperator {
    string op;
    BinOpDir dirs;  /// left, right, or both
}


enum BinOpDir {
    left = 1,
    right = 2,
}


string functionName(BinOpDir dir) {
    final switch(dir) with(BinOpDir) {
        case left: return "opBinary";
        case right: return "opBinaryRight";
    }
    assert(0);
}



template UnaryOperators(T) {
    import std.meta: AliasSeq, Filter;

    alias overloadable = AliasSeq!("-", "+", "~", "*", "++", "--");
    enum hasOperator(string op) = is(typeof(probeOperator!(T, "opUnary", op)));
    alias UnaryOperators = Filter!(hasOperator, overloadable);
}

///
@("UnaryOperators")
@safe pure unittest {

    static struct Struct {
        int opUnary(string op)() if(op == "+") { return 42; }
        int opUnary(string op)() if(op == "~") { return 33; }
    }

    static assert([UnaryOperators!Struct] == ["+", "~"]);
}


template AssignOperators(T) {
    import std.meta: AliasSeq, Filter;

    // See https://dlang.org/spec/operatoroverloading.html#op-assign
    private alias overloadable = AliasSeq!(
        "+", "-",  "*",  "/",  "%", "^^",  "&",
        "|", "^", "<<", ">>", ">>>", "~",
    );

    private enum hasOperator(string op) = is(typeof(probeOperator!(T, "opOpAssign", op)));
    alias AssignOperators = Filter!(hasOperator, overloadable);
}


///
@("AssignOperators")
@safe pure unittest {

    static struct Number {
        int i;
        Number opOpAssign(string op)(Number other) if(op == "+") {
            return Number(i + other.i);
        }
        Number opOpAssign(string op)(Number other) if(op == "-") {
            return Number(i - other.i);
        }
        Number opOpAssignRight(string op)(int other) if(op == "+") {
            return Number(i + other);
        }
    }

    static assert([AssignOperators!Number] == ["+", "-"]);
}
