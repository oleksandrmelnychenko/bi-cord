# Data Validation Checklist

Use this checklist after each stage of the vertical slice.

## Prefect Kafka → MinIO
- [ ] Connector status RUNNING (`curl .../status`).
- [ ] Prefect run succeeded; log shows records fetched.
- [ ] JSONL files appear under `cord-raw/product/raw/`.
- [ ] Sample file contains valid Debezium envelope.

## Bronze Load
- [ ] PySpark job reports `Bronze load completed.`.
- [ ] `SELECT count(*)` on `bronze.product_cdc` returns expected volume.
- [ ] Partition column `ingest_date` populated.
- [ ] No schema drift warnings in Spark logs.

## dbt Staging
- [ ] `dbt run --select stg_product` success.
- [ ] `dbt test --select stg_product` success.
- [ ] Sample data matches source after filtering deletes.

## Embeddings
- [ ] `src/ml/embedding_pipeline.py` executed without errors.
- [ ] `SELECT count(*)` on `product_embeddings` > 0.
- [ ] Embedding dimension matches model (e.g., 384 or 768).
- [ ] Spot-check vectors by querying nearest neighbors.
