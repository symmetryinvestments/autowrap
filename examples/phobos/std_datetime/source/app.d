import autowrap;


enum str = wrapDlang!(
    LibraryName("std_datetime"),
    Modules(
        Yes.alwaysExport,
        "std.datetime.date",
        "std.datetime.interval",
        "std.datetime.stopwatch",
        "std.datetime.systime",
        "std.datetime.timezone",
    )
);

// pragma(msg, str);
mixin(str);


version(Have_autowrap_pynih):

import autowrap.pynih.python.raw;

pragma(mangle, "_D6python4type__T13PythonCompareTS3std8typecons__T10RebindableTyCQBf8datetime8timezone8TimeZoneZQBuZ7_py_cmpUNbPSQEh3raw7_objectQriZQv")
private PyObject* hack0(PyObject*, PyObject*, int) { assert(0); }


pragma(mangle, "_D6python4type__T13PythonCompareTS3std8datetime8timezone13PosixTimeZone6TTInfoZ7_py_cmpUNbPSQDm3raw7_objectQriZQv")
private PyObject* hack1(PyObject*, PyObject*, int) { assert(0); }

import autowrap.pynih.python.type;
import autowrap.pynih.python.raw;
import std.typecons;
import std.datetime.timezone;
// pragma(mangle, "_D8autowrap5pynih6python4type__T13PythonCompareTS3std8typecons__T10RebindableTyCQBf8datetime8timezone8TimeZoneZQBuZ7_py_cmpUNbPSQEwQEqQEn3raw7_objectQxiZQBb")
// extern (C) _object* PythonCompare!(Rebindable!(immutable(TimeZone)))._py_cmp(_object*, _object*, int) nothrow {
//     assert(0);
// }

void hack2() {
    Rebindable!(immutable(TimeZone)) reb;
    auto t = PythonType!(typeof(reb))();
    auto pyType = t.pyType;
    auto rich = pyType.tp_richcompare;
    rich(null, null, 0);
    pragma(msg, typeof(rich));
}
