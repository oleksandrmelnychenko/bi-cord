# Product Data Pipeline Runbook

This runbook distills the steps required to sync product data from SQL Server into Postgres and keep availability, analogues, and OEM details ready for downstream ML and API workloads.

## 1. Prerequisites
- Copy `infra/env.example` to `.env`, fill in SQL Server, Kafka, MinIO, and Postgres credentials, then run `source .env`.
- Create and activate the Python environment: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`.
- Start the local stack (Kafka, Debezium, MinIO, Postgres, Prefect) with `docker compose -f infra/docker-compose.dev.yml up -d`.

## 2. Ingest CDC Events
1. Confirm the Debezium connector is registered and running (`docs/register_debezium_connector.md`); verify the status at `http://localhost:8083/connectors`.
2. Build/apply the Prefect deployment if the flow definition changed:
   ```bash
   prefect deployment build src/ingestion/prefect_flows/kafka_to_minio.py:kafka_to_minio_flow \
     -n product-cdc -q default -o orchestration/deployments/kafka_to_minio.yaml
   prefect deployment apply orchestration/deployments/kafka_to_minio.yaml
   ```
3. Trigger the flow to land raw JSONL batches in MinIO:
   ```bash
   prefect deployment run kafka-to-minio-flow/product-cdc
   ```
   Keep Prefect running on a schedule (Agent or `prefect worker start`) for ongoing syncs.

## 3. Load Bronze Tables
Run the direct loader to move MinIO JSONL batches into Postgres:
```bash
python -m src.transform.direct_loader
```
It creates `bronze.product_cdc` (if needed) and ingests new batches while skipping duplicates.

## 4. Build Warehouse Layers
1. Ensure dbt profiles are configured for the Postgres instance (see `docs/dbt_setup.md`).
2. Materialize staging views and marts:
   ```bash
   dbt run --models staging
   dbt run --models marts.dim_product_search
   dbt test --models staging.stg_product marts.dim_product_search
   ```
3. Optional: seed helper tables or macros if `dbt deps` reports missing packages.

## 5. Validate the Pipeline
Run the unified health check after each load:
```bash
python scripts/pipeline_healthcheck.py
```
You should see `PASS` for bronze tables, staging views, and the `marts.dim_product_search` table. Warnings indicate partial progress (e.g., no rows yet); failures call out missing env vars, unreachable Postgres, or unbuilt models.

## 6. Troubleshooting Cheatsheet
- **Debezium connector missing**: re-run the registration steps and confirm SQL Server credentials.
- **Bronze tables empty**: verify Kafka topics have traffic (`kafka-topics --list`) and re-run the Prefect flow.
- **Staging views missing columns**: `dbt run --models staging` and inspect logs for casting issues.
- **dim_product_search empty**: confirm availability/analogue staging models have data; re-run marts model.
- **Health check failures**: re-run with `PREFECT_API_URL` and `DEBEZIUM_CONNECT_URL` set if services use non-default hosts.

Once the health check passes, downstream services (embedding pipeline, semantic search API, proposal service) can trust the warehouse state.
