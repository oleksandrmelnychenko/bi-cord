{{
  config(
    materialized='view',
    schema='staging'
  )
}}

with source as (
    select * from {{ source('bronze', 'product_cdc') }}
),

parsed as (
    select
        -- Core Identity
        (cdc_payload->'payload'->'after'->>'ID')::bigint as product_id,
        (cdc_payload->'payload'->'after'->>'NetUID')::uuid as net_uid,
        to_timestamp((cdc_payload->'payload'->'after'->>'Created')::bigint / 1000) as created,
        to_timestamp((cdc_payload->'payload'->'after'->>'Updated')::bigint / 1000) as updated,
        (cdc_payload->'payload'->'after'->>'Deleted')::boolean as deleted,

        -- Basic Product Information
        (cdc_payload->'payload'->'after'->>'Name')::text as name,
        (cdc_payload->'payload'->'after'->>'VendorCode')::text as vendor_code,
        (cdc_payload->'payload'->'after'->>'Description')::text as description,
        (cdc_payload->'payload'->'after'->>'Size')::text as size,
        (cdc_payload->'payload'->'after'->>'Weight')::numeric as weight,
        (cdc_payload->'payload'->'after'->>'Volume')::text as volume,
        (cdc_payload->'payload'->'after'->>'Image')::text as image,
        (cdc_payload->'payload'->'after'->>'MainOriginalNumber')::text as main_original_number,
        (cdc_payload->'payload'->'after'->>'MeasureUnitID')::bigint as measure_unit_id,
        (cdc_payload->'payload'->'after'->>'Top')::text as top,

        -- Multilingual Content - Polish
        (cdc_payload->'payload'->'after'->>'NamePL')::text as name_pl,
        (cdc_payload->'payload'->'after'->>'DescriptionPL')::text as description_pl,
        (cdc_payload->'payload'->'after'->>'NotesPL')::text as notes_pl,
        (cdc_payload->'payload'->'after'->>'SynonymsPL')::text as synonyms_pl,

        -- Multilingual Content - Ukrainian
        (cdc_payload->'payload'->'after'->>'NameUA')::text as name_ua,
        (cdc_payload->'payload'->'after'->>'DescriptionUA')::text as description_ua,
        (cdc_payload->'payload'->'after'->>'NotesUA')::text as notes_ua,
        (cdc_payload->'payload'->'after'->>'SynonymsUA')::text as synonyms_ua,

        -- Search Optimization - Base Language
        (cdc_payload->'payload'->'after'->>'SearchName')::text as search_name,
        (cdc_payload->'payload'->'after'->>'SearchDescription')::text as search_description,
        (cdc_payload->'payload'->'after'->>'SearchSize')::text as search_size,
        (cdc_payload->'payload'->'after'->>'SearchVendorCode')::text as search_vendor_code,

        -- Search Optimization - Polish
        (cdc_payload->'payload'->'after'->>'SearchNamePL')::text as search_name_pl,
        (cdc_payload->'payload'->'after'->>'SearchDescriptionPL')::text as search_description_pl,
        (cdc_payload->'payload'->'after'->>'SearchSynonymsPL')::text as search_synonyms_pl,

        -- Search Optimization - Ukrainian
        (cdc_payload->'payload'->'after'->>'SearchNameUA')::text as search_name_ua,
        (cdc_payload->'payload'->'after'->>'SearchDescriptionUA')::text as search_description_ua,
        (cdc_payload->'payload'->'after'->>'SearchSynonymsUA')::text as search_synonyms_ua,

        -- Business Flags
        (cdc_payload->'payload'->'after'->>'HasAnalogue')::boolean as has_analogue,
        (cdc_payload->'payload'->'after'->>'HasImage')::boolean as has_image,
        (cdc_payload->'payload'->'after'->>'IsForSale')::boolean as is_for_sale,
        (cdc_payload->'payload'->'after'->>'IsForWeb')::boolean as is_for_web,
        (cdc_payload->'payload'->'after'->>'IsForZeroSale')::boolean as is_for_zero_sale,
        (cdc_payload->'payload'->'after'->>'HasComponent')::boolean as has_component,

        -- Specifications & Standards
        (cdc_payload->'payload'->'after'->>'UCGFEA')::text as ucgfea,
        (cdc_payload->'payload'->'after'->>'Standard')::text as standard,
        (cdc_payload->'payload'->'after'->>'OrderStandard')::text as order_standard,
        (cdc_payload->'payload'->'after'->>'PackingStandard')::text as packing_standard,

        -- Source System Integration
        (cdc_payload->'payload'->'after'->>'SourceAmgID')::bytea as source_amg_id,
        (cdc_payload->'payload'->'after'->>'SourceFenixID')::bytea as source_fenix_id,
        (cdc_payload->'payload'->'after'->>'ParentAmgID')::bytea as parent_amg_id,
        (cdc_payload->'payload'->'after'->>'ParentFenixID')::bytea as parent_fenix_id,
        (cdc_payload->'payload'->'after'->>'SourceAmgCode')::bigint as source_amg_code,
        (cdc_payload->'payload'->'after'->>'SourceFenixCode')::bigint as source_fenix_code,

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
            partition by product_id
            order by source_ts_ms desc, kafka_offset desc
        ) as rn
    from parsed
)

select
    -- Core Identity
    product_id,
    net_uid,
    created,
    updated,
    deleted,

    -- Basic Product Information
    name,
    vendor_code,
    description,
    size,
    weight,
    volume,
    image,
    main_original_number,
    measure_unit_id,
    top,

    -- Multilingual Content - Polish
    name_pl,
    description_pl,
    notes_pl,
    synonyms_pl,

    -- Multilingual Content - Ukrainian
    name_ua,
    description_ua,
    notes_ua,
    synonyms_ua,

    -- Search Optimization - Base Language
    search_name,
    search_description,
    search_size,
    search_vendor_code,

    -- Search Optimization - Polish
    search_name_pl,
    search_description_pl,
    search_synonyms_pl,

    -- Search Optimization - Ukrainian
    search_name_ua,
    search_description_ua,
    search_synonyms_ua,

    -- Business Flags
    has_analogue,
    has_image,
    is_for_sale,
    is_for_web,
    is_for_zero_sale,
    has_component,

    -- Specifications & Standards
    ucgfea,
    standard,
    order_standard,
    packing_standard,

    -- Source System Integration
    source_amg_id,
    source_fenix_id,
    parent_amg_id,
    parent_fenix_id,
    source_amg_code,
    source_fenix_code,

    -- CDC Metadata
    cdc_operation,
    source_timestamp,
    is_snapshot,
    ingested_at
from deduplicated
where rn = 1
