module csharp.wrapper;

import csharp.library;
import autowrap.csharp;

mixin(
    wrapCSharp(
        Modules(
            Module("csharp.library")
        )
    )
);

version (GenerateCSharp) {
    void main() {
        import std.stdio;
        string csharpFile = generateCSharp!(Module("csharp.library"))("csharp", "csharp");
        auto f = File("Wrapper.cs", "w");
        f.writeln(csharpFile);
    }
}
