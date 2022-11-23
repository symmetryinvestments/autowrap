module autowrap.pynih.python.exception;


import python.c: PyObject;


class PythonException: Exception {

    this(in string backupMsg, in string file = __FILE__, in size_t line = __LINE__) {

        import python.c: PyErr_Occurred;

        if(PyErr_Occurred is null)
            super(backupMsg, file, line);
        else {
            super(pythonExceptionMsg, file, line);
        }
    }
}


private string pythonExceptionMsg() {
    import python.c: PyErr_Occurred, PyErr_Fetch, PyErr_NormalizeException,
        PyObject_GetAttrString, PyTuple_Check, PyTuple_GetItem;
    import autowrap.pynih.python.conv.python_to_d: to;

    assert(PyErr_Occurred);

    PyObject* type, value, traceback;
    PyErr_Fetch(&type, &value, &traceback);
    PyErr_NormalizeException(&type, &value, &traceback);

    auto args = PyObject_GetAttrString(value, "args");
    assert(args !is null);
    assert(PyTuple_Check(args));
    const msg = PyTuple_GetItem(args, 0).to!string;

    return pyExceptionTypeToString(type) ~ ": " ~ msg;
}


private string pyExceptionTypeToString(PyObject* type) {
    import python.c: PyObject_Str;
    import autowrap.pynih.python.conv.python_to_d: to;

    enum prefix = "class <'";
    enum suffix = "'>";
    auto typeAsPyString = PyObject_Str(type);

    return typeAsPyString.to!string[prefix.length .. $ - suffix.length];
}
