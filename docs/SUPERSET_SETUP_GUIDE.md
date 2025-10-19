# Apache Superset Setup Guide

**Date**: 2025-10-18
**Purpose**: Set up Superset BI dashboard for Product analytics
**Status**: Ready for deployment

## Overview

This guide will help you deploy Apache Superset for visualizing Product data from the analytics database. Superset provides interactive dashboards, SQL IDE, and data exploration capabilities.

## Prerequisites

- Docker and Docker Compose installed
- PostgreSQL analytics database running (localhost:5433)
- Product data loaded (115 products in staging_staging.stg_product)
- Embeddings generated (analytics_features.product_embeddings)

## Quick Start

### Step 1: Start Superset

```bash
cd ~/Projects/bi-platform

# Start Superset container
docker compose -f infra/docker-compose.superset.yml up -d

# Wait for Superset to initialize (~2 minutes)
docker compose -f infra/docker-compose.superset.yml logs -f
# Watch for "Booting worker" messages
```

### Step 2: Access Superset UI

Open browser and navigate to:
```
http://localhost:8088
```

**Default credentials**:
- Username: `admin`
- Password: `admin`

**⚠️ IMPORTANT**: Change the default password immediately after first login!

### Step 3: Connect to Analytics Database

1. Click **Settings** → **Database Connections** → **+ Database**

2. Select **PostgreSQL** as database type

3. Enter connection details:
   ```
   Host: host.docker.internal
   Port: 5433
   Database: analytics
   Username: analytics
   Password: analytics
   Display Name: BI Platform Analytics
   ```

4. Click **Test Connection** (should succeed)

5. Click **Connect**

### Step 4: Import Product Analytics Queries

The ready-made SQL queries are located in:
```
~/Projects/bi-platform/sql/analytics/product_dashboard_queries.sql
```

**Import via SQL Lab**:
1. Navigate to **SQL** → **SQL Lab**
2. Select database: **BI Platform Analytics**
3. Select schema: **staging_staging**
4. Copy queries from `product_dashboard_queries.sql`
5. Execute and save as **Saved Queries**

## Dashboard Creation

### Dashboard 1: Product Catalog Overview

**Charts to Create**:

1. **Total Products KPI**
```sql
SELECT COUNT(*) as total_products
FROM staging_staging.stg_product
WHERE deleted = false;
```
- **Chart Type**: Big Number
- **Metric**: COUNT(*)
- **Title**: Total Products

2. **Products by Supplier**
```sql
SELECT
    COALESCE(LEFT(vendor_code, 4), 'Unknown') as supplier,
    COUNT(*) as count
FROM staging_staging.stg_product
WHERE deleted = false
GROUP BY LEFT(vendor_code, 4)
ORDER BY count DESC;
```
- **Chart Type**: Pie Chart
- **Dimension**: supplier
- **Metric**: COUNT(*)
- **Title**: Product Distribution by Supplier

3. **Multilingual Coverage**
```sql
SELECT
    'Names' as category,
    COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END) as polish,
    COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END) as ukrainian
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Descriptions',
    COUNT(CASE WHEN description_pl IS NOT NULL THEN 1 END),
    COUNT(CASE WHEN description_ua IS NOT NULL THEN 1 END)
FROM staging_staging.stg_product WHERE deleted = false;
```
- **Chart Type**: Bar Chart (Grouped)
- **Dimension**: category
- **Metrics**: polish, ukrainian
- **Title**: Multilingual Coverage

4. **Business Flags Summary**
```sql
SELECT
    'For Web' as flag,
    SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) as enabled,
    COUNT(*) - SUM(CASE WHEN is_for_web = true THEN 1 ELSE 0 END) as disabled
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Has Analogue',
    SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END),
    COUNT(*) - SUM(CASE WHEN has_analogue = true THEN 1 ELSE 0 END)
FROM staging_staging.stg_product WHERE deleted = false;
```
- **Chart Type**: Bar Chart (Stacked)
- **Dimension**: flag
- **Metrics**: enabled, disabled
- **Title**: Business Flags Distribution

### Dashboard 2: Data Quality Monitoring

**Charts to Create**:

1. **Field Completeness**
```sql
SELECT
    'Vendor Code' as field,
    ROUND(100.0 * COUNT(CASE WHEN vendor_code IS NOT NULL THEN 1 END) / COUNT(*), 2) as completeness
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Polish Name',
    ROUND(100.0 * COUNT(CASE WHEN name_pl IS NOT NULL THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Ukrainian Name',
    ROUND(100.0 * COUNT(CASE WHEN name_ua IS NOT NULL THEN 1 END) / COUNT(*), 2)
FROM staging_staging.stg_product WHERE deleted = false;
```
- **Chart Type**: Bar Chart (Horizontal)
- **Dimension**: field
- **Metric**: completeness
- **Title**: Field Completeness %

