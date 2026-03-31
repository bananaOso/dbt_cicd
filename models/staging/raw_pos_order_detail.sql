select * from {{ source('tb_101', 'ORDER_DETAIL') }}
limit 2000
