/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;


import python.raw: PyObject;
import mirror.meta.traits: isParameter, BinaryOperator;
import std.traits: Unqual, isArray, isIntegral, isBoolean, isFloatingPoint,
    isAggregateType, isCallable, isAssociativeArray, isSomeFunction;
import std.datetime: DateTime, Date, TimeOfDay;
import std.typecons: Tuple;
import std.range.primitives: isInputRange;
import std.meta: allSatisfy;
static import core.time;


package enum isPhobos(T) = isDateOrDateTime!T || isTuple!T || is(Unqual!T == core.time.Duration);
package enum isDateOrDateTime(T) = is(Unqual!T == DateTime) || is(Unqual!T == Date) || is(Unqual!T == TimeOfDay);
package enum isTuple(T) = is(Unqual!T == Tuple!A, A...);
package enum isUserAggregate(T) = isAggregateType!T && !isPhobos!(T);
package enum isNonRangeUDT(T) = isUserAggregate!T && !isInputRange!T;


/**
   A wrapper for `PyTypeObject`.

   This struct does all of the necessary boilerplate to intialise
   a `PyTypeObject` for a Python extension type that mimics the D
   type `T`.
 */
struct PythonType(T) {
    import python.raw: PyTypeObject, PySequenceMethods, PyMappingMethods;
    import std.traits: FieldNameTuple, Fields, Unqual, fullyQualifiedName, BaseClassesTuple;
    import std.meta: Alias, AliasSeq, staticMap;

    static if(is(T == struct) || is(T == union)) {
        alias fieldNames = FieldNameTuple!T;
        alias fieldTypes = Fields!T;
    } else static if(is(T == class)) {
        // recurse over base classes to get all fields
        alias fieldNames = AliasSeq!(FieldNameTuple!T, staticMap!(FieldNameTuple, BaseClassesTuple!T));
        private alias fieldType(string name) = typeof(__traits(getMember, T, name));
        alias fieldTypes = staticMap!(fieldType, fieldNames);
    } else static if(is(T == interface)) {
        alias fieldNames = AliasSeq!();
        alias fieldTypes = AliasSeq!();
    }

    enum hasLength = is(typeof({ size_t len = T.init.length; }));

    static PyTypeObject _pyType;
    static bool failedToReady;

    static PyObject* pyObject() {
        return cast(PyObject*) pyType;
    }

    static PyTypeObject* pyType() nothrow {
        initialise;
        return failedToReady ? null : &_pyType;
    }

    private static void initialise() nothrow {
        import autowrap.common: AlwaysTry;
        import python.raw: PyType_GenericNew, PyType_Ready, TypeFlags,
            PyErr_SetString, PyExc_TypeError,
            PyNumberMethods, PySequenceMethods;
        import mirror.meta.traits: UnaryOperators, BinaryOperators, AssignOperators, functionName;
        import std.traits: arity, hasMember, TemplateOf;
        import std.meta: Filter;
        static import std.typecons;

        if(_pyType != _pyType.init) return;

        // This allows tp_name to do its usual Python job and allows us to
        // construct a D class from its runtime Python type.
        _pyType.tp_name = fullyQualifiedName!(Unqual!T).ptr;
        _pyType.tp_flags = TypeFlags.Default;
        static if(is(T == class) || is(T == interface))
            _pyType.tp_flags |= TypeFlags.BaseType;

        // FIXME: types are that user aggregates *and* callables
        static if(isUserAggregate!T) {
            _pyType.tp_basicsize = PythonClass!T.sizeof;

            static if(AlwaysTry || __traits(compiles, getsetDefs()))
                _pyType.tp_getset = getsetDefs;
            else
                pragma(msg, "WARNING: could not generate attribute accessors for ", fullyQualifiedName!T);

            _pyType.tp_methods = methodDefs;
            static if(!isAbstract!T)
                _pyType.tp_new = &_py_new;
            _pyType.tp_repr = &_py_repr;
            _pyType.tp_init = &_py_init;

            // special-case std.typecons.Typedef
            // see: https://issues.dlang.org/show_bug.cgi?id=20117
            static isSamePtr(void* lhs, void* rhs) {
                return lhs is rhs;
            }

            static if(__traits(compiles, isSamePtr(&T.opCmp, &Object.opCmp))) {
                static if(
                    hasMember!(T, "opCmp")
                    && !__traits(isSame, TemplateOf!T, std.typecons.Typedef)
                    && !isSamePtr(&T.opCmp, &Object.opCmp)
                    )
                {
                    _pyType.tp_richcompare = &PythonOpCmp!T._py_cmp;
                } else
                    _pyType.tp_richcompare = &PythonCompare!T._py_cmp;
            } else
                _pyType.tp_richcompare = &PythonCompare!T._py_cmp;


            static if(hasMember!(T, "opSlice")) {
                static if(AlwaysTry || __traits(compiles, &PythonIterViaList!T._py_iter))
                    _pyType.tp_iter = &PythonIterViaList!T._py_iter;
                else
                    pragma(msg, "WARNING: could not implement Python opSlice for ", fullyQualifiedName!T);
            } else static if(isInputRange!T) {
                static if(AlwaysTry || __traits(compiles, &PythonIter!T._py_iter_next)) {
                    _pyType.tp_iter = &PythonIter!T._py_iter;
                    _pyType.tp_iternext = &PythonIter!T._py_iter_next;
                } else
                    pragma(msg, "WARNING: could not implement Python iterator for ", fullyQualifiedName!T);
            }

            // In Python, both D's opIndex and opSlice are dealt with by one function,
            // in opSlice's case when the type is indexed by a Python slice
            static if(hasMember!(T, "opIndex") || hasMember!(T, "opSlice")) {
                if(_pyType.tp_as_mapping is null)
                    _pyType.tp_as_mapping = new PyMappingMethods;
                static if(AlwaysTry || __traits(compiles, &PythonSubscript!T._py_index))
                    _pyType.tp_as_mapping.mp_subscript = &PythonSubscript!T._py_index;
                else
                    pragma(msg, "WARNING: could not implement Python index for ",
                           fullyQualifiedName!T);
            }

            static if(hasMember!(T, "opIndexAssign")) {
                if(_pyType.tp_as_mapping is null)
                    _pyType.tp_as_mapping = new PyMappingMethods;

                static if(AlwaysTry || __traits(compiles, &PythonIndexAssign!T._py_index_assign))
                    _pyType.tp_as_mapping.mp_ass_subscript = &PythonIndexAssign!T._py_index_assign;
                else
                    pragma(msg, "WARNING: could not implement Python index assign for ",
                           fullyQualifiedName!T);
            }

            enum isPythonableUnary(string op) = op == "+" || op == "-" || op == "~";
            enum unaryOperators = Filter!(isPythonableUnary, UnaryOperators!T);
            alias binaryOperators = BinaryOperators!T;
            alias assignOperators = AssignOperators!T;

            static if(unaryOperators.length > 0 || binaryOperators.length > 0 || assignOperators.length > 0) {
                _pyType.tp_as_number = new PyNumberMethods;
                _pyType.tp_as_sequence = new PySequenceMethods;
            }

            static foreach(op; unaryOperators) {
                mixin(`_pyType.`, dlangUnOpToPythonSlot(op), ` = &PythonUnaryOperator!(T, op)._py_un_op;`);
            }

            static foreach(binOp; binaryOperators) {{
                // first get the Python function pointer name
                enum slot = dlangBinOpToPythonSlot(binOp.op);
                // some of them differ in arity
                enum slotArity = arity!(mixin(`typeof(PyTypeObject.`, slot, `)`));

                // get the function name in PythonBinaryOperator
                // `in` is special because the function signature is different
                static if(binOp.op == "in") {
                    enum cFuncName = "_py_in_func";
                } else {
                    static if(slotArity == 2)
                        enum cFuncName = "_py_bin_func";
                    else static if(slotArity == 3)
                        enum cFuncName = "_py_ter_func";
                    else
                        static assert("Do not know how to deal with slot " ~ slot);
                }

                // set the C function that implements this operator
                mixin(`_pyType.`, slot, ` = &PythonBinaryOperator!(T, binOp).`, cFuncName, `;`);
            }}

            static foreach(assignOp; assignOperators) {{
                enum slot = dlangAssignOpToPythonSlot(assignOp);
                                // some of them differ in arity
                enum slotArity = arity!(mixin(`typeof(PyTypeObject.`, slot, `)`));

                // get the function name in PythonAssignOperator
                static if(slotArity == 2)
                    enum cFuncName = "_py_bin_func";
                else static if(slotArity == 3)
                    enum cFuncName = "_py_ter_func";
                else
                    static assert("Do not know how to deal with slot " ~ slot);

                // set the C function that implements this operator
                mixin(`_pyType.`, slot, ` = &PythonAssignOperator!(T, assignOp).`, cFuncName, `;`);
            }}

            static if(isCallable!T) {
                _pyType.tp_call = &PythonCallable!T._py_call;
            }

            // inheritance
            static if(is(T Bases == super)) {
                enum isSuperClass(U) = is(U == class) && !is(U == Object);
                alias supers = Filter!(isSuperClass, Bases);
                static if(supers.length == 1) {
                    _pyType.tp_base = PythonType!(supers[0]).pyType;
                }
            }

        } else static if(isCallable!T) {
            _pyType.tp_basicsize = PythonCallable!T.sizeof;
            _pyType.tp_call = &PythonCallable!T._py_call;
        } else static if(is(T == enum)) {
            import python.raw: PyEnum_Type;
            _pyType.tp_basicsize = 0;
            _pyType.tp_base = &PyEnum_Type;
            try
                _pyType.tp_dict = classDict;
            catch(Exception e) {
                import core.stdc.stdio;
                enum msg = "Could not create class dict for " ~ T.stringof ~ "\n";
                printf(msg);
            }
        } else
            static assert(false, "Don't know what to do for type " ~ T.stringof);

        static if(hasLength) {
            if(_pyType.tp_as_sequence is null)
                _pyType.tp_as_sequence = new PySequenceMethods;
            _pyType.tp_as_sequence.sq_length = &_py_length;
        }

        if(PyType_Ready(&_pyType) < 0) {
            PyErr_SetString(PyExc_TypeError, &"not ready"[0]);
            failedToReady = true;
        }
    }

