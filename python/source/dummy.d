version(unittest) {}
else version(Posix) extern(C) void _Dmain() { }  // make druntime happy
