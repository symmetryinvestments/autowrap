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


@("isUserAggregate!DateTime")
@safe pure unittest {
    import std.datetime: DateTime;
    static assert(!isUserAggregate!DateTime);
}


@("isUserAggregate!Tuple")
@safe pure unittest {
    import std.typecons: Tuple;
    static assert(!isUserAggregate!(Tuple!(int, double)));
}


@("PrimordialType")
@safe pure unittest {
    static assert(is(PrimordialType!int == int));
    static assert(is(PrimordialType!(int[]) == int));
    static assert(is(PrimordialType!(int[][]) == int));
    static assert(is(PrimordialType!(double[][]) == double));
    static assert(is(PrimordialType!(string[][]) == char));
    static assert(is(PrimordialType!(int*) == int));
    static assert(is(PrimordialType!(int**) == int));
}


@("RecursiveAggregates.scalar")
@safe pure unittest {
    static assert(is(RecursiveAggregates!int == int));
    static assert(is(RecursiveAggregates!double == double));
}


@("RecursiveAggregates.nested")
@safe pure unittest {
    import std.meta: AliasSeq;

    static struct Inner0 {
        int i;
        double d;
    }

    static struct Inner1 {
        string s;
    }

    static struct Mid {
        Inner0 inner0;
        Inner1 inner1;
    }

    static struct Outer {
        Mid mid;
        byte b;
    }

    static assert(is(RecursiveAggregates!Outer == AliasSeq!(Mid, Inner0, Inner1, Inner0, Inner1)));
}


@("RecursiveAggregates.typedef")
@safe pure unittest {
    import std.typecons: Typedef;
    import std.meta: AliasSeq;

    alias Int = Typedef!int;
    static assert(is(RecursiveAggregates!Int == int));

    alias Double = Typedef!double;
    static assert(is(RecursiveAggregates!Double == double));

    static struct Inner {}
    static struct Foo {
        Inner inner;
        int i;
    }

    static assert(is(RecursiveAggregates!Foo == AliasSeq!(Inner, Inner)));
    alias TFoo = Typedef!Foo;
    static assert(is(AliasSeq!(RecursiveAggregates!TFoo) == AliasSeq!Foo));
}


@("RecursiveAggregates.Date")
@safe pure unittest {
    import std.datetime: Date;
    import std.meta: AliasSeq;

    static struct Inner {
        Date date;
    }
    static struct Foo {
        Inner inner;
        int i;
    }

    static assert(is(RecursiveAggregates!Foo == AliasSeq!(Inner, Date, Date)));
}
