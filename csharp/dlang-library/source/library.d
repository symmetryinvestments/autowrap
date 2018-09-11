module autowrap.csharp.library;

import core.atomic;
import core.memory;
import std.conv;
import std.string;
import std.stdio;
import std.utf;

shared wstring[ulong] errors;
shared ulong errorCount = 0;

ulong setError(string error) {
    ulong t = atomicOp!"+="(errorCount, cast(ulong)1);
    errors[t] = toUTF16(error);
    return t;
}

extern(C):
export:

struct errorValue(T) {
    T value;
    ulong errorId;
}

wstring autowrap_csharp_getError(ulong errorId) {
    return errors[errorId];
}
