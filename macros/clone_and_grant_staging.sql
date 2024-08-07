{% macro clone_and_grant_staging() %}

    ////////////////////////////////////////////////////////////////////////////////
    // clone production to staging
    ////////////////////////////////////////////////////////////////////////////////
    {{ print("[clone PRODUCTION to STAGING]") }}

    {% set clone_db %}
    create or replace database staging clone production
    {% endset %}

    {% do run_query(clone_db) %}

    ////////////////////////////////////////////////////////////////////////////////
    // grant USAGE on STAGING to ROLES
    ////////////////////////////////////////////////////////////////////////////////
    {% set target_roles = ["DEVELOPER"] %}

    {% for target_role in target_roles %}
        {{ print("[grant USAGE on STAGING to " ~ target_role ~ " ]") }}

        {% set grant_usage_on_staging %}
        grant USAGE on database STAGING to role {{ target_role }}
        {% endset %}

        {% do run_query(grant_usage_on_staging) %}
    {% endfor %}

{% endmacro %}
