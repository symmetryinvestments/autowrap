import ast
import ir


class AstToIrVisitor(ast.NodeVisitor):
    def __init__(self):
        self.ast_depth = 0
        self.current_scope = None
        self.scope_depth = 0

    def log(self, msg):
        print(f"{self.ast_depth*' '}{msg}")

    def _visitimpl(self, node):
        self.ast_depth += 1
        ast.NodeVisitor.generic_visit(self, node)
        self.ast_depth -= 1

    def _visit_new_scope(self, node, new_scope):
        parent_scope = self.current_scope
        self.current_scope = new_scope
        self.scope_depth += 1
        self._visitimpl(node)
        assert new_scope == self.current_scope
        self.scope_depth -= 1
        self.current_scope = parent_scope

    def generic_visit(self, node):
        self.log(f"UNSUPPORTED: {type(node).__name__}")
        unsupported_node = ir.UnsupportedNode(node)
        self._visit_new_scope(node, unsupported_node)
        self.current_scope.add_unsupported_node(unsupported_node)

    def visit_Module(self, node):
        assert self.ast_depth == 0
        assert self.current_scope is None
        assert self.scope_depth == 0
        module = ir.Module()
        self._visit_new_scope(node, module)
        return module

    def visit_Import(self, node):
        assert self.current_scope
        self.log(f"visit_Import names={node.names}")
        self.current_scope.add_import(node.names)

    def visit_ImportFrom(self, node):
        assert self.current_scope
        self.log(f"visit_ImportFrom names={node.names}")
        self.current_scope.add_import_from(node.module, node.names)

    def visit_FunctionDef(self, node):
        self.log(f"visit_FunctionDef name={node.name} args={node.args}")
        assert self.current_scope
        assert self.scope_depth > 0
        parent_scope = self.current_scope
        # args, body, name, returns
        func = ir.Function(node.name)
        self._visit_new_scope(node, func)
        self.current_scope.add_function_def(func)

    def visit_Assign(self, node):
        assert self.current_scope
        self.log(f"visitAssign targets={node.targets} value={node.value}")
        # self.current_scope.add_assign(node)
        self._visitimpl(node)
