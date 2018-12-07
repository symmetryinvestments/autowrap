module python.wrap.wrap;

/// For a nicer API
struct Module {
    string name;
}


/// For a nicer API
struct CFunctions(functions...) {
    alias symbols = functions;
    enum length = functions.length;

    static string stringifySymbols() {
        import std.array: join;

        string[] ret;

        static foreach(cfunction; symbols)
            ret ~= __traits(identifier, cfunction);

        return ret.join(", ");
    }
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
    import std.format: format;

    enum ret = q{
        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        import python: ModuleInitRet;

        extern(C) export ModuleInitRet PyInit_%s() {
            import python: pyDateTimeImport;
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
    import std.format: format;

    enum ret = q{
        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        extern(C) export void init%s() {
            import python: pyDateTimeImport, initModule;
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
