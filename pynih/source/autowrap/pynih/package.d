module autowrap.pynih;


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
string wrapModules(
    LibraryName libraryName,
    Modules modules,
    PreModuleInitCode preModuleInitCode = PreModuleInitCode(),
    PostModuleInitCode postModuleInitCode = PostModuleInitCode())
    ()
    @safe pure
{
    return !__ctfe
        ? null
        : createPythonModuleMixin!(libraryName, modules);
}


string createPythonModuleMixin(
    LibraryName libraryName,
    Modules modules)
    ()
    @safe pure
{
    import autowrap.reflection: AllAggregates;
    import std.format: format;

    static assert(isPython3);
    if(!__ctfe) return null;

    alias aggregates = AllAggregates!modules;

    return q{
        import python: ModuleInitRet;
        import python.raw: PyDateTime_CAPI;

        // This is declared as an extern C variable in python.bindings.
        // We declare it here to avoid linker errors.
        export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;

        extern(C) export ModuleInitRet PyInit_%s() {
            import python.boilerplate: Module, CFunctions, Aggregates;
            %s

            mixin createPythonModule!(
                Module("%s"),
                CFunctions!(%s),
                Aggregates!(%s),
            );
            return _py_init_impl;
        }
    }.format(
        libraryName.value,  // PyInit_
        aggregateModuleImports!aggregates,
        libraryName.value,  // Module
        "", // FIXME CFunctions
        aggregateNames!aggregates,
    );
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
