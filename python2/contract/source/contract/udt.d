/**
   This module contains D code for the contract tests between Python
   and its C API regarding user-defined types.
 */
module contract.udt;


import python;


extern(C):


package PyObject* simple_struct(PyObject* self, PyObject *args) nothrow @nogc {

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
    }

    if(PyType_Ready(&type) < 0) {
        PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
        return null;
    }

    auto obj = pyObjectNew!MyType(&type);
    obj.i = 42;
    obj.d = 33.3;

    return cast(typeof(return)) obj;
}
