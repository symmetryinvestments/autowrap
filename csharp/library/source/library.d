module autowrap.csharp.library;

import core.atomic;
import core.memory;
import std.conv;
import std.string;
import std.stdio;
import std.utf;

shared wstring[ulong] errors;
shared ulong errorCount = 0;

extern(C):
export:

struct errorValue(T) {
    T value;
    ulong errorId;
}

wstring autowrap_csharp_getError(ulong errorId) {
    return errors[errorId];
}

ulong autowrap_csharp_setError(string error) {
    ulong t = atomicOp!"+="(errorCount, cast(ulong)1);
    errors[t] = toUTF16(error);
    return t;
}

string autowrap_csharp_createString(wchar* str) {
    string temp = toUTF8(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

wstring autowrap_csharp_createWString(wchar* str) {
    wstring temp = to!wstring(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

dstring autowrap_csharp_createDString(wchar* str) {
    dstring temp = toUTF32(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

void autowrap_csharp_release(void* ptr) {
    GC.removeRoot(ptr);
}
