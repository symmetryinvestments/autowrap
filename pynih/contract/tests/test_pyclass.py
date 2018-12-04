# coding=utf8


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


def test_string_list_struct():
    from contract import pyclass_string_list_struct

    s = pyclass_string_list_struct(['foo', 'bar', 'baz'])
    assert s.strings == ['foo', 'bar', 'baz']

    s = pyclass_string_list_struct(['quux', 'toto'])
    assert s.strings == ['quux', 'toto']
