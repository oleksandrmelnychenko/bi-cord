-- ML Feature Extraction Queries for Product Search
-- Purpose: Extract and transform product data for machine learning and semantic search
-- Date: 2025-10-19

-- ==============================================================================
-- 1. COMBINED TEXT FEATURES FOR EMBEDDING GENERATION
-- ==============================================================================
-- Purpose: Concatenate all searchable text fields for semantic embedding
-- Use Case: Input to sentence-transformers model for vector generation

CREATE OR REPLACE VIEW analytics_features.product_text_features AS
SELECT
    p.product_id,
    p.vendor_code,
    p.net_uid,

    -- Combined multilingual text for embedding (384-dimensional vector)
    CONCAT_WS(' | ',
        -- Base language fields
        COALESCE(p.name, ''),
        COALESCE(p.description, ''),
        COALESCE(p.vendor_code, ''),
        COALESCE(p.main_original_number, ''),

        -- Polish language fields
        COALESCE(p.polish_name, ''),
        COALESCE(p.polish_description, ''),

        -- Ukrainian language fields
        COALESCE(p.ukrainian_name, ''),
        COALESCE(p.ukrainian_description, ''),

        -- Search-optimized fields
        COALESCE(p.search_name, ''),
        COALESCE(p.search_polish_name, ''),
        COALESCE(p.search_ukrainian_name, ''),

        -- Additional context
        COALESCE(p.size, ''),
        COALESCE(p.ucgfea, ''),
        COALESCE(p.standard, '')
    ) AS combined_text,

    -- Character count for quality metrics
    LENGTH(CONCAT_WS(' | ',
        COALESCE(p.name, ''),
        COALESCE(p.description, ''),
        COALESCE(p.polish_name, ''),
        COALESCE(p.ukrainian_name, '')
    )) AS text_length,

    -- Language completeness flags
    (p.polish_name IS NOT NULL AND p.polish_description IS NOT NULL) AS has_polish,
    (p.ukrainian_name IS NOT NULL AND p.ukrainian_description IS NOT NULL) AS has_ukrainian,

    p.created,
    p.updated

FROM staging_marts.dim_product p
WHERE p.deleted = false;

COMMENT ON VIEW analytics_features.product_text_features IS
'Combines all product text fields for ML embedding generation. Used by embedding_pipeline.py';


-- ==============================================================================
-- 2. CATEGORICAL FEATURES FOR FILTERING AND RANKING
-- ==============================================================================
-- Purpose: Extract categorical features for search filtering and ranking
-- Use Case: Filter results by supplier, flags, weight range, etc.

CREATE OR REPLACE VIEW analytics_features.product_categorical_features AS
SELECT
    p.product_id,
    p.vendor_code,

    -- Supplier encoding
    SUBSTRING(p.vendor_code, 1, 4) AS supplier_code,
    p.supplier_name,

    -- Business flags (converted to integers for ML models)
    CASE WHEN p.has_analogue THEN 1 ELSE 0 END AS has_analogue_flag,
    CASE WHEN p.has_image THEN 1 ELSE 0 END AS has_image_flag,
    CASE WHEN p.is_for_sale THEN 1 ELSE 0 END AS for_sale_flag,
    CASE WHEN p.is_for_web THEN 1 ELSE 0 END AS web_flag,
    CASE WHEN p.has_component THEN 1 ELSE 0 END AS has_component_flag,

    -- Weight category encoding
    CASE p.weight_category
        WHEN 'Missing' THEN 0
        WHEN 'Light' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Heavy' THEN 3
        ELSE 0
    END AS weight_category_encoded,

    -- Multilingual status encoding
    CASE p.multilingual_status
        WHEN 'Missing' THEN 0
        WHEN 'Partial' THEN 1
        WHEN 'Complete' THEN 2
        ELSE 0
    END AS multilingual_status_encoded,

    p.created,
    p.updated

FROM staging_marts.dim_product p
WHERE p.deleted = false;

COMMENT ON VIEW analytics_features.product_categorical_features IS
'Categorical features encoded for ML models and search filtering';


-- ==============================================================================
-- 3. NUMERICAL FEATURES FOR RANKING AND SCORING
-- ==============================================================================
-- Purpose: Extract and normalize numerical features
-- Use Case: Ranking search results, relevance scoring

CREATE OR REPLACE VIEW analytics_features.product_numerical_features AS
SELECT
    p.product_id,
    p.vendor_code,

    -- Raw numerical values
    COALESCE(p.weight, 0) AS weight_raw,

    -- Normalized weight (0-1 scale using log transformation for heavy tail)
    CASE
        WHEN p.weight > 0 THEN
            LEAST(LOG(1 + p.weight) / 10.0, 1.0)  -- Cap at 1.0
        ELSE 0
    END AS weight_normalized,

    -- Age features (freshness for ranking)
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.created)) / 86400.0 AS age_days,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.updated)) / 86400.0 AS days_since_update,

    -- Recency score (newer products score higher)
    CASE
        WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.created)) / 86400.0 <= 30 THEN 1.0
        WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.created)) / 86400.0 <= 90 THEN 0.8
        WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.created)) / 86400.0 <= 180 THEN 0.6
        WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - p.created)) / 86400.0 <= 365 THEN 0.4
        ELSE 0.2
    END AS recency_score,

    -- Data completeness score (0-1)
    (
        CASE WHEN p.name IS NOT NULL THEN 0.15 ELSE 0 END +
        CASE WHEN p.description IS NOT NULL THEN 0.15 ELSE 0 END +
        CASE WHEN p.polish_name IS NOT NULL THEN 0.1 ELSE 0 END +
        CASE WHEN p.polish_description IS NOT NULL THEN 0.1 ELSE 0 END +
        CASE WHEN p.ukrainian_name IS NOT NULL THEN 0.1 ELSE 0 END +
        CASE WHEN p.ukrainian_description IS NOT NULL THEN 0.1 ELSE 0 END +
        CASE WHEN p.weight > 0 THEN 0.1 ELSE 0 END +
        CASE WHEN p.has_image THEN 0.1 ELSE 0 END +
        CASE WHEN p.has_analogue THEN 0.05 ELSE 0 END +
        CASE WHEN p.is_for_sale THEN 0.05 ELSE 0 END
    ) AS completeness_score,

    p.created,
    p.updated

