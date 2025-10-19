"""
Direct SQL Server to PostgreSQL Bronze Loader
Purpose: Bulk load products directly from SQL Server to Bronze layer, bypassing Kafka
Date: 2025-10-19
"""

import pymssql
import psycopg2
from psycopg2.extras import execute_batch
import json
from datetime import datetime
from uuid import UUID
import base64
import sys

# SQL Server connection details
SQLSERVER_CONFIG = {
    'host': '78.152.175.67',
    'port': 1433,
    'user': 'ef_migrator',
    'password': 'Grimm_jow92',
    'database': 'ConcordDb'
}

# PostgreSQL connection details
POSTGRES_CONFIG = {
    'host': 'localhost',
    'port': 5433,
    'user': 'analytics',
    'password': 'analytics',
    'database': 'analytics'
}

def create_bronze_table(pg_conn):
    """Ensure Bronze table exists with proper schema"""
    cursor = pg_conn.cursor()

    cursor.execute("""
        CREATE SCHEMA IF NOT EXISTS bronze;
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS bronze.product_cdc (
            id BIGSERIAL PRIMARY KEY,
            kafka_topic VARCHAR(255),
            kafka_partition INT,
            kafka_offset BIGINT,
            cdc_payload JSONB NOT NULL,
            ingested_at TIMESTAMP DEFAULT NOW(),
            UNIQUE(kafka_topic, kafka_partition, kafka_offset)
        );
    """)

    cursor.execute("""
        CREATE INDEX IF NOT EXISTS idx_product_cdc_payload
        ON bronze.product_cdc USING gin(cdc_payload);
    """)

    pg_conn.commit()
    cursor.close()
    print("✅ Bronze table ready")


def fetch_products_from_sqlserver(batch_size=5000):
    """Fetch all products from SQL Server in batches"""
    print(f"📡 Connecting to SQL Server: {SQLSERVER_CONFIG['host']}")

    conn = pymssql.connect(
        server=SQLSERVER_CONFIG['host'],
        port=SQLSERVER_CONFIG['port'],
        user=SQLSERVER_CONFIG['user'],
        password=SQLSERVER_CONFIG['password'],
        database=SQLSERVER_CONFIG['database']
    )

    cursor = conn.cursor(as_dict=True)

    # Get total count first
    cursor.execute("SELECT COUNT(*) as total FROM dbo.Product")
    total_count = cursor.fetchone()['total']
    print(f"📊 Total products in SQL Server: {total_count:,}")

    # Fetch all products
    query = """
        SELECT
            [ID], [Created], [Deleted], [Description], [HasAnalogue],
            [HasImage], [IsForSale], [IsForWeb], [IsForZeroSale],
            [MainOriginalNumber], [MeasureUnitID], [Name], [NetUID],
            [OrderStandard], [PackingStandard], [Size], [UCGFEA],
            [Updated], [VendorCode], [Volume], [Weight], [HasComponent],
            [Image], [Top], [DescriptionPL], [DescriptionUA], [NamePL],
            [NameUA], [SourceAmgID], [SourceFenixID], [SearchDescriptionPL],
            [SearchNamePL], [NotesPL], [NotesUA], [SearchDescriptionUA],
            [SearchNameUA], [SearchSize], [SearchVendorCode],
            [SearchDescription], [SearchName], [SearchSynonymsPL],
            [SearchSynonymsUA], [SynonymsPL], [SynonymsUA], [Standard],
            [ParentAmgID], [ParentFenixID], [SourceAmgCode], [SourceFenixCode]
        FROM dbo.Product
        ORDER BY ID
    """

    cursor.execute(query)

    batch = []
    total_fetched = 0

    while True:
        rows = cursor.fetchmany(batch_size)
        if not rows:
            break

        for row in rows:
            # Convert datetime, UUID, and bytes objects to JSON-serializable types
            for key, value in row.items():
                if isinstance(value, datetime):
                    # Convert datetime to milliseconds since epoch (Debezium format)
                    row[key] = int(value.timestamp() * 1000)
                elif isinstance(value, UUID):
                    row[key] = str(value)
                elif isinstance(value, bytes):
                    # Convert bytes to base64 string for JSON serialization
                    row[key] = base64.b64encode(value).decode('utf-8')

            batch.append(row)
            total_fetched += 1

        if len(batch) >= batch_size:
            yield batch
            batch = []

        if total_fetched % 50000 == 0:
            print(f"  📥 Fetched {total_fetched:,} / {total_count:,} products...")

    if batch:
        yield batch

    cursor.close()
    conn.close()
    print(f"✅ Fetched all {total_fetched:,} products from SQL Server")


