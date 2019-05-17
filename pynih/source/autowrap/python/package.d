module autowrap.python;


public import std.typecons: Yes, No;
public import autowrap.reflection: Modules, Module;


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


string wrapAll(in LibraryName libraryName,
               in Modules modules,
               in PreModuleInitCode preModuleInitCode = PreModuleInitCode(),
               in PostModuleInitCode postModuleInitCode = PostModuleInitCode())
    @safe pure
{
    if(!__ctfe) return null;
    return "";
}