    static if(is(T == enum)) {
        private static PyObject* classDict() {
            import python.conv.d_to_python: toPython;
            import std.traits: EnumMembers, OriginalType;

            OriginalType!T[string] dict;

            static foreach(i; 0 .. EnumMembers!T.length) {
                dict[__traits(identifier, EnumMembers!T[i])] = EnumMembers!T[i];
            }

            return dict.toPython;
        }
    }

    static if(isUserAggregate!T)
    private static auto getsetDefs() {
        import autowrap.common: AlwaysTry;
        import python.raw: PyGetSetDef;
        import mirror.meta.traits: isProperty, MemberFunctionsByOverload;
        import std.meta: Filter;
        import std.traits: ReturnType;

        alias properties = Filter!(isProperty, MemberFunctionsByOverload!T);

        // +1 due to the sentinel
        static PyGetSetDef[fieldNames.length + properties.length + 1] getsets;

        // don't bother if already initialised
        if(getsets != getsets.init) return &getsets[0];

        template isPublic(string fieldName) {
            static if(__traits(compiles, __traits(getMember, T, fieldName))) {
                alias field = __traits(getMember, T, fieldName);
                static if(__traits(compiles, __traits(getProtection, field)))
                    enum isPublic = __traits(getProtection, field) == "public";
                else
                    enum isPublic = false;
            } else
                enum isPublic = false;
        }

        // first deal with the public fields
        static foreach(i; 0 .. fieldNames.length) {
            getsets[i].name = cast(typeof(PyGetSetDef.name)) fieldNames[i];
            static if(isPublic!(fieldNames[i])) {
                getsets[i].get = &PythonClass!T._get_impl!i;
                getsets[i].set = &PythonClass!T._set_impl!i;
            }
        }

        // then deal with the property functions
        static foreach(j, property; properties) {{
            enum i = fieldNames.length + j;

            getsets[i].name = cast(typeof(PyGetSetDef.name)) __traits(identifier, property);

            static foreach(overload; __traits(getOverloads, T, __traits(identifier, property))) {
                static if(is(ReturnType!overload == void)) { // setter
                    static if(AlwaysTry || __traits(compiles, &PythonClass!T.propertySet!overload))
                        getsets[i].set = &PythonClass!T.propertySet!overload;
                    else
                        pragma(msg, "Cannot implement ", fullyQualifiedName!T, ".set!", i, " (", __traits(identifier, overload), ")");
                } else  { // getter
                    static if(AlwaysTry || __traits(compiles, &PythonClass!T.propertyGet!overload))
                        getsets[i].get = &PythonClass!T.propertyGet!overload;
                    else {
                        pragma(msg, "Cannot implement ", fullyQualifiedName!T, ".get!", i, " (", __traits(identifier, overload), ")");
                        // getsets[i].get = &PythonClass!T.propertyGet!overload;
                    }
                }
            }
        }}

        return &getsets[0];
    }

