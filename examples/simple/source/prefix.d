module prefix;

struct Prefix {

    string prefix;

    this(string prefix) {
        this.prefix = prefix;
    }

    export string pre(string str) {
        return prefix ~ str;
    }
}
