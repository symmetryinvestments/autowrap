/**
   A D API for dealing with Python's PyTypeObject
 */
module python.type;


import autowrap.reflection: isParameter, BinaryOperator;
import python.raw: PyObject;
import std.traits: Unqual, isArray, isIntegral, isBoolean, isFloatingPoint,
    isAggregateType, isCallable, isAssociativeArray, isSomeFunction;
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
    import python.raw: PyTypeObject, PySequenceMethods, PyMappingMethods;
    import std.traits: FieldNameTuple, Fields;
    import std.meta: Alias, staticMap;

    alias fieldNames = FieldNameTuple!T;
    alias fieldTypes = Fields!T;
    enum hasLength = is(typeof({ size_t len = T.init.length; }));

    static PyTypeObject _pyType;
    static bool failedToReady;

    static PyObject* pyObject() {
        initialise;
        return failedToReady ? null : cast(PyObject*) &_pyType;
    }

    static PyTypeObject* pyType() nothrow {
        initialise;
        return failedToReady ? null : &_pyType;
    }

    private static void initialise() nothrow {
        import python.raw: PyType_GenericNew, PyType_Ready, TypeFlags,
            PyErr_SetString, PyExc_TypeError,
            PyNumberMethods, PySequenceMethods;
        import autowrap.reflection: UnaryOperators, BinaryOperators, AssignOperators, functionName;
        import std.traits: arity, hasMember, TemplateOf;
        import std.meta: Filter;
        static import std.typecons;

        if(_pyType != _pyType.init) return;

        _pyType.tp_name = T.stringof;
        _pyType.tp_flags = TypeFlags.Default;

        // FIXME: types are that user aggregates *and* callables
        static if(isUserAggregate!T) {
            _pyType.tp_basicsize = PythonClass!T.sizeof;
            _pyType.tp_getset = getsetDefs;
            _pyType.tp_methods = methodDefs;
            _pyType.tp_new = &_py_new;
            _pyType.tp_repr = &_py_repr;
            _pyType.tp_init = &_py_init;

            // special-case std.typecons.Typedef
            // see: https://issues.dlang.org/show_bug.cgi?id=20117
            static if(
                hasMember!(T, "opCmp")
                && !__traits(isSame, TemplateOf!T, std.typecons.Typedef)
                && &T.opCmp !is &Object.opCmp
                )
            {
                _pyType.tp_richcompare = &PythonOpCmp!T._py_cmp;
            }

            static if(hasMember!(T, "opSlice")) {
                _pyType.tp_iter = &PythonIter!T._py_iter;
            }

            // In Python, both D's opIndex and opSlice are dealt with by one function,
            // in opSlice's case when the type is indexed by a Python slice
            static if(hasMember!(T, "opIndex") || hasMember!(T, "opSlice")) {
                if(_pyType.tp_as_mapping is null)
                    _pyType.tp_as_mapping = new PyMappingMethods;
                _pyType.tp_as_mapping.mp_subscript = &PythonSubscript!T._py_index;
            }

            static if(hasMember!(T, "opIndexAssign")) {
                if(_pyType.tp_as_mapping is null)
                    _pyType.tp_as_mapping = new PyMappingMethods;

                _pyType.tp_as_mapping.mp_ass_subscript = &PythonIndexAssign!T._py_index_assign;
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

        } else static if(isCallable!T) {
            _pyType.tp_basicsize = PythonCallable!T.sizeof;
            _pyType.tp_call = &PythonCallable!T._py_call;
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

    static if(isUserAggregate!T)
    private static auto getsetDefs() {
        import autowrap.reflection: Properties;
        import python.raw: PyGetSetDef;
        import std.meta: staticMap, Filter, Alias;
        import std.traits: isFunction, ReturnType;

        alias AggMember(string memberName) = Alias!(__traits(getMember, T, memberName));
        alias memberNames = __traits(allMembers, T);
        enum isPublic(string memberName) =
            __traits(getProtection, __traits(getMember, T, memberName)) == "public";
        alias publicMemberNames = Filter!(isPublic, memberNames);
        alias members = staticMap!(AggMember, publicMemberNames);
        alias memberFunctions = Filter!(isFunction, members);
        alias properties = Properties!memberFunctions;

        // +1 due to the sentinel
        static PyGetSetDef[fieldNames.length + properties.length + 1] getsets;

        // don't bother if already initialised
        if(getsets != getsets.init) return &getsets[0];

        // first deal with the public fields
        static foreach(i; 0 .. fieldNames.length) {
            getsets[i].name = cast(typeof(PyGetSetDef.name)) fieldNames[i];
            static if(__traits(getProtection, __traits(getMember, T, fieldNames[i])) == "public") {
                getsets[i].get = &PythonClass!T.get!i;
                getsets[i].set = &PythonClass!T.set!i;
            }
        }

        // then deal with the property functions
        static foreach(j, property; properties) {{
            enum i = fieldNames.length + j;

            getsets[i].name = cast(typeof(PyGetSetDef.name)) __traits(identifier, property);

            static foreach(overload; __traits(getOverloads, T, __traits(identifier, property))) {
                static if(is(ReturnType!overload == void))
                    getsets[i].set = &PythonClass!T.propertySet!(overload);
                else
                    getsets[i].get = &PythonClass!T.propertyGet!(overload);
            }
        }}

        return &getsets[0];
    }

    private static auto methodDefs()() {
        import autowrap.reflection: isProperty;
        import python.raw: PyMethodDef, MethodArgs;
        import python.cooked: pyMethodDef, defaultMethodFlags;
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
            && name != "__ctor"
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

            methods[i] = pyMethodDef!(__traits(identifier, memberFunction), flags)
                                     (&PythonMethod!(T, memberFunction)._py_method_impl);
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

            assert(self_ !is null);
            auto ret = text(self_.to!T);
            return pyUnicodeDecodeUTF8(ret.ptr, ret.length, null /*errors*/);
        });
    }

    private static extern(C) int _py_init(PyObject* self_, PyObject* args, PyObject* kwargs) nothrow {
        // nothing to do
        return 0;
    }

    static if(isUserAggregate!T)
    private static extern(C) PyObject* _py_new(PyTypeObject *type, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!({
            import autowrap.reflection: FunctionParameters, Parameter;
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
                return pythonConstructor!(T, false /*is variadic*/, parameters)(args, kwargs);
            } else {
                import autowrap.reflection: NumRequiredParameters;
                import python.raw: PyErr_SetString, PyExc_TypeError;
                import std.traits: Parameters, variadicFunctionStyle, Variadic;

                static foreach(constructor; constructors) {{

                    enum isVariadic = variadicFunctionStyle!constructor == Variadic.typesafe;

                    if(Parameters!constructor.length == numArgs) {
                        return pythonConstructor!(T, isVariadic, FunctionParameters!constructor)(args, kwargs);
                    } else if(numArgs >= NumRequiredParameters!constructor
                              && numArgs <= Parameters!constructor.length)
                    {
                        return pythonConstructor!(T, isVariadic, FunctionParameters!constructor)(args, kwargs);
                    }
                }}

                PyErr_SetString(PyExc_TypeError, "Could not find a suitable constructor");
                return null;
            }

        });
    }

    // Creates a python object from the given arguments by converting them to D
    // types, calling the D constructor and converting the result to a Python
    // object.
    static if(isUserAggregate!T)
    private static auto pythonConstructor(T, bool isVariadic, P...)(PyObject* args, PyObject* kwargs) {
        import python.conv: toPython;
        import std.traits: hasMember;

        auto dArgs = pythonArgsToDArgs!(isVariadic, P)(args, kwargs);

        static if(is(T == class)) {
            static if(hasMember!(T, "__ctor")) {
                // When immutable dmd prints an odd error message about not being
                // able to modify dobj
                static if(is(T == immutable))
                    auto dobj = new T(dArgs.expand);
                else
                    scope dobj = new T(dArgs.expand);
            } else
                T dobj;
        } else
            auto dobj = T(dArgs.expand);

        return toPython(dobj);
    }
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
        "/=":  "tp_as_number.nb_inplace_divide",
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
        "/":  "tp_as_number.nb_inplace_divide",
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


