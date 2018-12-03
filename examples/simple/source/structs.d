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
    private int j;
}
