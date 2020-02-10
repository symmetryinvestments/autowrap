import autowrap;


enum str = wrapDlang!(
    LibraryName("api"),
    Modules("api"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
