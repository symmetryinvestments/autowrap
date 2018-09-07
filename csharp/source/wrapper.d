module csharp.wrapper;

import csharp.boilerplate;
import csharp.library;

import core.memory;
import std.conv;
import std.string;
import std.stdio;
import std.utf;

extern(C):
export:

string cswrap_dlang_createString(wchar* str) {
    string temp = toUTF8(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

wstring cswrap_dlang_createWString(wchar* str) {
    wstring temp = to!wstring(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

dstring cswrap_dlang_createDString(wchar* str) {
    dstring temp = toUTF32(str.fromStringz());
    GC.addRoot(cast(void*)temp.ptr);
    return temp;
}

void cswrap_dlang_release(void* ptr) {
    GC.removeRoot(ptr);
}

int cswrap_freeFunction (int value) {
    return freeFunction(value);
}

const(wchar)* cswrap_stringFunction(wchar* value) {
    string temp = stringFunction(toUTF8(value.fromStringz()));
    return getCSharpString(temp);
}

s2[] cswrap_arrayFunction(s2[] array) {
    return arrayFunction(array);
}

string cswrap_dlang_string_stringFunction(string value) {
    return value.dup;
}

wstring cswrap_dlang_wstring_stringFunction(wstring value) {
    return value.dup;
}

dstring cswrap_dlang_dstring_stringFunction(dstring value) {
    return value.dup;
}

float cswrap_s1_getValue(s1* cswrap_s1) {
    return (*cswrap_s1).value;
}

void cswrap_s1_setNestedStruct(s1* cswrap_s1, s2 nested) {
    (*cswrap_s1).nestedStruct = nested;
}

c1 cswrap_c1__ctor() {
    __gshared c1 t = new c1();
    GC.addRoot(cast(void*)t);
    return t;
}

c1[] cswrap_c1_createRange(int capacity) {
    c1[] t;
    if (capacity > 0) {
        t.reserve(capacity);
    }
    void* ptr = cast(void*)t.ptr;
    GC.addRoot(ptr);
    return t;
}

void cswrap_c1_rangeAppend(c1[] array, c1 value) {
    array ~= value;
}

s2 cswrap_c1_get_getHidden(void* cswrap_c1) {
    return (cast(c1)cswrap_c1).getHidden();
}

void cswrap_c1_set_setHidden(void* cswrap_c1, s2 value) {
    (cast(c1)cswrap_c1).setHidden(value);
}

int cswrap_c1_get_intValue(void* cswrap_c1) {
    return (cast(c1)cswrap_c1).intValue;
}

void cswrap_c1_set_intValue(void* cswrap_c1, int value) {
    (cast(c1)cswrap_c1).intValue = value;
}

string cswrap_c1_get_stringValue(void* cswrap_c1) {
    return (cast(c1)cswrap_c1).stringValue;
}

void cswrap_c1_set_stringValue(void* cswrap_c1, string value) {
    (cast(c1)cswrap_c1).stringValue = value;
}

string cswrap_c1_testMemberFunc(void* cswrap_c1, string test, s1 value) {
    return (cast(c1)cswrap_c1).testMemberFunc(test, value);
}
