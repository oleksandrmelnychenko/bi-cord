-- ============================================================================
-- Search Analytics Schema Migration v2
-- Purpose: Add feedback tracking and fix column naming for API compatibility
-- Date: 2025-10-20
-- ============================================================================

-- Add feedback columns to search_query_log
ALTER TABLE analytics_features.search_query_log
ADD COLUMN IF NOT EXISTS feedback_type VARCHAR(50),
ADD COLUMN IF NOT EXISTS feedback_comment TEXT,
ADD COLUMN IF NOT EXISTS feedback_timestamp TIMESTAMPTZ;

-- Add index for feedback queries
CREATE INDEX IF NOT EXISTS idx_search_query_log_feedback
ON analytics_features.search_query_log(feedback_type, feedback_timestamp DESC)
WHERE feedback_type IS NOT NULL;

-- Add column aliases for backward compatibility
-- Note: The Python code will use these column names:
--   - id (instead of query_id)
--   - total_results (instead of result_count)
--   - execution_time_ms (already correct)
--   - search_type (instead of search_endpoint)
--   - query_timestamp (instead of timestamp)

-- Rename columns to match API expectations
ALTER TABLE analytics_features.search_query_log
RENAME COLUMN search_endpoint TO search_type;

-- Update click log to match API (already correct, but verify)
-- Expected columns: id, search_id, product_id, rank_position, click_timestamp

-- Add comment explaining feedback types
COMMENT ON COLUMN analytics_features.search_query_log.feedback_type IS
'User feedback type: helpful, not_helpful, no_results, irrelevant';

COMMENT ON COLUMN analytics_features.search_query_log.feedback_comment IS
'Optional user comment explaining their feedback';

-- ============================================================================
-- Update Views to Include Feedback
-- ============================================================================

-- Top queries with feedback stats
CREATE OR REPLACE VIEW analytics_features.v_top_queries_with_feedback AS
SELECT
    query_text,
    query_type,
    COUNT(*) as query_count,
    AVG(execution_time_ms) as avg_execution_time,
    AVG(result_count) as avg_result_count,
    COUNT(*) FILTER (WHERE feedback_type = 'helpful') as helpful_count,
    COUNT(*) FILTER (WHERE feedback_type = 'not_helpful') as not_helpful_count,
    COUNT(*) FILTER (WHERE feedback_type = 'no_results') as no_results_count,
    COUNT(*) FILTER (WHERE feedback_type = 'irrelevant') as irrelevant_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE feedback_type = 'helpful') /
          NULLIF(COUNT(*) FILTER (WHERE feedback_type IS NOT NULL), 0), 2) as satisfaction_rate,
    MAX(timestamp) as last_queried
FROM analytics_features.search_query_log
GROUP BY query_text, query_type
ORDER BY query_count DESC;

-- ============================================================================
-- Click-Through Rate with Rank Position Analysis
-- ============================================================================

CREATE OR REPLACE VIEW analytics_features.v_ctr_by_rank_position AS
SELECT
    cl.rank_position,
    COUNT(*) as click_count,
    COUNT(DISTINCT cl.query_id) as unique_queries_clicked,
    ROUND(AVG(cl.similarity_score), 3) as avg_similarity_score
FROM analytics_features.search_click_log cl
WHERE cl.rank_position IS NOT NULL
GROUP BY cl.rank_position
ORDER BY cl.rank_position;

-- ============================================================================
-- Success!
-- ============================================================================

SELECT
    'Search Analytics Schema Updated to v2' as status,
    COUNT(*) FILTER (WHERE feedback_type IS NOT NULL) as queries_with_feedback,
    COUNT(DISTINCT query_id) as total_queries
FROM analytics_features.search_query_log;
