{% macro clone_and_grant_staging() %}

////////////////////////////////////////////////////////////////////////////////
// clone production to staging
////////////////////////////////////////////////////////////////////////////////
{{ print("[clone PRODUCTION to STAGING]") }}

{% set clone_db %}
create or replace database staging clone production
{% endset %}

{% do run_query(clone_db) %}

{% endmacro %}
