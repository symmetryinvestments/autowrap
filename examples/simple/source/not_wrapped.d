// Definitions that don't show up anywhere on purpose to make sure everything
// that needs to be wrapped is.

struct NotWrappedInner {
    string value;
    this(string value) { this.value = value; }
}


struct NotWrappedInt {
    int value;
    this(int value) { this.value = value; }
}
