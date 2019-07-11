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
