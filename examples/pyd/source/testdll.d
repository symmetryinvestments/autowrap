module testdll;

// the names are prefixed with `test_dll` so as to not clash in python

string testdll_foo() {
    return "20 Monkey";
}

// this won't get wrapped
string testdll_foo(int i) {
    import std.conv: text;
    return text(i);
}

string testdll_bar(int i) {
    if (i > 10) {
        return "It's greater than 10!";
    } else {
        return "It's less than 10!";
    }
}


auto testdll_baz(int i = 10, string s = "moo") {
    import std.typecons: tuple;
    return tuple(i, s);
}


class TestDllFoo {
    int m_i;
    this() { }
    this(int i) {
        m_i = i;
    }
    this(int i, int j) {
        m_i = i + j;
    }
    string foo() {
        import std.format: format;
        return format("Foo.foo(): i = %s", m_i);
    }
    int length() { return 10; }
    int opSlice(long i1, long i2) {
        return 12;
    }
    int opIndex(int x, int y) {
        return x + y;
    }
    TestDllFoo opBinary(string op)(TestDllFoo f) if(op == "+")
    {
        return new TestDllFoo(m_i + f.m_i);
    }

    struct Range {
        int i = 0;

        @property bool empty() {
            return i >= 10;
        }
        @property int front() {
            return i+1;
        }
        void popFront() {
            i++;
        }
    }

    Range opSlice() {
        return Range();
    }
    @property int i() { return m_i; }
    @property void i(int j) { m_i = j; }
    void a() {}
    void b() {}
    void c() {}
    void d() {}
    void e() {}
    void f() {}
    void g() {}
    void h() {}
    void j() {}
    void k() {}
    void l() {}
    void m() {}
    void n() {}
    void o() {}
    void p() {}
    void q() {}
    void r() {}
    void s() {}
    void t() {}
    void u() {}
    void v() {}
    void w() {}
    void x() {}
    void y() {}
    void z() {}

    override string toString() {
        import std.conv: text;
        return text("TestDllFoo(", m_i, ")");
    }
}

string delegate() dg_ret() {
    return { return "returning a delegate works"; };
}

string dg_arg(string delegate(string arg) dg) {
    assert(dg !is null, "dg_arg: delegate cannot be null");
    return dg("foo");
}

class TestDllBar {
    int[] m_a;
    this() { }
    this(int[] i ...) { m_a = i; }
}

struct TestDllStruct {
    int i;
    char[] s;
}

TestDllFoo testdll_spam(TestDllFoo f) {
    f.foo();
    auto g = new TestDllFoo(f.i + 10);
    return g;
}

void testdll_throws() {
    throw new Exception("Yay! An exception!");
}
