/**
   New implementation of Python wrapping for D.
 */
module autowrap.pynih;


public import autowrap.pynih.wrap;

// Make sure that the init symbol for _typeobject ends up in the static library
private void _impl() {
    import python.c: _typeobject;
    _typeobject _;
}
