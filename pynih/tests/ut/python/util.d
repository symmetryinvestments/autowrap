module ut.python.util;


import unit_threaded;
import python.cooked;


@("Aggregates.stringifyTypes with templated struct")
@safe pure unittest {
    static struct Struct(T) { }
    auto aggs = Aggregates!(Struct!int, Struct!double)();
    aggs.stringifyTypes.should == "Struct!int, Struct!double";
}
