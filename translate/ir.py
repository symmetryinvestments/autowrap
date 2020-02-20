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

    def translate(self, writer):

        def stringify(value):
            """
            Transform value into a string
            """
            if isinstance(value, str):
                return '"' + value + '"'
            else:
                return str(value)

        actual = self.lhs
        expected = stringify(self.rhs)
        writer.writeln(
            f"// Assert.AreEqual({(expected)}, {actual});")


@dataclass
class Import:
    module: str
    importees: typing.List[str]

    def translate(self, writer):
        # nothing to do here since imports from Python have to become top-level
        # using declarations in C#
        pass
