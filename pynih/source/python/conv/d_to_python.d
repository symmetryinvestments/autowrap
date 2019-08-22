module python.conv.d_to_python;


import python.raw: PyObject;
import python.type: isUserAggregate, isTuple, isNonRangeUDT;
import std.traits: Unqual, isIntegral, isFloatingPoint, isAggregateType, isArray,
    isStaticArray, isAssociativeArray, isPointer, PointerTarget, isSomeChar,
    isCallable, isSomeString;
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


PyObject* toPython(T)(T value) if(isInputRange!T && !isSomeString!T && !isStaticArray!T) {
    import python.raw: PyList_New, PyList_SetItem, PyList_Append;
    import std.range: isForwardRange, enumerate;

    static if(__traits(hasMember, T, "length")) {
        const length = value.length;
        enum append = false;
    } else static if(isForwardRange!T){
        import std.range: walkLength;
        import std.array: save;
        const length = walkLength(value.save);
        enum append = false;
    } else {
        enum length = 0;
        enum append = true;
    }

    auto ret = PyList_New(length);

    foreach(i, elt; value.enumerate) {
        static if(append)
            PyList_Append(ret, toPython(elt));
        else
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


PyObject* toPython(T)(T value) if(isSomeString!T) {
    import python.raw: pyUnicodeFromStringAndSize;
    import std.conv: to;
    auto str = value.to!string;
    return pyUnicodeFromStringAndSize(str.ptr, str.length);
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
    return null;  // FIXME
}


PyObject* toPython(T)(T value) if(isCallable!T && !isUserAggregate!T) {
    import python.type: pythonCallable;
    return pythonCallable(value);
}
