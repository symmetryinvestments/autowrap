import unit_threaded.runner;


version(NoPynih) {
   mixin runTestsMain!(
        "autowrap.python.wrap",
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
        "autowrap.python.wrap",
        "reflection",
        "pynih.python.conv",
        "pynih.python.util",
        "issues",
    );
}
