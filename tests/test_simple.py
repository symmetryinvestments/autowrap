from datetime import date
import pytest


def test_adder():
    from simple import Adder
    assert Adder(3).add(5) == 8
    assert Adder(2).add(7) == 9


def test_prefix():
    from simple import Prefix
    p = Prefix("foo")
    assert p.pre("bar") == "foobar"


def test_int_string1():
    from simple import IntString
    x = IntString(42)
    assert x.i == 42
    assert x.s == ""


def test_int_string2():
    from simple import IntString
    x = IntString(33, "foobar")
    assert x.i == 33
    assert x.s == "foobar"


def test_point():
    from simple import create_int_point
    p = create_int_point(42, 33)
    assert p.x == 42
    assert p.y == 33

    with pytest.raises(AttributeError):
        p.z = 5


def test_create_outer():
    from simple import create_outer
    o = create_outer(2.0, 3.0, 33.3, "foo", "bar")
    [fst_i1, snd_i1] = o.inner1s
    assert fst_i1.point.x == 2.0
    assert fst_i1.point.y == 3.0
    assert fst_i1.value == 33.3
    assert snd_i1.point.x == 2.0
    assert snd_i1.point.y == 3.0
    assert snd_i1.value == 34.3
    assert o.inner2.evenInner.value == 33.3
    assert o.string1.value == "foo"
    assert o.string2.value == "bar"


def test_create_outers():
    from simple import create_outers
    [o] = create_outers(2.0, 3.0, 33.3, "foo", "bar")
    [fst_i1, snd_i1] = o.inner1s
    assert fst_i1.point.x == 2.0
    assert fst_i1.point.y == 3.0
    assert fst_i1.value == 33.3
    assert snd_i1.point.x == 2.0
    assert snd_i1.point.y == 3.0
    assert snd_i1.value == 35.3
    assert o.inner2.evenInner.value == 33.3
    assert o.string1.value == "foo"
    assert o.string2.value == "bar"


def test_create_datetime():
    from simple import create_date_time
    d = create_date_time(2017, 1, 2)
    assert d.year == 2017
    assert d.month == 1
    assert d.day == 2


def test_datetime_array():
    from simple import date_time_array
    [ds] = date_time_array(2017, 2, 3)
    assert len(ds) == 1
    [d] = ds
    assert d.year == 2017
    assert d.month == 2
    assert d.day == 3


def test_points():
    from simple import points
    [ps] = points(3, 1, 2)
    assert len(ps) == 3
    assert all(p.x == 1 for p in ps)
    assert all(p.y == 2 for p in ps)


def test_tuple_of_date_times():
    from simple import tuple_of_date_times
    ([d1], [d2]) = tuple_of_date_times(2017, 4, 5)

    assert d1.year == 2017
    assert d1.month == 4
    assert d1.day == 5

    assert d2.year == 2018
    assert d2.month == 5
    assert d2.day == 6


def test_create_outer2():
    from simple import create_outer2
    o = create_outer2(2.0, 3.0, 33.3, "foo", "bar")
    [fst_i1, snd_i1] = o.inner1s
    assert fst_i1.point.x == 2.0
    assert fst_i1.point.y == 3.0
    assert fst_i1.value == 33.3
    assert snd_i1.point.x == 2.0
    assert snd_i1.point.y == 3.0
    assert snd_i1.value == 34.3
    assert o.inner2.evenInner.value == 33.3
    assert o.string1.value == "foo"
    assert o.string2.value == "bar"


def test_typedef():
    from simple import create_typedef_foo
    create_typedef_foo(2, 3)


def test_create_date():
    from simple import create_date
    d = create_date(2017, 1, 2)
    assert d.year == 2017
    assert d.month == 1
    assert d.day == 2


def test_foo():
    from simple import Foo
    f = Foo(2, 3)
    assert f.toString() == "Foo(2, 3)"


def test_not_copyable():
    with pytest.raises(ImportError):
        from simple import NotCopyable
        NotCopyable(42)


def test_product():
    from simple import product
    assert product(2, 3) == 6
    assert product(4, 5) == 20


def test_identity_int():
    from simple import identity_int
    assert identity_int(4) == 4


def test_api_outer():
    from simple import ApiOuter, NotWrappedInner
    outer = ApiOuter(42, NotWrappedInner("foobar"))
    assert outer.value == 42
    assert outer.inner.value == "foobar"


def test_safe_pure_etc_struct():
    from simple import SafePureEtcStruct
    s = SafePureEtcStruct()
    assert s.stuff(3) == 6


def test_the_year():
    from simple import the_year
    assert the_year(date(2017, 1, 1)) == 2017
    assert the_year(date(2018, 2, 3)) == 2018


def test_wrap_all_string():
    from simple import String
    assert String("foobar").s == "foobar"


def test_wrap_all_other_string_as_param():
    from simple import other_string_as_param, OtherString
    assert other_string_as_param(OtherString("hello ")) == "hello quux"


def test_add_with_default():
    from simple import add_with_default, NotWrappedInt
    assert add_with_default(1, NotWrappedInt(2)) == 3
    assert add_with_default(1) == 43


def test_struct_with_private_member():
    from simple import StructWithPrivateMember

    s = StructWithPrivateMember()
    s.i = 42
    with pytest.raises(AttributeError):
        s.j = 5


def test_struct_fields():
    from simple import IntString

    obj = IntString(7, "foobar")
    assert obj.i == 7
    assert obj.s == "foobar"

    obj.i = 42
    assert obj.i == 42
    assert obj.s == "foobar"

    obj.s = "quux"
    assert obj.i == 42
    assert obj.s == "quux"
