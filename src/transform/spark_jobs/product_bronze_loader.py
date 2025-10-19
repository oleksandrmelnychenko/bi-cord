"""
Spark job to load Debezium product CDC JSON batches from MinIO into an Iceberg table.

Requires the following environment variables:
- MINIO_ENDPOINT (e.g., http://minio:9000)
- MINIO_ACCESS_KEY / MINIO_SECRET_KEY
- MINIO_RAW_BUCKET (default: cord-raw)
- ICEBERG_CATALOG (e.g., glue, hive, jdbc)
- ICEBERG_NAMESPACE (default: bronze)
- ICEBERG_TABLE (default: product_cdc)
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
        SparkSession.builder.appName("product-bronze-loader")
        .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
        .config("spark.sql.catalog.analytics", os.getenv("ICEBERG_CATALOG_CLASS", "org.apache.iceberg.spark.SparkCatalog"))
        .config("spark.sql.catalog.analytics.type", os.getenv("ICEBERG_CATALOG", "hive"))
        .config("spark.sql.catalog.analytics.uri", os.getenv("ICEBERG_CATALOG_URI", "thrift://metastore:9083"))
        .config("spark.hadoop.fs.s3a.endpoint", endpoint)
        .config("spark.hadoop.fs.s3a.access.key", access_key)
        .config("spark.hadoop.fs.s3a.secret.key", secret_key)
        .config("spark.hadoop.fs.s3a.path.style.access", "true")
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
        .config("spark.hadoop.fs.s3a.connection.ssl.enabled", str(endpoint.startswith("https")).lower())
        .config("spark.hadoop.fs.s3a.connection.timeout", "600000")
    )

    return builder.getOrCreate()


def read_raw_batches(spark: SparkSession) -> DataFrame:
    bucket = os.getenv("MINIO_RAW_BUCKET", "cord-raw")
    prefix = os.getenv("BRONZE_INPUT_PREFIX", "product/raw")
    path = f"s3a://{bucket}/{prefix}/*.jsonl"

    df = spark.read.json(path)
    return df.withColumn("input_file", input_file_name())


def write_iceberg(df: DataFrame):
    catalog = os.getenv("ICEBERG_CATALOG_NAME", "analytics")
    namespace = os.getenv("ICEBERG_NAMESPACE", "bronze")
    table = os.getenv("ICEBERG_TABLE", "product_cdc")
    full_table = f"{catalog}.{namespace}.{table}"

    enriched = (
        df.withColumn("ingested_at", current_timestamp())
        .withColumn("ingest_date", to_date(lit(datetime.utcnow().strftime("%Y-%m-%d"))))
    )

    (
        enriched.writeTo(full_table)
        .option("check-ordering", "false")
        .append()
    )


def main():
    spark = configure_spark()
    try:
        df = read_raw_batches(spark)
        if df.rdd.isEmpty():
            print("No raw JSON batches found; exiting.")
            return
        write_iceberg(df)
        print("Bronze load completed.")
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
