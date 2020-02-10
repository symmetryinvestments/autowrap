import autowrap;


enum str = wrapDlang!(
    LibraryName("adder"),
    Modules("adder"),
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
);
//pragma(msg,str);
mixin(str);
