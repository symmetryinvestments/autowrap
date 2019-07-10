/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;


import python.raw: PyObject;
import std.traits: Unqual, isArray, isIntegral, isBoolean, isFloatingPoint, isAggregateType;
import std.datetime: DateTime, Date;
import std.typecons: Tuple;
import std.range.primitives: isInputRange;
import std.meta: allSatisfy;


package enum isPhobos(T) = isDateOrDateTime!T || isTuple!T;
package enum isDateOrDateTime(T) = is(Unqual!T == DateTime) || is(Unqual!T == Date);
package enum isTuple(T) = is(T: Tuple!A, A...);
package enum isUserAggregate(T) = isAggregateType!T && !isPhobos!(T);
package enum isNonRangeUDT(T) = isUserAggregate!T && !isInputRange!T;


/**
   A wrapper for `PyTypeObject`.

   This struct does all of the necessary boilerplate to intialise
   a `PyTypeObject` for a Python extension type that mimics the D
   type `T`.
 */
struct PythonType(T) {
    import python.raw: PyTypeObject;
    import autowrap.reflection: PublicFieldNames, PublicFieldTypes;
    import std.traits: FieldNameTuple, Fields;
    import std.meta: Alias, staticMap;

    alias fieldNames = PublicFieldNames!T;
    alias fieldTypes = PublicFieldTypes!T;

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
        _pyType.tp_repr = &_py_repr;
        _pyType.tp_init = &_py_init;
        _pyType.tp_new = &_py_new;

        if(PyType_Ready(&_pyType) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            failedToReady = true;
        }
    }

    private static auto getsetDefs() {
        import python.raw: PyGetSetDef;

        // +1 due to the sentinel
        static PyGetSetDef[fieldNames.length + 1] getsets;

        // don't bother if already initialised
        if(getsets != getsets.init) return &getsets[0];

        static foreach(i; 0 .. fieldNames.length) {
            getsets[i].name = cast(typeof(PyGetSetDef.name)) fieldNames[i];
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
        import std.algorithm: startsWith;

        alias memberNames = AliasSeq!(__traits(allMembers, T));
        enum ispublic(string name) = isPublic!(T, name);
        alias publicMemberNames = Filter!(ispublic, memberNames);
        enum isRegular(string name) =
            name != "this"
            && name != "toHash"
            && name != "factory"
            && !name.startsWith("op")
            && name != "__ctor"
            ;
        alias regularMemberNames = Filter!(isRegular, publicMemberNames);
        alias Member(string name) = Alias!(__traits(getMember, T, name));
        alias members = staticMap!(Member, regularMemberNames);
        alias memberFunctions = Filter!(isSomeFunction, members);

        // +1 due to sentinel
        static PyMethodDef[memberFunctions.length + 1] methods;

        if(methods != methods.init) return &methods[0];

        static foreach(i, memberFunction; memberFunctions) {
            methods[i] = pyMethodDef!(__traits(identifier, memberFunction))
                                     (&PythonMethod!(T, memberFunction)._py_method_impl);
        }

        return &methods[0];
    }

    private static extern(C) PyObject* _py_repr(PyObject* self_) nothrow {

        return noThrowable!({

            import python: pyUnicodeDecodeUTF8, PyErr_SetString, PyExc_RuntimeError;
            import python.conv: to;
            import std.string: toStringz;
            import std.conv: text;

            assert(self_ !is null);
            auto ret = text(self_.to!T);
            return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
        });
    }

    private static extern(C) int _py_init(PyObject* self_, PyObject* args, PyObject* kwargs) nothrow {
        // nothing to do
        return 0;
    }

    private static extern(C) PyObject* _py_new(PyTypeObject *type, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!({
            import python.conv: toPython, to;
            import python.raw: PyTuple_Size, PyTuple_GetItem;
            import std.traits: hasMember, Unqual;
            import std.meta: AliasSeq;

            const numArgs = PyTuple_Size(args);

            if(numArgs == 0) {
                return toPython(userAggregateInit!T);
            }

            static if(hasMember!(T, "__ctor"))
                alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
            else
                alias constructors = AliasSeq!();

            static if(constructors.length == 0) {
                alias parameter(FieldType) = Parameter!(
                    FieldType,
                    "",
                    void,
                );
                alias parameters = staticMap!(parameter, fieldTypes);
                return pythonConstructor!(T, parameters)(args, kwargs);
            } else {
                import python.raw: PyErr_SetString, PyExc_TypeError;
                import std.traits: Parameters;

                static foreach(constructor; constructors) {
                    if(Parameters!constructor.length == numArgs) {
                        return pythonConstructor!(T, FunctionParameters!constructor)(args, kwargs);
                    } else if(numArgs >= NumRequiredParameters!constructor
                              && numArgs <= Parameters!constructor.length)
                    {
                        return pythonConstructor!(T, FunctionParameters!constructor)(args, kwargs);
                    }
                }

                PyErr_SetString(PyExc_TypeError, "Could not find a suitable constructor");
                return null;
            }

        });
    }

    // Creates a python object from the given arguments by converting them to D
    // types, calling the D constructor and converting the result to a Python
    // object.
    private static auto pythonConstructor(T, P...)(PyObject* args, PyObject* kwargs) {
        import python.conv: toPython;

        auto dArgs = pythonArgsToDArgs!P(args, kwargs);

        static if(is(T == class)) {
            // When immutable dmd prints an odd error message about not being
            // able to modify dobj
            static if(is(T == immutable))
                auto dobj = new T(dArgs.expand);
            else
                scope dobj = new T(dArgs.expand);
        } else
            auto dobj = T(dArgs.expand);

        return toPython(dobj);
    }
}


