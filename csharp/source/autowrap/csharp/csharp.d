module autowrap.csharp.csharp;

import autowrap.csharp.boilerplate;
import autowrap.reflection;

import std.ascii;
import std.traits;
import std.string;

public string writeCSharpFreeFunctions(Modules...)() if(allSatisfy!(isModule, Modules)) {
    import autowrap.reflection: AllFunctions;
    string ret = string.init;

    foreach(func; AllFunctions!Modules) {

    }

    return ret;
}
