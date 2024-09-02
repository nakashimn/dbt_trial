
////////////////////////////////////////////////////////////////////////////////
// test for equality in production and staging
////////////////////////////////////////////////////////////////////////////////
{% test is_equal_in_prod_and_stg(model, ignore_cols=[], evaluate_order=false) %}

    {% if execute %}
        {{ log("target_model: " ~ model.database ~ "." ~ model.schema ~ "." ~ model.name, info=true) }}

        // 比較対象のデータベースを定義
        {% set ref_db_name = "production" %}
        {% set tgt_db_name = model.database %}

        // カラム名取得
        {% set colnames = get_colnames(model.database, model.schema, model.name) %}

        // ignore_colsを除外
        {% set ignore_cols_upper = ignore_cols | map('upper') | list %}
        {% set target_cols = colnames | reject('in', ignore_cols_upper) | list %}
        {% set str_target_cols = target_cols | join(', ') %}
        {{ log("column_names: " ~ target_cols, info=true) }}

        // 順序比較の有無切替
        {% if evaluate_order %}
            {% set str_evaluate_order = "" %}
        {% else %}
            {% set str_evaluate_order = "order by " ~ str_target_cols %}
        {% endif %}

        // テーブルの一致をハッシュ値で評価
        with
        reference as (
            select
                hash_agg({{ str_target_cols }})
            from
                {{ ref_db_name }}.{{ model.schema }}.{{ model.name }}
            {{ str_evaluate_order }}
        ),
        target as (
            select
                hash_agg({{ str_target_cols }})
            from
                {{ tgt_db_name }}.{{ model.schema }}.{{ model.name }}
            {{ str_evaluate_order }}
        ),
        diff as (
            select * from reference
            except
            select * from target
        )
        select
            *
        from
            diff
    {% endif %}

{% endtest %}
