from __future__ import annotations

import json
import os
from datetime import datetime
from typing import Any, Dict, Iterable, List

from kafka import KafkaConsumer
from prefect import flow, get_run_logger, task

from ingestion.utils.minio_client import MinioClientFactory


def _deserialize(value: bytes | None) -> Any:
    if value is None:
        return None
    try:
        return json.loads(value.decode("utf-8"))
    except (json.JSONDecodeError, UnicodeDecodeError):
        return value.decode("utf-8", errors="ignore")


@task(retries=3, retry_delay_seconds=30)
def fetch_kafka_batch(topic: str, max_records: int = 1000) -> List[Dict[str, Any]]:
    logger = get_run_logger()
    bootstrap_servers = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
    group_id = os.getenv("KAFKA_CONSUMER_GROUP", "prefect-product-loader")

    consumer = KafkaConsumer(
        topic,
        bootstrap_servers=[s.strip() for s in bootstrap_servers.split(",")],
        group_id=group_id,
        auto_offset_reset=os.getenv("KAFKA_AUTO_OFFSET_RESET", "earliest"),
        enable_auto_commit=False,
        value_deserializer=lambda v: _deserialize(v),
        key_deserializer=lambda v: v.decode("utf-8") if v else None,
        consumer_timeout_ms=2000,
    )

    records: List[Dict[str, Any]] = []
    try:
        polled = consumer.poll(timeout_ms=1000, max_records=max_records)
        for partition_records in polled.values():
            for message in partition_records:
                record = {
                    "topic": message.topic,
                    "partition": message.partition,
                    "offset": message.offset,
                    "timestamp": message.timestamp,
                    "key": message.key,
                    "value": message.value,
                    "headers": [
                        {
                            "key": header[0],
                            "value": header[1].decode("utf-8", errors="ignore") if header[1] else None,
                        }
                        for header in (message.headers or [])
                    ],
                }
                records.append(record)
        logger.info("Fetched %s records from topic %s", len(records), topic)
        return records
    finally:
        consumer.close()


@task
def write_to_minio(records: Iterable[Dict[str, Any]], bucket: str, prefix: str) -> Dict[str, Any]:
    logger = get_run_logger()
    records_list = list(records)

    if not records_list:
        logger.info("No records fetched; skipping MinIO write.")
        return {"bucket": bucket, "key": None, "record_count": 0}

    client = MinioClientFactory.create()
    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    key = f"{prefix}/batch={timestamp}.jsonl"
    body = "\n".join(json.dumps(record) for record in records_list)

    client.put_object(
        Bucket=bucket,
        Key=key,
        Body=body.encode("utf-8"),
        ContentType="application/json",
    )

    logger.info("Wrote %s records to s3://%s/%s", len(records_list), bucket, key)
    return {"bucket": bucket, "key": key, "record_count": len(records_list)}


@flow
def kafka_to_minio_flow(
    topic: str = os.getenv("KAFKA_TOPIC", "cord.dbo.Product"),
    bucket: str = os.getenv("MINIO_RAW_BUCKET", "cord-raw"),
    prefix: str = "product/raw",
    max_records: int = 1000,
):
    records = fetch_kafka_batch(topic=topic, max_records=max_records)
    return write_to_minio(records=records, bucket=bucket, prefix=prefix)


if __name__ == "__main__":
    kafka_to_minio_flow()
