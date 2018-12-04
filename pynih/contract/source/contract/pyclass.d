/**
   D code for contract tests verifying creation of PythonClass instances.
 */
module contract.pyclass;


import python.raw;
import python.cooked;
import python.type;


extern(C):


package PyObject* pyclass_int_double_struct(PyObject* self, PyObject *args) {

    if(PyTuple_Size(args) != 2) {
        PyErr_SetString(PyExc_TypeError, &"Wrong number of arguments"[0]);
        return null;
    }

    auto arg0 = PyTuple_GetItem(args, 0);
    if(arg0 is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get first argument"[0]);
        return null;
    }

    auto arg1 = PyTuple_GetItem(args, 1);
    if(arg1 is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get first argument"[0]);
        return null;
    }

    static struct SimpleStruct {
        int i;
        double d;
    }

    auto darg0 = cast(int) PyLong_AsLong(arg0);
    auto darg1 = PyFloat_AsDouble(arg1);
    auto struct_ = SimpleStruct(darg0, darg1);

    return pythonClass(struct_);
}


package PyObject* pyclass_string_list_struct(PyObject* self, PyObject *args) {
    if(PyTuple_Size(args) != 1) {
        PyErr_SetString(PyExc_TypeError, &"Wrong number of arguments"[0]);
        return null;
    }

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get first argument"[0]);
        return null;
    }

    if(!pyListCheck(arg)) {
        PyErr_SetString(PyExc_TypeError, &"Argument not a list"[0]);
        return null;
    }

    char[][] strings;

    foreach(i; 0 .. PyList_Size(arg)) {

        auto item = PyList_GetItem(arg, i);
        if(pyUnicodeCheck(item)) item = pyObjectUnicode(item);

        if(!pyUnicodeCheck(item)) {
            PyErr_SetString(PyExc_TypeError, &"All arguments must be strings"[0]);
            return null;
        }

        auto unicode = pyUnicodeAsUtf8String(item);
        if(!unicode) {
            PyErr_SetString(PyExc_TypeError, &"Could not decode UTF8"[0]);
            return null;
        }

        Py_ssize_t length;
        PyUnicode_AsUnicodeAndSize(item, &length);
        auto ptr = pyBytesAsString(unicode);
        auto str = ptr is null ? null : ptr[0 .. length];

        strings ~= str;
    }

    static struct StringsStruct {
        string[] strings;
    }

    return pythonClass(StringsStruct(cast(string[]) strings));
}
