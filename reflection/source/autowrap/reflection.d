module autowrap.reflection;

import std.meta: allSatisfy;

private alias I(alias T) = T;
private enum isString(alias T) = is(typeof(T) == string);

template AllFunctions(ModuleNames...) if(allSatisfy!(isString, ModuleNames)) {
    import std.meta: staticMap;
    alias AllFunctions = staticMap!(Functions, ModuleNames);
}

template Functions(string moduleName) {
    mixin(`import module_ = ` ~ moduleName ~ `;`);
    alias Functions = Functions!module_;
}

template Functions(alias module_) if(!is(typeof(module_) == string)) {

    import std.meta: Filter, staticMap;

    template Function(string memberName) {
        static if(__traits(compiles, I!(__traits(getMember, module_, memberName)))) {
            alias member = I!(__traits(getMember, module_, memberName));
            static if(isExportFunction!member)
                alias Function = member;
            else
                alias Function = void;
        } else
            alias Function = void;
    }

    template notVoid(A...) if(A.length == 1) {
        alias T = A[0];
        enum notVoid = !is(T == void);
    }

    alias Functions = Filter!(notVoid, staticMap!(Function, __traits(allMembers, module_)));
}


private template isExportFunction(alias F) {
    import std.traits: isFunction;

    version(AutowrapAlwaysExport) {
        enum linkage = __traits(getLinkage, F);
        enum isExportFunction = isFunction!F && linkage != "C" && linkage != "C++";
    } else
        enum isExportFunction = isFunction!F && __traits(getProtection, F) == "export";
}
