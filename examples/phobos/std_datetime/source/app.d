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


pragma(mangle, "_D6python4type__T13PythonCompareTS3std8typecons__T10RebindableTyCQBf8datetime8timezone8TimeZoneZQBuZ7_py_cmpUNbPSQEh3raw7_objectQriZQv")
private void hack0() { assert(0); }


pragma(mangle, "_D6python4type__T13PythonCompareTS3std8datetime8timezone13PosixTimeZone6TTInfoZ7_py_cmpUNbPSQDm3raw7_objectQriZQv")
private void hack1() { assert(0); }
