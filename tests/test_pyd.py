def test_array():
    import pytest
    with pytest.raises(ImportError):
        from pyd import Foo
        f = Foo(2)
        assert f.i == 2
    from pyd import get, set, test

    assert get() == []

    with pytest.raises(UnboundLocalError):
        set([Foo(10), Foo(20)])
        assert get() == []

    with pytest.raises(RuntimeError):
        t = test()
        assert t.i == 10
        # bar can't be tested due to side-effects
        t.bar()
        assert str(t) == 'Foo'
        assert repr(t) == 'Foo'
