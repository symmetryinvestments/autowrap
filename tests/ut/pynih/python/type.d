module pynih.python.type;

version(Have_autowrap_pynih):

import unit_threaded;
import python.type;


@("union")
@safe pure unittest {
    static union Union {}
    alias Type = PythonType!Union;
}


@("const method but shared type")
@safe pure unittest {
    static struct Struct {
        int theAnswer() const { return 42; }
    }

    alias Type = PythonType!(shared Struct);
}
