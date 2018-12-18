module issues;


struct Uncopiable {
    @disable this(this);
    double x;
}

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
