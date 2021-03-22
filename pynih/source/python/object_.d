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
        import python.raw: PyObject_RichCompareBool, Py_LT;

        const ret = PyObject_RichCompareBool(cast(PyObject*)_obj, cast(PyObject*)other._obj, Py_LT);
        if(ret == -1) throw new Exception("Error comparing Python objects");

        if(ret == 1) return -1;

        return 0;
    }
}
