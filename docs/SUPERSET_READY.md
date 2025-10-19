# Superset BI Dashboard - Ready to Use

**Date**: 2025-10-19
**Status**: ✅ Fully Initialized and Running
**Access URL**: http://localhost:8088

## Quick Start

### 1. Access Superset

Open your browser and navigate to:
```
http://localhost:8088
```

**Login Credentials:**
- Username: `admin`
- Password: `admin`

⚠️ **IMPORTANT**: Change this password after first login!

### 2. Connect to Analytics Database

After logging in:

1. Click **Settings** (⚙️ icon in top right)
2. Select **Database Connections**
3. Click **+ Database** button
4. Choose **PostgreSQL** from the list

**Connection Details:**
```
Display Name: BI Platform Analytics
Host: host.docker.internal
Port: 5433
Database: analytics
Username: analytics
Password: analytics
```

**Advanced Options:**
- ✅ Enable "Allow DML"
- ✅ Enable "Allow Data Upload"
- ✅ Enable "Expose in SQL Lab"

5. Click **Test Connection** (should show ✅ Success)
6. Click **Connect**

### 3. Available Data

**Staging Layer** (staging_staging schema):
- `stg_product` - 115 products with 54 columns
  - 100% field completeness
  - Multilingual support (Polish, Ukrainian)
  - Business flags (is_for_web, has_analogue, etc.)
  - Supplier distribution (SEM1: 43%, SABO: 36%)

**Analytics Features** (analytics_features schema):
- `product_embeddings` - 115 semantic vectors
  - 384 dimensions
  - 99.6%+ similarity for identical products
  - Ready for recommendation engine

**Bronze CDC** (bronze schema):
- `product_cdc` - Raw change data capture events
  - JSONB payloads
  - Kafka metadata (topic, partition, offset)

## Dashboard Templates

### Dashboard 1: Product Catalog Overview

**Purpose**: Executive summary of product catalog

**Recommended Charts:**

#### 1. Total Products (Big Number KPI)
```sql
SELECT COUNT(*) as total_products
FROM staging_staging.stg_product
WHERE deleted = false;
```
**Expected Result**: 115

#### 2. Products by Supplier (Pie Chart)
```sql
SELECT
    COALESCE(LEFT(vendor_code, 4), 'Unknown') as supplier,
    COUNT(*) as product_count
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY LEFT(vendor_code, 4)
ORDER BY product_count DESC;
```
**Expected Result**: SEM1 (50), SABO (41), others (24)

#### 3. Multilingual Coverage (Grouped Bar Chart)
```sql
SELECT
    'Names' as field_category,
    COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END) as polish,
    COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END) as ukrainian
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Descriptions',
    COUNT(CASE WHEN description_pl IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN description_ua IS NOT NULL THEN 1 END)
FROM staging_staging.stg_product WHERE deleted = false;
```
**Expected Result**: 100% coverage (115/115 for both languages)

#### 4. Business Flags (Stacked Bar Chart)
```sql
SELECT
    'For Web' as flag_name,
    SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) as enabled,
    COUNT(*) - SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) as disabled
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Analogue',
    SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END),
    COUNT(*) - SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'For Sale',
    SUM(CASE WHEN is_for_sale = true THEN 1 ELSE 0 END),
    COUNT(*) - SUM(CASE WHEN is_for_sale = true THEN 1 ELSE 0 END)
FROM staging_staging.stg_product WHERE deleted = false;
```

### Dashboard 2: Data Quality Monitoring

**Purpose**: Track data completeness and identify issues

#### 1. Field Completeness (Horizontal Bar Chart)
```sql
SELECT
    'Vendor Code' as field,
    ROUND(100.0 * COUNT(vendor_code) / COUNT(*), 2) as completeness_pct
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Polish Name',
    ROUND(100.0 * COUNT(name_pl) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Ukrainian Name',
    ROUND(100.0 * COUNT(name_ua) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Polish Description',
    ROUND(100.0 * COUNT(description_pl) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
ORDER BY completeness_pct DESC;
```