// From a function symbol to an AliasSeq of `Parameter`
private template FunctionParameters(alias F) {
    import std.traits: Parameters, ParameterIdentifierTuple, ParameterDefaults;
    import std.meta: staticMap, aliasSeqOf;
    import std.range: iota;

    alias parameter(size_t i) = Parameter!(
        Parameters!F[i],
        ParameterIdentifierTuple!F[i],
        ParameterDefaults!F[i]
    );

    alias FunctionParameters = staticMap!(parameter, aliasSeqOf!(Parameters!F.length.iota));
}


private template Parameter(T, string id, D...) if(D.length == 1) {
    alias Type = T;
    enum identifier = id;

    static if(is(D[0] == void))
        alias Default = void;
    else
        enum Default = D[0];
}

private template isParameter(alias T) {
    import std.traits: TemplateOf;
    enum isParameter = __traits(isSame, TemplateOf!T, Parameter);
}

private auto pythonArgsToDArgs(P...)(PyObject* args, PyObject* kwargs)
    if(allSatisfy!(isParameter, P))
{
    import python.raw: PyTuple_Size, PyTuple_GetItem, pyUnicodeDecodeUTF8, PyDict_GetItem;
    import python.conv: to;
    import std.typecons: Tuple;
    import std.meta: staticMap;
    import std.traits: Unqual;
    import std.conv: text;
    import std.exception: enforce;

    const argsLength = PyTuple_Size(args);

    alias Type(alias Param) = Param.Type;
    alias Types = staticMap!(Type, P);

    // If one or more of the parameters is const/immutable,
    // it'll be hard to construct it as such, so we Unqual
    // the types for construction and cast to the appropriate
    // type when returning.
    alias MutableTuple = Tuple!(staticMap!(Unqual, Types));
    alias RetTuple = Tuple!(Types);

    MutableTuple dArgs;

    int pythonArgIndex = 0;
    static foreach(i; 0 .. P.length) {
        static if(is(P[i].Default == void)) {
            // ith parameter is required
            enforce(i < argsLength,
                    text(__FUNCTION__, ": not enough Python arguments"));
            dArgs[i] = PyTuple_GetItem(args, i).to!(typeof(dArgs[i]));
        } else {
            // Here it gets tricky. The user could have supplied it in
            // args positionally or via kwargs
            if(i >= argsLength) {

                auto key = pyUnicodeDecodeUTF8(&P[i].identifier[0],
                                               P[i].identifier.length,
                                               null /*errors*/);
                enforce(key, "Errors converting '" ~ P[i].identifier ~ "' to Python object");
                auto val = kwargs ? PyDict_GetItem(kwargs, key) : null;
                dArgs[i] = val
                    ? val.to!(P[i].Type) // use kwargs
                    : P[i].Default; // use default value
            } else {
                dArgs[i] = PyTuple_GetItem(args, i).to!(P[i].Type);
            }
        }
    }

    return cast(RetTuple) dArgs;
}


private alias Type(alias A) = typeof(A);


/**
   The C API implementation of a Python method F of aggregate type T
 */
struct PythonMethod(T, alias F) {
    static extern(C) PyObject* _py_method_impl(PyObject* self,
                                               PyObject* args,
                                               PyObject* kwargs)
        nothrow
    {
        return noThrowable!({
            import python.raw: pyDecRef;
            import python.conv: toPython, to;
            import std.traits: Parameters, FunctionAttribute, functionAttributes, Unqual, hasFunctionAttributes;

            assert(self !is null,
                   "Cannot call PythonMethod!" ~ __traits(identifier, F) ~ " on null self");

            static if(functionAttributes!F & FunctionAttribute.const_)
                alias Aggregate = const T;
            else static if(functionAttributes!F & FunctionAttribute.immutable_)
                alias Aggregate = immutable T;
            else
                alias Aggregate = Unqual!T;

            auto dAggregate = self.to!Aggregate;

            // Not sure how else to take `dAggregate` and `F` and call the member
            // function other than a mixin
            mixin(`auto ret = callDlangFunction!((Parameters!F args) => dAggregate.`,
                  __traits(identifier, F), `(args))(self, args, kwargs);`);

            // The member function could have side-effects, we need to copy the changes
            // back to the Python object.
            static if(!(functionAttributes!F & FunctionAttribute.const_)) {
                auto newSelf = toPython(dAggregate);
                scope(exit) {
                    pyDecRef(newSelf);
                }
                auto pyClassSelf = cast(PythonClass!T*) self;
                auto pyClassNewSelf = cast(PythonClass!T*) newSelf;

                static foreach(i; 0 .. PythonClass!T.fieldNames.length) {
                    pyClassSelf.set!i(self, pyClassNewSelf.get!i(newSelf));
                }
            }

            return ret;
        });
    }
}


