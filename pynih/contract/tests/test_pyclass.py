# coding=utf8
import pytest


def test_int_double_struct():
    from contract import pyclass_int_double_struct

    s = pyclass_int_double_struct(42, 33.3)
    assert s.i == 42
    assert s.d == 33.3

    s = pyclass_int_double_struct(21, 77.7)
    assert s.i == 21
    assert s.d == 77.7

    s.i = 3
    assert s.i == 3
    s.d = 22.2
    assert s.d == 22.2

    assert str(type(s)) == u"<class 'SimpleStruct'>"


def test_string_list_struct():
    from contract import pyclass_string_list_struct

    s = pyclass_string_list_struct(['foo', 'bar', 'baz'])
    assert s.strings == ['foo', 'bar', 'baz']

    s = pyclass_string_list_struct(['quux', 'toto'])
    assert s.strings == ['quux', 'toto']

    assert str(type(s)) == u"<class 'StringsStruct'>"


def test_twice_struct():
    from contract import pyclass_twice_struct

    s = pyclass_twice_struct(3)
    assert s.twice() == 6

    s = pyclass_twice_struct(4)
    assert s.twice() == 8

    assert str(type(s)) == u"<class 'TwiceStruct'>"


def test_thrice_struct():
    from contract import pyclass_thrice_struct

    s = pyclass_thrice_struct(33.3)
    assert s.thrice() == pytest.approx(99.9, 0.1)
    assert s.quadruple() == pytest.approx(133.2, 0.1)

    s = pyclass_thrice_struct(11.1)
    assert s.thrice() == pytest.approx(33.3, 0.1)
    assert s.quadruple() == pytest.approx(44.4, 0.1)

    assert str(type(s)) == u"<class 'ThriceStruct'>"
