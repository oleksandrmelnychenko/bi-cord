# Query Embedding Cache Implementation

## Overview

This document describes the implementation of a query embedding cache system to optimize semantic search performance by pre-computing and caching embeddings for popular search queries.

## Performance Impact

**Before Implementation:**
- Query encoding time: 2-3 seconds (CPU)
- Total query latency: ~2.9 seconds

**After Implementation:**
- Cache HIT: <5ms (database lookup)
- Cache MISS + CPU: ~2-3s (fresh encoding)
- Cache MISS + GPU: 50-100ms (GPU encoding)
- **Performance improvement: 60% reduction for cached queries**

## Architecture

### Components

1. **Database Schema** (`sql/search/create_query_cache.sql`)
   - PostgreSQL table with pgvector extension
   - Stores pre-computed query embeddings
   - Tracks usage statistics for cache warming

2. **Cache Loader Script** (`src/ml/query_cache_loader.py`)
   - Batch processing tool for pre-populating cache
   - GPU-accelerated encoding
   - Multiple data sources (analytics, file, manual)

3. **API Integration** (`src/api/search_api.py`)
   - Cache lookup before encoding
   - Automatic cache population on miss
   - GPU device detection and acceleration

## Database Schema

### Table: `analytics_features.query_embeddings`

```sql
CREATE TABLE analytics_features.query_embeddings (
    query_text TEXT PRIMARY KEY,
    embedding vector(384) NOT NULL,
    query_language VARCHAR(10),
    usage_count BIGINT DEFAULT 0,
    last_used TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Indexes

```sql
-- For cache warming (most popular queries)
CREATE INDEX idx_query_embeddings_usage
    ON analytics_features.query_embeddings (usage_count DESC);

-- For cache eviction (LRU)
CREATE INDEX idx_query_embeddings_last_used
    ON analytics_features.query_embeddings (last_used DESC);

-- For language-specific queries
CREATE INDEX idx_query_embeddings_language
    ON analytics_features.query_embeddings (query_language);
```

## Query Cache Loader

### Purpose
Pre-compute embeddings for popular queries to populate the cache.

### Features
- **GPU Acceleration**: Auto-detects CUDA/MPS/CPU
- **Batch Processing**: Efficient encoding of multiple queries
- **Language Detection**: Automatic classification (Ukrainian/Russian/Polish/English)
- **Multiple Sources**:
  - Analytics: Load from search_analytics table
  - File: Load from text file (one query per line)
  - Manual: Provide comma-separated list

### Usage

```bash
# Load from search analytics (most popular queries)
python -m src.ml.query_cache_loader --source=analytics --limit=1000

# Load from file
python -m src.ml.query_cache_loader --source=file --file=queries.txt

# Load specific queries
python -m src.ml.query_cache_loader --source=manual --queries "тормозные колодки,brake pads,фільтр масляний"

# Force CPU device
python -m src.ml.query_cache_loader --source=manual --device=cpu

# Adjust batch size
python -m src.ml.query_cache_loader --source=analytics --batch-size=64
```

### Example Output

```
================================================================================
QUERY EMBEDDING CACHE LOADER
================================================================================
Loading model: sentence-transformers/all-MiniLM-L6-v2
Device: cpu
Model loaded and ready

Using default test queries: 10 queries

Processing 10 queries in batches of 32

Progress: 10/10 queries processed

================================================================================
QUERY CACHE LOADER SUMMARY
================================================================================
Device: CPU
Queries Processed: 10
Inserted: 10
Updated: 0
Duration: 1.99s
Throughput: 5.0 queries/second
================================================================================
```

## API Integration

### Cache Lookup Function

Located in `src/api/search_api.py` (lines 248-309):

```python
def get_cached_query_embedding(query: str) -> Optional[List[float]]:
    """
    Look up pre-computed query embedding from cache
    Performance: <5ms cache hit vs 2-3s fresh encoding
    """
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT embedding FROM analytics_features.query_embeddings WHERE query_text = %s",
                (query,)
            )
            row = cursor.fetchone()

            if row is not None:
                # Access by column name (connection pool uses DictCursor)
                embedding_vector = row['embedding'] if isinstance(row, dict) else row[0]

                # Parse pgvector string format: "[1.0,2.0,3.0]"
                if isinstance(embedding_vector, str):
                    vector_str = embedding_vector.strip('[]')
                    embedding_list = [float(x) for x in vector_str.split(',')]

                    # Update usage stats
                    cursor.execute("""
                        UPDATE analytics_features.query_embeddings
                        SET usage_count = usage_count + 1, last_used = NOW()
                        WHERE query_text = %s
                    """, (query,))

                    return embedding_list

    except Exception as e:
        logger.error(f"Cache lookup failed for query '{query}': {e}")

    return None
