# Superset Dashboard Creation Guide

**Date**: 2025-10-19
**Purpose**: Step-by-step guide for creating Product analytics dashboards in Superset
**Prerequisites**: Superset running at http://localhost:8088, dim_product mart created

## Quick Reference

**Superset URL**: http://localhost:8088
**Credentials**: admin / admin (⚠️ change after first login)
**Database**: staging_marts.dim_product (115 active products)
**Data Quality**: 100% field completeness, 100% multilingual coverage

## Step 1: Initial Access

1. Open browser: http://localhost:8088
2. Login with admin/admin
3. **IMPORTANT**: Navigate to **Settings** → **User Info** → **Reset Password**
   - Change to a secure password
   - Save

## Step 2: Connect to Analytics Database

1. Click **Settings** (⚙️ icon in top right)
2. Select **Database Connections**
3. Click **+ Database** button
4. Choose **PostgreSQL** from supported databases list

**Connection Details:**
```
Database Name: BI Platform Analytics
Host: host.docker.internal
Port: 5433
Database: analytics
Username: analytics
Password: analytics
```

**Advanced Settings** (click "Advanced" tab):
- ✅ Enable "Allow DML"
- ✅ Enable "Allow Data Upload"
- ✅ Enable "Expose in SQL Lab"
- Cache Timeout: 300 (5 minutes)

5. Click **Test Connection** → Should show "✅ Connection looks good!"
6. Click **Connect**

## Step 3: Create Dataset

Before creating charts, you need to register the `dim_product` table as a dataset:

1. Navigate to **Data** → **Datasets**
2. Click **+ Dataset** button
3. Select:
   - **Database**: BI Platform Analytics
   - **Schema**: staging_marts
   - **Table**: dim_product
4. Click **Add**

The dataset will appear in the datasets list with 115 rows.

## Step 4: Create First Dashboard

### Dashboard: Product Catalog Overview

1. Navigate to **Dashboards** (top menu)
2. Click **+ Dashboard** button
3. Title: `Product Catalog Overview`
4. Click **Save**

You now have an empty dashboard. Let's add charts.

## Step 5: Create Charts

### Chart 1: Total Products (Big Number KPI)

1. Click **Edit Dashboard**
2. Click **+ Add Chart** (or drag from Components panel)
3. Click **Create a new chart**
4. Select:
   - **Dataset**: dim_product
   - **Chart Type**: Big Number
5. Click **Create new chart**

**Configuration:**
- **Query**:
  - Metric: COUNT(*)
  - Filters: (none)
- **Customize**:
  - Title: "Total Active Products"
  - Subheader: "In Catalog"

6. Click **Run** to preview
7. Expected result: **115**
8. Click **Save**
   - Chart name: "Total Products"
   - Add to dashboard: "Product Catalog Overview"

### Chart 2: Products by Supplier (Pie Chart)

1. In the dashboard, click **+ Add Chart**
2. Select **Create a new chart**
3. Dataset: dim_product, Chart Type: **Pie Chart**

**Configuration:**
- **Query**:
  - Dimension: supplier_name
  - Metric: COUNT(*)
- **Customize**:
  - Title: "Product Distribution by Supplier"
  - Show Labels: Yes
  - Show Percentage: Yes

4. Click **Run**
5. Expected: Top suppliers (SEM1, SABO, etc.)
6. **Save** as "Products by Supplier"

### Chart 3: Multilingual Coverage (Bar Chart)

1. Click **+ Add Chart** → **Create new chart**
2. Dataset: dim_product, Chart Type: **Bar Chart**

**Configuration:**
- **Query** tab → Click "Custom SQL":
```sql
SELECT
    'Polish Name' as language_field,
    COUNT(CASE WHEN polish_name IS NOT NULL THEN 1 END) as populated,
    COUNT(*) - COUNT(CASE WHEN polish_name IS NOT NULL THEN 1 END) as missing
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Ukrainian Name',
    COUNT(CASE WHEN ukrainian_name IS NOT NULL THEN 1 END),
    COUNT(*) - COUNT(CASE WHEN ukrainian_name IS NOT NULL THEN 1 END)
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Polish Description',
    COUNT(CASE WHEN polish_description IS NOT NULL THEN 1 END),
    COUNT(*) - COUNT(CASE WHEN polish_description IS NOT NULL THEN 1 END)
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Ukrainian Description',
    COUNT(CASE WHEN ukrainian_description IS NOT NULL THEN 1 END),
    COUNT(*) - COUNT(CASE WHEN ukrainian_description IS NOT NULL THEN 1 END)
FROM staging_marts.dim_product;
```

**Configuration:**
- **Data** tab:
  - X-axis: language_field
  - Metrics: populated, missing
- **Customize**:
  - Title: "Multilingual Field Coverage"
  - Chart Type: Stacked Bar Chart
  - Color Scheme: Choose a contrasting pair

