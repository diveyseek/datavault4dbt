{% macro yaml_metadata_parser(name=none, yaml_metadata=none, parameter=none, required=False, documentation=none) %}

    {% if datavault4dbt.is_something(yaml_metadata) %}
        {%- set yaml_metadata = fromyaml(yaml_metadata) -%}
        {% if name in yaml_metadata.keys() %}
            {% set return_value = yaml_metadata.get(name) %}
        {% elif datavault4dbt.is_something(parameter) %}
            {% set return_value = parameter %}

            {% if required %}
                {% do exceptions.warn("[" ~ this ~ "] Warning: yaml-metadata given, but parameter '" ~ name ~ "' not defined in there. Using '" ~ name ~ "' parameter defined outside. We advise to use only one method of parameter passing.") %}
            {% else %}

        {% elif required %}
            {{ exceptions.raise_compiler_error("[" ~ this ~ "] Error: yaml-metadata given, but required parameter '" ~ name ~ "' not defined in there or outside in the parameter. \n Description of parameter '" ~ name ~ "': \n" ~ documentation ) }}
        {% endif %}
    {% elif datavault4dbt.is_something(parameter) %}
        {% set return_value = parameter %}
    {% elif required %}
        {{ exceptions.raise_compiler_error("[" ~ this ~ "] Error: Required parameter '" ~ name ~ "' not defined. Define it either directly, or inside yaml-metadata. \n Description of parameter '" ~ name ~ "': \n" ~ documentation ) }}
    {% else %}
        {% set return_value = None %}
    {% endif %}

    {{ return(return_value) }}

{% endmacro %}