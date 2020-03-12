/**
   Entry point for the contract tests
 */
module contract.main;

import python.raw: PyDateTime_CAPI;

// To avoid linker errors.
export __gshared extern(C) PyDateTime_CAPI* PyDateTimeAPI;


extern(C) export auto PyInit_contract() {
    static import contract.scalars;
    static import contract.udt;
    static import contract.pyclass;
    import python.raw: pyDateTimeImport;
    import python.cooked: createModule;
    import python.boilerplate: Module, CFunctions, Aggregates;
    import core.runtime: rt_init;

    rt_init;

    pyDateTimeImport;

    return createModule!(
        Module("contract"),
        CFunctions!(
            contract.scalars.always_none,
            contract.scalars.the_answer,
            contract.scalars.one_bool_param_to_not,
            contract.scalars.one_int_param_to_times_two,
            contract.scalars.one_double_param_to_times_three,
            contract.scalars.one_string_param_to_length,
            contract.scalars.one_string_param_to_string,
            contract.scalars.one_string_param_to_string_manual_mem,
            contract.scalars.one_list_param,
            contract.scalars.one_tuple_param,
            contract.scalars.one_range_param,
            contract.scalars.one_list_param_to_list,
            contract.scalars.one_dict_param,
            contract.scalars.one_dict_param_to_dict,
            contract.scalars.add_days_to_date,
            contract.scalars.add_days_to_datetime,
            contract.scalars.throws_runtime_error,
            contract.scalars.kwargs_count,

            contract.udt.simple_struct_func,
            contract.udt.twice_struct_func,
            contract.udt.struct_getset,

            contract.pyclass.pyclass_int_double_struct,
            contract.pyclass.pyclass_string_list_struct,
            contract.pyclass.pyclass_twice_struct,
            contract.pyclass.pyclass_thrice_struct,
            contract.pyclass.pyclass_void_struct,
        ),
        Aggregates!(
            contract.udt.StructDefaultCtor,
            contract.udt.StructUserCtor,
        ),
    );
}
