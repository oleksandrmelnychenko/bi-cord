# Semantic Search Quality Investigation

## Date
2025-10-20

## Issue Description

Query for "тормозні колодки" (Ukrainian: brake pads) returns "Циліндр гальмівний" (brake cylinders) instead of actual brake pad products, despite brake pads existing in the database with proper embeddings.

## Investigation Summary

### Test Query
- **Query**: "тормозні колодки" (brake pads in Ukrainian)
- **Expected**: Products with `ukrainian_name = "Колодки гальмівні"`
- **Actual**: Top results are "Циліндр гальмівний" (brake cylinders)
- **Execution Time**: 1591.84ms
- **Cache Status**: HIT (query embedding served from cache correctly)

### Database Verification

#### 1. Brake Pad Products Exist
```sql
SELECT product_id, vendor_code, name, ukrainian_name, supplier_name
FROM staging_marts.dim_product
WHERE ukrainian_name ILIKE '%Колодки гальмівні%'
LIMIT 10;
```

**Result**: 10+ brake pad products found
- product_id: 7832540, vendor_code: MG26823
- product_id: 7832585, vendor_code: MG21823
- All have `ukrainian_name = "Колодки гальмівні"`

#### 2. Brake Pads Have Embeddings
```sql
SELECT p.product_id, p.vendor_code, p.name, p.ukrainian_name,
       CASE WHEN e.product_id IS NOT NULL THEN 'YES' ELSE 'NO' END as has_embedding
FROM staging_marts.dim_product p
LEFT JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
WHERE p.ukrainian_name ILIKE '%Колодки гальмівні%'
LIMIT 10;
```

**Result**: All brake pad products have embeddings (has_embedding = 'YES')

#### 3. Vector Search Returns Wrong Products
```sql
WITH query_emb AS (
  SELECT embedding
  FROM analytics_features.query_embeddings
  WHERE query_text = 'тормозні колодки'
  LIMIT 1
)
SELECT
  p.product_id,
  p.vendor_code,
  p.name,
  p.ukrainian_name,
  p.supplier_name,
  (e.embedding <=> (SELECT embedding FROM query_emb)) as distance
FROM analytics_features.product_embeddings e
JOIN staging_marts.dim_product p ON p.product_id = e.product_id
CROSS JOIN query_emb
ORDER BY e.embedding <=> (SELECT embedding FROM query_emb)
LIMIT 20;
```

**Result**: Top results are ALL brake cylinders with distances ~0.47-0.52
```
product_id |   vendor_code   |           name           |      ukrainian_name       | distance
-----------+-----------------+--------------------------+---------------------------+----------
   7900033 | 2019-01         | Цилиндр тормозной        | Циліндр гальмівний        | 0.474
   7968027 |                 | Полки нижні відкриті     | Полки нижні відкриті      | 0.489
   7898095 | 2017-01         | Цилиндр тормозной        | Циліндр гальмівний        | 0.490
```

## Root Cause Analysis

### 1. Shared Terminology
Both "Колодки гальмівні" (brake pads) and "Циліндр гальмівний" (brake cylinders) contain:
- **"гальмівн"** - Ukrainian word meaning "brake" or "braking"
- Both are brake-related automotive components
- The embedding model sees them as semantically similar

### 2. General-Purpose Embedding Model
Current model: `sentence-transformers/all-MiniLM-L6-v2`

**Characteristics**:
- Trained on general internet text
- No domain-specific knowledge of automotive parts
- Focuses on word overlap and general semantic similarity
- Cannot distinguish between different types of brake components

### 3. Product Text Representation

#### embedding_pipeline.py (OLD)
```python
def build_text(product: dict) -> str:
    parts: list[str] = []
    for key, value in product.items():
        if key in EXCLUDE_COLUMNS:
            continue
        if value is None:
            continue
        text = f"{key}: {value}"
        parts.append(text)
    return ". ".join(parts)
```

**Issue**: Combines ALL fields, diluting semantic meaning with metadata (IDs, codes, booleans)

