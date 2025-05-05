with stg_posts as (
    select
        _Id as PostId,
        _OwnerUserId as userkey,
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
    stg_posts.PostId as postkey,
    stg_users.user_id as userkey,
    stg_posts.title,
    stg_posts.viewcount,
    stg_posts.score,
    stg_posts.commentcount,
    stg_users.displayname,
    stg_users.userreputation,
    stg_users.location
from stg_posts
    join stg_users on stg_posts.userkey = stg_users.user_id