private auto pythonArgsToDArgs(bool isVariadic, P...)(PyObject* args, PyObject* kwargs)
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
        if(!checkPythonType!T(item)) {
            import python.raw: PyErr_Clear;
            PyErr_Clear;
            throw new ArgumentConversionException("Can't convert to " ~ T.stringof);
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
        return noThrowable!(callDlangFunctionNew!(T, F))(self, args, kwargs);
    }
}


private void mutateSelf(T)(PyObject* self, auto ref T dAggregate) {

    import python.conv.d_to_python: toPython;
    import python.raw: pyDecRef;

    auto newSelf = {
        return self is null ? self : toPython(dAggregate);
    }();
    scope(exit) {
        if(self !is null) pyDecRef(newSelf);
    }
    auto pyClassSelf = cast(PythonClass!T*) self;
    auto pyClassNewSelf = cast(PythonClass!T*) newSelf;

    static foreach(i; 0 .. PythonClass!T.fieldNames.length) {
        if(self !is null)
            pyClassSelf.set!i(self, pyClassNewSelf.get!i(newSelf));
    }

}


/**
   The C API implementation that calls a D function F.
 */
struct PythonFunction(alias F) {
    static extern(C) PyObject* _py_function_impl(PyObject* self, PyObject* args, PyObject* kwargs) nothrow {
        return noThrowable!(callDlangFunctionNew!(void, F))(self, args, kwargs);
    }
}


