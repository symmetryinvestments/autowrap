import autowrap;


enum str = wrapDlang!(
    LibraryName("issues"),
    Modules(
        "issues",
    ),
);
// pragma(msg, str);
mixin(str);
