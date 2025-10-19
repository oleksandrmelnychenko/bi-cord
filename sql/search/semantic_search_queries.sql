-- Semantic Search SQL Query Library
-- Purpose: Production-ready queries for AI-powered product search using pgvector
-- Date: 2025-10-19
-- Requirements: pgvector extension, analytics_features.product_embeddings table

-- ==============================================================================
-- SETUP: Ensure pgvector extension is enabled
-- ==============================================================================
CREATE EXTENSION IF NOT EXISTS vector;

-- ==============================================================================
-- 1. PURE VECTOR SIMILARITY SEARCH
-- ==============================================================================
-- Purpose: Find products most similar to a query embedding
-- Use Case: "Products similar to this description..."
-- Performance: <100ms with HNSW index for top-20 results

-- Query Template (replace %s with query embedding vector)
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.ukrainian_name,
    p.supplier_name,
    p.weight,
    p.is_for_sale,
    p.is_for_web,
    p.has_image,
    p.created,
    1 - (e.embedding <=> %s::vector) AS similarity_score
FROM staging_marts.dim_product p
JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false
ORDER BY e.embedding <=> %s::vector
LIMIT 20;

-- Alternative: Using cosine distance operator (<=>)
-- Note: pgvector supports <-> (L2), <#> (inner product), <=> (cosine)
-- Cosine distance is best for normalized embeddings from sentence-transformers


-- ==============================================================================
-- 2. FILTERED VECTOR SEARCH
-- ==============================================================================
-- Purpose: Semantic search with business logic filters
-- Use Case: "Find similar products from specific supplier that are for sale"

-- Filter by Supplier
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.supplier_name,
    p.weight,
    p.is_for_sale,
    1 - (e.embedding <=> %s::vector) AS similarity_score
FROM staging_marts.dim_product p
JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false
    AND p.supplier_name = %s  -- e.g., 'SEM1', 'SABO'
    AND p.is_for_sale = true
ORDER BY e.embedding <=> %s::vector
LIMIT 20;

-- Filter by Weight Range
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.weight,
    p.weight_category,
    1 - (e.embedding <=> %s::vector) AS similarity_score
FROM staging_marts.dim_product p
JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false
    AND p.weight BETWEEN %s AND %s  -- e.g., 0.5 and 5.0 kg
ORDER BY e.embedding <=> %s::vector
LIMIT 20;

-- Filter by Multiple Criteria
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.supplier_name,
    p.weight,
    p.has_analogue,
    1 - (e.embedding <=> %s::vector) AS similarity_score
FROM staging_marts.dim_product p
JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false
    AND p.is_for_web = true
    AND p.has_image = true
    AND p.supplier_name IN (%s)  -- List of approved suppliers
    AND p.multilingual_status = 'Complete'
ORDER BY e.embedding <=> %s::vector
LIMIT 20;


-- ==============================================================================
-- 3. HYBRID SEARCH (Text + Vector)
-- ==============================================================================
-- Purpose: Combine full-text search with semantic similarity
-- Use Case: When user query matches both keywords AND meaning
-- Performance: Requires full-text index on search fields

-- Create full-text search index (run once)
CREATE INDEX IF NOT EXISTS idx_product_search_text
ON staging_marts.dim_product
USING GIN (to_tsvector('polish', COALESCE(polish_name, '') || ' ' || COALESCE(polish_description, '')));

-- Hybrid search query (Polish)
WITH text_matches AS (
    SELECT
        product_id,
        ts_rank_cd(
            to_tsvector('polish', COALESCE(polish_name, '') || ' ' || COALESCE(polish_description, '')),
            plainto_tsquery('polish', %s)
        ) AS text_score
    FROM staging_marts.dim_product
    WHERE deleted = false
        AND to_tsvector('polish', COALESCE(polish_name, '') || ' ' || COALESCE(polish_description, ''))
            @@ plainto_tsquery('polish', %s)
),
vector_matches AS (
    SELECT
        e.product_id,
        1 - (e.embedding <=> %s::vector) AS vector_score
    FROM analytics_features.product_embeddings e
)
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.supplier_name,
    p.weight,
    COALESCE(t.text_score, 0) AS text_score,
    COALESCE(v.vector_score, 0) AS vector_score,
    -- Combined score: 30% text, 70% semantic
    (COALESCE(t.text_score, 0) * 0.3 + COALESCE(v.vector_score, 0) * 0.7) AS combined_score
