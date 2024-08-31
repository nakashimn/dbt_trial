{{ config(
    materialized='table',
    unique_key=['shop_id']
) }}

with
shops as (
    select
        *
    from
        {{ source("raw", "shops") }}
    qualify
        row_number() over (partition by shop_id order by date_part desc) = 1
),
final as (
    select
        shop_id
        , shop_name
        , open_date
        , close_date
        , date_part as updated_at
    from
        shops
)
select
    *
from
    final
