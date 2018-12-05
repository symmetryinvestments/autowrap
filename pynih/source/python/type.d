/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;

import python.raw: PyObject;
import std.traits: isArray, isIntegral, isBoolean, isFloatingPoint;

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


struct NewPythonType(T) {
    import python.raw: PyTypeObject, PyGetSetDef;
    import std.traits: FieldNameTuple, Fields;

    alias fieldNames = FieldNameTuple!T;
    alias fieldTypes = Fields!T;

    static PyTypeObject _pyType;
    static bool failedToReady;

    static PyObject* pyObject() {
        initialise;
        return failedToReady ? null : cast(PyObject*) &_pyType;
    }

    static PyTypeObject* pyType() {
        initialise;
        return failedToReady ? null : &_pyType;
    }

    private static void initialise() {
        import python.raw: PyType_GenericNew, PyType_Ready, TypeFlags,
            PyErr_SetString, PyExc_TypeError;

        if(_pyType != _pyType.init) return;

        // +1 due to the sentinel
        static PyGetSetDef[fieldNames.length + 1] getsets;

        static foreach(i; 0 .. fieldNames.length) {
            getsets[i].name = fieldNames[i];
            getsets[i].get = &PythonClass!T.get!i;
            getsets[i].set = &PythonClass!T.set!i;
        }

        if(_pyType == _pyType.init) {
            _pyType.tp_name = &"SimpleStruct"[0];
            _pyType.tp_basicsize = PythonClass!T.sizeof;
            _pyType.tp_flags = TypeFlags.Default;
            _pyType.tp_getset = &getsets[0];

            if(PyType_Ready(&_pyType) < 0) {
                PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
                failedToReady = true;
            }
        }
    }
}


auto pythonClass(T)(auto ref T dobj) {

    import python.conv: toPython;
    import python.raw: pyObjectNew;
    import std.traits: FieldNameTuple;

    auto ret = pyObjectNew!(PythonClass!T)(NewPythonType!T.pyType);

    static foreach(fieldName; FieldNameTuple!T) {
        mixin(`ret.`, fieldName, ` = dobj.`, fieldName, `.toPython;`);
    }

    return cast(PyObject*) ret;
}


/**
   A Python class that mirrors the D type `T`.
   For instance, this struct:
   ----------
   struct Foo {
       int i;
       string s;
   }
   ----------

   Will generate a Python class called `Foo` with two members, and trying to
   assign anything but an integer to `Foo.i` or a string to `Foo.s` in Python
   will raise `TypeError`.
 */
struct PythonClass(T) {
    import python.raw: PyObjectHead, PyGetSetDef;
    import std.traits: FieldNameTuple, Fields;

    alias fieldNames = FieldNameTuple!T;
    alias fieldTypes = Fields!T;

    // +1 for the sentinel
    static PyGetSetDef[fieldNames.length + 1] getsets;

    /// Field members
    // Every python object must have this
    mixin PyObjectHead;
    // Generate a python object field for every field in T
    static foreach(fieldName; fieldNames) {
        mixin(`PyObject* `, fieldName, `;`);
    }

    // The function pointer for PyGetSetDef.get
    private static extern(C) PyObject* get(int FieldIndex)(PyObject* self_, void* closure) {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass*) self_;
        pyIncRef(self.getField!FieldIndex);

        return self.getField!FieldIndex;
    }

    // The function pointer for PyGetSetDef.set
    static extern(C) int set(int FieldIndex)(PyObject* self_, PyObject* value, void* closure) {
        import python.raw: pyIncRef, pyDecRef, PyErr_SetString, PyExc_TypeError;

        if(value is null) {
            enum deleteErrStr = "Cannot delete " ~ fieldNames[FieldIndex];
            PyErr_SetString(PyExc_TypeError, deleteErrStr);
            return -1;
        }

        if(!checkPythonType!(fieldTypes[FieldIndex])(value)) {
            return -1;
        }

        auto self = cast(PythonClass!T*) self_;
        auto tmp = self.getField!FieldIndex;

        pyIncRef(value);
        self.setField!FieldIndex(value);
        pyDecRef(tmp);

        return 0;
    }

    private PyObject* getField(int FieldIndex)() {
        mixin(`return this.`, fieldNames[FieldIndex], `;`);
    }

    private void setField(int FieldIndex)(PyObject* value) {
        mixin(`this.`, fieldNames[FieldIndex], ` = value;`);
    }
}


private bool checkPythonType(T)(PyObject* value) if(isArray!T) {
    import python.raw: pyListCheck;
    const ret = pyListCheck(value);
    if(!ret) setPyErrTypeString!"list";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(isIntegral!T) {
    import python.raw: pyLongCheck;
    const ret = pyLongCheck(value);
    if(!ret) setPyErrTypeString!"long";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(isFloatingPoint!T) {
    import python.raw: pyFloatCheck;
    const ret = pyFloatCheck(value);
    if(!ret) setPyErrTypeString!"float";
    return ret;
}


private void setPyErrTypeString(string type)() @trusted @nogc nothrow {
    import python.raw: PyErr_SetString, PyExc_TypeError;
    enum str = "must be a " ~ type;
    PyErr_SetString(PyExc_TypeError, &str[0]);
}
