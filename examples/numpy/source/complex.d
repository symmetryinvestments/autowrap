import std.complex: Complex;


Complex!double switchCoord(Complex!double c) {
    return Complex!double(c.im, c.re);
}
