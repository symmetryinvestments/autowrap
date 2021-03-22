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
        import python.raw: PyObject_RichCompareBool, Py_LT, Py_EQ;
        import python.exception: PythonException;

        const lt = PyObject_RichCompareBool(cast(PyObject*)_obj, cast(PyObject*)other._obj, Py_LT);
        if(lt == -1) {
            throw new PythonException("Error comparing Python objects");
        }

        if(lt == 1) return -1;

        const eq = PyObject_RichCompareBool(cast(PyObject*)_obj, cast(PyObject*)other._obj, Py_EQ);
        if(eq == -1) {
            throw new PythonException("Error comparing Python objects");
        }

        if(eq == 1) return 0;


        return 1;
    }
}
