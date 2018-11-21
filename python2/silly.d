import python;


extern(C):


private PyObject* silly_strlen(PyObject* self, PyObject *args) nothrow @nogc {
    import core.stdc.string: cstrlen = strlen;

    const char* arg;

    if(!PyArg_ParseTuple(args, "s", &arg))
        return null;

    const auto len = cstrlen(arg);
    return PyLong_FromLong(len);
}


private auto methods = [
    pyMethodDef!"strlen"(&silly_strlen),
    pyMethodSentinel,
];


ModuleInitRet PyInit_silly() {
    static PyModuleDef sillymodule;

    sillymodule = pyModuleDef(
        &"silly"[0], // name
        null, // documentation
        -1, // size of per-interpreter module state or -1 if the module keeps state in globals
        &methods[0],
    );

    return createModule(&sillymodule);
}
