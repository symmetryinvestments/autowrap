struct IntString {

    int i;
    string s;

    this(int i) {
        this.i = i;
    }

    this(int i, string s) {
        this.i = i;
        this.s = s;
    }
}


struct String {
    string value;
}


struct SafePureEtcStruct {
    export int stuff(int i) @safe @nogc pure nothrow {
        return i * 2;
    }
}


struct StructWithPrivateMember {
    int i;
    private string j;
    int k;
}


struct Overloads {
    int fun(int i) { return i * 2; }
    int fun(int i, int j) { return i * j; }
}


struct NoCtor {
    int i;
    double d;
    string s;
}


struct Getter {
    int _i;
    this(int i) { _i = i;}
    @property int i() { return _i; }
}


struct Setter {
    int _i;
    @property void i(int i) { _i = i; }
}


struct GetterSetter {
    int _i;
    this(int i) { _i = i; }
    // would be const but pyd doesn't like it
    @property int i() { return _i; }
    @property void i(int i) { _i = i; }
}


struct GetterSetterConst {
    int _i;
    this(int i) @safe pure nothrow { _i = i; }
    @property int i() @safe const pure nothrow { return _i; }
    @property void i(int i) @safe pure nothrow { _i = i; }
}
