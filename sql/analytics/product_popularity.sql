-- ============================================================================
-- Product Popularity Tracking for Search Ranking
-- Purpose: Track and aggregate product popularity signals for ML ranking
-- Date: 2025-10-19
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS analytics_features;

-- ============================================================================
-- Product Popularity Scores Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS analytics_features.product_popularity_scores (
    product_id BIGINT PRIMARY KEY,

    -- Engagement metrics
    view_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    conversion_count INTEGER DEFAULT 0,

    -- Derived scores
    popularity_score FLOAT DEFAULT 0.0,  -- Normalized 0-1 score
    trending_score FLOAT DEFAULT 0.0,    -- Recent activity boost

    -- Timestamps
    last_viewed TIMESTAMPTZ,
    last_clicked TIMESTAMPTZ,
    last_converted TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_product_popularity_score
ON analytics_features.product_popularity_scores(popularity_score DESC);

CREATE INDEX IF NOT EXISTS idx_product_trending_score
ON analytics_features.product_popularity_scores(trending_score DESC);

-- ============================================================================
-- Materialized View: Popularity from Search Analytics
-- ============================================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics_features.mv_product_popularity AS
SELECT
    cl.product_id,
    COUNT(DISTINCT ql.query_id) as view_count,
    COUNT(DISTINCT cl.click_id) as click_count,
    0 as conversion_count,  -- Placeholder for future conversion tracking

    -- Calculate popularity score using log scale
    -- Formula: log(1 + clicks * 3 + views) / log(100)
    LEAST(1.0, LOG(1 + COUNT(DISTINCT cl.click_id) * 3 + COUNT(DISTINCT ql.query_id)) / LOG(100)) as popularity_score,

    -- Trending score (last 7 days activity)
    LEAST(1.0, LOG(1 +
        COUNT(DISTINCT cl.click_id) FILTER (WHERE cl.clicked_at > NOW() - INTERVAL '7 days') * 3 +
        COUNT(DISTINCT ql.query_id) FILTER (WHERE ql.timestamp > NOW() - INTERVAL '7 days')
    ) / LOG(50)) as trending_score,

    MAX(ql.timestamp) as last_viewed,
    MAX(cl.clicked_at) as last_clicked,
    NULL::timestamptz as last_converted,
    NOW() as updated_at
FROM analytics_features.search_query_log ql
LEFT JOIN analytics_features.search_click_log cl ON ql.query_id = cl.query_id
WHERE cl.product_id IS NOT NULL
GROUP BY cl.product_id;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_product_popularity_product_id
ON analytics_features.mv_product_popularity(product_id);

-- ============================================================================
-- Function: Refresh Popularity Scores
-- ============================================================================

CREATE OR REPLACE FUNCTION analytics_features.refresh_popularity_scores()
RETURNS void AS $$
BEGIN
    -- Refresh materialized view
    REFRESH MATERIALIZED VIEW CONCURRENTLY analytics_features.mv_product_popularity;

    -- Upsert into main popularity table
    INSERT INTO analytics_features.product_popularity_scores (
        product_id,
        view_count,
        click_count,
        conversion_count,
        popularity_score,
        trending_score,
        last_viewed,
        last_clicked,
        last_converted,
        updated_at
    )
    SELECT
        product_id,
        view_count,
        click_count,
        conversion_count,
        popularity_score,
        trending_score,
        last_viewed,
        last_clicked,
        last_converted,
        updated_at
    FROM analytics_features.mv_product_popularity
    ON CONFLICT (product_id) DO UPDATE SET
        view_count = EXCLUDED.view_count,
        click_count = EXCLUDED.click_count,
        conversion_count = EXCLUDED.conversion_count,
        popularity_score = EXCLUDED.popularity_score,
        trending_score = EXCLUDED.trending_score,
        last_viewed = EXCLUDED.last_viewed,
        last_clicked = EXCLUDED.last_clicked,
        last_converted = EXCLUDED.last_converted,
        updated_at = EXCLUDED.updated_at;

    -- Set default scores for products without analytics data
    INSERT INTO analytics_features.product_popularity_scores (product_id, popularity_score, trending_score)
    SELECT p.product_id, 0.0, 0.0
    FROM staging_marts.dim_product p
    WHERE NOT EXISTS (
        SELECT 1 FROM analytics_features.product_popularity_scores pop
        WHERE pop.product_id = p.product_id
    )
    ON CONFLICT (product_id) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Initial Population
-- ============================================================================

-- Initialize with zero scores for all products (will be updated as analytics data comes in)
INSERT INTO analytics_features.product_popularity_scores (product_id, popularity_score, trending_score)
SELECT product_id, 0.0, 0.0
FROM staging_marts.dim_product
ON CONFLICT (product_id) DO NOTHING;

-- ============================================================================
-- Verification
-- ============================================================================

SELECT
    COUNT(*) as total_products,
    COUNT(*) FILTER (WHERE view_count > 0) as products_with_views,
    COUNT(*) FILTER (WHERE click_count > 0) as products_with_clicks,
    ROUND(AVG(popularity_score)::numeric, 4) as avg_popularity,
    MAX(popularity_score) as max_popularity
FROM analytics_features.product_popularity_scores;

-- ============================================================================
-- Usage Notes
-- ============================================================================

-- Refresh popularity scores (run daily or hourly):
-- SELECT analytics_features.refresh_popularity_scores();

-- Get top popular products:
-- SELECT p.product_id, p.vendor_code, p.name, pop.popularity_score, pop.click_count
-- FROM staging_marts.dim_product p
-- JOIN analytics_features.product_popularity_scores pop USING (product_id)
-- ORDER BY pop.popularity_score DESC
-- LIMIT 20;

-- Get trending products (recent activity):
-- SELECT p.product_id, p.vendor_code, p.name, pop.trending_score, pop.last_clicked
-- FROM staging_marts.dim_product p
-- JOIN analytics_features.product_popularity_scores pop USING (product_id)
-- WHERE pop.trending_score > 0
-- ORDER BY pop.trending_score DESC
-- LIMIT 20;
