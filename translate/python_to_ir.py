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

        statements = _run_visitor(node, PyTestVisitor)
        self.tests.append(AutowrapTest(node.name, statements))


def _run_visitor(node, klass):
    visitor = klass()
    visitor.visit(node)
    return visitor.value


class PyTestVisitor(NodeVisitor):
    def __init__(self):
        self.value = []

    def generic_visit(self, node):
        print(f"TODO: pytest node {type(node)}")

    def visit_FunctionDef(self, node):
        for statement in node.body:
            self.visit(statement)

    def visit_Assert(self, node):
        self.value.append(_run_visitor(node.test, AssertionVisitor))

    def visit_ImportFrom(self, node):
        from ir import Import

        for name in node.names:
            assert name.asname is None, "Cannot yet handle as name"

        self.value.append(Import(node.module,
                                 [x.name for x in node.names]))

    def visit_Expr(self, node):
        self.visit(node.value)


class AssertionVisitor(NodeVisitor):

    def visit_Compare(self, node):
        from ast import dump
        from ir import Assertion

        assert len(node.comparators) == 1, "Can only handle one comparator"

        lhs_value = _run_visitor(node.left, ExpressionVisitor)

        rhs = node.comparators[0]
        rhs_value = _run_visitor(rhs, ExpressionVisitor)
        if rhs_value is None:
            print(f"Cannot handle rhs {dump(rhs)}")

        self.value = Assertion(lhs_value, rhs_value)


class ExpressionVisitor(NodeVisitor):

    value = None

    def generic_visit(self, node):
        from ast import dump
        try:
            print(f"ERROR: ExpressionVisitor cannot handle {dump(node)}")
        except TypeError:
            print(f"ERROR: ExpressionVisitor cannot handle {node}")

    def visit_Attribute(self, node):
        value = _run_visitor(node.value, ExpressionVisitor)
        self.value = f"{value}.{node.attr}"

    def visit_Constant(self, node):
        self.value = node.value

    def visit_Call(self, node):

        func_name = _run_visitor(node.func, ExpressionVisitor)
        # hacky way to determine whether a function is a constructor
        is_ctor = func_name[0].isupper()
        func_expr = 'new ' + func_name if is_ctor else func_name

        arg_strings = [_run_visitor(x, ExpressionVisitor) for x in node.args]
        args = ", ".join(str(x) for x in arg_strings)

        self.value = f"{func_expr}({args})"

    def visit_Name(self, node):
        self.value = node.id
