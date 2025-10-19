# dbt Setup Guide

This guide walks through configuring dbt to connect to the Iceberg/Trino environment for the Cord BI project.

## 1. Install dbt and dependencies
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt  # include dbt-trino or dbt-spark as needed
```

## 2. Create `~/.dbt/profiles.yml`
Copy the template and edit values:
```bash
mkdir -p ~/.dbt
cp dbt/profiles-template.yml ~/.dbt/profiles.yml
```

Set the following fields:
- `host`: Trino coordinator hostname.
- `port`: Usually 8080.
- `user`: Service account with access to Iceberg catalog.
- `catalog`: Hive/Iceberg catalog name (e.g., `analytics`).
- `schema`: Default schema for dev models (e.g., `analytics_dev`).
- Add authentication parameters if TLS/kerberos is used.

For Spark-based workflow, swap the adapter:
```yaml
dbt:
  outputs:
    dev:
      type: spark
      method: thrift
      host: <spark-thrift-host>
      port: 10000
      schema: analytics_dev
      connect_retries: 5
```

## 3. Verify connection
```bash
dbt debug --project-dir dbt
```

## 4. Run staging models
```bash
dbt run --project-dir dbt --select staging.stg_product
```

## 5. Tests
```bash
dbt test --project-dir dbt --select staging.stg_product
```

Document the connection details securely (Vault/secret manager) instead of committing them to the repo.
