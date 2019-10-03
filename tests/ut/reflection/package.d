module reflection;


import autowrap.reflection;
import unit_threaded;
import std.typecons: Yes;


@("isStatic")
@safe pure unittest {
    static struct Struct {
        int foo();
        static int bar();
    }

    static assert(!isStatic!(Struct.foo));
    static assert( isStatic!(Struct.bar));
}


@("Functions.export")
@safe pure unittest {
    alias functions = Functions!(Module("modules.functions"));
    functions.length.should == 2;

    static import modules.functions;

    functions[0].name.should == "stringRet";
    static assert(__traits(isSame, functions[0].module_, modules.functions));
    functions[0].moduleName.should == "modules.functions";
    static assert(__traits(isSame, functions[0].symbol, modules.functions.stringRet));

    functions[1].name.should == "twice";
    static assert(__traits(isSame, functions[1].module_, modules.functions));
    functions[1].moduleName.should == "modules.functions";
    static assert(__traits(isSame, functions[1].symbol, modules.functions.twice));
}


@("Functions.all")
@safe pure unittest {
    alias functions = Functions!(Module("modules.functions", Yes.alwaysExport));
    functions.length.should == 3;
}


@("BinaryOperators")
@safe pure unittest {

    static struct Number {
        int i;
        Number opBinary(string op)(Number other) if(op == "+") {
            return Number(i + other.i);
        }
        Number opBinary(string op)(Number other) if(op == "-") {
            return Number(i - other.i);
        }
        Number opBinaryRight(string op)(int other) if(op == "+") {
            return Number(i + other);
        }
    }

    static assert(
        [BinaryOperators!Number] ==
        [
            BinaryOperator("+", BinOpDir.left | BinOpDir.right),
            BinaryOperator("-", BinOpDir.left),
        ]
    );
}


@("UnaryOperators")
@safe pure unittest {

    static struct Struct {
        int opUnary(string op)() if(op == "+") { return 42; }
        int opUnary(string op)() if(op == "~") { return 33; }
    }

    static assert([UnaryOperators!Struct] == ["+", "~"]);
}


@("AssignOperators")
@safe pure unittest {

    static struct Number {
        int i;
        Number opOpAssign(string op)(Number other) if(op == "+") {
            return Number(i + other.i);
        }
        Number opOpAssign(string op)(Number other) if(op == "-") {
            return Number(i - other.i);
        }
        Number opOpAssignRight(string op)(int other) if(op == "+") {
            return Number(i + other);
        }
    }

    static assert([AssignOperators!Number] == ["+", "-"]);
}
