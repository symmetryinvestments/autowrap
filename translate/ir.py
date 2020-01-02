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
