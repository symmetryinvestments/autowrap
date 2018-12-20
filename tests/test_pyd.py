def test_array():
    import pytest
    from pyd import Foo, get, set, test

    f = Foo(2)
    # FIXME - see #54
    with pytest.raises(AttributeError):
        assert f.i == 2

    assert get() == []

    set([Foo(10), Foo(20)])
    assert [f.value() for f in get()] == [10, 20]
    with pytest.raises(AttributeError):
        assert [f.i for f in get()] == [10, 20]

    t = test()
    with pytest.raises(AttributeError):
        assert t.i == 10
    # bar can't be tested due to side-effects
    t.bar()
    assert str(t) == '{10}'
    assert repr(t) == '{10}'


def test_inherit():
    from pyd import (Base, Derived,
                     call_poly, return_poly_base, return_poly_derived)
    import pytest

    b = Base(1)
    assert b.foo() == 'Base.foo'
    assert b.bar() == 'Base.bar'

    d = Derived(2)
    assert d.foo() == 'Derived.foo'
    assert d.bar() == 'Base.bar'

    assert issubclass(Derived, Base)

    assert call_poly(b) == 'Base.foo_call_poly'
    assert call_poly(d) == 'Derived.foo_call_poly'

    class PyClass(Derived):
        def foo(self):
            return 'PyClass.foo'

    p = PyClass(3)
    # FIXME - #61
    with pytest.raises(AssertionError):
        assert call_poly(p) == 'PyClass.foo_call_poly'

    assert return_poly_base().foo() == 'Base.foo'
    # FIXME - #62
    with pytest.raises(AssertionError):
        assert return_poly_derived().foo() == 'Derived.foo'
