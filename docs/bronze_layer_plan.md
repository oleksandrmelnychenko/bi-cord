# Bronze Layer Build Plan

The bronze layer stores raw but structured copies of Debezium CDC events in an Iceberg/Delta table that downstream tools (dbt, analytics, ML) can query efficiently. This document captures the approach and operational steps.

## 1. Landing Format
- Source: Kafka topic `cord.dbo.Product` populated by Debezium.
- Landing files: JSON Lines batches written by Prefect flow to `s3://cord-raw/product/raw/`.
- Schema: Debezium envelope (`before`, `after`, `source`, `op`, `ts_ms`, etc.).

## 2. Transformation Goals
- Preserve full CDC payload to allow auditing and replay.
- Add ingestion metadata (batch timestamp, file path, load timestamp).
- Partition by ingestion date (`ingest_date`) for pruning.
- Store as Iceberg table `bronze.product_cdc` (or Delta Lake equivalent).

## 3. Processing Strategy
1. Prefect flow writes JSONL batches to MinIO raw bucket.
2. PySpark job (`src/transform/spark_jobs/product_bronze_loader.py`) ingests new raw objects and appends to Iceberg table.
3. Use object path markers (e.g., `_SUCCESS` files or state table) to avoid reprocessing.
4. Expose Trino/Spark view pointing at `bronze.product_cdc`.

## 4. Operational Checklist
- Configure Spark with MinIO credentials (`fs.s3a.endpoint`, `fs.s3a.access.key`, `fs.s3a.secret.key`, `fs.s3a.path.style.access=true`).
- Ensure Iceberg catalog configured (Hive Metastore or JDBC catalog) and accessible to Spark/Trino.
- Schedule job via Prefect or Airflow (daily/hourly depending on latency requirements).
- Add unit checks after load (row counts, schema drift).

## 5. Next Steps
- Populate `infra/env.example` with required environment variables (MinIO, Iceberg catalog).
- Integrate job launch into orchestration (Prefect deployment).
- Enhance job with watermarking/state tracking (e.g., using PostgreSQL table `bronze_load_state`).
- Follow `docs/spark_setup.md` to install PySpark and configure the environment before running the loader.
