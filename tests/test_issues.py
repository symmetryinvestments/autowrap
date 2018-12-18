def test_issue_44():
    from simple import string_ptr
    import pytest

    with pytest.raises(RuntimeError):
        assert string_ptr('foo').value == 'foo'
        assert string_ptr('bar').value == 'bar'


def test_issue_47():
    from simple import uncopiable_ptr
    import pytest

    with pytest.raises(RuntimeError):
        assert uncopiable_ptr(33.3).d == 33.3
        assert uncopiable_ptr(44.4).d == 44.4
