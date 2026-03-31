select
    m.MENU_ITEM_ID,
    m.MENU_ITEM_NAME,
    m.MENU_TYPE,
    m.TRUCK_BRAND_NAME,
    m.SALE_PRICE_USD,
    m.COST_OF_GOODS_USD,
    m.SALE_PRICE_USD - m.COST_OF_GOODS_USD as PROFIT_PER_ITEM_USD,
    count(distinct od.ORDER_ID) as TOTAL_ORDERS,
    sum(od.QUANTITY) as TOTAL_QUANTITY_SOLD,
    sum(od.PRICE) as TOTAL_REVENUE,
    sum(od.QUANTITY * m.COST_OF_GOODS_USD) as TOTAL_COST,
    sum(od.PRICE) - sum(od.QUANTITY * m.COST_OF_GOODS_USD) as TOTAL_PROFIT,
    round(
        div0(
            sum(od.PRICE) - sum(od.QUANTITY * m.COST_OF_GOODS_USD),
            sum(od.PRICE)
        ) * 100,
        2
    ) as PROFIT_MARGIN_PCT
from {{ ref('raw_pos_menu') }} m
left join {{ ref('raw_pos_order_detail') }} od
    on m.MENU_ITEM_ID = od.MENU_ITEM_ID
group by
    m.MENU_ITEM_ID,
    m.MENU_ITEM_NAME,
    m.MENU_TYPE,
    m.TRUCK_BRAND_NAME,
    m.SALE_PRICE_USD,
    m.COST_OF_GOODS_USD
order by TOTAL_REVENUE desc
