# coding=utf8


def test_simple_struct():
    from contract import simple_struct
    mytype = simple_struct()
    assert mytype.the_int == 42
    assert mytype.the_double == 33.3