def load_to_bronze(pg_conn, products, batch_offset):
    """Load products to Bronze layer as CDC events"""
    cursor = pg_conn.cursor()

    # Prepare CDC payloads in Debezium format
    records = []
    for idx, product in enumerate(products):
        # Create Debezium-compatible CDC payload
        cdc_payload = {
            "schema": {
                "type": "struct",
                "fields": [],
                "optional": False,
                "name": "cord.ConcordDb.dbo.Product.Envelope"
            },
            "payload": {
                "before": None,
                "after": product,
                "source": {
                    "version": "2.1.0.Final",
                    "connector": "sqlserver",
                    "name": "cord",
                    "ts_ms": int(datetime.utcnow().timestamp() * 1000),
                    "snapshot": "true",
                    "db": "ConcordDb",
                    "schema": "dbo",
                    "table": "Product",
                    "change_lsn": None,
                    "commit_lsn": "00001ed0:00004b2e:0001"
                },
                "op": "r",  # Read operation (snapshot)
                "ts_ms": int(datetime.utcnow().timestamp() * 1000),
                "transaction": None
            }
        }

        # Simulate Kafka metadata
        kafka_topic = "cord.ConcordDb.dbo.Product"
        kafka_partition = 0
        kafka_offset = batch_offset + idx

        records.append((
            kafka_topic,
            kafka_partition,
            kafka_offset,
            json.dumps(cdc_payload)
        ))

    # Batch insert with ON CONFLICT DO NOTHING (deduplication)
    insert_query = """
        INSERT INTO bronze.product_cdc
            (kafka_topic, kafka_partition, kafka_offset, cdc_payload)
        VALUES (%s, %s, %s, %s::jsonb)
        ON CONFLICT (kafka_topic, kafka_partition, kafka_offset) DO NOTHING
    """

    execute_batch(cursor, insert_query, records, page_size=1000)
    pg_conn.commit()
    cursor.close()

    return len(records)


def main():
    """Main execution function"""
    print("=" * 80)
    print("🚀 Direct SQL Server → PostgreSQL Bronze Loader")
    print("=" * 80)
    print()

    # Connect to PostgreSQL
    print("📡 Connecting to PostgreSQL...")
    pg_conn = psycopg2.connect(**POSTGRES_CONFIG)
    print("✅ Connected to PostgreSQL")
    print()

    # Ensure Bronze table exists
    create_bronze_table(pg_conn)
    print()

    # Load products
    total_loaded = 0
    batch_number = 0
    global_offset = 0

    print("🔄 Starting data transfer...")
    print()

    try:
        for batch in fetch_products_from_sqlserver(batch_size=5000):
            batch_number += 1
            loaded = load_to_bronze(pg_conn, batch, global_offset)
            total_loaded += loaded
            global_offset += len(batch)

            if batch_number % 10 == 0:
                print(f"  ✅ Batch {batch_number}: Loaded {total_loaded:,} products")

        print()
        print("=" * 80)
        print(f"🎉 SUCCESS! Loaded {total_loaded:,} products to Bronze layer")
        print("=" * 80)
        print()

        # Verify count
        cursor = pg_conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM bronze.product_cdc")
        bronze_count = cursor.fetchone()[0]
        cursor.close()

        print(f"📊 Verification:")
        print(f"   Bronze table: {bronze_count:,} CDC events")
        print()

        # Get unique products count
        cursor = pg_conn.cursor()
        cursor.execute("""
            SELECT COUNT(DISTINCT (cdc_payload->'payload'->'after'->>'ID')::bigint)
            FROM bronze.product_cdc
            WHERE cdc_payload->'payload'->>'op' != 'd'
        """)
        unique_products = cursor.fetchone()[0]
        cursor.close()

        print(f"   Unique products: {unique_products:,}")
        print()

        print("✅ Next steps:")
        print("   1. Run dbt: dbt run --select stg_product dim_product")
        print("   2. Generate embeddings: ./venv-py311/bin/python src/ml/embedding_pipeline.py")
        print()

    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

    finally:
        pg_conn.close()


if __name__ == "__main__":
    main()
