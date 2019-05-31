/**
   Wrapping functionality for D to Python.
 */
module autowrap.pynih.wrap;


public import std.typecons: Yes, No;
public import autowrap.reflection: Modules, Module;
static import python.boilerplate;
import python.raw: isPython2, isPython3;


/**
   The name of the dynamic library, i.e. the file name with the .so/.dll extension
 */
struct LibraryName {
    string value;
}

/**
   Code to be inserted before the call to module_init
 */
struct PreModuleInitCode {
    string value;
}

/**
   Code to be inserted after the call to module_init
 */
struct PostModuleInitCode {
    string value;
}


/**
   Returns a string to mixin that implements the necessary boilerplate
   to create a Python library containing one Python module
   wrapping all relevant D code and data structures.
 */
string wrapDlang(
    LibraryName libraryName,
    Modules modules,
    PreModuleInitCode preModuleInitCode = PreModuleInitCode(),
    PostModuleInitCode postModuleInitCode = PostModuleInitCode())
    ()
{
    return !__ctfe
        ? null
        : createPythonModuleMixin!(libraryName, modules);
}


string createPythonModuleMixin(LibraryName libraryName, Modules modules)
                              ()
{
    import autowrap.reflection: AllAggregates, AllFunctions;
    import std.format: format;

    if(!__ctfe) return null;

    alias aggregates = AllAggregates!modules;
    alias functions = AllFunctions!modules;

    return q{
        import python: ModuleInitRet;
        import python.raw: PyDateTime_CAPI;
        import python.type: PythonFunction;

        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        extern(C) export ModuleInitRet %s%s() {
            import python.boilerplate: Module, CFunctions, CFunction, Aggregates;
            import python.type: PythonFunction;
            import autowrap.pynih.wrap: createPythonModule;
            %s

            mixin createPythonModule!(
                Module("%s"),
                CFunctions!(%s),
                Aggregates!(%s),
            );
            return _py_init_impl;
        }
    }.format(
        pyInitFuncName,     // init function name
        libraryName.value,  // after init
        aggregateModuleImports!aggregates,
        libraryName.value,  // Module
        functionNames!functions,
        aggregateNames!aggregates,
    );
}

private string pyInitFuncName() @safe pure nothrow {
    static if(isPython2)
        return "init";
    else static if(isPython3)
        return "PyInit_";
    else
        static assert(false);
}


private string aggregateModuleImports(aggregates...)() {
    import std.meta: staticMap, NoDuplicates;
    import std.array: join;
    import std.traits: moduleName;

    alias aggModules = NoDuplicates!(staticMap!(moduleName, aggregates));

    string[] ret;
    static foreach(name; aggModules) {
        ret ~= name;
    }

    return `import ` ~ ret.join(", ") ~ `;`;
}

private string aggregateNames(aggregates...)() {
    import std.meta: staticMap;
    import std.array: join;
    import std.traits: fullyQualifiedName;

    enum Name(T) = fullyQualifiedName!T;
    alias names = staticMap!(Name, aggregates);

    string[] ret;
    static foreach(name; names) {
        ret ~= name;
    }

    return ret.join(", ");
}

private string functionNames(functions...)() {
    import std.meta: staticMap;
    import std.array: join;
    import std.traits: fullyQualifiedName, moduleName;

    enum FQN(alias functionSymbol) = fullyQualifiedName!(functionSymbol.symbol);
    enum ImplName(alias functionSymbol) =
        `CFunction!(PythonFunction!(` ~ FQN!functionSymbol ~ `)._py_function_impl, "` ~
        functionSymbol.name.toSnakeCase ~
        `")`;
    alias names = staticMap!(ImplName, functions);

    string[] ret;
    static foreach(name; names) {
        ret ~= name;
    }

    return ret.join(", ");
}


mixin template createPythonModule(python.boilerplate.Module module_, alias cfunctions, alias aggregates)
    if(isPython3)
{
    import python: ModuleInitRet;
    import std.format: format;

    static extern(C) export ModuleInitRet _py_init_impl() {
        import python.raw: pyDateTimeImport;
        import python.cooked: createModule;
        import python.boilerplate: Module, CFunctions, Aggregates;
        import core.runtime: rt_init;

        rt_init;

        pyDateTimeImport;
        return createModule!(module_, cfunctions, aggregates);
    }
}


mixin template createPythonModule(python.boilerplate.Module module_, alias cfunctions, alias aggregates)
    if(isPython2)
{
    import python: ModuleInitRet;
    import std.format: format;

    static extern(C) export void _py_init_impl() {
        import python.raw: pyDateTimeImport;
        import python.cooked: initModule;
        import python.boilerplate: Module, CFunctions, Aggregates;
        import core.runtime: rt_init;

        rt_init;

        pyDateTimeImport;
        initModule!(module_, cfunctions, aggregates);
    }
}


// FIXME - put into common subpackage
string toSnakeCase(in string str) @safe pure {

    import std.algorithm: all, map;
    import std.ascii: isUpper;

    if(str.all!isUpper) return str;

    string ret;

    string convert(in size_t index, in char c) {
        import std.ascii: isLower, toLower;

        const prefix = index == 0 ? "" : "_";
        const isHump =
            (index == 0 && c.isUpper) ||
            (index > 0 && c.isUpper && str[index - 1].isLower);

        return isHump ? prefix ~ c.toLower : "" ~ c;
    }

    foreach(i, c; str) {
        ret ~= convert(i, c);
    }

    return ret;
}
