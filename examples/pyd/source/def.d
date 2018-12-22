module def;


int def_a(int i) {
    return 10;
}

int def_a(double d){
    return 20;
}

int def_a2(int i, double d=4.5) {
    return cast(int) (100*d + i);
}

int def_a3(int[] i...) {
    int ret = 42;
    foreach(_i; i) ret += _i;
    return ret;
}

string def_a4(string s1, int i1, string s2 = "friedman", int i2 = 4, string s3 = "jefferson") {
    import std.format: format;
    return format("<'%s', %s, '%s', %s, '%s'>", s1, i1, s2, i2, s3);
}

int def_t1(T)(T i) {
    return 1;
}

template def_t2(T) {
    int f(T t) {
        return 1;
    }
}


auto def_t1_int(int i) {
    return def_t1!int(i);
}


auto def_t2_int(int i) {
    return def_t2!int.f(i);
}
