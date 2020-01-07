import pytest


def test_import():
    from std_numeric import decimal_to_factorial
    fac = [0] * 21
    idx = decimal_to_factorial(2982, fac)
    assert idx == 7
    # FIXME #202
    with pytest.raises(AssertionError):
        assert fac[:idx] == [4, 0, 4, 1, 0, 0, 0]
