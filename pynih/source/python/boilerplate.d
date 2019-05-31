module python.boilerplate;


import python.raw: isPython2, isPython3;
import std.traits: isFunction;


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
