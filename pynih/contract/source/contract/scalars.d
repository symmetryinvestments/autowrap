/**
   This module contains D code for the contract tests between Python
   and its C API regarding scalars.  The functions below are meant to
   document the behaviour of said API when values are passed through
   the layer between the two languages, be it as function parameters
   or return values.
 */
module contract.scalars;

import python;

extern(C):


package PyObject* always_none(PyObject* self, PyObject *args) nothrow @nogc {
    pyIncRef(pyNone);
    return pyNone;
}


// Always returns 42. Takes no parameters.
// Tests PyLongFromUnsignedLong.
package PyObject* the_answer(PyObject* self, PyObject *args) nothrow @nogc {

    if(!PyArg_ParseTuple(args, ""))
        return null;

    return PyLong_FromUnsignedLong(42UL);
}


// returns the boolean opposite of the bool passed in
package PyObject* one_bool_param_to_not(PyObject* self, PyObject *args) nothrow @nogc {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyBoolCheck(arg)) return null;
    const dArg = arg == pyTrue;

    return PyBool_FromLong(!dArg);
}


// returns the number passed in multiplied by two
package PyObject* one_int_param_to_times_two(PyObject* self, PyObject *args) nothrow @nogc {

    long arg;

    if(!PyArg_ParseTuple(args, "l", &arg))
        return null;

    return PyLong_FromLong(arg * 2);
}


// returns the number passed in multiplied by 3
package PyObject* one_double_param_to_times_three(PyObject* self, PyObject *args) nothrow @nogc {

    double arg;

    if(!PyArg_ParseTuple(args, "d", &arg))
        return null;

    return PyFloat_FromDouble(arg * 3);
}


// returns the length of the single passed-in string
package PyObject* one_string_param_to_length(PyObject* self, PyObject *args) nothrow @nogc {
    import core.stdc.string: cstrlen = strlen;

    const char* arg;

    if(!PyArg_ParseTuple(args, "s", &arg))
        return null;

    const auto len = cstrlen(arg);
    return PyLong_FromLong(len);
}


// appends "_suffix" to the string passed in
package PyObject* one_string_param_to_string(PyObject* self, PyObject *args) nothrow {
    import std.string: fromStringz;

    if(PyTuple_Size(args) != 1) {
        PyErr_SetString(PyExc_TypeError, &"Wrong number of arguments"[0]);
        return null;
    }

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get first argument"[0]);
        return null;
    }

    if(!pyUnicodeCheck(arg)) arg = pyObjectUnicode(arg);

    if(!pyUnicodeCheck(arg)) {
        PyErr_SetString(PyExc_TypeError, &"Argument not a unicode string"[0]);
        return null;
    }

    auto unicodeArg = pyUnicodeAsUtf8String(arg);
    if(!unicodeArg) {
        PyErr_SetString(PyExc_TypeError, &"Could not decode UTF8"[0]);
        return null;
    }

    const ptr = pyBytesAsString(unicodeArg);

    const ret = ptr.fromStringz ~ "_suffix";

    return pyUnicodeDecodeUTF8(&ret[0], ret.length, null /*errors*/);
}


// appends "_suffix" to the string passed in without using the GC
package PyObject* one_string_param_to_string_manual_mem(PyObject* self, PyObject *args) nothrow @nogc {
    import std.string: fromStringz;
    import core.stdc.stdlib: malloc;
    import core.stdc.string: strlen;

    if(PyTuple_Size(args) != 1) {
        PyErr_SetString(PyExc_TypeError, &"Wrong number of arguments"[0]);
        return null;
    }

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get first argument"[0]);
        return null;
    }

    if(!pyUnicodeCheck(arg)) arg = pyObjectUnicode(arg);

    if(!pyUnicodeCheck(arg)) {
        PyErr_SetString(PyExc_TypeError, &"Argument not a unicode string"[0]);
        return null;
    }

    auto unicodeArg = pyUnicodeAsUtf8String(arg);
    if(!unicodeArg) {
        PyErr_SetString(PyExc_TypeError, &"Could not decode UTF8"[0]);
        return null;
    }

    const ptr = pyBytesAsString(unicodeArg);

    enum suffix = "_suffix";
    const ptrLen = strlen(ptr);
    const retLength = strlen(ptr) + suffix.length;
    auto ret = cast(char*) malloc(retLength);
    scope(exit) free(cast(void*) ret);

    ret[0 .. ptrLen] = ptr[0 .. ptrLen];
    ret[ptrLen .. retLength] = suffix[];

    return pyUnicodeDecodeUTF8(&ret[0], retLength, null /*errors*/);
}


