version(Have_autowrap_csharp)  // very weird dmd bug mixed with weirder C# mixin strings
    import autowrap.csharp;
else
    import autowrap;


immutable Modules modules = Modules(Module("prefix"),
                                    Module("adder"),
                                    Module("structs"),
                                    Module("templates"),
                                    Module("api"),
                                    Module("wrap_all", Yes.alwaysExport));


enum str = wrapDlang!(
    LibraryName("simple"),
    modules,
    RootNamespace("Autowrap.CSharp.Examples.Simple"),
    );
//pragma(msg,str);
mixin(str);
