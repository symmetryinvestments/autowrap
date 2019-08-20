import unit_threaded.runner;


version(NoPynih) {
   mixin runTestsMain!(
        "autowrap.reflection",
        "autowrap.python.wrap",
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
        "autowrap.reflection",
        "autowrap.python.wrap",
        "pynih.python.conv",
        "pynih.python.util",
        "issues",
    );
}
