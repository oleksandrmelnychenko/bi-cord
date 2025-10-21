-- Polish Keyword Cache Builder
-- Purpose: Extract Polish words from product polish_name column to identify Polish queries
-- This allows us to EXCLUDE Polish queries from search without hardcoding word lists

-- ==============================================================================
-- STEP 1: Extract Polish Keywords from Product Names
-- ==============================================================================

-- Create or replace the keyword extraction function
CREATE OR REPLACE FUNCTION extract_polish_keywords()
RETURNS TABLE(keyword TEXT, frequency BIGINT) AS $$
BEGIN
    RETURN QUERY
    WITH polish_words AS (
        -- Extract individual words from Polish product names
        SELECT
            LOWER(TRIM(word)) as word,
            COUNT(*) as freq
        FROM staging_marts.dim_product p,
             LATERAL unnest(string_to_array(p.polish_name, ' ')) as word
        WHERE p.polish_name IS NOT NULL
            AND p.deleted = false
            AND LENGTH(TRIM(word)) >= 3  -- Skip very short words
            AND TRIM(word) ~ '^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+$'  -- Only letters (Latin + Polish)
        GROUP BY LOWER(TRIM(word))
    ),
    -- Also extract from search_polish_name for better coverage
    polish_search_words AS (
        SELECT
            LOWER(TRIM(word)) as word,
            COUNT(*) as freq
        FROM staging_marts.dim_product p,
             LATERAL unnest(string_to_array(p.search_polish_name, ' ')) as word
        WHERE p.search_polish_name IS NOT NULL
            AND p.deleted = false
            AND LENGTH(TRIM(word)) >= 3
            AND TRIM(word) ~ '^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ]+$'
        GROUP BY LOWER(TRIM(word))
    ),
    combined AS (
        SELECT word, SUM(freq) as total_freq
        FROM (
            SELECT word, freq FROM polish_words
            UNION ALL
            SELECT word, freq FROM polish_search_words
        ) all_words
        GROUP BY word
    )
    SELECT
        word as keyword,
        total_freq as frequency
    FROM combined
    WHERE total_freq >= 5  -- Only keep words that appear at least 5 times
    ORDER BY total_freq DESC;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION extract_polish_keywords() IS
'Extracts Polish keywords from product polish_name and search_polish_name columns for query language detection';


-- ==============================================================================
-- STEP 2: Populate Polish Keywords into Cache Table
-- ==============================================================================

-- Insert Polish keywords into the existing keyword cache table
-- (assuming the table already exists from Ukrainian keyword extraction)

INSERT INTO analytics_features.product_keyword_cache (keyword, language, frequency, last_updated)
SELECT
    keyword,
    'polish' as language,
    frequency,
    NOW() as last_updated
FROM extract_polish_keywords()
ON CONFLICT (keyword, language)
DO UPDATE SET
    frequency = EXCLUDED.frequency,
    last_updated = NOW();


-- ==============================================================================
-- STEP 3: Verification Queries
-- ==============================================================================

-- Check Polish keyword counts
SELECT
    'Total Polish keywords' as metric,
    COUNT(*) as count
FROM analytics_features.product_keyword_cache
WHERE language = 'polish';

-- Show top 20 most common Polish keywords
SELECT
    keyword,
    frequency,
    language
FROM analytics_features.product_keyword_cache
WHERE language = 'polish'
ORDER BY frequency DESC
LIMIT 20;

-- Compare language coverage
SELECT
    language,
    COUNT(*) as keyword_count,
    SUM(frequency) as total_occurrences,
    AVG(frequency) as avg_frequency
FROM analytics_features.product_keyword_cache
GROUP BY language
ORDER BY keyword_count DESC;


-- ==============================================================================
-- STEP 4: Sample Polish Products for Validation
-- ==============================================================================

-- Show sample products with Polish names
SELECT
    product_id,
    vendor_code,
    polish_name,
    ukrainian_name,
    name as english_name
FROM staging_marts.dim_product
WHERE polish_name IS NOT NULL
    AND deleted = false
ORDER BY product_id
LIMIT 10;


-- ==============================================================================
-- USAGE NOTES
-- ==============================================================================

/*
This script should be run:
1. Initially to build the Polish keyword cache
2. Periodically (e.g., weekly) to update with new product names
3. After bulk product imports

The extracted keywords will be loaded by search_api.py on startup to
dynamically identify and EXCLUDE Polish queries from search results.

Example keywords that will be extracted:
- hamulcowe (brake)
- klocki (pads)
- filtr (filter)
- oleju (oil)
- amortyzator (shock absorber)
- zawieszenie (suspension)
- silnik (engine)
- części (parts)

Any query containing these Polish words will be automatically excluded
from the query embedding cache and search results.
*/
