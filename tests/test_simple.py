import pytest
import os

is_pyd = os.environ.get('PYD')
is_pynih = os.environ.get('PYNIH')
is_python = is_pyd or is_pynih
is_cs = not is_python


def test_adder():
    from adder import Adder
    assert Adder(3).add(5) == 8
    assert Adder(2).add(7) == 9


def test_prefix():
    from prefix import Prefix
    p = Prefix("foo")
    assert p.pre("bar") == "foobar"


def test_int_string1():
    from structs import IntString
    x = IntString(42)
    assert x.i == 42
    assert x.s == ""


def test_int_string2():
    from structs import IntString
    x = IntString(33, "foobar")
    assert x.i == 33
    assert x.s == "foobar"


def test_point():
    if is_python:  # FIXME C# (template function)
        from api import create_int_point
        p = create_int_point(42, 33)
        assert p.x == 42
        assert p.y == 33

        with pytest.raises(AttributeError):
            p.z = 5


def test_create_outer():
    if is_python:  # FIXME C# (template function)
        from api import create_outer
        o = create_outer(2.0, 3.0, 33.3, "foo", "bar")
        [fst_i1, snd_i1] = o.inner1s
        assert fst_i1.point.x == 2.0
        assert fst_i1.point.y == 3.0
        assert fst_i1.value == 33.3
        assert snd_i1.point.x == 2.0
        assert snd_i1.point.y == 3.0
        assert snd_i1.value == 34.3
        assert o.inner2.evenInner.value == 33.3
        assert o.string1.value == "foo"
        assert o.string2.value == "bar"


def test_create_outers():
    if is_python:  # FIXME C# (template function)
        from api import create_outers
        [o] = create_outers(2.0, 3.0, 33.3, "foo", "bar")
        [fst_i1, snd_i1] = o.inner1s
        assert fst_i1.point.x == 2.0
        assert fst_i1.point.y == 3.0
        assert fst_i1.value == 33.3
        assert snd_i1.point.x == 2.0
        assert snd_i1.point.y == 3.0
        assert snd_i1.value == 35.3
        assert o.inner2.evenInner.value == 33.3
        assert o.string1.value == "foo"
        assert o.string2.value == "bar"


def test_create_datetime():
    from api import create_date_time
    d = create_date_time(2017, 1, 2)
    assert d.year == 2017
    assert d.month == 1
    assert d.day == 2


def test_datetime_array():
    # FIXME C# translation:
    # * len(ds) isn't translated correctly
    # * Assigning to a list doesn't translate correctly
    # * Trying to do d = d[0] also doesn't work since subscripts aren't handled
    if is_python:
        from api import date_time_array
        [ds] = date_time_array(2017, 2, 3)
        assert len(ds) == 1
        [d] = ds
        assert d.year == 2017
        assert d.month == 2
        assert d.day == 3


def test_points():
    # FIXME C# translation
    # * [ps] =
    # * len
    # * assert(all(...))
    if is_python:
        from api import points
        [ps] = points(3, 1, 2)
        assert len(ps) == 3
        assert all(p.x == 1 for p in ps)
        assert all(p.y == 2 for p in ps)


def test_tuple_of_date_times():
    # FIXME C# translation
    # * ([d1], [d2]) = ...
    if is_python:
        from api import tuple_of_date_times
        ([d1], [d2]) = tuple_of_date_times(2017, 4, 5)

        assert d1.year == 2017
        assert d1.month == 4
        assert d1.day == 5

        assert d2.year == 2018
        assert d2.month == 5
        assert d2.day == 6


def test_create_outer2():
    # FIXME C# translation
    # * [fst_i1, snd_i1] =
    if is_python:
        from api import create_outer2
        o = create_outer2(2.0, 3.0, 33.3, "foo", "bar")
        [fst_i1, snd_i1] = o.inner1s
        assert fst_i1.point.x == 2.0
        assert fst_i1.point.y == 3.0
        assert fst_i1.value == 33.3
        assert snd_i1.point.x == 2.0
        assert snd_i1.point.y == 3.0
        assert snd_i1.value == 34.3
        assert o.inner2.evenInner.value == 33.3
        assert o.string1.value == "foo"
        assert o.string2.value == "bar"


def test_typedef():
    if is_python:  # FIXME C# (function not exported)
        from api import create_typedef_foo
        create_typedef_foo(2, 3)


def test_create_date():
    from api import create_date
    d = create_date(2017, 1, 2)
    assert d.year == 2017
    assert d.month == 1
    assert d.day == 2


def test_foo():
    from api import Foo
    f = Foo(2, 3)
    assert f.toString() == "Foo(2, 3)"


def test_not_copyable():
    with pytest.raises(ImportError):
        from simple import NotCopyable
        NotCopyable(42)


def test_product():
    from wrap_all import product
    assert product(2, 3) == 6
    assert product(4, 5) == 20


def test_identity_int():
    from wrap_all import identity_int
    assert identity_int(4) == 4


def test_api_outer():
    if is_python:  # FIXME C#  (NotWrappedInner not registered)
        from api import ApiOuter, NotWrappedInner
        outer = ApiOuter(42, NotWrappedInner("foobar"))
        assert outer.value == 42
        assert outer.inner.value == "foobar"


def test_safe_pure_etc_struct():
    from structs import SafePureEtcStruct
    s = SafePureEtcStruct()
    assert s.stuff(3) == 6


def test_the_year():
    from api import the_year
    from datetime import date
    assert the_year(date(2017, 1, 1)) == 2017
    assert the_year(date(2018, 2, 3)) == 2018


