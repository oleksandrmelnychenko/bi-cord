# Unified Search API - Complete Guide

## Overview

The Search API has been **completely consolidated into a single endpoint** for maximum simplicity. All search-related operations now go through `POST /search`.

## What Changed

### Before (Multiple Endpoints)
```
POST /search                         → Product search
GET  /search/similar/{product_id}    → Similar products (REMOVED)
POST /search/click                   → Click tracking
POST /search/feedback                → User feedback
```

### After (Single Endpoint)
```
POST /search   → Handles ALL operations based on 'action' parameter
GET  /health   → Health check
```

## API Endpoints

### 1. Root Endpoint
```bash
GET http://localhost:8000/
```

Returns API documentation with all available actions.

### 2. Universal Search Endpoint
```bash
POST http://localhost:8000/search
```

Handles three types of operations based on the `action` parameter:
- `action="search"` - Product search
- `action="track_click"` - Click tracking
- `action="feedback"` - User feedback

## Usage Examples

### 1. Product Search

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "тормозные колодки",
    "limit": 10,
    "supplier_name": "SEM1",
    "is_for_sale": true
  }'
```

**Response:**
```json
{
  "action": "search",
  "success": true,
  "execution_time_ms": 156.23,
  "query": "тормозные колодки",
  "total_results": 42,
  "search_id": 12345,
  "results": [
    {
      "product_id": 67890,
      "vendor_code": "BP-001",
      "name": "Brake Pads Premium",
      "ukrainian_name": "Гальмівні колодки преміум",
      "similarity_score": 0.95,
      "ranking_score": 0.95,
      "is_for_sale": true,
      "has_image": true
    }
  ]
}
```

### 2. Click Tracking

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "track_click",
    "search_id": 12345,
    "clicked_product_id": 67890,
    "rank_position": 1
  }'
```

**Response:**
```json
{
  "action": "track_click",
  "success": true,
  "execution_time_ms": 12.45,
  "message": "Click tracked successfully",
  "click_id": 999
}
```

### 3. User Feedback

**Request:**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "feedback",
    "search_id": 12345,
    "feedback_type": "helpful",
    "feedback_comment": "Great results!"
  }'
```

**Response:**
```json
{
  "action": "feedback",
  "success": true,
  "execution_time_ms": 8.32,
  "message": "Feedback submitted successfully"
}
```

## Request Parameters

### SearchRequest Model

| Field | Type | Required | Description | Used By |
|-------|------|----------|-------------|---------|
| `action` | string | Yes | Operation type: "search", "track_click", "feedback" | All |
| `query` | string | For search | Search query text | search |
| `supplier_name` | string | No | Filter by supplier | search |
| `weight_min` | float | No | Min product weight (kg) | search |
| `weight_max` | float | No | Max product weight (kg) | search |
| `is_for_sale` | bool | No | Filter by sale status | search |
| `is_for_web` | bool | No | Filter by web availability | search |
| `has_image` | bool | No | Filter by image availability | search |
| `limit` | int | No | Max results (default: 20, max: 100) | search |
| `offset` | int | No | Skip N results (pagination) | search |
| `weight_preset` | string | No | Ranking preset: "balanced", "exact_priority", etc. | search |
| `search_id` | int | For click/feedback | ID from search response | track_click, feedback |
| `clicked_product_id` | int | For click | Product that was clicked | track_click |
| `rank_position` | int | For click | Position in results (1-indexed) | track_click |
| `feedback_type` | string | For feedback | "helpful", "not_helpful", "no_results", "irrelevant" | feedback |
| `feedback_comment` | string | No | Optional comment | feedback |

## Search Features

### Intelligent Query Classification
The API automatically classifies queries and adjusts search strategy:

- **VENDOR_CODE**: `"100623SAMKO"` → Exact matching priority
- **EXACT_PHRASE**: `"Гальмівні колодки"` → Text matching priority
- **NATURAL_LANGUAGE**: `"brake pads for trucks"` → Balanced semantic approach

### Hybrid Search Techniques
Combines 4 search methods:
1. **Full-text Search** - PostgreSQL GIN indexes with ts_rank
2. **Trigram Fuzzy Matching** - Typo-tolerant similarity search
3. **Exact Text Matching** - Fast ILIKE pattern matching
4. **Vector Semantic Search** - AI embeddings with HNSW indexing

### ML Ranking
7-signal ensemble ranking:
- Exact match score
- Full-text score
- Trigram similarity
- Vector similarity
- Popularity score
- Availability score
- Freshness score

### Language Support
- ✅ **Ukrainian** - Full support
- ✅ **English** - Full support
- ❌ **Polish** - Excluded from search and embeddings

## Performance

- **Search**: <200ms for 278k products
- **Click Tracking**: <50ms
- **Feedback**: <50ms

## Testing

Run the test suite:

```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform
python3 test_unified_search_api.py
```

Or test manually:

```bash
# 1. Start the API
uvicorn src.api.search_api:app --reload --port 8000

