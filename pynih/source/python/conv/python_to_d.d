module python.conv.python_to_d;


import python.raw: PyObject, pyListCheck, pyTupleCheck, PyTuple_Size, pyCallableCheck;
import python.type: isUserAggregate, isTuple;
import std.traits: Unqual, isIntegral, isFloatingPoint, isAggregateType, isArray,
    isStaticArray, isAssociativeArray, isPointer, PointerTarget, isSomeChar, isSomeString,
    isDelegate, isFunctionPointer;
import std.range: isInputRange;
import std.datetime: DateTime, Date;
import core.time: Duration;


T to(T)(PyObject* value) @trusted if(isIntegral!T && !is(T == enum)) {
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


private template UserAggregateReturnType(T) {
    import std.traits: isCopyable;

    static if(isCopyable!T)
        alias UserAggregateReturnType = T;
     else
        alias UserAggregateReturnType = T*;
}

// Returns T if T is copyable, T* otherwise
UserAggregateReturnType!T to(T)(PyObject* value)
    @trusted
    if(isUserAggregate!T && (is(T == struct) || is(T == union)))
{
    import std.traits: Unqual, isCopyable;

    alias RetType = UserAggregateReturnType!T;

    static if(isCopyable!T) {
        Unqual!T ret;
        toStructImpl(value, &ret);
    } else {
        auto ret = new Unqual!T;
        toStructImpl(value, ret);
    }

    return maybeCast!RetType(ret);
}


private void toStructImpl(T)(PyObject* value, T* ret) {
    import autowrap.common: AlwaysTry;
    import python.raw: Py_None;
    import python.type: PythonClass;
    import std.traits: fullyQualifiedName, isCopyable, isPointer;

    if(value == Py_None)
        throw new Exception("Cannot convert None to " ~ T.stringof);

    auto pyclass = cast(PythonClass!T*) value;

    static foreach(i; 0 .. typeof(*ret).tupleof.length) {{
        static if(AlwaysTry || __traits(compiles, pyclass.getField!i.to!(typeof(T.tupleof[i])))) {

            auto pythonField = pyclass.getField!i;
            auto converted = pythonField.to!(typeof(T.tupleof[i]));

            static if(isCopyable!(typeof((*ret).tupleof[i])))
                (*ret).tupleof[i] = converted;
            else {
                static assert(isPointer!(typeof(converted)));
                toStructImpl(pyclass.getField!i, &((*ret).tupleof[i]));
            }
        } else
            pragma(msg, "WARNING: cannot convert struct field #", i, " of ", fullyQualifiedName!T);
    }}
}


T to(T)(PyObject* value) @trusted if(isUserAggregate!T && !is(T == struct) && !is(T == union))
{
    import python.type: PythonClass, userAggregateInit, gFactory;
    import std.traits: Unqual;
    import std.string: fromStringz;
    import std.conv: text;

    assert(value !is null, "Cannot convert null PyObject to `" ~ T.stringof ~ "`");

    auto pyclass = cast(PythonClass!T*) value;
    const runtimeType = value.ob_type.tp_name.fromStringz.text;
    auto creator = runtimeType in gFactory;
    return creator
        ? cast(T) (*creator)(value)
        : userAggregateInit!T;
}


T to(T)(PyObject* value) if(isPointer!T && isUserAggregate!(PointerTarget!T)) {
    auto ret = new Unqual!(PointerTarget!T);
    toStructImpl(value, ret);
    return ret;
}


// FIXME - not sure why a separate implementation is needed for non user aggregates
T to(T)(PyObject* value)
    if(isPointer!T && !isUserAggregate!(PointerTarget!T) &&
       !isFunctionPointer!T && !isDelegate!T &&
       !is(Unqual!(PointerTarget!T) == void))
{
    import python.raw: pyUnicodeCheck;
    import std.traits: Unqual, PointerTarget;
    import std.string: toStringz;

    enum isStringz = is(PointerTarget!T == const(char)) || is(PointerTarget!T == immutable(char));

    if(isStringz && pyUnicodeCheck(value))
        return value.to!string.toStringz.maybeCast!T;
    else {
        auto ret = new Unqual!(PointerTarget!T);
        *ret = value.to!(Unqual!(PointerTarget!T));
        return ret.maybeCast!T;
    }
}


T to(T)(PyObject* value) if(isPointer!T && is(Unqual!(PointerTarget!T) == void))
{
    import python.raw: pyBytesCheck, PyBytes_AsString;
    import std.exception: enforce;

    enforce(pyBytesCheck(value), "Can only convert Python bytes object to void*");
    return cast(void*) PyBytes_AsString(value);
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


T to(T)(PyObject* value) if(isArray!T && !isSomeString!T)
    in(pyListCheck(value) || pyTupleCheck(value))
{
    import python.raw: PyList_Size, PyList_GetItem, PyTuple_Size, PyTuple_GetItem;
    import std.range: ElementEncodingType;
    import std.traits: Unqual, isDynamicArray;
    import std.exception: enforce;
    import std.conv: text;

    alias ElementType = Unqual!(ElementEncodingType!T);

    // This is needed to deal with array of const or immutable
    static if(isDynamicArray!T)
        alias ArrayType = ElementType[];
    else
        alias ArrayType = Unqual!T;

    // deal with void[] here since otherwise we won't be able to iterate over it
    static if(is(ElementType == void))
        alias RetType = ubyte[];
    else
        alias RetType = ArrayType;

    RetType ret;

    static if(__traits(compiles, ret.length = 1)) {
        const valueLength = {
            if(pyListCheck(value))
                return PyList_Size(value);
            else if(pyTupleCheck(value))
                return PyTuple_Size(value);
            else
                assert(0);
        }();
        assert(valueLength >= 0, text("Invalid length ", valueLength));
        ret.length = valueLength;
    }

    foreach(i, ref elt; ret) {
        auto pythonItem = {
            if(pyListCheck(value))
                return PyList_GetItem(value, i);
            else if(pyTupleCheck(value))
                return PyTuple_GetItem(value, i);
            else
                assert(0);
        }();
        elt = pythonItem.to!(typeof(elt));
    }

    return maybeCast!T(ret);
}


T to(T)(PyObject* value) if(isSomeString!T) {

    import python.raw: pyUnicodeGetSize, pyUnicodeCheck,
        pyBytesAsString, pyObjectUnicode, pyUnicodeAsUtf8String, Py_ssize_t;
    import std.conv: to;

    value = pyObjectUnicode(value);

    const length = pyUnicodeGetSize(value);
    if(length == 0) return T.init;

    auto str = pyUnicodeAsUtf8String(value);
    if(str is null) throw new Exception("Tried to convert a non-string Python value to D string");

    auto ptr = pyBytesAsString(str);
    assert(length == 0 || ptr !is null);

    auto slice = ptr[0 .. length];

    return slice.to!T;
}


T to(T)(PyObject* value) if(is(Unqual!T == bool)) {
    import python.raw: pyTrue;
    return value is pyTrue;
}


T to(T)(PyObject* value) if(isAssociativeArray!T)
{
    import python.raw: pyDictCheck, PyDict_Keys, PyList_Size, PyList_GetItem, PyDict_GetItem;

    assert(pyDictCheck(value));

    // this enum is to get K and V whilst avoiding auto-decoding, which is why we're not using
    // std.traits
    enum _ = is(T == V[K], V, K);
    alias KeyType = Unqual!K;
    alias ValueType = Unqual!V;

    ValueType[KeyType] ret;

    auto keys = PyDict_Keys(value);

    foreach(i; 0 .. PyList_Size(keys)) {
        auto k = PyList_GetItem(keys, i);
        auto v = PyDict_GetItem(value, k);
        auto dk = k.to!KeyType;
        auto dv = v.to!ValueType;

        ret[dk] = dv;
    }

    return ret;
}


T to(T)(PyObject* value) if(isTuple!T)
    in(pyTupleCheck(value))
    in(PyTuple_Size(value) == T.length)
    do
{
    import python.raw: pyTupleCheck, PyTuple_Size, PyTuple_GetItem;

    T ret;

    static foreach(i; 0 .. T.length) {
        ret[i] = PyTuple_GetItem(value, i).to!(typeof(ret[i]));
    }

    return ret;
}


T to(T)(PyObject* value) if(is(Unqual!T == char) || is(Unqual!T == wchar) || is(Unqual!T == dchar)) {
    auto str = value.to!string;
    return str[0];
}


T to(T)(PyObject* value) if(isDelegate!T) {
    return value.toDlangFunction!T;
}

T to(T)(PyObject* value) if(isFunctionPointer!T) {
    throw new Exception("Conversion of Python functions to D function pointers not yet implemented");
}


private T toDlangFunction(T)(PyObject* value)
    in(pyCallableCheck(value))
    do
{
    import python.raw: PyObject_CallObject;
    import python.conv.d_to_python: toPython;
    import python.conv.python_to_d: to;
    import std.traits: ReturnType, Unqual;
    static import std.traits;
    import std.meta: staticMap;
    import std.typecons: Tuple;
    import std.format: format;
    import std.conv: text;

    alias UnqualParams = staticMap!(Unqual, std.traits.Parameters!T);

    enum code =
        q{
            // FIXME: the @trusted here is due to conversions to @safe
            // D delegates
            return (%s) @trusted {
                try {
                    Tuple!UnqualParams dArgsTuple;
                    static foreach(i; 0 .. UnqualParams.length) {
                        dArgsTuple[i] = mixin(`arg` ~ i.text);
                    }
                    auto pyArgs = dArgsTuple.toPython;
                    auto pyResult = PyObject_CallObject(value, pyArgs);
                    static if(!is(ReturnType!T == void))
                        return pyResult.to!(ReturnType!T);
                    else
                        return;
                } catch(Exception e) {
                    import python.raw: PyErr_SetString, PyExc_RuntimeError;
                    import std.string: toStringz;
                    PyErr_SetString(PyExc_RuntimeError, e.msg.toStringz);
                }
                assert(0);

            };
        }.format(
            parametersRecipe!T("T"),
        )
    ;

    // pragma(msg, code);
    mixin(code);
}

private string parametersRecipe(alias F)(in string symbol)
    in(__ctfe)
    do
{

    import std.array: join;
    import std.traits: Parameters;

    string[] parameters;

    static foreach(i; 0 .. Parameters!F.length) {
        parameters ~= parameterRecipe!(F, i)(symbol);
    }

    return parameters.join(", ");
}


private string parameterRecipe(alias F, size_t i)(in string symbol)
    in(__ctfe)
    do
{
    import std.array: join;
    import std.conv: text;
    import std.traits: ParameterDefaults;

    const string[] storageClasses = [ __traits(getParameterStorageClasses, F, i) ];

    static string defaultValue(alias default_)() {
        static if(is(default_ == void))
            return "";
        else
            return text(" = ", default_);
    }


    return
        text(storageClasses.join(" "), " ",
             `std.traits.Parameters!(`, symbol, `)[`, i, `] `,
             `arg`, i,
             defaultValue!(ParameterDefaults!F[i]),
            );
}



T to(T)(PyObject* value) if(is(Unqual!T == Duration)) {
    import python.raw: PyDateTime_Delta;
    import core.time: days, seconds, usecs;

    const delta = cast(PyDateTime_Delta*) value;

    return delta.days.days + delta.seconds.seconds + delta.microseconds.usecs;
}


T to(T)(PyObject* value) if(is(T == enum)) {
    import std.traits: OriginalType;
    return cast(T) value.to!(OriginalType!T);
}


// Usually this is needed in the presence of `const` or `immutable`
private auto maybeCast(Wanted, Actual)(auto ref Actual value) {
    static if(is(Wanted == Actual))
        return value;
    // the presence of `opCast` might mean this isn't
    // always possible
    else static if(__traits(compiles, cast(Wanted) value))
        return cast(Wanted) value;
    else {
        Wanted ret = value;
        return ret;
    }
}
