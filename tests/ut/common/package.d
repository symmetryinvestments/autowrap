module ut.common;


import autowrap.common;
import unit_threaded;


@("toSnakeCase empty")
@safe pure unittest {
    static assert("".toSnakeCase == "");
}

@("toSnakeCase no caps")
@safe pure unittest {
    static assert("foo".toSnakeCase == "foo");
}

@("toSnakeCase camelCase")
@safe pure unittest {
    static assert("toSnakeCase".toSnakeCase == "to_snake_case");
}

@("toSnakeCase PascalCase")
@safe pure unittest {
    static assert("PascalCase".toSnakeCase == "pascal_case");
}

@("toSnakeCase ALLCAPS")
@safe pure unittest {
    static assert("ALLCAPS".toSnakeCase == "ALLCAPS");
}
