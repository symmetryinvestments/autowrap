struct sw_Foo1{
    int i;
    int j;
    int k;

    this(int _i, int _j, int _k) {
        i=_i; j=_j; k=_k;
    }

    int bar() {
        return i+j*k;
    }
}

struct sw_Foo2 {
    int i;
    string[] s;
    dchar[][] d;
    immutable(dchar)[][] d2;
}

struct sw_Foo3 {
    int i;
    sw_Foo4 foo;
}

struct sw_Foo4 {
    int j;
}

struct sw_Foo5 {
    sw_Foo4 foo;
}

struct sw_Foo6 {
    import std.datetime: DateTime;
    DateTime dateTime;
    // ctor needed for pyd...
    this(DateTime dateTime) { this.dateTime = dateTime; }
}
