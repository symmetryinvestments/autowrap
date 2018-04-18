struct Point(T) {
    T x, y;
}


struct Outer(T) {
    import structs: String;
    Inner1!T[] inner1s;
    Inner2!T inner2;
    String string1;
    String string2;
}

struct Inner1(T) {
    Point!T point;
    T value;
}

struct Inner2(T) {
    EvenInner!T evenInner;
}

struct EvenInner(T) {
    T value;
}
