import autowrap;


enum str = wrapDlang!(
    LibraryName("issues"),
    Modules(
        "issues",
//        "external",
    ),
);
// pragma(msg, str);
mixin(str);
