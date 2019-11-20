version(Have_autowrap_pynih)
    import autowrap.pynih;
else version(Have_autowrap_csharp)
    import autowrap.csharp;
else version(Have_autowrap_pyd)
    import autowrap.pyd;
else version(Have_autowrap_excel)
    import autowrap.excel;


immutable Modules modules = Modules(Module("prefix"),
                                    Module("adder"),
                                    Module("structs"),
                                    Module("templates"),
                                    Module("api"),
                                    Module("wrap_all", Yes.alwaysExport));


version(WrapExcel) {
    import xlld:wrapAll;

    mixin(
        wrapAll!(
            "prefix",
            "adder",
            "structs",
            "templates",
            "api",
            "wrap_all",
        ),
    );

} else {
    enum str = wrapDlang!(
        LibraryName("simple"),
        modules,
        RootNamespace("Autowrap.CSharp.Examples.Simple"),
    );
    //pragma(msg,str);
    mixin(str);
}
