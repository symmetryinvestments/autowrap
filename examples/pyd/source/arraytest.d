module arraytest;

import std.stdio : writefln;
import std.string : format;


class Foo {
    int i;
    this(int j) { i = j; }
    void bar() {
        writefln("Foo.bar: %s", i);
    }
    override string toString() {
        return format("{%s}",i);
    }
}

Foo[] global_array;

Foo[] get() {
    writefln("get: %s", global_array);
    return global_array;
}
void set(Foo[] a) {
    writefln("set: a: %s, global: %s", a, global_array);
    global_array = a;
    writefln("set: global now: %s", global_array);
}
Foo test() {
    return new Foo(10);
}
