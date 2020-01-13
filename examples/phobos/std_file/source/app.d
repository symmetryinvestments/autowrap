import autowrap;


enum str = wrapDlang!(
    LibraryName("std_file"),
    Modules(
        Yes.alwaysExport,
        "std.file",
    )
);

// pragma(msg, str);
mixin(str);

/**
   Without this there is a linker error about an undefined symbol corrensponding
   to the .init value for the TypeInfo object for the return type of this
   overload of std.file.dirEntries.
 */
void hack() {
    import std.file: dirEntries, SpanMode;
    auto id = typeid(dirEntries("path", "pattern", SpanMode.depth));
}
