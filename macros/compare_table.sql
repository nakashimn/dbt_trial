////////////////////////////////////////////////////////////////////////////////
// テーブルの変更前後の差分抽出
// USAGE:
//  > dbt run-operation extract_diff --args "{schema_name: <schema>, table_name: <table>, primary_keys: [<primary_key>, ...], ignore_cols: [<ignore_cols>, ...]}"
////////////////////////////////////////////////////////////////////////////////
{% macro extract_diff(schema_name, table_name, primary_keys, ignore_cols=[], reference_db="production", target_db="staging", output_db="development", print_query=false) %}

    {{ print("[extract diff]") }}

    {% set ref_db_name = reference_db %}
    {% set tgt_db_name = target_db %}
    {% set dst_db_name = output_db %}
    {% set ref_schema_name = schema_name %}
    {% set tgt_schema_name = schema_name %}
    {% set dst_schema_name = schema_name %}

    {% set ref_table = ref_db_name ~ "." ~ ref_schema_name ~ "." ~ table_name %}
    {% set tgt_table = tgt_db_name ~ "." ~ tgt_schema_name ~ "." ~ table_name %}
    {% set dst_tran_table = dst_db_name ~ "." ~ dst_schema_name ~ ".diff_" ~ table_name %}
    {% set primary_keys_upper = translate_upper_on_list(primary_keys) %}
    {% set str_primary_keys = primary_keys | join(", ") %}
    {% set str_ignore_cols = ignore_cols | join(", ") %}

    {{ print("=============================================================") }}
    {{ print("reference: " ~ ref_table) }}
    {{ print("target: " ~ tgt_table) }}
    {{ print("destination: " ~ dst_tran_table) }}
    {{ print("=============================================================") }}
    {{ print("primary_keys: " ~ str_primary_keys) }}
    {{ print("ignore_columns: " ~ str_ignore_cols) }}

    // カラム名取得
    {% set ref_cols = get_cols(ref_db_name, ref_schema_name, table_name, ignore_cols) %}
    {% set tgt_cols = get_cols(tgt_db_name, tgt_schema_name, table_name, ignore_cols) %}
    {% set str_tgt_cols = tgt_cols | join(", ") %}
    {{ print("target_columns: " ~ str_tgt_cols) }}
    {{ print("=============================================================") }}

    // カラムの一致確認
    {% if not validate_cols(ref_cols, tgt_cols) %}
        {{ print(red_text("[Error] Columns have any mismatch.")) }}
        {{ return(false) }}
    {% endif %}

    // 比較用のsuffix付与
    {% set ref_cols_alias = get_cols_alias_query(tgt_cols, "REF", primary_keys) %}
    {% set tgt_cols_alias = get_cols_alias_query(tgt_cols, "TGT", primary_keys) %}

    // 差分テーブルのカラム定義
    {% set ref_aliased_cols = get_aliased_cols(tgt_cols, "REF", primary_keys) %}
    {% set tgt_aliased_cols = get_aliased_cols(tgt_cols, "TGT", primary_keys) %}
    {% set diff_cols = primary_keys + ((ref_aliased_cols + tgt_aliased_cols) | sort) %}
    {% set str_diff_cols = diff_cols | join(", ") %}

    // 差分テーブル(diff_*)作成
    {% set create_diff_table %}
        CREATE OR REPLACE TRANSIENT TABLE {{ dst_tran_table }} AS
        WITH
        ref AS (
            SELECT {{ str_tgt_cols }} FROM {{ ref_table }}
        ),
        tgt AS (
            SELECT {{ str_tgt_cols }} FROM {{ tgt_table }}
        ),
        ref_only AS (
            SELECT * FROM ref
            EXCEPT
            SELECT * FROM tgt
        ),
        tgt_only AS (
            SELECT * FROM tgt
            EXCEPT
            SELECT * FROM ref
        ),
        aliased_ref_only AS (
            SELECT {{ ref_cols_alias }} FROM ref_only
        ),
        aliased_tgt_only AS (
            SELECT {{ tgt_cols_alias }} FROM tgt_only
        ),
        diff AS (
            SELECT
                {{ str_diff_cols }}
            FROM
                aliased_ref_only
            FULL OUTER JOIN
                aliased_tgt_only
            USING
                ({{ str_primary_keys }})
        )
        SELECT * FROM diff
    {% endset %}

    // 実行クエリ表示(DEBUG用)
    {% if print_query %}
        {{ print(create_diff_table) }}
    {% endif %}

    // クエリ実行
    {% do run_query(create_diff_table) %}

    // 差分ありレコード件数表示
    {% set n_diffs = count_rows(dst_tran_table) %}
    {% if n_diffs is none %}
        {{ print(red_text("[Error] Failed to create \"" ~ dst_tran_table ~ "\".")) }}
    {% elif n_diffs > 0 %}
        {{ print("Transient table \"" ~ dst_tran_table ~ "\" is created.") }}
        {{ print(red_text("\"" ~ table_name ~ "\" has " ~ n_diffs ~ " diffs.")) }}
    {% else %}
        {{ print("Transient table \"" ~ dst_tran_table ~ "\" is created.") }}
        {{ print("\"" ~ table_name ~ "\" has No diff.") }}
    {% endif %}