#### embedding_pipeline_v2.py (CURRENT)
```python
def build_text(product: Dict[str, Any]) -> str:
    """Build searchable text representation of product"""
    parts = []

    if product.get('vendor_code'):
        parts.append(f"Code: {product['vendor_code']}")

    if product.get('name'):
        parts.append(f"Name: {product['name']}")

    if product.get('ukrainian_name'):
        parts.append(f"Ukrainian: {product['ukrainian_name']}")

    if product.get('polish_name'):
        parts.append(f"Polish: {product['polish_name']}")

    if product.get('supplier_name'):
        parts.append(f"Supplier: {product['supplier_name']}")

    # Add metadata...
    return ". ".join(parts)
```

**Better but still limited**:
- Focuses on names and metadata
- No product category or type information
- No additional descriptive context

### 4. Example Product Embeddings

**Brake Pad Product**:
```
Code: MG26823. Name: Колодки тормозные. Ukrainian: Колодки гальмівні. Supplier: MG26. For sale. Available online. Has image. Weight: 1.5kg
```

**Brake Cylinder Product**:
```
Code: 2019-01. Name: Цилиндр тормозной. Ukrainian: Циліндр гальмівний. Supplier: 2019. For sale. Available online. Has image. Weight: 0.8kg
```

**Embedding Model Perspective**:
- Both contain brake-related terms ("тормозные"/"гальмівні")
- Similar metadata (for sale, online, has image)
- Both automotive parts
- Similar text structure

Result: Model considers them semantically similar (distance ~0.47)

## Impact Assessment

### Affected Queries
- Ukrainian automotive part queries
- Russian automotive part queries
- Any queries where products share domain terminology

### Cache System Impact
- **Cache functionality**: ✅ Working correctly
- **Query embedding**: ✅ Generated and cached correctly
- **Search results**: ❌ Semantically incorrect but technically valid

### Performance Impact
- No performance issues
- Cache reduces latency as designed
- Problem is result **quality**, not **speed**

## Proposed Solutions

### Solution 1: Add Product Category to Embeddings (Quick Win)

**Implementation**:
```python
def build_text(product: Dict[str, Any]) -> str:
    parts = []

    # Add category/type first (highest priority)
    if product.get('product_category'):
        parts.append(f"Category: {product['product_category']}")

    if product.get('product_type'):
        parts.append(f"Type: {product['product_type']}")

    # Then names...
    if product.get('ukrainian_name'):
        parts.append(f"{product['ukrainian_name']}")

    # ...rest of fields
    return ". ".join(parts)
```

**Pros**:
- Easy to implement
- No model retraining needed
- Can be done immediately

**Cons**:
- Requires product categorization data
- May not fully solve the problem

### Solution 2: Fine-tune Embedding Model (Long-term)

**Process**:
1. Collect training data:
   - Positive pairs: Same product category
   - Negative pairs: Different categories (brake pads ≠ brake cylinders)
2. Fine-tune all-MiniLM-L6-v2 on automotive parts
3. Re-generate all product embeddings

**Pros**:
- Most effective solution
- Model learns automotive domain knowledge
- Better semantic understanding

**Cons**:
- Requires labeled training data
- Time-consuming (weeks)
- Need to re-embed all 275k products

### Solution 3: Hybrid Search (Recommended)

**Implementation**:
```python
def hybrid_search(query: str, limit: int):
    # 1. Semantic search (current)
    semantic_results = semantic_search(query, limit * 2)

    # 2. Keyword search (PostgreSQL full-text)
    keyword_results = fulltext_search(query, limit * 2)

    # 3. Exact match boost
    exact_matches = exact_text_search(query, limit)

    # 4. Combine and re-rank
    combined = merge_and_rerank(
        semantic_results,
        keyword_results,
        exact_matches,
        weights={'semantic': 0.4, 'keyword': 0.4, 'exact': 0.2}
    )

    return combined[:limit]
```

**Pros**:
- Combines strengths of multiple approaches
- Exact matches get boosted
- More robust search
- Can be implemented incrementally

