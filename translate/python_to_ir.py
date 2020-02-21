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
        print(f"to-ir TODO: pytest node {type(node)}")

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

    def visit_Assign(self, node):
        from ir import Assignment

        assert len(node.targets), "Cannot handle multiple assignment targets"

        lhs_node = node.targets[0]
        rhs_node = node.value
        lhs = _run_visitor(lhs_node, ExpressionVisitor)
        rhs = _run_visitor(rhs_node, ExpressionVisitor)

        self.value.append(Assignment(lhs, rhs))

    def visit_If(self, node):
        from ir import IfPyd, IfPynih, IfPython
        from ast import Name

        is_name = type(node.test) == Name

        if is_name:
            if node.test.id == 'is_pyd':
                klass = IfPyd
            elif node.test.id == 'is_pynih':
                klass = IfPynih
            elif node.test.id == 'is_python':
                klass = IfPython
            else:
                raise Exception("Cannot handle ifs that aren't is_pyd or is_pynih")
        else:
            raise Exception("Cannot handle ifs that aren't is_pyd or is_pynih")

        statements = [_run_visitor(x, PyTestVisitor) for x in node.body]
        flat_statements = _flatten(statements)

        self.value.append(klass(flat_statements))

    def visit_Pass(self, node):
        pass

    def visit_Call(self, node):
        self.value.append(_run_visitor(node, ExpressionVisitor))

    def visit_With(self, node):
        from ir import ShouldThrow
        from ast import Call, Attribute

        assert len(node.items) == 1, \
            "Cannot handle with block with more than one item"

        context = node.items[0].context_expr

        is_call = type(context) == Call
        is_call_attr = is_call and type(context.func) == Attribute
        is_pytest_raises = \
            is_call_attr \
            and context.func.value.id == 'pytest' \
            and context.func.attr == 'raises'
        if is_pytest_raises:
            assert len(context.args) == 1, \
                "Can only handle one arg for pytest.raises"
            exception = context.args[0].id

        msg = "Cannot handle with blocks that aren't pytest exception checks"
        if not is_pytest_raises:
            raise Exception(msg)

        nested_statements = [_run_visitor(x, PyTestVisitor) for x in node.body]
        flat_statements = _flatten(nested_statements)

        self.value.append(ShouldThrow(exception, flat_statements))


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
            print(f"ERROR: ExpressionVisitor cannot handle node {dump(node)}")
        except TypeError:
            print(f"ERROR: ExpressionVisitor cannot handle non-node {node}")

    def visit_Attribute(self, node):
        from ir import Attribute
        instance = _run_visitor(node.value, ExpressionVisitor)
        attribute = node.attr
        self.value = Attribute(instance, attribute)

    def visit_Constant(self, node):
        from ir import NumLiteral, StringLiteral, BytesLiteral

        value = node.value
        if type(value) == int or type(value) == float:
            self.value = NumLiteral(value)
        elif type(value) == str:
            self.value = StringLiteral(value)
        elif type(value) == bytes:
            self.value = BytesLiteral(value)
        else:
            raise Exception(
                f"Cannot handle constant of type {type(value)} {value}")

    def visit_Call(self, node):
        from ir import FunctionCall

        receiver = _run_visitor(node.func, ExpressionVisitor)
        args = [_run_visitor(x, ExpressionVisitor) for x in node.args]

        self.value = FunctionCall(receiver, args)

    def visit_Name(self, node):
        self.value = node.id

    def visit_List(self, node):
        from ir import Sequence
        elts = [_run_visitor(x, ExpressionVisitor) for x in node.elts]
        self.value = Sequence(elts)

    def visit_Tuple(self, node):
        self.visit_List(node)


def _flatten(list_of_lists):
    from itertools import chain
    return list(chain.from_iterable(list_of_lists))
