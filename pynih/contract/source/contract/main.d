module contract.main;

import python;
import contract.scalars;
import contract.udt;
import contract.pyclass;

mixin(
    createModuleMixin!(
        Module("contract"),
        CFunctions!(
            always_none,
            the_answer,
            one_bool_param_to_not,
            one_int_param_to_times_two,
            one_double_param_to_times_three,
            one_string_param_to_length,
            one_string_param_to_string,
            one_string_param_to_string_manual_mem,
            one_list_param,
            one_tuple_param,
            one_range_param,
            one_list_param_to_list,
            one_dict_param,
            one_dict_param_to_dict,
            add_days_to_date,
            add_days_to_datetime,
            throws_runtime_error,
            kwargs_count,

            simple_struct_func,
            twice_struct_func,
            struct_getset,

            pyclass_int_double_struct,
            pyclass_string_list_struct,
            pyclass_twice_struct,
            pyclass_thrice_struct,
            pyclass_void_struct,
        ),
        Aggregates!(
            StructDefaultCtor,
            StructUserCtor,
        ),
    )
);
