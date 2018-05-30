module autowrap.excel;


string wrapAll(Modules...)(in string mainModule = __MODULE__) {
    if(!__ctfe) return "";

    import xlld: wrapAll_ = wrapAll;
    import std.typecons: Yes;

    return
        "import xlld;\n" ~
        wrapAll_!Modules(Yes.onlyExports, mainModule);
}
