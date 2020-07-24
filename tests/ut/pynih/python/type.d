module pynih.python.type;


import unit_threaded;
import python.type;


@safe pure unittest {
    static union Union {}
    alias Type = PythonType!Union;
}
