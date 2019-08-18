module python.embedded;
import python.raw;
import std.exception: enforce;
//#include <python3.7m/pythonrun.h>

/+
	Capabilities of pyd embedded interpreter:
		- run python code in D
		- run D code in python
		- declare python functions and use in D
		- access and manipulate python globals in D
		- wrap D classes/structs and use in python or D
		- wrap python class instances in D
		- wrap D ranges and iterate through them in python
		- wrap python iterators as D ranges
		- inheritance and multithreading
+/

//import deimos.python.Python;
import python.raw : PyObject, PyFrameObject;
import python.type;
import std.algorithm: findSplit;
import std.string: strip, outdent;
import std.traits;

char* zc()(string s) {
	    if(s.length && s[$-1] == 0) return s.dup.ptr;
		    return ((cast(char[])s) ~ "\0").ptr;
}

PyObject* pyImportModule(string name)
{
	import std.string : toStringz;
	import std.exception : enforce;
    enforce(pyIsInitialized(), "python not initialized");
	return PyImport_ImportModule(name.toStringz);
}

bool pyIsInitialized()
{
	return true;
}


/+
  Encapsulate a context within the Python interpreter.
  This will preserve local variables and changes to the Python interpreter
  made by 'from ___future__ import feature' across calls to this.py_eval and
  this.py_stmts.
  Otherwise, will not segregate global changes made to the Python interpreter.
+/
final class InterpContext
{
    /// dict object: global variables in this context
    PyObject* globals;
    /// dict object: local variables in this context
    PyObject* locals;
    PyCompilerFlags flags;
    PyFrameObject* frame;

    /**
      */
    this()
	{
		import std.string : toStringz;
        enforce(pyIsInitialized(), "python not initialized");
        locals = PyDict_New();
		globals = PyDict_New();
		PyDict_SetItemString(globals, "__builtins__",PyEval_GetBuiltins());
    }

    void pushDummyFrame()
	{
        auto threadstate = PyThreadState_Get();
        if (threadstate.frame is null)
		{
            PyCodeObject* code = PyCode_NewEmpty("<d>","<d>", 0);
            frame = PyFrame_New(threadstate, code,
                    cast(PyObject*)(globals),
                    cast(PyObject*)(locals));
            threadstate.frame = frame;
        }
    }

    void popDummyFrame()
	{
        auto threadstate = PyThreadState_Get();
        if(threadstate.frame == frame) {
            threadstate.frame = null;
        }
    }

    /**
      Evaluate a python expression once within this context and return the
      result.
		Params:
			python = a python expression
		Returns:
			the result of expression
     */
    T py_eval(T = PyObject*)( string pythonExpression, string file = __FILE__, size_t line = __LINE__)
	{
		import std.string : toStringz;
        auto pres = PyRun_StringFlags(
                pythonExpression.toStringz, 
                Py_eval_input,
                cast(PyObject*) globals,
                cast(PyObject*) locals,
                null); //&flags);
        if(pres) {
            return pres;
        }else{
			import std.stdio;
			stderr.writefln("file: %s, line: %s",file,line);
            //handle_exception(file,line);
            assert(0);
        }
    }
    /**
      Evaluate one or more python statements once.
Params:
python = python statements
     */
    auto evalStatements(string pythonStatements, string file = __FILE__, size_t line = __LINE__)
	{
        import std.string: outdent, toStringz;

        auto pres = PyRun_StringFlags(
                outdent(pythonStatements).toStringz,
                Py_file_input,
                cast(PyObject*) globals,
                cast(PyObject*) locals,
                &flags);
        if(pres) {
			auto ret = pres.toString();
			pyDecRef(pres);
			return ret;
        }else{
            //handle_exception(file,line);
			assert(0);
        }
    }

    @property PyObject opDispatch(string id)() {
        return this.locals[id];
    }

    @property void opDispatch(string id, T)(T t) {
        static if(is(T == PyObject)) {
            alias t s;
        }else{
            PyObject s = py(t);
        }
        this.locals[id] = py(s);
    }
}

/++
Wraps a python function (specified as a string) as a D function roughly of
signature func_t
Params:
python = a python function
pythonModule = context in which to run expression. must be a python module name.
func_t = type of d function
 +/
