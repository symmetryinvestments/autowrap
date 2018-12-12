# autowrap

[![Build Status](https://travis-ci.org/kaleidicassociates/autowrap.png?branch=master)](https://travis-ci.org/kaleidicassociates/autowrap)

Wrap existing D code for use in other environments such as Python, Excel, and .NET.

# About

There are projects already to make it possible to use D code
[from Python](https://github.com/ariovistus/pyd) and
[from Excel](https://github.com/kaleidicassociates/excel-d).

In PyD, the functions and data structures must be registered manually,
and while the same isn't true of excel-d, the latter wraps everything
in the modules reflected on. When writing code specifically for Excel,
that is clearly what the user wants (and if not it can be made `private`).
When wrapping pre-existing D code, however, it makes sense to opt-in instead
by requiring functions to be wrapped to be marked `export`. If one wants to
wrap all functions regardless of `export`, use `version=AutowrapAlwaysExport`.

There is [ppyd](https://github.com/John-Colvin/ppyd) that makes the effort
required to use pyd a lot less but that requires using a UDA. Again, when
writing code specifically for Python use this makes sense, but adds a
dependency that "dirties" pre-existing D code.

This dub package makes it possible to wrap pre-existing D code "from the outside",
imposing no dependencies on the aforementioned body of work.

autowrap also does away with the boilerplate necessary to creating a Python extension
with PyD. Things should just work.

To wrap for Python, make a dub dynamicLibrary project with one file:

```d
import autowrap.python;
mixin(
    wrapAll(
        LibraryName("mylibrary"),
        Modules("my.module1", "my.module2", /* ... */),
    )
);
```

Assuming the dub package name is also "mylibrary", you should get libmylibrary.so/mylibrary.dll.
If the former, rename it to mylibrary.so and you'll be able to use it from Python:


```Python
import mylibrary

mylibrary.func1()
```

The camelCase D functions are wrapped by snake_case Python functions, but struct members
have the same names.

It is also possible to wrap all functions regardless of their `export` status on a
module-by-module basis. To do so, instead of using a string to designate the module,
do this instead:

```d
Modules("my.module1", Module("my.module2", Yes.alwaysExport))
```


To wrap for Excel:

```d
import autowrap.excel;

mixin(
    wrapAll!(
        "my.module1", "my.module2", /* ... */
    )
);

```

The camelCase D functions will be PascalCase in Excel.


## Python versions

Since autowrap depends on PyD, the version of python to use must be specified.
You can either specify the configuration explicity, e.g.
`subConfiguration "autowrap:python" "python36"` or you can use the default `env`
configuration. In order to build using the `env` configuration your must first
set the relevant environment variables using the `pyd_set_env_vars.{sh,bat}`
scripts, which you can copy to your current working directory by running
`dub run pyd:setup`. See
[the pyd docs](https://pyd.readthedocs.io/en/latest/dub.html) for more
information.

# .NET Support

Autowrap can also generate C# bindings to D libraries. Generating bindings for C# is a two-step process. First we must generate a C# compatible C-interface for the D library, then we build and run a version of the library that emits the corresponding C# interface code.

### What Works:

* Module Functions
* Primitive Types
  * string
  * wstring
  * dstring
  * byte
  * ubyte
  * short
  * ushort
  * int
  * uint
  * long
  * ulong
  * float
  * double
* Structs
  * Fields
  * Properties
  * Methods
* Classes
  * Constructors
  * Fields
  * Properties
  * Methods

1-Dimensional Ranges are implemented but only lightly tested and may not work in all cases. Higher dimensional ranges are not supported.

## Generating .NET Interfaces

To generate the C-interface use the following example replacing "csharp" with the dub name of your library (ex: csharp builds to libcsharp&#46;so) and replace "csharp.library" with the name of the module you want to wrap.

```d
import csharp.library;
import autowrap.csharp;

mixin(
    wrapCSharp("csharp",
        Modules(
            Module("csharp.library")
        )
    )
);
```

To generate the C# interface use the emitCSharp mixin as follows to dump the output to a location of your choice. This mixin creates a void main() function that will need to be executed by running the code. (This is due to the inability of CTFE to write files to the disk.)

```d
mixin(
    emitCSharp(
        Modules(
            Module("csharp.library")
        ),
        OutputFileName("Wrapper.cs"),
        LibraryName("csharp"),
        RootNamespace("csharp")
    )
);
```

## Full Example

```d
module csharp.wrapper;

import csharp.library;
import autowrap.csharp;

immutable Modules modules = Modules(Module("test"));

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
```

# Our sponsors

[<img src="https://raw.githubusercontent.com/libmir/mir-algorithm/master/images/symmetry.png" height="80" />](http://symmetryinvestments.com/) 	&nbsp; 	&nbsp;	&nbsp;	&nbsp;
[<img src="https://raw.githubusercontent.com/libmir/mir-algorithm/master/images/kaleidic.jpeg" height="80" />](https://github.com/kaleidicassociates)
