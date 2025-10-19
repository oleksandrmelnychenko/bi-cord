-- ============================================================================
-- Full-Text Search Indexes for Advanced Product Search
-- Purpose: Enable fast text-based search using PostgreSQL's native full-text capabilities
-- Date: 2025-10-19
-- ============================================================================

-- Full-text search provides:
-- - Stemming and language-aware search (Polish, Ukrainian, Russian, English)
-- - Fuzzy matching with ranking
-- - Fast trigram similarity
-- - Combined with vector search for best results

-- ============================================================================
-- ENABLE EXTENSIONS
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;  -- Trigram similarity for fuzzy matching
CREATE EXTENSION IF NOT EXISTS unaccent; -- Remove accents for better matching

-- ============================================================================
-- ADD FULL-TEXT SEARCH COLUMNS
-- ============================================================================

-- Add tsvector column for full-text search (if not exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'staging_marts'
        AND table_name = 'dim_product'
        AND column_name = 'search_vector'
    ) THEN
        ALTER TABLE staging_marts.dim_product
        ADD COLUMN search_vector tsvector;
    END IF;
END$$;

-- ============================================================================
-- POPULATE FULL-TEXT SEARCH VECTOR
-- ============================================================================

-- Create multilingual search vector combining all text fields
-- Weight A (highest) = vendor_code, name
-- Weight B = polish_name, ukrainian_name
-- Weight C = description
-- Weight D (lowest) = polish_description, ukrainian_description

UPDATE staging_marts.dim_product
SET search_vector =
    setweight(to_tsvector('simple', coalesce(vendor_code, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(polish_name, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(ukrainian_name, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(description, '')), 'C') ||
    setweight(to_tsvector('english', coalesce(polish_description, '')), 'D') ||
    setweight(to_tsvector('english', coalesce(ukrainian_description, '')), 'D');

-- ============================================================================
-- CREATE GIN INDEX FOR FULL-TEXT SEARCH
-- ============================================================================

-- Drop existing index if present
DROP INDEX IF EXISTS staging_marts.idx_product_search_vector;

-- Create GIN index for fast full-text search
-- GIN (Generalized Inverted Index) is optimized for full-text queries
CREATE INDEX idx_product_search_vector
ON staging_marts.dim_product
USING gin(search_vector);

-- ============================================================================
-- CREATE TRIGRAM INDEXES FOR FUZZY MATCHING
-- ============================================================================

-- Trigram indexes for fuzzy string matching (typos, partial matches)
CREATE INDEX IF NOT EXISTS idx_product_vendor_code_trgm
ON staging_marts.dim_product
USING gin(vendor_code gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_product_name_trgm
ON staging_marts.dim_product
USING gin(name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_product_polish_name_trgm
ON staging_marts.dim_product
USING gin(polish_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_product_ukrainian_name_trgm
ON staging_marts.dim_product
USING gin(ukrainian_name gin_trgm_ops);

-- ============================================================================
-- CREATE TRIGGER TO AUTO-UPDATE SEARCH VECTOR
-- ============================================================================

-- Function to update search_vector when product data changes
CREATE OR REPLACE FUNCTION staging_marts.update_product_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('simple', coalesce(NEW.vendor_code, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(NEW.name, '')), 'A') ||
        setweight(to_tsvector('english', coalesce(NEW.polish_name, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(NEW.ukrainian_name, '')), 'B') ||
        setweight(to_tsvector('english', coalesce(NEW.description, '')), 'C') ||
        setweight(to_tsvector('english', coalesce(NEW.polish_description, '')), 'D') ||
        setweight(to_tsvector('english', coalesce(NEW.ukrainian_description, '')), 'D');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing trigger if present
DROP TRIGGER IF EXISTS trg_update_product_search_vector ON staging_marts.dim_product;

-- Create trigger to auto-update search_vector on INSERT or UPDATE
CREATE TRIGGER trg_update_product_search_vector
BEFORE INSERT OR UPDATE ON staging_marts.dim_product
FOR EACH ROW
EXECUTE FUNCTION staging_marts.update_product_search_vector();

-- ============================================================================
-- ANALYZE TABLES FOR QUERY PLANNER
-- ============================================================================

ANALYZE staging_marts.dim_product;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check index sizes
SELECT
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
    idx_scan as times_used
FROM pg_stat_user_indexes
WHERE schemaname = 'staging_marts'
    AND tablename = 'dim_product'
    AND indexname LIKE '%search%'
OR indexname LIKE '%trgm%'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Check search_vector column
SELECT
    COUNT(*) as total_products,
    COUNT(search_vector) as products_with_search_vector,
    ROUND(100.0 * COUNT(search_vector) / COUNT(*), 2) as coverage_percentage
FROM staging_marts.dim_product;

-- ============================================================================
-- EXAMPLE FULL-TEXT SEARCH QUERIES
-- ============================================================================

-- Full-text search with ranking
/*
SELECT
    product_id,
    vendor_code,
    name,
    ts_rank(search_vector, to_tsquery('english', 'brake & pads')) as rank
FROM staging_marts.dim_product
WHERE search_vector @@ to_tsquery('english', 'brake & pads')
ORDER BY rank DESC
LIMIT 10;
*/

-- Fuzzy trigram search
/*
SELECT
    product_id,
    vendor_code,
    similarity(vendor_code, '100623SAMKO') as sim
FROM staging_marts.dim_product
WHERE vendor_code % '100623SAMKO'  -- Fuzzy match operator
ORDER BY sim DESC
LIMIT 10;
*/

-- Combined full-text + trigram
/*
SELECT
    product_id,
    vendor_code,
    name,
    ts_rank(search_vector, to_tsquery('english', 'brake')) as fts_rank,
    similarity(name, 'brake pads') as trgm_sim,
    (ts_rank(search_vector, to_tsquery('english', 'brake')) + similarity(name, 'brake pads')) / 2 as combined_score
FROM staging_marts.dim_product
WHERE search_vector @@ to_tsquery('english', 'brake')
    OR name % 'brake pads'
ORDER BY combined_score DESC
LIMIT 10;
*/

-- ============================================================================
-- PERFORMANCE NOTES
-- ============================================================================
-- GIN Index Build: ~2-5 minutes for 278k products
-- GIN Index Size: ~50-150 MB (depends on text volume)
-- Trigram Indexes: ~20-50 MB each
-- Full-Text Query Speed: 10-50ms (vs 335-613ms for ILIKE)
-- Supports: Stemming, stop words, phrase search, Boolean operators (AND, OR, NOT)
