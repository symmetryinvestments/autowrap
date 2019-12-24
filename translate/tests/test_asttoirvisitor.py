#!/usr/bin/env python3
import unittest
import ast
from asttoirvisitor import AstToIrVisitor


class AstToIrVisitorTestCase(unittest.TestCase):
    def test_ir_visitor(self):
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
        module = AstToIrVisitor().visit(test_ast)


if __name__ == '__main__':
    unittest.main()
