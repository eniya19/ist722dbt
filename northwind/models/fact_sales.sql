with stg_orders as (
    select
        OrderID,  
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey, 
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey, 
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
        from {{source('northwind','Orders')}}
),

stg_order_details as (
    select 
        OrderID,
        productid,
        quantity,
        unitprice,
        discount
    from {{ source('northwind', 'Order_Details') }}
),

stg_products as (
    select 
        productid 
    from {{ source('northwind', 'Products') }}
)
select 
    o.customerkey,
    o.orderdatekey,
    p.productid as Productkey,
    o.orderid,
    od.quantity,
    od.quantity * od.unitprice as extendedpriceamount,
    od.quantity * od.unitprice * od.discount as discountamount,
    od.quantity * od.unitprice * (1 - od.discount) as soldamount
from stg_orders o
    join stg_order_details od on o.orderid = od.orderid
    join stg_products p on od.productid = p.productid