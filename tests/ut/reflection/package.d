module ut.reflection;


import autowrap.reflection;
import unit_threaded;
import std.typecons: Yes;


@("Functions.export")
@safe pure unittest {
    alias functions = Functions!(Module("modules.functions"));
    functions.length.should == 2;

    static import modules.functions;

    functions[0].identifier.should == "stringRet";
    static assert(__traits(isSame, functions[0].symbol, modules.functions.stringRet));

    functions[1].identifier.should == "twice";
    static assert(__traits(isSame, functions[1].symbol, modules.functions.twice));
}


@("Functions.all")
@safe pure unittest {
    alias functions = Functions!(Module("modules.functions", Yes.alwaysExport));
    functions.length.should == 3;
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