private auto noThrowable(alias F, A...)(auto ref A args) {
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

// simple, regular version for functions
private auto callDlangFunctionOld(alias F)
                                 (PyObject* self, PyObject* args, PyObject* kwargs)
{
    return callDlangFunctionOld!(F, F)(self, args, kwargs);
}

// Takes two functions due to how we're calling methods.
// One is the original function to reflect on, the other
// is the closure that's actually going to be called.
private PyObject* callDlangFunctionOld(alias callable, A...)
                                      (PyObject* self, PyObject* args, PyObject* kwargs)
    if(A.length == 1 && isCallable!(A[0]))
{
    import autowrap.reflection: FunctionParameters, NumDefaultParameters, NumRequiredParameters;
    import python.raw: PyTuple_Size;
    import python.conv: toPython;
    import std.traits: Parameters, variadicFunctionStyle, Variadic, ReturnType;
    import std.conv: text;
    import std.string: toStringz;
    import std.exception: enforce;
    import std.meta: AliasSeq, allSatisfy;

    alias originalFunction = A[0];

    enum numDefaults = NumDefaultParameters!originalFunction;
    enum numRequired = NumRequiredParameters!originalFunction;
    enum isVariadic = variadicFunctionStyle!originalFunction == Variadic.typesafe;

    static if(__traits(compiles, __traits(identifier, originalFunction)))
        enum identifier = __traits(identifier, originalFunction);
    else
        enum identifier = "anonymous";

    const numArgs = args is null ? 0 : PyTuple_Size(args);
    if(!isVariadic)
        enforce(numArgs >= numRequired
                && numArgs <= Parameters!originalFunction.length,
                text("Received ", numArgs, " parameters but ",
                     identifier, " takes ", Parameters!originalFunction.length));

    alias Overloads(alias F) = __traits(getOverloads, __traits(parent, F), identifier);
    static if(__traits(compiles, Overloads!originalFunction))
        alias overloads = __traits(getOverloads, __traits(parent, originalFunction), identifier);
    else
        alias overloads = AliasSeq!(callable);

    auto dArgs = pythonArgsToDArgs!(isVariadic, FunctionParameters!originalFunction)(args, kwargs);
    return callDlangFunction!callable(dArgs);
}

private PyObject* callDlangFunctionNew(T, alias F)(PyObject* self, PyObject* args, PyObject *kwargs) {

    import autowrap.reflection: FunctionParameters, NumDefaultParameters, NumRequiredParameters;
    import python.raw: PyTuple_Size;
    import python.conv: toPython, to;
    import std.traits: Parameters, variadicFunctionStyle, Variadic, ReturnType, functionAttributes, FunctionAttribute, moduleName;
    import std.conv: text;
    import std.exception: enforce;

    static if(is(T == void)) { // regular function
        enum parent = moduleName!F;
        mixin(`static import `, parent, `;`);
        mixin(`alias Parent = `, parent, `;`);
    } else {
        enum parent =  "dAggregate";
        alias Parent = T;
    }

    enum identifier = __traits(identifier, F);
    alias overloads = __traits(getOverloads, Parent, identifier);

    static foreach(overload; overloads) {{
        enum numDefaults = NumDefaultParameters!overload;
        enum numRequired = NumRequiredParameters!overload;
        enum isVariadic = variadicFunctionStyle!overload == Variadic.typesafe;
        enum isMemberFunction = !__traits(isStaticFunction, overload) && !is(T == void);

        static if(isMemberFunction)
            assert(self !is null,
                   "Cannot call PythonMethod!" ~ identifier ~ " on null self");

        static if(functionAttributes!overload & FunctionAttribute.const_)
            alias Aggregate = const T;
        else static if(functionAttributes!overload & FunctionAttribute.immutable_)
            alias Aggregate = immutable T;
        else
            alias Aggregate = Unqual!T;

        static if(!is(T == void)) { // member function, static or not
            // self could be null for static member functions
            auto dAggregate = self is null ? Aggregate.init : self.to!Aggregate;
        }

        try {
            const numArgs = args is null ? 0 : PyTuple_Size(args);
            if(!isVariadic)
                enforce!ArgumentConversionException(
                    numArgs >= numRequired
                    && numArgs <= Parameters!overload.length,
                    text("Received ", numArgs, " parameters but ",
                         identifier, " takes ", Parameters!overload.length));

            auto dArgs = pythonArgsToDArgs!(isVariadic, FunctionParameters!overload)(args, kwargs);
            mixin(`auto ret = callDlangFunction!((Parameters!overload dArgs) => `, parent, `.`, identifier, `(dArgs))(dArgs);`);

            static if(isMemberFunction && !isConstMemberFunction!overload) {
                mutateSelf(self, dAggregate);
            }

            return ret;
        } catch(ArgumentConversionException _) {
            // only using this to weed out incompatible overloads
        }
    }}

    throw new Exception("Could not find suitable overload for `" ~ identifier ~ "`");
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

    static if(is(T == class)) {
        if(dobj is null)
            throw new Exception("Cannot create Python class from null D class");
    }

    auto ret = pyObjectNew!(PythonClass!T)(PythonType!T.pyType);

    static foreach(fieldName; PythonType!T.fieldNames) {
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

    // The function pointer for PyGetSetDef.get
    private static extern(C) PyObject* get(int FieldIndex)
                                          (PyObject* self_, void* closure = null)
        nothrow
        in(self_ !is null)
    {
        import python.raw: pyIncRef;

        auto self = cast(PythonClass*) self_;

        auto field = self.getField!FieldIndex;
        assert(field !is null, "Cannot increase reference count on null field");
        pyIncRef(field);

        return field;
    }

    // The function pointer for PyGetSetDef.set
    static extern(C) int set(int FieldIndex)
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

        // FIXME
        // if(!checkPythonType!(fieldTypes[FieldIndex])(value)) {
        //     return -1;
        // }

        auto self = cast(PythonClass!T*) self_;
        auto tmp = self.getField!FieldIndex;

        pyIncRef(value);
        mixin(`self.`, fieldNames[FieldIndex], ` = value;`);
        pyDecRef(tmp);

        return 0;
    }

    PyObject* getField(int FieldIndex)() {
        mixin(`return this.`, fieldNames[FieldIndex], `;`);
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
            return noThrowable!(callDlangFunctionOld!((Parameters!T args) => self._callable(args), T))(self_, args, kwargs);
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
        import autowrap.reflection: BinOpDir, functionName;
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
                    mixin(`alias parameters = Parameters!(T.`, funcName, `!(operator.op));`);
                    static assert(parameters.length == 1, "Binary operators must take one parameter");
                    alias Arg = parameters[0];

                    auto this_ = self.to!T;
                    auto dArg  = pArg.to!Arg;
                    mixin(`return this_.`, funcName, `!(operator.op)(dArg).toPython;`);
                } else {
                    throw new Exception(text(T.stringof, " does not support ", funcName, " with self on ", dir));
                }
            }

            if(lhs_.isInstanceOf!T) {  // self is on the left hand side
                return impl!(BinOpDir.left);
            } else if(rhs_.isInstanceOf!T) {  // self is on the right hand side
                return impl!(BinOpDir.right);
            } else {
                throw new Exception("Neither lhs or rhs were of type " ~ T.stringof);
            }
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
            alias parameters = Parameters!(T.opOpAssign!op);
            static assert(parameters.length == 1, "Assignment operators must take one parameter");

            auto dObj = lhs.to!T;
            dObj.opOpAssign!op(rhs.to!(parameters[0]));
            return dObj.toPython;
        }

        return noThrowable!impl;
    }
}


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
        import std.traits: Parameters, Unqual, hasMember;
        import std.meta: Filter;

        PyObject* impl() {
            static if(hasMember!(T, "opIndex")) {
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
                } else
                    throw new Exception(T.stringof ~ " failed pyIndexCheck and pySliceCheck for key '" ~ PyObject_Repr(key).to!string ~ "'");
                assert(0);
            } else
                throw new Exception(T.stringof ~ " has no opIndex");
        }

        return noThrowable!impl;
    }
}


/**
   Implement a Python iterator for D type T.
   We get a D slice from it, convert it to a Python list,
   then return its iterator.
 */
private template PythonIter(T) {

    static extern(C) PyObject* _py_iter(PyObject* self) nothrow {
        import python.raw: PyObject_GetIter;
        import python.conv.d_to_python: toPython;
        import python.conv.python_to_d: to;
        import std.array;

        PyObject* impl() {
            static if(__traits(compiles, T.init[].array[0])) {
                auto dObj = self.to!T;
                auto list = dObj[].array.toPython;
                return PyObject_GetIter(list);
            } else {
                throw new Exception("Cannot get an array from " ~ T.stringof ~ "[]");
            }
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