    private static auto methodDefs()() {
        import autowrap.common: AlwaysTry;
        import python.raw: PyMethodDef, MethodArgs;
        import python.cooked: pyMethodDef, defaultMethodFlags;
        import mirror.meta.traits: isProperty;
        import std.meta: AliasSeq, Alias, staticMap, Filter, templateNot;
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
            && !name.startsWith("__")
            ;
        alias regularMemberNames = Filter!(isRegular, publicMemberNames);
        alias overloads(string name) = AliasSeq!(__traits(getOverloads, T, name));
        alias members = staticMap!(overloads, regularMemberNames);
        alias memberFunctions = Filter!(templateNot!isProperty, Filter!(isSomeFunction, members));

        // +1 due to sentinel
        static PyMethodDef[memberFunctions.length + 1] methods;

        if(methods != methods.init) return &methods[0];

        static foreach(i, memberFunction; memberFunctions) {{

            static if(__traits(isStaticFunction, memberFunction))
                enum flags = defaultMethodFlags | MethodArgs.Static;
            else
                enum flags = defaultMethodFlags;

            static if(AlwaysTry || __traits(compiles, &PythonMethod!(T, memberFunction)._py_method_impl))
                methods[i] = pyMethodDef!(__traits(identifier, memberFunction), flags)
                                         (&PythonMethod!(T, memberFunction)._py_method_impl);
            else {
                pragma(msg, "WARNING: could not wrap D method `", T, ".", __traits(identifier, memberFunction), "`");
                // uncomment to get the compiler error message to find out why not
                // auto ptr = &PythonMethod!(T, memberFunction)._py_method_impl;
            }
        }}

        return &methods[0];
    }

    import python.raw: Py_ssize_t;
    private static extern(C) Py_ssize_t _py_length(PyObject* self_) nothrow {

        return noThrowable!({
            assert(self_ !is null);
            static if(hasLength) {
                import python.conv: to;
                return self_.to!T.length;
            } else
                return -1;
        });
    }

    private static extern(C) PyObject* _py_repr(PyObject* self_) nothrow {

        return noThrowable!({

            import python: pyUnicodeDecodeUTF8;
            import python.conv: to;
            import std.string: toStringz;
            import std.conv: text;
            import std.traits: fullyQualifiedName;

            assert(self_ !is null);

            static if(__traits(compiles, text(self_.to!T))) {
                auto ret = text(self_.to!T);
                return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
            } else {
                pragma(msg, "WARNING: cannot generate repr for ", fullyQualifiedName!T);
                PyObject* impl() {
                    throw new Exception("Unable to generate Python repr for F " ~ fullyQualifiedName!T);
                }
                return impl;
            }
        });
    }

    private static extern(C) int _py_init(PyObject* self_, PyObject* args, PyObject* kwargs) nothrow {
        // nothing to do
        return 0;
    }

    static if(isUserAggregate!T && !isAbstract!T)
    private static extern(C) PyObject* _py_new(PyTypeObject *type, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!({
            import python.conv: toPython;
            import python.raw: PyTuple_Size;
            import mirror.meta.traits: isPrivate;
            import std.traits: hasMember, fullyQualifiedName;

            if(PyTuple_Size(args) == 0) return toPython(userAggregateInit!T);

            static if(hasMember!(T, "__ctor") && !isPrivate!(__traits(getMember, T, "__ctor"))) {
                static if(__traits(compiles, callDlangFunction!(T, __traits(getMember, T, "__ctor"))(null /*self*/, args, kwargs)))
                    return callDlangFunction!(T, __traits(getMember, T, "__ctor"))(null /*self*/, args, kwargs);
                else {
                    pragma(msg, "WARNING: cannot wrap constructor for `", fullyQualifiedName!T, "`");
                    // uncomment below to see the compilation error
                    // return callDlangFunction!(T, __traits(getMember, T, "__ctor"))(null /*self*/, args, kwargs);
                    return toPython(userAggregateInit!T);
                }

            } else { // allow implicit constructors to work in Python
                T impl(fieldTypes fields = fieldTypes.init) {
                    static if(is(T == class)) {
                        if(PyTuple_Size(args) != 0)
                            throw new Exception(T.stringof ~ " has no constructor therefore can't construct one from arguments");
                        return T.init;
                    } else {
                        static if(__traits(compiles, T(fields)))
                            return T(fields);
                        else {
                            pragma(msg, "WARNING: cannot use implicit constructor for `", T, "`");
                            // uncomment below to see the compiler error
                            // auto _t_tmp = T(fields);
                            return T.init;
                        }
                    }
                }

                static if(__traits(compiles, callDlangFunction!(typeof(impl), impl)(null, args, kwargs)))
                    return callDlangFunction!(typeof(impl), impl)(null /*self*/, args, kwargs);
                else {
                    enum msg = "could not generate constructor for " ~ fullyQualifiedName!T;
                    pragma(msg, "WARNING: ", msg);
                    static PyObject* oops() {
                        throw new Exception(msg);
                    }
                    return oops;
                }
            }
        });
    }
}


private template isAbstract(T) {
    import std.traits: isAbstractClass;
    enum isAbstract = is(T == interface) || isAbstractClass!T;
}


// From a D operator (e.g. `+`) to a Python function pointer member name
private string dlangUnOpToPythonSlot(string op) {
    enum opToSlot = [
        "+": "tp_as_number.nb_positive",
        "-": "tp_as_number.nb_negative",
        "~": "tp_as_number.nb_invert",
    ];
    if(op !in opToSlot) throw new Exception("Unknown unary operator " ~ op);
    return opToSlot[op];
}


// From a D operator (e.g. `+`) to a Python function pointer member name
private string dlangBinOpToPythonSlot(string op) {
    enum opToSlot = [
        "+":   "tp_as_number.nb_add",
        "+=":  "tp_as_number.nb_inplace_add",
        "-":   "tp_as_number.nb_subtract",
        "-=":  "tp_as_number.nb_inplace_subtract",
        "*":   "tp_as_number.nb_multiply",
        "*=":  "tp_as_number.nb_inplace_multiply",
        "/":   "tp_as_number.nb_divide",
        "/=":  "tp_as_number.nb_inplace_true_divide",
        "%":   "tp_as_number.nb_remainder",
        "%=":  "tp_as_number.nb_inplace_remainder",
        "^^":  "tp_as_number.nb_power",
        "^^=": "tp_as_number.nb_inplace_power",
        "&":   "tp_as_number.nb_and",
        "&=":  "tp_as_number.nb_inplace_and",
        "|":   "tp_as_number.nb_or",
        "|=":  "tp_as_number.nb_inplace_or",
        "^":   "tp_as_number.nb_xor",
        "^=":  "tp_as_number.nb_inplace_xor",
        "<<":  "tp_as_number.nb_lshift",
        "<<=": "tp_as_number.nb_inplace_lshift",
        ">>":  "tp_as_number.nb_rshift",
        ">>=": "tp_as_number.nb_inplace_rshift",
        "~":   "tp_as_sequence.sq_concat",
        "~=":  "tp_as_sequence.sq_concat",
        "in":  "tp_as_sequence.sq_contains",
    ];
    if(op !in opToSlot) throw new Exception("Unknown binary operator " ~ op);
    return opToSlot[op];
}


