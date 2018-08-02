/**
   Reimplementations of pyd's class_wrap module
 */
module autowrap.python.pyd.class_wrap;

import deimos.python.Python;


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
struct Def(alias fn, Options...) {
    import pyd.def: Args;

    alias Args!("","", __traits(identifier,fn), "",Options) args;

    static if(args.rem.length) {
        alias args.rem[0] fn_t;
    } else {
        alias typeof(&fn) fn_t;
    }

    mixin _Def!(fn, args.pyname, fn_t, args.docstring);
}

template _Def(alias _fn, string name, fn_t, string docstring) {
    import pyd.class_wrap: wrapped_method_list;
    import pyd.references: PydTypeObject;
    import pyd.def: def_selector;
    import pyd.func_wrap: minArgs, method_wrap;
    import util.typeinfo: ApplyConstness, constness;
    import deimos.python.methodobject: PyMethodDef, PyCFunction, METH_VARARGS, METH_KEYWORDS;

    alias def_selector!(_fn,fn_t).FN func;
    static assert(!__traits(isStaticFunction, func),
                  "Cannot register " ~ name ~ " because static member functions are not yet supported");
    alias /*StripSafeTrusted!*/fn_t func_t;
    enum realname = __traits(identifier,func);
    enum funcname = name;
    enum min_args = minArgs!(func);
    enum bool needs_shim = false;

    static void call(string classname, T) () {
        alias ApplyConstness!(T, constness!(typeof(func))) cT;
        static PyMethodDef empty = { null, null, 0, null };
        alias wrapped_method_list!(T) list;
        list[$-1].ml_name = (name ~ "\0").ptr;
        list[$-1].ml_meth = cast(PyCFunction) &method_wrap!(cT, func, classname ~ "." ~ name).func;
        list[$-1].ml_flags = METH_VARARGS | METH_KEYWORDS;
        list[$-1].ml_doc = (docstring~"\0").ptr;
        list ~= empty;
        // It's possible that appending the empty item invalidated the
        // pointer in the type struct, so we renew it here.
        PydTypeObject!(T).tp_methods = list.ptr;
    }
    template shim(size_t i, T) {
        import util.replace: Replace;
        enum shim = Replace!(q{
            alias Params[$i] __pyd_p$i;
            $override ReturnType!(__pyd_p$i.func_t) $realname(ParameterTypeTuple!(__pyd_p$i.func_t) t) $attrs {
                return __pyd_get_overload!("$realname", __pyd_p$i.func_t).func!(ParameterTypeTuple!(__pyd_p$i.func_t))("$name", t);
            }
            alias T.$realname $realname;
        }, "$i",i,"$realname",realname, "$name", name,
        "$attrs", attrs_to_string(functionAttributes!func_t) ~ " " ~ tattrs_to_string!(func_t)(),
        "$override",
        // todo: figure out what's going on here
        (variadicFunctionStyle!func == Variadic.no ? "override":""));
    }
}
