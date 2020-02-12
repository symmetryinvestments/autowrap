import autowrap;

enum str = wrapDlang!(
    LibraryName("std_digest"),
    Modules(
        Yes.alwaysExport,
        "std.digest.crc",
        "std.digest.digest",
        "std.digest.hmac",
        "std.digest.md",
        "std.digest.murmurhash",
        "std.digest.ripemd",
        "std.digest.sha",
    )
);

// pragma(msg, str);
mixin(str);
