with stg_products as (
    select * from {{ source('northwind', 'Products') }}
),

stg_suppliers as (
    select * from {{ source('northwind', 'Suppliers') }}
),

stg_categories as (
    select * from {{ source('northwind', 'Categories') }}
)

select 
    {{ dbt_utils.generate_surrogate_key(['p.productid']) }} as productkey,
    p.productid,
    p.productname,
    s.supplierid as supplieridkey,  -- Use suppliername from stg_suppliers
    c.categoryname,
    c.description as categorydescription
from stg_products p
    left join stg_suppliers s on p.supplierid = s.supplierid
    left join stg_categories c on p.categoryid = c.categoryid
