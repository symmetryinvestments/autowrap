import autowrap;

enum str = wrapDlang!(
    LibraryName("pyd"),
    Modules(
        Module("arraytest", Yes.alwaysExport),
        Module("inherit", Yes.alwaysExport),
        Module("testdll", Yes.alwaysExport),
        Module("def", Yes.alwaysExport),
        Module("struct_wrap", Yes.alwaysExport),
        Module("const_", Yes.alwaysExport),
        Module("class_wrap", Yes.alwaysExport),
        Module("funcs", Yes.alwaysExport),
    ),
);
//pragma(msg, str);
mixin(str);
