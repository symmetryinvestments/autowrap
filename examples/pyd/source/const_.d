class const_T1 {
    int i;
    string s;

    string a() immutable {
        return "abc";
    }

    string b() const {
        return "def";
    }

    string c(const(const_T1) t) {
        return t.b ~ "_C";
    }
    string d(immutable(const_T1) t) {
        return t.a() ~ "_I";
    }
    void e(const_T1 t) {
    }

    @property void p1(int i) {
    }
    @property int p1() {
        return 100;
    }

    @property int p1i() immutable {
        return 200;
    }

    @property int p1c() const {
        return 300;
    }

    @property int p1w() inout {
        return 400;
    }

    void v1() {
        int i = 1 + 2;
    }

    void im1(immutable(const_T1) tz) {
    }
}
