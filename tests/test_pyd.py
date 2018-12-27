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


def test_def():
    from pyd import def_a, def_a2, def_a3, def_a4, def_t1_int, def_t2_int
    import pytest

    with pytest.raises(RuntimeError) as ex:
        assert def_a(1.0) == 20
    assert "Couldn't convert Python type 'float' to D type 'int'" in \
        str(ex.value)

    assert def_a(42) == 10
    assert def_a(24) == 10

    assert def_a2(4, 2.1) == 214
    assert def_a2(4) == 454
    assert def_a2(i=4) == 454

    # def_a3 accepts a variadic number of ints
    assert def_a3(4) == 46
    assert def_a3(i=4) == 46
    assert def_a3(4, 3) == 49
    assert def_a3(i=[4, 3]) == 49

    assert def_a4('hi', 2, s3='zi') == "<'hi', 2, 'friedman', 4, 'zi'>"

    assert def_t1_int(42) == 1
    assert def_t2_int(42) == 1


def test_struct_wrap():
    from pyd import (sw_Foo1 as Foo1, sw_Foo3 as Foo3, sw_Foo5 as Foo5,
                     sw_Foo6 as Foo6)
    from datetime import datetime as DateTime

    foo1 = Foo1(2, 3, 4)
    assert foo1.i == 2

    foo3 = Foo3()
    foo3.i = 1
    foo3.foo.j = 2
    assert foo3.foo.j == 2

    foo5 = Foo5()
    foo5.foo.j = 2

    foo6 = Foo6(DateTime(2018, 7, 3))
    assert foo6.dateTime.year == 2018


def test_const():
    from pyd import const_T1 as T1
    import pytest

    boozy = T1()

    with pytest.raises(RuntimeError) as ex:
        boozy.a()
    assert 'constness mismatch required:' in str(ex.value)

    assert boozy.b() == 'def'

    with pytest.raises(RuntimeError) as ex:
        boozy.p1i
    assert 'constness mismatch required:' in str(ex.value)

    assert boozy.p1c == 300


def test_class_wrap_bizzy():
    from pyd import Bizzy

    bizzy = Bizzy(i=4)
    assert bizzy.a(1) == 12
    assert Bizzy.b(1) == 14
    assert str(bizzy) == 'bye'
    assert repr(bizzy) == 'bye'

    assert bizzy + 1 == 2
    assert bizzy * 1 == 3
    assert bizzy ** 1 == 4

    assert 1 + bizzy == 5
    assert 19 in bizzy
    assert 0 not in bizzy

    assert +bizzy == 55
    assert ~bizzy == 44

    assert bizzy > 1
    assert len(bizzy) == 401

    assert bizzy[0] == 0.0
    assert bizzy[1] == 4.4
    assert bizzy[1:2] == [1, 2, 3]

    bizzy += 2
    assert bizzy.m() == 24
    bizzy %= 3
    assert bizzy.m() == 36
    bizzy **= 4
    assert bizzy.m() == 48

    bizzy[2] = 3.5
    assert bizzy.m() == 3502
    bizzy[2:3] = 4.5
    assert bizzy.m() == 4523

    assert bizzy(40.5) == 45023



def test_class_wrap_bizzy2():
    from pyd import Bizzy2
    import pytest

    bizzy = Bizzy2(4)
    assert bizzy.jj() == [4]

    bizzy = Bizzy2(4, 5)
    assert bizzy.jj() == [4, 5]

    bizzy = Bizzy2(i=4)
    assert bizzy.jj() == [4]

    bizzy = Bizzy2(i=[4,5])
    assert bizzy.jj() == [4, 5]

    assert Bizzy2.a(7, 32.1) == 6427
    assert Bizzy2.a(i=7, d=32.1) == 6427
    assert Bizzy2.a(d=32.1, i=7) == 6427

    assert Bizzy2.b(7, 32.1) == 32173
    assert Bizzy2.b(d=32.1, i=7) == 32173
    assert Bizzy2.b(i=7, d=32.1) == 32173
    assert Bizzy2.b(7) == 3273
    assert Bizzy2.b(i=7) == 3273

    assert Bizzy2.c(7) == 7
    assert Bizzy2.c(i=7) == 7
    assert Bizzy2.c(i=[7]) == 7
    assert Bizzy2.c(7, 5, 6) == 657
    assert Bizzy2.c(i=[7, 5, 6]) == 657

    assert Bizzy2.d(i=7, k='foobiz') == "<7, 101, 'foobiz'>"
    with pytest.raises(RuntimeError) as ex:
        Bizzy2.d(i=7, s='foobiz')
    assert "Bizzy2.d() got an unexpected keyword argument 's'" in str(ex.value)


def test_class_wrap_bizzy3():
    from pyd import Bizzy3

    bizzy = Bizzy3(1,2)
    assert bizzy.a(7, 32.1) == 3224
    assert bizzy.a(i=7, d=32.1) == 3224
    assert bizzy.a(d=32.1,i=7) == 3224

    assert bizzy.b(7, 32.1) == 32244
    assert bizzy.b(d=32.1,i=7) == 32244
    assert bizzy.b(i=7, d=32.1) == 32244
    assert bizzy.b(7) == 3344
    assert bizzy.b(i=7) == 3344

    assert bizzy.c(7) == 7
    assert bizzy.c(i=7) == 7
    assert bizzy.c(i=[7]) == 7
    assert bizzy.c(7,5,6) == 756
    assert bizzy.c(i=[7,5,6]) == 756

    assert bizzy.d(i=7, k='foobiz') == "<7, 102, 'foobiz'>"


def test_class_wrap_bizzy4():
    from pyd import Bizzy4

    bizzy = Bizzy4()
    assert bizzy.i == 4
    bizzy.i = 10
    assert bizzy.i == 10
    assert len(bizzy) == 5
    assert repr(bizzy) == "cowabunga"


def test_class_wrap_bizzy5():
    from pyd import Bizzy5

    boozy = Bizzy5(1)
    assert boozy.a() == "<1, 1, 'hi'>"
    boozy = Bizzy5(1, d=2.0)
    assert boozy.a() == "<1, 2, 'hi'>"
    boozy = Bizzy5(1, s='ten')
    assert boozy.a() == "<1, 1, 'ten'>"
