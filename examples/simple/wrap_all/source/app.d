import autowrap;


enum str = wrapDlang!(
    LibraryName("wrap_all"),
    Modules(Yes.alwaysExport, "wrap_all"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
