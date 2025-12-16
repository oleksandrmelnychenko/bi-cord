# SEM1 Search Example - Unified API

## Database Stats

```
Total Products in Database: 278,697
SEM1 Supplier Products:     6,728
```

## Starting the API

Since Docker is running with PostgreSQL, you can start the API server:

```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform
uvicorn src.api.search_api:app --reload --port 8000
```

## Search Query with SEM1 Supplier Filter

### Example 1: Basic SEM1 Search

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "тяга рулевая",
    "supplier_name": "SEM1",
    "limit": 10
  }'
```

**What This Does:**
- Searches for "тяга рулевая" (steering rod) products
- Filters ONLY SEM1 supplier products
- Returns top 10 results

**Expected Response:**
```json
{
  "action": "search",
  "success": true,
  "execution_time_ms": 145.23,
  "query": "тяга рулевая",
  "total_results": 42,
  "search_id": 12345,
  "results": [
    {
      "product_id": 7807566,
      "vendor_code": "SEM14310",
      "name": "Тяга рулевая",
      "ukrainian_name": "Тяга рульова",
      "supplier_name": "SEM1",
      "weight": 0.0,
      "is_for_sale": false,
      "has_image": false,
      "similarity_score": 0.95,
      "ranking_score": 0.95
    }
  ]
}
```

### Example 2: SEM1 Vendor Code Search

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "SEM14310",
    "supplier_name": "SEM1",
    "limit": 5
  }'
```

**What This Does:**
- Searches for specific vendor code
- Ensures it's from SEM1 supplier
- API auto-detects this is a VENDOR_CODE query and prioritizes exact matching

### Example 3: SEM1 with Multiple Filters

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "brake",
    "supplier_name": "SEM1",
    "weight_min": 0.0,
    "weight_max": 10.0,
    "limit": 20
  }'
```

**What This Does:**
- Searches for "brake" in SEM1 products
- Filters products with weight between 0-10 kg
- Returns up to 20 results

### Example 4: SEM1 Products For Sale

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "амортизатор",
    "supplier_name": "SEM1",
    "is_for_sale": true,
    "has_image": true,
    "limit": 15
  }'
```

**What This Does:**
- Searches for "амортизатор" (shock absorber)
- ONLY from SEM1 supplier
- ONLY products that are for sale
- ONLY products with images
- Returns 15 results

## Available Filters for SEM1 Search

All of these can be combined with `supplier_name: "SEM1"`:

| Filter | Type | Description | Example |
|--------|------|-------------|---------|
| `supplier_name` | string | Filter by supplier | `"SEM1"` |
| `weight_min` | float | Minimum weight in kg | `0.5` |
| `weight_max` | float | Maximum weight in kg | `10.0` |
| `is_for_sale` | boolean | Only products for sale | `true` |
| `is_for_web` | boolean | Only web-available products | `true` |
| `has_image` | boolean | Only products with images | `true` |
| `limit` | integer | Max results (1-100) | `20` |
| `offset` | integer | Skip N results (pagination) | `0` |

## Sample SEM1 Products (from database)

```
Product ID | Vendor Code | Name           | Ukrainian Name
-----------|-------------|----------------|----------------
7807566    | SEM14310    | Тяга рулевая   | Тяга рульова
7807567    | SEM14298    | Тяга рулевая   | Тяга рульова
7807568    | SEM14297    | Тяга рулевая   | Тяга рульова
7807569    | SEM14290    | Тяга рулевая   | Тяга рульова
7807570    | SEM14283    | Тяга рулевая   | Тяга рульова

... 6,723 more SEM1 products available
```

## Testing

### Automated Test
```bash
./test_sem1_api.sh
```

### Manual Test
```bash
# 1. Start API
uvicorn src.api.search_api:app --reload --port 8000

# 2. In another terminal, test
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{"action": "search", "query": "тяга", "supplier_name": "SEM1", "limit": 5}'
```

## How It Works

1. **Request arrives** at `POST /search` with `action="search"` and `supplier_name="SEM1"`

2. **Query classification**: API detects query type (vendor code, exact phrase, or natural language)

3. **Filter application**: Adds SQL `WHERE supplier_name = 'SEM1'` condition

4. **Hybrid search execution**:
   - Full-text search on product names/descriptions
   - Trigram fuzzy matching for typo tolerance
   - Exact matching for vendor codes
   - Vector semantic search (if natural language query)

5. **ML Ranking**: Combines signals:
   - Exact match score
   - Full-text relevance
   - Trigram similarity
   - Vector similarity
   - Popularity (click data)
   - Availability flags
   - Product freshness

6. **Results filtered**: Only SEM1 products returned

7. **Response sent** with ranked results

## Performance

- **Query time with SEM1 filter**: <200ms
- **SEM1 product count**: 6,728 products
- **Index usage**: Leverages PostgreSQL indexes on `supplier_name`

## Next Steps

After you start the API, you can:

1. Test with `./test_sem1_api.sh`
2. Integrate into your frontend with the examples above
3. Add click tracking for search improvements
4. Submit feedback to improve relevance

## Notes

- The API uses the **unified endpoint** - everything through `POST /search`
- Default `action` is `"search"`, so it's optional for search queries
- SEM1 filter is applied server-side in the SQL query for performance
- Results are cached in the query embedding table for faster repeat searches
