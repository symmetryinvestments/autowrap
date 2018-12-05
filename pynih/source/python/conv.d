module python.conv;


import python.raw: PyObject;
import std.traits: isIntegral, isFloatingPoint, isAggregateType;


PyObject* toPython(int value) @trusted {
    import python.raw: PyLong_FromLong;
    return PyLong_FromLong(value);
}


PyObject* toPython(double value) @trusted {
    import python.raw: PyFloat_FromDouble;
    return PyFloat_FromDouble(value);
}


PyObject* toPython(string[] value) @trusted {
    import python.raw: PyList_New, PyList_SetItem, PyUnicode_FromStringAndSize;

    auto ret = PyList_New(value.length);

    foreach(i, str; value) {
        PyList_SetItem(ret, i, PyUnicode_FromStringAndSize(&str[0], str.length));
    }

    return ret;
}


T to(T)(PyObject* value) @trusted if(isIntegral!T) {
    import python.raw: PyLong_AsLong;

    const ret = PyLong_AsLong(value);
    if(ret > T.max || ret < T.min) throw new Exception("Overflow");

    return cast(T) ret;
}


T to(T)(PyObject* value) @trusted if(isFloatingPoint!T) {
    import python.raw: PyFloat_AsDouble;
    auto ret = PyFloat_AsDouble(value);
    return cast(T) ret;
}


T to(T)(PyObject* value) if(isAggregateType!T) {
    import python.type: PythonClass;

    auto pyclass = cast(PythonClass!T*) value;

    T ret;

    static foreach(i; 0 .. T.tupleof.length) {
        ret.tupleof[i] = pyclass.getField!i.to!(typeof(T.tupleof[i]));
    }

    return ret;
}
