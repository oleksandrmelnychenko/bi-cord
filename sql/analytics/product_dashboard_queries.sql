-- Product Analytics Dashboard Queries
-- Generated: 2025-10-18
-- Database: PostgreSQL (analytics)
-- Purpose: Ready-to-use queries for BI dashboards and reports

-- =============================================================================
-- 1. PRODUCT CATALOG OVERVIEW
-- =============================================================================

-- 1.1 Overall Product Statistics
SELECT
    COUNT(*) as total_products,
    COUNT(DISTINCT vendor_code) as unique_vendor_codes,
    COUNT(DISTINCT CASE WHEN is_for_web = true THEN product_id END) as products_on_web,
    COUNT(DISTINCT CASE WHEN has_analogue = true THEN product_id END) as products_with_alternatives,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN has_analogue = true THEN product_id END) / COUNT(*), 2) as pct_with_alternatives
FROM staging_staging.stg_product
WHERE deleted = false;

-- 1.2 Product Count by Supplier Prefix
SELECT
    COALESCE(LEFT(vendor_code, 4), 'Unknown') as supplier_prefix,
    COUNT(*) as product_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY LEFT(vendor_code, 4)
ORDER BY product_count DESC;

-- 1.3 Product Catalog Freshness
SELECT
    DATE(created) as creation_date,
    COUNT(*) as products_created,
    SUM(COUNT(*)) OVER (ORDER BY DATE(created)) as cumulative_products
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY DATE(created)
ORDER BY creation_date DESC
LIMIT 30;

-- =============================================================================
-- 2. DATA QUALITY METRICS
-- =============================================================================

-- 2.1 Field Completeness Dashboard
SELECT
    'Vendor Code' as field_name,
    COUNT(CASE WHEN vendor_code IS NOT NULL THEN 1 END) as populated,
    COUNT(*) as total,
    ROUND(100.0 * COUNT(CASE WHEN vendor_code IS NOT NULL THEN 1 END) / COUNT(*), 2) as pct_complete
