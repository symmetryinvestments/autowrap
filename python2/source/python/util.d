/**
   Helper functions to interact with the Python C API
 */
module python.util;

import python.bindings;

/// For a nicer API
struct Module {
    string name;
}


/// For a nicer API
struct CFunctions(functions...) {
    alias symbols = functions;
    enum length = functions.length;
}


/**
   A string mixin to reduce boilerplate when creating a Python module.
   Takes a module name and a variadic list of C functions to make
   available.
 */
string createModuleMixin(Module module_, alias cfunctions)() if(isPython3) {
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
            );
        }
    }.format(module_.name, module_.name, symbols!cfunctions);

    return ret;
}

string createModuleMixin(Module module_, alias cfunctions)() if(isPython2) {
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
            );
        }
    }.format(module_.name, module_.name, symbols!cfunctions);

    return ret;
}

private string symbols(alias cfunctions)() {
    import std.array: join;

    string[] ret;

    static foreach(cfunction; cfunctions.symbols)
        ret ~= __traits(identifier, cfunction);

    return ret.join(", ");
}


/**
   Creates a Python3 module from the given C functions.
   Each function has the same name in Python.
 */
auto createModule(Module module_, alias cfunctions)()
    if(isPython3 && is(cfunctions == CFunctions!(A), A...))
{
    static PyModuleDef moduleDef;

    auto pyMethodDefs = cFunctionsToPyMethodDefs!(cfunctions);
    moduleDef = pyModuleDef(module_.name.ptr, null /*doc*/, -1 /*size*/, pyMethodDefs);

    return pyModuleCreate(&moduleDef);
}


/**
   Calls Py_InitModule. It's the Python2 way of creating a new Python module.
   Each function has the same name in Python.
 */
void initModule(Module module_, alias cfunctions)()
    if(isPython2 && is(cfunctions == CFunctions!(A), A...))
{
    pyInitModule(&module_.name[0], cFunctionsToPyMethodDefs!(cfunctions));
}

///  Returns a PyMethodDef for each cfunction.
private PyMethodDef* cFunctionsToPyMethodDefs(alias cfunctions)()
        if(is(cfunctions == CFunctions!(A), A...))
{
    // +1 due to the sentinel that Python uses to know when to
    // stop incrementing through the pointer.
    static PyMethodDef[cfunctions.length + 1] methods;

    static foreach(i, cfunction; cfunctions.symbols) {
        // TODO: make it possible to use a different name with a UDA
        static assert(is(typeof(&cfunction): PyCFunction) ||
                      is(typeof(&cfunction): PyCFunctionWithKeywords));
        methods[i] = pyMethodDef!(__traits(identifier, cfunction))(cast(PyCFunction) &cfunction);
    }

    return &methods[0];
}


/**
   Create a Python3 module.
   The strings are compile-time parameters to avoid passing GC-allocated memory
   to Python (by calling std.string.toStringz or manually appending the null
   terminator).
 */
auto createModule(string name, string doc = "", long size = -1)(PyMethodDef[] methods) {
    assert(methods[$-1] == PyMethodDef.init, "Methods array must end with a sentinel");
    static PyModuleDef moduleDef;
    moduleDef = pyModuleDef(name.ptr, doc.ptr, size, &methods[0]);
    return pyModuleCreate(&moduleDef);
}

/**
   Helper function to get around the C syntax problem with
   PyModuleDef_HEAD_INIT - it doesn't compile in D.
*/
private auto pyModuleDef(A...)(auto ref A args) if(isPython3) {
    import std.functional: forward;

    return PyModuleDef(
        // the line below is a manual D version expansion of PyModuleDef_HEAD_INIT
        PyModuleDef_Base(PyObject(1 /*ref count*/, null /*type*/), null /*m_init*/, 0/*m_index*/, null/*m_copy*/),
        forward!args
    );
}

/**
   Helper function to create PyMethodDef structs.
   The strings are compile-time parameters to avoid passing GC-allocated memory
   to Python (by calling std.string.toStringz or manually appending the null
   terminator).
 */
auto pyMethodDef(string name, int flags = MethodArgs.Var | MethodArgs.Keywords, string doc = "")
                (PyCFunction cfunction) pure
{
    return PyMethodDef(name.ptr, cfunction, flags, doc.ptr);
}
