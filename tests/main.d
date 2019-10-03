import unit_threaded.runner;


version(NoPynih) {
   mixin runTestsMain!(
        "common",
        "reflection",
        "issues",
    );
} else {

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
        "common",
        "reflection",
        "issues",
        "pynih.python.conv",
        "pynih.python.util",
    );
}
