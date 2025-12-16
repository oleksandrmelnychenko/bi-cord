{{
  config(
    materialized='view',
    schema='staging'
  )
}}

with source as (
    select * from {{ source('bronze', 'product_income_item_cdc') }}
),

parsed as (
    select
        to_timestamp((cdc_payload->'payload'->'after'->>'Created')::bigint / 1000) as created,
        (cdc_payload->'payload'->'after'->>'Deleted')::boolean as deleted,
        (cdc_payload->'payload'->'after'->>'ID')::bigint as i_d,
        (cdc_payload->'payload'->'after'->>'with')::text as with,
        (cdc_payload->'payload'->'after'->>'NetUID')::uuid as net_u_i_d,
        to_timestamp((cdc_payload->'payload'->'after'->>'Updated')::bigint / 1000) as updated,
        (cdc_payload->'payload'->'after'->>'SaleReturnItemID')::bigint as sale_return_item_i_d,
        (cdc_payload->'payload'->'after'->>'references')::text as references,
        (cdc_payload->'payload'->'after'->>'on')::text as on,
        (cdc_payload->'payload'->'after'->>'ProductIncomeID')::bigint as product_income_i_d,
        (cdc_payload->'payload'->'after'->>'PackingListPackageOrderItemID')::bigint as packing_list_package_order_item_i_d,
        (cdc_payload->'payload'->'after'->>'Qty')::numeric as qty,
        (cdc_payload->'payload'->'after'->>'SupplyOrderUkraineItemID')::bigint as supply_order_ukraine_item_i_d,
        (cdc_payload->'payload'->'after'->>'RemainingQty')::numeric as remaining_qty,
        (cdc_payload->'payload'->'after'->>'ActReconciliationItemID')::bigint as act_reconciliation_item_i_d,
        (cdc_payload->'payload'->'after'->>'ProductCapitalizationItemID')::bigint as product_capitalization_item_i_d,
        -- CDC Metadata
        cdc_payload->'payload'->>'op' as cdc_operation,
        (cdc_payload->'payload'->'source'->>'ts_ms')::bigint as source_ts_ms,
        to_timestamp((cdc_payload->'payload'->'source'->>'ts_ms')::bigint / 1000) as source_timestamp,
        (cdc_payload->'payload'->'source'->>'snapshot')::text as is_snapshot,
        kafka_offset,
        kafka_partition,
        kafka_topic,
        ingested_at
    from source
    where cdc_payload->'payload'->'after' is not null
),

deduplicated as (
    select
        *,
        row_number() over (
            partition by i_d
            order by source_ts_ms desc, kafka_offset desc
        ) as rn
    from parsed
)

select
    *
from deduplicated
where rn = 1 and deleted = false