#### 2. Data Quality Issues (Table)
```sql
SELECT
    'Products not for sale' as issue,
    COUNT(*) FILTER (WHERE is_for_sale = false) as count,
    'Investigate business rules' as recommendation
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Products without images',
    COUNT(*) FILTER (WHERE has_image = false),
    'Verify image files and update flags'
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Products with zero weight',
    COUNT(*) FILTER (WHERE weight IS NULL OR weight = 0),
    'Verify weight measurement units'
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Missing vendor codes',
    COUNT(*) FILTER (WHERE vendor_code IS NULL OR LENGTH(vendor_code) < 4),
    'Assign vendor codes'
FROM staging_staging.stg_product WHERE deleted = false;
```

### Dashboard 3: Semantic Search Analytics

**Purpose**: Monitor embedding quality and enable product recommendations

#### 1. Embedding Coverage (Big Number with Subheader)
```sql
SELECT
    COUNT(*) as total_embeddings,
    vector_dims((SELECT embedding FROM analytics_features.product_embeddings LIMIT 1)) as dimensions,
    'sentence-transformers/all-MiniLM-L6-v2' as model_name
FROM analytics_features.product_embeddings;
```
**Expected Result**: 115 embeddings @ 384 dimensions

#### 2. Top Similar Products (Table)
```sql
SELECT
    p1.vendor_code as product_1,
    p1.name as product_1_name,
    p2.vendor_code as product_2,
    p2.name as product_2_name,
    ROUND((1 - (e1.embedding <=> e2.embedding))::numeric, 4) as similarity
FROM analytics_features.product_embeddings e1
JOIN analytics_features.product_embeddings e2 ON e1.product_id < e2.product_id
JOIN staging_staging.stg_product p1 ON p1.product_id = e1.product_id
JOIN staging_staging.stg_product p2 ON p2.product_id = e2.product_id
WHERE p1.deleted = false AND p2.deleted = false
ORDER BY similarity DESC
LIMIT 20;
```
**Expected Result**: Top pairs with 99%+ similarity

#### 3. Product Recommendations (Parameterized Query)
```sql
-- Find top 10 similar products to a given product ID
WITH target AS (
    SELECT embedding FROM analytics_features.product_embeddings
    WHERE product_id = 7807552  -- Change this to any product_id
)
SELECT
    p.product_id,
    p.vendor_code,
    p.name,
    ROUND((1 - (e.embedding <=> t.embedding))::numeric, 4) as similarity_score
FROM analytics_features.product_embeddings e
CROSS JOIN target t
JOIN staging_staging.stg_product p ON p.product_id = e.product_id
WHERE e.product_id != 7807552  -- Exclude the target product
  AND p.deleted = false
ORDER BY similarity_score DESC
LIMIT 10;
```

## Creating Your First Dashboard

### Step-by-Step Guide

1. **Navigate to Dashboards**
   - Click **Dashboards** in the top menu
   - Click **+ Dashboard** button

2. **Name Your Dashboard**
   - Title: "Product Catalog Overview"
   - Save

3. **Add Charts**
   - Click **Edit Dashboard**
   - Click **+ Add Chart**
   - Select "Create a new chart"
   - Choose database: "BI Platform Analytics"
   - Choose dataset: Click "Create dataset" if needed
     - Schema: staging_staging
     - Table: stg_product
   - Select chart type (e.g., "Big Number")
   - Paste SQL query from templates above
   - Click **Run Query**
   - Customize appearance
   - Click **Save**

4. **Arrange Charts**
   - Drag and drop charts to organize layout
   - Resize charts as needed
   - Add text boxes for context

5. **Save Dashboard**
   - Click **Save** in top right

## SQL Lab Usage

For ad-hoc queries:

1. Navigate to **SQL** → **SQL Lab**
2. Select database: "BI Platform Analytics"
3. Select schema: "staging_staging"
4. Write your query
5. Click **Run**
6. Export results as CSV if needed
7. Save queries for reuse

## Performance Tips

### Add Indexes for Frequently Queried Columns
```sql
-- Run these in PostgreSQL (not Superset)
CREATE INDEX IF NOT EXISTS idx_product_vendor_code
ON staging_staging.stg_product(vendor_code);

CREATE INDEX IF NOT EXISTS idx_product_created
ON staging_staging.stg_product(created);

CREATE INDEX IF NOT EXISTS idx_product_deleted
ON staging_staging.stg_product(deleted);
```

### Enable Query Result Caching
1. Go to **Settings** → **Database Connections**
2. Edit "BI Platform Analytics"
3. Set **Cache Timeout**: 300 (5 minutes)
4. Enable **Query Result Cache**
5. Save

