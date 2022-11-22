module autowrap.pynih.python.boilerplate;


import std.traits: isFunction;


string createModuleRecipe(Module module_, alias cfunctions, alias aggregates = Aggregates!())
                         ()
{
    import std.format: format;

    return q{
        extern(C) export auto PyInit_%s() nothrow {
            import autowrap.pynih.python.cooked: createModule;
            import autowrap.pynih.python.boilerplate: commonInit, Module, CFunctions, Aggregates;

            commonInit;

            return createModule!(
                Module("%s"),
                %s,
                %s,
            );
        }

    }.format(
        module_.name,
        module_.name,
        cfunctions.stringof,
        aggregates.stringof,
    );
}


void commonInit() nothrow {
    import core.runtime: rt_init;

    try
        rt_init;
    catch(Exception _)
        assert(0);
}

/// For a nicer API
struct Module {
    string name;
}


/// For a nicer API
struct CFunctions(Args...) {

    import std.meta: staticMap;

    enum length = Args.length;

    private template toCFunction(alias F) {
        static if(isFunction!F)
            alias toCFunction = CFunction!F;
        else
            alias toCFunction = F;
    }

    alias functions = staticMap!(toCFunction, Args);

    static string stringifySymbols() {
        import std.array: join;

        string[] ret;

        static foreach(func; functions)
            ret ~= `CFunction!(` ~ __traits(identifier, func.symbol) ~ `, "` ~ func.identifier ~ `")`;

        return ret.join(", ");
    }
}

/// For a nicer API
struct CFunction(alias F, string I = "") if(isFunction!F) {

    alias symbol = F;

    static if(I == "")
        enum identifier = __traits(identifier, symbol);
    else
        enum
            identifier = I;
}


/// A list of aggregates to wrap
struct Aggregates(T...) {
    alias Types = T;

    static string stringifyTypes() {
        import std.array: join;
        string[] ret;

        static foreach(T; Types)
            ret ~= T.stringof;

        return ret.join(", ");
    }
}
