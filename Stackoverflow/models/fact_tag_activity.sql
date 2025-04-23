with stg_posts as (
    select
        _Id as PostId,
        {{ dbt_utils.generate_surrogate_key(['_OwnerUserId']) }} as userkey,
        {{ dbt_utils.generate_surrogate_key(['_Tags']) }} as tagkey,
        -- Directly use _CreationDate as tagactivitytimestamp
        _CreationDate as tagactivitytimestamp,
        _Title as title,
        _ViewCount as viewcount,
        _Score as score,
        _CommentCount as commentcount
    from {{ source('stackoverflow', 'posts') }}
),
stg_users as (
    select 
        _Id as user_id,
        _DisplayName as displayname,
        _Reputation as userreputation,
        _Location as location
    from {{ source('stackoverflow', 'users') }}
),
stg_tags as (
    select 
        _Id as tag_id,
        _TagName as tagname,
        _Count as tagcount
    from {{ source('stackoverflow', 'tags') }}
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_posts.PostId', 'stg_tags.tag_id']) }} as tagactivitykey,
    stg_posts.PostId as postkey,
    stg_users.user_id as userkey,
    stg_tags.tag_id as tagkey,
    stg_posts.tagactivitytimestamp,
    stg_tags.tagname,
    stg_tags.tagcount,
    stg_posts.title,
    stg_posts.viewcount,
    stg_posts.score,
    stg_posts.commentcount,
    stg_users.displayname,
    stg_users.userreputation,
    stg_users.location
from stg_posts
    join stg_tags on stg_posts.tagkey = stg_tags.tag_id
    join stg_users on stg_posts.userkey = stg_users.user_id