ReturnType!func_t py_def(func_t)(string pythonFunction, string pythonModule, ParameterTypeTuple!func_t args, string file = __FILE__, size_t line = __LINE__)
{
	import std.string : toStringz;
	alias ReturnType!func_t R;
	alias ParameterTypeTuple!func_t Args;
    enum afterdef = findSplit(pythonFunction, "def")[2];
    enum ereparen = findSplit(afterdef, "(")[0];
    enum name = strip(ereparen) ~ "\0";
    static PyObject func;
    static PythonException exc;
    static string errmsg;
    static bool once = true;
    enforce(pyIsInitialized(), "python not initialized");
    if(once)
	{
        once = false;
        auto globals = py_import(pythonModule).getdict();
        auto globals_ptr = pyIncRef(globals);
        scope(exit) pyDecRef(globals_ptr);
        auto locals = py((string[string]).init);
        auto locals_ptr = pyIncRef(locals);
        scope(exit) pyDecRef(locals_ptr);
        if("__builtins__" !in globals)
		{
			globals = PyDict_New();
			PyDict_SetItemString(globals, "__builtins__",PyEval_GetBuiltins());
        }
        auto pres = PyRun_String(
                    pythonFunction.toStringz,
                    Py_file_input, globals_ptr, locals_ptr);
        if(pres)
		{
            auto res = new PyObject(pres);
            func = locals[name];
        } else
		{
            try
			{
                handle_exception();
            } catch(PythonException e)
			{
                exc = e;
            }
        }
    }
    if(!func)
	{
        throw exc;
    }
    return func(args).to_d!R();
}

/++
Evaluate a python expression once and return the result.
Params:
python = a python expression
pythonModule = context in which to run expression. either a python module name, or "".
 +/
T evalExpression(T = PyObject*)(string pythonExpression, string pythonModule= "", string file = __FILE__, size_t line = __LINE__)
{
	import std.string : toStringz;
    enforce(pyIsInitialized(), "python not initialized");
    PyObject* locals = null;
	// FIXME
	pythonModule="";
    locals = (pythonModule == "") ? PyDict_New() :  pyImportModule(pythonModule); // .getdict();
	pyIncRef(locals);
    //if ("__builtins__" !in locals) {
		PyDict_SetItemString(locals, "__builtins__",PyEval_GetBuiltins());
    //}
    auto result = PyRun_StringFlags( pythonExpression.toStringz, Py_eval_input, locals, locals,null);
	scope(exit) Py_DecRef(locals);
	return result;
	/+
	//scope(exit) Py_XDecRef(locals);
    if(result)
	{
        //auto res = new PyObject(result);
		assert(0);
        // return res.to_d!T();
    }else
	{
        // handle_exception(file,line);
        assert(0);
    } +/
}

/++
Evaluate one or more python statements once.
Params:
python = python statements
modl = context in which to run expression. either a python module name, or "".
 +/
auto evalStatements(string pythonStatements, string module_ = "",string file = __FILE__, size_t line = __LINE__)
{
	import std.string : toStringz;
    enforce(pyIsInitialized(), "python not initialized");
    PyObject* locals;
    //PyObject* locals_ptr;
    if (module_ == "") {
        locals = PyDict_New();
    }else {
        //locals = pyImportModule(module_).getdict();
    }
    pyIncRef(locals);
	//locals_ptr = locals;
	// locals_ptr = pyIncRef(locals); // locals.ptr);
    //if("__builtins__" !in locals) {
        //auto builtins = new PyObject(PyEval_GetBuiltins());
        // locals["__builtins__"] = builtins;
    //}
    auto pres = PyRun_StringFlags(
            outdent(pythonStatements).toStringz,
            Py_file_input, locals, locals,null);
	return pres; 
	/+
    scope(exit) pyDecRef(locals);
    if(pres) {
        pyDecRef(pres);
    }else{
        //handle_exception(file,line);
		assert(0);
    } +/
}
alias py_stmts = evalStatements;

void evalSimpleString(string s)
{
	import std.string : toStringz;
	PyRun_SimpleStringFlags(s.toStringz,null);
}
void initializePython()
{
	Py_Initialize();
}

string toString(PyObject* o)
{
	import std.string : fromStringz;
	char* s;
	PyArg_Parse(o, "s",&s);
	return s.fromStringz.idup;
}

PyObject* getMember(PyObject* parent, string memberName)
{
	import std.string: toStringz;
	return PyObject_GetAttrString(parent,memberName.toStringz);
}

PyObject* getModuleMember(string moduleName, string memberName)
{
	auto pmod = pyImportModule(moduleName);
	auto ret = getMember(pmod,memberName);
	Py_DecRef(pmod);
	return ret;
}

PyObject* callObject(PyObject* o, PyObject* args)
{
	return null; // PyEval_CallObject(o,args);
}

PyObject* construct(string moduleName, string className)
{
	auto pythonClass = getModuleMember(moduleName, className);
	auto pythonArgs = Py_BuildValue("()");
	auto result = callObject(pythonClass,pythonArgs);
	Py_DecRef(pythonClass);
	Py_DecRef(pythonArgs);
	return result;
}

PyObject* pyBuildValue(Args...)(string formatString, Args args)
{
	import std.string : toStringz;
	return Py_BuildValue(formatString.toStringz,args);
}

auto pyParseArgs(Args...)(PyObject* o, string formatString)
{
	import std.string : toStringz;
	import std.typecons: Tuple, tuple;
	import std.algorithm : map;
	import std.array : array;
	Tuple!Args args;
	auto argsPtr = args.map!(arg => &arg).array;
	PyArg_Parse(formatString,argsPtr);
	return args;
}

