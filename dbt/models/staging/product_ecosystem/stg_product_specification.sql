{{
  config(
    materialized='view',
    schema='staging'
  )
}}

with source as (
    select * from {{ source('bronze', 'product_specification_cdc') }}
),

parsed as (
    select
        (cdc_payload->'payload'->'after'->>'ID')::bigint as i_d,
        (cdc_payload->'payload'->'after'->>'with')::text as with,
        (cdc_payload->'payload'->'after'->>'AddedByID')::bigint as added_by_i_d,
        (cdc_payload->'payload'->'after'->>'references')::text as references,
        to_timestamp((cdc_payload->'payload'->'after'->>'Created')::bigint / 1000) as created,
        (cdc_payload->'payload'->'after'->>'Deleted')::boolean as deleted,
        (cdc_payload->'payload'->'after'->>'NetUID')::uuid as net_u_i_d,
        (cdc_payload->'payload'->'after'->>'ProductID')::bigint as product_i_d,
        (cdc_payload->'payload'->'after'->>'SpecificationCode')::text as specification_code,
        to_timestamp((cdc_payload->'payload'->'after'->>'Updated')::bigint / 1000) as updated,
        (cdc_payload->'payload'->'after'->>'Name')::text as name,
        (cdc_payload->'payload'->'after'->>'IsActive')::boolean as is_active,
        (cdc_payload->'payload'->'after'->>'DutyPercent')::numeric as duty_percent,
        (cdc_payload->'payload'->'after'->>'Locale')::text as locale,
        (cdc_payload->'payload'->'after'->>'CustomsValue')::numeric as customs_value,
        (cdc_payload->'payload'->'after'->>'Duty')::numeric as duty,
        (cdc_payload->'payload'->'after'->>'VATPercent')::numeric as v_a_t_percent,
        (cdc_payload->'payload'->'after'->>'VATValue')::numeric as v_a_t_value,
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