2. **Data Quality Issues**
```sql
SELECT
    'Not for sale' as issue,
    SUM(CASE WHEN is_for_sale = false THEN 1 ELSE 0 END) as count
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'No image',
    SUM(CASE WHEN has_image = false THEN 1 ELSE 0 END)
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Missing weight',
    SUM(CASE WHEN weight IS NULL OR weight = 0 THEN 1 ELSE 0 END)
FROM staging_staging.stg_product WHERE deleted = false;
```
- **Chart Type**: Table
- **Columns**: issue, count
- **Title**: Data Quality Issues

3. **Recent Product Updates**
```sql
SELECT
    DATE(updated) as date,
    COUNT(*) as updates
FROM staging_staging.stg_product
WHERE deleted = false
  AND updated > created
GROUP BY DATE(updated)
ORDER BY date DESC
LIMIT 30;
```
- **Chart Type**: Time Series Line Chart
- **Time Column**: date
- **Metric**: COUNT(*)
- **Title**: Product Updates (Last 30 Days)

### Dashboard 3: Semantic Search Analytics

**Charts to Create**:

1. **Embedding Coverage**
```sql
SELECT
    COUNT(*) as total_embeddings,
    vector_dims((SELECT embedding FROM analytics_features.product_embeddings LIMIT 1)) as dimensions
FROM analytics_features.product_embeddings;
```
- **Chart Type**: Big Number with Trend
- **Metric**: total_embeddings
- **Subheader**: dimensions
- **Title**: Semantic Embeddings

2. **Product Similarity Matrix** (Top 20 Products)
```sql
-- Sample similarity for visualization
SELECT
    p1.vendor_code as product_1,
    p2.vendor_code as product_2,
    ROUND((1 - (e1.embedding <=> e2.embedding))::numeric, 3) as similarity
FROM analytics_features.product_embeddings e1
JOIN analytics_features.product_embeddings e2 ON e1.product_id < e2.product_id
JOIN staging_staging.stg_product p1 ON p1.product_id = e1.product_id
JOIN staging_staging.stg_product p2 ON p2.product_id = e2.product_id
WHERE p1.deleted = false AND p2.deleted = false
LIMIT 100;
```
- **Chart Type**: Heatmap
- **X-axis**: product_1
- **Y-axis**: product_2
- **Metric**: similarity
- **Title**: Product Similarity Heatmap

## Advanced Features

### Custom SQL Queries

Use the provided queries from `sql/analytics/product_dashboard_queries.sql`:
- 10 categories
- 40+ production-ready queries
- All parameterized and optimized

### Filters and Parameters

Add dashboard filters:
1. **Supplier Filter**: Filter by vendor code prefix
2. **Date Range**: Filter by created/updated dates
3. **Language**: Switch between Polish/Ukrainian

### Scheduled Reports

Configure email reports:
1. Navigate to **Settings** → **Alerts & Reports**
2. Create new report
3. Select dashboard
4. Set schedule (daily, weekly, monthly)
5. Add recipients

### Row-Level Security (Optional)

If you need to restrict data access:
1. Navigate to **Security** → **Row Level Security**
2. Create filters based on user roles
3. Apply to specific tables/datasets

## Troubleshooting

### Issue 1: Cannot Connect to Database

**Symptom**: "Connection failed" error when testing database

**Solution**:
```bash
# Check if PostgreSQL is accessible from Docker
docker compose -f infra/docker-compose.superset.yml exec superset bash
psql -h host.docker.internal -p 5433 -U analytics -d analytics -c "SELECT 1;"
```

If connection fails:
- Verify PostgreSQL is running on host
- Check firewall allows Docker connections
- Try using host IP instead of `host.docker.internal`

### Issue 2: Superset Won't Start

**Symptom**: Container exits immediately

**Solution**:
```bash
# Check logs
docker compose -f infra/docker-compose.superset.yml logs superset

# Common issues:
# - Port 8088 already in use
# - Insufficient memory
# - Database initialization failed

# Restart with fresh state
docker compose -f infra/docker-compose.superset.yml down -v
docker compose -f infra/docker-compose.superset.yml up -d
```

### Issue 3: Slow Query Performance

