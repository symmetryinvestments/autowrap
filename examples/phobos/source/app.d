import autowrap;

enum str = wrapDlang!(
    LibraryName("phobos"),
    Modules(
        Module("std.algorithm.comparison", Yes.alwaysExport),
        Module("std.algorithm.iteration", Yes.alwaysExport),
        Module("std.algorithm.mutation", Yes.alwaysExport),
        Module("std.algorithm.searching", Yes.alwaysExport),
        Module("std.algorithm.setops", Yes.alwaysExport),
        Module("std.algorithm.sorting", Yes.alwaysExport),
        Module("std.array", Yes.alwaysExport),
        Module("std.ascii", Yes.alwaysExport),
        Module("std.base64", Yes.alwaysExport),
        Module("std.bigint", Yes.alwaysExport),
        Module("std.socket", Yes.alwaysExport),
    ),
);

// pragma(msg, str);
mixin(str);
