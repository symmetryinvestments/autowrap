module adder;

struct Adder {
    int value;

    this(int value) {
        this.value = value;
    }

    export int add(int i) {
        return i + value;
    }
}
