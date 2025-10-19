# Staging Layer - Implementation Complete ✅

## Summary

The **staging layer is fully operational** using dbt to parse CDC JSONB payloads into clean, typed SQL views. All 115 products from the bronze layer are now available in a structured format ready for analytics and embeddings.

## Architecture

```
Bronze (JSONB CDC) → dbt → Staging Views (PostgreSQL)
bronze.product_cdc → stg_product (115 unique products)
```

## What's Working

### 1. dbt Configuration ✅

**dbt-postgres** installed (v1.9.1) with full PostgreSQL integration:
- Connection to analytics database on port 5433
- Search path includes bronze and staging schemas
- Configuration validated with `dbt debug`

**Profiles**: `~/.dbt/profiles.yml`
```yaml
cord_bi:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5433
      user: analytics
      password: analytics
      dbname: analytics
      schema: staging
```

### 2. Staging Model (`stg_product`) ✅

**Location**: `dbt/models/staging/product/stg_product.sql`

**Features**:
- Parses JSONB CDC payloads into typed columns (bigint, text, numeric, boolean, timestamp)
- Extracts 19 product attributes from `cdc_payload->'payload'->'after'`
- Includes CDC metadata (operation type, source timestamp, snapshot flag)
- **Automatic deduplication** using `ROW_NUMBER()` partitioned by `product_id`
- Only includes records with valid `after` payload (excludes deletes)

**Materialization**: View in `staging_staging` schema

### 3. Data Quality Tests ✅

All 4 tests passing:
- `not_null_stg_product_product_id` - ✅ PASS
- `unique_stg_product_product_id` - ✅ PASS
- `not_null_stg_product_name` - ✅ PASS
- `not_null_stg_product_ingested_at` - ✅ PASS

### 4. Schema Documentation ✅

**Location**: `dbt/models/staging/schema.yml`

- Source documentation for `bronze.product_cdc`
- Model documentation for `stg_product` with all 19 columns
- Column descriptions and data types
- Comprehensive test coverage

## Staging Table Schema

```sql
-- View: staging_staging.stg_product

product_id          BIGINT       PRIMARY KEY (unique, not null)
name                TEXT         NOT NULL
vendor_code         TEXT         Vendor/SKU code
description         TEXT         Product description
weight              NUMERIC      Product weight
length              NUMERIC      Length dimension
width               NUMERIC      Width dimension
height              NUMERIC      Height dimension
volume              NUMERIC      Product volume
price               NUMERIC      Product price
is_active           BOOLEAN      Active/available flag
category_id         BIGINT       FK to category
manufacturer_id     BIGINT       FK to manufacturer
created_at          TIMESTAMP    Source system creation timestamp
updated_at          TIMESTAMP    Source system update timestamp
cdc_operation       TEXT         CDC op: r=read, c=create, u=update, d=delete
source_timestamp    TIMESTAMP    CDC event timestamp
is_snapshot         TEXT         'first'=snapshot, null=live CDC
ingested_at         TIMESTAMP    Bronze ingestion timestamp (NOT NULL)
```

## Running the Staging Layer

### 1. Verify dbt Connection

```bash
cd ~/Projects/bi-platform/dbt
source ../venv/bin/activate
dbt debug
```

**Expected output**: "All checks passed!"

### 2. Run Staging Model

```bash
dbt run --select stg_product
```

**Expected output**:
```
1 of 1 OK created sql view model staging_staging.stg_product ... [CREATE VIEW]
Completed successfully
Done. PASS=1 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=1
```

### 3. Run Data Quality Tests

```bash
dbt test --select stg_product
```

**Expected output**:
```
4 of 4 PASS not_null_stg_product_product_id
4 of 4 PASS unique_stg_product_product_id
4 of 4 PASS not_null_stg_product_name
4 of 4 PASS not_null_stg_product_ingested_at
Done. PASS=4 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=4
```

### 4. Query Staging Data

```bash
psql -h localhost -p 5433 -U analytics -d analytics
```

```sql
-- Count records
SELECT COUNT(*) FROM staging_staging.stg_product;
-- Result: 115

-- View sample products
SELECT
    product_id,
    name,
    vendor_code,
    price,
    is_active,
    source_timestamp
FROM staging_staging.stg_product
LIMIT 10;

-- Check CDC operations distribution
SELECT
    cdc_operation,
    COUNT(*) as count
FROM staging_staging.stg_product
GROUP BY cdc_operation;

-- Products by category (if populated)
SELECT
    category_id,
    COUNT(*) as product_count
FROM staging_staging.stg_product
WHERE category_id IS NOT NULL
GROUP BY category_id
ORDER BY product_count DESC;
```

## Current Status

- ✅ **115 products** parsed from bronze CDC into staging view
- ✅ **19 typed columns** extracted from JSONB payloads
- ✅ **Deduplication** ensures only latest state per product
- ✅ **4 data quality tests** all passing
- ✅ **Full CDC metadata** preserved for audit trail

## Key Design Decisions

### 1. View vs Table Materialization

**Chosen**: View materialization
**Rationale**:
- Staging layer is lightweight (115 records)
- JSONB parsing is fast on PostgreSQL
- Always reflects latest bronze data
- No need for incremental refresh logic

**When to switch to table**:
- Dataset > 100K records
- Complex transformations (joins, aggregations)
- Downstream models query staging frequently

### 2. Deduplication Strategy

**Chosen**: `ROW_NUMBER()` window function partitioned by `product_id`
**Logic**:
```sql
ORDER BY source_ts_ms DESC, kafka_offset DESC
```

