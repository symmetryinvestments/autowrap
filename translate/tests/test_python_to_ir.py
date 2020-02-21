from python_to_ir import transform
from ir import (AutowrapTest, Assertion, Import, Call, NumLiteral,
                StringLiteral, Assignment, Sequence, BytesLiteral,
                IfPyd, IfPynih, ShouldThrow)


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
                Assertion(NumLiteral(1), NumLiteral(2)),
            ]
        )
    ]


def test_one_assertion_literals_1():
    ir = transform("""
def random_function():
    pass


def test_bar():
    assert 3 == 'foo'

""")
    assert ir == [
        AutowrapTest(
            "test_bar",
            [
                Assertion(NumLiteral(3), StringLiteral("foo")),
            ]
        )
    ]


def test_assertion_call_literal():
    ir = transform("""
def test_func():
    from mod import func
    assert func(7) == 42
""")

    assert ir == [
        AutowrapTest(
            "test_func",
            [
                Import('mod', ['func']),
                Assertion(Call("func", [NumLiteral(7)]), NumLiteral(42)),
            ]
        )
    ]


def test_assign_to_var():
    ir = transform("""
def test_assign():
    foo = 42
""")

    assert ir == [
        AutowrapTest(
            "test_assign",
            [
                Assignment('foo', NumLiteral(42))
            ]
        )
    ]


def test_assign_to_list():
    ir = transform("""
def test_assign_to_list():
    [foo, bar] = 42
""")

    assert ir == [
        AutowrapTest(
            "test_assign_to_list",
            [
                Assignment(Sequence(['foo', 'bar']), NumLiteral(42))
            ]
        )
    ]


def test_assign_from_bytes():
    ir = transform("""
def test_assign_from_bytes():
    foo = b'abc'
""")

    assert ir == [
        AutowrapTest(
            "test_assign_from_bytes",
            [
                Assignment('foo', BytesLiteral(b'abc'))
            ]
        )
    ]


def test_if_constant():
    import pytest
    with pytest.raises(Exception) as info:
        transform("""
def test_oops():
    if True:
        pass
""")

    assert str(info.value) == \
        "Cannot handle ifs that aren't is_pyd or is_pynih"


def test_if_pyd():
    ir = transform("""
def test_if_pyd():
    if is_pyd:
        pass
""")

    assert ir == [
        AutowrapTest(
            "test_if_pyd",
            [
                IfPyd([]),
            ]
        )
    ]


def test_if_pynih():
    ir = transform("""
def test_if_pynih():
    if is_pynih:
        pass
""")

    assert ir == [
        AutowrapTest(
            "test_if_pynih",
            [
                IfPynih([]),
            ]
        )
    ]


def test_with_random():
    import pytest
    with pytest.raises(Exception) as info:
        transform("""
def test_oops():
    with foo as bar:
        pass
""")
    assert str(info.value) == \
        "Cannot handle with blocks that aren't pytest exception checks"


def test_with_raises_exception():
    ir = transform("""
def test_raises():
    with pytest.raises(ImportError):
        from bar import foo
    """)
    assert ir == [
        AutowrapTest(
            "test_raises",
            [
                ShouldThrow(
                    "ImportError",
                    [
                        Import('bar', ['foo'])
                    ]
                )
            ]
        )
    ]
