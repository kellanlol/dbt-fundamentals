with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),

order_payments as (

    select 
        order_id,
        sum(case 
                when pmt_status = 'success' 
                then amount 
            end) as amount

    from payments
    group by 1

),

/*
--my first attempt at building the fct_orders table.  didn't originally include intermediate order_payments CTE.

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
*/

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final