FROM staging_marts.dim_product p
LEFT JOIN text_matches t ON t.product_id = p.product_id
LEFT JOIN vector_matches v ON v.product_id = p.product_id
WHERE p.deleted = false
    AND (t.text_score > 0 OR v.vector_score > 0.5)  -- Threshold for inclusion
ORDER BY combined_score DESC
LIMIT 20;


-- ==============================================================================
-- 4. FIND SIMILAR PRODUCTS (Product-to-Product Similarity)
-- ==============================================================================
-- Purpose: "Customers who viewed this also viewed..."
-- Use Case: Product recommendation, alternative suggestions

SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.supplier_name,
    p.weight,
    p.has_analogue,
    1 - (e1.embedding <=> e2.embedding) AS similarity_score
FROM analytics_features.product_embeddings e1
CROSS JOIN analytics_features.product_embeddings e2
JOIN staging_marts.dim_product p ON p.product_id = e2.product_id
WHERE e1.product_id = %s  -- Source product ID
    AND e2.product_id != %s  -- Exclude the source product
    AND p.deleted = false
ORDER BY e1.embedding <=> e2.embedding
LIMIT 10;


-- ==============================================================================
-- 5. MULTI-VECTOR SEARCH (Query Expansion)
-- ==============================================================================
-- Purpose: Search using multiple query embeddings (e.g., different phrasings)
-- Use Case: Robust search across multiple interpretations

WITH query_vectors AS (
    SELECT unnest(ARRAY[
        %s::vector,  -- Query embedding 1
        %s::vector,  -- Query embedding 2
        %s::vector   -- Query embedding 3
    ]) AS query_embedding
),
ranked_products AS (
    SELECT
        p.product_id,
        p.vendor_code,
        p.name,
        MIN(e.embedding <=> q.query_embedding) AS min_distance,
        AVG(1 - (e.embedding <=> q.query_embedding)) AS avg_similarity
    FROM analytics_features.product_embeddings e
    CROSS JOIN query_vectors q
    JOIN staging_marts.dim_product p ON p.product_id = e.product_id
    WHERE p.deleted = false
    GROUP BY p.product_id, p.vendor_code, p.name
)
SELECT
    product_id,
    vendor_code,
    name,
    min_distance,
    avg_similarity,
    -- Combined score favoring products that match ALL queries
    (avg_similarity * 0.7 + (1 - min_distance) * 0.3) AS combined_score
FROM ranked_products
ORDER BY combined_score DESC
LIMIT 20;


-- ==============================================================================
-- 6. SEMANTIC SEARCH WITH BUSINESS RANKING
-- ==============================================================================
-- Purpose: Combine semantic similarity with business rules for ranking
-- Use Case: Boost high-quality, in-stock, featured products

SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.supplier_name,
    p.weight,
    p.is_for_sale,
    p.has_image,
    1 - (e.embedding <=> %s::vector) AS similarity_score,

    -- Business ranking factors
    CASE WHEN p.is_for_sale THEN 1.2 ELSE 1.0 END AS for_sale_boost,
    CASE WHEN p.has_image THEN 1.1 ELSE 1.0 END AS image_boost,
    CASE WHEN p.has_analogue THEN 1.05 ELSE 1.0 END AS analogue_boost,
    CASE
        WHEN p.multilingual_status = 'Complete' THEN 1.15
        WHEN p.multilingual_status = 'Partial' THEN 1.05
        ELSE 1.0
    END AS multilingual_boost,

    -- Combined final score
    (1 - (e.embedding <=> %s::vector)) *
    CASE WHEN p.is_for_sale THEN 1.2 ELSE 1.0 END *
    CASE WHEN p.has_image THEN 1.1 ELSE 1.0 END *
    CASE WHEN p.has_analogue THEN 1.05 ELSE 1.0 END *
    CASE
        WHEN p.multilingual_status = 'Complete' THEN 1.15
        WHEN p.multilingual_status = 'Partial' THEN 1.05
        ELSE 1.0
    END AS final_score

FROM staging_marts.dim_product p
JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false
ORDER BY final_score DESC
LIMIT 20;


-- ==============================================================================
-- 7. FACETED SEARCH (Aggregations for Filtering UI)
-- ==============================================================================
-- Purpose: Get aggregated counts for search filters
-- Use Case: "Show me facets for refinement (suppliers, weight ranges, etc.)"

