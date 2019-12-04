import os
import pytest

is_pyd = os.environ.get('PYD')
is_pynih = os.environ.get('PYNIH')


def test_std_socket_protocol():
    if is_pyd:
        with pytest.raises(ImportError):
            from phobos import Protocol
    else:
        from phobos import Protocol, ProtocolType

        protocol = Protocol()
        assert protocol.getProtocolByType(ProtocolType.TCP)

        assert protocol.name == "tcp"
        assert protocol.aliases == ["TCP"]