{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// リスト内の文字列を大文字に変換
////////////////////////////////////////////////////////////////////////////////
{% macro translate_upper_on_list(tgt_list) %}
    {% set list_upper = tgt_list | map("upper") | list %}
    {{ return(list_upper) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// カラム名のリスト取得
////////////////////////////////////////////////////////////////////////////////
{% macro get_cols(db_name, schema_name, table_name, ignore_cols) %}
    {% set get_cols %}
        SELECT
            column_name
        FROM
            {{ db_name }}.information_schema.columns
        WHERE
            table_schema = '{{ schema_name | upper }}'
        AND
            table_name = '{{ table_name | upper }}'
    {% endset %}
    {% set result = run_query(get_cols) %}

    {% set ignore_cols_upper = translate_upper_on_list(ignore_cols) %}
    {% set cols = result.rows | map(attribute=0) | reject('in', ignore_cols_upper) | list %}
    {{ return(cols) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// suffix付与クエリ生成
////////////////////////////////////////////////////////////////////////////////
{% macro get_cols_alias_query(cols, suffix, primary_keys) %}
    {% set primary_keys_upper = translate_upper_on_list(primary_keys) %}
    {% set col_aliases = [] %}
    {% for col in cols %}
        {% if col in primary_keys_upper %}
            {% do col_aliases.append(col) %}
        {% else %}
            {% do col_aliases.append(col ~ " AS " ~ col ~ "_" ~ suffix ) %}
        {% endif %}
    {% endfor %}
    {{ return(col_aliases | join(", ")) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// suffix付カラム名取得
////////////////////////////////////////////////////////////////////////////////
{% macro get_aliased_cols(cols, suffix, primary_keys) %}
    {% set primary_keys_upper = translate_upper_on_list(primary_keys) %}
    {% set aliased_cols = [] %}
    {% for col in cols %}
        {% if col not in primary_keys_upper %}
            {% do aliased_cols.append(col ~ "_" ~ suffix ) %}
        {% endif %}
    {% endfor %}
    {{ return(aliased_cols) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// 変更前後のカラム一致確認
////////////////////////////////////////////////////////////////////////////////
{% macro validate_cols(ref_cols, tgt_cols) %}
    {% for item in tgt_cols %}
        {% if item not in ref_cols %}
            {{ return(false) }}
        {% endif %}
    {% endfor %}
    {{ return(true) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// カラム数取得
////////////////////////////////////////////////////////////////////////////////
{% macro count_rows(table_name) %}
    {% set result = run_query("SELECT COUNT(*) FROM " ~ table_name) %}
    {% if not result %}
        {{ return(none) }}
    {% endif %}
    {% set n_diffs = result.rows[0][0] %}
    {{ return(n_diffs) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// 赤文字修飾
////////////////////////////////////////////////////////////////////////////////
{% macro red_text(txt) %}
    {{ return("\033[1;31m" ~ txt ~ "\033[0m")}}
{% endmacro %}
