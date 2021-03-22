module python.object_;


struct PythonObject {
    import python.raw: PyObject;

    private PyObject* _obj;

    invariant {
        assert(_obj !is null);
    }

    this(T)(auto ref T value) {
        import python.conv.d_to_python: toPython;
        _obj = value.toPython;
    }

    int opCmp(in PythonObject other) @trusted /* cast because of const */ const {
        import python.raw: PyObject_RichCompareBool, Py_LT, PyErr_Occurred, PyErr_Fetch, PyErr_NormalizeException;
        import python.raw: PyObject_GetAttrString, pyTupleCheck, PyTuple_GetItem, PyObject_Str;
        import python.conv.python_to_d: to;

        const ret = PyObject_RichCompareBool(cast(PyObject*)_obj, cast(PyObject*)other._obj, Py_LT);
        if(ret == -1) {
            if(PyErr_Occurred is null)
                throw new Exception("Error comparing Python objects");
            else {
                PyObject* type, value, traceback;
                PyErr_Fetch(&type, &value, &traceback);
                PyErr_NormalizeException(&type, &value, &traceback);

                auto args = PyObject_GetAttrString(value, "args");
                assert(args !is null);
                assert(pyTupleCheck(args));
                enum prefix = "class <'";
                enum suffix = "'>";
                auto typeAsPyString = PyObject_Str(type);
                const typeStr = typeAsPyString.to!string[prefix.length .. $ - suffix.length];
                const msg = PyTuple_GetItem(args, 0).to!string;

                throw new Exception(typeStr ~ ": " ~ msg);
            }
        }

        if(ret == 1) return -1;

        return 0;
    }
}
