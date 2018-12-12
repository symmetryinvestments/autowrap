/**
   Helper functions to interact with the Python C API
 */
module python.cooked;

import python.raw;
import python.boilerplate: Module, CFunctions, Aggregates;

/**
   Creates a Python3 module from the given C functions.
   Each function has the same name in Python.
 */
auto createModule(Module module_, alias cfunctions, alias aggregates)()
    if(isPython3 &&
       is(cfunctions == CFunctions!F, F...) &&
       is(aggregates == Aggregates!T, T...))
{
    static PyModuleDef moduleDef;

    auto pyMethodDefs = cFunctionsToPyMethodDefs!(cfunctions);
    moduleDef = pyModuleDef(module_.name.ptr, null /*doc*/, -1 /*size*/, pyMethodDefs);

    auto module_ = pyModuleCreate(&moduleDef);
    addModuleTypes!aggregates(module_);

    return module_;
}



/**
   Calls Py_InitModule. It's the Python2 way of creating a new Python module.
   Each function has the same name in Python.
 */
void initModule(Module module_, alias cfunctions, alias aggregates)()
    if(isPython2 &&
       is(cfunctions == CFunctions!F, F...) &&
       is(aggregates == Aggregates!T, T...))
{
    auto module_ = pyInitModule(&module_.name[0], cFunctionsToPyMethodDefs!(cfunctions));
    addModuleTypes!aggregates(module_);
}

private void addModuleTypes(alias aggregates)(PyObject* module_) {
    import python.type: PythonType;

    static foreach(T; aggregates.Types) {

        if(PyType_Ready(PythonType!T.pyType) < 0)
            throw new Exception("Could not get type ready for `" ~ __traits(identifier, T) ~ "`");


        pyIncRef(PythonType!T.pyObject);
        PyModule_AddObject(module_, __traits(identifier, T), PythonType!T.pyObject);
    }
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
                      is(typeof(&cfunction): PyCFunctionWithKeywords),
                      __traits(identifier, cfunction) ~ " is not a Python C function");

        methods[i] = pyMethodDef!(__traits(identifier, cfunction))(cast(PyCFunction) &cfunction);
    }

    return &methods[0];
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
auto pyMethodDef(string name, int flags = MethodArgs.Var | MethodArgs.Keywords, string doc = "", F)
                (F cfunction) pure
{
    import std.traits: ReturnType, Parameters, isPointer;
    import std.meta: allSatisfy;

    static assert(isPointer!(ReturnType!F),
                  "C function method implementation must return a pointer");
    static assert(allSatisfy!(isPointer, Parameters!F),
                  "C function method implementation must take pointers");
    static assert(Parameters!F.length == 2 || Parameters!F.length == 3,
                  "C function method implementation must take 2 or 3 pointers");

    return PyMethodDef(name.ptr, cast(PyCFunction) cfunction, flags, doc.ptr);
}
