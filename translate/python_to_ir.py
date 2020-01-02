from ir import AutowrapTest, Assertion
from ast import NodeVisitor


def transform(source_code):
    from ast import parse
    tree = parse(source_code)
    visitor = ModuleVisitor()
    visitor.visit(tree)
    return visitor.tests


class ModuleVisitor(NodeVisitor):

    def __init__(self):
        self.tests = []

    def visit_FunctionDef(self, node):
        if not node.name.startswith('test_'):
            return

        statements = function_to_statements(node)
        self.tests.append(AutowrapTest(node.name, statements))


def function_to_statements(node):
    visitor = PyTestVisitor()
    visitor.visit(node)
    return visitor.statements


class PyTestVisitor(NodeVisitor):
    def __init__(self):
        self.statements = []

    def visit_Assert(self, node):
        try:
            self.statements.append(node_to_assertion(node))
        except:
            # FIXME
            pass


def node_to_assertion(node):
    visitor = AssertionVisitor()
    visitor.visit(node.test)
    return visitor.assertion


class AssertionVisitor(NodeVisitor):
    def visit_Compare(self, node):
        self.assertion = Assertion(node.left.value, node.comparators[0].value)
