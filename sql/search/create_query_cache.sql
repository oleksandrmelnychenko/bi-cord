-- Query Embeddings Cache for Fast Semantic Search
-- Purpose: Pre-compute and cache embeddings for popular search queries
-- Performance: <5ms cache hit vs 2-3s fresh encoding on CPU

-- Enable vector extension if not already enabled
CREATE EXTENSION IF NOT EXISTS vector;

-- Create query embeddings cache table
CREATE TABLE IF NOT EXISTS analytics_features.query_embeddings (
    query_text TEXT PRIMARY KEY,
    embedding vector(384) NOT NULL,
    query_language VARCHAR(10),
    usage_count BIGINT DEFAULT 0,
    last_used TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Index for finding most popular queries (for cache warming)
CREATE INDEX IF NOT EXISTS idx_query_embeddings_usage
    ON analytics_features.query_embeddings (usage_count DESC);

-- Index for finding recently used queries (for cache eviction)
CREATE INDEX IF NOT EXISTS idx_query_embeddings_last_used
    ON analytics_features.query_embeddings (last_used DESC);

-- Index for language-specific queries
CREATE INDEX IF NOT EXISTS idx_query_embeddings_language
    ON analytics_features.query_embeddings (query_language);

-- Comments for documentation
COMMENT ON TABLE analytics_features.query_embeddings IS
'Cache of pre-computed query embeddings for fast semantic search. Reduces query encoding time from 2-3s to <5ms for popular queries.';

COMMENT ON COLUMN analytics_features.query_embeddings.query_text IS
'The search query text (normalized, lowercased)';

COMMENT ON COLUMN analytics_features.query_embeddings.embedding IS
'384-dimensional embedding vector from sentence-transformers/all-MiniLM-L6-v2';

COMMENT ON COLUMN analytics_features.query_embeddings.usage_count IS
'Number of times this query has been searched (for popularity tracking)';

COMMENT ON COLUMN analytics_features.query_embeddings.last_used IS
'Last time this query was searched (for cache eviction and refresh)';

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION analytics_features.update_query_embeddings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at on every update
DROP TRIGGER IF EXISTS trigger_update_query_embeddings_updated_at
    ON analytics_features.query_embeddings;
CREATE TRIGGER trigger_update_query_embeddings_updated_at
    BEFORE UPDATE ON analytics_features.query_embeddings
    FOR EACH ROW
    EXECUTE FUNCTION analytics_features.update_query_embeddings_updated_at();

-- Sample queries for initial cache warming (optional)
-- Uncomment and modify based on your actual popular queries
/*
INSERT INTO analytics_features.query_embeddings (query_text, query_language)
VALUES
    ('тормозные колодки', 'ukrainian'),
    ('brake pads', 'english'),
    ('гвинт кріплення', 'ukrainian'),
    ('масляный фильтр', 'russian'),
    ('амортизатор', 'russian')
ON CONFLICT (query_text) DO NOTHING;
*/
