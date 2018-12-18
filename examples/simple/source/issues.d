module issues;


struct Uncopiable {
    @disable this(this);
    double x;
}

export auto uncopiable() {
    return Uncopiable.init;
}