**Symptom**: Dashboard loads very slowly

**Solution**:
```sql
-- Add indexes for frequently queried columns
CREATE INDEX IF NOT EXISTS idx_product_vendor_code
ON staging_staging.stg_product(vendor_code);

CREATE INDEX IF NOT EXISTS idx_product_created
ON staging_staging.stg_product(created);

CREATE INDEX IF NOT EXISTS idx_product_updated
ON staging_staging.stg_product(updated);
```

### Issue 4: Charts Not Displaying

**Symptom**: "No data" or blank charts

**Solution**:
1. Check SQL query returns results in SQL Lab
2. Verify correct database and schema selected
3. Check for NULL values in dimension columns
4. Review Superset logs for errors

## Security Best Practices

### Production Deployment

**Change Default Credentials**:
```python
# After first login, change admin password in UI
# Or via CLI:
docker compose -f infra/docker-compose.superset.yml exec superset \
  superset fab reset-password \
  --username admin \
  --password <new-secure-password>
```

**Set Secure Secret Key**:
Edit `docker-compose.superset.yml`:
```yaml
SUPERSET_SECRET_KEY: '<generate-strong-random-key>'
```

Generate secure key:
```bash
openssl rand -base64 42
```

**Enable HTTPS**:
Use reverse proxy (nginx, Caddy) for SSL/TLS termination.

**Database Password**:
Use secrets management (Docker secrets, env files):
```bash
# Create .env file
echo "ANALYTICS_PASSWORD=<secure-password>" > .env

# Reference in docker-compose.yml
DATABASE_PASSWORD: ${ANALYTICS_PASSWORD}
```

## Performance Tuning

### Cache Configuration

Enable result caching for faster dashboard loads:

1. Navigate to **Settings** → **Database Connections**
2. Edit analytics database
3. Enable **Cache Timeout**: 300 seconds (5 minutes)
4. Enable **Query Result Cache**

### Resource Limits

For production, adjust worker count:
```yaml
command: >
  sh -c "
    gunicorn \
      --bind 0.0.0.0:8088 \
      --workers 8 \          # Increase for more concurrent users
      --timeout 120 \
      --limit-request-line 0 \
      --limit-request-field_size 0 \
      'superset.app:create_app()'
  "
```

## Maintenance

### Backup Superset Metadata

```bash
# Backup Superset configuration and dashboards
docker compose -f infra/docker-compose.superset.yml exec superset \
  superset export-dashboards -f /app/dashboards/backup.zip

# Copy to host
docker cp superset:/app/dashboards/backup.zip ./backups/
```

### Update Superset

```bash
# Pull latest image
docker compose -f infra/docker-compose.superset.yml pull

# Restart with new image
docker compose -f infra/docker-compose.superset.yml up -d

# Run database migrations
docker compose -f infra/docker-compose.superset.yml exec superset \
  superset db upgrade
```

## Next Steps

### After Setup

1. **Create Dashboards**:
   - Product Catalog Overview
   - Data Quality Monitoring
   - Semantic Search Analytics

2. **Configure Alerts**:
   - Data freshness alerts
   - Quality threshold alerts
   - New product notifications

3. **Share with Team**:
   - Create user accounts
   - Assign roles (Admin, Alpha, Gamma)
   - Share dashboard links

### Future Enhancements

4. **Add More Datasets** (Phase 2):
   - ProductCategory (when deployed)
   - ProductPricing (when deployed)
   - ProductAvailability (when deployed)

5. **Advanced Analytics**:
   - Recommendation engine metrics
   - Semantic search quality tracking
   - Product performance analytics

6. **Integration**:
   - Embed dashboards in applications
   - API access for programmatic queries
   - Webhook alerts to Slack/Teams

## Resources

**Superset Documentation**: https://superset.apache.org/docs/intro
**SQL Queries**: `~/Projects/bi-platform/sql/analytics/product_dashboard_queries.sql`
**Data Analysis Report**: `docs/PRODUCT_DATA_ANALYSIS_REPORT.md`

## Support

**Access Superset UI**: http://localhost:8088
**View Logs**: `docker compose -f infra/docker-compose.superset.yml logs -f`
**Restart Service**: `docker compose -f infra/docker-compose.superset.yml restart`
**Stop Service**: `docker compose -f infra/docker-compose.superset.yml down`

---

**Created**: 2025-10-18
**Status**: Ready for Deployment
**Default Admin**: admin / admin (⚠️ Change immediately!)
**Database**: PostgreSQL at host.docker.internal:5433
