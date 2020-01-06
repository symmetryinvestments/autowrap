import os
import pytest


is_pyd = os.environ.get('PYD')
is_pynih = os.environ.get('PYNIH')


def test_fabs():
    from std_math import fabs
    for i in range(10):
        number = i + 0.1  # turn it into a float
        assert abs(number) == fabs(number)


# FIXME
def test_sqrt():
    if is_pynih:  # FIXME
        with pytest.raises(ImportError):
            from std_math import sqrt
    else:
        from std_math import sqrt
        assert sqrt(4) == 2
        assert sqrt(4.0) == 2
        assert sqrt(9) == 3
        assert sqrt(9.0) == 3


def test_ceil():
    from std_math import ceil
    assert ceil(0.0) == 0
    assert ceil(1.234) == 2
    assert ceil(-1.234) == -1


def test_floor():
    from std_math import floor
    assert floor(0.0) == 0
    assert floor(1.234) == 1
    assert floor(-1.234) == -2