FROM staging_staging.stg_product
WHERE deleted = false
UNION ALL
SELECT 'Description (Base)',
    COUNT(CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 1 END),
    COUNT(*),
    ROUND(100.0 * COUNT(CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Polish Name',
    COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END),
    COUNT(*),
    ROUND(100.0 * COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Ukrainian Name',
    COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END),
    COUNT(*),
    ROUND(100.0 * COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Weight',
    COUNT(CASE WHEN weight IS NOT NULL THEN 1 END),
    COUNT(*),
    ROUND(100.0 * COUNT(CASE WHEN weight IS NOT NULL THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
ORDER BY field_name;

-- 2.2 Business Flags Summary
SELECT
    'For Web' as flag_name,
    SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) as enabled_count,
    COUNT(*) as total,
    ROUND(100.0 * SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_enabled
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'For Sale',
    SUM(CASE WHEN is_for_sale = true THEN 1 ELSE 0 END),
    COUNT(*),
    ROUND(100.0 * SUM(CASE WHEN is_for_sale = true THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Analogue',
    SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END),
    COUNT(*),
    ROUND(100.0 * SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Image',
    SUM(CASE WHEN has_image = true THEN 1 ELSE 0 END),
    COUNT(*),
    ROUND(100.0 * SUM(CASE WHEN has_image = true THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
ORDER BY flag_name;

-- 2.3 Data Quality Issues (Products Needing Attention)
SELECT
    product_id,
    vendor_code,
    name,
    ARRAY_REMOVE(ARRAY[
        CASE WHEN is_for_sale = false THEN 'Not for sale' END,
        CASE WHEN has_image = false THEN 'No image' END,
        CASE WHEN vendor_code IS NULL OR LENGTH(vendor_code) = 0 THEN 'Missing vendor code' END,
        CASE WHEN weight IS NULL OR weight = 0 THEN 'Missing/zero weight' END,
        CASE WHEN description IS NULL OR LENGTH(description) = 0 THEN 'No description' END
    ], NULL) as issues
FROM staging_staging.stg_product
WHERE deleted = false
  AND (
      is_for_sale = false OR
      has_image = false OR
      vendor_code IS NULL OR LENGTH(vendor_code) = 0 OR
      weight IS NULL OR weight = 0 OR
      description IS NULL OR LENGTH(description) = 0
  )
ORDER BY ARRAY_LENGTH(ARRAY_REMOVE(ARRAY[
    CASE WHEN is_for_sale = false THEN 1 END,
    CASE WHEN has_image = false THEN 1 END,
    CASE WHEN vendor_code IS NULL THEN 1 END,
    CASE WHEN weight IS NULL OR weight = 0 THEN 1 END
], NULL), 1) DESC NULLS LAST, product_id;

-- =============================================================================
-- 3. MULTILINGUAL ANALYTICS
-- =============================================================================

-- 3.1 Multilingual Coverage by Field
SELECT
    'Names' as field_category,
    COUNT(CASE WHEN name IS NOT NULL THEN 1 END) as base_language,
    COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END) as polish,
    COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END) as ukrainian,
    COUNT(CASE WHEN name IS NOT NULL AND name_pl IS NOT NULL AND name_ua IS NOT NULL THEN 1 END) as all_languages
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Descriptions',
    COUNT(CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 1 END),
    COUNT(CASE WHEN description_pl IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN description_ua IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN description_pl IS NOT NULL AND description_ua IS NOT NULL THEN 1 END)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Notes',
    0, -- No base notes field
    COUNT(CASE WHEN notes_pl IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN notes_ua IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN notes_pl IS NOT NULL AND notes_ua IS NOT NULL THEN 1 END)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Synonyms',
    0, -- No base synonyms field
    COUNT(CASE WHEN synonyms_pl IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN synonyms_ua IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN synonyms_pl IS NOT NULL AND synonyms_ua IS NOT NULL THEN 1 END)
FROM staging_staging.stg_product WHERE deleted = false;

-- 3.2 Average Text Lengths by Language
SELECT
    'Name' as field_type,
    ROUND(AVG(LENGTH(name)), 2) as avg_base_length,
    ROUND(AVG(LENGTH(name_pl)), 2) as avg_polish_length,
    ROUND(AVG(LENGTH(name_ua)), 2) as avg_ukrainian_length
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Description',
    ROUND(AVG(LENGTH(description)), 2),
    ROUND(AVG(LENGTH(description_pl)), 2),
    ROUND(AVG(LENGTH(description_ua)), 2)
FROM staging_staging.stg_product WHERE deleted = false;

-- =============================================================================
-- 4. SEMANTIC SEARCH QUERIES
-- =============================================================================

-- 4.1 Find Similar Products (Parameterized)
-- Replace :product_id with actual product ID
WITH target_product AS (
    SELECT embedding
    FROM analytics_features.product_embeddings
    WHERE product_id = :product_id
)
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.name_pl,
    p.name_ua,
    p.has_analogue,
    ROUND((1 - (e.embedding <=> tp.embedding))::numeric, 4) as similarity_score
FROM analytics_features.product_embeddings e
CROSS JOIN target_product tp
JOIN staging_staging.stg_product p ON p.product_id = e.product_id
WHERE e.product_id != :product_id
  AND p.deleted = false
ORDER BY similarity_score DESC
LIMIT 10;

-- 4.2 Find Product Duplicates (High Similarity)
SELECT
    p1.product_id as product_1_id,
    p1.vendor_code as product_1_code,
    p1.name as product_1_name,
    p2.product_id as product_2_id,
    p2.vendor_code as product_2_code,
    p2.name as product_2_name,
    ROUND((1 - (e1.embedding <=> e2.embedding))::numeric, 4) as similarity_score
FROM analytics_features.product_embeddings e1
JOIN analytics_features.product_embeddings e2 ON e1.product_id < e2.product_id
JOIN staging_staging.stg_product p1 ON p1.product_id = e1.product_id
JOIN staging_staging.stg_product p2 ON p2.product_id = e2.product_id
WHERE (1 - (e1.embedding <=> e2.embedding)) > 0.95  -- 95%+ similar
  AND p1.deleted = false
  AND p2.deleted = false
ORDER BY similarity_score DESC;

-- 4.3 Product Diversity Analysis (Most Different Products)
SELECT
    p1.product_id as product_1_id,
    p1.vendor_code as product_1_code,
    p1.name as product_1_name,
    p2.product_id as product_2_id,
    p2.vendor_code as product_2_code,
    p2.name as product_2_name,
    ROUND((1 - (e1.embedding <=> e2.embedding))::numeric, 4) as similarity_score
FROM analytics_features.product_embeddings e1
JOIN analytics_features.product_embeddings e2 ON e1.product_id < e2.product_id
JOIN staging_staging.stg_product p1 ON p1.product_id = e1.product_id
JOIN staging_staging.stg_product p2 ON p2.product_id = e2.product_id
WHERE p1.deleted = false
  AND p2.deleted = false
ORDER BY similarity_score ASC
LIMIT 20;

-- =============================================================================
-- 5. SUPPLIER ANALYTICS
-- =============================================================================

-- 5.1 Top Suppliers by Product Count
SELECT
    COALESCE(LEFT(vendor_code, 4), 'Unknown') as supplier_prefix,
    COUNT(*) as product_count,
    COUNT(CASE WHEN has_analogue = true THEN 1 END) as products_with_analogues,
    ROUND(100.0 * COUNT(CASE WHEN has_analogue = true THEN 1 END) / COUNT(*), 2) as pct_with_analogues,
    STRING_AGG(DISTINCT name, ' | ' ORDER BY name LIMIT 3) as sample_products
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY LEFT(vendor_code, 4)
ORDER BY product_count DESC;

-- 5.2 Supplier Product Details
-- Replace :supplier_prefix with actual prefix (e.g., 'SABO', 'SEM1')
SELECT
    product_id,
    vendor_code,
    name,
    name_pl,
    has_analogue,
    is_for_web,
    weight,
    created
FROM staging_staging.stg_product
WHERE deleted = false
  AND vendor_code LIKE :supplier_prefix || '%'
ORDER BY created DESC;

-- =============================================================================
-- 6. TIME-SERIES ANALYTICS
-- =============================================================================

-- 6.1 Products Added Over Time (Daily)
SELECT
    DATE(created) as date,
    COUNT(*) as products_added,
    SUM(COUNT(*)) OVER (ORDER BY DATE(created)) as cumulative_total
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY DATE(created)
ORDER BY date;

-- 6.2 Product Updates Over Time
SELECT
    DATE(updated) as date,
    COUNT(*) as products_updated,
    COUNT(DISTINCT product_id) as unique_products_updated
FROM staging_staging.stg_product
WHERE deleted = false
  AND updated > created  -- Only actual updates, not initial creation
GROUP BY DATE(updated)
ORDER BY date DESC
LIMIT 30;

-- 6.3 Recent Product Activity
SELECT
    product_id,
    vendor_code,
    name,
    created,
    updated,
    AGE(updated, created) as time_since_creation,
    cdc_operation
FROM staging_staging.stg_product
WHERE deleted = false
ORDER BY updated DESC
LIMIT 20;

-- =============================================================================
-- 7. PHYSICAL PROPERTIES ANALYTICS
-- =============================================================================

-- 7.1 Weight Distribution
SELECT
    CASE
        WHEN weight = 0 THEN '0 kg (Not set)'
        WHEN weight > 0 AND weight <= 0.1 THEN '0-0.1 kg'
        WHEN weight > 0.1 AND weight <= 0.5 THEN '0.1-0.5 kg'
        WHEN weight > 0.5 AND weight <= 1.0 THEN '0.5-1.0 kg'
        WHEN weight > 1.0 THEN '>1.0 kg'
        ELSE 'Unknown'
    END as weight_range,
    COUNT(*) as product_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY weight_range
ORDER BY MIN(weight) NULLS LAST;

-- 7.2 Products with Physical Properties Summary
SELECT
    'Has Size' as property,
    COUNT(CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 1 END) as count,
    ROUND(100.0 * COUNT(CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 1 END) / COUNT(*), 2) as pct
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Weight',
    COUNT(CASE WHEN weight IS NOT NULL AND weight > 0 THEN 1 END),
    ROUND(100.0 * COUNT(CASE WHEN weight IS NOT NULL AND weight > 0 THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Volume',
    COUNT(CASE WHEN volume IS NOT NULL AND LENGTH(volume) > 0 THEN 1 END),
    ROUND(100.0 * COUNT(CASE WHEN volume IS NOT NULL AND LENGTH(volume) > 0 THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false;

-- =============================================================================
-- 8. SOURCE SYSTEM TRACKING
-- =============================================================================

-- 8.1 Products by Source System
SELECT
    CASE
        WHEN source_amg_id IS NOT NULL THEN 'AMG'
        WHEN source_fenix_id IS NOT NULL THEN 'Fenix'
        ELSE 'Unknown'
    END as source_system,
    COUNT(*) as product_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY source_system;

-- 8.2 Products with Parent Relationships
SELECT
    COUNT(CASE WHEN parent_amg_id IS NOT NULL THEN 1 END) as has_amg_parent,
    COUNT(CASE WHEN parent_fenix_id IS NOT NULL THEN 1 END) as has_fenix_parent,
    COUNT(CASE WHEN parent_amg_id IS NULL AND parent_fenix_id IS NULL THEN 1 END) as no_parent,
    COUNT(*) as total
FROM staging_staging.stg_product
WHERE deleted = false;

-- =============================================================================
-- 9. ADVANCED ANALYTICS
-- =============================================================================

-- 9.1 Product Completeness Score
SELECT
    product_id,
    vendor_code,
    name,
    (
        CASE WHEN vendor_code IS NOT NULL THEN 10 ELSE 0 END +
        CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 10 ELSE 0 END +
        CASE WHEN name_pl IS NOT NULL THEN 10 ELSE 0 END +
        CASE WHEN name_ua IS NOT NULL THEN 10 ELSE 0 END +
        CASE WHEN description_pl IS NOT NULL THEN 10 ELSE 0 END +
        CASE WHEN description_ua IS NOT NULL THEN 10 ELSE 0 END +
        CASE WHEN has_analogue = true THEN 10 ELSE 0 END +
        CASE WHEN weight IS NOT NULL AND weight > 0 THEN 10 ELSE 0 END +
        CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 10 ELSE 0 END +
        CASE WHEN is_for_web = true THEN 10 ELSE 0 END
    ) as completeness_score,
    CASE
        WHEN (
            CASE WHEN vendor_code IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 10 ELSE 0 END +
            CASE WHEN name_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN name_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN has_analogue = true THEN 10 ELSE 0 END +
            CASE WHEN weight IS NOT NULL AND weight > 0 THEN 10 ELSE 0 END +
            CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 10 ELSE 0 END +
            CASE WHEN is_for_web = true THEN 10 ELSE 0 END
        ) >= 80 THEN 'Excellent'
        WHEN (
            CASE WHEN vendor_code IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 10 ELSE 0 END +
            CASE WHEN name_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN name_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN has_analogue = true THEN 10 ELSE 0 END +
            CASE WHEN weight IS NOT NULL AND weight > 0 THEN 10 ELSE 0 END +
            CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 10 ELSE 0 END +
            CASE WHEN is_for_web = true THEN 10 ELSE 0 END
        ) >= 60 THEN 'Good'
        ELSE 'Needs Improvement'
    END as quality_grade
FROM staging_staging.stg_product
WHERE deleted = false
ORDER BY completeness_score DESC, product_id;

-- 9.2 Product Completeness Distribution
WITH scores AS (
    SELECT
        (
            CASE WHEN vendor_code IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description IS NOT NULL AND LENGTH(description) > 0 THEN 10 ELSE 0 END +
            CASE WHEN name_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN name_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_pl IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN description_ua IS NOT NULL THEN 10 ELSE 0 END +
            CASE WHEN has_analogue = true THEN 10 ELSE 0 END +
            CASE WHEN weight IS NOT NULL AND weight > 0 THEN 10 ELSE 0 END +
            CASE WHEN size IS NOT NULL AND LENGTH(size) > 0 THEN 10 ELSE 0 END +
            CASE WHEN is_for_web = true THEN 10 ELSE 0 END
        ) as score
    FROM staging_staging.stg_product
    WHERE deleted = false
)
SELECT
    CASE
        WHEN score >= 80 THEN 'Excellent (80-100)'
        WHEN score >= 60 THEN 'Good (60-79)'
        WHEN score >= 40 THEN 'Fair (40-59)'
        ELSE 'Needs Improvement (<40)'
    END as quality_category,
    COUNT(*) as product_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM scores
GROUP BY quality_category
ORDER BY MIN(score) DESC;

-- =============================================================================
-- 10. MONITORING & ALERTS
-- =============================================================================

-- 10.1 Data Freshness Check
SELECT
    'Last Product Update' as metric,
    MAX(updated) as last_timestamp,
    AGE(NOW(), MAX(updated)) as time_since_last_update
FROM staging_staging.stg_product
UNION ALL
SELECT
    'Last Product Created',
    MAX(created),
    AGE(NOW(), MAX(created))
FROM staging_staging.stg_product
UNION ALL
SELECT
    'Last CDC Ingestion',
    MAX(ingested_at),
    AGE(NOW(), MAX(ingested_at))
FROM staging_staging.stg_product;

-- 10.2 Data Quality Alert Thresholds
SELECT
    'Missing Vendor Codes' as alert_type,
    COUNT(*) as affected_products,
    'CRITICAL' as severity
FROM staging_staging.stg_product
WHERE deleted = false AND (vendor_code IS NULL OR LENGTH(vendor_code) = 0)
UNION ALL
SELECT
    'Products Not For Sale',
    COUNT(*),
    'WARNING'
FROM staging_staging.stg_product
WHERE deleted = false AND is_for_sale = false
UNION ALL
SELECT
    'Products Without Images',
    COUNT(*),
    'INFO'
FROM staging_staging.stg_product
WHERE deleted = false AND has_image = false
UNION ALL
SELECT
    'Missing Weight Data',
    COUNT(*),
    'WARNING'
FROM staging_staging.stg_product
WHERE deleted = false AND (weight IS NULL OR weight = 0)
ORDER BY severity, affected_products DESC;

-- End of Dashboard Queries
