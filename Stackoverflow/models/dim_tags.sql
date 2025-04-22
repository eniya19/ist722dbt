with stg_tags as (
    select * from {{ source('stackoverflow', 'tags') }}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_tags._Id']) }} as tagkey, 
    stg_tags.* 
from stg_tags
