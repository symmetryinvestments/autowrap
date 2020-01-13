import autowrap;


enum str = wrapDlang!(
    LibraryName("std_mmfile"),
    Modules(
        Yes.alwaysExport,
        "std.mmfile",
    )
);

// pragma(msg, str);
mixin(str);


/**
   Without this there is a linker error about an undefined symbol corrensponding
   to the .init value for the TypeInfo object for std.File.BinaryWriterImpl!true.
 */
void hack() {
    import std.stdio: File;
    auto id = typeid(File("/tmp/foo").lockingBinaryWriter);
}