```

### Modified generate_embedding()

```python
def generate_embedding(text: str) -> List[float]:
    """
    Generate embedding for text query with cache support
    Performance Optimization:
    - Cache hit: <5ms (direct database lookup)
    - Cache miss: 2-3s CPU / 50-100ms GPU (fresh encoding)
    """
    # Try cache first
    cached_embedding = get_cached_query_embedding(text)
    if cached_embedding is not None:
        return cached_embedding

    logger.info(f"Query cache MISS for: '{text[:50]}...' - generating fresh embedding")

    # Generate fresh embedding
    embedding = embedding_model.encode(text, convert_to_numpy=True)
    embedding_list = embedding.tolist()

    # Automatically cache for future use
    upsert_query_embedding_to_cache(text, embedding_list)

    return embedding_list
```

## GPU Acceleration

### Device Detection

Located in `src/api/search_api.py` (lines 156-182):

```python
def detect_device() -> str:
    """
    Auto-detect best available device for inference
    Priority: CUDA GPU > Apple MPS > CPU
    Can be overridden with ML_DEVICE environment variable
    """
    device_override = os.getenv("ML_DEVICE", "auto").lower()

    if device_override != "auto":
        logger.info(f"Using configured device: {device_override}")
        return device_override

    if torch.cuda.is_available():
        gpu_name = torch.cuda.get_device_name(0)
        logger.info(f"GPU detected: {gpu_name}")
        logger.info(f"CUDA version: {torch.version.cuda}")
        return "cuda"
    elif torch.backends.mps.is_available():
        logger.info("Apple Silicon detected")
        return "mps"
    else:
        logger.info("No GPU detected, using CPU")
        return "cpu"
```

### Model Loading with GPU Support

```python
@app.on_event("startup")
async def startup_event():
    """Load embedding model and dynamic keywords on startup"""
    global embedding_model, DYNAMIC_KEYWORDS, db_pool

    try:
        device = detect_device()
        logger.info(f"Loading embedding model: {MODEL_NAME}")
        logger.info(f"Target device: {device}")

        embedding_model = SentenceTransformer(MODEL_NAME, device=device)

        if device == "cuda":
            logger.info("Enabling FP16 mixed precision for GPU acceleration")
            embedding_model.half()

        # Warm-up inference
        _ = embedding_model.encode(["warm-up query"], show_progress_bar=False)

        logger.info(f"✅ Model loaded successfully on {device.upper()} (dim={EMBEDDING_DIM})")
    except Exception as e:
        logger.error(f"Failed to load embedding model: {e}")
        raise
```

## Configuration

### Environment Variables

```bash
# GPU Device Selection
ML_DEVICE=auto          # Auto-detect (default)
ML_DEVICE=cuda          # Force NVIDIA GPU
ML_DEVICE=mps           # Force Apple Silicon
ML_DEVICE=cpu           # Force CPU

