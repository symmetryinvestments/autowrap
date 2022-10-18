import autowrap;

enum str = wrapDlang!(
    LibraryName("std_encoding"),
    Modules(
        Yes.alwaysExport,
        "std.encoding",
        )
    );

// pragma(msg, str);
mixin(str);


import std.encoding;
pragma(mangle, "_D3std8encoding14EncodingScheme8toStringMxFZAya")
private string dummy0(EncodingScheme) {
    assert(0);
}
