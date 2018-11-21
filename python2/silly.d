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
    return createModule!"silly"(methods);
}