/**
   The C API implementation that calls a D function F.
 */
struct PythonFunction(alias F) {
    static extern(C) PyObject* _py_function_impl(PyObject* self, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!(() => callDlangFunction!F(self, args, kwargs));
    }
}


private auto callDlangFunction(alias F)(PyObject* self, PyObject* args, PyObject* kwargs) {
    import python.raw: PyTuple_Size, PyErr_SetString, PyExc_RuntimeError;
    import python.conv: toPython;
    import std.traits: Parameters;
    import std.conv: text;
    import std.string: toStringz;
    import std.exception: enforce;

    enum numDefaults = NumDefaultParameters!F;
    enum numRequired = NumRequiredParameters!F;

    enforce(PyTuple_Size(args) >= numRequired
            && PyTuple_Size(args) <= Parameters!F.length,
            text("Received ", PyTuple_Size(args), " parameters but ",
                 __traits(identifier, F), " takes ", Parameters!F.length));

    auto dArgs = pythonArgsToDArgs!(FunctionParameters!F)(args, kwargs);
    return callDlangFunction!F(dArgs);
}

private auto noThrowable(alias F, A...)(auto ref A args) {
    import python.raw: PyErr_SetString, PyExc_RuntimeError;
    import std.string: toStringz;

    try {
        return F(args);
    } catch(Exception e) {
        PyErr_SetString(PyExc_RuntimeError, e.msg.toStringz);
        return null;
    } catch(Error e) {
        PyErr_SetString(PyExc_RuntimeError, ("FATAL ERROR: " ~ e.msg).toStringz);
        return null;
    }
}


private auto callDlangFunction(alias F, A)(auto ref A argTuple) {
    import python.raw: pyIncRef, pyNone;
    import python.conv: toPython;
    import std.traits: ReturnType;

    // TODO - side-effects on parameters?
    static if(is(ReturnType!F == void)) {
        F(argTuple.expand);
        pyIncRef(pyNone);
        return pyNone;
    } else {
        auto dret = F(argTuple.expand);
        return dret.toPython;
    }
}


private template NumDefaultParameters(alias F) {
    import std.meta: Filter;
    import std.traits: ParameterDefaults;

    template notVoid(T...) if(T.length == 1) {
        enum notVoid = !is(T[0] == void);
    }

    enum NumDefaultParameters = Filter!(notVoid, ParameterDefaults!F).length;
}


private template NumRequiredParameters(alias F) {
    import std.traits: Parameters;
    enum NumRequiredParameters = Parameters!F.length - NumDefaultParameters!F;
}

/**
   Creates an instance of a Python class that is equivalent to the D type `T`.
   Return PyObject*.
 */
PyObject* pythonClass(T)(auto ref T dobj) {

    import python.conv: toPython;
    import python.raw: pyObjectNew;
    import std.traits: FieldNameTuple;

    static if(is(T == class)) {
        if(dobj is null)
            throw new Exception("Cannot create Python class from null D class");
    }

    auto ret = pyObjectNew!(PythonClass!T)(PythonType!T.pyType);

    static foreach(fieldName; FieldNameTuple!T) {
        static if(isPublic!(T, fieldName))
            mixin(`ret.`, fieldName, ` = dobj.`, fieldName, `.toPython;`);
    }

    return cast(PyObject*) ret;
}


private template isPublic(T, string memberName) {

    static if(__traits(compiles, __traits(getProtection, __traits(getMember, T, memberName)))) {
        enum protection = __traits(getProtection, __traits(getMember, T, memberName));
        enum isPublic = protection == "public" || protection == "export";
    } else
        enum isPublic = false;
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
struct PythonClass(T) if(isUserAggregate!T) {
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
    private static extern(C) PyObject* get(int FieldIndex)(PyObject* self_, void* closure = null) nothrow {
        import python.raw: pyIncRef;

        assert(self_ !is null);
        auto self = cast(PythonClass*) self_;

        auto field = self.getField!FieldIndex;
        assert(field !is null, "Cannot increase reference count on null field");
        pyIncRef(field);

        return field;
    }

    // The function pointer for PyGetSetDef.set
    static extern(C) int set(int FieldIndex)(PyObject* self_, PyObject* value, void* closure = null) nothrow {
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

// Generalises T.init for classes since null isn't a value we want to use
T userAggregateInit(T)() {
    static if(is(T == class)) {
        auto buffer = new void[__traits(classInstanceSize, T)];
        // this is needed for the vtable to work
        buffer[] = typeid(T).initializer[];
        return cast(T) buffer.ptr;
    } else
        return T.init;
}
