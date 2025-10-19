# BI & AI Platform Architecture Plan

## 1. Objectives
- Deliver a Python-centric business intelligence platform that consumes the operational SQL Server schema (see `Desktop/Cord/Db.rtf`) without disrupting OLTP workloads.
- Provide AI-powered product search, demand forecasting, personalized product propositions, and automated insight reports.
- Establish robust data governance, observability, and deployment practices to keep analytics trustable and auditable.

## 2. Target Architecture (Textual)
- **Sources:** Production SQL Server (`Product`, `Order`, `Sale`, `Client` tables); auxiliary CSV/Excel when required.
- **Change Data Capture:** Debezium SQL Server connector streaming into Kafka (or native SQL Server CDC if Debezium is unavailable).
- **Landing/Staging:** On-prem object storage cluster (MinIO, Ceph, or HDFS) keeping raw CDC increments in Delta Lake or Apache Iceberg format.
- **Warehouse/Query Engine:** Trino/Presto cluster querying Delta/Iceberg on MinIO; Apache Spark (stand-alone or on Kubernetes) for heavy ETL; PostgreSQL + Citus or ClickHouse as complementary mart store when low-latency SQL is needed.
- **Transformations:** dbt-core (dbt-trino/dbt-spark adapters) materializing dimensional models (Sales, Orders, Inventory, Clients, Products) and aggregate snapshots.
- **Orchestration:** Prefect 2.0 (self-hosted server) coordinating ingestion (Debezium offsets), dbt runs, quality checks, ML retraining, and batch inference.
- **Data Quality & Lineage:** Great Expectations suites embedded in Prefect flows; OpenLineage for metadata emitted from dbt and Prefect.
- **Feature Store:** Feast backed by the Trino/Spark warehouse for online/offline parity; incremental aggregates for ML features.
- **Model Training & Tracking:** MLflow server inside the cluster; experiments logged from secured JupyterHub or VSCode remote sessions.
- **Vector Store for Semantic Search:** pgvector on PostgreSQL 15+ (deployed on-prem) or self-hosted Qdrant/Weaviate depending on scale.
- **Model Serving / APIs:** FastAPI microservices containerized with Docker and orchestrated via on-prem Kubernetes (K3s/RKE/OpenShift); async jobs via Celery + Redis or RabbitMQ.
- **BI Consumption Layer:** Apache Superset (self-hosted) connected directly to curated marts; optional Metabase for lighter stakeholders.
- **Monitoring & Alerting:** Prometheus + Grafana dashboards for infra metrics; Evidently AI for data drift; Alertmanager/Slack (or Mattermost) integration.

## 3. Technology Rationale
- **Debezium + Kafka** provides near real-time ingest without heavy load on OLTP, scalable to future microservices.
- **Delta Lake / Apache Iceberg + Trino/Spark** supply ACID guarantees and open table formats that run fully on-prem while supporting both streaming and batch workloads.
- **dbt-core** (using the Trino or Spark adapter) gives modular, testable SQL transformations, version-controlled in Git CI/CD workflows.
- **Prefect** aligns with Python skillset; self-hosted server keeps orchestration data on-prem while still offering retries, scheduling, and observability.
- **Feast** ensures consistent ML features between training and inference, simplifying forecast/recommendation data flows.
- **pgvector or Qdrant** integrate vector search within the analytics estate, enabling hybrid SQL + semantic queries without internet access.
- **FastAPI** offers high-performance async APIs and automatic schema generation; packages cleanly into on-prem containers.
- **MLflow & Evidently** underpin reproducibility, audit trails, and drift detection, critical for regulated clients.
- **Superset** is open-source, supports row-level security, and integrates natively with the self-hosted SQL engines in the stack.

## 4. Data Pipeline Stages
1. **Extract**
   - Debezium tasks capture inserts/updates/deletes from key operational tables.
   - Airbyte or one-off Python connectors sync non-CDC sources (CSV, REST).
2. **Land**
   - Prefect flow writes raw CDC payloads as partitioned Delta tables (`cdc_schema.table_name/year=.../month=...`).
   - Metadata (schema version, batch id) stored in Hive metastore for discoverability.
3. **Stage**
   - dbt models clean and conform raw data into staging tables (`stg_product`, `stg_sale`, `stg_client`).
   - Data quality tests enforce not-null, unique keys, referential integrity using Great Expectations.
