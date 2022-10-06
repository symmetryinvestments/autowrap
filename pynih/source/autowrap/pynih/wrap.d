/**
   Wrapping functionality for D to Python.
 */
module autowrap.pynih.wrap;


public import autowrap.types: Modules, Module, isModule,
    LibraryName, PreModuleInitCode, PostModuleInitCode, RootNamespace, Ignore;
public import std.typecons : Yes, No;

import python.raw: PyDateTime_CAPI, PyObject;
static import python.boilerplate;
import autowrap.common: toSnakeCase;
import mirror.meta.reflection : FunctionSymbol;
import std.meta: allSatisfy;
import std.traits: isInstanceOf;

// This is required to avoid linker errors. Before it was in the string mixin,
// but there's no need for it there, instead we declare it here in the library
// instead.
export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;


/**
   Returns a string to mixin that implements the necessary boilerplate
   to create a Python library containing one Python module
   wrapping all relevant D code and data structures.
 */
string wrapDlang(
    LibraryName libraryName,
    Modules modules,
    RootNamespace _ = RootNamespace(), // ignored in this backend
    PreModuleInitCode preModuleInitCode = PreModuleInitCode(),    // ignored in this backend
    PostModuleInitCode postModuleInitCode = PostModuleInitCode(), // ignored in this backend
    )
    ()
{
    assert(__ctfe);
    return createPythonModuleMixin!(libraryName, modules);
}


/**
   Returns a string with the module creation function for Python, i.e.
   the Python extension module's entry point. Needs to be a string mixin
   since Python knows which function is the entry point by name convention,
   where an extension module called "foo" needs to export a function
   `PyInit_foo`. "All" this function does is create a function with the
   appropriate name and stringify the arguments to pass to the function
   doing the heavy lifting: createPythonModule.
 */
string createPythonModuleMixin(LibraryName libraryName, Modules modules)
                              ()
{
    import std.format: format;
    import std.algorithm: map;
    import std.array: join;

    assert(__ctfe);

    return q{
        extern(C) export auto PyInit_%s() { // -> ModuleInitRet
            import autowrap.pynih.wrap: createPythonModule, LibraryName;
            import autowrap.types: Module;
            return createPythonModule!(
                LibraryName("%s"),
                %s
            );
        }
    }.format(
        libraryName.value,
        libraryName.value,
        modules.value.map!(a => a.toString).join(", ")
    );
}


/**
   Reflects on the modules given and creates a Python module called `libraryName`
   with wrappers for all of the functions and types in each of the modules.
 */
auto createPythonModule(LibraryName libraryName, modules...)()
    if(allSatisfy!(isModule, modules))
{
    import python.boilerplate: Module;

    auto ret = createDlangPythonModule!(
        Module(libraryName.value),
        cfunctions!modules,
        aggregates!modules
    );

    addConstants!modules(ret);

    return ret;
}

void addConstants(modules...)(PyObject* pythonModule) {
    import python.cooked : addStringConstant, addIntConstant;
    import autowrap.reflection: AllConstants;
    import std.meta: Filter;

    alias constants = AllConstants!modules;

    template isIntegral(alias var) {
        import std.traits: _isIntegral = isIntegral;
        enum isIntegral = _isIntegral!(var.Type);
    }
    static foreach(intConstant; Filter!(isIntegral, constants)) {
        addIntConstant!(intConstant.identifier, intConstant.value)(pythonModule);
    }

    enum isString(alias var) = is(var.Type == string);
    static foreach(strConstant; Filter!(isString, constants)) {
        addStringConstant!(strConstant.identifier, strConstant.value)(pythonModule);
    }
}

/**
   The C functions that Python is actually going to call, of the type
   PyObject* (PyObject* args, PyObject* kwargs). "Returned" as `python.boilerplate.CFunctions`,
   obtained by reflecting on the passed-in modules and synthethising the necessary functions
   by doing all conversions automatically.
 */
template cfunctions(modules...) {
    import python.boilerplate: CFunctions;
    import std.meta: staticMap;
    alias cfunctions = CFunctions!(staticMap!(toCFunction, wrappableFunctions!modules));
}

private template wrappableFunctions(modules...) {
    import autowrap.common: AlwaysTry;
    import python.type: PythonFunction;
    import autowrap.reflection: AllFunctions;
    import std.meta: Filter, templateNot;
    import std.traits: fullyQualifiedName;

    alias allFunctions = AllFunctions!modules;
    enum isWrappableFunction(alias functionSymbol) = AlwaysTry ||
        __traits(compiles, &PythonFunction!(functionSymbol.symbol)._py_function_impl);
    alias nonWrappableFunctions = Filter!(templateNot!isWrappableFunction, allFunctions);

    static foreach(nonWrappableFunction; nonWrappableFunctions) {
            pragma(msg, "autowrap WARNING: Could not wrap function ",
                   fullyQualifiedName!(nonWrappableFunction.symbol));
        // uncomment to see the compiler error
        // &PythonFunction!(nonWrappableFunction.symbol)._py_function_impl;
    }

    alias wrappableFunctions = Filter!(isWrappableFunction, allFunctions);
}

/**
   The D aggregates (structs/classes/enums) to be wrapped for Python.
   "Returned" as `python.boilerplate.Aggregates`
 */
template aggregates(modules...) {
    import python.boilerplate: Aggregates;
    import autowrap.reflection: AllAggregates;
    alias aggregates = Aggregates!(AllAggregates!modules);
}

/**
   Converts from mirror.meta.reflection.FunctionSymbol to the template CFunction from python.boilerplate
 */
template toCFunction(alias functionSymbol, string identifier = functionSymbol.identifier.toSnakeCase)
    if(isInstanceOf!(FunctionSymbol, functionSymbol))
{
    import python.type: PythonFunction;
    import python.boilerplate: CFunction;

    alias toCFunction = CFunction!(
        PythonFunction!(functionSymbol.symbol)._py_function_impl,
        functionSymbol.identifier.toSnakeCase,
    );
}

/**
   Initialises the Python DateTime API, the druntime, and creates the Python extension module
 */
auto createDlangPythonModule(python.boilerplate.Module module_, alias cfunctions, alias aggregates)() {
    import python.raw: pyDateTimeImport;
    import python.cooked: createModule;
    import core.runtime: rt_init;

    rt_init;
    pyDateTimeImport;

    return createModule!(module_, cfunctions, aggregates);
}
