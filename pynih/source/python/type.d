/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;


/**
   Creates storage for a `PyTypeObject` for each D type `T`.
 */
template PythonType(T) {
    import python.raw: PyObject, PyTypeObject, PyMemberDef;
    import std.traits: Fields;

    private PyTypeObject _pyType;
    private PyMemberDef[Fields!T.length + 1] members;

    void init() {
        import python.raw: MemberType, TypeFlags, PyType_GenericNew;
        import std.traits: Fields, FieldNameTuple;

        if(_pyType != _pyType.init) return;

        _pyType.tp_name = &__traits(identifier, T)[0];
        _pyType.tp_basicsize = (PythonAggregate!T).sizeof;
        _pyType.tp_flags = TypeFlags.Default;  // this is important for Python2
        _pyType.tp_new = &PyType_GenericNew;
        _pyType.tp_init = &ctor;
        _pyType.tp_repr = &repr;
        _pyType.tp_str = &repr;

        // TODO: members
        // static foreach(i; 0 .. Fields!T.length) {
        //     members[i].name = cast(typeof(PyMemberDef.name)) &FieldNameTuple!T[i][0];
        //     members[i].type = MemberType.Int; // FIXME
        //     members[i].offset = __traits(getMember, T, FieldNameTuple!T[i]).offsetof + PythonAggregate!T.original.offsetof;
        // }
        // _pyType.tp_members = &members[0];

        // TODO: methods
    }

    PyObject* object() {
        init;
        return cast(PyObject*) &_pyType;
    }

    PyTypeObject* pyType() {
        init;
        return &_pyType;
    }

    extern(C) static PyObject* repr(PyObject* self_) {
        import python: pyUnicodeDecodeUTF8;
        import std.conv: text;

        auto self = cast(PythonAggregate!T*) self_;
        auto ret = text(self.original);
        return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
    }

    extern(C) static int ctor(PyObject* self_, PyObject* args, PyObject* kwargs) {
        auto self = cast(PythonAggregate!T*) self_;
        self.original = T();
        // TODO: arguments
        return 0;
    }
}



/**
   A Python extension type for a D aggregate T.
 */
struct PythonAggregate(T) {
    import python.raw: PyObjectHead;

    alias Type = T;

    mixin PyObjectHead;
    T original;
    alias original this;
}


auto pythonClass(T)(auto ref T dobj) if(__traits(identifier, T) == "SimpleStruct") {

    import python.raw: PyObject, PyObjectHead, PyGetSetDef, PyTypeObject, PyType_Ready,
        TypeFlags, PyErr_SetString, PyExc_TypeError,
        pyObjectNew, PyLong_FromLong, PyFloat_FromDouble
        ;

    static PyGetSetDef[3] getsets;

    static extern(C) PyObject* getField0(PyObject* self_, void* closure) {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass!T*) self_;
        pyIncRef(self.i);

        return self.i;
    }

    static extern(C) int setField0(PyObject* self_, PyObject* value, void* closure) {
        import python.raw: pyIncRef, pyDecRef, pyLongCheck, PyErr_SetString, PyExc_TypeError;

        auto self = cast(PythonClass!T*) self_;

        PyObject *tmp;

        if(value is null) {
            PyErr_SetString(PyExc_TypeError, "Cannot delete i");
            return -1;
        }

        if(!pyLongCheck(value)) {
            PyErr_SetString(PyExc_TypeError, "i must be a long");
            return -1;
        }

        tmp = self.i;
        pyIncRef(value);
        self.i = value;
        pyDecRef(tmp);

        return 0;
    }

    getsets[0].name = &"i"[0];
    getsets[0].get = &getField0;
    getsets[0].set = &setField0;

    static extern(C) PyObject* getField1(PyObject* self_, void* closure) {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass!T*) self_;
        pyIncRef(self.d);

        return self.d;
    }

    static extern(C) int setField1(PyObject* self_, PyObject* value, void* closure) {
        import python.raw: pyIncRef, pyDecRef, pyFloatCheck, PyErr_SetString, PyExc_TypeError;

        auto self = cast(PythonClass!T*) self_;

        PyObject *tmp;

        if(value is null) {
            PyErr_SetString(PyExc_TypeError, "Cannot delete d");
            return -1;
        }

        if(!pyFloatCheck(value)) {
            PyErr_SetString(PyExc_TypeError, "i must be a float");
            return -1;
        }

        tmp = self.d;
        pyIncRef(value);
        self.d = value;
        pyDecRef(tmp);

        return 0;
    }

    getsets[1].name = &"d"[0];
    getsets[1].get = &getField1;
    getsets[1].set = &setField1;

    static PyTypeObject type;

    if(type == type.init) {
        type.tp_name = &"SimpleStruct"[0];
        type.tp_basicsize = PythonClass!T.sizeof;
        type.tp_flags = TypeFlags.Default;
        type.tp_getset = &getsets[0];

        if(PyType_Ready(&type) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }
    }

    auto ret = pyObjectNew!(PythonClass!T)(&type);
    ret.i = PyLong_FromLong(dobj.i);
    ret.d = PyFloat_FromDouble(dobj.d);

    return cast(PyObject*) ret;
}


auto pythonClass(T)(auto ref T dobj) if(__traits(identifier, T) == "StringsStruct") {

    import python.raw: PyObject, PyObjectHead, PyGetSetDef, PyTypeObject, PyType_Ready,
        TypeFlags, PyErr_SetString, PyExc_TypeError,
        pyObjectNew, PyList_New, PyList_SetItem, PyUnicode_FromStringAndSize;

    static PyGetSetDef[2] getsets;

    static extern(C) PyObject* getField0(PyObject* self_, void* closure) {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass!T*) self_;
        pyIncRef(self.strings);

        return self.strings;
    }

    static extern(C) int setField0(PyObject* self_, PyObject* value, void* closure) {
        import python.raw: pyIncRef, pyDecRef, pyListCheck, PyErr_SetString, PyExc_TypeError;

        auto self = cast(PythonClass!T*) self_;

        PyObject *tmp;

        if(value is null) {
            PyErr_SetString(PyExc_TypeError, "Cannot delete strings");
            return -1;
        }

        if(!pyListCheck(value)) {
            PyErr_SetString(PyExc_TypeError, "strings must be a list");
            return -1;
        }

        tmp = self.strings;
        pyIncRef(value);
        self.strings = value;
        pyDecRef(tmp);

        return 0;
    }

    getsets[0].name = &"strings"[0];
    getsets[0].get = &getField0;
    getsets[0].set = &setField0;

    static PyTypeObject type;

    if(type == type.init) {
        type.tp_name = &"SimpleStruct"[0];
        type.tp_basicsize = PythonClass!T.sizeof;
        type.tp_flags = TypeFlags.Default;
        type.tp_getset = &getsets[0];

        if(PyType_Ready(&type) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            return null;
        }
    }

    auto ret = pyObjectNew!(PythonClass!T)(&type);
    ret.strings = PyList_New(dobj.strings.length);

    foreach(i, str; dobj.strings) {
        PyList_SetItem(ret.strings, i, PyUnicode_FromStringAndSize(&str[0], str.length));
    }

    return cast(PyObject*) ret;
}


/**
   A Python class that mirrors the D type `T`.
 */
struct PythonClass(T) {
    import python.raw: PyObjectHead;
    import std.traits: FieldNameTuple;

    alias fieldNames = FieldNameTuple!T;

    // Every python object must have this
    mixin PyObjectHead;
    // Generate a python object field for every field in T
    static foreach(fieldName; fieldNames) {
        mixin(`PyObject* `, fieldName, `;`);
    }

}
