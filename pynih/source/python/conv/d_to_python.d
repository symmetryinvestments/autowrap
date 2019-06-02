module python.conv.d_to_python;


import python.raw: PyObject;
import python.type: isUserAggregate, isTuple, isNonRangeUDT;
import std.traits: Unqual, isIntegral, isFloatingPoint, isAggregateType, isArray,
    isStaticArray, isAssociativeArray, isPointer, PointerTarget, isSomeChar;
import std.range: isInputRange;
import std.datetime: Date, DateTime;



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

    static if(__traits(hasMember, T, "length"))
        const length = value.length;
    else {
        import std.range: isForwardRange, walkLength;
        import std.array: save;
        static assert(isForwardRange!T);
        const length = walkLength(value.save);
    }

    auto ret = PyList_New(length);

    foreach(i, elt; value) {
        PyList_SetItem(ret, i, toPython(elt));
    }

    return ret;

}


PyObject* toPython(T)(T value) if(isNonRangeUDT!T) {
    import python.type: pythonClass;
    return pythonClass(value);
}


PyObject* toPython(T)(T value) if(isPointer!T && isNonRangeUDT!(PointerTarget!T)) {
    return toPython(*value);
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


PyObject* toPython(T)(T value) if(isAssociativeArray!T) {
    import python.raw: PyDict_New, PyDict_SetItem;

    auto ret = PyDict_New;

    foreach(k, v; value) {
        PyDict_SetItem(ret, k.toPython, v.toPython);
    }

    return ret;
}

PyObject* toPython(T)(T value) if(isTuple!T) {
    import python.raw: PyTuple_New, PyTuple_SetItem;

    auto ret = PyTuple_New(value.length);

    static foreach(i; 0 .. T.length) {
        PyTuple_SetItem(ret, i, value[i].toPython);
    }

    return ret;
}


PyObject* toPython(T)(T value) if(isSomeChar!T) {
    return null;
}
