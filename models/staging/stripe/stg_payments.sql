select
    orderid as order_id,
    paymentmethod,
    status as pmt_status,
    amount / 100 as amount,
    created as pmt_date

from raw.stripe.payment