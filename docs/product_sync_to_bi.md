# Product Data Synchronization to BI

**Purpose**: Complete guide for refreshing Product data from source system to BI-ready mart layer

**Last Updated**: 2025-10-19

## Overview

This document describes the complete data pipeline for synchronizing Product data from SQL Server to the BI-optimized `dim_product` mart table, ready for consumption by Superset and other BI tools.

## Data Flow Architecture

```
SQL Server (ConcordDb.dbo.Product)
    ↓ [Debezium CDC Connector]
Kafka Topic (cord.ConcordDb.dbo.Product)
    ↓ [Prefect Flow: kafka_to_minio]
MinIO Object Storage (cord-raw/product/raw/batch=*.jsonl)
    ↓ [Python Script: bronze_loader.py or direct SQL]
PostgreSQL Bronze Layer (bronze.product_cdc)
    ↓ [dbt: stg_product]
PostgreSQL Staging Layer (staging_staging.stg_product)
    ↓ [dbt: dim_product]
PostgreSQL Marts Layer (marts.dim_product)
    ↓ [BI Tool Connection]
Superset Dashboards / BI Tools
```

## Data Layers Explained

### 1. Bronze Layer (`bronze.product_cdc`)
- **Purpose**: Raw CDC events from Kafka
- **Format**: JSONB payloads with Kafka metadata
- **Characteristics**:
  - Contains ALL change events (inserts, updates, deletes)
  - Includes CDC metadata (operation type, timestamp, snapshot flag)
  - Deduplication by (kafka_topic, kafka_partition, kafka_offset)

### 2. Staging Layer (`staging_staging.stg_product`)
- **Purpose**: Typed, parsed Product records
- **Format**: Strongly-typed columns extracted from JSONB
- **Characteristics**:
  - 54 columns with proper data types
  - Deduplication: Latest record per product_id
  - Includes deleted records (filtered downstream)
  - Preserves CDC metadata

### 3. Marts Layer (`marts.dim_product`)
- **Purpose**: BI-optimized, denormalized Product dimension
- **Format**: Materialized table with computed columns
- **Characteristics**:
  - Active products only (deleted = false)
  - ~30 most relevant columns for BI
  - Computed helper columns (supplier_name, weight_category, etc.)
  - Optimized for query performance

## Full Data Refresh Procedure

### Prerequisites
- SQL Server CDC connector running (10.67.24.18:1433 accessible)
- Kafka cluster healthy (localhost:9092)
- MinIO accessible (localhost:9000)
- PostgreSQL analytics database accessible (localhost:5433)
- Python venv-py311 activated with all dependencies
- dbt installed in venv-py311

### Step 1: Trigger CDC Snapshot (If Needed)
```bash
# Check Debezium connector status
curl -s http://localhost:8083/connectors/sqlserver-product-v2/status | jq

# If connector needs restart (to capture new records):
curl -X POST http://localhost:8083/connectors/sqlserver-product-v2/restart

# Monitor snapshot progress:
docker compose -f ~/Projects/bi-platform/infra/docker-compose.dev.yml logs -f kafka-connect | grep -i snapshot
```

**Expected Outcome**: Connector completes snapshot, publishes CDC events to Kafka

### Step 2: Ingest Kafka Events to MinIO
```bash
cd ~/Projects/bi-platform

# Activate Python environment
source ./venv-py311/bin/activate

# Run Kafka ingestion (fetches all messages from earliest offset)
export PYTHONPATH=src
export KAFKA_TOPIC="cord.ConcordDb.dbo.Product"
export KAFKA_CONSUMER_GROUP="prefect-fresh-load-$(date +%s)"

./venv-py311/bin/python -c "
import os
from src.ingestion.prefect_flows.kafka_to_minio import fetch_kafka_batch, write_to_minio

topic = os.getenv('KAFKA_TOPIC')
bucket = 'cord-raw'
prefix = 'product/raw'
total_records = 0
batch_num = 0

while True:
    records = fetch_kafka_batch(topic=topic, max_records=5000)
    if not records:
        print(f'No more records. Total: {total_records} records in {batch_num} batches')
        break

    result = write_to_minio(records=records, bucket=bucket, prefix=prefix)
    total_records += result['record_count']
    batch_num += 1
    print(f'Batch {batch_num}: {result[\"record_count\"]} records (Total: {total_records})')
"
```

**Expected Outcome**: All CDC events written to MinIO as JSONL batches

**Typical Results**:
- ~31,970 CDC events consumed
- ~278 batch files written to MinIO
- Duration: ~2-3 minutes

