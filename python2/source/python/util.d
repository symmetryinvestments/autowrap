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
            ret ~= __traits(identifier, T);

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
   Creates storage for a `PyTypeObject` for each D type `T`.
 */
template PythonType(T) {
    import std.traits: Fields;

    PyTypeObject pyType;
    private PyMemberDef[Fields!T.length + 1] members;

    void init() {
        import std.traits: Fields, FieldNameTuple;

        if(pyType != pyType.init) return;

        pyType.tp_name = &__traits(identifier, T)[0];
        pyType.tp_basicsize = (PythonAggregate!T).sizeof;
        pyType.tp_flags = TypeFlags.Default;  // this is important for Python2
        pyType.tp_new = &PyType_GenericNew;
        pyType.tp_init = &ctor;
        pyType.tp_repr = &repr;

        static foreach(i; 0 .. Fields!T.length) {
            members[i].name = cast(typeof(PyMemberDef.name)) &FieldNameTuple!T[i][0];
            members[i].type = MemberType.Int; // FIXME
            members[i].offset = __traits(getMember, T, FieldNameTuple!T[i]).offsetof + PythonAggregate!T.original.offsetof;
        }

        pyType.tp_members = &members[0];

        // TODO: methods

        if(PyType_Ready(&pyType) < 0)
            throw new Exception("Could not get type ready for `" ~ __traits(identifier, T) ~ "`");

    }

    PyObject* object() {
        init;
        return cast(PyObject*) &pyType;
    }

    extern(C) static PyObject* repr(PyObject* self_) {
        import python: pyUnicodeDecodeUTF8;
        import std.conv: text;

        auto self = cast(PythonAggregate!T*) self_;
        auto ret = text(self.original);
        return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
    }

    extern(C) static int ctor(PyObject* self_, PyObject* args, PyObject* kwargs) {
        auto self = cast(PythonAggregate!T*) self_;
        self.original = T();
        // TODO: arguments
        return 0;
    }
}



/**
   A Python extension type for a D aggregate T.
 */
struct PythonAggregate(T) {
    alias Type = T;

    mixin PyObjectHead;
    T original;
    alias original this;
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
    static foreach(T; aggregates.Types) {
        auto object = PythonType!T.object();
        pyIncRef(object);
        PyModule_AddObject(module_, &__traits(identifier, T)[0], object);
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
                      is(typeof(&cfunction): PyCFunctionWithKeywords));
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
