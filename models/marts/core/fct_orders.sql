with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),

final as (
    select
        orders.order_id,
        orders.order_date,
        orders.status,
        customers.customer_id,
        payments.amount
    from orders
    inner join customers
        on customers.customer_id = orders.customer_id
    left join payments
        on payments.order_id = orders.order_id
)

select * from final