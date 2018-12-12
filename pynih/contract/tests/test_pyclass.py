# coding=utf8
import pytest
import sys


if sys.version_info >= (3, 0):
    is_python_3 = True
    is_python_2 = False
else:
    is_python_3 = False
    is_python_2 = True


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

    if is_python_3:
        assert str(type(s)) == u"<class 'SimpleStruct'>"
    else:
        assert str(type(s)) == u"<type 'SimpleStruct'>"

    assert repr(s) == u'SimpleStruct(3, 22.2)'
    assert str(s) == u'SimpleStruct(3, 22.2)'


def test_string_list_struct():
    from contract import pyclass_string_list_struct

    s = pyclass_string_list_struct([u'foo', u'bar', u'baz'])
    assert s.strings == [u'foo', u'bar', u'baz']

    s = pyclass_string_list_struct([u'quux', u'toto'])
    assert s.strings == [u'quux', u'toto']

    if is_python_3:
        assert str(type(s)) == u"<class 'StringsStruct'>"
    else:
        assert str(type(s)) == u"<type 'StringsStruct'>"

    assert repr(s) == u'StringsStruct(["quux", "toto"])'
    assert str(s) == u'StringsStruct(["quux", "toto"])'


def test_twice_struct():
    from contract import pyclass_twice_struct

    s = pyclass_twice_struct(3)
    assert s.twice() == 6

    s = pyclass_twice_struct(4)
    assert s.twice() == 8

    if is_python_3:
        assert str(type(s)) == u"<class 'TwiceStruct'>"
    else:
        assert str(type(s)) == u"<type 'TwiceStruct'>"

    assert repr(s) == u'TwiceStruct(4)'
    assert str(s) == u'TwiceStruct(4)'


def test_thrice_struct():
    from contract import pyclass_thrice_struct

    s = pyclass_thrice_struct(33.3)
    assert s.thrice() == pytest.approx(99.9, 0.1)
    assert s.quadruple() == pytest.approx(133.2, 0.1)

    s = pyclass_thrice_struct(11.1)
    assert s.thrice() == pytest.approx(33.3, 0.1)
    assert s.quadruple() == pytest.approx(44.4, 0.1)

    if is_python_3:
        assert str(type(s)) == u"<class 'ThriceStruct'>"
    else:
        assert str(type(s)) == u"<type 'ThriceStruct'>"

    assert repr(s) == u'ThriceStruct(11.1)'
    assert str(s) == u'ThriceStruct(11.1)'


def test_void_method():
    from contract import pyclass_void_struct

    s = pyclass_void_struct()
    assert s.i == 42
    s.setValue(33)
    assert s.i == 33
