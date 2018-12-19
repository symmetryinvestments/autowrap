module arraytest;


class Foo {
    int i;
    this(int j) { i = j; }
    void bar() {
        import std.stdio : writefln;
        writefln("Foo.bar: %s", i);
    }
    override string toString() {
        import std.string : format;
        return format("{%s}",i);
    }

    int value() { return i; }
}

Foo[] global_array;

Foo[] get() {
    return global_array;
}
void set(Foo[] a) {
    global_array = a;
}
Foo test() {
    return new Foo(10);
}
