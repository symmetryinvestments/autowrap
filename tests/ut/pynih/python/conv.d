module ut.pynih.python.conv;


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
                         (auto ref T value, in string file = __FILE__, in size_t line = __LINE__)
{
    value.toPython.to!(typeof(value)).shouldEqual(value, file, line);
}


@Types!(
    bool,
    byte, ubyte, short, ushort, int, uint, long, ulong,  // integral
    float, double,
)
void testBackAndForthNoGc(T)()
{
    check!((T d) @nogc => d.toPython.to!T == d);
}


@Types!(
    int[], double[],
)
void testBackAndForthGc(T)()
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


// FIXME - crashes dmd 2.100.1
// @Values("foobar", "quux")
// @("string.ascii")
// unittest {
//     const value = getValue!string;
//     backAndForth(value);
// }


// FIXME - crashes dmd 2.100.1
// @ShouldFail
// @Values("café", "açaí")
// @("string.unicode")
// unittest {
//     const value = getValue!string;
//     backAndForth(value);
// }

@("stringz")
unittest {
    import std.string: toStringz, fromStringz;
    const value = "foobar".toStringz;
    value.toPython.to!(typeof(value)).fromStringz.should == "foobar";
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


@("array.static.immutable(int)")
unittest {
    immutable(int)[3] ints = [1, 2, 3];
    backAndForth(ints);
}


@("array.slice.char")
unittest {
    auto chars = ['a', 'b', 'c'];
    backAndForth(chars);
}


@("array.slice.immutable(int)")
unittest {
    immutable(int)[] ints = [1, 2, 3];
    backAndForth(ints);
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


@("udt.class.baseref")
unittest {
    import std.conv: text;
    import std.string: fromStringz;

    static class Base {
        int i;
        this() {}
        this(int i) { this.i = i; }
        int twice() @safe @nogc pure nothrow const { return i * 2; }
        override string toString() @safe pure const {
            import std.conv: text;
            return text("Base(", i, ")");
        }
    }

    static class Child: Base {
        this() {}
        this(int i) { super(i); }
        override string toString() @safe pure const {
            import std.conv: text;
            return text("Child(", i, ")");
        }
    }


    auto child = new Child(42);
    child.toString.should == "Child(42)";
    auto python = child.toPython;
    auto back = python.to!Base;
    assert(typeid(back) == typeid(Child), text("Expected Child but got ", typeid(back)));
    back.toString.should == "Child(42)";
}


@("udt.struct.ptr.uncopiable")
unittest {
    static struct Uncopiable {
        @disable this(this);
        int i;
    }
    const value = new Uncopiable(42);
    const back = value.toPython.to!(typeof(value));
}


@("udt.struct.char")
unittest {
    static struct Char {
        char c;
    }
    backAndForth(Char('a'));
}


@("udt.struct.charptr")
unittest {
    static struct CharPtr {
        char* ptr;
        bool opEquals(in CharPtr other) @safe @nogc pure nothrow const {
            if(ptr  is null  && other.ptr  is null) return true;
            if(ptr  is null  && other.ptr !is null) return false;
            if(ptr !is null  && other.ptr  is null) return false;
            return *ptr == *other.ptr;
        }
    }
    backAndForth(CharPtr(new char('a')));
}


// Similar to issue with std.bitmanip.BitArray.
// The presence of `opCast` makes the conversion to `const(T)` fail
// since there's no available cast to `const(T)`.
@("udt.struct.opCast")
unittest {
    static struct Struct {

        void[] opCast(T: void[])() @safe @nogc pure nothrow {
            return null;
        }

        size_t[] opCast(T: size_t[])() @safe @nogc pure nothrow {
            return null;
        }
    }

    const s = Struct();
    backAndForth(s);
}


// FIXME - causing linker errors
// @ShouldFail("D function pointers not yet supported")
// @("function")
// unittest {
//     static string fun(int i, double d) {
//         import std.conv: text;
//         return text("i: ", i, " d: ", d);
//     }
//     const back = (&fun).toPython.to!(typeof(&fun));
// }


@("duration")
unittest {
    import core.time: seconds;
    backAndForth(1.seconds);
}


@("enum.int")
unittest {
    static enum Enum {
        foo,
        bar,
        baz,
    }

    backAndForth(Enum.bar);
}


@("enum.char")
unittest {
    static enum Char: char {
        a = 'a',
        b = 'b',
    }

    backAndForth(Char.b);
}


@("dchar")
unittest {
    const str = "foobar"d;
    backAndForth(str[0]);
}


@("range.infinite")
unittest {

    import std.range.primitives: isForwardRange;

    // infinite range
    static struct FortyTwos {
        int i;
        enum empty = false;
        int front() { return 42; }
        void popFront() {}
        auto save() { return this; }
        string toString() {
            import std.conv: text;
            return i.text;
        }
    }

    static assert(isForwardRange!FortyTwos);
    auto py = FortyTwos(77).toPython;
    auto d = py.to!FortyTwos;
    d.i.should == 77;
}


@("exception.msg")
unittest {
    static class MyException: Exception {
        // These members make no sense, but that's what
        // std.xml.CheckException does
        this(string msg) { super(msg); }
        string msg;
        size_t line;
    }

    // FIXME - cannot deal with repeated field names
    // auto py = (new MyException("oops")).toPython;
}


@("Nullable!Date")
unittest {
    import std.typecons: Nullable;
    import std.datetime: Date;
    auto py = Nullable!Date.init.toPython;
}


@("method.shared")
unittest {
    static struct Oops {
        int func() shared { return 42; }
    }

    auto py = (shared Oops()).toPython;
}


@("member.pointer")
unittest {

    static struct Uncopiable {
        @disable this(this);
        @disable void opAssign(Uncopiable);
        size_t count;
    }

    static struct Outer {
        Uncopiable inner;
    }

    // this was a bug because to!Outer didn't compile
    const back = Outer(Uncopiable(42)).toPython.to!Outer;
    back.inner.count.should == 42;
}