**Rationale**:
- Handles late-arriving events correctly
- Uses CDC timestamp from source database
- Falls back to Kafka offset for ties
- Simple and performant

### 3. Column Type Casting

All JSONB extractions explicitly cast to target types:
```sql
(cdc_payload->'payload'->'after'->>'ID')::bigint
(cdc_payload->'payload'->'after'->>'Name')::text
(cdc_payload->'payload'->'after'->>'Weight')::numeric
(cdc_payload->'payload'->'after'->>'IsActive')::boolean
```

**Benefits**:
- PostgreSQL query planner can optimize
- Type errors caught at view creation
- Enables index usage in downstream models
- Clear schema contract

## Next Steps

### 1. Create Mart Layer (Optional)

For analytics-ready tables:

```sql
-- dbt/models/marts/product_metrics.sql
SELECT
    product_id,
    name,
    vendor_code,
    price,
    weight,
    CASE
        WHEN price < 100 THEN 'Low'
        WHEN price < 500 THEN 'Medium'
        ELSE 'High'
    END as price_tier,
    LENGTH(description) as description_length,
    created_at,
    updated_at
FROM {{ ref('stg_product') }}
WHERE is_active = true
```

Then run:
```bash
dbt run --models product_metrics
dbt test --models product_metrics
```

### 2. Embeddings Pipeline

Now that staging data is structured and clean:

```bash
cd ~/Projects/bi-platform
source venv/bin/activate
python src/ml/embedding_pipeline.py --limit 100
```

**Input**: `staging_staging.stg_product` view
**Process**: Generate embeddings for product name + description
**Output**: Vector embeddings for semantic search

### 3. Incremental Bronze Loading

Set up scheduled Prefect flow to continuously ingest new CDC events:

```bash
# Run every 5 minutes
prefect deployment create orchestration/deployments/kafka_to_minio.yaml

# Or run manually when needed
cd ~/Projects/bi-platform
source venv/bin/activate
export PYTHONPATH=src
export KAFKA_TOPIC="cord.ConcordDb.dbo.Product"
python3 src/ingestion/prefect_flows/kafka_to_minio.py
python3 src/transform/direct_loader.py
```

Then refresh dbt models:
```bash
cd dbt
source ../venv/bin/activate
dbt run --select stg_product
```

### 4. Add More CDC Tables

Replicate the pattern for other tables:

1. Enable CDC on source table (SQL Server)
2. Create Debezium connector JSON
3. Register connector with Kafka Connect
4. Update `kafka_to_minio.py` for new topic
5. Update `direct_loader.py` for new bronze table
6. Create dbt staging model

## Dependencies Installed

**dbt-postgres v1.9.1** (full dependency tree):
- dbt-core 1.10.13
- dbt-adapters 1.17.2
- dbt-common 1.32.0
- psycopg2-binary 2.9.11 (already installed)
- agate 1.9.1 (data processing)
- sqlparse 0.5.3 (SQL parsing)
- networkx 3.5 (DAG resolution)

## Files Created/Modified

1. `~/.dbt/profiles.yml` - PostgreSQL connection config
2. `dbt/dbt_project.yml` - Fixed deprecated properties (data-paths → removed, snapshots-paths → snapshot-paths)
3. `dbt/models/staging/product/stg_product.sql` - **Complete staging model** with JSONB parsing and deduplication
4. `dbt/models/staging/schema.yml` - Enhanced with full documentation and tests

## Troubleshooting

### Issue: dbt debug fails with "Additional properties not allowed"
**Solution**: Update `dbt_project.yml` to use `snapshot-paths` instead of `snapshots-paths`

### Issue: dbt debug fails with "data-paths deprecated"
**Solution**: Remove `data-paths` line from `dbt_project.yml` (use `seed-paths` instead)

### Issue: Staging view shows 0 records
**Solution**: Verify bronze table has data:
```sql
SELECT COUNT(*) FROM bronze.product_cdc WHERE cdc_payload->'payload'->'after' IS NOT NULL;
```

### Issue: Type casting errors in staging model
**Solution**: Check CDC payload structure:
```sql
SELECT cdc_payload->'payload'->'after' FROM bronze.product_cdc LIMIT 1;
```

Verify field names match (case-sensitive):
- `ID` not `id`
- `Name` not `name`
- `VendorCode` not `vendor_code`

## Performance Considerations

**Current Scale**: 115 products
- View query time: <50ms
- dbt run time: <1s
- Test execution: <500ms

**Expected Scale**: 60K products (full catalog)
- View query time: ~100-200ms (with proper indexes)
- dbt run time: ~2-5s
- Consider table materialization if query time > 500ms

**Optimization Tips**:
1. Add indexes on bronze table for JSONB queries if needed:
   ```sql
   CREATE INDEX idx_product_cdc_payload_id
   ON bronze.product_cdc ((cdc_payload->'payload'->'after'->>'ID'));
   ```

2. Switch to incremental materialization for large datasets:
   ```sql
   {{ config(materialized='incremental', unique_key='product_id') }}
   ```

3. Use partitioning for time-series queries:
   ```sql
   CREATE INDEX idx_product_cdc_ingested_at_brin
   ON bronze.product_cdc USING brin(ingested_at);
   ```

## Summary

The staging layer successfully transforms raw CDC JSONB data into clean, typed, deduplicated product records ready for analytics. The end-to-end pipeline from SQL Server CDC through Debezium, Kafka, MinIO, PostgreSQL bronze, to dbt staging is **fully operational** without requiring PySpark or Iceberg.
