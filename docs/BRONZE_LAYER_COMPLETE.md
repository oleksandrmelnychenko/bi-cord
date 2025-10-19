# Bronze Layer - Implementation Complete ✅

## Summary

The bronze layer is **fully operational** using a **direct PostgreSQL loader** instead of Spark/Iceberg. This approach is simpler, more maintainable, and better suited for the current infrastructure.

## Architecture

```
SQL Server (CDC) → Debezium → Kafka → Prefect Flow → MinIO → PostgreSQL (bronze schema)
```

## What's Working

### 1. End-to-End CDC Pipeline ✅
- **SQL Server**: CDC enabled on `ConcordDb.dbo.Product`
- **Debezium**: Connector streaming changes to Kafka
- **Kafka**: Topic `cord.ConcordDb.dbo.Product` with 61,443+ records
- **Prefect Flow**: `kafka_to_minio.py` consuming and writing to MinIO
- **MinIO**: Raw JSONL files stored at `s3://cord-raw/product/raw/`
- **PostgreSQL**: Bronze table `bronze.product_cdc` with CDC events

### 2. Bronze Table Schema

```sql
CREATE TABLE bronze.product_cdc (
    id BIGSERIAL PRIMARY KEY,
    kafka_topic VARCHAR(255),
    kafka_partition INT,
    kafka_offset BIGINT,
    kafka_timestamp BIGINT,
    kafka_key JSONB,              -- Debezium key with Product ID
    cdc_payload JSONB,             -- Full CDC event (before/after/source/op)
    ingested_at TIMESTAMP DEFAULT NOW(),
    batch_file VARCHAR(500),
    UNIQUE(kafka_topic, kafka_partition, kafka_offset)  -- Prevents duplicates
);
```

**Indexes**:
- `idx_product_cdc_topic_partition_offset` - For deduplication
- `idx_product_cdc_ingested_at` - For time-based queries

### 3. CDC Payload Structure

Each `cdc_payload` JSONB column contains:

```json
{
  "schema": { ... },  // Debezium schema definition
  "payload": {
    "before": null,   // Previous state (null for reads/inserts)
    "after": {        // Current state with all Product fields
      "ID": 7807552,
      "Name": "Пневмоподушка",
      "VendorCode": "SABO520067C",
      ...
    },
    "source": {       // CDC metadata
      "version": "2.4.0.Final",
      "connector": "sqlserver",
      "db": "ConcordDb",
      "table": "Product",
      "ts_ms": 1760797940732,
      "snapshot": "first",
      "commit_lsn": "00001ed0:00000448:0001"
    },
    "op": "r",        // Operation: r=read, c=create, u=update, d=delete
    "ts_ms": 1760797940718
  }
}
```

## Running the Pipeline

### 1. Ingest from Kafka to MinIO

```bash
cd ~/Projects/bi-platform
source venv/bin/activate
export PYTHONPATH=src
export KAFKA_TOPIC="cord.ConcordDb.dbo.Product"
python3 src/ingestion/prefect_flows/kafka_to_minio.py
```

**Output**: Creates JSONL file in MinIO at `product/raw/batch=YYYYMMDDTHHMMSSZ.jsonl`

### 2. Load from MinIO to PostgreSQL Bronze Table

```bash
cd ~/Projects/bi-platform
source venv/bin/activate
export PYTHONPATH=src
python3 src/transform/direct_loader.py
```

**Features**:
- Automatically creates `bronze` schema and `product_cdc` table
- Deduplicates based on `(kafka_topic, kafka_partition, kafka_offset)`
- Processes all JSONL files in MinIO bucket
- Idempotent - safe to run multiple times

## Monitoring & Verification

### Check Debezium Connector Status
```bash
curl http://localhost:8083/connectors/sqlserver-product-connector/status | jq
```

### View Kafka Messages
```bash
docker compose -f infra/docker-compose.dev.yml exec kafka kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic cord.ConcordDb.dbo.Product \
  --from-beginning \
  --max-messages 5
```

### Check MinIO Files
```bash
source venv/bin/activate
python3 -c "
import boto3
s3 = boto3.client('s3', endpoint_url='http://localhost:9000',
                  aws_access_key_id='minioadmin', aws_secret_access_key='minioadmin')
result = s3.list_objects_v2(Bucket='cord-raw', Prefix='product/raw/')
for obj in result.get('Contents', []):
    print(f'{obj[\"Key\"]}: {obj[\"Size\"]:,} bytes')
"
```

