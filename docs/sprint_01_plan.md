# Sprint 01 Plan – Foundation Slice
Duration: 2 weeks

## Goals
- Deliver a vertical slice proving the end-to-end pipeline: ingest `Product` table changes, land in lake storage, transform to staging, and expose embeddings via prototype API.
- Establish engineering workflows (Git, CI, code standards) and shared runbooks.

## Backlog
1. **Environment Setup**
   - Provision development Kubernetes namespace (or Docker Compose) for Kafka, MinIO, PostgreSQL (pgvector), and Prefect.
   - Publish base container images to internal registry (Python runtime with Prefect/dbt tooling).
2. **CDC Pipeline**
   - Configure Debezium connector for `Product` table using read-only SQL Server credentials.
   - Implement Prefect flow to land CDC events into MinIO Delta/Iceberg tables (raw layer).
   - Add Great Expectations validation for schema/row count parity.
3. **dbt Staging**
   - Scaffold dbt project (`dbt_project.yml`, `profiles.yml` template) targeting Trino/Spark.
   - Create `stg_product` model cleaning raw data; include dbt tests (not-null, unique keys).
4. **Embedding Prototype**
   - Implement Python job in `src/ml/embedding_pipeline.py` that loads `stg_product`, generates embeddings using sentence-transformers, and writes vectors to pgvector.
   - Seed pgvector schema with index + metadata tables.
5. **API Skeleton**
   - Create FastAPI service skeleton (`src/api/app.py`) with health endpoint and placeholder search route.
   - Set up basic integration test to ensure API can query pgvector store.
6. **Ops & Observability**
   - Configure Prefect deployment definitions; enable logging aggregation (Fluent Bit → Loki/ELK).
   - Publish Grafana dashboard template for Kafka connector lag and Prefect flow status.

## Definition of Done
- Scheduled Prefect flow successfully ingests sample `Product` changes end-to-end.
- dbt tests and Great Expectations validations pass in CI pipeline.
- Embedding job runs and persists vectors retrievable via FastAPI placeholder endpoint.
- Documentation updated: runbook for CDC flow, onboarding instructions for developers.

## Risks / Mitigations
- **Hardware availability:** start in containerised dev stack while awaiting production hardware.
- **Model licensing:** verify sentence-transformers license compatibility; plan alternative if restricted.
- **Access delays:** engage DBA/network teams early with the CDC checklist to avoid blockers.
