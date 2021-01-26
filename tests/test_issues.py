import os
import pytest

is_pyd = os.environ.get('PYD')
is_pynih = os.environ.get('PYNIH')


def test_issue_39():
    from issues import StaticMemberFunctions
    s = StaticMemberFunctions()
    assert s.add(1, 2) == 3
    assert s.add(2, 3) == 5
    assert StaticMemberFunctions.add(3, 4) == 7


def test_issue_40_c():
    from issues import c_add
    assert c_add(2, 3) == 5


def test_issue_40_cpp():
    from issues import cpp_add
    assert cpp_add(2, 3) == 5


def test_issue_42_takes_in():
    from issues import IssueString, takes_in_string

    if is_pyd:
        # pyd can't convert to const
        with pytest.raises(RuntimeError):
            takes_in_string(IssueString())


def test_issue_42_takes_scope():
    from issues import IssueString, takes_scope_string
    takes_scope_string(IssueString())


def test_issue_42_takes_ref():
    from issues import IssueString, takes_ref_string
    takes_ref_string(IssueString())


def test_issue_42_takes_ref_const():
    from issues import IssueString, takes_ref_const_string

    if is_pyd:
        # pyd can't convert to const
        with pytest.raises(RuntimeError):
            takes_ref_const_string(IssueString())


def test_issue_42_returns_ref_const():
    from issues import returns_ref_const_string

    if is_pyd:
        # pyd can't convert from const(issues.IssueString*)
        with pytest.raises(RuntimeError):
            s = returns_ref_const_string()
            assert s.value == 'quux'


def test_issue_42_returns_const():
    from issues import returns_const_string

    if is_pyd:
        # pyd can't convert from const(issues.IssueString*)
        with pytest.raises(RuntimeError):
            returns_const_string()
    else:
        assert returns_const_string().value == 'toto'


def test_issue_44():
    if is_pynih:
        with pytest.raises(ImportError):
            from issues import string_ptr
    else:
        from issues import string_ptr
        assert string_ptr('foo').value == 'foo'
        assert string_ptr('bar').value == 'bar'


def test_issue_47():
    from issues import uncopiable_ptr

    if is_pyd:
        with pytest.raises(RuntimeError):
            assert uncopiable_ptr(33.3).x == 33.3
            assert uncopiable_ptr(44.4).x == 44.4
    else:
        assert uncopiable_ptr(33.3).x == 33.3
        assert uncopiable_ptr(44.4).x == 44.4


def test_issue_50():
    from issues import String, takes_string
    takes_string(String())


def test_issue_54():
    from issues import Issue54

    c = Issue54(10)
    if is_pyd:
        # FIXME
        with pytest.raises(AttributeError):
            assert c.i == 10
    else:
        assert c.i == 10


def test_issue_153():
    if is_pyd:  # FIXME
        with pytest.raises(ImportError):
            from issues import Issue153
    else:
        from issues import Issue153

        txt = ""

        def sink(chars):
            nonlocal txt
            txt += chars

        c = Issue153(42)
        c.toString(sink)
        assert txt == "Issue153(42)"


def test_issue_159():
    if is_pyd:  # FIXME
        with pytest.raises(ImportError):
            from issues import Socket
    else:
        from issues import Socket
        s = Socket()
        assert s.send([1, 2, 3]) == 3
        assert s.send([0, 1, 2, 3]) == 4


def test_issue_161():
    if is_pyd:  # FIXME
        with pytest.raises(ImportError):
            from issues import Issue161
    else:
        from issues import Issue161

        e0 = Issue161()
        assert e0.msg == ""

        line = 42
        next_ = None
        err = -1

        def errorFormatter(i):
            return str(i) + 'oops'

        e1 = Issue161("msg", "file", line, next_, err, errorFormatter)
        with pytest.raises(AttributeError):
            assert e1.err == -1


def test_issue_163():
    from issues import issue163
    ints = [1, 2, 3]
    issue163(ints)
    with pytest.raises(AssertionError):
        assert ints == [1, 2, 3, 42]
        issue163(ints)
        assert ints == [1, 2, 3, 42, 42]


