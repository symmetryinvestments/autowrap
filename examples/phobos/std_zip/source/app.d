import autowrap;

enum str = wrapDlang!(
    LibraryName("std_zip"),
    Modules(
        Yes.alwaysExport,
        "std.zip",
        )
    );

// pragma(msg, str);
mixin(str);


pragma(mangle, "_D6python4type__T13PythonCompareTS3std8typecons__T10RebindableTyCQBf8datetime8timezone8TimeZoneZQBuZ7_py_cmpUNbPSQEh3raw7_objectQriZQv")
private void hack0() { assert(0); }
