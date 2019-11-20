/**
   Types to be used in the API for type-safety
   (as opposed to, say, raw strings).
 */
module autowrap.types;


template isModule(alias T) {
    import std.traits: Unqual;
    enum isModule = is(Unqual!(typeof(T)) == Module);
}


/**
   The list of modules to automatically wrap for consumption by other languages.
 */
struct Modules {
    import std.traits: Unqual;
    import std.meta: allSatisfy;

    Module[] value;

    this(A...)(auto ref A modules) {

        foreach(module_; modules) {
            static if(is(Unqual!(typeof(module_)) == Module))
                value ~= module_;
            else static if(is(Unqual!(typeof(module_)) == string))
                value ~= Module(module_);
            else
                static assert(false, "Modules must either be `string` or `Module`");
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

    string toString() @safe pure const {
        import std.conv: text;
        import std.string: capitalize;
        return text(`Module("`, name, `", `, text(alwaysExport).capitalize, `.alwaysExport)`);
    }
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
