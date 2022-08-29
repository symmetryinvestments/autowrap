module ut.issues;


@("24")
@safe pure unittest {
    import autowrap.types: Module;
    import autowrap.reflection: AllFunctions, AllAggregates;
    import std.typecons: Yes;
    import std.traits: fullyQualifiedName;
    import std.meta: staticMap, AliasSeq;

    alias functions = AllFunctions!(Module("not_public", Yes.alwaysExport));
    enum FunctionName(alias F) = fullyQualifiedName!(F.symbol);
    alias functionNames = staticMap!(FunctionName, functions);
    static assert(functionNames == AliasSeq!("not_public.fun0"));

    alias aggregates = AllAggregates!(Module("not_public", Yes.alwaysExport));
    alias aggNames = staticMap!(fullyQualifiedName, aggregates);
    static assert(aggNames == AliasSeq!("not_public.Public"));
}
