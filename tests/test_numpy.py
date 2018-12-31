def test_bool():
    from numpytests import if_true_then_42_else_33
    from numpy import bool_

    assert if_true_then_42_else_33(bool_(True)) == 42
    assert if_true_then_42_else_33(bool_(False)) == 33


def test_int8():
    from numpytests import add1
    from numpy import int8

    assert add1(int8(2), int8(3)) == 6
    assert add1(int8(1), int8(1)) == 3


def test_int16():
    from numpytests import add1
    from numpy import int16

    assert add1(int16(2), int16(3)) == 6
    assert add1(int16(1), int16(1)) == 3


def test_int32():
    from numpytests import add1
    from numpy import int32

    assert add1(int32(2), int32(3)) == 6
    assert add1(int32(1), int32(1)) == 3


def test_int64():
    from numpytests import add1
    from numpy import int64

    assert add1(int64(2), int64(3)) == 6
    assert add1(int64(1), int64(1)) == 3


def test_uint8():
    from numpytests import add1
    from numpy import uint8

    assert add1(uint8(2), uint8(3)) == 6
    assert add1(uint8(1), uint8(1)) == 3


def test_uint16():
    from numpytests import add1
    from numpy import uint16

    assert add1(uint16(2), uint16(3)) == 6
    assert add1(uint16(1), uint16(1)) == 3


def test_uint32():
    from numpytests import add1
    from numpy import uint32

    assert add1(uint32(2), uint32(3)) == 6
    assert add1(uint32(1), uint32(1)) == 3


def test_uint64():
    from numpytests import add1
    from numpy import uint64

    assert add1(uint64(2), uint64(3)) == 6
    assert add1(uint64(1), uint64(1)) == 3


def test_float32():
    from numpytests import twice
    from numpy import float32
    import pytest

    assert twice(float32(33.3)) == pytest.approx(66.6)


def test_float64():
    from numpytests import twice
    from numpy import float64
    import pytest

    assert twice(float64(33.3)) == pytest.approx(66.6)


def test_complex64():
    from numpytests import switch_coord
    from numpy import complex64
    import pytest

    switched = switch_coord(complex64(33.3))
    assert switched.real == pytest.approx(0.0)
    assert switched.imag == pytest.approx(33.3)


def test_complex128():
    from numpytests import switch_coord
    from numpy import complex128
    import pytest

    switched = switch_coord(complex128(33.3))
    assert switched.real == pytest.approx(0.0)
    assert switched.imag == pytest.approx(33.3)


def test_datetime64():
    from numpytests import inc_year
    from numpy import datetime64
    from datetime import datetime

    inc2 = inc_year(datetime64(datetime(2018, 1, 2, 3, 4, 5)), 2)
    assert inc2 == datetime(2020, 1, 2, 3, 4, 5)

    incm3 = inc_year(datetime64(datetime(2018, 1, 2, 3, 4, 5)), -3)
    assert incm3 == datetime(2015, 1, 2, 3, 4, 5)


def test_array():
    from numpytests import append42
    from numpy import array
    import pytest

    # FIXME
    with pytest.raises(AssertionError):
        assert append42(array([1, 2, 3])) == [1, 2, 3, 42]


def test_arange():
    from numpytests import append42
    from numpy import arange
    import pytest

    # FIXME
    with pytest.raises(AssertionError):
        assert append42(arange(3)) == [0, 1, 2, 42]

def test_ndarray():
    from numpytests import matrix_inc1
    from numpy import ndarray
    from pytest import approx

    nd = ndarray(shape=(2,2), dtype=float, order='F')
    nd[0, 0] = 1.1
    nd[0, 1] = 2.2
    nd[1, 0] = 3.3
    nd[1, 1] = 4.4

    lst = matrix_inc1(nd)
    assert lst[0][0] == approx(2.1)
    assert lst[0][1] == approx(3.2)
    assert lst[1][0] == approx(4.3)
    assert lst[1][1] == approx(5.4)
