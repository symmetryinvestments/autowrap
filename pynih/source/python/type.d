/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;


import python.raw: PyObject;
import std.traits: isArray, isIntegral, isBoolean, isFloatingPoint, isAggregateType;
import std.datetime: DateTime, Date;


/**
   A wrapper for `PyTypeObject`.

   This struct does all of the necessary boilerplate to intialise
   a `PyTypeObject` for a Python extension type that mimics the D
   type `T`.
 */
struct PythonType(T) {
    import python.raw: PyTypeObject;
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

        _pyType.tp_name = T.stringof;
        _pyType.tp_basicsize = PythonClass!T.sizeof;
        _pyType.tp_flags = TypeFlags.Default;
        _pyType.tp_new = &PyType_GenericNew;
        _pyType.tp_getset = getsetDefs;
        _pyType.tp_methods = methodDefs;
        _pyType.tp_repr = &repr;
        _pyType.tp_init = &init;
        _pyType.tp_new = &new_;

        if(PyType_Ready(&_pyType) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            failedToReady = true;
        }
    }

    private static auto getsetDefs() {
        import python.raw: PyGetSetDef;

        // +1 due to the sentinel
        static PyGetSetDef[fieldNames.length + 1] getsets;

        if(getsets != getsets.init) return &getsets[0];

        static foreach(i; 0 .. fieldNames.length) {
            getsets[i].name = cast(typeof(PyGetSetDef.name))fieldNames[i];
            getsets[i].get = &PythonClass!T.get!i;
            getsets[i].set = &PythonClass!T.set!i;
        }

        return &getsets[0];
    }

    private static auto methodDefs()() {
        import python.raw: PyMethodDef;
        import python.cooked: pyMethodDef;
        import std.meta: AliasSeq, Alias, staticMap, Filter;
        import std.traits: isSomeFunction;

        alias memberNames = AliasSeq!(__traits(allMembers, T));
        enum ispublic(string name) = isPublic!(T, name);
        alias publicMemberNames = Filter!(ispublic, memberNames);
        alias Member(string name) = Alias!(__traits(getMember, T, name));
        alias members = staticMap!(Member, publicMemberNames);
        alias memberFunctions = Filter!(isSomeFunction, members);

        // +1 due to sentinel
        static PyMethodDef[memberFunctions.length + 1] methods;

        if(methods != methods.init) return &methods[0];

        static foreach(i, memberFunction; memberFunctions) {
            methods[i] = pyMethodDef!(__traits(identifier, memberFunction))
                                     (&PythonMethod!(T, memberFunction).impl);
        }

        return &methods[0];
    }

    private static extern(C) PyObject* repr(PyObject* self_) {
        import python: pyUnicodeDecodeUTF8;
        import python.conv: to;
        import std.conv: text;

        assert(self_ !is null);
        auto ret = text(self_.to!T);
        return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
    }

    private static extern(C) int init(PyObject* self_, PyObject* args, PyObject* kwargs) {
        // nothing to do
        return 0;
    }

    private static extern(C) PyObject* new_(PyTypeObject *type, PyObject* args, PyObject* kwargs) {
        import python.conv: toPython, to;
        import python.raw: PyTuple_Size, PyTuple_GetItem;
        import std.traits: hasMember;
        import std.meta: AliasSeq;

        const numArgs = PyTuple_Size(args);

        if(numArgs == 0)
            return toPython(T());

        // TODO: parameters
        static if(hasMember!(T, "__ctor"))
            alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
        else
            alias constructors = AliasSeq!();

        static if(constructors.length == 0) {

            import std.typecons: Tuple;

            Tuple!fieldTypes dArgs;

            static foreach(i; 0 .. fieldTypes.length) {
                dArgs[i] = PyTuple_GetItem(args, i).to!(fieldTypes[i]);
            }

            return toPython(T(dArgs.expand));

        } else {
            import python.raw: PyErr_SetString, PyExc_TypeError;
            import std.traits: Parameters;
            import std.typecons: Tuple;

            static foreach(constructor; constructors) {
                if(Parameters!constructor.length == numArgs) {

                    Tuple!(Parameters!constructor) dArgs;

                    static foreach(i; 0 .. Parameters!constructor.length) {
                        dArgs[i] = PyTuple_GetItem(args, i).to!(Parameters!constructor[i]);
                    }

                    return toPython(T(dArgs.expand));
                }
            }

            PyErr_SetString(PyExc_TypeError, "Could not find a suitable constructor");
            return null;
        }


    }
}

private alias Type(alias A) = typeof(A);


/**
   The C API implementation of a Python method F of aggregate type T
 */
