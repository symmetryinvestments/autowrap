# Tests for the simple example that only pynih can handle


def test_method_overloads():
    from simple import Overloads
    o = Overloads()
    assert o.fun(2) == 4
    assert o.fun(3) == 6
    assert o.fun(2, 3) == 6
    assert o.fun(3, 4) == 12


def test_struct_no_ctor():
    from simple import NoCtor
    s = NoCtor(42, 33.3, "foobar")
    assert s.i == 42
    assert s.d == 33.3
    assert s.s == 'foobar'


def test_property_getter_setter_const():
    from simple import GetterSetterConst
    import pytest

    obj = GetterSetterConst(42)

    # can't call the property function since not registered
    with pytest.raises(TypeError):
        obj.i()

    # can't call the property function since not registered
    with pytest.raises(TypeError):
        obj.i(33)

    assert obj.i == 42
    obj.i = 33  # shouldn't throw


def test_funcs():
    from pyd import appends_to_fn_cb

    assert appends_to_fn_cb(lambda x: str(x), 42, "post") == \
        "42post"
