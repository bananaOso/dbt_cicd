select
    cl.CUSTOMER_ID,
    cl.CITY,
    cl.COUNTRY,
    cl.FIRST_NAME,
    cl.LAST_NAME,
    cl.PHONE_NUMBER,
    cl.E_MAIL,
    sum(oh.ORDER_TOTAL) as TOTAL_SALES,
    array_agg(distinct oh.LOCATION_ID) as VISITED_LOCATION_IDS_ARRAY
from {{ ref('raw_customer_customer_loyalty') }} cl
join {{ ref('raw_pos_order_header') }} oh
    on cl.CUSTOMER_ID = oh.CUSTOMER_ID
group by
    cl.CUSTOMER_ID,
    cl.CITY,
    cl.COUNTRY,
    cl.FIRST_NAME,
    cl.LAST_NAME,
    cl.PHONE_NUMBER,
    cl.E_MAIL
