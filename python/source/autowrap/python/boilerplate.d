/**
   Necessary boilerplate for pyd.

   To wrap all functions/return/parameter types and  struct/class definitions from
   a list of modules, write this in a "main" module and generate mylib.{so,dll}:

   ------
   mixin wrapAll(LibraryName("mylib"), Modules("module1", "module2", ...));
   ------
 */
module autowrap.python.boilerplate;

import autowrap.reflection : Modules;

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


/**
   A string to be mixed in that defines all the necessary runtime pyd boilerplate.
 */
string wrapAll(in LibraryName libraryName,
               in Modules modules,
               in PreModuleInitCode preModuleInitCode = PreModuleInitCode(),
               in PostModuleInitCode postModuleInitCode = PostModuleInitCode())
    @safe pure
{
    if(!__ctfe) return null;

    string ret =
        pydMainMixin(modules, preModuleInitCode, postModuleInitCode) ~
        pydInitMixin(libraryName.value);

    version(Have_excel_d) {
        ret ~=
        // this is needed because of the excel-d dependency
        q{
            import xlld.wrap.worksheet: WorksheetFunction;
            extern(C) WorksheetFunction[] getWorksheetFunctions() @safe pure nothrow { return []; }
        };
    } else version(Windows) {
        ret ~= dllMainMixinStr;
    }

    return ret;
}

/**
   A string to be mixed in that defines PydMain, automatically registering all
   functions and structs in the passed in modules.
 */
string pydMainMixin(in Modules modules,
                    in PreModuleInitCode preModuleInitCode = PreModuleInitCode(),
                    in PostModuleInitCode postModuleInitCode = PostModuleInitCode())
    @safe pure
{
    import std.format: format;
    import std.algorithm: map;
    import std.array: join;

    if(!__ctfe) return null;

    const modulesList = modules.value.map!(a => a.toString).join(", ");

    return q{
        extern(C) void PydMain() {
            import std.typecons: Yes, No;
            import pyd.pyd: module_init;
            import autowrap.python.wrap: wrapAllFunctions, wrapAllAggregates;

            // this must go before module_init
            wrapAllFunctions!(%s);

            %s

            module_init;

            // this must go after module_init
            wrapAllAggregates!(%s);

            %s
        }
    }.format(modulesList, preModuleInitCode.value, modulesList, postModuleInitCode.value);
}

/**
   A string to be mixed in that defines the PyInit function for a library.
 */
string pydInitMixin(in string libraryName) @safe pure {
    import std.format: format;

    if(!__ctfe) return null;

    version(Python_3_0_Or_Later) {
        return q{
            import deimos.python.object: PyObject;
            extern(C) export PyObject* PyInit_%s() {
                import pyd.def: pyd_module_name, pyd_modules;
                import pyd.exception: exception_catcher;
                import pyd.thread: ensureAttached;

                return exception_catcher(delegate PyObject*() {
                        ensureAttached();
                        pyd_module_name = "%s";
                        PydMain();
                        return pyd_modules[""];
                    });
            }
        }.format(libraryName, libraryName);
    } else {
        return q{
            import pyd.exception: exception_catcher;
            import pyd.thread: ensureAttached;
            import pyd.def: pyd_module_name;
            extern(C) export void init%s() {
                exception_catcher(delegate void() {
                        ensureAttached();
                        pyd_module_name = "%s";
                        PydMain();
                    });

            }
        }.format(libraryName, libraryName);
    }
}
