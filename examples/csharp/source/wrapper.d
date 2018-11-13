module csharp.wrapper;

import csharp.library;

import core.memory;
import std.conv;
import std.string;
import std.stdio;
import std.utf;
import std.typecons: Yes, No;

import autowrap.csharp.boilerplate;
import autowrap.reflection;

mixin(
    wrapCSharp("csharp",
        Modules(
            Module("csharp.library")
        )
    )
);

version (GenerateCSharp) {

pragma(msg, wrapCSharp("csharp",
        Modules(
            Module("csharp.library")
        )
    )
);

void main() {
    import std.stdio;
    import autowrap.csharp.csharp : writeCSharpFile;
    string csharpFile = writeCSharpFile!(Module("csharp.library"))("csharp", "csharp");
    //writeln(csharpFile);
    auto f = File("Wrapper.cs", "w");
    f.writeln(csharpFile);
    f.flush();
    f.close();
}
}
