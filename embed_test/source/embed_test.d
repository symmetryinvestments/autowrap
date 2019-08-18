module embed_test;
import python.embedded;
import python.raw;
import std.exception: enforce;
import python.raw : PyObject, PyFrameObject;
import python.type;
import std.algorithm: findSplit;
import std.string: fromStringz;
import std.traits;
import std.stdio: writeln, writefln;

void main(string[] args)
{
	initializePython();
	auto interp = new InterpContext;
	//interp.evalStatements(`print("hello")`);
	interp.evalStatements(`a=1+3; print(a)`);
	//auto result = evalExpression("1 + 3");
	//auto result = interp.py_eval(`print("hello")`);
	//writeln(result.toString());
}

