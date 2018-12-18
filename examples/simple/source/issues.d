module issues;


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


export auto stringPtr(string s) {
    static struct StringPtrRetStruct {
        string value;
    }
    return new StringPtrRetStruct(s);
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