def test_issue_164():
    from issues import Issue164, MethodParamString
    i = Issue164()
    assert i.strlen(MethodParamString("foo")) == 3
    assert i.strlen(MethodParamString("quux")) == 4


# FIXME
def test_issue_166():
    from issues import issue166_days, issue166_secs, issue166_usecs
    from datetime import timedelta

    delta = timedelta(days=42, seconds=77, microseconds=99)
    if is_pynih:
        exc = AssertionError
    else:
        exc = RuntimeError

    with(pytest.raises(exc)):
        assert(issue166_days(delta)) == 42
        assert(issue166_secs(delta)) == 77
        assert(issue166_usecs(delta)) == 99


def test_issue_198():
    from issues import Issue198

    i = Issue198([0, 1, 2, 3, 4, 5])
    if is_pynih:
        assert i[1:4] == [1, 2, 3]
    else:
        with pytest.raises(TypeError):  # FIXME
            assert i[1:4] == [1, 2, 3]


def test_infinite_range():
    from issues import FortyTwos
    # from itertools import islice

    _ = FortyTwos(77)
    #  FIXME - this causes a segfault despite the test passing
    # assert list(islice(rng, 4)) == [42, 42, 42, 42]


def test_union():
    if is_pynih:
        from issues import Union
    else:
        with pytest.raises(ImportError):
            from issues import Union


def test_issue_256():
    from issues import Issue256
    from datetime import date

    d = date(2020, 1, 2)
    i = Issue256(d)

    if is_pynih:
        assert i.date == d
    else:
        with pytest.raises(AssertionError):  # FIXME
            assert i.date == d

    assert {'date', 'maybeInt', 'maybeDate'} <= set(dir(Issue256))


def test_method_delegate_safe_scope():
    if is_pyd:
        with pytest.raises(ImportError):
            from issues import MethodWithScopeSafeDelegate
    else:
        from issues import MethodWithScopeSafeDelegate
        m = MethodWithScopeSafeDelegate()
        assert m.fun(3, lambda i, d, s: i * 2) == 6


def test_issue_268():
    from issues import Issue268
    assert Issue268(1) != Issue268(2)
    if is_pynih:
        assert Issue268(42) == Issue268(42)
    else:
        with pytest.raises(AssertionError):
            assert Issue268(42) == Issue268(42)


def test_issue_271():
    if is_pyd:
        with pytest.raises(ImportError):
            from issues import Issue271
            i = Issue271("foobar")
            assert i.length == 6
    else:
        from issues import Issue271
        i = Issue271("foobar")
        with pytest.raises(AttributeError):
            assert i.length == 6


def test_issue_279():
    from issues import Struct279, Class279, DummyInt

    if is_pynih:
        assert Struct279(42) == Struct279(42)
        with pytest.raises(AssertionError):
            assert Struct279(42) == Struct279(33)

        assert Struct279(42) != Struct279(33)
        with pytest.raises(AssertionError):
            assert Struct279(42) != Struct279(42)

        with pytest.raises(RuntimeError):  # FIXME, should be TypeError
            assert Struct279(42) != None  # unpythonic but on purpose

        with pytest.raises(RuntimeError):  # FIXME, should be TypeError
            assert not Struct279(42) == None  # unpythonic but on purpose

        # with pytest.raises(AssertionError):
        #     assert Struct279(42) == DummyInt(42)

        with pytest.raises(AssertionError):
            assert Struct279(42) != DummyInt(42)

        # assert Class279(42) == Class279(42)  FIXME
        with pytest.raises(AssertionError):
            assert Class279(42) == Class279(33)

        assert Class279(42) != Class279(33)
        # with pytest.raises(AssertionError):
        #     assert Class279(42) != Class279(42)  FIXME

        assert Class279(42) != None  # unpythonic but on purpose
        assert not Class279(42) == None  # unpythonic but on purpose

        # with pytest.raises(AssertionError):
        #     assert Class279(42) == DummyInt(42)

        with pytest.raises(AssertionError):
            assert Class279(42) != DummyInt(42)
