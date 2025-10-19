# Embedding Pipeline Usage

## Overview
- Reads complete records from `staging.stg_product` (all columns) and converts every non-empty attribute into descriptive text.
- Generates sentence-transformer embeddings (default `all-MiniLM-L6-v2`).
- Upserts vectors into pgvector table defined in environment variables.

## Requirements
- Prefect & ingestion flows have populated bronze/staging tables.
- `sentence-transformers` model downloaded (internet or local mirror).
- Environment variables set (`PGVECTOR_*`, `STAGING_DB_*`).
- `PGVECTOR_EMBEDDING_DIM` must match the embedding size of the chosen model (default 384 for `all-MiniLM-L6-v2`).
- Optional: set `EMBEDDING_MODEL_PATH` to a local directory containing the model to avoid outbound downloads.

## Run Locally
```bash
source .env  # ensure pgvector + staging connection vars present (optional if defaults ok)
./venv-py311/bin/python src/ml/embedding_pipeline.py --limit 10000
```

## Production Considerations
- Schedule via Prefect or cron after nightly ETL completes.
- Monitor runtime and DB load; batch updates to avoid locking.
- For air-gapped environments, host models on internal artifact store.
- Consider storing model metadata (version, parameters) in a registry table.

## Next Enhancements
- Add incremental logic to only embed products changed since last run.
- Log metadata (run id, counts) to monitoring table.
- Wrap script in Prefect flow for unified orchestration.
- Extend to enrich text with related tables (groups, categories) once staging models include them.
