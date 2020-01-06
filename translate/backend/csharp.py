class Writer:
    def __init__(self, out_file):
        self.out_file = out_file
        self.indent_level = 0

    def writeln(self, line):
        self.out_file.write(f"{self.indent_level * 4 * ' '}{line}\n")

    def open_block(self):
        self.writeln("{")
        self.indent_level += 1

    def close_block(self):
        self.indent_level -= 1
        self.writeln("}")


def translate(source_code, filename):
    from python_to_ir import transform
    tests = transform(source_code)
    with open(filename, "w") as file:
        writer = Writer(file)
        writer.writeln("// this file is autogenerated, do not modify by hand")
        writer.writeln('using Microsoft.VisualStudio.TestTools.UnitTesting;')

        # we use the fully-qualified names to avoid name-collisions
        # with the symbols from the test
        writer.writeln(
            "[Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]")
        writer.writeln("public class TestMain")
        writer.open_block()

        for test in tests:
            translate_test(writer, test)

        writer.close_block()


def translate_test(writer, test):
    from ir import Assertion

    writer.writeln(
        f"[Microsoft.VisualStudio.TestTools.UnitTesting.TestMethod]")
    writer.writeln(f"public void {test.name}()")
    writer.open_block()
    for statement in test.statements:
        if isinstance(statement, Assertion):
            writer.writeln(
                f"// Assert.AreEqual({statement.rhs}, {statement.lhs});")
        else:
            writer.writeln(f"// TODO: translate {statement}")
    writer.close_block()