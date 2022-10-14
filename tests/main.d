import unit_threaded.runner;
import std.meta: AliasSeq;


alias normalModules = AliasSeq!(
    "ut.common",
    "ut.reflection",
    "ut.issues",
);

alias pynihModules = AliasSeq!(
    "ut.pynih.python.conv",
    "ut.pynih.python.util",
    "ut.pynih.python.type",
    "ut.pynih.python.object_",
);


version(NoPynih) {
    alias testModules = normalModules;
} else {
    alias testModules = AliasSeq!(normalModules, pynihModules);

    import python: Py_Initialize, Py_Finalize, pyDateTimeImport;

    shared static this() {
        Py_Initialize;
        pyDateTimeImport;
    }

    shared static ~this() {
        Py_Finalize;
    }
}


mixin runTestsMain!testModules;
