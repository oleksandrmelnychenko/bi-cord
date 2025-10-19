-- ============================================================================
-- Search Analytics Infrastructure
-- Purpose: Track user queries and clicks for intelligent search optimization
-- Date: 2025-10-19
-- ============================================================================

-- Create analytics_features schema if not exists
CREATE SCHEMA IF NOT EXISTS analytics_features;

-- ============================================================================
-- Query Log Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS analytics_features.search_query_log (
    query_id BIGSERIAL PRIMARY KEY,
    query_text TEXT NOT NULL,
    query_type VARCHAR(50),  -- vendor_code, exact_phrase, natural_language
    search_endpoint VARCHAR(100),  -- which endpoint was used
    result_count INTEGER,
    execution_time_ms FLOAT,
    user_id VARCHAR(100),  -- for future user tracking
    session_id VARCHAR(100),
    ip_address INET,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata JSONB  -- flexible for additional context
);

CREATE INDEX idx_search_query_log_timestamp ON analytics_features.search_query_log(timestamp DESC);
CREATE INDEX idx_search_query_log_query_text ON analytics_features.search_query_log(query_text);
CREATE INDEX idx_search_query_log_query_type ON analytics_features.search_query_log(query_type);

-- ============================================================================
-- Click-Through Tracking
-- ============================================================================

CREATE TABLE IF NOT EXISTS analytics_features.search_click_log (
    click_id BIGSERIAL PRIMARY KEY,
    query_id BIGINT REFERENCES analytics_features.search_query_log(query_id),
    product_id BIGINT NOT NULL,
    rank_position INTEGER,  -- position in search results (1-based)
    similarity_score FLOAT,
    clicked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    session_id VARCHAR(100),
    metadata JSONB
);

CREATE INDEX idx_search_click_log_query_id ON analytics_features.search_click_log(query_id);
CREATE INDEX idx_search_click_log_product_id ON analytics_features.search_click_log(product_id);
CREATE INDEX idx_search_click_log_clicked_at ON analytics_features.search_click_log(clicked_at DESC);

-- ============================================================================
-- Dynamic Keyword Cache
-- ============================================================================

CREATE TABLE IF NOT EXISTS analytics_features.product_keyword_cache (
    id SERIAL PRIMARY KEY,
    language VARCHAR(20) NOT NULL,  -- ukrainian, polish, russian, english
    keyword TEXT NOT NULL,
    frequency INTEGER NOT NULL,
    last_updated TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(language, keyword)
);

CREATE INDEX idx_product_keyword_cache_language ON analytics_features.product_keyword_cache(language);
CREATE INDEX idx_product_keyword_cache_frequency ON analytics_features.product_keyword_cache(frequency DESC);

-- ============================================================================
-- Materialized View: Popular Keywords by Language
-- ============================================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics_features.mv_popular_keywords AS
WITH ukrainian_keywords AS (
    SELECT
        'ukrainian' as language,
        unnest(string_to_array(LOWER(ukrainian_name), ' ')) as keyword,
        COUNT(*) as frequency
    FROM staging_marts.dim_product
    WHERE ukrainian_name IS NOT NULL
    GROUP BY keyword
),
polish_keywords AS (
    SELECT
        'polish' as language,
        unnest(string_to_array(LOWER(polish_name), ' ')) as keyword,
        COUNT(*) as frequency
    FROM staging_marts.dim_product
    WHERE polish_name IS NOT NULL
    GROUP BY keyword
),
all_keywords AS (
    SELECT * FROM ukrainian_keywords
    UNION ALL
    SELECT * FROM polish_keywords
)
SELECT
    language,
    keyword,
    SUM(frequency) as total_frequency
FROM all_keywords
WHERE LENGTH(keyword) >= 4
    AND keyword NOT IN ('null', 'для', 'або', 'przód', 'tył', 'oraz')
GROUP BY language, keyword
HAVING SUM(frequency) >= 100
ORDER BY language, total_frequency DESC;

CREATE INDEX idx_mv_popular_keywords_language ON analytics_features.mv_popular_keywords(language);
CREATE INDEX idx_mv_popular_keywords_frequency ON analytics_features.mv_popular_keywords(total_frequency DESC);

-- ============================================================================
-- Function: Refresh Keyword Cache
-- ============================================================================

CREATE OR REPLACE FUNCTION analytics_features.refresh_keyword_cache()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY analytics_features.mv_popular_keywords;

    INSERT INTO analytics_features.product_keyword_cache (language, keyword, frequency, last_updated)
    SELECT language, keyword, total_frequency::integer, NOW()
    FROM analytics_features.mv_popular_keywords
    WHERE total_frequency >= 100
    ON CONFLICT (language, keyword)
    DO UPDATE SET
        frequency = EXCLUDED.frequency,
        last_updated = EXCLUDED.last_updated;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Query Analytics Views
-- ============================================================================

-- Top queries by frequency
CREATE OR REPLACE VIEW analytics_features.v_top_queries AS
SELECT
    query_text,
    query_type,
    COUNT(*) as query_count,
    AVG(execution_time_ms) as avg_execution_time,
    AVG(result_count) as avg_result_count,
    MAX(timestamp) as last_queried
FROM analytics_features.search_query_log
GROUP BY query_text, query_type
ORDER BY query_count DESC;

-- Click-through rate by query type
CREATE OR REPLACE VIEW analytics_features.v_ctr_by_query_type AS
SELECT
    ql.query_type,
    COUNT(DISTINCT ql.query_id) as total_queries,
    COUNT(DISTINCT cl.query_id) as queries_with_clicks,
    ROUND(100.0 * COUNT(DISTINCT cl.query_id) / COUNT(DISTINCT ql.query_id), 2) as ctr_percentage
FROM analytics_features.search_query_log ql
LEFT JOIN analytics_features.search_click_log cl ON ql.query_id = cl.query_id
GROUP BY ql.query_type;

-- ============================================================================
-- Initial Keyword Cache Population
-- ============================================================================

-- Refresh materialized view
REFRESH MATERIALIZED VIEW analytics_features.mv_popular_keywords;

-- Populate initial cache
INSERT INTO analytics_features.product_keyword_cache (language, keyword, frequency, last_updated)
SELECT language, keyword, total_frequency::integer, NOW()
FROM analytics_features.mv_popular_keywords
WHERE total_frequency >= 100
ON CONFLICT (language, keyword)
DO UPDATE SET
    frequency = EXCLUDED.frequency,
    last_updated = EXCLUDED.last_updated;

-- ============================================================================
-- Success!
-- ============================================================================

SELECT
    'Search Analytics Infrastructure Created' as status,
    COUNT(*) FILTER (WHERE language = 'ukrainian') as ukrainian_keywords,
    COUNT(*) FILTER (WHERE language = 'polish') as polish_keywords,
    COUNT(*) as total_keywords
FROM analytics_features.product_keyword_cache;