### Step 3: Load Bronze Layer from MinIO
```bash
# Option A: Using inline Python script
./venv-py311/bin/python -c "
import json
import boto3
import psycopg2
from datetime import datetime

# MinIO client
s3 = boto3.client('s3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin'
)

# PostgreSQL connection
conn = psycopg2.connect(
    host='localhost', port=5433,
    database='analytics', user='analytics', password='analytics'
)
cur = conn.cursor()

# Truncate bronze table
print('Truncating bronze.product_cdc...')
cur.execute('TRUNCATE TABLE bronze.product_cdc;')
conn.commit()

# Load from MinIO
print('Loading from MinIO...')
paginator = s3.get_paginator('list_objects_v2')
pages = paginator.paginate(Bucket='cord-raw', Prefix='product/raw/batch=')

total_inserted = 0
for page in pages:
    for obj in page.get('Contents', []):
        response = s3.get_object(Bucket='cord-raw', Key=obj['Key'])
        content = response['Body'].read().decode('utf-8')

        for line in content.strip().split('\n'):
            if not line.strip():
                continue
            record = json.loads(line)
            cur.execute('''
                INSERT INTO bronze.product_cdc (
                    kafka_topic, kafka_partition, kafka_offset, kafka_timestamp,
                    kafka_key, cdc_payload, batch_file
                ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (kafka_topic, kafka_partition, kafka_offset) DO NOTHING
            ''', (record.get('topic'), record.get('partition'),
                  record.get('offset'), record.get('timestamp'),
                  json.dumps(record.get('key')),
                  json.dumps(record.get('value')), obj['Key']))
            total_inserted += 1

conn.commit()
print(f'Inserted {total_inserted} records into bronze.product_cdc')
cur.close()
conn.close()
"
```

**Expected Outcome**: Bronze layer loaded with unique CDC events (typically 115 unique products after deduplication)

**Validation**:
```bash
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics \
  -c "SELECT COUNT(*) as bronze_records FROM bronze.product_cdc;"
```

### Step 4: Run dbt Transformations
```bash
cd ~/Projects/bi-platform

# Option 1: Build specific models
source ./venv-py311/bin/activate
dbt run --project-dir dbt --select stg_product dim_product

# Option 2: Build all models
dbt run --project-dir dbt
```

**Expected Outcome**:
- `staging_staging.stg_product` view refreshed
- `marts.dim_product` table created/refreshed
- Duration: ~5-10 seconds

**Validation**:
```bash
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -c "
SELECT 'Staging' as layer, COUNT(*)::text as records
FROM staging_staging.stg_product WHERE deleted = false
UNION ALL
SELECT 'Marts', COUNT(*)::text
FROM marts.dim_product;
"
```

**Expected Output**:
```
   layer   | records
-----------+---------
 Staging   | 115
 Marts     | 115
```

### Step 5: Run dbt Tests
```bash
cd ~/Projects/bi-platform
source ./venv-py311/bin/activate

# Test dim_product specifically
dbt test --project-dir dbt --select dim_product

# Test all models
dbt test --project-dir dbt
```

**Expected Outcome**: All tests pass (product_id unique/not_null, net_uid unique/not_null, etc.)

### Step 6: Refresh BI Tool
**Superset**: Dashboards automatically refresh on next view (if cache expired)

**Manual Refresh**:
1. Navigate to dashboard
2. Click **⋮** (three dots) menu
3. Select **Force Refresh**

**Or update cache settings**:
1. Go to **Settings** → **Database Connections**
2. Edit "BI Platform Analytics"
3. Adjust **Cache Timeout** (default: 300 seconds)

## Incremental Refresh (Future)

Currently, the process is full refresh (truncate and reload). For incremental updates:

**Bronze Layer**: Already supports incremental (CDC events append-only)

**Staging Layer**: Deduplication handles latest state per product_id

**Marts Layer**: Would need to change materialization strategy:
```sql
{{
  config(
    materialized='incremental',
    unique_key='product_id'
  )
}}
```

## Validation Queries

### Check Data Consistency Across Layers
```sql
-- Compare record counts
SELECT
    'Bronze CDC' as layer,
    COUNT(*) as total_records
FROM bronze.product_cdc

UNION ALL

SELECT
    'Staging (Active)',
    COUNT(*)
FROM staging_staging.stg_product
WHERE deleted = false

UNION ALL

SELECT
    'Staging (All)',
    COUNT(*)
FROM staging_staging.stg_product

UNION ALL

SELECT
    'Marts',
    COUNT(*)
FROM marts.dim_product;
```

