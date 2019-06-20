def test_method_overloads():
    from simple import Overloads
    o = Overloads()
    assert o.fun(2) == 4
    assert o.fun(3) == 6
    assert o.fun(2, 3) == 6
    assert o.fun(3, 4) == 12


def test_struct_no_ctor():
    from simple import NoCtor
    _ = NoCtor(42, 33.3, "foobar")
