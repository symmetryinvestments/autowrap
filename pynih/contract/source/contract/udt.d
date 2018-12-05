/**
   This module contains D code for the contract tests between Python
   and its C API regarding user-defined types.
 */
module contract.udt;


import python;


extern(C):


package PyObject* simple_struct_func(PyObject* self, PyObject *args) nothrow @nogc {

    static struct MyType {
        mixin PyObjectHead;
        int i = 2;
        double d = 3;
    }

    // either this of PyGetSetDef
    static PyMemberDef[3] members;
    members[0].name = cast(typeof(PyMemberDef.name)) &"the_int"[0];
    members[0].type = MemberType.Int;
    members[0].offset = MyType.i.offsetof;
    members[1].name = cast(typeof(PyMemberDef.name)) &"the_double"[0];
    members[1].type = MemberType.Double;
    members[1].offset = MyType.d.offsetof;

    static PyTypeObject type;

    if(type == type.init) {
        type.tp_name = &"MyType"[0];
        type.tp_basicsize = MyType.sizeof;
        type.tp_members = &members[0];
        type.tp_flags = TypeFlags.Default;

        if(PyType_Ready(&type) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }
    }

    auto obj = pyObjectNew!MyType(&type);
    obj.i = 42;
    obj.d = 33.3;

    return cast(typeof(return)) obj;
}


package PyObject* twice_struct_func(PyObject* self, PyObject *args) nothrow @nogc {

    import python.cooked: pyMethodDef;

    static struct Twice {
        mixin PyObjectHead;
        int i;
        int twice() @safe @nogc pure nothrow const {
            return i * 2;
        }
    }

    static extern(C) PyObject* twice(Twice* self, PyObject* args) {
        return PyLong_FromLong(self.twice);
    }

    if(PyTuple_Size(args) != 1) {
        PyErr_SetString(PyExc_TypeError, &"Must be used with one parameter"[0]);
        return null;
    }

    auto arg = PyTuple_GetItem(args, 0);
    if(arg is null) {
        PyErr_SetString(PyExc_TypeError, &"Could not get 1st argument"[0]);
        return null;
    }

    static PyMethodDef[2] methods;
    // can't use a function literal because they're not allowed to be extern(C)
    methods[0] = pyMethodDef!("twice")(&twice);

    static PyTypeObject type;

    if(type == type.init) {
        type.tp_name = &"Twice"[0];
        type.tp_basicsize = Twice.sizeof;
        type.tp_methods = &methods[0];
        type.tp_flags = TypeFlags.Default;

        if(PyType_Ready(&type) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }
    }

    auto obj = pyObjectNew!Twice(&type);
    obj.i = cast(int) PyLong_AsLong(arg);

    return cast(typeof(return)) obj;
}


struct StructDefaultCtor {
    int i = 42;
}

struct StructUserCtor {
    int i = 42;
    double d = 33.3;
    string s = "foobar";
    private int _shouldBeOk;

    this(int i, string s) {
        this.i = i;
        this.d = 77.7;
        this.s = s;
    }

    this(int i, double d, string s) {
        this.i = i;
        this.d = d;
        this.s = s;
    }
}


