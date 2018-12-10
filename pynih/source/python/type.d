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

        static foreach(i; 0 .. Fields!T.length) {
            members[i].name = cast(typeof(PyMemberDef.name)) &FieldNameTuple!T[i][0];
            members[i].type = MemberType.Int; // FIXME
            members[i].offset = __traits(getMember, T, FieldNameTuple!T[i]).offsetof + PythonAggregate!T.original.offsetof;
        }

        _pyType.tp_members = &members[0];

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
