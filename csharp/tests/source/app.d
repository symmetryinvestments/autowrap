module app;

import test;
import autowrap.csharp;

mixin(
    wrapCSharp(
        Modules(
            Module("test")
        )
    )
);

mixin(
    emitCSharp(
        Modules( 
            Module("test")
        ),
        OutputFileName("Wrapper.cs"),
        LibraryName("csharp-tests"),
        RootNamespace("Autowrap.CSharp.Tests")
    )
);
