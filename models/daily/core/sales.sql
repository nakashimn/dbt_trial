{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['shop_id', 'sale_date']
) }}

with
sales as (
    select
        shop_id
        , current_date as sale_date
        , uniform(10, 500, random()) * 1000 as sales_amount
    from
        {{ source("core", "shops") }}
),
final as (
    select
        *
        , current_timestamp as created_at
        , null as modified_at
    from
        sales
)
select
    *
from
    final
