from ast import NodeVisitor


def transform(source_code):
    from ast import parse
    visitor = ModuleVisitor()
    visitor.visit(parse(source_code))
    return visitor.tests


class ModuleVisitor(NodeVisitor):

    def __init__(self):
        self.tests = []

    def visit_FunctionDef(self, node):
        from ir import AutowrapTest

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

    def generic_visit(self, node):
        print(f"TODO: pytest node {type(node)}")

    def visit_FunctionDef(self, node):
        for statement in node.body:
            self.visit(statement)

    def visit_Assert(self, node):
        self.statements.append(node_to_assertion(node))

    def visit_ImportFrom(self, node):
        from ir import Import

        for name in node.names:
            assert name.asname is None, "Cannot yet handle as name"

        self.statements.append(Import(node.module,
                                      [x.name for x in node.names]))

    def visit_Expr(self, node):
        self.visit(node.value)


def node_to_assertion(node):
    visitor = AssertionVisitor()
    visitor.visit(node.test)
    return visitor.value


class AssertionVisitor(NodeVisitor):

    def visit_Compare(self, node):
        from ast import dump
        from ir import Assertion

        lhs = node.left
        lhs_visitor = ExpressionVisitor()
        lhs_visitor.visit(lhs)

        assert len(node.comparators) == 1, "Can only handle one comparator"
        rhs = node.comparators[0]
        rhs_visitor = ExpressionVisitor()
        rhs_visitor.visit(rhs)
        if rhs_visitor.value is None:
            print(f"Cannot handle rhs {dump(rhs)}")

        self.value = Assertion(lhs_visitor.value, rhs_visitor.value)


class ExpressionVisitor(NodeVisitor):

    value = None

    def generic_visit(self, node):
        from ast import dump
        try:
            print(f"ERROR: ExpressionVisitor cannot handle {dump(node)}")
        except TypeError:
            print(f"ERROR: ExpressionVisitor cannot handle {node}")

    def visit_Attribute(self, node):
        value_visitor = ExpressionVisitor()
        value_visitor.visit(node.value)
        self.value = f"{value_visitor.value}.{node.attr}"

    def visit_Constant(self, node):
        self.value = node.value

    def visit_Call(self, node):

        func_visitor = ExpressionVisitor()
        func_visitor.visit(node.func)

        # hacky way to determine whether a function is a constructor
        func_name = func_visitor.value
        is_ctor = func_name[0].isupper()
        func_expr = 'new ' + func_name if is_ctor else func_name

        arg_strings = []
        for arg in node.args:
            arg_visitor = ExpressionVisitor()
            arg_visitor.visit(arg)
            arg_strings.append(arg_visitor.value)

        args = ", ".join(str(x) for x in arg_strings)

        self.value = f"{func_expr}({args})"

    def visit_Name(self, node):
        self.value = node.id
