module ut.pynih.python.util;


import unit_threaded;
import autowrap.pynih.python.cooked;


@("Aggregates.stringifyTypes with templated struct")
@safe pure unittest {
    import autowrap.pynih.python.boilerplate: Aggregates;
    static struct Struct(T) { }
    auto aggs = Aggregates!(Struct!int, Struct!double)();
    aggs.stringifyTypes.should == "Struct!int, Struct!double";
}
