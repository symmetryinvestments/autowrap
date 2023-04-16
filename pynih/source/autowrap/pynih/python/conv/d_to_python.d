module autowrap.pynih.python.conv.d_to_python;


import python.c: PyObject;
import autowrap.pynih.python.type: isUserAggregate, isTuple, isNonRangeUDT;
import std.traits: Unqual, isIntegral, isFloatingPoint, isAggregateType,
    isStaticArray, isAssociativeArray, isPointer, isSomeChar,
    isCallable, isSomeString, isFunctionPointer, isDelegate,
    PointerTarget;
import std.range: isInputRange, isInfinite;
import std.datetime: Date, DateTime, TimeOfDay;
import core.time: Duration;


PyObject* toPython(in bool val) @trusted @nogc {
    import python.c: Py_IncRef, _Py_TrueStruct, _Py_FalseStruct;

    auto pyTrue = cast(PyObject*) &_Py_TrueStruct;
    auto pyFalse = cast(PyObject*) &_Py_FalseStruct;

    static PyObject* incAndRet(PyObject* obj) @nogc {
        
        (cast(int function(PyObject*) @nogc)(&Py_IncRef))(obj);
        return obj;
    }

    return val ? incAndRet(pyTrue) : incAndRet(pyFalse);
}


PyObject* toPython(T)(T value) @trusted if(isIntegral!T && !is(T == enum)) {
    import python.c: PyLong_FromLong;
    return PyLong_FromLong(value);
}


PyObject* toPython(T)(T value) @trusted if(isFloatingPoint!T) {
    import python.c: PyFloat_FromDouble;
    return PyFloat_FromDouble(value);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == void[])) {
    auto bytes = cast(ubyte[]) value;
    return bytes.toPython;
}


PyObject* toPython(T)(T value)
    if(isInputRange!T && !isInfinite!T && !isSomeString!T && !isStaticArray!T)
{
    import python.c: PyList_New, PyList_SetItem, PyList_Append;
    import std.range: isForwardRange, enumerate;

    static if(__traits(hasMember, T, "length")) {
        const length = value.length;
        enum append = false;
    } else static if(isForwardRange!T) {
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

PyObject* toPython(T)(T value)
    if(isInputRange!T && isInfinite!T)
{
    import autowrap.pynih.python.type: pythonClass;
    return pythonClass(value);
}


PyObject* toPython(T)(auto ref T value) if(isNonRangeUDT!T) {
    import autowrap.pynih.python.type: pythonClass;
    return pythonClass(value);
}


PyObject* toPython(T)(T value)
    if(isPointer!T && !isFunctionPointer!T && !isDelegate!T && !is(Unqual!(PointerTarget!T) == void))
{
    import autowrap.common: AlwaysTry;

    static if(AlwaysTry || __traits(compiles, toPython(*value))) {
        import std.traits: PointerTarget;
        import std.string: fromStringz;

        static if(is(PointerTarget!T == const(char)) || is(PointerTarget!T == immutable(char)))
            return value.fromStringz.toPython;
        else
            return toPython(*value);
    } else {
        import std.traits: fullyQualifiedName;
        enum msg = "could not convert " ~ fullyQualifiedName!T ~ " to Python";
        pragma(msg, "WARNING: ", msg);
        throw new Exception(msg);
    }
}


PyObject* toPython(T)(T value)
    if(isPointer!T && is(Unqual!(PointerTarget!T) == void))
{
    throw new Exception("Converting void* to Python is not supported");
}


PyObject* toPython(T)(T value) if(is(Unqual!T == DateTime)) {
    import python.c: PyDateTime_FromDateAndTime;
    return PyDateTime_FromDateAndTime(value.year, value.month, value.day,
                                      value.hour, value.minute, value.second, 0 /*usec*/);
}

PyObject* toPython(T)(T value) if(is(Unqual!T == Date)) {
    import python.c: PyDate_FromDate;
    return PyDate_FromDate(value.year, value.month, value.day);
}

PyObject* toPython(T)(T value) if(is(Unqual!T == TimeOfDay)) {
    import python.c: PyTime_FromTime;
    return PyTime_FromTime(value.hour, value.minute, value.second, 0 /*usec*/);
}


PyObject* toPython(T)(T value) if(isSomeString!T) {
    import python.c: PyUnicode_FromStringAndSize;
    import std.conv: to;
    auto str = value.to!string;
    return PyUnicode_FromStringAndSize(str.ptr, str.length);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == bool)) {
    import python.c: PyBool_FromLong;
    return PyBool_FromLong(value);
}


PyObject* toPython(T)(T value) if(isStaticArray!T) {
    return toPython(value[]);
}


PyObject* toPython(T)(T value) if(isAssociativeArray!T) {
    import python.c: PyDict_New, PyDict_SetItem;

    auto ret = PyDict_New;

    foreach(k, v; value) {
        PyDict_SetItem(ret, k.toPython, v.toPython);
    }

    return ret;
}

PyObject* toPython(T)(T value) if(isTuple!T) {
    import python.c: PyTuple_New, PyTuple_SetItem;

    auto ret = PyTuple_New(value.length);

    static foreach(i; 0 .. T.length) {
        PyTuple_SetItem(ret, i, value[i].toPython);
    }

    return ret;
}


PyObject* toPython(T)(T value) if(is(Unqual!T == char) || is(Unqual!T == wchar) || is(Unqual!T == dchar)) {
    return [value].toPython;
}


PyObject* toPython(T)(T value) if(isCallable!T && !isUserAggregate!T) {
    import autowrap.pynih.python.type: pythonCallable;
    return pythonCallable(value);
}


PyObject* toPython(T)(T value) if(is(Unqual!T == Duration)) {
    import python.c: PyDelta_FromDSU;
    int days, seconds, useconds;
    value.split!("days", "seconds", "usecs")(days, seconds, useconds);
    return PyDelta_FromDSU(days, seconds, useconds);
}


PyObject* toPython(T)(T value) if(is(T == enum)) {
    import std.traits: OriginalType;
    return toPython(cast(OriginalType!T) value);
}
