select
    l.LOCATION_ID,
    l.LOCATION,
    l.CITY,
    count(distinct oh.TRUCK_ID) as TRUCK_COUNT,
    coalesce(sum(od.PRICE), 0) as TOTAL_SALES,
    coalesce(sum(oh.ORDER_AMOUNT), 0) as TOTAL_AMOUNT,
    coalesce(sum(oh.ORDER_TOTAL) - sum(oh.ORDER_AMOUNT), 0) as TOTAL_TAX,
    l.CITY || ' (Trucks: ' || count(distinct oh.TRUCK_ID)::string || ')' as LOCATION_DESCRIPTION
from {{ ref('raw_pos_location') }} l
left join {{ ref('raw_pos_order_header') }} oh
    on l.LOCATION_ID = oh.LOCATION_ID
left join {{ ref('raw_pos_order_detail') }} od
    on oh.ORDER_ID = od.ORDER_ID
group by
    l.LOCATION_ID,
    l.LOCATION,
    l.CITY
