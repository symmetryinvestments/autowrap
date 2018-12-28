def test_bool():
    from numpytests import if_true_then_42_else_33
    from numpy import bool_

    assert if_true_then_42_else_33(bool_(True)) == 42
    assert if_true_then_42_else_33(bool_(False)) == 33