FROM staging_marts.dim_product p
WHERE p.deleted = false;

COMMENT ON VIEW analytics_features.product_numerical_features IS
'Numerical features normalized for ranking and relevance scoring';


-- ==============================================================================
-- 4. COMBINED FEATURE SET FOR ML MODELS
-- ==============================================================================
-- Purpose: Join all feature types for comprehensive ML input
-- Use Case: Training recommendation models, advanced search ranking

CREATE OR REPLACE VIEW analytics_features.product_ml_features AS
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.supplier_name,

    -- Text features
    t.combined_text,
    t.text_length,
    t.has_polish,
    t.has_ukrainian,

    -- Categorical features
    c.supplier_code,
    c.has_analogue_flag,
    c.has_image_flag,
    c.for_sale_flag,
    c.web_flag,
    c.has_component_flag,
    c.weight_category_encoded,
    c.multilingual_status_encoded,

    -- Numerical features
    n.weight_raw,
    n.weight_normalized,
    n.age_days,
    n.days_since_update,
    n.recency_score,
    n.completeness_score,

    p.created,
    p.updated

FROM staging_marts.dim_product p
LEFT JOIN analytics_features.product_text_features t ON t.product_id = p.product_id
LEFT JOIN analytics_features.product_categorical_features c ON c.product_id = p.product_id
LEFT JOIN analytics_features.product_numerical_features n ON n.product_id = p.product_id
WHERE p.deleted = false;

COMMENT ON VIEW analytics_features.product_ml_features IS
'Comprehensive feature set combining text, categorical, and numerical features for ML models';


-- ==============================================================================
-- 5. SEARCH QUALITY METRICS
-- ==============================================================================
-- Purpose: Analyze product data quality for search effectiveness
-- Use Case: Identify products needing enrichment, quality monitoring

CREATE OR REPLACE VIEW analytics_features.search_quality_metrics AS
SELECT
    COUNT(*) AS total_products,

    -- Text completeness
    COUNT(CASE WHEN name IS NOT NULL AND LENGTH(name) > 5 THEN 1 END) AS has_valid_name,
    COUNT(CASE WHEN description IS NOT NULL AND LENGTH(description) > 10 THEN 1 END) AS has_valid_description,

    -- Multilingual coverage
    COUNT(CASE WHEN polish_name IS NOT NULL THEN 1 END) AS has_polish_name,
    COUNT(CASE WHEN ukrainian_name IS NOT NULL THEN 1 END) AS has_ukrainian_name,

    -- Search field optimization
    COUNT(CASE WHEN search_name IS NOT NULL THEN 1 END) AS has_search_name,
    COUNT(CASE WHEN search_polish_name IS NOT NULL THEN 1 END) AS has_search_polish_name,
    COUNT(CASE WHEN search_ukrainian_name IS NOT NULL THEN 1 END) AS has_search_ukrainian_name,

    -- Business flags
    COUNT(CASE WHEN is_for_sale THEN 1 END) AS products_for_sale,
    COUNT(CASE WHEN is_for_web THEN 1 END) AS products_on_web,
    COUNT(CASE WHEN has_image THEN 1 END) AS products_with_images,
    COUNT(CASE WHEN has_analogue THEN 1 END) AS products_with_analogues,

    -- Quality percentages
    ROUND(100.0 * COUNT(CASE WHEN name IS NOT NULL AND LENGTH(name) > 5 THEN 1 END) / COUNT(*), 2) AS pct_valid_name,
    ROUND(100.0 * COUNT(CASE WHEN polish_name IS NOT NULL THEN 1 END) / COUNT(*), 2) AS pct_polish,
    ROUND(100.0 * COUNT(CASE WHEN ukrainian_name IS NOT NULL THEN 1 END) / COUNT(*), 2) AS pct_ukrainian

FROM staging_marts.dim_product
WHERE deleted = false;

COMMENT ON VIEW analytics_features.search_quality_metrics IS
'Aggregated metrics for monitoring search data quality and completeness';


-- ==============================================================================
-- USAGE EXAMPLES
-- ==============================================================================

-- Example 1: Get text features for embedding generation (used by embedding_pipeline.py)
-- SELECT product_id, combined_text FROM analytics_features.product_text_features LIMIT 1000;

-- Example 2: Get products with highest completeness for featured results
-- SELECT * FROM analytics_features.product_ml_features
-- WHERE completeness_score > 0.8
-- ORDER BY recency_score DESC, completeness_score DESC LIMIT 20;

-- Example 3: Find products needing multilingual enrichment
-- SELECT product_id, vendor_code, name, has_polish, has_ukrainian
-- FROM analytics_features.product_text_features
-- WHERE NOT has_polish OR NOT has_ukrainian
-- ORDER BY product_id LIMIT 100;

-- Example 4: Monitor search quality metrics
-- SELECT * FROM analytics_features.search_quality_metrics;

-- Example 5: Get products by supplier with quality scores
-- SELECT supplier_name, COUNT(*) as product_count,
--        AVG(completeness_score) as avg_quality,
--        AVG(recency_score) as avg_recency
-- FROM analytics_features.product_ml_features
-- GROUP BY supplier_name
-- ORDER BY product_count DESC;