package PyObject* struct_getset(PyObject* self, PyObject *args) nothrow @nogc {

    static struct StructGetSet {
        mixin PyObjectHead;
        double d;
        Inner inner;

        static struct Inner {
            mixin PyObjectHead;
            int i;
            double d;
            // we don't bother wrapping `s` just to show that what Python sees
            // doesn't have to be exactly what D does.
            string s;
        }
    }

    static extern(C) PyObject* getOuterInt(PyObject*, void*) {
        return PyLong_FromLong(42);
    }

    static extern(C) PyObject* getOuterDouble(PyObject* self_, void*) {
        auto self = cast(StructGetSet*) self_;
        return PyFloat_FromDouble(self.d);
    }

    static extern(C) int setOuterDouble(PyObject* self_, PyObject* value, void*) {
         auto self = cast(StructGetSet*) self_;
         self.d = PyFloat_AsDouble(value);
         return 0;
    }

    static extern(C) PyObject* getInnerInt(PyObject* self_, void*) {
        auto self = cast(StructGetSet.Inner*) self_;
        return PyLong_FromLong(self.i);
    }

    static extern(C) PyObject* getInnerDouble(PyObject* self_, void*) {
        auto self = cast(StructGetSet.Inner*) self_;
        return PyFloat_FromDouble(self.d);
    }

    static extern(C) int setInnerInt(PyObject* self_, PyObject* value, void*) {
         auto self = cast(StructGetSet.Inner*) self_;
         self.i = cast(int) PyLong_AsLong(value);
         return 0;
    }

    static extern(C) int setInnerDouble(PyObject* self_, PyObject* value, void*) {
         auto self = cast(StructGetSet.Inner*) self_;
         self.d = PyFloat_AsDouble(value);
         return 0;
    }

    extern(C) static PyObject* reprOuter(PyObject* self_) {
        import std.conv: text;

        auto self = cast(StructGetSet*) self_;
        auto ret = text(*self);

        return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
    }

    extern(C) static PyObject* reprInner(PyObject* self_) {
        import std.conv: text;

        auto self = cast(StructGetSet.Inner*) self_;
        auto ret = text(*self);

        return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
    }

    static PyTypeObject outerType;
    static PyTypeObject innerType;

    static extern(C) PyObject* getInner(PyObject* self_, void*) {
        auto self = cast(StructGetSet*) self_;
        auto innerObj = cast(PyObject*) &self.inner;
        pyIncRef(innerObj);
        return innerObj;
    }

    static PyGetSetDef[10] outerGetSets;
    static PyGetSetDef[10] innerGetSets;

    if(outerType == outerType.init) {

        outerGetSets[0].name = cast(typeof(PyGetSetDef.name)) &"i"[0];
        outerGetSets[0].get = &getOuterInt;
        outerGetSets[1].name = cast(typeof(PyGetSetDef.name)) &"d"[0];
        outerGetSets[1].get = &getOuterDouble;
        outerGetSets[1].set = &setOuterDouble;
        outerGetSets[2].name = cast(typeof(PyGetSetDef.name)) &"inner"[0];
        outerGetSets[2].get = &getInner;

        outerType.tp_name = &"StructGetSet"[0];
        outerType.tp_basicsize = StructGetSet.sizeof;
        outerType.tp_flags = TypeFlags.Default;
        outerType.tp_repr = outerType.tp_str = &reprOuter;
        outerType.tp_getset = &outerGetSets[0];

        if(PyType_Ready(&outerType) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }

        innerGetSets[0].name = cast(typeof(PyGetSetDef.name)) &"i"[0];
        innerGetSets[0].get = &getInnerInt;
        innerGetSets[0].set = &setInnerInt;
        innerGetSets[1].name = cast(typeof(PyGetSetDef.name)) &"d"[0];
        innerGetSets[1].get = &getInnerDouble;
        innerGetSets[1].set = &setInnerDouble;

        innerType.tp_name = &"StructGetSet.Inner"[0];
        innerType.tp_basicsize = StructGetSet.Inner.sizeof;
        innerType.tp_flags = TypeFlags.Default;
        innerType.tp_repr = innerType.tp_str = &reprInner;
        innerType.tp_getset = &innerGetSets[0];

        if(PyType_Ready(&innerType) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }
    }

    auto ret = pyObjectNew!StructGetSet(&outerType);
    ret.d = 3.3;
    ret.inner.i = 999;
    ret.inner.d = 777.77;
    // this line below is important, it's the equivalent of pyObjectNew above
    PyObject_Init(cast(PyObject*) &ret.inner, &innerType);

    return cast(typeof(return)) ret;
}
