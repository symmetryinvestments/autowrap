module pynih.python.type;

version(Have_autowrap_pynih):

import unit_threaded;
import python.type;


@safe pure unittest {
    static union Union {}
    alias Type = PythonType!Union;
}