// takes a list and returns its length + 1
package PyObject* one_list_param(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyListCheck(arg)) return null;
    // lists have iterators
    if(PyObject_GetIter(arg) is null) return null;

    return PyLong_FromLong(PyList_Size(arg) + 1);
}


// takes a list and returns its length + 1
package PyObject* one_list_param_to_list(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyListCheck(arg)) return null;

    auto ret = PyList_New(PyList_Size(arg));

    foreach(i; 0 .. PyList_Size(arg))
        PyList_SetItem(ret, i, PyList_GetItem(arg, i));

    PyList_Append(ret, PyLong_FromLong(4));
    PyList_Append(ret, PyLong_FromLong(5));

    return ret;
}


// takes a tuple and returns its length + 2
package PyObject* one_tuple_param(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyTupleCheck(arg)) return null;
    // tuples have iterators
    if(PyObject_GetIter(arg) is null) return null;

    return PyLong_FromLong(PyTuple_Size(arg) + 2);
}


// takes a range and returns its length + 3
package PyObject* one_range_param(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    auto iter = PyObject_GetIter(arg);
    if(iter is null) return null;

    int length;
    while(PyIter_Next(iter)) ++length;
    return PyLong_FromLong(length + 3);
}


// takes a range and returns its length + 3
package PyObject* one_dict_param(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyDictCheck(arg)) return null;

    return PyLong_FromLong(PyDict_Size(arg));
}


// takes a dict and returns a copy with an extra `"oops": "noooo"` in it
package PyObject* one_dict_param_to_dict(PyObject* self, PyObject *args) nothrow {
    if(PyTuple_Size(args) != 1) return null;

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) return null;

    if(!pyDictCheck(arg)) return null;

    auto ret = PyDict_New;

    auto keysIter = PyObject_GetIter(PyDict_Keys(arg));
    for(auto key = PyIter_Next(keysIter);
        key;
        key = PyIter_Next(keysIter))
    {
        PyDict_SetItem(ret, key, PyDict_GetItem(arg, key));
    }

    const oops = "oops";
    const no = "noooo";

    auto pyOops = pyUnicodeDecodeUTF8(&oops[0], oops.length, null /*errors*/);
    auto pyNo = pyUnicodeDecodeUTF8(&no[0], no.length, null /*errors*/);

    PyDict_SetItem(ret, pyOops, pyNo);

    return ret;
}


// Adds a certain number of days to the passed in object
package PyObject* add_days_to_date(PyObject* self, PyObject *args) {
    import std.datetime: Date, days;

    if(PyTuple_Size(args) != 2) return null;

    auto dateArg = PyTuple_GetItem(args, 0);
    if(dateArg is null) return null;

    auto deltaArg = PyTuple_GetItem(args, 1);
    if(deltaArg is null) return null;

    const year = pyDateTimeYear(dateArg);
    const month = pyDateTimeMonth(dateArg);
    const day = pyDateTimeDay(dateArg);

    auto date = Date(year, month, day);
    date += PyLong_AsLong(deltaArg).days;

    return pyDateFromDate(date.year, date.month, date.day);
}


// Adds a certain number of days to the passed in object
package PyObject* add_days_to_datetime(PyObject* self, PyObject *args) {
    import std.datetime: DateTime, days;

    if(PyTuple_Size(args) != 2) return null;

    auto dateArg = PyTuple_GetItem(args, 0);
    if(dateArg is null) return null;

    auto deltaArg = PyTuple_GetItem(args, 1);
    if(deltaArg is null) return null;

    const year = pyDateTimeYear(dateArg);
    const month = pyDateTimeMonth(dateArg);
    const day = pyDateTimeDay(dateArg);
    const hour = pyDateTimeHour(dateArg);
    const minute = pyDateTimeMinute(dateArg);
    const second = pyDateTimeSecond(dateArg);

    auto date = DateTime(year, month, day, hour, minute, second);
    date += PyLong_AsLong(deltaArg).days;

    return pyDateTimeFromDateAndTime(date.year, date.month, date.day,
                                     date.hour, date.minute, date.second);
}



package PyObject* throws_runtime_error(PyObject* self, PyObject *args) @nogc nothrow {
    enum str = "Generic runtime error";
    PyErr_SetString(PyExc_RuntimeError, str.ptr);
    return null;
}


// Returns the length of kwargs, which is a dict
package PyObject* kwargs_count(PyObject* self, PyObject *args, PyObject* kwargs) @nogc nothrow {
    if(PyTuple_Size(args) != 2) {
        PyErr_BadArgument();
        return null;
    }

    return PyLong_FromLong(PyObject_Length(kwargs));
}