### Check Supplier Distribution
```sql
SELECT
    supplier_name,
    COUNT(*) as product_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM marts.dim_product
GROUP BY supplier_name
ORDER BY product_count DESC;
```

### Check Multilingual Coverage
```sql
SELECT
    multilingual_status,
    COUNT(*) as product_count
FROM marts.dim_product
GROUP BY multilingual_status;
```

### Check Data Freshness
```sql
SELECT
    MAX(last_modified_in_source) as latest_source_update,
    MAX(ingested_timestamp) as latest_ingest,
    CURRENT_TIMESTAMP - MAX(ingested_timestamp) as data_age
FROM marts.dim_product;
```

## Troubleshooting

### Issue 1: No CDC Events in Kafka

**Symptoms**: Kafka consumer fetches 0 records

**Solutions**:
```bash
# Check Kafka topic exists and has data
docker compose -f ~/Projects/bi-platform/infra/docker-compose.dev.yml exec kafka \
  kafka-console-consumer --bootstrap-server localhost:9092 \
  --topic cord.ConcordDb.dbo.Product --from-beginning --max-messages 1

# Check Debezium connector status
curl -s http://localhost:8083/connectors/sqlserver-product-v2/status | jq

# Restart connector
curl -X POST http://localhost:8083/connectors/sqlserver-product-v2/restart
```

### Issue 2: Bronze Load Fails

**Symptoms**: psycopg2 errors, connection refused

**Solutions**:
- Verify PostgreSQL is running: `docker compose -f ~/Projects/bi-platform/infra/docker-compose.dev.yml ps postgres`
- Check connection: `PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -c "SELECT 1;"`
- Verify table exists: `\d bronze.product_cdc`

### Issue 3: dbt Run Fails

**Symptoms**: dbt compilation errors, SQL errors

**Solutions**:
```bash
# Check dbt can connect
cd ~/Projects/bi-platform
source ./venv-py311/bin/activate
dbt debug --project-dir dbt

# Check stg_product exists
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics \
  -c "\dv staging_staging.stg_product"

# Run with verbose logging
dbt run --project-dir dbt --select dim_product --debug
```

### Issue 4: Superset Shows Stale Data

**Solutions**:
1. Check cache timeout: **Settings** → **Database Connections** → Edit → Cache Timeout
2. Force refresh dashboard: **Dashboard** → **⋮** → **Force Refresh**
3. Clear Superset cache:
```bash
docker compose -f ~/Projects/bi-platform/infra/docker-compose.superset.yml exec superset \
  superset cache purge
```

## Monitoring & Alerts

### Key Metrics to Monitor

1. **Data Freshness**: `MAX(ingested_timestamp)` should be < 1 hour old
2. **Record Count**: Should match expected product count
3. **dbt Test Results**: All tests should pass
4. **Multilingual Coverage**: Should remain at 100%
5. **Business Flags**: Watch for anomalies (e.g., all products suddenly not for sale)

### Prefect Integration (Future)

Create a Prefect flow to automate this entire process:

```python
# flows/sync_product_to_bi.py
from prefect import flow, task

@flow(name="sync_product_to_bi")
def sync_product_to_bi():
    kafka_records = ingest_kafka_to_minio()
    bronze_records = load_bronze_from_minio()
    dbt_run = run_dbt_transformations()
    dbt_test = run_dbt_tests()

    if dbt_test.failed:
        send_alert("dbt tests failed!")

    return bronze_records, dbt_run, dbt_test

# Schedule: Every 6 hours
```

## Related Documentation

- **Data Profiling**: `docs/FRESH_DATA_PROFILING_REPORT.md`
- **Superset Setup**: `docs/SUPERSET_READY.md`
- **SQL Analytics Queries**: `sql/analytics/product_dashboard_queries.sql`
- **dbt Setup**: `docs/dbt_setup.md`
- **Embedding Pipeline**: `docs/embedding_pipeline.md`

## Quick Reference Commands

```bash
# Full refresh (all steps)
cd ~/Projects/bi-platform && source ./venv-py311/bin/activate

# 1. Ingest Kafka → MinIO (see Step 2 above)

# 2. Load MinIO → Bronze (see Step 3 above)

# 3. Run dbt
dbt run --project-dir dbt --select stg_product dim_product

# 4. Test dbt
dbt test --project-dir dbt --select dim_product

# 5. Validate
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics \
  -c "SELECT COUNT(*) FROM marts.dim_product;"
```

---

**Created**: 2025-10-19
**Owner**: BI Platform Team
**Update Frequency**: On-demand (manual) or via Prefect (future)
**Target**: 115 active products (as of 2025-10-19)
