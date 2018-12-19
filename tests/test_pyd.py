def test_array():
    import pytest
    from pyd import Foo, get, set, test

    f = Foo(2)
    # FIXME - see #54
    with pytest.raises(AttributeError):
        assert f.i == 2

    assert get() == []

    set([Foo(10), Foo(20)])
    assert [f.value() for f in get()] == [10, 20]
    with pytest.raises(AttributeError):
        assert [f.i for f in get()] == [10, 20]

    t = test()
    with pytest.raises(AttributeError):
        assert t.i == 10
    # bar can't be tested due to side-effects
    t.bar()
    assert str(t) == '{10}'
    assert repr(t) == '{10}'
