import autowrap;


enum str = wrapDlang!(
    LibraryName("prefix"),
    Modules("prefix"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
