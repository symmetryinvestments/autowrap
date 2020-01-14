module issues;


import extra: String, MethodParamString;
import core.time: Duration;

struct Uncopiable {
    @disable this(this);
    double x;
}

/**
   Here to make sure it's not wrapped and doesn't cause problems.
   See #10.
 */
export auto uncopiable() {
    return Uncopiable.init;
}


export auto uncopiablePtr(double d = 33.3) {
    return new Uncopiable(d);
}



// FIXME - Can't spell out the name of an inner struct in the mixin
// that calls createPythonModule
// See https://github.com/symmetryinvestments/autowrap/issues/130
version(Have_autowrap_pynih) { }
else {
    export auto stringPtr(string s) {
        static struct StringPtrRetStruct {
            string value;
        }
        return new StringPtrRetStruct(s);
    }
}


// Generates symbols with two leading underscores
struct DoubleUnderscore {
    static struct Inner {
        this(this) {}
        ~this() {}
    }

    Inner inner;

    this(this) { }
    ~this() {}
}


struct IssueString {
    string value;
    this(string value) { this.value = value; }
}

export void takesInString(in IssueString str) {

}

export void takesScopeString(scope IssueString str) {

}

export void takesRefString(ref IssueString str) {

}


export void takesRefConstString(ref const(IssueString) str) {

}


export ref const(IssueString) returnsRefConstString() {
    static IssueString ret = IssueString("quux");
    return ret;
}


export const(IssueString) returnsConstString() {
    return const IssueString("toto");
}


export extern(C) int cAdd(int i, int j) {
    return i + j;
}


export extern(C++) int cppAdd(int i, int j) {
    return i + j;
}


struct StaticMemberFunctions {
    static int add(int i, int j) {
        return i + j;
    }
}


class Issue54 {
    int i;
    this(int i) { this.i = i; }
}

export void takesString(String str) {

}


class Issue153 {

    int i;

    this(int i) @safe @nogc pure nothrow {
        this.i = i;
    }

    void toString(scope void delegate(in char[]) sink) const {
        import std.conv: text;
        sink("Issue153(");
        sink(i.text);
        sink(")");
    }
}


struct Socket {
    size_t send(const(void)[] bytes) {
        return bytes.length;
    }
}


class MyException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

class Issue161: MyException {
    int errorCode;

    this(string msg,
         string file = __FILE__,
         size_t line = __LINE__,
         Throwable next = null,
         int err = _lasterr(),
         string function(int) @trusted errorFormatter = &formatSocketError)
    {
        errorCode = err;

        if (msg.length)
            super(msg ~ ": " ~ errorFormatter(err), file, line, next);
        else
            super(errorFormatter(err), file, line, next);
    }

    this(string msg,
         Throwable next,
         string file = __FILE__,
         size_t line = __LINE__,
         int err = _lasterr(),
         string function(int) @trusted errorFormatter = &formatSocketError)
    {
        this(msg, file, line, next, err, errorFormatter);
    }

    this(string msg,
         int err,
         string function(int) @trusted errorFormatter = &formatSocketError,
         string file = __FILE__,
         size_t line = __LINE__,
         Throwable next = null)
    {
        this(msg, file, line, next, err, errorFormatter);
    }
}

version(Windows) {
    private int _lasterr() nothrow @nogc {
        return WSAGetLastError();
    }
} else {
    private int _lasterr() nothrow @nogc {
        import core.stdc.errno;
        // return errno;
        return 42;
    }
}


private string formatSocketError(int err) @trusted
{
    return "oops";
}


export void issue163(out int[] ints) {
    ints ~= 42;
}


struct Issue164 {
    size_t strlen(MethodParamString s) {
        return s.value.length;
    }
}


export int issue166_days(Duration dur) {
    return cast(int) dur.total!"days";
}


export int issue166_secs(Duration dur) {
    return cast(int) dur.total!"seconds";
}


export int issue166_usecs(Duration dur) {
    return cast(int) dur.total!"usecs";
}


struct Issue198 {

    ubyte[] bytes;

    void[] opSlice(ulong start, ulong end) {
        return bytes[start .. end];
    }

    ubyte opIndex(ulong i) {
        return 42;
    }

    auto length() @property @safe @nogc pure const {
        return bytes.length;
    }
}


// infinite range
struct FortyTwos {
    int i;  // why not
    enum empty = false;
    int front() { return 42; }
    void popFront() {}
    auto save() { return this; }
    string toString() {
        import std.conv: text;
        return i.text;
    }
}
