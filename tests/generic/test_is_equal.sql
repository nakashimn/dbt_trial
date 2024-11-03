
////////////////////////////////////////////////////////////////////////////////
// test for equality in production and staging
////////////////////////////////////////////////////////////////////////////////
{% test is_equal_in_prod_and_stg(model, ignore_cols=[], evaluate_order=false, reference_db="production") %}

    {% if execute %}
        {{ log("target_model: " ~ model.database ~ "." ~ model.schema ~ "." ~ model.name, info=true) }}

        // 比較対象のデータベースを定義
        {% set ref_db_name = reference_db %}
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
            {% set str_evaluate_order = "ORDER BY " ~ str_target_cols %}
        {% endif %}

        // テーブルの一致をハッシュ値で評価
        WITH
        reference AS (
            SELECT
                hash_agg({{ str_target_cols }})
            FROM
                {{ ref_db_name }}.{{ model.schema }}.{{ model.name }}
            {{ str_evaluate_order }}
        ),
        target AS (
            SELECT
                hash_agg({{ str_target_cols }})
            FROM
                {{ tgt_db_name }}.{{ model.schema }}.{{ model.name }}
            {{ str_evaluate_order }}
        ),
        diff AS (
            SELECT * FROM reference
            EXCEPT
            SELECT * FROM target
        )
        SELECT * FROM diff
    {% endif %}

{% endtest %}
