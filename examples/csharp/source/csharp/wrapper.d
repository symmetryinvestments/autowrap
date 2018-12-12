module csharp.wrapper;

import csharp.library;
import autowrap.csharp;

mixin(
    wrapCSharp(
        Modules(
            Module("csharp.library")
        ),
        OutputFileName("Wrapper.cs"),
        LibraryName("csharp"),
        RootNamespace("csharp")
    )
);