# 2. Check API is running
curl http://localhost:8000/

# 3. Test search
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{"action": "search", "query": "test", "limit": 5}'
```

## Migration Guide

If you're migrating from the old multi-endpoint API:

### Old Code (Multiple Endpoints)
```python
# Product search
response = requests.post("http://api/search", json={
    "query": "brake pads",
    "limit": 10
})

# Click tracking
response = requests.post("http://api/search/click", json={
    "search_id": 123,
    "product_id": 456,
    "rank_position": 1
})

# Feedback
response = requests.post("http://api/search/feedback", json={
    "search_id": 123,
    "feedback_type": "helpful"
})
```

### New Code (Single Endpoint)
```python
# Product search
response = requests.post("http://api/search", json={
    "action": "search",  # ← Add this
    "query": "brake pads",
    "limit": 10
})

# Click tracking
response = requests.post("http://api/search", json={  # ← Same endpoint
    "action": "track_click",  # ← Add this
    "search_id": 123,
    "clicked_product_id": 456,  # ← Renamed field
    "rank_position": 1
})

# Feedback
response = requests.post("http://api/search", json={  # ← Same endpoint
    "action": "feedback",  # ← Add this
    "search_id": 123,
    "feedback_type": "helpful"
})
```

## Benefits

✅ **Maximum Simplicity** - One endpoint for everything
✅ **Easier Integration** - Single URL to remember
✅ **Reduced API Surface** - Fewer endpoints to maintain
✅ **Backward Compatible** - Default action is "search"
✅ **Better Documentation** - All operations in one place
✅ **Simplified Testing** - One endpoint to test

## Error Handling

### Invalid Action
```json
{
  "detail": "Invalid action 'invalid'. Must be 'search', 'track_click', or 'feedback'"
}
```

### Missing Required Fields
```json
{
  "detail": "Query is required for search action"
}
```

### Invalid Search ID
```json
{
  "detail": "Search ID 12345 not found"
}
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  POST /search                           │
│                 (Universal Endpoint)                    │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │   action parameter    │
         └───────────┬───────────┘
                     │
         ┌───────────┴───────────┬───────────────────┐
         │                       │                   │
         ▼                       ▼                   ▼
┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐
│ _handle_search  │  │ _handle_click_   │  │ _handle_        │
│                 │  │   tracking       │  │   feedback      │
│ • Classify      │  │                  │  │                 │
│ • Apply filters │  │ • Verify ID      │  │ • Verify ID     │
│ • Hybrid search │  │ • Log click      │  │ • Store feedback│
│ • ML ranking    │  │ • Return click_id│  │ • Confirm       │
│ • Return results│  │                  │  │                 │
└─────────────────┘  └──────────────────┘  └─────────────────┘
```

## Support

For issues or questions:
- Check API health: `GET /health`
- View API docs: `GET /`
- Run tests: `python3 test_unified_search_api.py`
