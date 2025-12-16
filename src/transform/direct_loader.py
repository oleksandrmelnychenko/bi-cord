"""
Direct loader: MinIO JSONL → PostgreSQL bronze table (no Spark needed).
Reads CDC events from MinIO and loads them into a PostgreSQL table for dbt processing.
"""

import json
import os
from datetime import datetime
from typing import Any, Dict, List

import boto3
import psycopg2
from psycopg2.extras import Json, execute_values


def get_s3_client():
    """Create boto3 S3 client for MinIO."""
    return boto3.client(
        "s3",
        endpoint_url=os.getenv("MINIO_ENDPOINT", "http://localhost:9000"),
        aws_access_key_id=os.getenv("MINIO_ACCESS_KEY", "minioadmin"),
        aws_secret_access_key=os.getenv("MINIO_SECRET_KEY", "minioadmin"),
    )


def get_pg_connection():
    """Create PostgreSQL connection using staging defaults."""
    host = os.getenv("STAGING_DB_HOST") or os.getenv("POSTGRES_HOST", "localhost")
    port = int(os.getenv("STAGING_DB_PORT") or os.getenv("POSTGRES_PORT", "5432"))
    database = os.getenv("STAGING_DB_NAME") or os.getenv("POSTGRES_DB", "analytics")
    user = os.getenv("STAGING_DB_USER") or os.getenv("POSTGRES_USER", "analytics")
    password = os.getenv("STAGING_DB_PASSWORD") or os.getenv("POSTGRES_PASSWORD", "analytics")

    return psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password,
    )


def create_bronze_table(conn):
    """Create bronze.product_cdc table if it doesn't exist."""
    with conn.cursor() as cur:
        # Create schema
        cur.execute("CREATE SCHEMA IF NOT EXISTS bronze;")

        # Create table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS bronze.product_cdc (
                id BIGSERIAL PRIMARY KEY,
                kafka_topic VARCHAR(255),
                kafka_partition INT,
                kafka_offset BIGINT,
                kafka_timestamp BIGINT,
                kafka_key JSONB,
                cdc_payload JSONB,
                ingested_at TIMESTAMP DEFAULT NOW(),
                batch_file VARCHAR(500),
                UNIQUE(kafka_topic, kafka_partition, kafka_offset)
            );
        """)

        # Create indexes
        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_product_cdc_topic_partition_offset
            ON bronze.product_cdc(kafka_topic, kafka_partition, kafka_offset);
        """)

        cur.execute("""
            CREATE INDEX IF NOT EXISTS idx_product_cdc_ingested_at
            ON bronze.product_cdc(ingested_at);
        """)

        conn.commit()
        print("✓ Created bronze.product_cdc table")


def read_jsonl_from_minio(s3_client, bucket: str, key: str) -> List[Dict[str, Any]]:
    """Read JSONL file from MinIO and parse into list of dicts."""
    print(f"Reading s3://{bucket}/{key}")

    obj = s3_client.get_object(Bucket=bucket, Key=key)
    content = obj["Body"].read().decode("utf-8")

    records = []
    for line in content.strip().split("\n"):
        if line:
            records.append(json.loads(line))

    return records


def transform_record(record: Dict[str, Any], batch_file: str) -> tuple:
    """Transform CDC record for PostgreSQL insertion."""
    # Parse key if it's a string
    key = record.get("key")
    if isinstance(key, str):
        try:
            key = json.loads(key)
        except json.JSONDecodeError:
            pass

    return (
        record.get("topic"),
        record.get("partition"),
        record.get("offset"),
        record.get("timestamp"),
        Json(key) if key else None,
        Json(record.get("value")),
        batch_file,
    )


def load_to_postgres(conn, records: List[Dict[str, Any]], batch_file: str):
    """Bulk load records into PostgreSQL."""
    if not records:
        print("No records to load")
        return

    values = [transform_record(r, batch_file) for r in records]

    with conn.cursor() as cur:
        execute_values(
            cur,
            """
            INSERT INTO bronze.product_cdc
                (kafka_topic, kafka_partition, kafka_offset, kafka_timestamp,
                 kafka_key, cdc_payload, batch_file)
            VALUES %s
            ON CONFLICT (kafka_topic, kafka_partition, kafka_offset) DO NOTHING
            """,
            values,
            page_size=1000,
        )

        conn.commit()
        print(f"✓ Loaded {cur.rowcount} new records (duplicates skipped)")


def main():
    """Main ETL process."""
    bucket = os.getenv("MINIO_RAW_BUCKET", "cord-raw")
    prefix = os.getenv("BRONZE_INPUT_PREFIX", "product/raw")

    print(f"Starting bronze load from s3://{bucket}/{prefix}/")

    # Initialize clients
    s3 = get_s3_client()
    conn = get_pg_connection()

    try:
        # Create table
        create_bronze_table(conn)

        # List all JSONL files
        result = s3.list_objects_v2(Bucket=bucket, Prefix=prefix)
        files = [obj["Key"] for obj in result.get("Contents", []) if obj["Key"].endswith(".jsonl")]

        if not files:
            print(f"No JSONL files found in s3://{bucket}/{prefix}/")
            return

        print(f"Found {len(files)} file(s) to process")

        total_records = 0
        for file_key in files:
            records = read_jsonl_from_minio(s3, bucket, file_key)
            load_to_postgres(conn, records, file_key)
            total_records += len(records)

        print(f"\n✓ Bronze load complete: {total_records} total records processed")

        # Show summary
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM bronze.product_cdc")
            count = cur.fetchone()[0]
            print(f"✓ bronze.product_cdc now contains {count} records")

    finally:
        conn.close()


if __name__ == "__main__":
    main()
