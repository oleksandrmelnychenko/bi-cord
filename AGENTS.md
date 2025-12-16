# Repository Guidelines

## Project Structure & Module Organization
- `src/ingestion/` holds Debezium/Kafka CDC flows feeding MinIO staging; `src/transform/` contains warehouse utilities and dbt helpers.
- `src/ml/` bundles embedding and forecasting pipelines, `src/api/` exposes FastAPI search services, and runtime defaults sit in `src/config/`.
- `dbt/` captures modeling logic, `orchestration/` tracks Prefect deployments, while `docs/`, `infra/`, `sql/`, `scripts/`, and `tests/` provide runbooks, IaC, SQL aids, automation, and pytest suites.

## Build, Test, and Development Commands
- `python3 -m venv .venv && source .venv/bin/activate` provisions an isolated environment aligned with `requirements.txt`.
- `docker compose -f infra/docker-compose.dev.yml up -d` launches Kafka, MinIO, pgvector, and supporting services.
- `prefect deployment build src/ingestion/prefect_flows/kafka_to_minio.py:kafka_to_minio_flow -n product-cdc` generates the ingestion deployment; follow with `prefect deployment apply`.
- `./verify_pipeline.sh` executes ingestion smoke checks—rerun after modifications in `src/ingestion/` or `orchestration/`.
- `python -m pytest tests` runs unit coverage across embedding, normalization, and helper modules.

## Coding Style & Naming Conventions
- Python code follows PEP 8 with 4-space indentation; add concise docstrings to Prefect flows, API routers, and public utilities.
- Modules and packages use lowercase with underscores (e.g., `src/ml/embedding_pipeline_v2.py`); tests mirror targets (`tests/test_query_normalizer.py`).
- Keep configuration keys snake_case, source defaults from `src/config/settings.py`, and surface overrides through environment variables in `.env`.

## Testing Guidelines
- Extend pytest suites under `tests/`; name files `test_<feature>.py` and functions `test_<behavior>`.
- Mock external services to avoid direct Kafka, MinIO, or pgvector dependencies; prefer fixtures for sample payloads.
- When altering data transforms, add regression assertions (field counts, critical keys) and update `./verify_pipeline.sh` if workflows change.

## Commit & Pull Request Guidelines
- Follow Conventional Commit phrasing seen in history (`feat: ...`, `fix: ...`, `chore: ...`) with imperative summaries.
- Group related changes per commit and note performance or schema impacts in the body when relevant.
- Pull requests should include a concise summary, linked issue, validation steps (`pytest`, `verify_pipeline.sh`, docker status), and screenshots for API or Superset UI updates.

## Security & Configuration Notes
- Copy `infra/env.example` to `.env` for local setups; never commit populated secrets or connector credentials.
- Align with `docs/secrets_management.md` for rotation procedures and document any environment overrides in PR descriptions.
