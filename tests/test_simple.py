from simple import (Prefix, Adder, IntString, create_int_point, create_outer,
                    create_outers, create_date_time, date_time_array, points,
                    tuple_of_date_times)
import pytest


def test_adder():
    assert Adder(3).add(5) == 8
    assert Adder(2).add(7) == 9


def test_prefix():
    p = Prefix("foo")
    assert p.pre("bar") == "foobar"


def test_int_string1():
    x = IntString(42)
    assert x.i == 42
    assert x.s == ""


def test_int_string2():
    x = IntString(33, "foobar")
    assert x.i == 33
    assert x.s == "foobar"


def test_point():
    p = create_int_point(42, 33)
    assert p.x == 42
    assert p.y == 33

    with pytest.raises(AttributeError):
        p.z = 5


def test_create_outer():
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
    d = create_date_time(2017, 1, 2)
    assert d.year == 2017
    assert d.month == 1
    assert d.day == 2


def test_datetime_array():
    [ds] = date_time_array(2017, 2, 3)
    assert len(ds) == 1
    [d] = ds
    assert d.year == 2017
    assert d.month == 2
    assert d.day == 3


def test_points():
    [ps] = points(3, 1, 2)
    assert len(ps) == 3
    assert all(p.x == 1 for p in ps)
    assert all(p.y == 2 for p in ps)


def test_tuple_of_date_times():
    ([d1], [d2]) = tuple_of_date_times(2017, 4, 5)

    assert d1.year == 2017
    assert d1.month == 4
    assert d1.day == 5

    assert d2.year == 2018
    assert d2.month == 5
    assert d2.day == 6
