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

enriched as (
    select
        -- Core Identity
        product_id,
        net_uid,
        created,
        updated,

        -- Basic Product Information
        name,
        vendor_code,
        LEFT(vendor_code, 4) as supplier_prefix,
        description,
        size,
        weight,
        volume,
        image,
        main_original_number,

        -- Multilingual Content
        name_pl as polish_name,
        description_pl as polish_description,
        name_ua as ukrainian_name,
        description_ua as ukrainian_description,

        -- Search Optimization Fields (for reference)
        search_name,
        search_vendor_code,
        search_name_pl as search_polish_name,
        search_name_ua as search_ukrainian_name,

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

        -- Source System Integration
        source_amg_code,
        source_fenix_code,

        -- Computed Columns
        CURRENT_DATE - created::date as days_since_created,
        CURRENT_DATE - updated::date as days_since_updated,

        CASE
            WHEN vendor_code IS NULL OR LENGTH(vendor_code) < 4 THEN 'Unknown'
            ELSE LEFT(vendor_code, 4)
        END as supplier_name,

        CASE
            WHEN name_pl IS NOT NULL AND name_ua IS NOT NULL THEN 'Complete'
            WHEN name_pl IS NOT NULL OR name_ua IS NOT NULL THEN 'Partial'
            ELSE 'Missing'
        END as multilingual_status,

        CASE
            WHEN weight IS NULL OR weight = 0 THEN 'Missing'
            WHEN weight > 0 AND weight < 1 THEN 'Light (<1kg)'
            WHEN weight >= 1 AND weight < 10 THEN 'Medium (1-10kg)'
            WHEN weight >= 10 THEN 'Heavy (>10kg)'
        END as weight_category,

        -- Metadata
        source_timestamp,
        ingested_at

    from product_base
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

    -- Metadata
    source_timestamp as last_modified_in_source,
    ingested_at as ingested_timestamp

from enriched
