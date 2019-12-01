module wrap_all;

import templates2;
import impl: OtherString;

// should be registered in Python as identity_int
alias identityInt = identity!int;

int product(int i, int j) {
    return i * j;
}

struct String {
    string s;
    this(string s) { this.s = s; }
}


string otherStringAsParam(OtherString s) {
    return s.s ~ "quux";
}


enum MyEnum {
    foo,
    bar,
    baz,
}
