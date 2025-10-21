# Database Structure Verification

## Question: Does PostgreSQL have all the product-related tables?

**Short answer:** The **dbt models exist** and reference these tables, but we need to **verify the actual database** to confirm they're populated with data.

---

## 📋 What We Know (from dbt models)

### ✅ dbt Models Exist:

1. **`stg_product_availability`** - Product stock by warehouse
   - Source: `bronze.product_availability_cdc`
   - Fields: `product_i_d`, `storage_i_d`, `amount`

2. **`stg_product_analogue`** - Alternative/substitute products
   - Source: `bronze.product_analogue_cdc`
   - Fields: `base_product_i_d`, `analogue_product_i_d`

3. **`stg_product_original_number`** - OEM part numbers
   - Source: `bronze.product_original_number_cdc`
   - Fields: `product_i_d`, `original_number_i_d`, `is_main_original_number`

4. **`stg_product`** - Main product table
   - Source: `bronze.product_cdc`
   - 54 columns including multilingual fields

### 📊 Expected Data Flow:

```
SQL Server (ConcordDb)
    ↓ Debezium CDC
Kafka Topics
    ↓ Kafka Consumer
Bronze Layer (PostgreSQL)
    ↓ dbt Models
Staging Layer (PostgreSQL)
    ↓ dbt Models
Marts Layer (dim_product)
```

---

## 🔍 How to Verify

### Option 1: Run Python Verification Script

```bash
# If database is running:
python3 /tmp/verify_complete_structure.py
```

**What it checks:**
- ✅ Which schemas exist (bronze, staging, staging_marts)
- ✅ Which tables exist in each schema
- ✅ Row counts for each table
- ✅ Sample data from availability, analogues, OEM numbers
- ✅ Whether dim_product has denormalized fields

---

### Option 2: Run SQL Verification Script

```bash
# Connect to database
psql -h localhost -p 5433 -U analytics -d analytics

# Run verification
\i /tmp/check_database_structure.sql
```

---

### Option 3: Manual SQL Checks

```sql
-- 1. Check if tables exist
SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables
WHERE schemaname IN ('bronze', 'staging', 'staging_marts')
  AND tablename LIKE '%product%'
ORDER BY schemaname, tablename;

-- 2. Check row counts
SELECT
    (SELECT COUNT(*) FROM staging.stg_product) as products,
    (SELECT COUNT(*) FROM staging.stg_product_availability) as availability_rows,
    (SELECT COUNT(*) FROM staging.stg_product_analogue) as analogue_rows,
    (SELECT COUNT(*) FROM staging.stg_product_original_number) as oem_rows;

-- 3. Check if dim_product has denormalized fields
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'staging_marts'
  AND table_name = 'dim_product'
  AND column_name IN ('total_available_amount', 'storage_count',
                      'original_number_ids', 'analogue_product_ids')
ORDER BY column_name;

-- 4. Sample availability data
SELECT
    product_i_d,
    storage_i_d,
    amount
FROM staging.stg_product_availability
LIMIT 10;

-- 5. Sample analogue data
SELECT
    base_product_i_d,
    analogue_product_i_d
FROM staging.stg_product_analogue
LIMIT 10;

-- 6. Sample OEM numbers
SELECT
    product_i_d,
    original_number_i_d,
    is_main_original_number
FROM staging.stg_product_original_number
LIMIT 10;
```

---

## 🎯 Expected Results

### ✅ If Everything is Working:

```
STAGING LAYER:
✅ stg_product                      278,697 rows
✅ stg_product_availability         150,000+ rows  (stock records)
✅ stg_product_analogue              45,000+ rows  (alternative products)
✅ stg_product_original_number       89,000+ rows  (OEM part numbers)

MARTS LAYER:
✅ dim_product                      278,697 rows
   - Has total_available_amount     ✅
   - Has storage_count              ✅
   - Has original_number_ids        ✅
   - Has analogue_product_ids       ✅
```

---

## ⚠️ Potential Issues

### Issue 1: Bronze CDC Tables Missing

**Symptom:** `bronze.product_availability_cdc` doesn't exist

**Cause:** CDC pipeline not set up or Kafka not running

**Solution:**
```bash
# Start Kafka + Debezium
cd /home/user/bi-cord/infra
docker-compose -f docker-compose.dev.yml up -d kafka zookeeper debezium-connect

# Check Debezium connectors
curl http://localhost:8083/connectors
```

---

### Issue 2: Staging Tables Missing

**Symptom:** `staging.stg_product_availability` doesn't exist

**Cause:** dbt models not run yet

**Solution:**
```bash
cd /home/user/bi-cord/dbt
dbt run --models staging.stg_product_availability
dbt run --models staging.stg_product_analogue
dbt run --models staging.stg_product_original_number
```

---

### Issue 3: dim_product Missing Denormalized Fields

**Symptom:** `dim_product` exists but doesn't have `total_available_amount`, etc.

**Cause:** Old version of dim_product (before our updates)

**Solution:**
```bash
# Rebuild with denormalized fields
cd /home/user/bi-cord/dbt
dbt run --models dim_product

# OR run SQL script directly
psql -h localhost -p 5433 -U analytics -d analytics \
  -f /home/user/bi-cord/sql/rebuild_dim_product.sql
```

---

## 🚀 Next Steps Based on Verification

### Scenario A: ✅ All Tables Exist with Data

**You're ready to:**
1. Implement Learning-to-Rank
2. Use denormalized fields in search
3. Start collecting interaction data

**Action:** Proceed with ML implementation!

---

### Scenario B: ⚠️ Tables Exist but Empty

**Cause:** CDC pipeline not running or not synced yet

**Action:**
1. Check Kafka/Debezium status
2. Verify source database connection
3. Check CDC connector configuration

---

### Scenario C: ❌ Tables Don't Exist

**Cause:** dbt models not built yet

**Action:**
```bash
# Build all staging models
cd /home/user/bi-cord/dbt
dbt run --models staging

# Build marts
dbt run --models marts
```

---

## 📁 Files Created for Verification

1. **`/tmp/check_database_structure.sql`** - SQL verification script
2. **`/tmp/verify_complete_structure.py`** - Python verification script
3. **`VERIFY_DATABASE_STRUCTURE.md`** - This documentation

---

## ❓ Quick FAQ

**Q: Do we have ProductAvailability data?**
A: YES - if `staging.stg_product_availability` exists and has rows

**Q: Do we have Analogue data?**
A: YES - if `staging.stg_product_analogue` exists and has rows

**Q: Do we have OEM numbers (OriginalNumber)?**
A: YES - if `staging.stg_product_original_number` exists and has rows

**Q: Can we build dim_product with denormalized fields?**
A: YES - if the above 3 tables exist with data

**Q: What if tables are missing?**
A: Run `dbt run --models staging` to build them from bronze CDC data

**Q: What if bronze CDC tables are empty?**
A: Check Debezium/Kafka CDC pipeline - it needs to sync from SQL Server first

---

## 🎯 Bottom Line

**The structure SHOULD exist based on:**
- ✅ dbt models are defined
- ✅ Schema files reference the sources
- ✅ CDC topics are configured

**But we MUST verify:**
1. Are tables actually created in PostgreSQL?
2. Do tables have data?
3. Is CDC pipeline running and syncing?

**Run the verification scripts above to confirm!**
