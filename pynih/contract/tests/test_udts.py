# coding=utf8


def test_simple_struct_func():
    from contract import simple_struct_func
    mytype = simple_struct_func()
    assert mytype.the_int == 42
    assert mytype.the_double == 33.3


def test_twice_struct_func():
    from contract import twice_struct_func
    s3 = twice_struct_func(3)
    assert s3.twice() == 6
    s4 = twice_struct_func(4)
    assert s4.twice() == 8


def test_ctor():
    from contract import MyStruct

    assert MyStruct().i == 42
    # TODO
    # assert MyStruct(77).i == 77
