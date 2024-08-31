////////////////////////////////////////////////////////////////////////////////
// テーブルの変更前後の差分抽出
////////////////////////////////////////////////////////////////////////////////
{% macro extract_diff(schema_name, table_name, primary_keys, ignore_cols=[]) %}

    {{ print("[extract diff]") }}

    {% set reference_db_name = "production" %}
    {% set target_db_name = "development" %}
    {% set reference_schema_name = schema_name %}
    {% set target_schema_name = target.schema ~ "_" ~ schema_name %}

    {% set reference_table = reference_db_name ~ "." ~ reference_schema_name ~ "." ~ table_name %}
    {% set target_table = target_db_name ~ "." ~ target_schema_name ~ "." ~ table_name %}
    {% set output_tran_table = target_db_name ~ "." ~ target_schema_name ~ ".diff_" ~ table_name %}
    {% set primary_keys_upper = translate_upper_on_list(primary_keys) %}
    {% set str_primary_keys = primary_keys | join(", ") %}
    {% set str_ignore_cols = ignore_cols | join(", ") %}

    {{ print("=============================================================") }}
    {{ print("reference: " ~ reference_table) }}
    {{ print("target: " ~ target_table) }}
    {{ print("output: " ~ output_tran_table) }}
    {{ print("=============================================================") }}
    {{ print("primary_keys: " ~ str_primary_keys) }}
    {{ print("ignore_cols: " ~ str_ignore_cols) }}

    // 変更前(reference)のカラム名取得
    {% set reference_col_list = get_col_name_list(reference_db_name, reference_schema_name, table_name, ignore_cols) %}
    {% set reference_cols = reference_col_list | join(", ") %}
    {% set reference_cols_alias = get_col_name_alias_string(reference_col_list, "ref", primary_keys) %}

    // 変更後(target)のカラム名取得
    {% set target_col_list = get_col_name_list(target_db_name, target_schema_name, table_name, ignore_cols) %}
    {% set target_cols = target_col_list | join(", ") %}
    {% set target_cols_alias = get_col_name_alias_string(target_col_list, "tgt", primary_keys) %}

    // カラムの一致確認
    {% if not validate_cols(reference_col_list, target_col_list) %}
        {{ print("[Error] columns have any mismatch.") }}
        {{ return(false) }}
    {% endif %}

    {{ print("target_cols: " ~ target_cols) }}
    {{ print("=============================================================") }}

    // 差分テーブル(diff_*)作成
    {% set create_diff_table %}
        create or replace transient table {{ output_tran_table }} as
        with
        reference as (
            select {{ reference_cols }} from {{ reference_table }}
        ),
        target as (
            select {{ target_cols }} from {{ target_table }}
        ),
        reference_only as (
            select * from reference
            except
            select * from target
        ),
        target_only as (
            select * from target
            except
            select * from reference
        ),
        aliased_reference_only as (
            select {{ reference_cols_alias }} from reference_only
        ),
        aliased_target_only as (
            select {{ target_cols_alias }} from target_only
        ),
        diff as (
            select
                *
            from
                aliased_reference_only
            outer join
                aliased_target_only
            using
                ({{ str_primary_keys }})
        )
        select
            *
        from
            diff
    {% endset %}

    {% do run_query(create_diff_table) %}

    {{ print("transient table \"" ~ output_tran_table ~ "\" is created.") }}

{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// リスト内の文字列を大文字に変換
////////////////////////////////////////////////////////////////////////////////
{% macro translate_upper_on_list(target_list) %}
    {% set list_upper = [] %}
    {% for val in target_list %}
        {% do list_upper.append(val | upper) %}
    {% endfor %}
    {{ return(list_upper) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// カラム名のリスト取得
////////////////////////////////////////////////////////////////////////////////
{% macro get_col_name_list(db_name, schema_name, table_name, ignore_cols) %}
    {% set get_col_names %}
        select
            column_name
        from
            {{ db_name }}.information_schema.columns
        where
            table_schema = '{{ schema_name | upper }}'
        and
            table_name = '{{ table_name | upper }}'
    {% endset %}
    {% set result = run_query(get_col_names) %}

    {% set ignore_cols_upper = translate_upper_on_list(ignore_cols) %}
    {% set col_name_list = [] %}
    {% for row in result.rows %}
        {% if row[0] not in ignore_cols_upper %}
            {% do col_name_list.append(row[0]) %}
        {% endif %}
    {% endfor %}
    {{ return(col_name_list) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// カラム名のエイリアス用クエリ文字列取得
////////////////////////////////////////////////////////////////////////////////
{% macro get_col_name_alias_string(col_name_list, prefix, primary_keys) %}
    {% set primary_keys_upper = translate_upper_on_list(primary_keys) %}
    {% set col_aliases = [] %}
    {% for col_name in col_name_list %}
        {% if col_name in primary_keys_upper %}
            {% do col_aliases.append(col_name) %}
        {% else %}
            {% do col_aliases.append(col_name ~ " as " ~ prefix ~ "_" ~ col_name ) %}
        {% endif %}
    {% endfor %}
    {% set str_col_alias = col_aliases | join(", ") %}
    {{ return(str_col_alias) }}
{% endmacro %}


////////////////////////////////////////////////////////////////////////////////
// 変更前後のカラム一致確認
////////////////////////////////////////////////////////////////////////////////
{% macro validate_cols(reference_col_list, target_col_list) %}
    {% for item in target_col_list %}
        {% if item not in reference_col_list %}
            {{ return(false) }}
        {% endif %}
    {% endfor %}
    {{ return(true) }}
{% endmacro %}
