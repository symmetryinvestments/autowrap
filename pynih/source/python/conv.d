import python.raw: PyObject;


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
