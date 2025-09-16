{{
  config(
    materialized='incremental',
    on_schema_change='fail'
  )
}}
with src_reviews as (
  select * from {{ ref('src_reviews') }}
)
select
  {{ dbt_utils.generate_surrogate_key(['listing_id','review_date','reviewer_name','review_text']) }} as review_id,  -- new macro [7][20]
  *
from src_reviews
where review_text is not null  -- retain filter [12]
{% if is_incremental() %}
  and review_date >= (
    select coalesce(max(review_date), '1900-01-01') from {{ this }}
  )  -- coalesce avoids empty-target errors and uses >= to capture late updates [12]
{% endif %}