struct PythonMethod(T, alias F) {
    static extern(C) PyObject* impl(PyObject* self_, PyObject* args, PyObject* kwargs) {
        import python.raw: PyTuple_Size, PyTuple_GetItem, pyIncRef, pyNone, pyDecRef;
        import python.conv: toPython, to;
        import std.traits: Parameters, ReturnType, FunctionAttribute, functionAttributes, Unqual;
        import std.typecons: Tuple;
        import std.meta: staticMap;

        assert(PyTuple_Size(args) == Parameters!F.length);

        Tuple!(staticMap!(Unqual, Parameters!F)) dArgs;

        static foreach(i; 0 .. Parameters!F.length) {
            dArgs[i] = PyTuple_GetItem(args, i).to!(Parameters!F[i]);
        }

        assert(self_ !is null);
        auto dAggregate = self_.to!(Unqual!T);

        static if(is(ReturnType!F == void))
            enum dret = "";
        else
            enum dret = "auto dRet = ";

        // e.g. `auto dRet = dAggregate.myMethod(dArgs[0], dArgs[1]);`
        mixin(dret, `dAggregate.`, __traits(identifier, F), `(dArgs.expand);`);

        // The member function could have side-effects, we need to copy the changes
        // back to the Python object.
        static if(!(functionAttributes!F & FunctionAttribute.const_)) {
            auto newSelf = toPython(dAggregate);
            scope(exit) {
                pyDecRef(newSelf);
            }
            auto pyClassSelf = cast(PythonClass!T*) self_;
            auto pyClassNewSelf = cast(PythonClass!T*) newSelf;

            static foreach(i; 0 .. PythonClass!T.fieldNames.length) {
                pyClassSelf.set!i(self_, pyClassNewSelf.get!i(newSelf));
            }
        }

        static if(!is(ReturnType!F == void))
            return dRet.toPython;
        else {
            pyIncRef(pyNone);
            return pyNone;
        }
    }
}


/**
   Creates an instance of a Python class that is equivalent to the D type `T`.
   Return PyObject*.
 */
PyObject* pythonClass(T)(auto ref T dobj) {

    import python.conv: toPython;
    import python.raw: pyObjectNew;
    import std.traits: FieldNameTuple;

    auto ret = pyObjectNew!(PythonClass!T)(PythonType!T.pyType);

    static foreach(fieldName; FieldNameTuple!T) {
        static if(isPublic!(T, fieldName))
            mixin(`ret.`, fieldName, ` = dobj.`, fieldName, `.toPython;`);
    }

    return cast(PyObject*) ret;
}


private template isPublic(T, string memberName) {
    enum protection = __traits(getProtection, __traits(getMember, T, memberName));
    enum isPublic = protection == "public" || protection == "export";
}


private enum isDateOrDateTime(T) = is(Unqual!T == DateTime) || is(Unqual!T == Date);


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
struct PythonClass(T) if(isAggregateType!T && !isDateOrDateTime!T) {
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
    private static extern(C) PyObject* get(int FieldIndex)(PyObject* self_, void* closure = null) {
        import python.raw: pyIncRef;

        assert(self_ !is null);
        auto self = cast(PythonClass*) self_;

        auto field = self.getField!FieldIndex;
        assert(field !is null, "Cannot increase reference count on null field");
        pyIncRef(field);

        return field;
    }

    // The function pointer for PyGetSetDef.set
    static extern(C) int set(int FieldIndex)(PyObject* self_, PyObject* value, void* closure = null) {
        import python.raw: pyIncRef, pyDecRef, PyErr_SetString, PyExc_TypeError;

        if(value is null) {
            enum deleteErrStr = "Cannot delete " ~ fieldNames[FieldIndex];
            PyErr_SetString(PyExc_TypeError, deleteErrStr);
            return -1;
        }

        // FIXME
        // if(!checkPythonType!(fieldTypes[FieldIndex])(value)) {
        //     return -1;
        // }

        assert(self_ !is null);
        auto self = cast(PythonClass!T*) self_;
        auto tmp = self.getField!FieldIndex;

        pyIncRef(value);
        self.setField!FieldIndex(value);
        pyDecRef(tmp);

        return 0;
    }

    PyObject* getField(int FieldIndex)() {
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
    import python.raw: pyIntCheck, pyLongCheck;
    const ret = pyLongCheck(value) || pyIntCheck(value);
    if(!ret) setPyErrTypeString!"long";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(isFloatingPoint!T) {
    import python.raw: pyFloatCheck;
    const ret = pyFloatCheck(value);
    if(!ret) setPyErrTypeString!"float";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(is(T == DateTime)) {
    import python.raw: pyDateTimeCheck;
    const ret = pyDateTimeCheck(value);
    if(!ret) setPyErrTypeString!"DateTime";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(is(T == Date)) {
    import python.raw: pyDateCheck;
    const ret = pyDateCheck(value);
    if(!ret) setPyErrTypeString!"Date";
    return ret;
}



private void setPyErrTypeString(string type)() @trusted @nogc nothrow {
    import python.raw: PyErr_SetString, PyExc_TypeError;
    enum str = "must be a " ~ type;
    PyErr_SetString(PyExc_TypeError, &str[0]);
}