4. **Transform**
   - Dimensional models: `dim_product`, `dim_client`, `dim_date`, `dim_transporter`, etc.
   - Fact tables: `fct_order_item`, `fct_sale`, `fct_inventory_snapshot`, `fct_client_interaction`.
   - Aggregates: weekly/monthly sales, stock coverage, client RFM metrics.
5. **Feature Engineering**
   - Feast feature views for forecasting (time-series lag features, promo flags) and recommendations (collaborative signals).
   - Embedding generation jobs (sentence-transformers, Instructor, or fine-tuned local LLMs) stored in `vector_product_embeddings`.
6. **Model Training**
   - Forecasting notebooks/pipelines (Prophet baseline, upgrade to LightGBM/Temporal Fusion Transformer) scheduled via Prefect.
   - Recommendation models (implicit ALS + content-based) retrained weekly; metrics logged to MLflow.
7. **Serving**
   - Batch inference outputs written to `mart_forecast_product_day` and `mart_reco_client_top_n`.
   - FastAPI endpoints expose search, recommendation, and reporting summarizers; results cached in Redis.
8. **Consumption**
   - Superset dashboards consume marts; .NET apps call FastAPI endpoints; scheduled email/slack reports generated via Prefect tasks.

## 5. Implementation Phases & Milestones
- **Phase 0 – Kickoff (Week 0-1)**
  - Finalize on-prem infrastructure blueprint, credentials, and security requirements.
  - Set up Git repo, CI/CD skeleton, and shared documentation (Confluence/Notion).
- **Phase 1 – Foundation (Week 2-4)**
  - Provision storage, warehouse, Prefect, Kafka, and dbt project scaffolding.
  - Implement minimal CDC ingestion for `Product`, `Order`, `Sale`, `Client`.
  - Establish data quality suites and lineage capture.
- **Phase 2 – Core BI Models (Week 5-7)**
  - Build core dimensional models and fact tables.
  - Deliver initial Superset dashboards (sales overview, inventory status).
  - Harden pipelines with unit/integration tests, CI for dbt.
- **Phase 3 – AI Product Search (Week 6-8, overlaps)**
  - Clean product text fields, generate embeddings, deploy vector index.
  - Ship beta FastAPI semantic search endpoint; gather feedback analytics.
- **Phase 4 – Forecasting Engine (Week 8-11)**
  - Engineer time-series features; baseline forecasts; evaluate against historicals.
  - Automate training/inference cadence; publish forecast marts.
- **Phase 5 – Personalized Propositions (Week 10-13)**
  - Implement collaborative + content modeling; connect to Feast feature store.
  - Deploy batch scoring and API for client-specific top-N propositions.
- **Phase 6 – AI Reports & Observability (Week 12-14)**
  - Integrate LLM-driven narratives using on-prem models (Llama 3, Mistral) served via vLLM or text-generation-inference; add report scheduling.
  - Complete monitoring dashboards, drift alerts, and on-call playbooks.
- **Phase 7 – Handover & Scale (Week 15+)**
  - Load/performance testing, disaster recovery drills.
  - Documentation, training sessions, and production readiness review.

## 6. Open Decisions & Risks
- **Hardware footprint:** size Kafka, MinIO, Trino/Spark, and GPU nodes; confirm virtualization vs. bare-metal deployment.
- **LLM access:** choose on-prem model family (Llama 3, Mistral, Mixtral) and serving stack; confirm licensing and GPU allocation.
- **Real-time needs:** clarify SLA for search/recommendations—decides between batch-only vs. streaming inference.
- **Data privacy:** identify sensitive fields (PII in `Client` tables) needing masking/anonymization before landing in lake.
- **Team skills:** ensure ownership for Kafka, dbt, Prefect, and Kubernetes; plan training if skill gaps exist.

## 7. Next Immediate Actions
1. Confirm on-prem hardware topology (storage, compute, GPU) and security constraints.
2. Draft connectivity plan for SQL Server source (firewall rules, credentials, CDC enablement).
3. Initialize Git repository with Prefect + dbt boilerplate and basic Docker compose for local dev (Kafka, Postgres, MinIO).
4. Prepare thin vertical slice: ingest `Product` table, transform to `stg_product`, generate sample embeddings, and expose prototype search API.
