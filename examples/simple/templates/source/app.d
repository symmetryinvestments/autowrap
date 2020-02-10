import autowrap;


enum str = wrapDlang!(
    LibraryName("templates"),
    Modules("templates"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