4. Click **Run** → Should show 100% populated (115/115) for all fields
5. **Save** as "Multilingual Coverage"

### Chart 4: Products by Weight Category (Pie Chart)

1. Click **+ Add Chart** → **Create new chart**
2. Dataset: dim_product, Chart Type: **Pie Chart**

**Configuration:**
- **Query**:
  - Dimension: weight_category
  - Metric: COUNT(*)
- **Customize**:
  - Title: "Products by Weight Category"
  - Show Labels: Yes

3. Click **Run**
4. Expected: Distribution across Missing/Light/Medium/Heavy
5. **Save** as "Weight Distribution"

### Chart 5: Multilingual Status (Donut Chart)

1. Click **+ Add Chart** → **Create new chart**
2. Dataset: dim_product, Chart Type: **Pie Chart**

**Configuration:**
- **Query**:
  - Dimension: multilingual_status
  - Metric: COUNT(*)
- **Customize**:
  - Title: "Multilingual Completion Status"
  - Donut: Yes
  - Inner Radius: 50

3. Click **Run**
4. Expected: 100% "Complete" (115 products)
5. **Save** as "Multilingual Status"

### Chart 6: Supplier Product Table (Table)

1. Click **+ Add Chart** → **Create new chart**
2. Dataset: dim_product, Chart Type: **Table**

**Configuration:**
- **Query** tab → Custom SQL:
```sql
SELECT
    supplier_name,
    COUNT(*) as product_count,
    COUNT(CASE WHEN has_analogue = true THEN 1 END) as products_with_analogues,
    COUNT(CASE WHEN is_for_web = true THEN 1 END) as products_on_web,
    ROUND(AVG(CASE WHEN weight > 0 THEN weight END), 2) as avg_weight_kg
FROM staging_marts.dim_product
GROUP BY supplier_name
ORDER BY product_count DESC;
```

**Configuration:**
- **Customize**:
  - Title: "Supplier Summary Table"
  - Page Length: 10

3. Click **Run**
4. **Save** as "Supplier Summary"

## Step 6: Arrange Dashboard Layout

1. Click **Edit Dashboard** (pencil icon)
2. Drag and drop charts to arrange:
   - **Top Row**: Total Products KPI (left), Multilingual Status Donut (center), Weight Distribution (right)
   - **Middle Row**: Products by Supplier Pie (left), Multilingual Coverage Bar (right)
   - **Bottom Row**: Supplier Summary Table (full width)
3. Resize charts as needed by dragging corners
4. Click **Save**

## Step 7: Add Dashboard Filters

1. In edit mode, click **Filters** button
2. Click **+ Add Filter**
3. Configure filter:
   - **Column**: supplier_name
   - **Filter Type**: Select Box
   - **Default Value**: (leave empty for "All")
4. Click charts to apply filter to them
5. **Save**

Now users can filter the entire dashboard by supplier.

## Step 8: Test Dashboard

1. Exit edit mode
2. Use supplier filter → Select "SEM1"
   - Verify all charts update
   - Total Products should show 50
3. Clear filter
4. Click **⋮** (three dots) → **Force Refresh**
   - Verifies data connection works

## Additional Charts (Optional)

### Chart: Recent Product Activity (Time Series)

**Custom SQL**:
```sql
SELECT
    DATE(created) as date,
    COUNT(*) as products_created
FROM staging_marts.dim_product
WHERE created >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY DATE(created)
ORDER BY date;
```

**Chart Type**: Line Chart
**X-axis**: date
**Metric**: products_created

### Chart: Top 10 Products by Weight

**Custom SQL**:
```sql
SELECT
    vendor_code,
    name,
    weight,
    supplier_name
FROM staging_marts.dim_product
WHERE weight > 0
ORDER BY weight DESC
LIMIT 10;
```

**Chart Type**: Bar Chart (Horizontal)

### Chart: Search Optimization Status

**Custom SQL**:
```sql
SELECT
    'Base Name' as field,
    COUNT(CASE WHEN search_name IS NOT NULL THEN 1 END) as optimized
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Polish Name',
    COUNT(CASE WHEN search_polish_name IS NOT NULL THEN 1 END)
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Ukrainian Name',
    COUNT(CASE WHEN search_ukrainian_name IS NOT NULL THEN 1 END)
FROM staging_marts.dim_product;
```

**Chart Type**: Bar Chart

## Dashboard 2: Data Quality Monitoring

Create a second dashboard focusing on data quality:

### Chart: Data Quality Issues Table

**Custom SQL**:
```sql
SELECT
    'Products not for sale' as issue,
    COUNT(*) FILTER (WHERE is_for_sale = false) as count,
    'Investigate business rules' as action
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Products without images',
    COUNT(*) FILTER (WHERE has_image = false),
    'Verify image files'
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Products with zero/null weight',
    COUNT(*) FILTER (WHERE weight IS NULL OR weight = 0),
    'Verify weight units'
FROM staging_marts.dim_product

UNION ALL

SELECT
    'Products missing vendor code',
    COUNT(*) FILTER (WHERE vendor_code IS NULL OR LENGTH(vendor_code) < 4),
    'Assign vendor codes'
FROM staging_marts.dim_product;
```

