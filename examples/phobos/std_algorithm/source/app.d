import autowrap;

enum str = wrapDlang!(
    LibraryName("std_algorithm"),
    Modules(
        Yes.alwaysExport,
        "std.algorithm.comparison",
        "std.algorithm.iteration",
        "std.algorithm.mutation",
        "std.algorithm.searching",
        "std.algorithm.setops",
        "std.algorithm.sorting",
        )
    );

// pragma(msg, str);
mixin(str);
