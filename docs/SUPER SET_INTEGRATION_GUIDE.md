# Superset Integration Guide - Product Analytics

**Date**: 2025-10-19
**Superset URL**: http://localhost:8088
**Catalog Size**: 278,697 products
**Status**: Ready for Dashboards

## Overview

This guide helps you create BI dashboards in Apache Superset using the 278k product catalog data.

---

## Database Connection

**Already configured** - Superset is connected to:
- Host: `localhost:5433`
- Database: `analytics`
- Schema: `staging_marts`
- Table: `dim_product` (278,697 products)

---

## Recommended Dashboards

### 1. Product Catalog Overview

**Metrics to Display**:
```sql
-- Total Products
SELECT COUNT(*) as total_products
FROM staging_marts.dim_product;

-- Products by Supplier
SELECT
  supplier_name,
  COUNT(*) as product_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) as percentage
FROM staging_marts.dim_product
GROUP BY supplier_name
ORDER BY product_count DESC
LIMIT 20;

-- Web Availability
SELECT
  is_for_web,
  COUNT(*) as count
FROM staging_marts.dim_product
GROUP BY is_for_web;
```

**Chart Types**:
- Big Number: Total Products
- Pie Chart: Products by Supplier
- Bar Chart: Web Availability

---

### 2. Data Quality Dashboard

**Multilingual Content Coverage**:
```sql
SELECT
  'Polish Name' as field,
  COUNT(*) FILTER (WHERE polish_name IS NOT NULL) as has_value,
  COUNT(*) FILTER (WHERE polish_name IS NULL) as missing,
  ROUND(100.0 * COUNT(*) FILTER (WHERE polish_name IS NOT NULL) / COUNT(*), 2) as coverage_pct
FROM staging_marts.dim_product
UNION ALL
SELECT
  'Ukrainian Name',
  COUNT(*) FILTER (WHERE ukrainian_name IS NOT NULL),
  COUNT(*) FILTER (WHERE ukrainian_name IS NULL),
  ROUND(100.0 * COUNT(*) FILTER (WHERE ukrainian_name IS NOT NULL) / COUNT(*), 2)
FROM staging_marts.dim_product
UNION ALL
SELECT
  'Description',
  COUNT(*) FILTER (WHERE description IS NOT NULL),
  COUNT(*) FILTER (WHERE description IS NULL),
  ROUND(100.0 * COUNT(*) FILTER (WHERE description IS NOT NULL) / COUNT(*), 2)
FROM staging_marts.dim_product;
```

---

### 3. ML Embedding Coverage

**Embedding Statistics**:
```sql
-- Embedding Coverage
SELECT
  'Total Products' as metric,
  COUNT(*)::text as value
FROM staging_marts.dim_product
UNION ALL
SELECT
  'Embeddings Generated',
  COUNT(*)::text
FROM analytics_features.product_embeddings
UNION ALL
SELECT
  'Coverage %',
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM staging_marts.dim_product), 2)::text || '%'
FROM analytics_features.product_embeddings;

-- HNSW Index Status
SELECT
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE indexname = 'idx_product_embeddings_hnsw';
```

---

### 4. Product Weight Distribution

**Weight Analysis**:
```sql
SELECT
  CASE
    WHEN weight IS NULL THEN 'Missing'
    WHEN weight < 1 THEN '< 1 kg'
    WHEN weight < 5 THEN '1-5 kg'
    WHEN weight < 20 THEN '5-20 kg'
    ELSE '> 20 kg'
  END as weight_range,
  COUNT(*) as product_count
FROM staging_marts.dim_product
GROUP BY 1
ORDER BY
  CASE
    WHEN weight IS NULL THEN 0
    WHEN weight < 1 THEN 1
    WHEN weight < 5 THEN 2
    WHEN weight < 20 THEN 3
    ELSE 4
  END;
```

---

## Step-by-Step Dashboard Creation

### 1. Create Dataset

1. Go to **Data > Datasets**
2. Click "+ Dataset"
3. Select:
   - Database: `analytics`
   - Schema: `staging_marts`
   - Table: `dim_product`
4. Click "Create Dataset and Create Chart"

### 2. Create Charts

**Example: Products by Supplier (Bar Chart)**:
1. Chart Type: "Bar Chart"
2. Dimensions: `supplier_name`
3. Metrics: `COUNT(*)`
4. Sort: Descending by COUNT
5. Row Limit: 20
6. Save as "Top 20 Suppliers"

### 3. Build Dashboard

1. Go to **Dashboards**
2. Click "+ Dashboard"
3. Name: "Product Catalog Analytics"
4. Drag saved charts onto dashboard
5. Arrange and resize
6. Save

---

## Advanced Queries

### Products with Complete Data
```sql
SELECT
  COUNT(*) as complete_products
FROM staging_marts.dim_product
WHERE
  name IS NOT NULL
  AND polish_name IS NOT NULL
  AND ukrainian_name IS NOT NULL
  AND description IS NOT NULL
  AND has_image = true;
```

### Recent Product Updates
```sql
SELECT
  DATE(updated) as update_date,
  COUNT(*) as products_updated
FROM staging_marts.dim_product
WHERE updated >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(updated)
ORDER BY update_date DESC;
```

---

## Related Documentation

- [ML_SEARCH_IMPLEMENTATION.md](./ML_SEARCH_IMPLEMENTATION.md)
- [API_USAGE_GUIDE.md](./API_USAGE_GUIDE.md)
- [SUPERSET_READY.md](./SUPERSET_READY.md)

---

**Last Updated**: 2025-10-19
**Status**: Ready for Dashboard Creation
