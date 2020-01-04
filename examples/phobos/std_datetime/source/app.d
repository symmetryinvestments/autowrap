import autowrap;


enum str = wrapDlang!(
    LibraryName("std_datetime"),
    Modules(
        Yes.alwaysExport,
        "std.datetime.date",
        "std.datetime.interval",
        "std.datetime.stopwatch",
        "std.datetime.systime",
        "std.datetime.timezone",
    )
);

// pragma(msg, str);
mixin(str);
