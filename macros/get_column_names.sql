////////////////////////////////////////////////////////////////////////////////
// Table, Viewのカラム名を取得する
////////////////////////////////////////////////////////////////////////////////
{% macro get_colnames(db_name, schema_name, model_name) %}

    {% set query %}
        select
            column_name
        from
            {{ db_name }}.information_schema.columns
        where
            table_catalog = '{{ db_name | upper }}'
        and
            table_schema = '{{ schema_name | upper }}'
        and
            table_name = '{{ model_name | upper }}'
    {% endset %}


    {% set result = run_query(query) %}
    {% set col = result.columns[0].values() %}

    {{ return(col) }}

{% endmacro %}