**Chart Type**: Table

### Chart: Data Freshness (Big Number)

**Custom SQL**:
```sql
SELECT
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(ingested_timestamp))) / 3600 as hours_since_last_update
FROM staging_marts.dim_product;
```

**Chart Type**: Big Number
**Title**: "Data Age (Hours)"

## Sharing Dashboards

### Option 1: Direct URL
Share the dashboard URL with team members:
```
http://localhost:8088/superset/dashboard/{dashboard_id}/
```

### Option 2: Email Reports

1. Navigate to **Settings** → **Alerts & Reports**
2. Click **+ Report**
3. Configure:
   - **Report Name**: "Daily Product Metrics"
   - **Dashboard**: Product Catalog Overview
   - **Schedule**: Daily at 8:00 AM
   - **Recipients**: team@company.com
4. **Save**

### Option 3: Embed in Application

Use Superset's embedding API to embed dashboards in your web application.

## Performance Optimization

### Enable Query Caching

1. Go to **Settings** → **Database Connections**
2. Edit "BI Platform Analytics"
3. Set **Cache Timeout**: 300 seconds (5 minutes)
4. Enable **Query Result Cache**

### Add Database Indexes

Run these in PostgreSQL to speed up common queries:

```sql
-- Frequently filtered columns
CREATE INDEX IF NOT EXISTS idx_dim_product_supplier_name
ON staging_marts.dim_product(supplier_name);

CREATE INDEX IF NOT EXISTS idx_dim_product_created
ON staging_marts.dim_product(created);

CREATE INDEX IF NOT EXISTS idx_dim_product_weight_category
ON staging_marts.dim_product(weight_category);

-- Frequently joined columns
CREATE INDEX IF NOT EXISTS idx_dim_product_product_id
ON staging_marts.dim_product(product_id);
```

## Troubleshooting

### Issue: Chart Shows "No Data"

**Checklist**:
1. Verify dataset has data: **Data** → **Datasets** → dim_product → View rows
2. Check SQL query in SQL Lab: **SQL** → **SQL Lab** → Paste query → Run
3. Check filters aren't too restrictive
4. Clear Superset cache: **Settings** → **Clear Cache**

### Issue: Dashboard Loads Slowly

**Solutions**:
1. Enable query result caching (see Performance Optimization)
2. Add database indexes
3. Reduce number of charts or use simpler visualizations
4. Increase Superset worker count in docker-compose.yml

### Issue: Cannot Connect to Database

**Solutions**:
```bash
# Test PostgreSQL connection from Superset container
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml exec superset bash
psql -h host.docker.internal -p 5433 -U analytics -d analytics -c "SELECT COUNT(*) FROM staging_marts.dim_product;"
# Expected: 115
```

## Next Steps

### Immediate
1. ✅ Create "Product Catalog Overview" dashboard (follow steps above)
2. ✅ Add supplier filter for interactive exploration
3. ✅ Share dashboard URL with stakeholders

### Short-Term
4. Create "Data Quality Monitoring" dashboard
5. Schedule daily email reports
6. Add user accounts for team members

### Future
7. Deploy Phase 2 tables (ProductCategory, ProductPricing, etc.)
8. Create cross-table dashboards (Products + Categories + Pricing)
9. Add semantic search dashboard using embeddings
10. Create predictive analytics dashboards (forecasting, recommendations)

## Resources

**Documentation**:
- Data Profiling: `docs/FRESH_DATA_PROFILING_REPORT.md`
- BI Sync Guide: `docs/product_sync_to_bi.md`
- Superset Setup: `docs/SUPERSET_READY.md`
- SQL Query Library: `sql/analytics/product_dashboard_queries.sql`

**SQL Reference Queries**:
The `sql/analytics/product_dashboard_queries.sql` file contains 40+ production-ready queries organized by category:
- Product Catalog Overview (3 queries)
- Data Quality Metrics (3 queries)
- Multilingual Analytics (2 queries)
- Semantic Search (3 queries)
- Supplier Analytics (2 queries)
- Time-Series Analytics (3 queries)
- Physical Properties (2 queries)
- Source System Tracking (2 queries)
- Advanced Analytics (2 queries)
- Monitoring & Alerts (2 queries)

**Access Points**:
- Superset: http://localhost:8088
- PostgreSQL: localhost:5433 (analytics/analytics)
- Prefect: http://localhost:4200
- MinIO Console: http://localhost:9001

---

**Created**: 2025-10-19
**Status**: Ready for Dashboard Creation
**Data Available**: 115 active products, 100% quality, 15 suppliers
**Next Action**: Follow steps above to create your first dashboard!
