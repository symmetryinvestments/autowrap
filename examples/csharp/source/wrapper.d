module csharp.wrapper;

import csharp.library;

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
void main() {
    import std.stdio;
    import autowrap.csharp.csharp : writeCSharpFile;
    string csharpFile = writeCSharpFile!(Module("csharp.library"))("csharp", "csharp");
    auto f = File("Wrapper.cs", "w");
    f.writeln(csharpFile);
    f.flush();
    f.close();
}
}
