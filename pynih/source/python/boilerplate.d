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


/**
   A string mixin to reduce boilerplate when creating a Python module.
   Takes a module name and a variadic list of C functions to make
   available.
 */
string createModuleMixin(Module module_, alias cfunctions, alias aggregates)()
    if(isPython3)
{
    if(!__ctfe) return null;

    import std.format: format;

    enum ret = q{
        import python.raw: PyDateTime_CAPI;
        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        import python: ModuleInitRet;

        extern(C) export ModuleInitRet PyInit_%s() {
            import python.raw: pyDateTimeImport;
            import python.cooked: createModule;
            import python.boilerplate: Module, CFunctions, Aggregates;
            import core.runtime: rt_init;

            rt_init;

            pyDateTimeImport;

            return createModule!(
                Module("%s"),
                CFunctions!(
                    %s
                ),
                Aggregates!(
                    %s
                )
            );
        }
    }.format(module_.name, module_.name, cfunctions.stringifySymbols, aggregates.stringifyTypes);

    return ret;
}

string createModuleMixin(Module module_, alias cfunctions, alias aggregates)()
    if(isPython2)
{
    if(!__ctfe) return null;

    import std.format: format;

    enum ret = q{
        import python.raw: PyDateTime_CAPI;

        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        extern(C) export void init%s() {
            import python.raw: pyDateTimeImport;
            import python.cooked: initModule;
            import python.boilerplate: Module, CFunctions, Aggregates;
            import core.runtime: rt_init;

            rt_init;

            pyDateTimeImport;
            initModule!(
                Module("%s"),
                CFunctions!(
                    %s
                ),
                Aggregates!(
                    %s
                ),
            );
        }
    }.format(module_.name, module_.name, cfunctions.stringifySymbols, aggregates.stringifyTypes);

    return ret;
}