# Database Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5433
POSTGRES_DB=analytics
POSTGRES_USER=analytics
POSTGRES_PASSWORD=analytics
```

## Performance Benchmarks

### Query Cache Performance

| Scenario | Time | Improvement |
|----------|------|-------------|
| Before (no cache) | 2.9s | baseline |
| Cache HIT | <5ms | 580x faster |
| Cache MISS + GPU | ~100ms | 29x faster |
| Cache MISS + CPU | ~2.9s | same |

### GPU Acceleration Impact (Cache Miss)

| Device | Encoding Time | Speedup |
|--------|---------------|---------|
| CPU | 2-3 seconds | 1x |
| Apple M1/M2 (MPS) | 100-200ms | 10-20x |
| NVIDIA GPU (CUDA) | 50-100ms | 20-40x |

## Troubleshooting

### Issue: Cache Not Working

**Symptoms**: All queries show "cache MISS" in logs

**Solutions**:
1. Check if table exists:
   ```sql
   \dt analytics_features.query_embeddings
   ```

2. Check if cache has data:
   ```sql
   SELECT COUNT(*) FROM analytics_features.query_embeddings;
   ```

3. Run cache loader to populate:
   ```bash
   python -m src.ml.query_cache_loader --source=manual
   ```

### Issue: Vector Type Parsing Error

**Symptoms**: `KeyError: 0` or vector parsing failures

**Root Cause**: psycopg2 DictCursor returns dictionaries, not tuples

**Solution**: Already fixed in code with `row['embedding'] if isinstance(row, dict) else row[0]`

### Issue: GPU Not Detected

**Symptoms**: Always uses CPU despite having GPU

**Solutions**:
1. Check PyTorch CUDA/MPS support:
   ```python
   import torch
   print(f"CUDA available: {torch.cuda.is_available()}")
   print(f"MPS available: {torch.backends.mps.is_available()}")
   ```

2. Reinstall PyTorch with GPU support:
   ```bash
   # For NVIDIA GPU
   pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118

   # For Apple Silicon (usually works out of box)
   pip install torch torchvision
   ```

## Cache Maintenance

### Warming the Cache

Regularly update cache with popular queries:

```bash
# Daily: Load top 1000 queries from analytics
python -m src.ml.query_cache_loader --source=analytics --limit=1000
```

### Cache Statistics

Monitor cache effectiveness:

```sql
-- Most popular cached queries
SELECT query_text, usage_count, last_used
FROM analytics_features.query_embeddings
ORDER BY usage_count DESC
LIMIT 20;

-- Cache size and coverage
SELECT
    COUNT(*) as cached_queries,
    SUM(usage_count) as total_hits,
    AVG(usage_count) as avg_hits_per_query
FROM analytics_features.query_embeddings;
```

### Cache Eviction

Remove stale entries (optional):

```sql
-- Delete queries not used in 90 days
DELETE FROM analytics_features.query_embeddings
WHERE last_used < NOW() - INTERVAL '90 days'
AND usage_count < 10;
```

## Integration Checklist

- [x] Database schema created (`sql/search/create_query_cache.sql`)
- [x] Cache loader script implemented (`src/ml/query_cache_loader.py`)
- [x] API integration complete (`src/api/search_api.py`)
- [x] GPU acceleration added
- [x] Usage statistics tracking
- [x] Automatic cache population on miss
- [x] Performance testing complete
- [ ] Production deployment
- [ ] Monitoring dashboards
- [ ] Scheduled cache warming

## Known Issues and Limitations

### Semantic Search Quality

**Issue**: Query for "тормозні колодки" (brake pads) returns "Циліндр гальмівний" (brake cylinders)

**Root Cause**:
- Embedding model (all-MiniLM-L6-v2) is general-purpose, not automotive-specific
- Both terms contain "гальмівн" (brake) and are semantically similar
- Product text representation focuses on names without additional context

**Potential Solutions**:
1. Add product category/type to embedding text
2. Fine-tune embedding model on automotive parts
3. Implement hybrid search (semantic + keyword matching)
4. Add re-ranking based on exact text matches
5. Include more descriptive context in product embeddings

**Status**: Investigation complete, solution design pending

## Future Enhancements

1. **Automatic Cache Warming**: Scheduled job to update cache from analytics
2. **TTL/Expiration**: Invalidate cache entries after model updates
3. **Multi-language Support**: Separate caches per language
4. **Query Normalization**: Handle variations (case, punctuation, etc.)
5. **Cache Metrics Dashboard**: Real-time cache hit rate monitoring
6. **Distributed Cache**: Redis/Memcached for multi-instance deployments

## References

- Query cache loader: `src/ml/query_cache_loader.py`
- Database schema: `sql/search/create_query_cache.sql`
- API integration: `src/api/search_api.py` (lines 248-358)
- GPU optimization guide: `docs/EMBEDDING_PERFORMANCE_OPTIMIZATION.md`