// From a D operator (e.g. `+`) to a Python function pointer member name
private string dlangAssignOpToPythonSlot(string op) {
    enum opToSlot = [
        "+":  "tp_as_number.nb_inplace_add",
        "-":  "tp_as_number.nb_inplace_subtract",
        "*":  "tp_as_number.nb_inplace_multiply",
        "/":  "tp_as_number.nb_inplace_true_divide",
        "%":  "tp_as_number.nb_inplace_remainder",
        "^^": "tp_as_number.nb_inplace_power",
        "&":  "tp_as_number.nb_inplace_and",
        "|":  "tp_as_number.nb_inplace_or",
        "^":  "tp_as_number.nb_inplace_xor",
        "<<": "tp_as_number.nb_inplace_lshift",
        ">>": "tp_as_number.nb_inplace_rshift",
        "~":  "tp_as_sequence.sq_concat",
    ];
    if(op !in opToSlot) throw new Exception("Unknown assignment operator " ~ op);
    return opToSlot[op];
}


auto pythonArgsToDArgs(bool isVariadic, P...)(PyObject* args, PyObject* kwargs)
    if(allSatisfy!(isParameter, P))
{
    import python.raw: PyTuple_Size, PyTuple_GetItem, PyTuple_GetSlice, pyUnicodeDecodeUTF8, PyDict_GetItem;
    import python.conv: to;
    import std.typecons: Tuple;
    import std.meta: staticMap;
    import std.traits: Unqual;
    import std.conv: text;
    import std.exception: enforce;

    const argsLength = args is null ? 0 : PyTuple_Size(args);

    alias Type(alias Param) = Param.Type;
    alias Types = staticMap!(Type, P);

    // If one or more of the parameters is const/immutable,
    // it'll be hard to construct it as such, so we Unqual
    // the types for construction and cast to the appropriate
    // type when returning.
    alias MutableTuple = Tuple!(staticMap!(Unqual, Types));
    alias RetTuple = Tuple!(Types);

    MutableTuple dArgs;

    void positional(size_t i, T)() {
        auto item = PyTuple_GetItem(args, i);

        static if(__traits(compiles, checkPythonType!T(item))) {
            if(!checkPythonType!T(item)) {
                import python.raw: PyErr_Clear;
                PyErr_Clear;
                throw new ArgumentConversionException("Can't convert to " ~ T.stringof);
            }
        } else {
            version(PynihCheckType) {
                pragma(msg, "WARNING: cannot check python type for `", T, "`");
                // uncomment to see the compilation error
                // checkPythonType!T(item);
            }
        }

        dArgs[i] = item.to!T;
    }

    int pythonArgIndex = 0;
    static foreach(i; 0 .. P.length) {

        static if(i == P.length - 1 && isVariadic) {  // last parameter and it's a typesafe variadic one
            // slice the remaining arguments
            auto remainingArgs = PyTuple_GetSlice(args, i, PyTuple_Size(args));
            dArgs[i] = remainingArgs.to!(P[i].Type);
        } else static if(is(P[i].Default == void)) {
            // ith parameter is required
            enforce(i < argsLength,
                    text(__FUNCTION__, ": not enough Python arguments"));
            positional!(i, typeof(dArgs[i]));
        } else {

            if(i < argsLength) {  // regular case
                positional!(i, P[i].Type);
            } else {
                // Here it gets tricky. The user could have supplied it in
                // args positionally or via kwargs
                auto key = pyUnicodeDecodeUTF8(&P[i].identifier[0],
                                               P[i].identifier.length,
                                               null /*errors*/);
                enforce(key, "Errors converting '" ~ P[i].identifier ~ "' to Python object");
                auto val = kwargs ? PyDict_GetItem(kwargs, key) : null;
                dArgs[i] = val
                    ? val.to!(P[i].Type) // use kwargs
                    : P[i].Default; // use default value
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
        return noThrowable!(callDlangFunction!(T, F))(self, args, kwargs);
    }
}


private void mutateSelf(T)(PyObject* self, auto ref T dAggregate) {

    import python.conv.d_to_python: toPython;
    import python.raw: pyDecRef;

    auto newSelf = self is null ? self : toPython(dAggregate);
    scope(exit) {
        if(self !is null) pyDecRef(newSelf);
    }
    auto pyClassSelf = cast(PythonClass!T*) self;
    auto pyClassNewSelf = cast(PythonClass!T*) newSelf;

    static foreach(i; 0 .. PythonClass!T.fieldNames.length) {
        if(self !is null)
            pyClassSelf._set_impl!i(self, pyClassNewSelf._get_impl!i(newSelf));
    }

}


/**
   The C API implementation that calls a D function F.
 */
struct PythonFunction(alias F) {
    static extern(C) PyObject* _py_function_impl(PyObject* self, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!(callDlangFunction!(void, F))(self, args, kwargs);
    }
}


auto noThrowable(alias F, A...)(auto ref A args) {
    import python.raw: PyErr_SetString, PyExc_RuntimeError;
    import std.string: toStringz;
    import std.traits: ReturnType;

    try {
        return F(args);
    } catch(Exception e) {
        PyErr_SetString(PyExc_RuntimeError, e.msg.toStringz);
        return ReturnType!F.init;
    } catch(Error e) {
        import std.conv: text;
        try
            PyErr_SetString(PyExc_RuntimeError, ("FATAL ERROR: " ~ e.text).toStringz);
        catch(Exception _)
            PyErr_SetString(PyExc_RuntimeError, ("FATAL ERROR: " ~ e.msg).toStringz);

        return ReturnType!F.init;
    }
}


class ArgsException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

private PyObject* callDlangFunction(T, alias F)(PyObject* self, PyObject* args, PyObject *kwargs) {

    import python.raw: PyTuple_Size;
    import python.conv: toPython, to;
    import mirror.meta.traits: Parameters, NumDefaultParameters, NumRequiredParameters;
    import std.traits: variadicFunctionStyle, Variadic,
        moduleName, isCallable, StdParameters = Parameters;
    import std.conv: text;
    import std.exception: enforce;
    import std.meta: AliasSeq;

    enum identifier = __traits(identifier, F);
    enum isCtor = isUserAggregate!T && identifier == "__ctor";
    enum isMethod = isUserAggregate!T && identifier != "__ctor";

    static if(is(T == void)) { // regular function
        enum parent = moduleName!F;
        mixin(`static import `, parent, `;`);
        mixin(`alias Parent = `, parent, `;`);
    } else static if(isMethod) {
        enum parent =  "dAggregate";
        alias Parent = T;
    } else static if(isCallable!T) {
        // nothing to do here
    } else static if(isCtor) {
        alias Parent = T;
    } else
        static assert(false, __FUNCTION__ ~ " does not know how to handle " ~ T.stringof);

    static if(is(T == void))
        enum callMixin = `auto ret = callDlangFunction!F(dArgs);`;
    else static if(isMethod)
        enum callMixin = `auto ret = callDlangFunction!((StdParameters!overload dArgs) => ` ~ parent ~ `.` ~ identifier ~ `(dArgs))(dArgs);`;
    else static if(isCtor) {
        static if(is(T == class))
            enum callMixin = `auto ret = callDlangFunction!((StdParameters!overload dArgs) => new T(dArgs))(dArgs);`;
        else
            enum callMixin = `auto ret = callDlangFunction!((StdParameters!overload dArgs) => T(dArgs))(dArgs);`;
    } else static if(isCallable!T && !isUserAggregate!T)
        enum callMixin = `auto ret = callDlangFunction!F(dArgs);`;
    else
        static assert(false);

    static if(__traits(compiles, __traits(getOverloads, Parent, identifier))) {
        alias candidates = __traits(getOverloads, Parent, identifier);
        // Deal with possible template instantiation functions.
        // If it's a free function (T is void), then there must be at least
        // one overload. The only reason for there to not be one is because
        // it's a function template.
        static if(is(T == void) && candidates.length == 0)
            alias overloads = AliasSeq!F;
        else
            alias overloads = candidates;
    } else
        alias overloads = AliasSeq!F;

    static foreach(overload; overloads) {{
        enum numDefaults = NumDefaultParameters!overload;
        enum numRequired = NumRequiredParameters!overload;
        enum isVariadic = variadicFunctionStyle!overload == Variadic.typesafe;
        enum isMemberFunction = !__traits(isStaticFunction, overload) && !is(T == void);

        static if(isUserAggregate!T && isMemberFunction && !isCtor)
            assert(self !is null,
                   "Cannot call PythonMethod!" ~ identifier ~ " on null self");

        alias Aggregate = QualifiedType!(T, overload);

        static if(isUserAggregate!T) { // member function, static or not
            // The reason we alias this here is because Aggregate could be a value
            // type but self.to!Aggregate could return a pointer when the struct
            // is not copiable.
            alias typeofConversion = typeof(self.to!Aggregate);
            // self could be null for static member functions
            auto dAggregate = self is null ? typeofConversion.init : self.to!Aggregate;
        }

        try {
            const numArgs = args is null ? 0 : PyTuple_Size(args);
            if(!isVariadic)
                enforce!ArgumentConversionException(
                    numArgs >= numRequired
                    && numArgs <= Parameters!overload.length,
                    text("Received ", numArgs, " parameters but ",
                         identifier, " takes ", Parameters!overload.length));

            auto dArgs = pythonArgsToDArgs!(isVariadic, Parameters!overload)(args, kwargs);

            void testCallMixin()() {
                mixin(callMixin);
            }

            static if(is(typeof(testCallMixin!()))) {

                mixin(callMixin);

                static if(isUserAggregate!T && isMemberFunction && !isConstMemberFunction!overload) {
                    mutateSelf(self, dAggregate);
                }

                return ret;
            } else
                throw new Exception("Cannot call function since `" ~ callMixin ~ "` does not compile");

        } catch(ArgumentConversionException _) {
            // only using this to weed out incompatible overloads
        }
    }}

    throw new Exception("Could not find suitable overload for `" ~ identifier ~ "`");
}


private template QualifiedType(T, alias overload) {

    import std.traits: functionAttributes, FunctionAttribute;

    static if(functionAttributes!overload & FunctionAttribute.const_)
        alias QualifiedType = const T;
    else static if(functionAttributes!overload & FunctionAttribute.immutable_)
        alias QualifiedType = immutable T;
    else static if(functionAttributes!overload & FunctionAttribute.shared_)
        alias QualifiedType = shared T;
    else
        alias QualifiedType = Unqual!T;
}


class ArgumentConversionException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}


private PyObject* callDlangFunction(alias F, A)(auto ref A argTuple) {
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


/**
   Creates an instance of a Python class that is equivalent to the D type `T`.
   Return PyObject*.
 */
PyObject* pythonClass(T)(auto ref T dobj) {

    import python.conv: toPython;
    import python.raw: pyObjectNew;
    import std.traits: isPointer, PointerTarget;

    static if(is(T == class) || isPointer!T) {
        if(dobj is null)
            throw new Exception("Cannot create Python class from null D object");
    }

    static if(isPointer!T)
        alias Type = PointerTarget!T;
    else
        alias Type = T;

    auto _type = PythonType!Type.pyType;

    auto ret = pyObjectNew!(PythonClass!Type)(PythonType!Type.pyType);

    static foreach(fieldName; PythonType!Type.fieldNames) {
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
   OOP types register factory functions here, indexed by the fully qualified
   name of the type. This allows us to construct D class types from the
   runtime types of Python values.
 */
Object delegate(PyObject*)[string] gFactory;

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
struct PythonClass(T) {//}if(isUserAggregate!T) {
    import python.raw: PyObjectHead, PyGetSetDef;
    import std.traits: Unqual;

    alias fieldNames = PythonType!(Unqual!T).fieldNames;
    alias fieldTypes = PythonType!(Unqual!T).fieldTypes;

    // Every python object must have this
    mixin PyObjectHead;

    // Field members
    // Generate a python object field for every field in T
    static foreach(fieldName; fieldNames) {
        mixin(`PyObject* `, fieldName, `;`);
    }

    static if(is(T == class)) {
        static this() {
            import std.traits: fullyQualifiedName;

            gFactory[fullyQualifiedName!(Unqual!T)] = (PyObject* value) {
                import python.conv.python_to_d: to;

                auto pyclass = cast(PythonClass!T*) value;
                auto ret = userAggregateInit!(Unqual!T);

                static foreach(fieldName; fieldNames) {{
                    alias Field = typeof(__traits(getMember, ret, fieldName));
                    // The reason we can't just assign to the field here is that the field
                    // might be const or immutable.
                    auto fieldPtr = cast(Unqual!Field*) &__traits(getMember, ret, fieldName);
                    *fieldPtr = __traits(getMember, pyclass, fieldName).to!Field;
                }}

                return cast(Object) ret;
            };
        }
    }

    // The function pointer for PyGetSetDef.get
    private static extern(C) PyObject* _get_impl(int FieldIndex)
                                                (PyObject* self_, void* closure = null)
        nothrow
        in(self_ !is null)
    {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass*) self_;

        auto impl() {
            auto field = self.getField!FieldIndex;
            assert(field !is null, "Cannot increase reference count on null field");
            pyIncRef(field);

            return field;
        }

        return noThrowable!impl;
    }

    // The function pointer for PyGetSetDef.set
    static extern(C) int _set_impl(int FieldIndex)
                                  (PyObject* self_, PyObject* value, void* closure = null)
        nothrow
        in(self_ !is null)
    {
        import python.raw: pyIncRef, pyDecRef, PyErr_SetString, PyExc_TypeError;

        if(value is null) {
            enum deleteErrStr = "Cannot delete " ~ fieldNames[FieldIndex];
            PyErr_SetString(PyExc_TypeError, deleteErrStr);
            return -1;
        }

        static if(__traits(compiles, checkPythonType!(fieldTypes[FieldIndex])(value))) {
            if(!checkPythonType!(fieldTypes[FieldIndex])(value)) {
                return -1;
            }
        } else {
            version(PynihCheckType) {
                pragma(msg, "WARNING: cannot check python type for field #", FieldIndex, " of ", T);
                // uncomment below to see compilation failure
                // checkPythonType!(fieldTypes[FieldIndex])(value);
            }
        }

        auto impl() {
            auto self = cast(PythonClass!T*) self_;
            auto tmp = self.getField!FieldIndex;

            pyIncRef(value);
            mixin(`self.`, fieldNames[FieldIndex], ` = value;`);
            pyDecRef(tmp);

            return 0;
        }

        return noThrowable!impl;
    }

    PyObject* getField(int FieldIndex)() {

        import autowrap.common: AlwaysTry;

        auto impl()() {
            mixin(`return this.`, fieldNames[FieldIndex], `;`);
        }

        static if(AlwaysTry || __traits(compiles, impl!()()))
            return impl;
        else {
            import std.traits: fullyQualifiedName;
            import std.conv: text;

            enum msg = text("cannot implement ", fullyQualifiedName!T, ".getField!", FieldIndex);
            pragma(msg, "WARNING: ", msg);
            throw new Exception(msg);
        }
    }

    static extern(C) PyObject* propertyGet(alias F)
                                          (PyObject* self_, void* closure = null)
        nothrow
        in(self_ !is null)
    {
        return PythonMethod!(T, F)._py_method_impl(self_, null /*args*/, null /*kwargs*/);
    }

    static extern(C) int propertySet(alias F)
                                    (PyObject* self_, PyObject* value, void* closure = null)
        nothrow
        in(self_ !is null)
    {
        import python.raw: PyTuple_New, PyTuple_SetItem, pyDecRef;

        auto args = PyTuple_New(1);
        PyTuple_SetItem(args, 0, value);
        scope(exit) pyDecRef(args);

        PythonMethod!(T, F)._py_method_impl(self_, args, null /*kwargs*/);

        return 0;
    }
}


PyObject* pythonCallable(T)(T callable) {
    import python.raw: pyObjectNew;

    auto ret = pyObjectNew!(PythonCallable!T)(PythonType!T.pyType);
    ret._callable = callable;

    return cast(PyObject*) ret;
}


private struct PythonCallable(T) if(isCallable!T) {

    import std.traits: hasMember;

    static if(hasMember!(T, "opCall")) {
        private static extern(C) PyObject* _py_call(PyObject* self, PyObject* args, PyObject* kwargs) nothrow {
            return PythonMethod!(T, T.opCall)._py_method_impl(self, args, kwargs);
        }
    } else {
        /**
           Reserves space for a callable to be stored in a PyObject struct so that it
           can later be called.
        */

        import python.raw: PyObjectHead;

        // Every python object must have this
        mixin PyObjectHead;

        private T _callable;

        private static extern(C) PyObject* _py_call(PyObject* self_, PyObject* args, PyObject* kwargs)
            nothrow
            in(self_ !is null)
            do
        {
            import std.traits: Parameters, ReturnType;
            auto self = cast(PythonCallable!T*) self_;
            assert(self._callable !is null, "Cannot have null callable");
            return noThrowable!(callDlangFunction!(T, (Parameters!T args) => self._callable(args)))(self_, args, kwargs);
        }
    }
}

private bool isConstMemberFunction(alias F)() {
    import std.traits: functionAttributes, FunctionAttribute;
    return cast(bool) (functionAttributes!F & FunctionAttribute.const_);
}


private template PythonUnaryOperator(T, string op) {
    static extern(C) PyObject* _py_un_op(PyObject* self) nothrow {
        return noThrowable!({
            import python.conv.python_to_d: to;
            import python.conv.d_to_python: toPython;
            import std.traits: Parameters;

            static assert(Parameters!(T.opUnary!op).length == 0, "opUnary can't take any parameters");

            return self.to!T.opUnary!op.toPython;
        });
    }
}


private template PythonBinaryOperator(T, BinaryOperator operator) {

    static extern(C) int _py_in_func(PyObject* lhs, PyObject* rhs)
        nothrow
        in(operator.op == "in")
    {
        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import std.traits: Parameters, hasMember;

        alias inParams(U) = Parameters!(U.opBinaryRight!(operator.op));

        static if(__traits(compiles, inParams!T))
            alias parameters = inParams!T;
        else
            alias parameters = void;

        static if(is(typeof(T.init.opBinaryRight!(operator.op)(parameters.init)): bool)) {
            return noThrowable!({

                static assert(parameters.length == 1, "opBinaryRight!in must have one parameter");
                alias Arg = parameters[0];

                auto this_ = lhs.to!T;
                auto dArg  = rhs.to!Arg;

                const ret = this_.opBinaryRight!(operator.op)(dArg);
                // See https://docs.python.org/3/c-api/sequence.html#c.PySequence_Contains
                return ret ? 1 : 0;
            });
        } else {
            // Error. See https://docs.python.org/3/c-api/sequence.html#c.PySequence_Contains
            return -1;
        }
    }

    static extern(C) PyObject* _py_bin_func(PyObject* lhs, PyObject* rhs) nothrow {
        return _py_ter_func(lhs, rhs, null);
    }

    // Should only be for `^^` because in Python the function is ternary
    static extern(C) PyObject* _py_ter_func(PyObject* lhs_, PyObject* rhs_, PyObject* extra) nothrow {
        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import mirror.meta.traits: BinOpDir, functionName;
        import std.traits: Parameters;
        import std.exception: enforce;
        import std.conv: text;

        return noThrowable!({

            PyObject* self, pArg;

            if(lhs_.isInstanceOf!T) {
                self = lhs_;
                pArg = rhs_;
            } else if(rhs_.isInstanceOf!T) {
                self = rhs_;
                pArg = lhs_;
            } else
                throw new Exception("Neither lhs or rhs were of type " ~ T.stringof);

            PyObject* impl(BinOpDir dir)() {

                enum funcName = functionName(dir);

                static if(operator.dirs & dir) {
                    mixin(`alias parameters = Parameters!(T.init.`, funcName, `!(operator.op));`);
                    static assert(parameters.length == 1, "Binary operators must take one parameter");
                    alias Arg = parameters[0];

                    auto this_ = self.to!T;
                    auto dArg  = pArg.to!Arg;
                    mixin(`return this_.`, funcName, `!(operator.op)(dArg).toPython;`);
                } else
                    throw new Exception(text(T.stringof, " does not support ", funcName, " with self on ", dir));
            }

            if(lhs_.isInstanceOf!T)   // self is on the left hand side
                return impl!(BinOpDir.left);
            else if(rhs_.isInstanceOf!T)   // self is on the right hand side
                return impl!(BinOpDir.right);
            else
                throw new Exception("Neither lhs or rhs were of type " ~ T.stringof);
        });
    }
}

private template PythonAssignOperator(T, string op) {

    static extern(C) PyObject* _py_bin_func(PyObject* lhs, PyObject* rhs) nothrow {
        return _py_ter_func(lhs, rhs, null);
    }

    // Should only be for `^^` because in Python the function is ternary
    static extern(C) PyObject* _py_ter_func(PyObject* lhs, PyObject* rhs, PyObject* extra) nothrow {
        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import std.traits: Parameters;

        PyObject* impl() {
            alias parameters = Parameters!(T.init.opOpAssign!op);
            static assert(parameters.length == 1, "Assignment operators must take one parameter");

            auto dObj = lhs.to!T;
            dObj.opOpAssign!op(rhs.to!(parameters[0]));
            return dObj.toPython;
        }

        return noThrowable!impl;
    }
}


// implements _py_cmp for types with opCmp
private template PythonOpCmp(T) {
    static extern(C) PyObject* _py_cmp(PyObject* lhs, PyObject* rhs, int opId) nothrow {
        import python.raw: Py_LT, Py_LE, Py_EQ, Py_NE, Py_GT, Py_GE;
        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import std.conv: text;
        import std.traits: Unqual, Parameters;

        return noThrowable!({

            alias parameters = Parameters!(T.opCmp);
            static assert(parameters.length == 1, T.stringof ~ ".opCmp must have exactly one parameter");

            const cmp = lhs.to!(Unqual!T).opCmp(rhs.to!(Unqual!(parameters[0])));

            const dRes = {
                switch(opId) {
                    default: throw new Exception(text("Unknown opId for opCmp: ", opId));
                    case Py_LT: return cmp < 0;
                    case Py_LE: return cmp <= 0;
                    case Py_EQ: return cmp == 0;
                    case Py_NE: return cmp !=0;
                    case Py_GT: return cmp > 0;
                    case Py_GE: return cmp >=0;
                }
            }();

            return dRes.toPython;
       });
    }
}


private template PythonSubscript(T) {

    static extern(C) PyObject* _py_index(PyObject* self, PyObject* key) nothrow {
        import python.raw: pyIndexCheck, pySliceCheck, PyObject_Repr, PyObject_Length,
            Py_ssize_t, PySlice_GetIndices;
        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import std.traits: Parameters, Unqual, hasMember, fullyQualifiedName;
        import std.meta: Filter, AliasSeq;

        PyObject* impl() {
            static if(!hasMember!(T, "opIndex") && !hasMember!(T, "opSlice")) {
                throw new Exception(fullyQualifiedName!T ~ " has no opIndex or opSlice");
            } else {
                if(pyIndexCheck(key)) {
                    static if(__traits(compiles, Parameters!(T.opIndex))) {
                        alias parameters = Parameters!(T.opIndex);
                        static if(parameters.length == 1)
                            return self.to!(Unqual!T).opIndex(key.to!(parameters[0])).toPython;
                        else
                            throw new Exception("Don't know how to handle opIndex with more than one parameter");
                    }
                } else if(pySliceCheck(key)) {

                    enum hasTwoParams(alias F) = Parameters!F.length == 2;

                    static if(!hasMember!(T, "opSlice")) {
                        throw new Exception(fullyQualifiedName!T ~ " has no opSlice");
                    } else {

                        alias twoParamOpSlices = Filter!(hasTwoParams, __traits(getOverloads, T, "opSlice"));

                        static if(twoParamOpSlices.length > 0) {

                            static assert(twoParamOpSlices.length == 1);
                            alias opSlice = twoParamOpSlices[0];

                            const len = PyObject_Length(self);
                            Py_ssize_t start, stop, step;
                            const indicesRet = PySlice_GetIndices(key, len, &start, &stop, &step);

                            if(indicesRet < 0)
                                throw new Exception("Could not get slice indices for key '" ~ PyObject_Repr(key).to!string ~ "'");

                            if(step != 1)
                                throw new Exception("Slice steps other than 1 not supported in D: " ~ PyObject_Repr(key).to!string);

                            auto dObj = self.to!T;
                            return dObj[start .. stop].toPython;

                        } else {
                            throw new Exception(T.stringof ~ " cannot be sliced by " ~ PyObject_Repr(key).to!string);
                        }

                        assert(0, "Error in slicing " ~ T.stringof ~ " with " ~ PyObject_Repr(key).to!string);
                    }
                } else
                    throw new Exception(T.stringof ~ " failed pyIndexCheck and pySliceCheck for key '" ~ PyObject_Repr(key).to!string ~ "'");
                assert(0);
            }
        }

        return noThrowable!impl;
    }
}


/**
   Implement a Python iterator for D type T.
   We get a D slice from it, convert it to a Python list,
   then return its iterator.
 */
private template PythonIterViaList(T) {

    static extern(C) PyObject* _py_iter(PyObject* self) nothrow {
        import python.raw: PyObject_GetIter;
        import python.conv.d_to_python: toPython;
        import python.conv.python_to_d: to;
        import std.array: array;
        import std.traits: fullyQualifiedName;

        PyObject* impl() {
            static if(__traits(compiles, T.init[].array[0])) {
                auto dObj = self.to!T;
                auto list = dObj[].array.toPython;
                return PyObject_GetIter(list);
            } else {
                throw new Exception("Cannot get an array from " ~ fullyQualifiedName!T ~ "[]");
            }
        }

        return noThrowable!impl;
    }
}


/**
   Implement a Python iterator based on a D range.
 */
private template PythonIter(T) if(isInputRange!T)
{
    static extern(C) PyObject* _py_iter(PyObject* self) nothrow {
        return self;
    }

    static extern(C) PyObject* _py_iter_next(PyObject* self) nothrow {
        import python.raw: PyErr_SetNone, PyExc_StopIteration;
        import python.conv: to, toPython;

        auto impl() {
            auto dObj = self.to!T;

            if(dObj.empty) {
                PyErr_SetNone(PyExc_StopIteration);
                return null;
            }

            dObj.popFront;
            auto newSelf = dObj.toPython;
            *self = *newSelf;
            auto ret = dObj.front.toPython;
            return ret;
        }

        return noThrowable!impl;
    }
}


private template PythonIndexAssign(T) {

    static extern(C) int _py_index_assign(PyObject* self, PyObject* key, PyObject* val) nothrow {

        import python.conv.python_to_d: to;
        import python.conv.d_to_python: toPython;
        import python.raw: pyIndexCheck, pySliceCheck, PyObject_Repr, PyObject_Length, PySlice_GetIndices, Py_ssize_t;
        import std.traits: Parameters, Unqual;
        import std.conv: to;
        import std.meta: Filter, AliasSeq;

        int impl() {
            if(pyIndexCheck(key)) {
                static if(__traits(compiles, Parameters!(T.opIndexAssign))) {
                    alias parameters = Parameters!(T.opIndexAssign);
                    static if(parameters.length == 2) {
                        auto dObj = self.to!(Unqual!T);
                        dObj.opIndexAssign(val.to!(parameters[0]), key.to!(parameters[1]));
                        mutateSelf(self, dObj);
                        return 0;
                    } else
                        //throw new Exception("Don't know how to handle opIndex with more than one parameter");
                        return -1;
                } else
                    return -1;
            } else if(pySliceCheck(key)) {

                enum hasThreeParams(alias F) = Parameters!F.length == 3;
                alias threeParamOps = Filter!(hasThreeParams,
                                              AliasSeq!(
                                                  __traits(getOverloads, T, "opIndexAssign"),
                                                  __traits(getOverloads, T, "opSliceAssign"),
                                              )
                );

                static if(threeParamOps.length > 0) {

                    static assert(threeParamOps.length == 1);
                    alias opIndexAssign = threeParamOps[0];
                    alias parameters = Parameters!opIndexAssign;

                    const len = PyObject_Length(self);
                    Py_ssize_t start, stop, step;
                    const indicesRet = PySlice_GetIndices(key, len, &start, &stop, &step);

                    if(indicesRet < 0)
                        return -1;

                    if(step != 1)
                        return -1;

                    auto dObj = self.to!(Unqual!T);
                    mixin(`dObj.`, __traits(identifier, opIndexAssign), `(val.to!(parameters[0]), start, stop);`);
                    mutateSelf(self, dObj);
                    return 0;
                } else {
                    return -1;
                }
            } else
                return -1;
        }

        return noThrowable!impl;
    }
}


// implements _py_cmp for types without opCmp
private template PythonCompare(T) {

    static extern(C) PyObject* _py_cmp(PyObject* self, PyObject* other, int op) nothrow {

        PyObject* impl() {
            import python.conv.python_to_d: to;
            import python.conv.d_to_python: toPython;
            import python.raw: pyIncRef, _Py_NotImplementedStruct, Py_EQ, Py_LT, Py_LE, Py_NE, Py_GT, Py_GE;

            static notImplemented() {
                auto pyNotImplemented = cast(PyObject*) &_Py_NotImplementedStruct;
                pyIncRef(pyNotImplemented);
                return pyNotImplemented;
            }

            if(!other.isInstanceOf!T) return notImplemented;

            // See https://github.com/symmetryinvestments/autowrap/issues/279
            static if(is(T == class) || is(T == interface))
                T _init;
            else
                static T _init() { return T.init; }

            static if(is(typeof(_init < _init) == bool))
                if(op == Py_LT)
                    return (self.to!T < other.to!T).toPython;

            static if(is(typeof(_init <= _init) == bool))
                if(op == Py_LE)
                    return (self.to!T <= other.to!T).toPython;

            static if(is(typeof(_init == _init) == bool))
                if(op == Py_EQ)
                    return (self.to!T == other.to!T).toPython;

            static if(is(typeof(_init != _init) == bool))
                if(op == Py_NE)
                    return (self.to!T != other.to!T).toPython;

            static if(is(typeof(_init > _init) == bool))
                if(op == Py_GT)
                    return (self.to!T > other.to!T).toPython;

            static if(is(typeof(_init >= _init) == bool))
                if(op == Py_GE)
                    return (self.to!T >= other.to!T).toPython;

            return notImplemented;
        }

        return noThrowable!impl;
    }
}


private bool isInstanceOf(T)(PyObject* obj) {
    import python.raw: PyObject_IsInstance;
    return cast(bool) PyObject_IsInstance(obj, cast(PyObject*) PythonType!T.pyType);
}


private bool checkPythonType(T)(PyObject* value) if(isArray!T) {
    import python.raw: pySequenceCheck;
    const ret = pySequenceCheck(value);
    if(!ret) setPyErrTypeString!"sequence";
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


private bool checkPythonType(T)(PyObject* value) if(isAssociativeArray!T) {
    import python.raw: pyMappingCheck;
    const ret = pyMappingCheck(value);
    if(!ret) setPyErrTypeString!"dict";
    return ret;
}


private bool checkPythonType(T)(PyObject* value) if(isUserAggregate!T) {
    return true;  // FIXMME
}


private bool checkPythonType(T)(PyObject* value) if(isSomeFunction!T) {
    import python.raw: pyCallableCheck;
    const ret = pyCallableCheck(value);
    if(!ret) setPyErrTypeString!"callable";
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
