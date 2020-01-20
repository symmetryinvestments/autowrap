import autowrap;

enum str = wrapDlang!(
    LibraryName("std_xml"),
    Modules(
        Module("std.xml",
               Yes.alwaysExport,
               Ignore("ElementParser"), // FIXME
        ),
    )
);

// pragma(msg, str);
mixin(str);
