select
    oh.ORDER_ID,
    oh.TRUCK_ID,
    oh.ORDER_TS,
    od.ORDER_DETAIL_ID,
    od.LINE_NUMBER,
    m.TRUCK_BRAND_NAME,
    m.MENU_TYPE,
    t.PRIMARY_CITY,
    t.REGION,
    t.COUNTRY,
    t.FRANCHISE_FLAG,
    t.FRANCHISE_ID,
    f.FIRST_NAME as FRANCHISEE_FIRST_NAME,
    f.LAST_NAME as FRANCHISEE_LAST_NAME,
    oh.LOCATION_ID,
    oh.CUSTOMER_ID,
    cl.FIRST_NAME,
    cl.LAST_NAME,
    cl.E_MAIL,
    cl.PHONE_NUMBER,
    cl.CHILDREN_COUNT,
    cl.GENDER,
    cl.MARITAL_STATUS,
    od.MENU_ITEM_ID,
    m.MENU_ITEM_NAME,
    od.QUANTITY,
    od.UNIT_PRICE,
    od.PRICE,
    oh.ORDER_AMOUNT,
    oh.ORDER_TAX_AMOUNT,
    oh.ORDER_DISCOUNT_AMOUNT,
    oh.ORDER_TOTAL
from {{ ref('raw_pos_order_header') }} oh
join {{ ref('raw_pos_order_detail') }} od
    on oh.ORDER_ID = od.ORDER_ID
join {{ ref('raw_pos_truck') }} t
    on oh.TRUCK_ID = t.TRUCK_ID
join {{ ref('raw_pos_menu') }} m
    on od.MENU_ITEM_ID = m.MENU_ITEM_ID
left join {{ ref('raw_pos_franchise') }} f
    on t.FRANCHISE_ID = f.FRANCHISE_ID
left join {{ ref('raw_customer_customer_loyalty') }} cl
    on oh.CUSTOMER_ID = cl.CUSTOMER_ID
