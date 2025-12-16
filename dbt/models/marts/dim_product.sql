{{
  config(
    materialized='table',
    schema='marts'
  )
}}

with product_base as (
    select * from {{ ref('stg_product') }}
    where deleted = false
),

-- Aggregate availability by product across all storages
availability_agg as (
    select
        product_i_d as product_id,
        sum(amount) as total_available_amount,
        max(case when amount > 0 then 1 else 0 end)::boolean as is_available,
        count(distinct storage_i_d) as storage_count
    from {{ ref('stg_product_availability') }}
    where deleted = false
    group by product_i_d
),

-- Aggregate original numbers into array
original_numbers_agg as (
    select
        product_i_d as product_id,
        array_agg(distinct original_number_i_d) filter (where original_number_i_d is not null) as original_number_ids
    from {{ ref('stg_product_original_number') }}
    where deleted = false
    group by product_i_d
),

-- Aggregate analogues into array
analogues_agg as (
    select
        base_product_i_d as product_id,
        array_agg(distinct analogue_product_i_d) filter (where analogue_product_i_d is not null) as analogue_product_ids
    from {{ ref('stg_product_analogue') }}
    where deleted = false
    group by base_product_i_d
),

enriched as (
    select
        -- Core Identity
        p.product_id,
        p.net_uid,
        p.created,
        p.updated,

        -- Basic Product Information
        p.name,
        p.vendor_code,
        LEFT(p.vendor_code, 4) as supplier_prefix,
        p.description,
        p.size,
        p.weight,
        p.volume,
        p.image,
        p.main_original_number,

        -- Multilingual Content
        p.name_pl as polish_name,
        p.description_pl as polish_description,
        p.name_ua as ukrainian_name,
        p.description_ua as ukrainian_description,

        -- Search Optimization Fields (for reference)
        p.search_name,
        p.search_vendor_code,
        p.search_name_pl as search_polish_name,
        p.search_name_ua as search_ukrainian_name,

        -- Business Flags
        p.has_analogue,
        p.has_image,
        p.is_for_sale,
        p.is_for_web,
        p.is_for_zero_sale,
        p.has_component,

        -- Specifications
        p.ucgfea,
        p.standard,

        -- Source System Integration
        p.source_amg_code,
        p.source_fenix_code,

        -- Computed Columns
        CURRENT_DATE - p.created::date as days_since_created,
        CURRENT_DATE - p.updated::date as days_since_updated,

        CASE
            WHEN p.vendor_code IS NULL OR LENGTH(p.vendor_code) < 4 THEN 'Unknown'
            ELSE LEFT(p.vendor_code, 4)
        END as supplier_name,

        CASE
            WHEN p.name_pl IS NOT NULL AND p.name_ua IS NOT NULL THEN 'Complete'
            WHEN p.name_pl IS NOT NULL OR p.name_ua IS NOT NULL THEN 'Partial'
            ELSE 'Missing'
        END as multilingual_status,

        CASE
            WHEN p.weight IS NULL OR p.weight = 0 THEN 'Missing'
            WHEN p.weight > 0 AND p.weight < 1 THEN 'Light (<1kg)'
            WHEN p.weight >= 1 AND p.weight < 10 THEN 'Medium (1-10kg)'
            WHEN p.weight >= 10 THEN 'Heavy (>10kg)'
        END as weight_category,

        -- **DENORMALIZED AVAILABILITY** (from ProductAvailability)
        coalesce(av.total_available_amount, 0) as total_available_amount,
        coalesce(av.storage_count, 0) as storage_count,

        -- **DENORMALIZED ORIGINAL NUMBERS** (from ProductOriginalNumber)
        on_agg.original_number_ids,

        -- **DENORMALIZED ANALOGUES** (from ProductAnalogue)
        an_agg.analogue_product_ids,

        -- **SEARCH RANKING SIGNALS**
        CASE
            WHEN coalesce(av.is_available, false) = true THEN 1.0
            WHEN p.has_analogue THEN 0.5
            ELSE 0.0
        END as availability_score,

        CASE
            WHEN CURRENT_DATE - p.created::date < 30 THEN 1.0
            WHEN CURRENT_DATE - p.created::date < 90 THEN 0.75
            WHEN CURRENT_DATE - p.created::date < 180 THEN 0.5
            WHEN CURRENT_DATE - p.created::date < 365 THEN 0.25
            ELSE 0.1
        END as freshness_score,

        -- Metadata
        p.source_timestamp,
        p.ingested_at

    from product_base p
    left join availability_agg av on p.product_id = av.product_id
    left join original_numbers_agg on_agg on p.product_id = on_agg.product_id
    left join analogues_agg an_agg on p.product_id = an_agg.product_id
)

select
    -- Core Identity
    product_id,
    net_uid,
    created,
    updated,
    days_since_created,
    days_since_updated,

    -- Basic Product Information
    name,
    vendor_code,
    supplier_prefix,
    supplier_name,
    description,
    size,
    weight,
    weight_category,
    volume,
    image,
    main_original_number,

    -- Multilingual Content
    polish_name,
    polish_description,
    ukrainian_name,
    ukrainian_description,
    multilingual_status,

    -- Search Optimization
    search_name,
    search_vendor_code,
    search_polish_name,
    search_ukrainian_name,

    -- Business Flags
    has_analogue,
    has_image,
    is_for_sale,
    is_for_web,
    is_for_zero_sale,
    has_component,

    -- Specifications
    ucgfea,
    standard,

    -- Source Systems
    source_amg_code,
    source_fenix_code,

    -- **DENORMALIZED JOINS** (eliminates runtime JOINs)
    total_available_amount,
    storage_count,
    original_number_ids,
    analogue_product_ids,

    -- **SEARCH RANKING SIGNALS** (for ML ranking)
    availability_score,
    freshness_score,

    -- Metadata
    source_timestamp as last_modified_in_source,
    ingested_at as ingested_timestamp

from enriched
