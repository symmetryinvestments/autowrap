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

    import python.util: pyMethodDef;

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


struct MyStruct {
    int i = 42;
}
