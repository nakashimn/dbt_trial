{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if (custom_schema_name is none) -%}
        {{ default_schema }}
    {%- else -%}
        {%- if (target.name == "prod") or (target.name == "stg") -%}
            {{ custom_schema_name | trim }}
        {%- else -%}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro %}
