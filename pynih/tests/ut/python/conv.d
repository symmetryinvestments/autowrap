module ut.python.conv;


import unit_threaded;
import python.conv;
import std.datetime: Date, DateTime;
import std.typecons: tuple;


struct IntString {
    int i;
    string s;
}


// helper function to test that converting to python and back yields the same value
private void backAndForth(T)
                         (T value, in string file = __FILE__, in size_t line = __LINE__)
{
    value.toPython.to!(typeof(value)).shouldEqual(value, file, line);
}


@Types!(
    bool,
    byte, ubyte, short, ushort, int, uint, long, ulong,  // integral
    float, double,
    int[], double[],
)
void testBackAndForth(T)()
{
    check!((T d) => d.toPython.to!T == d);
}


@("DateTime")
unittest {
    backAndForth(DateTime(2018, 1, 2, 3, 4, 5));
}


@("Date")
unittest {
    backAndForth(Date(2018, 1, 2));
}


// FIXME: failing for unicode
@Values("foobar", "quux", /*"café"*/)
@("string")
unittest {
    const value = getValue!string;
    backAndForth(value);
}


@("array.static.int")
unittest {
    int[2] value = [1, 2];
    backAndForth(value);
}


@("array.static.double")
unittest {
    double[3] value = [11.1, 22.2, 33.3];
    backAndForth(value);
}


@("aa.int.string")
unittest {
    backAndForth([1: "foo", 2: "bar"]);
}


@("aa.string.int")
unittest {
    backAndForth(["foo": 1, "bar": 2]);
}


@("tuple.int.int.int")
unittest {
    backAndForth(tuple(3, 5, 7));
}


@("tuple.int.string")
unittest {
    backAndForth(tuple(42, "foo"));
}


@("udt.intstring.val")
unittest {
    backAndForth(IntString(42, "quux"));
}

@("udt.intstring.ptr")
unittest {
    const value = new IntString(42, "quux");
    const back = value.toPython.to!(typeof(value));
    (*back).should == *value;
}


@("udt.class")
unittest {

    static class Class {
        int i;
        this(int i) { this.i = i; }
        int twice() @safe @nogc pure nothrow const { return i * 2; }
        override string toString() @safe pure const {
            import std.conv: text;
            return text("Class(", i, ")");
        }
    }

    backAndForth(new Class(42));
}
