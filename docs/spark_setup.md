# Spark Environment Setup

## 1. Python Environment
- Install Python 3.10+ with `python3` and `pip3` available in PATH.
- Optionally create a virtual environment:
  ```bash
  python3 -m venv .venv
  source .venv/bin/activate
  pip install --upgrade pip
  ```

## 2. Install Dependencies
- Install PySpark and dependencies (or run `pip install -r requirements.txt`):
  ```bash
  pip install pyspark==3.5.1 pyarrow==15.0.2
  ```
- Add `boto3` or Hadoop AWS libraries if running outside the compose stack:
  ```bash
  pip install boto3==1.34.143
  ```

## 3. Configure Environment Variables
- Source `.env` or export manually:
  ```bash
  export MINIO_ENDPOINT=http://localhost:9000
  export MINIO_ACCESS_KEY=minioadmin
  export MINIO_SECRET_KEY=minioadmin
  export MINIO_RAW_BUCKET=cord-raw
  export ICEBERG_CATALOG=hive
  export ICEBERG_CATALOG_URI=thrift://metastore:9083
  export ICEBERG_NAMESPACE=bronze
  export ICEBERG_TABLE=product_cdc
  ```
- Ensure Spark can reach the Iceberg catalog (Hive Metastore, Glue, JDBC).

## 4. Run Bronze Loader
```bash
python src/transform/spark_jobs/product_bronze_loader.py
```
- Check console output for `Bronze load completed.`.
- Validate Iceberg table via Trino/Spark SQL:
  ```sql
  SELECT count(*) FROM bronze.product_cdc;
  ```

## 5. Troubleshooting
- `ModuleNotFoundError: pyspark` — install PySpark package as described.
- `NoSuchTableException` — create Iceberg namespace/table with Spark SQL:
  ```sql
  CREATE NAMESPACE IF NOT EXISTS bronze;
  CREATE TABLE IF NOT EXISTS bronze.product_cdc (...);
  ```
- S3/MinIO auth errors — verify credentials and ensure `fs.s3a.path.style.access=true`.
- Install Java 11 (required for PySpark on macOS):
  ```bash
  brew install openjdk@11
  export JAVA_HOME=$(/usr/libexec/java_home -v11)
  ```
