from dataclasses import dataclass
import typing


@dataclass
class AutowrapTest:
    name: str
    statements: typing.List[typing.Any]


@dataclass
class Assertion:
    lhs: typing.Any
    rhs: typing.Any


@dataclass
class Import:
    module: str
    importees: typing.List[str]


@dataclass
class FunctionCall:
    """
    A function call.
    """
    receiver: typing.Any
    args: typing.List[typing.Any]


@dataclass
class NumLiteral:
    value: int


@dataclass
class StringLiteral:
    value: str


@dataclass
class BytesLiteral:
    value: bytes


@dataclass
class Assignment:
    lhs: typing.Any
    rhs: typing.Any


@dataclass
class Sequence:
    value: typing.List[typing.Any]


@dataclass
class IfPyd:
    block: typing.List[typing.Any]


@dataclass
class IfPynih:
    block: typing.List[typing.Any]


@dataclass
class ShouldThrow:
    exception: str
    block: typing.List[typing.Any]


@dataclass
class Attribute:
    instance: typing.Any
    attribute: typing.Any