## Advanced Features

### Scheduled Reports
1. Navigate to **Settings** → **Alerts & Reports**
2. Click **+ Report**
3. Select dashboard
4. Choose schedule (daily, weekly, monthly)
5. Add email recipients
6. Save

### Dashboard Filters
1. Edit dashboard
2. Click **Filters** button
3. Add filters:
   - Supplier (based on vendor_code)
   - Date Range (created/updated)
   - Language (PL/UA)
4. Apply filters to specific charts
5. Save

### Row-Level Security (Optional)
If you need to restrict data access by user:
1. Navigate to **Security** → **Row Level Security**
2. Create filter based on user roles
3. Apply to specific tables

## Troubleshooting

### Cannot Connect to Database
**Symptom**: "Connection failed" error

**Solution**:
```bash
# Test PostgreSQL connectivity from Superset container
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml exec superset bash
psql -h host.docker.internal -p 5433 -U analytics -d analytics -c "SELECT COUNT(*) FROM staging_staging.stg_product;"
# Should return: 115
```

### Slow Dashboard Performance
**Solutions**:
1. Enable result caching (see Performance Tips)
2. Add database indexes
3. Optimize SQL queries (avoid SELECT *)
4. Use materialized views for complex queries

### Charts Show "No Data"
**Checklist**:
- ✅ Database connection successful
- ✅ Correct schema selected (staging_staging)
- ✅ SQL query returns results in SQL Lab
- ✅ No NULL values in dimension columns
- ✅ Check Superset logs for errors

## Next Steps

### Immediate
1. ✅ Access Superset at http://localhost:8088
2. ✅ Login with admin/admin
3. ✅ Change admin password
4. ✅ Connect to analytics database
5. ✅ Create "Product Catalog Overview" dashboard

### This Week
6. Create "Data Quality Monitoring" dashboard
7. Create "Semantic Search Analytics" dashboard
8. Set up scheduled daily reports
9. Add dashboard filters (supplier, date range)
10. Share dashboards with team

### Next Steps
11. Address data quality issues (see profiling report)
12. Deploy Phase 2 tables (when SQL Server connectivity restored)
13. Expand embeddings with more context
14. Build recommendation engine API

## Resources

**Documentation:**
- Fresh Data Profiling: `/Users/oleksandrmelnychenko/Projects/bi-platform/docs/FRESH_DATA_PROFILING_REPORT.md`
- Setup Guide: `/Users/oleksandrmelnychenko/Projects/bi-platform/docs/SUPERSET_SETUP_GUIDE.md`
- SQL Queries: `/Users/oleksandrmelnychenko/Projects/bi-platform/sql/analytics/product_dashboard_queries.sql`

**Access Points:**
- Superset UI: http://localhost:8088
- PostgreSQL: localhost:5433 (analytics/analytics)
- MinIO Console: http://localhost:9001 (minioadmin/minioadmin)
- Prefect UI: http://localhost:4200

**Commands:**
```bash
# View Superset logs
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml logs -f

# Restart Superset
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml restart

# Stop Superset
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml down

# Fresh start (removes all dashboards/settings)
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml down -v
```

## Current Data Summary

**Product Data (staging_staging.stg_product):**
- Total Products: 115
- Field Completeness: 100% (54/54 columns)
- Multilingual Coverage: 100% (Polish + Ukrainian)
- Unique Vendor Codes: 114
- Products for Web: 115 (100%)
- Products with Analogues: 77 (67%)

**Supplier Distribution:**
- SEM1: 50 products (43.48%)
- SABO: 41 products (35.65%)
- Others: 24 products (20.87%)

**Semantic Embeddings (analytics_features.product_embeddings):**
- Total Vectors: 115
- Dimensions: 384
- Model: sentence-transformers/all-MiniLM-L6-v2
- Similarity Quality: 99.6%+ for identical products

**Data Quality Issues:**
1. ⚠️ All products: is_for_sale = false (investigate business rules)
2. ⚠️ All products: has_image = false (verify image files)
3. ⚠️ 110 products: weight = 0 or NULL (verify units)
4. ⚠️ 2 products: missing vendor codes (IDs: 7807618, 7807619)

---

**Status**: ✅ Superset Ready to Use
**Date**: 2025-10-19
**Access**: http://localhost:8088 (admin/admin)
**Next Action**: Login and create your first dashboard!
