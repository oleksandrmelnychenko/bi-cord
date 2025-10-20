{{
  config(
    materialized='table',
    schema='marts',
    indexes=[
      {'columns': ['product_id'], 'unique': True},
      {'columns': ['search_name'], 'type': 'gin', 'operator': 'gin_trgm_ops'},
      {'columns': ['search_vendor_code']},
      {'columns': ['original_numbers'], 'type': 'gin'},
      {'columns': ['is_available']},
      {'columns': ['total_available_amount']}
    ]
  )
}}

-- Enhanced product search table with denormalized joins
-- Eliminates need for runtime JOINs to ProductAvailability, OriginalNumber, Analogue, etc.
-- Optimized for world-class AI/ML search performance

with product_base as (
    select * from {{ ref('stg_product') }}
    where deleted = false
),

-- Aggregate availability by product across all storages
availability_agg as (
    select
        product_i_d as product_id,
        sum(amount) as total_available_amount,
        max(case when amount > 0 then 1 else 0 end) as is_available,
        count(distinct storage_i_d) as storage_count,
        -- For multilingual support, we'll need to join with storage later
        -- For now, just track if product is available
        max(updated) as last_availability_update
    from {{ ref('stg_product_availability') }}
    where deleted = false
    group by product_i_d
),

-- Aggregate original numbers (OEM part numbers) into array
original_numbers_agg as (
    select
        pon.product_i_d as product_id,
        array_agg(distinct pon.original_number_i_d) filter (where pon.original_number_i_d is not null) as original_number_ids,
        count(distinct pon.original_number_i_d) as original_number_count,
        max(case when pon.is_main_original_number = true then pon.original_number_i_d end) as main_original_number_id
    from {{ ref('stg_product_original_number') }}  pon
    where pon.deleted = false
    group by pon.product_i_d
),

-- Aggregate analogues (alternative products) into array
analogues_agg as (
    select
        base_product_i_d as product_id,
        array_agg(distinct analogue_product_i_d) filter (where analogue_product_i_d is not null) as analogue_product_ids,
        count(distinct analogue_product_i_d) as analogue_count
    from {{ ref('stg_product_analogue') }}
    where deleted = false
    group by base_product_i_d
),

-- Join everything together
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
        p.measure_unit_id,
        p.top,

        -- Multilingual Content (Full Fields)
        p.name_pl,
        p.name_ua,
        p.description_pl,
        p.description_ua,
        p.notes_pl,
        p.notes_ua,
        p.synonyms_pl,
        p.synonyms_ua,

        -- Search Optimization Fields (for full-text search)
        p.search_name,
        p.search_description,
        p.search_name_pl,
        p.search_description_pl,
        p.search_synonyms_pl,
        p.search_name_ua,
        p.search_description_ua,
        p.search_synonyms_ua,
        p.search_vendor_code,
        p.search_size,

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
        p.order_standard,
        p.packing_standard,

        -- Source System Integration
        p.source_amg_id,
        p.source_fenix_id,
        p.parent_amg_id,
        p.parent_fenix_id,
        p.source_amg_code,
        p.source_fenix_code,

        -- **DENORMALIZED AVAILABILITY** (eliminates ProductAvailability JOIN)
        coalesce(av.total_available_amount, 0) as total_available_amount,
        coalesce(av.is_available, 0)::boolean as is_available,
        coalesce(av.storage_count, 0) as storage_count,
        av.last_availability_update,

        -- **DENORMALIZED ORIGINAL NUMBERS** (eliminates OriginalNumber JOIN)
        on_agg.original_number_ids,
        coalesce(on_agg.original_number_count, 0) as original_number_count,
        on_agg.main_original_number_id,

        -- **DENORMALIZED ANALOGUES** (eliminates ProductAnalogue JOIN)
        an_agg.analogue_product_ids,
        coalesce(an_agg.analogue_count, 0) as analogue_count,

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

        -- Search Ranking Signals
        CASE
            WHEN coalesce(av.is_available, 0) = 1 THEN 1.0
            WHEN p.has_analogue THEN 0.5  -- Boost if analogues available
            ELSE 0.0
        END as availability_score,

        -- Freshness score (newer products score higher)
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
    measure_unit_id,
    top,

    -- Multilingual Content
    name_pl,
    name_ua,
    description_pl,
    description_ua,
    notes_pl,
    notes_ua,
    synonyms_pl,
    synonyms_ua,
    multilingual_status,

    -- Search Optimization
    search_name,
    search_description,
    search_name_pl,
    search_description_pl,
    search_synonyms_pl,
    search_name_ua,
    search_description_ua,
    search_synonyms_ua,
    search_vendor_code,
    search_size,

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
    order_standard,
    packing_standard,

    -- Source Systems
    source_amg_code,
    source_fenix_code,
    source_amg_id,
    source_fenix_id,
    parent_amg_id,
    parent_fenix_id,

    -- **DENORMALIZED AVAILABILITY**
    total_available_amount,
    is_available,
    storage_count,
    last_availability_update,

    -- **DENORMALIZED ORIGINAL NUMBERS**
    original_number_ids,
    original_number_count,
    main_original_number_id,

    -- **DENORMALIZED ANALOGUES**
    analogue_product_ids,
    analogue_count,

    -- **SEARCH RANKING SIGNALS**
    availability_score,
    freshness_score,

    -- Metadata
    source_timestamp as last_modified_in_source,
    ingested_at as ingested_timestamp

from enriched
