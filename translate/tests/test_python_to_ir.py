from python_to_ir import transform
from ir import AutowrapTest, Assertion


def test_one_assertion_literals_0():
    ir = transform("""
def random_function():
    pass


def test_foo():
    assert 1 == 2

""")
    assert ir == [
        AutowrapTest(
            "test_foo",
            [
                Assertion(1, 2),
            ]
        )
    ]


def test_one_assertion_literals_1():
    ir = transform("""
def random_function():
    pass


def test_bar():
    assert 3 == 4

""")
    assert ir == [
        AutowrapTest(
            "test_bar",
            [
                Assertion(3, 4),
            ]
        )
    ]
