# BI Platform (On-Prem)

This repository drives the on-premises BI and AI initiative built on top of the Cord transactional database (`Desktop/Cord/Db.rtf`). It holds architecture notes, infrastructure manifests, ETL/ELT code, machine learning pipelines, and API services that power semantic product search, forecasting, personalized recommendations, and automated reports.

## Repository Layout

- `architecture_plan.md` — high-level blueprint and phased roadmap.
- `docs/` — supplementary design notes, runbooks, and compliance checklists.
- `infra/` — infrastructure-as-code, container orchestrator manifests, and deployment automation.
- `src/ingestion/` — Debezium/Kafka consumers, raw-to-staging loaders.
- `src/transform/` — data warehouse utilities, dbt adapters, data quality helpers.
- `src/ml/` — forecasting, recommendation, and embedding generation pipelines.
- `src/api/` — FastAPI services for semantic search, personalized offers, and AI-generated reports.
- `dbt/` — dbt project for staging, dimensional models, and marts.
- `orchestration/` — Prefect flows, deployment configs, and scheduling policies.
- Key docs: `docs/bronze_layer_plan.md`, `docs/dbt_setup.md`, `docs/prefect_operations.md`, `docs/embedding_pipeline.md`, `docs/secrets_management.md`, `docs/spark_setup.md`, `docs/validation_checklist.md`, `docs/offline_python_packages.md`, `docs/offline_package_manifest.md`, `docs/offline_install_checklist.md`, `docs/entity_property_catalog.md`, `docs/data_profiling_plan.md`, `docs/forecasting_design.md`, `docs/product_sync_to_bi.md`.
- SQL utilities: `sql/profile_core_entities.sql` for quick profiling metrics.
- BI dashboards: Apache Superset deployed at http://localhost:8088 (see `docs/SUPERSET_READY.md`)
- BI mart layer: `staging_marts.dim_product` table with 278,697 active products (see `docs/product_sync_to_bi.md`)
- ML Search API: FastAPI service at http://localhost:8000 with 278,698 semantic embeddings (see `docs/ML_SEARCH_IMPLEMENTATION.md`)
- BI sync: run `dbt run --select dim_product` and `dbt test --select dim_product`
- Operational history captured in `docs/run_log.md`.

## System Status

**Completed (2025-10-19)**:
- ✅ Full product catalog synced: 278,697 products
- ✅ ML semantic embeddings: 278,698 vectors (384-dim)
- ✅ HNSW vector index: 544 MB optimized for fast search
- ✅ FastAPI search service: http://localhost:8000
- ✅ Apache Superset dashboards: http://localhost:8088

**ML Search API Endpoints**:
- `POST /search/semantic` - Pure vector similarity search
- `POST /search/filtered` - Filtered semantic search (supplier, weight, etc.)
- `POST /search/hybrid` - Text + vector hybrid search
- `GET /search/similar/{id}` - Product-to-product similarity

See `docs/ML_SEARCH_IMPLEMENTATION.md` for complete documentation.

## Next Steps

1. GPU acceleration for query inference (reduce 11-12s to ~100ms)
2. Integrate search API with production frontend
3. Add authentication & rate limiting to FastAPI
4. Expand Superset dashboards with product analytics
5. Implement automated embedding refresh pipeline

## Development Setup

1. Create a virtual environment and install dependencies:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```
2. Launch the local stack (Kafka, MinIO, pgvector, Prefect):
   ```bash
   docker compose -f infra/docker-compose.dev.yml up -d
   ```
3. Create or activate the Python 3.11 virtualenv (`venv-py311`) and install offline packages per `docs/offline_python_packages.md`.
4. Export environment variables (copy `infra/env.example` to `.env` and `source` it) before running flows and jobs.
5. Register the Debezium connector as described in `docs/register_debezium_connector.md`.
6. Run the Prefect flow locally:
   ```bash
   prefect deployment build src/ingestion/prefect_flows/kafka_to_minio.py:kafka_to_minio_flow -n product-cdc
   prefect deployment apply kafka_to_minio_flow-deployment.yaml
   prefect deployment run kafka-to-minio-flow/product-cdc
   ```
   *(Adjust Prefect commands once the deployment strategy is finalised.)*
7. Populate the bronze table with the Spark job (see `docs/bronze_layer_plan.md`). PySpark requires Java 11; see `docs/spark_setup.md`.
8. Generate embeddings (already complete with 278,698 vectors):
   ```bash
   # Already complete - 278,698 embeddings generated
   # To regenerate or update:
   ./venv-py311/bin/python -c "from src.ml.embedding_pipeline import main; main()"
   ```
9. Start the ML search API server:
   ```bash
   ./venv-py311/bin/uvicorn src.api.search_api:app --host 0.0.0.0 --port 8000
   # Visit http://localhost:8000/docs for interactive API documentation
   ```