def test_wrap_all_string():
    # FIXME C# translation- name clash between Structs.String and
    # Wrap_all.String, no current way to mitigate by using fully
    # qualified names here
    if is_python:
        from wrap_all import String
        assert String("foobar").s == "foobar"


def test_wrap_all_other_string_as_param():
    if is_python:  # FIXME C# (OtherString not found)
        from wrap_all import other_string_as_param, OtherString
        assert other_string_as_param(OtherString("hello ")) == "hello quux"


def test_add_with_default():
    if is_python:  # FIXME C# (NotWrappedInt isn't registered)
        from api import add_with_default, NotWrappedInt
        assert add_with_default(1, NotWrappedInt(2)) == 3
        assert add_with_default(1) == 43


def test_struct_with_private_member():
    from structs import StructWithPrivateMember

    s = StructWithPrivateMember()

    s.i = 42
    # j is private
    with pytest.raises(AttributeError):
        s.j = "oops"
    s.k = 33

    assert s.i == 42
    assert s.k == 33


def test_struct_fields():
    from structs import IntString

    obj = IntString(7, "foobar")
    assert obj.i == 7
    assert obj.s == "foobar"

    obj.i = 42
    assert obj.i == 42
    assert obj.s == "foobar"

    obj.s = "quux"
    assert obj.i == 42
    assert obj.s == "quux"


def test_property_getter():
    from structs import Getter

    g = Getter(42)
    # can't call the property function since not registered
    with pytest.raises(TypeError):
        g.i()

    assert g.i == 42


def test_property_setter():
    from structs import Setter

    s = Setter()
    # can't call the property function since not registered
    with pytest.raises(AttributeError):
        s.i(33)
    if is_python:  # FIXME C# - attribute not registered
        s.i = 33  # shouldn't throw


def test_property_getter_setter():
    from structs import GetterSetter

    obj = GetterSetter(42)

    # can't call the property function since not registered
    with pytest.raises(TypeError):
        obj.i()

    # can't call the property function since not registered
    with pytest.raises(TypeError):
        obj.i(33)

    assert obj.i == 42
    obj.i = 33  # shouldn't throw
    assert obj.i == 33


def test_enum():
    if is_pyd:  # FIXME
        with pytest.raises(ImportError):
            from wrap_all import MyEnum
    else:
        from wrap_all import MyEnum
        assert MyEnum.foo == 0
        assert MyEnum.bar == 1
        assert MyEnum.baz == 2

        with pytest.raises(AttributeError):  # no quux
            assert MyEnum.quux == 42


def test_send():
    if is_python:  # FIXME C# translation (byte literals)
        from wrap_all import mysend

        with pytest.raises(RuntimeError):
            mysend(1, 2, 3, 4)

        socket = 42
        bs = b'abc'
        if is_pynih:
            assert mysend(socket, bs, len(bs), 0) == ord('a')
            assert mysend(socket, bs, len(bs), 1) == ord('b')
            assert mysend(socket, bs, len(bs), 2) == ord('c')
        else:
            # FIXME
            with pytest.raises(AssertionError):
                assert mysend(socket, bs, len(bs), 0) == ord('a')


def test_global_int_enum():
    if is_pyd:
        with pytest.raises(ImportError):
            from wrap_all import GLOBAL_INT_ENUM
    else:
        from wrap_all import GLOBAL_INT_ENUM
        assert GLOBAL_INT_ENUM == 42


def test_global_string_enum():
    if is_pyd:
        with pytest.raises(ImportError):
            from wrap_all import GLOBAL_STRING_ENUM
    else:
        from wrap_all import GLOBAL_STRING_ENUM
        assert GLOBAL_STRING_ENUM == "quux"


def test_global_empty_string_enum():
    if is_pyd:
        with pytest.raises(ImportError):
            from wrap_all import GLOBAL_EMPTY_STRING_ENUM
    else:
        from wrap_all import GLOBAL_EMPTY_STRING_ENUM
        assert GLOBAL_EMPTY_STRING_ENUM == ""


def test_int_to_string():
    from wrap_all import int_to_string
    if is_pyd:  # FIXME
        with pytest.raises(RuntimeError):
            assert int_to_string(42) == "42"
    else:
        assert int_to_string(42) == "42"
        assert int_to_string(77) == "77"


def test_immutable_fields():
    if is_python:  # FIXME C# (ImmutableFields not found)
        from wrap_all import ImmutableFields
        i = ImmutableFields("foobar")
        if is_pyd:  # FIXME
            with pytest.raises(AttributeError):
                assert i.name == "foobar"
        else:
            assert i.name == "foobar"


def test_method_overloads():
    from structs import Overloads
    o = Overloads()
    assert o.fun(2) == 4
    assert o.fun(3) == 6
    if is_pynih:
        assert o.fun(2, 3) == 6
        assert o.fun(3, 4) == 12
    else:
        # FIXME - can't assert that raises TypeError
        # becauses otherwise we get a segfault
        pass


def test_struct_no_ctor():
    from structs import NoCtor
    if is_python:  # FIXME C# (no 3-arg ctor for NoCtor)
        s = NoCtor(42, 33.3, "foobar")
        if is_pynih:  # FIXME pyd
            assert s.i == 42
            assert s.d == 33.3
            assert s.s == 'foobar'


def test_property_getter_setter_const():
    from structs import GetterSetterConst

    obj = GetterSetterConst(42)

    if is_pynih:
        # can't call the property function since not registered as a function
        with pytest.raises(TypeError):
            obj.i()

        # can't call the property function since not registered as a function
        with pytest.raises(TypeError):
            obj.i(33)

        assert obj.i == 42

    obj.i = 33  # shouldn't throw
    if is_pynih:
        assert obj.i == 33
