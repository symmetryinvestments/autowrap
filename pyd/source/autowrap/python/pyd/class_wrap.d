/**
   Reimplementations of pyd's class_wrap module
 */
module autowrap.python.pyd.class_wrap;


/**
Wraps a member function of the class.

Supports default arguments, typesafe variadic arguments, and python's
keyword arguments.

Params:
fn = The member function to wrap.
Options = Optional parameters. Takes Docstring!(docstring), PyName!(pyname),
and fn_t.
fn_t = The type of the function. It is only useful to specify this
       if more than one function has the same name as this one.
pyname = The name of the function as it will appear in Python. Defaults to
fn's name in D
docstring = The function's docstring. Defaults to "".
*/
struct MemberFunction(alias fn, Options...) {
    import pyd.def: Args;

    alias args = Args!("", "", __traits(identifier, fn), "", Options);

    static if(args.rem.length) {
        alias fn_t = args.rem[0];
    } else {
        alias fn_t = typeof(&fn);
    }

    mixin MemberFunctionImpl!(fn, args.pyname, fn_t, args.docstring);
}

private template MemberFunctionImpl(alias _fn, string name, fn_t, string docstring) {
    import pyd.class_wrap: wrapped_method_list;
    import pyd.references: PydTypeObject;
    import pyd.def: def_selector;
    import pyd.func_wrap: minArgs, method_wrap;
    import pyd.util.typeinfo: ApplyConstness, constness;
    import deimos.python.methodobject: PyMethodDef, PyCFunction, METH_VARARGS, METH_KEYWORDS;

    alias func = def_selector!(_fn, fn_t).FN;
    static assert(!__traits(isStaticFunction, func),
                  "Cannot register " ~ name ~ " because static member functions are not yet supported");
    alias /*StripSafeTrusted!*/fn_t func_t;
    enum realname = __traits(identifier,func);
    enum funcname = name;
    enum min_args = minArgs!func;
    enum bool needs_shim = false; // needed for the compile-time interface

    static void call(string classname, T) () { // needed for the compile-time interface
        alias cT = ApplyConstness!(T, constness!(typeof(func)));
        static PyMethodDef empty = { null, null, 0, null };
        alias list = wrapped_method_list!(T);

        list[$ - 1].ml_name = (name ~ "\0").ptr;
        list[$ - 1].ml_meth = cast(PyCFunction) &method_wrap!(cT, func, classname ~ "." ~ name).func;
        list[$ - 1].ml_flags = METH_VARARGS | METH_KEYWORDS;
        list[$ - 1].ml_doc = (docstring~"\0").ptr;
        list ~= empty;
        // It's possible that appending the empty item invalidated the
        // pointer in the type struct, so we renew it here.
        PydTypeObject!T.tp_methods = list.ptr;
    }

    template shim(size_t i, T) {
        import pyd.util.replace: Replace;
        import std.traits: functionAttributes, variadicFunctionStyle, Variadic;

        enum shim = Replace!(q{
            alias __pyd_p$i = Params[$i];
            $override ReturnType!(__pyd_p$i.func_t) $realname(ParameterTypeTuple!(__pyd_p$i.func_t) t) $attrs {
                return __pyd_get_overload!("$realname", __pyd_p$i.func_t).func!(ParameterTypeTuple!(__pyd_p$i.func_t))("$name", t);
            }
            alias T.$realname $realname;
        },
            "$i", i, "$realname", realname, "$name", name,
            "$attrs", attrs_to_string(functionAttributes!func_t) ~ " " ~ tattrs_to_string!func_t(),
            "$override",
            //TODO: figure out what's going on here
            (variadicFunctionStyle!func == Variadic.no ? "override": ""));
    }
}


private string attrs_to_string(uint attrs) {
    import std.traits: FunctionAttribute;
    import std.compiler: version_major, version_minor;

    string s = "";
    with(FunctionAttribute) {
        if(attrs & pure_) s ~= " pure";
        if(attrs & nothrow_) s ~= " nothrow";
        if(attrs & ref_) s ~= " ref";
        if(attrs & property) s ~= " @property";
        if(attrs & trusted) s ~= " @trusted";
        if(attrs & safe) s ~= " @safe";
        if(attrs & nogc) s ~= " @nogc";
        static if(version_major == 2 && version_minor >= 67) {
            if(attrs & return_) s ~= " return";
        }
    }
    return s;
}


private string tattrs_to_string(fn_t)() {
    string s;
    if(isConstFunction!fn_t) {
        s ~= " const";
    }
    if(isImmutableFunction!fn_t) {
        s ~= " immutable";
    }
    if(isSharedFunction!fn_t) {
        s ~= " shared";
    }
    if(isWildcardFunction!fn_t) {
        s ~= " inout";
    }
    return s;
}

private template isImmutableFunction(T...) if (T.length == 1) {
    alias funcTarget!T func_t;
    enum isImmutableFunction = is(func_t == immutable);
}
private template isConstFunction(T...) if (T.length == 1) {
    alias funcTarget!T func_t;
    enum isConstFunction = is(func_t == const);
}
private template isMutableFunction(T...) if (T.length == 1) {
    alias funcTarget!T func_t;
    enum isMutableFunction = !is(func_t == inout) && !is(func_t == const) && !is(func_t == immutable);
}
private template isWildcardFunction(T...) if (T.length == 1) {
    alias funcTarget!T func_t;
    enum isWildcardFunction = is(func_t == inout);
}
private template isSharedFunction(T...) if (T.length == 1) {
    alias funcTarget!T func_t;
    enum isSharedFunction = is(func_t == shared);
}

private template funcTarget(T...) if(T.length == 1) {
    import std.traits;
    static if(isPointer!(T[0]) && is(PointerTarget!(T[0]) == function)) {
        alias PointerTarget!(T[0]) funcTarget;
    }else static if(is(T[0] == function)) {
        alias T[0] funcTarget;
    }else static if(is(T[0] == delegate)) {
        alias PointerTarget!(typeof((T[0]).init.funcptr)) funcTarget;
    }else static assert(false);
}
