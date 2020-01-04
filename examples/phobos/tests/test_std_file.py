import os


is_pyd = os.environ.get('PYD')
is_pynih = os.environ.get('PYNIH')


def test_import():
    import std_file
