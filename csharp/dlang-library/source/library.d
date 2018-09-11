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

struct error_bool {
    bool value;
    ulong errorId;
}

struct error_byte {
    byte value;
    ulong errorId;
}

struct error_ubyte {
    ubyte value;
    ulong errorId;
}

struct error_short {
    short value;
    ulong errorId;
}

struct error_ushort {
    ushort value;
    ulong errorId;
}

struct error_int {
    int value;
    ulong errorId;
}

struct error_uint {
    uint value;
    ulong errorId;
}

struct error_long {
    long value;
    ulong errorId;
}

struct error_ulong {
    ulong value;
    ulong errorId;
}

struct error_float {
    float value;
    ulong errorId;
}

struct error_double {
    double value;
    ulong errorId;
}

struct error_string {
    string value;
    ulong errorId;
}

struct error_wstring {
    wstring value;
    ulong errorId;
}

struct error_dstring {
    dstring value;
    ulong errorId;
}

wstring autowrap_csharp_getError(ulong errorId) {
    return errors[errorId];
}
