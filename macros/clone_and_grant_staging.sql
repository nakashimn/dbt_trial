{% macro clone_and_grant_staging() %}

////////////////////////////////////////////////////////////////////////////////
// clone production to staging
////////////////////////////////////////////////////////////////////////////////
{{ print("[clone PRODUCTION to STAGING]") }}

{% set clone_db %}
create or replace database staging clone production
{% endset %}

{% do run_query(clone_db) %}

-- ////////////////////////////////////////////////////////////////////////////////
-- // grant privileges to DEVELOPER
-- ////////////////////////////////////////////////////////////////////////////////
-- {{ print("[grant privileges to DEVELOPER]") }}

-- // 既存全Schemeの使用権限
-- {% set grant_usage_on_all_schemas %}
-- grant USAGE on all schemas in database staging to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_usage_on_all_schemas) %}

-- -- // 将来作られるSchemeの使用権限
-- -- {% set grant_usage_on_future_schemas %}
-- -- grant USAGE on future schemas in database staging to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_usage_on_future_schemas) %}


-- //  既存Stageの使用権限
-- {% set grant_usage_on_all_stages %}
-- grant USAGE on all stages in schema staging.raw to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_usage_on_all_stages) %}

-- -- // 将来作られるStageの使用権限
-- -- {% set grant_usage_on_future_stages %}
-- -- grant USAGE on future stages in schema staging.raw to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_usage_on_future_stages) %}

-- // 既存TableのSELECT権限
-- {% set grant_select_on_all_tables_in_raw %}
-- grant SELECT on all tables in schema staging.raw to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_tables_in_raw) %}

-- -- // 将来作られるTableのSELECT権限
-- -- {% set grant_select_on_future_tables_in_raw %}
-- -- grant SELECT on future tables in schema staging.raw to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_tables_in_raw) %}

-- // 既存ViewのSELECT権限
-- {% set grant_select_on_all_views_in_raw %}
-- grant SELECT on all views in schema staging.raw to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_views_in_raw) %}

-- -- // 将来作られるViewのSELECT権限
-- -- {% set grant_select_on_future_views_in_raw %}
-- -- grant SELECT on future views in schema staging.raw to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_views_in_raw) %}

-- // 既存TableのSELECT権限
-- {% set grant_select_on_all_tables_in_core %}
-- grant SELECT on all tables in schema staging.core to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_tables_in_core) %}

-- -- // 将来作られるTableのSELECT権限
-- -- {% set grant_select_on_future_tables_in_core %}
-- -- grant SELECT on future tables in schema staging.core to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_tables_in_core) %}

-- // 既存ViewのSELECT権限
-- {% set grant_select_on_all_views_in_core %}
-- grant SELECT on all views in schema staging.core to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_views_in_core) %}

-- -- // 将来作られるViewのSELECT権限
-- -- {% set grant_select_on_future_views_in_core %}
-- -- grant SELECT on future views in schema staging.core to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_views_in_core) %}

-- // 既存TableのSELECT権限
-- {% set grant_select_on_all_tables_in_integration %}
-- grant SELECT on all tables  in schema staging.integration to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_tables_in_integration) %}

-- -- // 将来作られるTableのSELECT権限
-- -- {% set grant_select_on_future_tables_in_integration %}
-- -- grant SELECT on future tables in schema staging.integration to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_tables_in_integration) %}

-- // 既存ViewのSELECT権限
-- {% set grant_select_on_all_views_in_integration %}
-- grant SELECT on all views in schema staging.integration to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_views_in_integration) %}

-- -- // 将来作られるViewのSELECT権限
-- -- {% set grant_select_on_future_views_in_integration %}
-- -- grant SELECT on future views in schema staging.integration to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_views_in_integration) %}

-- // 既存TableのSELECT権限
-- {% set grant_select_on_all_tables_in_semantic %}
-- grant SELECT on all tables  in schema staging.semantic to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_tables_in_semantic) %}

-- -- // 将来作られるTableのSELECT権限
-- -- {% set grant_select_on_future_tables_in_semantic %}
-- -- grant SELECT on future tables in schema staging.semantic to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_tables_in_semantic) %}

-- // 既存ViewのSELECT権限
-- {% set grant_select_on_all_views_in_semantic %}
-- grant SELECT on all views in schema staging.semantic to role DEVELOPER
-- {% endset %}

-- {% do run_query(grant_select_on_all_views_in_semantic) %}

-- -- // 将来作られるViewのSELECT権限
-- -- {% set grant_select_on_future_views_in_semantic %}
-- -- grant SELECT on future views in schema staging.semantic to role DEVELOPER
-- -- {% endset %}

-- -- {% do run_query(grant_select_on_future_views_in_semantic) %}

{% endmacro %}
