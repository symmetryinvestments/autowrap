from dataclasses import dataclass
import typing


@dataclass
class ImportedSymbol:
    name: str
    alias: str


@dataclass
class Import:
    module: ImportedSymbol
    symbols: typing.List[ImportedSymbol]


# base class for nodes that hold code and/or symbol decls
# i.e. module/function
class Scope:
    def __init__(self):
        super(Scope, self).__init__()
        self.imports = []
        self.nodes = []

    def add_unsupported_node(self, node):
        assert isinstance(node, UnsupportedNode)
        self.nodes.append(node)

    def add_import(self, modules):
        self.imports.append(
            [ImportedSymbol(n.name, n.asname) for n in modules])

    def add_import_from(self, module, names):
        self.imports.append(
            Import(ImportedSymbol(module, None),
                   [ImportedSymbol(n.name, n.asname) for n in names]))

    def add_function_def(self, func):
        assert isinstance(func, Function)
        self.nodes.append(func)


class Module(Scope):
    def __init__(self):
        super(Module, self).__init__()

    def accept(self, visitor):
        visitor.visit_Module(self)


class Function(Scope):
    def __init__(self, name):
        super(Function, self).__init__()
        self.name = name

    def accept(self, visitor):
        visitor.visit_Function(self)


class UnsupportedNode(Scope):
    def __init__(self, ast_node):
        super(UnsupportedNode, self).__init__()
        self.ast_node = ast_node

    def accept(self, visitor):
        visitor.visit_UnsupportedNode(self)


class IrVisitor:
    def visit(self, node):
        node.accept(self)
