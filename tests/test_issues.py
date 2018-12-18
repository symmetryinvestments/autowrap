def test_issue_42_takes_in():
    from simple import IssueString, takes_in_string
    import pytest

    # pyd can't convert to const
    with pytest.raises(RuntimeError):
        takes_in_string(IssueString())


def test_issue_42_takes_scope():
    from simple import IssueString, takes_scope_string
    takes_scope_string(IssueString())


def test_issue_42_takes_ref():
    from simple import IssueString, takes_ref_string
    takes_ref_string(IssueString())


def test_issue_42_takes_ref_const():
    from simple import IssueString, takes_ref_const_string
    import pytest

    # pyd can't convert to const
    with pytest.raises(RuntimeError):
        takes_ref_const_string(IssueString())


def test_issue_42_returns_ref_const():
    from simple import returns_ref_const_string
    import pytest

    # pyd can't convert from const(issues.IssueString*)
    with pytest.raises(RuntimeError):
        s = returns_ref_const_string()
        assert s.value == 'quux'


def test_issue_42_returns_const():
    from simple import returns_const_string
    import pytest

    # pyd can't convert from const(issues.IssueString*)
    with pytest.raises(RuntimeError):
        s = returns_const_string()
        assert s.value == 'toto'


def test_issue_44():
    from simple import string_ptr
    assert string_ptr('foo').value == 'foo'
    assert string_ptr('bar').value == 'bar'


def test_issue_47():
    from simple import uncopiable_ptr
    import pytest

    with pytest.raises(RuntimeError):
        assert uncopiable_ptr(33.3).d == 33.3
        assert uncopiable_ptr(44.4).d == 44.4
