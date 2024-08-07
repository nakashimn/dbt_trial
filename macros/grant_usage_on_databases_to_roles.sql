{% macro grant_usage_on_databases_to_roles() %}

    ////////////////////////////////////////////////////////////////////////////////
    // grant USAGE on DATABASES to ROLES
    ////////////////////////////////////////////////////////////////////////////////
    {% set db_names = ["STAGING"] %}
    {% set role_names = ["DEVELOPER"] %}

    {% for db_name in db_names %}
        {% for role_name in role_names %}
            {{ print("[grant USAGE on " ~ db_name ~ " to " ~ role_name ~ " ]") }}

            {% set grant_usage_on_staging %}
            grant USAGE on database {{ db_name }} to role {{ role_name }}
            {% endset %}

            {% do run_query(grant_usage_on_staging) %}
        {% endfor %}
    {% endfor %}

{% endmacro %}
