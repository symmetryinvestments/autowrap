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

pragma(msg, wrapCSharp("csharp",
        Modules(
            Module("csharp.library")
        )
    )
);

mixin(
    wrapCSharp("csharp",
        Modules(
            Module("csharp.library")
        )
    )
);
