import autowrap;
import std.meta;


enum moduleNames = AliasSeq!(
    "std.math",
    "std.math.algebraic",
    "std.math.constants",
    "std.math.exponential",
    "std.math.hardware",
    "std.math.operations",
    "std.math.remainder",
    "std.math.rounding",
    "std.math.traits",
    "std.math.trigonometry",
);


enum toModule(string id) = Module(id, Yes.alwaysExport, Ignore("rndtonl"));
enum modules = Modules(staticMap!(toModule, moduleNames));

enum str = wrapDlang!(LibraryName("std_math"), modules);
//pragma(msg, str);
mixin(str);
