with stg_users as (
    select * from {{ source('stackoverflow', 'users') }}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_users._id']) }} as userkey, 
    stg_users.* 
from stg_users
