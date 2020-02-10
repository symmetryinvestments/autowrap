import autowrap;


enum str = wrapDlang!(
    LibraryName("structs"),
    Modules("structs"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
