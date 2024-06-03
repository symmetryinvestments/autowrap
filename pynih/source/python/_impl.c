__import core.stdc.stdlib;
__import core.stdc.stdint;
__import core.stdc.stdio;
__import core.stdc.time;
__import core.stdc.assert_;
__import core.sys.posix.pthread;

 // can't use these because then importC chokes on uses of them in C casts (or maybe sizeof ??)
//__import object : size_t, ptrdiff_t;

// TODO: not so portable...
#define size_t unsigned long
#define ssize_t long

#include "Python.h"
#include "datetime.h"
#include "structmember.h"

#define macroToFunc(returnT, name, p1T) returnT (name)(p1T p1) { return name(p1); }
#define macroToFunc2(returnT, name, p1T, p2T) returnT (name)(p1T p1, p2T p2) { return name(p1, p2); }
#define macroToFunc3(returnT, name, p1T, p2T, p3T) returnT (name)(p1T p1, p2T p2, p3T p3) { return name(p1, p2, p3); }
#define macroToFunc4(returnT, name, p1T, p2T, p3T, p4T) returnT (name)(p1T p1, p2T p2, p3T p3, p4T p4)\
                                                        { return name(p1, p2, p3, p4); }
#define macroToFunc5(returnT, name, p1T, p2T, p3T, p4T, p5T) returnT (name)(p1T p1, p2T p2, p3T p3, p4T p4, p5T p5) \
                                                        { return name(p1, p2, p3, p4, p5); }
#define macroToFunc6(returnT, name, p1T, p2T, p3T, p4T, p5T, p6T) returnT (name)(p1T p1, p2T p2, p3T p3, p4T p4, p5T p5, p6T p6) \
                                                        { return name(p1, p2, p3, p4, p5, p6); }
#define macroToFunc7(returnT, name, p1T, p2T, p3T, p4T, p5T, p6T, p7T) returnT (name)(p1T p1, p2T p2, p3T p3, p4T p4, p5T p5, p6T p6, p7T p7) \
                                                        { return name(p1, p2, p3, p4, p5, p6, p7); }

macroToFunc(int, PyList_Check, PyObject *)
macroToFunc(int, PyTuple_Check, PyObject *)
macroToFunc(int, PyTime_Check, PyObject *)
macroToFunc(int, PyUnicode_Check, PyObject *)
macroToFunc(int, PyDict_Check, PyObject *)
macroToFunc(int, PyBool_Check, PyObject *)
macroToFunc(PyObject *, PyModule_Create, PyModuleDef *)

// just using pyobject because these aren't supposed to be type checked, see python docs
macroToFunc(int, PyDateTime_GET_YEAR, PyObject *)
macroToFunc(int, PyDateTime_GET_MONTH, PyObject *)
macroToFunc(int, PyDateTime_GET_DAY, PyObject *)
macroToFunc(int, PyDateTime_DATE_GET_HOUR, PyObject *)
macroToFunc(int, PyDateTime_DATE_GET_MINUTE, PyObject *)
macroToFunc(int, PyDateTime_DATE_GET_SECOND, PyObject *)

macroToFunc3(PyObject *, PyDate_FromDate, int, int, int)

macroToFunc7(PyObject *, PyDateTime_FromDateAndTime, int, int, int, int, int, int, int)

#define DefineToConstGlobal(T, NAME) const T NAME##_ = NAME;

DefineToConstGlobal(int, METH_VARARGS)
DefineToConstGlobal(int, METH_KEYWORDS)
DefineToConstGlobal(int, METH_STATIC)
DefineToConstGlobal(int, Py_LT)
DefineToConstGlobal(int, Py_EQ)
DefineToConstGlobal(int, Py_GT)
DefineToConstGlobal(int, Py_LE)
DefineToConstGlobal(int, Py_NE)
DefineToConstGlobal(int, Py_GE)
DefineToConstGlobal(int, Py_TPFLAGS_DEFAULT) // ? on type
DefineToConstGlobal(PyObject *, Py_None)
DefineToConstGlobal(PyObject *, Py_True)
DefineToConstGlobal(PyObject *, Py_False)
DefineToConstGlobal(int, T_INT)
DefineToConstGlobal(int, T_DOUBLE)


#define xstr(s) str(s)
#define str(s) #s

// checks on the D side to make sure the code we're using isn't out of date
const char* PyObject_HEAD_code = xstr(PyObject_HEAD);

void pyDateTimeImport(void) {
    PyDateTimeAPI = (PyDateTime_CAPI *)PyCapsule_Import(PyDateTime_CAPSULE_NAME, 0);
}