-- Create HNSW Index for Fast Vector Search
-- Purpose: Enable approximate nearest neighbor search for semantic product search
-- Date: 2025-10-19
-- Requirements: pgvector extension, completed embeddings in analytics_features.product_embeddings

-- ==============================================================================
-- HNSW INDEX CREATION
-- ==============================================================================
-- HNSW (Hierarchical Navigable Small World) provides:
-- - Sub-100ms query times for millions of vectors
-- - ~95-99% recall accuracy
-- - 10-100x speed improvement over exact search

-- Drop existing index if present (for recreation)
DROP INDEX IF EXISTS analytics_features.idx_product_embeddings_hnsw;

-- Create HNSW index with optimal parameters for 278k products
-- Parameters:
--   m = 16: Number of connections per layer (trade-off between recall and build time)
--   ef_construction = 64: Size of dynamic candidate list during construction
CREATE INDEX idx_product_embeddings_hnsw
ON analytics_features.product_embeddings
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- Update table statistics for query planner
ANALYZE analytics_features.product_embeddings;

-- ==============================================================================
-- VERIFICATION
-- ==============================================================================

-- Check index exists and size
SELECT
    schemaname,
    relname as tablename,
    indexrelname as indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE indexrelname = 'idx_product_embeddings_hnsw';

-- Check total embeddings count
SELECT COUNT(*) as total_embeddings
FROM analytics_features.product_embeddings;

-- ==============================================================================
-- PERFORMANCE TUNING (Optional)
-- ==============================================================================

-- Increase ef_search for better recall at query time (default: 40)
-- Higher values = better recall but slower queries
-- SET hnsw.ef_search = 100;

-- For production queries, you can set this per-session:
-- BEGIN;
-- SET LOCAL hnsw.ef_search = 100;
-- [run your vector search queries]
-- COMMIT;

-- ==============================================================================
-- EXPECTED PERFORMANCE
-- ==============================================================================
-- With HNSW index on 278k products:
-- - Index build time: ~1-2 minutes
-- - Index size: ~50-100 MB
-- - Query time (top-20): <50ms
-- - Recall: ~97-99% compared to exact search

-- Without HNSW (sequential scan):
-- - Query time (top-20): 500-1000ms
-- - Recall: 100% (exact)

-- ==============================================================================
-- NEXT STEPS
-- ==============================================================================
-- 1. Run this script: psql -h localhost -p 5433 -U analytics -d analytics -f sql/search/create_hnsw_index.sql
-- 2. Start FastAPI search endpoint: uvicorn src.api.search_api:app --reload --port 8000
-- 3. Test search queries from docs/ML_SEARCH_IMPLEMENTATION.md
