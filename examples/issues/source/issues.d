module issues;


import extra: String;

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
