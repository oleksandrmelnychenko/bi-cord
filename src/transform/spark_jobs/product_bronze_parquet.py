"""
Simplified Spark job to load Debezium product CDC JSON batches from MinIO to Parquet.
This version doesn't require Iceberg/Hive metastore infrastructure.

Requires the following environment variables:
- MINIO_ENDPOINT (default: http://localhost:9000)
- MINIO_ACCESS_KEY / MINIO_SECRET_KEY (default: minioadmin)
- MINIO_RAW_BUCKET (default: cord-raw)
- BRONZE_OUTPUT_PATH (default: /tmp/bronze/product_cdc)
"""

from __future__ import annotations

import os
from datetime import datetime

from pyspark.sql import DataFrame, SparkSession
from pyspark.sql.functions import current_timestamp, input_file_name, lit, to_date


def configure_spark() -> SparkSession:
    endpoint = os.getenv("MINIO_ENDPOINT", "http://localhost:9000")
    access_key = os.getenv("MINIO_ACCESS_KEY", "minioadmin")
    secret_key = os.getenv("MINIO_SECRET_KEY", "minioadmin")

    builder = (
        SparkSession.builder.appName("product-bronze-parquet-loader")
        .config("spark.hadoop.fs.s3a.endpoint", endpoint)
        .config("spark.hadoop.fs.s3a.access.key", access_key)
        .config("spark.hadoop.fs.s3a.secret.key", secret_key)
        .config("spark.hadoop.fs.s3a.path.style.access", "true")
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
        .config("spark.hadoop.fs.s3a.connection.ssl.enabled", str(endpoint.startswith("https")).lower())
        .config("spark.hadoop.fs.s3a.connection.timeout", "600000")
        .config("spark.sql.adaptive.enabled", "true")
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true")
    )

    return builder.getOrCreate()


def read_raw_batches(spark: SparkSession) -> DataFrame:
    bucket = os.getenv("MINIO_RAW_BUCKET", "cord-raw")
    prefix = os.getenv("BRONZE_INPUT_PREFIX", "product/raw")
    path = f"s3a://{bucket}/{prefix}/*.jsonl"

    print(f"Reading CDC data from {path}")
    df = spark.read.json(path)
    return df.withColumn("input_file", input_file_name())


def write_parquet(df: DataFrame):
    output_path = os.getenv("BRONZE_OUTPUT_PATH", "/tmp/bronze/product_cdc")

    print(f"Writing {df.count()} records to {output_path}")

    enriched = (
        df.withColumn("ingested_at", current_timestamp())
        .withColumn("ingest_date", to_date(lit(datetime.utcnow().strftime("%Y-%m-%d"))))
    )

    # Write as parquet with partitioning by date
    (
        enriched.write
        .mode("append")
        .partitionBy("ingest_date")
        .parquet(output_path)
    )

    print(f"✅ Bronze parquet load completed to {output_path}")


def main():
    spark = configure_spark()
    try:
        df = read_raw_batches(spark)

        if df.rdd.isEmpty():
            print("❌ No raw JSON batches found in MinIO")
            return

        print(f"✅ Found CDC data, schema:")
        df.printSchema()

        print(f"\nSample records:")
        df.show(5, truncate=False)

        write_parquet(df)

    finally:
        spark.stop()


if __name__ == "__main__":
    main()