**Cons**:
- More complex implementation
- Requires tuning weights
- Slightly slower (multiple queries)

### Solution 4: Add Product Description/Specifications

**Implementation**:
```python
def build_text(product: Dict[str, Any]) -> str:
    parts = []

    # Core identity
    parts.append(f"{product['ukrainian_name']}")

    # Add rich description if available
    if product.get('description'):
        parts.append(product['description'])

    # Add specifications
    if product.get('specifications'):
        parts.append(f"Specs: {product['specifications']}")

    # Add usage/application
    if product.get('application'):
        parts.append(f"Used for: {product['application']}")

    return ". ".join(parts)
```

**Pros**:
- Provides more context for model
- Natural way to add information
- No model changes needed

**Cons**:
- Requires product description data
- Data may not exist for all products
- Increases embedding size/complexity

### Solution 5: Re-rank with Exact Text Matching

**Implementation**:
```python
def rerank_results(query: str, results: List[Product]) -> List[Product]:
    """Boost results with exact query term matches"""
    query_terms = set(query.lower().split())

    for result in results:
        # Calculate exact match score
        product_text = (result.ukrainian_name + " " + result.name).lower()
        product_terms = set(product_text.split())

        overlap = len(query_terms & product_terms)
        exact_score = overlap / len(query_terms)

        # Boost similarity score
        result.similarity_score = (
            result.similarity_score * 0.7 +  # Semantic score
            exact_score * 0.3                 # Exact match boost
        )

    return sorted(results, key=lambda x: x.similarity_score, reverse=True)
```

**Pros**:
- Simple post-processing step
- No database changes
- Immediate improvement

**Cons**:
- Still relies on semantic search first
- May not work for typos/variations

## Recommended Approach

**Phase 1 (Immediate - 1-2 days)**:
1. Implement Solution 5: Re-rank with exact text matching
2. Add logging to track result quality improvements

**Phase 2 (Short-term - 1 week)**:
3. Implement Solution 3: Hybrid search architecture
4. Combine semantic + keyword + exact match
5. A/B test with different ranking weights

**Phase 3 (Medium-term - 2-4 weeks)**:
6. Add product categorization if not available
7. Implement Solution 1: Add categories to embeddings
8. Re-generate embeddings with categories

**Phase 4 (Long-term - 2-3 months)**:
9. Collect training data for automotive domain
10. Fine-tune embedding model (Solution 2)
11. Evaluate against current model

## Testing and Validation

### Test Queries
Create test suite with known good/bad results:

```python
test_queries = [
    {
        "query": "тормозні колодки",
        "expected_category": "brake_pads",
        "not_expected": ["brake_cylinder", "brake_disc"]
    },
    {
        "query": "масляний фільтр",
        "expected_category": "oil_filter",
        "not_expected": ["air_filter", "fuel_filter"]
    },
    # ... more test cases
]
```

### Metrics to Track
1. **Precision@K**: Relevant results in top K
2. **Category Accuracy**: Correct category in top results
3. **User Click-Through Rate**: Production metric
4. **Exact Match Coverage**: % of queries with exact match in top 10

## Implementation Status

- [x] Issue identified and documented
- [x] Root cause analysis complete
- [x] Database verification complete
- [x] Solutions proposed
- [ ] Solution selection and approval
- [ ] Implementation planning
- [ ] Development
- [ ] Testing
- [ ] Production deployment

## Related Files

- Database schema: `sql/search/create_hnsw_index.sql`
- Current embedding pipeline: `src/ml/embedding_pipeline_v2.py`
- Search API: `src/api/search_api.py`
- Performance docs: `docs/EMBEDDING_PERFORMANCE_OPTIMIZATION.md`
- Query cache docs: `docs/QUERY_CACHE_IMPLEMENTATION.md`

## Notes

- Cache system is working correctly - this is NOT a caching issue
- Performance is acceptable - this is NOT a performance issue
- This is a **search quality** issue requiring algorithm changes
- The embedding model sees brake pads and brake cylinders as similar (which they are, semantically - both are brake components)
- Need to add more specific signals to distinguish between related but different products