### Query Bronze Table
```sql
-- Connect to PostgreSQL
psql -h localhost -p 5433 -U analytics -d analytics

-- Check record count
SELECT COUNT(*) FROM bronze.product_cdc;

-- View recent records
SELECT
    kafka_offset,
    cdc_payload->>'op' as operation,
    cdc_payload->'payload'->'after'->>'ID' as product_id,
    cdc_payload->'payload'->'after'->>'Name' as product_name,
    ingested_at
FROM bronze.product_cdc
ORDER BY ingested_at DESC
LIMIT 10;

-- Extract all Product IDs
SELECT DISTINCT
    (cdc_payload->'payload'->'after'->>'ID')::bigint as product_id
FROM bronze.product_cdc
WHERE cdc_payload->'payload'->'after' IS NOT NULL
ORDER BY product_id;
```

## Current Status

- ✅ **115 CDC records** loaded into `bronze.product_cdc`
- ✅ **2 JSONL files** stored in MinIO (1.19 MB total)
- ✅ **Deduplication working** - duplicate offsets are skipped
- ✅ **Full CDC metadata preserved** - can reconstruct state changes

## Next Steps

### 1. dbt Staging Layer ✅ COMPLETE

**Status**: Fully implemented and tested
**Documentation**: See `docs/STAGING_LAYER_COMPLETE.md`

The staging layer is operational with:
- dbt-postgres v1.9.1 installed
- `stg_product` view parsing 19 columns from JSONB
- Automatic deduplication by product_id
- 4 data quality tests passing (unique, not_null)
- 115 products successfully transformed

Run the staging layer:
```bash
cd ~/Projects/bi-platform/dbt
source ../venv/bin/activate
dbt run --select stg_product
dbt test --select stg_product
```

### 2. Embeddings Pipeline

After staging is populated:
```bash
python src/ml/embedding_pipeline.py --limit 100
```

### 3. Scheduled Ingestion (Optional)

Deploy Prefect flow for continuous ingestion:
```bash
prefect deployment create orchestration/deployments/kafka_to_minio.yaml
```

## Why PostgreSQL Instead of Spark?

**Decision rationale**:
1. **Python 3.13 compatibility**: PyArrow/PySpark have build issues on Python 3.13
2. **Simpler infrastructure**: No need for Spark cluster, Iceberg catalog, or Hive metastore
3. **Better SQL integration**: Native JSONB support in PostgreSQL is excellent for CDC parsing
4. **Easier development**: Direct SQL queries for debugging and dbt integration
5. **Sufficient scale**: For 60K products, PostgreSQL handles this easily

**When to consider Spark**:
- Dataset > 10M records
- Complex transformations beyond SQL capabilities
- Need for distributed processing
- Multiple large fact tables

For now, the PostgreSQL bronze layer is the right choice.

## Dependencies Status

**Installed ✅**:
- Prefect 3.4.24
- boto3 1.40.55
- kafka-python 2.2.15
- psycopg2-binary 2.9.11

**Skipped** (not needed for current implementation):
- PySpark (Python 3.13 compatibility issues, replaced with direct PostgreSQL loader)
- PyArrow (dependency of PySpark)
- sentence-transformers (defer until embedding pipeline step)

## Files Created

1. `src/transform/direct_loader.py` - PostgreSQL bronze loader (replaces Spark job)
2. `src/ingestion/prefect_flows/kafka_to_minio.py` - Kafka consumer (already existed)
3. `src/ingestion/utils/minio_client.py` - MinIO client factory (already existed)

## Troubleshooting

### Issue: "No records to load"
**Solution**: Run Kafka ingestion first to populate MinIO

### Issue: Duplicate records warning
**Solution**: Expected behavior - deduplication is working

### Issue: PostgreSQL connection refused on port 5432
**Solution**: Use port 5433 (configured to avoid conflict with local PostgreSQL)

### Issue: MinIO connection error
**Solution**: Verify Docker containers are running:
```bash
docker compose -f infra/docker-compose.dev.yml ps
```
