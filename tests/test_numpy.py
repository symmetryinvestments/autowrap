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
