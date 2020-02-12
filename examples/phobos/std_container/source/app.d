import autowrap;

enum str = wrapDlang!(
    LibraryName("std_container"),
    Modules(
        Yes.alwaysExport,
        "std.container.array",
        "std.container.binaryheap",
        "std.container.dlist",
        "std.container.rbtree",
        "std.container.slist",
        "std.container.util",
        )
    );

// pragma(msg, str);
mixin(str);
