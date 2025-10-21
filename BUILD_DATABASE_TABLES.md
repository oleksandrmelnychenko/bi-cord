# Build Database Tables - Action Plan

## Current Status ✅

Your codebase has ALL required tables properly defined:

1. ✅ **stg_product_availability** - Product stock by warehouse
2. ✅ **stg_product_analogue** - Alternative products
3. ✅ **stg_product_original_number** - OEM part numbers
4. ✅ **dim_product_search** - Denormalized search table

## Problem: Tables Not Built Yet ⚠️

The dbt models exist as code but haven't been materialized in PostgreSQL database.

**Evidence:** No `dbt/target/manifest.json` file exists (created after first dbt run)

---

## Solution: Build Tables in 3 Steps

### Step 1: Start Database & Services

```bash
cd /home/user/bi-cord/infra

# Start PostgreSQL + Kafka ecosystem
docker-compose -f docker-compose.dev.yml up -d

# Verify services are running
docker ps

# You should see:
# - postgres (port 5433)
# - kafka (port 9092)
# - zookeeper (port 2181)
# - kafka-connect (port 8083)
```

**Wait 30 seconds** for services to fully start.

---

### Step 2: Verify Bronze CDC Tables Exist

The staging models depend on bronze CDC tables. Check if Debezium has created them:

```bash
# Option A: Using psql (if installed)
psql -h localhost -p 5433 -U analytics -d analytics -c "\dt bronze.*cdc"

# Option B: Using Python verification script
python3 /tmp/verify_complete_structure.py

# Expected bronze tables:
# bronze.product_availability_cdc
# bronze.product_analogue_cdc
# bronze.product_original_number_cdc
# bronze.product_cdc
```

**If bronze tables are missing:**
- Debezium CDC connectors need to be configured
- Check Kafka Connect: `curl http://localhost:8083/connectors`
- See `SETUP_CDC.md` for Debezium setup

**If bronze tables exist but are empty:**
- CDC sync from SQL Server hasn't started yet
- Check connector status
- May need to configure source SQL Server connection

---

### Step 3: Build dbt Models

Once bronze tables have data, build the staging and marts:

```bash
cd /home/user/bi-cord/dbt

# Install dbt if needed
pip3 install dbt-postgres==1.7.0

# Build staging models (creates views from bronze CDC tables)
dbt run --models staging.stg_product_availability
dbt run --models staging.stg_product_analogue
dbt run --models staging.stg_product_original_number
dbt run --models staging.stg_product

# Build marts (denormalized tables for search)
dbt run --models marts.dim_product_search

# OR build everything at once
dbt run --models staging marts
```

**Expected Output:**
```
Completed successfully

Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```

---

### Step 4: Verify Tables Were Built

```bash
# Check if staging views exist
psql -h localhost -p 5433 -U analytics -d analytics -c "
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname IN ('staging', 'staging_marts')
  AND tablename LIKE '%product%'
ORDER BY schemaname, tablename;
"

# Check row counts
psql -h localhost -p 5433 -U analytics -d analytics -c "
SELECT
    (SELECT COUNT(*) FROM staging.stg_product) as products,
    (SELECT COUNT(*) FROM staging.stg_product_availability) as availability_rows,
    (SELECT COUNT(*) FROM staging.stg_product_analogue) as analogue_rows,
    (SELECT COUNT(*) FROM staging.stg_product_original_number) as oem_rows,
    (SELECT COUNT(*) FROM staging_marts.dim_product_search) as search_table_rows;
"
```

**Expected Results:**
```
 products | availability_rows | analogue_rows | oem_rows | search_table_rows
----------+-------------------+---------------+----------+-------------------
   278697 |            150000 |         45000 |    89000 |            278697
```

---

## Quick Start Script

Save this as `build_all.sh`:

```bash
#!/bin/bash
set -e

echo "======================================"
echo "Building BI-Cord Database Tables"
echo "======================================"

# Start services
echo "[1/4] Starting Docker services..."
cd /home/user/bi-cord/infra
docker-compose -f docker-compose.dev.yml up -d
sleep 30

# Check database
echo "[2/4] Checking database connection..."
psql -h localhost -p 5433 -U analytics -d analytics -c "SELECT version();" || {
    echo "❌ Database not accessible!"
    exit 1
}

# Run dbt
echo "[3/4] Building dbt models..."
cd /home/user/bi-cord/dbt
dbt run --models staging marts

# Verify
echo "[4/4] Verifying tables..."
python3 /tmp/verify_complete_structure.py

echo ""
echo "✅ BUILD COMPLETE!"
echo ""
echo "Next: Start search API with denormalized tables"
echo "  cd /home/user/bi-cord/src/api"
echo "  uvicorn search_api:app --reload --host 0.0.0.0 --port 8000"
```

---

## Troubleshooting

### Issue: "relation bronze.product_availability_cdc does not exist"

**Cause:** CDC tables not created yet

**Solution:**
1. Check Debezium: `curl http://localhost:8083/connectors`
2. Configure source SQL Server connector
3. Wait for initial snapshot sync

---

### Issue: "Staging tables exist but are empty"

**Cause:** Bronze CDC tables are empty (no data synced from source)

**Solution:**
1. Verify source SQL Server is accessible
2. Check Debezium connector status
3. Look at Kafka topics: `kafka-console-consumer --bootstrap-server localhost:9092 --topic dbserver1.ConcordDb.dbo.ProductAvailability --from-beginning --max-messages 5`

---

### Issue: "dbt run fails with materialization error"

**Cause:** PostgreSQL permissions or pgvector extension missing

**Solution:**
```sql
-- Connect to database
psql -h localhost -p 5433 -U analytics -d analytics

-- Create schemas if missing
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS staging_marts;

-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Grant permissions
GRANT ALL ON SCHEMA bronze TO analytics;
GRANT ALL ON SCHEMA staging TO analytics;
GRANT ALL ON SCHEMA staging_marts TO analytics;
```

---

## What Happens After Tables Are Built?

Once tables are built with data, you can:

### 1. **Test Enhanced Search**
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "brake pads",
    "limit": 10
  }'

# Response will include denormalized fields:
# - total_available_amount (from ProductAvailability)
# - storage_count (number of warehouses with stock)
# - original_number_ids (OEM part numbers array)
# - analogue_product_ids (alternative products array)
# - availability_score (ML ranking signal)
# - freshness_score (ML ranking signal)
```

### 2. **Start Learning-to-Rank Implementation**

With denormalized tables ready, you can proceed with ML roadmap:

- ✅ Phase 1: Event tracking (impressions, clicks, conversions)
- ✅ Phase 2: Feature engineering (40-50 features per query-product pair)
- ✅ Phase 3: Training data preparation
- ✅ Phase 4: LightGBM LambdaMART model training
- ✅ Phase 5: Deploy re-ranker in search API

### 3. **Query Performance Benefits**

**Before (Legacy C# with runtime JOINs):**
```sql
-- 5 JOINs at query time
SELECT p.*, pa.Amount, pon.OriginalNumber, ...
FROM Product p
LEFT JOIN ProductAvailability pa ON ...
LEFT JOIN ProductOriginalNumber pon ON ...
LEFT JOIN ProductAnalogue pan ON ...
-- 500ms+ query time
```

**After (Denormalized dim_product_search):**
```sql
-- Zero JOINs, all pre-computed
SELECT
    product_id,
    total_available_amount,  -- pre-aggregated
    original_number_ids,     -- pre-aggregated array
    analogue_product_ids     -- pre-aggregated array
FROM staging_marts.dim_product_search
WHERE ...
-- <50ms query time
```

---

## Summary

**Your Question:** "Does postgres has all the product related tables? With analogue and storages"

**Answer:**

✅ **YES** - All tables are properly defined in dbt models
⚠️ **BUT** - They need to be built using the steps above

**Next Action:** Run the 3-step build process to materialize the tables in PostgreSQL.

Once built, you'll have:
- All product data denormalized
- All relationships pre-joined (availability, analogues, OEM)
- Ready for world-class AI/ML search implementation
- 10x faster queries (no runtime JOINs)

---

**Ready to build?** Start with Step 1 above! 🚀
