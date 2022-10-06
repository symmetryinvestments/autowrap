/**
   Wrapping functionality for D to Python.
 */
module autowrap.pynih.wrap;


public import autowrap.types: Modules, Module, isModule,
    LibraryName, PreModuleInitCode, PostModuleInitCode, RootNamespace, Ignore;
public import std.typecons : Yes, No;

import python.raw: PyDateTime_CAPI;
static import python.boilerplate;
import std.meta: allSatisfy;

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


string createPythonModuleMixin(LibraryName libraryName, Modules modules)
                              ()
{
    import std.format: format;
    import std.algorithm: map;
    import std.array: join;

    assert(__ctfe);

    const modulesList = modules.value.map!(a => a.toString).join(", ");

    return q{
        extern(C) export auto %s() { // -> ModuleInitRet
            import autowrap.pynih.wrap: createPythonModule, LibraryName;
            import autowrap.types: Module;
            return createPythonModule!(
                LibraryName("%s"),
                %s
            );
        }
    }.format(
        pyInitFuncName(libraryName),  // extern(C) function name
        libraryName.value,
        modulesList,
    );
}


private string pyInitFuncName(LibraryName libraryName) @safe pure nothrow {
    import python.raw: isPython3;
    static assert(isPython3, "Python2 no longer supported");
    return "PyInit_" ~ libraryName.value;
}


auto createPythonModule(LibraryName libraryName, modules...)()
    if(allSatisfy!(isModule, modules))
{
    import autowrap.common: toSnakeCase, AlwaysTry;
    import python.type: PythonFunction;
    import python.boilerplate: Module, CFunctions, CFunction, Aggregates;
    import python.raw: PyModule_AddIntConstant, PyModule_AddStringConstant;
    import autowrap.reflection: AllAggregates, AllFunctions, AllConstants;
    import std.meta: Filter, templateNot, staticMap;
    import std.traits: fullyQualifiedName;

    static immutable char[1] emptyString = ['\0'];

    alias allFunctions = AllFunctions!modules;
    enum isWrappableFunction(alias functionSymbol) = AlwaysTry ||
        __traits(compiles, &PythonFunction!(functionSymbol.symbol)._py_function_impl);
    alias wrappableFunctions = Filter!(isWrappableFunction, allFunctions);
    alias nonWrappableFunctions = Filter!(templateNot!isWrappableFunction, allFunctions);

    static foreach(nonWrappableFunction; nonWrappableFunctions) {{
            pragma(msg, "autowrap WARNING: Could not wrap function ",
                   fullyQualifiedName!(nonWrappableFunction.symbol));
        // uncomment to see the compiler error
        // auto ptr = &PythonFunction!(nonWrappableFunction.symbol)._py_function_impl;
    }}

    alias toCFunction(alias functionSymbol) = CFunction!(
        PythonFunction!(functionSymbol.symbol)._py_function_impl,
        functionSymbol.identifier.toSnakeCase,
    );
    alias cfunctions = CFunctions!(staticMap!(toCFunction, wrappableFunctions));

    alias allAggregates = AllAggregates!modules;
    alias aggregates = Aggregates!allAggregates;

    enum pythonModule = python.boilerplate.Module(libraryName.value);

    mixin createPythonModule!(pythonModule, cfunctions, aggregates);
    auto ret = _py_init_impl();

    template isIntegral(alias var) {
        import std.traits: _isIntegral = isIntegral;
        enum isIntegral = _isIntegral!(var.Type);
    }

    enum isString(alias var) = is(var.Type == string);

    alias constants = AllConstants!modules;
    static foreach(intConstant; Filter!(isIntegral, constants)) {
        PyModule_AddIntConstant(ret, &intConstant.identifier[0], intConstant.value);
    }
    static foreach(strConstant; Filter!(isString, constants)) {

        // We can't pass a null pointer if the value of the string constant is empty
        PyModule_AddStringConstant(ret,
                                   strConstant.identifier.ptr,
                                   strConstant.value.length ? strConstant.value.ptr : &emptyString[0]);
    }

    return ret;
}


mixin template createPythonModule(python.boilerplate.Module module_, alias cfunctions, alias aggregates)
{
    static extern(C) export auto _py_init_impl() {  // -> ModuleInitRet
        import python.raw: pyDateTimeImport;
        import python.cooked: createModule;
        import core.runtime: rt_init;

        rt_init;

        pyDateTimeImport;
        return createModule!(module_, cfunctions, aggregates);
    }
}
