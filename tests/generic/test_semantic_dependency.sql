////////////////////////////////////////////////////////////////////////////////
// test for references
////////////////////////////////////////////////////////////////////////////////
{% test has_permitted_dependencies(model, depend_on=[]) %}

    {% if execute %}
        {{ log("target_model: " ~ model.database ~ "." ~ model.schema ~ "." ~ model.name, info=true) }}

        // 許可されている依存先の構文化処理
        {% set permitted_schema_to_depend_on = [] %}
        {% for schema in depend_on %}
            {% do permitted_schema_to_depend_on.append("'" ~ schema | upper ~ "'") %}
        {% endfor %}
        {{ log(permitted_schema_to_depend_on, info=true) }}

        // 依存先評価
        with
        referenced_schemas as (
            select
                distinct referenced_schema
            from
                snowflake.account_usage.object_dependencies
            where
                referencing_database = '{{ model.database | upper }}'
            and
                referencing_schema = '{{ model.schema | upper }}'
        )
        select
            *
        from
            referenced_schemas
        where
            referenced_schema not in ( {{ permitted_schema_to_depend_on | join(",") }} )
    {% endif %}

{% endtest %}
