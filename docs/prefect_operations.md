# Prefect Operations Guide

## 1. Deployment
1. Ensure `.env` (based on `infra/env.example`) is sourced.
2. Build/update deployment YAML:
   ```bash
   prefect deployment build src/ingestion/prefect_flows/kafka_to_minio.py:kafka_to_minio_flow \
     -n product-cdc \
     -q default \
     -o orchestration/deployments/kafka_to_minio.yaml
   ```
3. Apply deployment:
   ```bash
   prefect deployment apply orchestration/deployments/kafka_to_minio.yaml
   ```

## 2. Running Jobs
- Ad-hoc run:
  ```bash
  prefect deployment run kafka-to-minio-flow/product-cdc
  ```
- Schedule via Prefect UI by adding a cron/interval schedule to the deployment.

## 3. Monitoring
- Prefect UI: http://localhost:4200 (default credentials not required; create account as needed).
- Logs accessible via Prefect UI or `docker compose logs prefect`.
- Configure notifications (email/Slack) from Prefect Cloud/Server as applicable.

## 4. Secrets & Blocks
- Register MinIO credentials as a Prefect block (if Vault integration available).
- Store Kafka bootstrap servers and topics in blocks to avoid hard-coded `.env`.

## 5. CI/CD Integration
- Add `prefect deployment build` and `prefect deployment apply --skip-upload` steps to CI pipeline after lint/tests.
- Use Prefect CLI with API key for remote apply in staging/prod.
