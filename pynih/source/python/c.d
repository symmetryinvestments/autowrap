module python.c;

static import impl = impl;

import std.traits : FunctionAttribute;

template withAttr(alias f, FunctionAttribute attributes, string name) {
    import std.traits :  SetFunctionAttributes, functionAttributes, functionLinkage,
        ReturnType, Parameters, variadicFunctionStyle, Variadic;

    //pragma(msg, __LINE__, ": ", "not a type ", __traits(identifier, f), " ", typeof(f));

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
        auto withAttr(Args ...)(Parameters!newFptrT args, Args extraArgs) {
            return (cast(newFptrT) getFptr())(args, extraArgs);
        }
    } else {
        auto withAttr(Parameters!newFptrT args) {
            return (cast(newFptrT) getFptr())(args);
        }
    }
}

// don't do anything to types
template withAttr(f, FunctionAttribute attributes, string name) {
    //pragma(msg, __LINE__, ": ", "it's a type ", f);
    alias withAttr = f;
}

template maybeAddAttributes(alias s, string name) {
    import std.traits : FunctionAttribute, isCallable;
    static if (is(typeof(s) == function) || is(typeof(*s) == function)) {
        //pragma(msg, __LINE__, ": ", "it's a function ");
        alias maybeAddAttributes = withAttr!(s, FunctionAttribute.nothrow_ | FunctionAttribute.nogc, name);
    } else {
        alias maybeAddAttributes = s;
    }
}

enum ignore = ["PySignal_SetWakeupFd", "_PyCodec_Forget"];

static foreach (mem; __traits(allMembers, impl)) {
    //pragma(msg, "\n", __LINE__, ": ", mem);
    static foreach (toIgnore; ignore) {
        static if (mem == toIgnore) {
            mixin(`enum noWrap` ~ mem ~ `;`);
        }
    }
    static if (!is(mixin(`noWrap` ~ mem))) {
        mixin(`alias ` ~ mem ~ ` = maybeAddAttributes!(__traits(getMember, impl, mem), mem);`);
    }
    //pragma(msg, __LINE__, ": ", mixin(mem));
}

//public import impl;

string untranslate(string name) {
    return `auto ` ~ name ~ ` = ` ~ name ~ `_;`;
}

static foreach (name; ["METH_VARARGS", "METH_KEYWORDS", "METH_STATIC",
    "Py_LT", "Py_EQ", "Py_GT", "Py_LE", "Py_NE", "Py_GE", "Py_TPFLAGS_DEFAULT",
    "T_INT", "T_DOUBLE"]) {
    mixin(untranslate(name));
}

static foreach(name; ["Py_None", "Py_True", "Py_False"]) {
    mixin(`PyObject* ` ~ name ~ `;`);
    shared static this() {
        mixin(name ~ ` = ` ~ name ~ `_;`);
    }
}

mixin template PyObjectHead() {
    import impl : PyObject_HEAD_code;
    shared static this() {
        assert(PyObject_HEAD_code == "PyObject ob_base;", "Error, PyObject_HEAD changed");
    }
    PyObject ob_base;
}

auto pyObjectNew(T)(PyTypeObject* typeobj) {
    return cast(T*) _PyObject_New(typeobj);
}
