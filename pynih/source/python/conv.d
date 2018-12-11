module python.conv;


import python.raw: PyObject;
import std.traits: Unqual, isIntegral, isFloatingPoint, isAggregateType, isArray, isStaticArray;
import std.range: isInputRange;
import std.datetime: DateTime, Date;


private enum isDateOrDateTime(T) = is(Unqual!T == DateTime) || is(Unqual!T == Date);


PyObject* toPython(T)(T value) @trusted if(isIntegral!T) {
    import python.raw: PyLong_FromLong;
    return PyLong_FromLong(value);
}


PyObject* toPython(T)(T value) @trusted if(isFloatingPoint!T) {
    import python.raw: PyFloat_FromDouble;
    return PyFloat_FromDouble(value);
}


PyObject* toPython(T)(T value) if(isInputRange!T && !is(T == string) && !isStaticArray!T) {
    import python.raw: PyList_New, PyList_SetItem;

    auto ret = PyList_New(value.length);

    foreach(i, elt; value) {
        PyList_SetItem(ret, i, toPython(elt));
    }

    return ret;

}


PyObject* toPython(T)(T value) if(isAggregateType!T && !isInputRange!T && !isDateOrDateTime!T) {
    import python.type: pythonClass;
    return pythonClass(value);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == DateTime)) {
    import python.raw: pyDateTimeFromDateAndTime;
    return pyDateTimeFromDateAndTime(value.year, value.month, value.day,
                                     value.hour, value.minute, value.second);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == Date)) {
    import python.raw: pyDateFromDate;
    return pyDateFromDate(value.year, value.month, value.day);
}


PyObject* toPython(T)(T value) if(is(T == string)) {
    import python.raw: pyUnicodeFromStringAndSize;
    return pyUnicodeFromStringAndSize(value.ptr, value.length);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == bool)) {
    import python.raw: PyBool_FromLong;
    return PyBool_FromLong(value);
}


PyObject* toPython(T)(T value) if(isStaticArray!T) {
    return toPython(value[]);
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


T to(T)(PyObject* value) if(isAggregateType!T && !isDateOrDateTime!T) {
    import python.type: PythonClass;

    auto pyclass = cast(PythonClass!T*) value;

    Unqual!T ret;

    static foreach(i; 0 .. T.tupleof.length) {
        ret.tupleof[i] = pyclass.getField!i.to!(typeof(T.tupleof[i]));
    }

    return ret;
}

T to(T)(PyObject* value) if(is(Unqual!T == DateTime)) {
    import python.raw;

    return DateTime(pyDateTimeYear(value),
                    pyDateTimeMonth(value),
                    pyDateTimeDay(value),
                    pyDateTimeHour(value),
                    pyDateTimeMinute(value),
                    pyDateTimeSecond(value));

}


T to(T)(PyObject* value) if(is(Unqual!T == Date)) {
    import python.raw;

    return Date(pyDateTimeYear(value),
                pyDateTimeMonth(value),
                pyDateTimeDay(value));
}


T to(T)(PyObject* value) if(isArray!T && !is(T == string)) {
    import python.raw: PyList_Size, PyList_GetItem;
    import std.range: ElementType;

    T ret;
    static if(__traits(compiles, ret.length = 1))
        ret.length = PyList_Size(value);

    foreach(i, ref elt; ret) {
        elt = PyList_GetItem(value, i).to!(ElementType!T);
    }

    return ret;
}


T to(T)(PyObject* value) if(is(T == string)) {
    import python.raw: pyUnicodeGetSize, pyUnicodeCheck,
        pyBytesAsString, pyObjectUnicode, pyUnicodeAsUtf8String, Py_ssize_t;

    value = pyObjectUnicode(value);

    const length = pyUnicodeGetSize(value);

    auto ptr = pyBytesAsString(pyUnicodeAsUtf8String(value));
    assert(length == 0 || ptr !is null);

    return ptr[0 .. length].idup;
}


T to(T)(PyObject* value) if(is(Unqual!T == bool)) {
    import python.raw: pyTrue;
    return value is pyTrue;
}
