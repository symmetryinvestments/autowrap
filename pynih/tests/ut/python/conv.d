module ut.python.conv;


import unit_threaded;
import python.conv;
import std.datetime: Date, DateTime;


struct IntString {
    int i;
    string s;
}


@Serial
@UnitTest
@Types!(
    bool,
    byte, ubyte, short, ushort, int, uint, long, ulong,  // integral
    float, double,  // floating point
    int[], double[],
)
void backAndForth(T)()
{
    check!((T d) => d.toPython.to!T == d);
}


@Serial
@("DateTime")
unittest {
    const value = DateTime(2018, 1, 2, 3, 4, 5);
    value.toPython.to!DateTime.should == value;
}


@Serial
@("Date")
unittest {
    const value = Date(2018, 1, 2);
    value.toPython.to!Date.should == value;
}


// FIXME: failing for unicode
@Serial
@Values("foobar", "quux", /*"café"*/)
@("string")
unittest {
    const value = getValue!string;
    value.toPython.to!string.should == value;
}


@Serial
@("array.static.int")
unittest {
    int[2] value = [1, 2];
    value.toPython.to!(int[2]).should == value;
}


@Serial
@("array.static.double")
unittest {
    double[3] value = [11.1, 22.2, 33.3];
    value.toPython.to!(double[3]).should == value;
}
