import unit_threaded;

import python;
export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;


shared static this() {
    Py_Initialize;
    pyDateTimeImport;
}

shared static ~this() {
    Py_Finalize;
}

mixin runTestsMain!(
    "ut.python.util",
    "ut.python.conv",
);
