import unit_threaded.runner;
import std.meta: AliasSeq;


alias normalModules = AliasSeq!(
    "common",
    "reflection",
    "issues",
);

alias pynihModules = AliasSeq!(
    "pynih.python.conv",
    "pynih.python.util",
    "pynih.python.type",
);


version(NoPynih) {
    alias testModules = normalModules;
} else {
    alias testModules = AliasSeq!(normalModules, pynihModules);

    import python;
    export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;


    shared static this() {
        Py_Initialize;
        pyDateTimeImport;
    }

    shared static ~this() {
        Py_Finalize;
    }
}


mixin runTestsMain!testModules;
