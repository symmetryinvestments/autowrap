module python.c;

static import impl;

import std.traits : FunctionAttribute;

private template withAttr(alias f, FunctionAttribute attributes, string name) {
    import std.traits :  SetFunctionAttributes, functionAttributes, functionLinkage,
        ReturnType, Parameters, variadicFunctionStyle, Variadic;

    enum newAttributes = functionAttributes!f | attributes;
    auto getFptr() {
        static if (is(typeof(*f) == function)) {
            return f;
        } else {
            return &f;
        }
    }
    alias fptrT = typeof(getFptr());
    alias newFptrT = SetFunctionAttributes!(fptrT, functionLinkage!f, newAttributes);

    static if (variadicFunctionStyle!newFptrT == Variadic.c) {
        public auto withAttr(Args ...)(Parameters!newFptrT args, Args extraArgs) {
            return (cast(newFptrT) getFptr())(args, extraArgs);
        }
    } else {
        public auto withAttr(Parameters!newFptrT args) {
            return (cast(newFptrT) getFptr())(args);
        }
    }
}

// don't do anything to types
private template withAttr(f, FunctionAttribute attributes, string name) {
    alias withAttr = f;
}

private template maybeAddAttributes(alias s, string name) {
    import std.traits : FunctionAttribute, isCallable;
    static if (is(typeof(s) == function) || is(typeof(*s) == function)) {
        alias maybeAddAttributes = withAttr!(s, FunctionAttribute.nothrow_ | FunctionAttribute.nogc, name);
    } else {
        alias maybeAddAttributes = s;
    }
}

// I don't really understand why, but they aren't in the python library???
private enum ignore = ["PySignal_SetWakeupFd", "_PyCodec_Forget"];

// go through all the members of the impl module and alias them, adding nothrow and nogc on
// functions and functions pointers, but not on types
static foreach (mem; __traits(allMembers, impl)) {
    static foreach (toIgnore; ignore) {
        static if (mem == toIgnore) {
            mixin(`enum noWrap` ~ mem ~ `;`);
        }
    }
    static if (!is(mixin(`noWrap` ~ mem))) {
        mixin(`alias ` ~ mem ~ ` = maybeAddAttributes!(__traits(getMember, impl, mem), mem);`);
    }
}

private string untranslate(string name) {
    return `immutable ` ~ name ~ ` = ` ~ name ~ `_;`;
}

static foreach (name; ["METH_VARARGS", "METH_KEYWORDS", "METH_STATIC",
    "Py_LT", "Py_EQ", "Py_GT", "Py_LE", "Py_NE", "Py_GE", "Py_TPFLAGS_DEFAULT",
    "T_INT", "T_DOUBLE"]) {
    mixin(untranslate(name));
}

// can't initialise these at compile time, so do it at runtime
static foreach(name; ["Py_None", "Py_True", "Py_False"]) {
    mixin(`PyObject* ` ~ name ~ `;`);
    shared static this() {
        mixin(name ~ ` = ` ~ name ~ `_;`);
    }
}

/// hacky way to get the PyObject_HEAD macro safely correct
mixin template PyObjectHead() {
    import impl : PyObject_HEAD_code;
    shared static this() {
        assert(PyObject_HEAD_code == "PyObject ob_base;", "Error, PyObject_HEAD changed");
    }
    PyObject ob_base;
}

/// genuinely nice little abstraction
auto pyObjectNew(T)(PyTypeObject* typeobj) {
    return cast(T*) _PyObject_New(typeobj);
}
