# Polish Exclusion - Quick Start Guide

**Goal:** Exclude all Polish queries from search using database-driven approach

---

## Step 1: Build Polish Keyword Cache from Database

Extract Polish words from your product table's `polish_name` column:

```bash
psql -h localhost -p 5433 -U analytics -d analytics < sql/search/create_polish_keyword_cache.sql
```

**What this does:**
- Extracts all unique words from `polish_name` and `search_polish_name` columns
- Stores them in `analytics_features.product_keyword_cache` table
- Filters by frequency (keeps words appearing ≥5 times)

**Verify it worked:**
```sql
SELECT COUNT(*) FROM analytics_features.product_keyword_cache WHERE language = 'polish';
-- Should return thousands of Polish keywords
```

---

## Step 2: Update Product Embeddings (Remove Polish Fields)

Recreate the product text features view to exclude Polish fields:

```bash
psql -h localhost -p 5433 -U analytics -d analytics < sql/ml/feature_extraction.sql
```

**What changed:**
- `polish_name` → **REMOVED**
- `polish_description` → **REMOVED**
- `search_polish_name` → **REMOVED**
- Only Ukrainian + English fields remain

---

## Step 3: Rebuild Product Embeddings

Regenerate embeddings without Polish content:

```bash
python -m src.ml.embedding_pipeline_v2 --rebuild
```

**Impact:**
- Product vectors now exclude Polish text
- Semantic search focuses on Ukrainian + English only

---

## Step 4: Clean Existing Polish Queries (Optional)

Remove Polish queries from the cache:

```sql
DELETE FROM analytics_features.query_embeddings WHERE query_language = 'polish';
```

---

## Step 5: Test Language Detection

The system will now automatically:
1. Load Polish keywords from database on startup
2. Detect Polish queries by checking words against keyword cache
3. Exclude Polish queries from embedding cache

**Test it:**
```python
from src.ml.query_cache_loader import classify_query_language

# These should return 'polish' and be excluded
classify_query_language("klocki hamulcowe")
classify_query_language("filtr oleju")

# These should return 'ukrainian' and be accepted
classify_query_language("гвинт кріплення")
classify_query_language("фільтр масляний")

# These should return 'english' and be accepted
classify_query_language("brake pads")
classify_query_language("oil filter")
```

---

## How It Works

### Before (Hardcoded Approach)
```python
polish_words = {'klocki', 'hamulcowe', 'filtr', ...}  # Limited, static
```

### After (Database-Driven Approach) ⭐
```python
# Automatically loads from database:
SELECT keyword FROM analytics_features.product_keyword_cache
WHERE language = 'polish' AND frequency >= 10;

# Result: Thousands of Polish words from YOUR actual products
```

---

## Maintenance

### Weekly Refresh (Recommended)

As products are added/updated, refresh the Polish keyword cache:

```bash
# Cron job (every Sunday at 2 AM)
0 2 * * 0 psql -h localhost -p 5433 -U analytics -d analytics < /path/to/sql/search/create_polish_keyword_cache.sql
```

### Monitor Polish Detection

Check how many Polish queries are being detected:

```sql
SELECT
    query_language,
    COUNT(*) as query_count
FROM analytics_features.search_query_log
WHERE query_text IS NOT NULL
GROUP BY query_language
ORDER BY query_count DESC;
```

Expected output:
```
query_language | query_count
---------------+------------
ukrainian      | 15,234
english        | 8,521
russian        | 2,103
polish         | 0        <-- Polish queries blocked!
```

---

## Troubleshooting

### Polish queries still getting through?

1. **Check keyword cache:**
   ```sql
   SELECT COUNT(*) FROM analytics_features.product_keyword_cache WHERE language = 'polish';
   ```
   Should have >100 keywords

2. **Check product table:**
   ```sql
   SELECT COUNT(*) FROM staging_marts.dim_product WHERE polish_name IS NOT NULL;
   ```
   Should have products with Polish names

3. **Reload Polish keywords:**
   ```bash
   psql -h localhost -p 5433 -U analytics -d analytics < sql/search/create_polish_keyword_cache.sql
   ```

### Can't connect to database?

Check your database connection settings in `.env`:
```
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
POSTGRES_DB=analytics
POSTGRES_USER=analytics
POSTGRES_PASSWORD=analytics
```

---

## Benefits

✅ **Automatic** - Updates when products change
✅ **Comprehensive** - All Polish words from your catalog
✅ **Self-learning** - Adapts to your business domain
✅ **No hardcoding** - Driven by actual product data
✅ **Scalable** - Works with any catalog size

---

## Summary

1. ✅ Run SQL script to extract Polish keywords
2. ✅ Update product embeddings (remove Polish fields)
3. ✅ Polish queries automatically excluded
4. ✅ Schedule weekly refresh

**Done!** Your search system now exclusively supports Ukrainian and English.
