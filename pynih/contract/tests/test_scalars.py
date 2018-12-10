# coding=utf8
import pytest


def test_always_none():
    from contract import always_none
    assert always_none() is None
    assert always_none() is None


def test_the_answer():
    from contract import the_answer
    assert the_answer() == 42


def test_one_bool():
    from contract import one_bool_param_to_not
    assert not one_bool_param_to_not(True)
    assert one_bool_param_to_not(False)


def test_one_string():
    from contract import one_string_param_to_length
    assert one_string_param_to_length(u'foo') == 3
    assert one_string_param_to_length(u'quux') == 4


def test_one_int():
    from contract import one_int_param_to_times_two
    assert one_int_param_to_times_two(3) == 6
    assert one_int_param_to_times_two(7) == 14
    # can't pass a float when expecting an integer
    with pytest.raises(TypeError):
        assert one_int_param_to_times_two(11.1) == 22


def test_one_double():
    from contract import one_double_param_to_times_three
    assert one_double_param_to_times_three(1.1) == pytest.approx(3.3)
    assert one_double_param_to_times_three(3.3) == pytest.approx(9.9)
    # no problem passing an integer literal when expecting a float
    assert one_double_param_to_times_three(4) == pytest.approx(12.0)


def test_one_string_param_to_string():
    from contract import one_string_param_to_string
    assert one_string_param_to_string(u'foo') == u'foo_suffix'
    assert one_string_param_to_string(u'quux') == u'quux_suffix'
    assert one_string_param_to_string(u'café') == u'café_suffix'


def test_one_string_param_to_string_manual_mem():
    from contract import one_string_param_to_string_manual_mem
    assert one_string_param_to_string_manual_mem(u'foo') == u'foo_suffix'
    assert one_string_param_to_string_manual_mem(u'quux') == u'quux_suffix'
    assert one_string_param_to_string_manual_mem(u'café') == u'café_suffix'


def test_one_list_param():
    from contract import one_list_param
    assert one_list_param([1, 2, 3]) == 4
    assert one_list_param([4, 5, 6, 7]) == 5


def test_one_list_param_to_list():
    from contract import one_list_param_to_list
    assert one_list_param_to_list([1, 2, 3]) == [1, 2, 3, 4, 5]
    assert one_list_param_to_list([u'foo', u'bar']) == [u'foo', u'bar', 4, 5]


def test_one_tuple_param():
    from contract import one_tuple_param
    assert one_tuple_param((1, 2, 3)) == 5
    assert one_tuple_param((4, 5, 6, 7)) == 6


def test_one_range_param():
    from contract import one_range_param
    assert one_range_param(range(10)) == 13


def test_one_dict_param():
    from contract import one_dict_param
    assert one_dict_param({u'foo': u'bar'}) == 1
    assert one_dict_param({u'foo': u'bar', u'quux': u'toto'}) == 2


def test_one_dict_param_to_dict():
    from contract import one_dict_param_to_dict
    ret = one_dict_param_to_dict({u'foo': u'bar'})
    assert ret == {u'foo': u'bar', u'oops': u'noooo'}


def test_add_days_to_date():
    from contract import add_days_to_date
    from datetime import date

    assert add_days_to_date(date(2018, 1, 2), 5) == date(2018, 1, 7)
    assert add_days_to_date(date(2017, 2, 3), 6) == date(2017, 2, 9)


def test_add_days_to_datetime():
    from contract import add_days_to_datetime
    from datetime import datetime

    assert add_days_to_datetime(datetime(2018, 1, 2, 12, 13, 14), 5) == \
        datetime(2018, 1, 7, 12, 13, 14)

    assert add_days_to_datetime(datetime(2017, 2, 3, 12, 13, 14), 6) == \
        datetime(2017, 2, 9, 12, 13, 14)


def test_runtime_error():
    from contract import throws_runtime_error

    with pytest.raises(RuntimeError) as ex:
        throws_runtime_error()

    assert str(ex.value) == "Generic runtime error"


def test_kwargs():
    from contract import kwargs_count
    assert kwargs_count(1, 2, third=3) == 1
    assert kwargs_count(1, 2, third=3, fourth=4, fifth=5) == 3
