import ast
from asttoirvisitor import AstToIrVisitor


def test_ir_visitor():
    test_ast = ast.parse("""
import a
import a as b
import a as b, c
import a as b, c as d
from a import b
from a import b as c
from a import b as c, d
from a import b as c, d as e
from a import b as c, d as e, f
from a import b as c, d as e, f as g

def foo():
    return 0
""")
    #  only verifies that no exceptions are raised
    AstToIrVisitor().visit(test_ast)
