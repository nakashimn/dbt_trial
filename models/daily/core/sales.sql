{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['shop_id', 'sale_date']
) }}

with
sales as (
    select
        shop_id
        , shop_name
        , current_date as sale_date
        , uniform(10, 500, random()) * 1000 as sales_amount
    from
        {{ ref("shops") }}
),
final as (
    select
        *
        , current_timestamp as updated_at
    from
        sales
)
select
    *
from
    final
