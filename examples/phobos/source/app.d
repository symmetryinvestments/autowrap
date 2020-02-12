/**
   None of the modules below work
 */
import autowrap;

version(Have_autowrap_pyd) {
    enum modules = Modules(
        Module("std.bitmanip", Yes.alwaysExport),  // compilation failure
    );
} else {
    enum modules = Modules(
        Module("std.concurrency", Yes.alwaysExport), // compilation failure
        Module("std.experimental.logger.core", Yes.alwaysExport), // compilation failure
        Module("std.experimental.logger.filelogger", Yes.alwaysExport), // compilation failure
        Module("std.experimental.logger.multilogger", Yes.alwaysExport), // compilation failure
        Module("std.experimental.logger.nulllogger", Yes.alwaysExport),  // compilation failure
        Module("std.parallelism", Yes.alwaysExport), // compilation failure
    );
}


enum str = wrapDlang!(
    LibraryName("phobos"),
    modules,
);

// pragma(msg, str);
mixin(str);
