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


def test_testdll():
    from pyd import \
        (testdll_foo, testdll_bar, testdll_baz, dg_test, TestDllFoo,
         testdll_throws, TestDllStruct, testdll_spam)
    import pytest

    assert testdll_foo() == '20 Monkey'

    assert testdll_bar(5) == "It's less than 10!"
    assert testdll_bar(12) == "It's greater than 10!"

    (baz_i, baz_s) = testdll_baz()
    assert baz_i == 10
    assert baz_s == 'moo'

    (baz_i, baz_s) = testdll_baz(20)
    assert baz_i == 20
    assert baz_s == 'moo'

    (baz_i, baz_s) = testdll_baz(30, 'cat')
    assert baz_i == 30
    assert baz_s == 'cat'

    def callback():
        return 'callback works'
    assert dg_test(callback) == 'callback works'

    foo = TestDllFoo(10)
    assert foo.foo() == 'Foo.foo(): i = 10'

    assert foo.i == 10
    foo.i = 50
    assert foo.i == 50

    assert str(foo + foo) == 'TestDllFoo(100)'

    assert [i for i in foo] == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    spam_foo = testdll_spam(foo)
    assert str(spam_foo) == 'TestDllFoo(60)'

    assert TestDllFoo(1, 2).i == 3
    assert TestDllFoo(2, 3).i == 5

    with pytest.raises(RuntimeError) as ex:
        testdll_throws()
    assert 'Yay! An exception!' in str(ex.value)

    S = TestDllStruct
    s = S()
    assert s.i == 0
    assert s.s == ''
    s.i = 42
    s.s = 'hello'
    assert s.i == 42
    assert s.s == 'hello'
