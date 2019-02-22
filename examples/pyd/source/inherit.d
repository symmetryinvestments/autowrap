module inherit;


class Base {
    this(int i) { }
    string foo() {
        return "Base.foo";
    }
    string bar() {
        return "Base.bar";
    }
}


class Derived : Base {
    this(int i) { super(i); }
    override string foo() {
        return "Derived.foo";
    }
}


string call_poly(Base b) {
    return b.foo ~ "_call_poly";
}


Base return_poly_base() {
    return new Base(1);
}


Base return_poly_derived() {
    return new Derived(2);
}
