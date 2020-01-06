/**
   Types to be used in the API for type-safety
   (as opposed to, say, raw strings).
 */
module autowrap.types;


template isModule(alias T) {
    import std.traits: Unqual;
    static if(is(T))
        enum isModule = is(Unqual!T == Module);
    else
        enum isModule = is(Unqual!(typeof(T)) == Module);
}


/**
   The list of modules to automatically wrap for consumption by other languages.
 */
struct Modules {
    import std.traits: Unqual;
    import std.meta: allSatisfy;
    import std.typecons: Flag;

    private enum isString(T) = is(Unqual!(T) == string);
    private enum isModuleOrString(T) = isModule!T || isString!T;

    Module[] value;

    this(A...)(auto ref A modules) if(allSatisfy!(isModuleOrString, A)) {

        foreach(module_; modules) {
            static if(is(Unqual!(typeof(module_)) == Module))
                value ~= module_;
            else static if(is(Unqual!(typeof(module_)) == string))
                value ~= Module(module_);
            else
                static assert(false, "Modules must either be `string` or `Module`");
        }
    }

    this(A...)(Flag!"alwaysExport" alwaysExport, A moduleNames) if(allSatisfy!(isString, A)) {
        static foreach(moduleName; moduleNames) {
            value ~= Module(moduleName, alwaysExport);
        }
    }
}

/**
   A module to automatically wrap.
   Usually not needed since a string will do, but is useful when trying to export
   all functions from a module by using Module("mymodule", Yes.alwaysExport)
   instead of "mymodule"
 */
struct Module {
    import std.typecons: Flag, No;

    string name;
    Flag!"alwaysExport" alwaysExport = No.alwaysExport;
    Ignore[] ignoredSymbols;

    this(string name) {
        this(name, No.alwaysExport);
    }

    this(string name, Flag!"alwaysExport" alwaysExport, Ignore[] ignoredSymbols...) {
        this.name = name;
        this.alwaysExport = alwaysExport;
        this.ignoredSymbols = ignoredSymbols;
    }

    string toString() @safe pure const {
        import std.conv: text;
        import std.string: capitalize;
        return text(`Module("`, name, `", `, text(alwaysExport).capitalize, `.alwaysExport, `, ignoredSymbols, `)`);
    }
}


/**
   Used in a module to ignore certain symbols
 */
struct Ignore {
    string identifier;
}

/**
   The name of the dynamic library, i.e. the file name with the .so/.dll extension
 */
struct LibraryName {
    string value;
}

/**
   Code to be inserted before the call to module_init
 */
struct PreModuleInitCode {
    string value;
}

/**
   Code to be inserted after the call to module_init
 */
struct PostModuleInitCode {
    string value;
}


struct RootNamespace {
    string value;
}

struct OutputFileName {
    string value;
}
