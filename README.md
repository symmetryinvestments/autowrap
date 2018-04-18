# autowrap

[![Build Status](https://travis-ci.org/kaleidicassociates/autowrap.png?branch=master)](https://travis-ci.org/kaleidicassociates/autowrap)

Wrap existing D code for use in other environments such as Python and Excel.

## About

There are projects already to make it possible to use D code
[from Python](https://github.com/ariovistus/pyd) and
[from Excel](https://github.com/kaleidicassociates/excel-d).

In PyD, the functions and data structures must be registered manually,
and while the same isn't true of excel-d, the latter wraps everything
in the modules reflected on. When writing code specifically for Excel,
that is clearly what the user wants (and if not it can be made `private`).
When wrapping pre-existing D code, however, it makes sense to opt-in instead
by requiring functions to be wrapped to be marked `export`.

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

Since autowrap depends on PyD, the python version must be explicitly stated
as a dub configuration and defaults to 3.6. To use another version, pass
`-c $CONFIG` to dub where `$CONFIG` is one of:

* python27
* python34
* python35
* python36
