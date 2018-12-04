import python;


extern(C):

mixin(
    createModuleMixin!(
        Module("silly"),
        CFunctions!(
            strlen_,
        ),
        Aggregates!(),
    )
);



private PyObject* strlen_(PyObject* self, PyObject *args) nothrow @nogc {
    import core.stdc.string: cstrlen = strlen;

    const char* arg;

    if(!PyArg_ParseTuple(args, "s", &arg))
        return null;

    const auto len = cstrlen(arg);
    return PyLong_FromLong(len);
}
