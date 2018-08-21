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

int cswrap_freeFunction (int value) {
    return freeFunction(value);
}

const(wchar)* cswrap_stringFunction(wchar* value) {
    string temp = stringFunction(toUTF8(value.fromStringz()));
    return getCSharpString(temp);
}

float cswrap_s1_getValue(s1* cswrap_s1) {
    return (*cswrap_s1).value;
}

void cswrap_s1_setNestedStruct(s1* cswrap_s1, s2 nested) {
    (*cswrap_s1).nestedStruct = nested;
}

void* cswrap_c1__ctor() {
    void* ptr = cast(void*)new c1();
    GC.addRoot(ptr);
    return ptr;
}

void cswrap_c1__dtor(void* ptr) {
    GC.removeRoot(ptr);
}

s2 cswrap_c1_get_getHidden(void* cswrap_c1) {
    return (cast(c1)cswrap_c1).getHidden();
}

void cswrap_c1_set_setHidden(void* cswrap_c1, s2 value) {
    (cast(c1)cswrap_c1).setHidden(value);
}

s2 cswrap_c1_get_stringValue(void* cswrap_c1) {
    return (cast(c1)cswrap_c1).getHidden();
}

void cswrap_c1_set_stringValue(void* cswrap_c1, wchar[] value) {
    (cast(c1)cswrap_c1).stringValue = to!string(value);
}

wchar[] cswrap_c1_testMemberFunc(void* cswrap_c1, wchar[] test, s1 value) {
    return to!(wchar[])((cast(c1)cswrap_c1).testMemberFunc(to!string(test), value));
}