WITH search_results AS (
    SELECT
        p.product_id,
        p.supplier_name,
        p.weight_category,
        p.multilingual_status,
        p.is_for_sale,
        p.has_image,
        1 - (e.embedding <=> %s::vector) AS similarity_score
    FROM staging_marts.dim_product p
    JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
    WHERE p.deleted = false
        AND (1 - (e.embedding <=> %s::vector)) > 0.3  -- Minimum similarity threshold
)
SELECT
    'Supplier' AS facet_type,
    supplier_name AS facet_value,
    COUNT(*) AS count
FROM search_results
GROUP BY supplier_name

UNION ALL

SELECT
    'Weight Category' AS facet_type,
    weight_category AS facet_value,
    COUNT(*) AS count
FROM search_results
GROUP BY weight_category

UNION ALL

SELECT
    'Multilingual Status' AS facet_type,
    multilingual_status AS facet_value,
    COUNT(*) AS count
FROM search_results
GROUP BY multilingual_status

UNION ALL

SELECT
    'For Sale' AS facet_type,
    CASE WHEN is_for_sale THEN 'Yes' ELSE 'No' END AS facet_value,
    COUNT(*) AS count
FROM search_results
GROUP BY is_for_sale

UNION ALL

SELECT
    'Has Image' AS facet_type,
    CASE WHEN has_image THEN 'Yes' ELSE 'No' END AS facet_value,
    COUNT(*) AS count
FROM search_results
GROUP BY has_image

ORDER BY facet_type, count DESC;


-- ==============================================================================
-- 8. APPROXIMATE NEAREST NEIGHBOR SEARCH (HNSW Index)
-- ==============================================================================
-- Purpose: Fast approximate search for large datasets
-- Performance: Sub-100ms for millions of vectors

-- Create HNSW index (run once after embedding generation)
CREATE INDEX IF NOT EXISTS idx_product_embeddings_hnsw
ON analytics_features.product_embeddings
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- Update index statistics
ANALYZE analytics_features.product_embeddings;

-- Query using HNSW index (automatically used by optimizer)
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    1 - (e.embedding <=> %s::vector) AS similarity_score
FROM analytics_features.product_embeddings e
JOIN staging_marts.dim_product p ON p.product_id = e.product_id
WHERE p.deleted = false
ORDER BY e.embedding <=> %s::vector
LIMIT 20;

-- Note: HNSW provides ~95-99% accuracy with 10-100x speed improvement


-- ==============================================================================
-- 9. PERFORMANCE MONITORING QUERIES
-- ==============================================================================

-- Check embedding coverage
SELECT
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT e.product_id) AS products_with_embeddings,
    ROUND(100.0 * COUNT(DISTINCT e.product_id) / NULLIF(COUNT(DISTINCT p.product_id), 0), 2) AS coverage_pct
FROM staging_marts.dim_product p
LEFT JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.deleted = false;

-- Check embedding quality (self-similarity should be ~1.0)
SELECT
    e1.product_id,
    1 - (e1.embedding <=> e2.embedding) AS self_similarity
FROM analytics_features.product_embeddings e1
JOIN analytics_features.product_embeddings e2 ON e1.product_id = e2.product_id
LIMIT 10;

-- Search performance test (explain analyze)
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    p.product_id,
    p.name,
    1 - (e.embedding <=> '[0.1, 0.2, ...]'::vector) AS similarity
FROM analytics_features.product_embeddings e
JOIN staging_marts.dim_product p ON p.product_id = e.product_id
WHERE p.deleted = false
ORDER BY e.embedding <=> '[0.1, 0.2, ...]'::vector
LIMIT 20;


-- ==============================================================================
-- USAGE EXAMPLES FOR FASTAPI
-- ==============================================================================

-- Example 1: Simple semantic search
-- POST /search/semantic
-- { "query": "brake pads", "limit": 20 }
-- → Generate embedding for "brake pads"
-- → Execute Query #1 with embedding

-- Example 2: Filtered search by supplier
-- POST /search/filtered
-- { "query": "filters", "supplier": "SEM1", "limit": 20 }
-- → Generate embedding
-- → Execute Query #2 with supplier filter

-- Example 3: Find similar products
-- GET /search/similar/{product_id}
-- → Execute Query #4 with product_id

-- Example 4: Hybrid text + semantic search
-- POST /search/hybrid
-- { "query": "filtry oleju", "language": "polish", "limit": 20 }
-- → Execute Query #3 with Polish full-text + vector search
