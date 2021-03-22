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
        import python.raw: PyObject_RichCompareBool, Py_LT, Py_EQ, Py_GT;
        import python.exception: PythonException;

        static int[int] pyOpToRet;
        if(pyOpToRet == pyOpToRet.init)
            pyOpToRet = [Py_LT: -1, Py_EQ: 0, Py_GT: 1];

        foreach(pyOp, ret; pyOpToRet) {
            const pyRes = PyObject_RichCompareBool(cast(PyObject*)_obj, cast(PyObject*)other._obj, pyOp);

            if(pyRes == -1)
                throw new PythonException("Error comparing Python objects");

            if(pyRes == 1)
                return ret;
        }

        assert(0);
    }
}
