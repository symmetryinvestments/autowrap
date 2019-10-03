module modules.functions;


export string stringRet() {
    return "20 Monkey";
}


export string stringRet(int i) {
    import std.conv: text;
    return text(i);
}

export int twice(int i) {
    return i * 2;
}


// not export on purpose
int thrice(int i) {
    return i * 3;
}
