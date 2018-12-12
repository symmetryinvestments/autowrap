module app;

import test;
import autowrap.csharp;

immutable Modules modules = Modules(Module("test"));

mixin(
    wrapCSharp(modules)
);

mixin(
    emitCSharp(
        modules,
        OutputFileName("Wrapper.cs"),
        LibraryName("csharp-tests"),
        RootNamespace("Autowrap.CSharp.Tests")
    )
);
