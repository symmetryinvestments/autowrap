alias Py_ssize_t = long;

class Bizzy {
    int _m;

    int m() { return _m; }

    this(int i, double d = 1.0, string s = "hi") {
    }

    int a(int i){
        return i + 11;
    }
    int a(double d) {
        return cast(int)( d+12);
    }
    static int b(int i){
        return i + 13;
    }
    static int b(double d) {
        return cast(int)( d+14);
    }

    string toString(int i) {
        return "hi";
    }
    override string toString() const {
        return "bye";
    }
    int opBinary(string op)(int i) {
        static if(op == "+") return i+1;
        else static if(op == "*") return i+2;
        else static if(op == "^^") return i+3;
        else static assert(0);
    }
    bool opBinaryRight(string op)(int i) if(op == "in") {
        return i > 10;
    }

    int opBinaryRight(string op)(int i) if(op == "+") {
        return i + 4;
    }

    void opOpAssign(string op)(int i) {
        static if(op == "+") _m = i + 22;
        else static if(op == "%") _m = i + 33;
        else static if(op == "^^") _m = i + 44;
        else static assert(0);
    }

    int opUnary(string op)() {
        static if(op == "+") return 55;
        else static if(op == "~") return 44;
        else static assert(0);
    }

    override int opCmp(Object p) {
        return 10;
    }

    double opIndex(int i) {
        return i*4.4;
    }

    int[] opSlice(Py_ssize_t a, Py_ssize_t b) {
        return [1,2,3];
    }

    void opIndexAssign(double d, int i) {
        _m = cast(int)(d*1000) + i;
    }

    void opSliceAssign(double d, Py_ssize_t a, Py_ssize_t b) {
        _m = cast(int)(d*1000) + cast(int)(a*10 + b);
    }

    Py_ssize_t length(){
        return 401;
    }

    int opCall(double d) {
        return _m + cast(int)(1000 *d);
    }
}

class Bizzy2 {
    int[] js;
    this(int[] i...) {
        js = i.dup;
    }

    int[] jj() {
        return js;
    }

    static int a(int i, double d) {
        return cast(int)(200*d + i);
    }
    static int b(int i, double d = 3.2) {
        return cast(int)(1000*d + 10*i+3);
    }
    static int c(int[] i...) {
        int ret = 0;
        foreach(_i,k; i) {
            ret += 10 ^^ _i * k;
        }
        return ret;
    }

    static string d(int i, int j = 101, string k = "bizbar") {
        import std.string;
        return format("<%s, %s, '%s'>", i,j,k);
    }
}

class Bizzy3{
    this(int i, int j) {
    }

    int a(int i, double d) {
        return cast(int)(100*d + 2*i);
    }
    int b(int i, double d = 3.2) {
        return cast(int)(1000*d + 20*i+4);
    }
    int c(int[] i...) {
        int ret = 0;
        foreach_reverse(_i,k; i) {
            ret += 10 ^^ (i.length-_i-1) * k;
        }
        return ret;
    }

    string d(int i, int j = 102, string k = "bizbar") {
        import std.string;
        return format("<%s, %s, '%s'>", i,j,k);
    }

}

class Bizzy4 {
    int _i = 4;

    @property int i() { return _i; }
    @property void i(int n) { _i = n; }
    @property Py_ssize_t length() { return 5; }
    override string toString() const { return "cowabunga"; }

    void foo(Bizzy4 other) {
    }
}

class Bizzy5 {
    int i;
    double d;
    string s;
    this(int i, double d = 1.0, string s = "hi") {
        this.i = i;
        this.d = d;
        this.s = s;
    }
    string a() {
        import std.string;
        return format("<%s, %s, '%s'>", i,d,s);
    }

    @property string b() { return "abc"; }

    @property string c() { return "abc"; }
    @property void c(string _val) { }

    @property void e(string _val) { }

}

mixin template t3(T) {
    int f(T t) {
        return 1;
    }
}

class TBizzy {
    mixin t3!int;
}
