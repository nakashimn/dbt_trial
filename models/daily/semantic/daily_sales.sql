{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='sale_date'
) }}

with
sales as (
    select
        *
    from
        {{ ref("sales") }}
    {% if is_incremental() %}
    where
        sale_date >= dateadd('day', -1, current_date)
    {% endif %}
),
daily_sales as (
    select
        sale_date
        , sum(sales_amount) as sales_amount
    from
        sales
    group by
        all
),
final as (
    select
        *
        , current_timestamp as created_at
        , null as modified_at
    from
        daily_sales
)
select
    *
from
    final
