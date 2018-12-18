module ut.python.conv;


import unit_threaded;
import python.conv;
import std.datetime: Date, DateTime;


struct IntString {
    int i;
    string s;
}


@UnitTest
@Types!(
    bool,
    byte, ubyte, short, ushort, int, uint, long, ulong,  // integral
    float, double,
    int[], double[],
)
void backAndForth(T)()
{
    check!((T d) => d.toPython.to!T == d);
}


@("DateTime")
unittest {
    const value = DateTime(2018, 1, 2, 3, 4, 5);
    value.toPython.to!DateTime.should == value;
}


@("Date")
unittest {
    const value = Date(2018, 1, 2);
    value.toPython.to!Date.should == value;
}


// FIXME: failing for unicode
@Values("foobar", "quux", /*"café"*/)
@("string")
unittest {
    const value = getValue!string;
    value.toPython.to!string.should == value;
}


@("array.static.int")
unittest {
    int[2] value = [1, 2];
    value.toPython.to!(int[2]).should == value;
}


@("array.static.double")
unittest {
    double[3] value = [11.1, 22.2, 33.3];
    value.toPython.to!(double[3]).should == value;
}


@("aa.int.string")
unittest {
    const value = [1: "foo", 2: "bar"];
    value.toPython.to!(typeof(value)).should == value;
}


@("aa.string.int")
unittest {
    const value = ["foo": 1, "bar": 2];
    value.toPython.to!(typeof(value)).should == value;
}
