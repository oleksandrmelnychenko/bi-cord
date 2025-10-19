# Local Development Stack Guide

Use this guide to spin up the containerised environment for development and integration testing.

## Prerequisites
- Docker 24+ with Docker Compose plugin.
- At least 16 GB RAM and 40 GB free disk for containers and volumes.
- `docker` access for your user (no sudo required).

## Services Included
- Zookeeper, Kafka broker, and Kafka Connect with Debezium plugin placeholder.
- Confluent Schema Registry (optional for Avro/Protobuf payloads).
- MinIO object storage with pre-created buckets (`cord-raw`, `cord-curated`, `cord-features`).
- PostgreSQL with pgvector extension for embeddings and metadata.
- Prefect 2 server for orchestration UI/API.

## Start Environment
```bash
cd Projects/bi-platform
docker compose -f infra/docker-compose.dev.yml up -d
```

Verify services:
- Prefect UI: http://localhost:4200
- MinIO Console: http://localhost:9001 (user `minioadmin` / `minioadmin`)
- PostgreSQL: `psql postgres://analytics:analytics@localhost:5432/analytics`
- Kafka Connect API: http://localhost:8083/connectors

## Stop & Cleanup
```bash
docker compose -f infra/docker-compose.dev.yml down
docker compose -f infra/docker-compose.dev.yml down -v  # removes volumes
```

## Next Steps
1. Copy the Debezium SQL Server connector JARs into `infra/kafka-connect/plugins/`.
2. Copy `infra/env.example` to `.env`, adjust values, and `source .env` for local runs.
3. POST `infra/kafka-connect/connectors/sqlserver-product.json` to `http://localhost:8083/connectors`.
4. Configure dbt `profiles.yml` to point at Trino/Spark (or use local placeholder until cluster available).
5. Register Prefect block credentials and deploy the ingestion flow.
