"""Embedding pipeline prototype.

Reads product text from the staging layer and writes embeddings to pgvector.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

import psycopg2
from psycopg2.extras import DictCursor, execute_values
from sentence_transformers import SentenceTransformer


@dataclass
class PgVectorConfig:
    host: str = os.getenv("PGVECTOR_HOST", "localhost")
    port: int = int(os.getenv("PGVECTOR_PORT", "5433"))
    database: str = os.getenv("PGVECTOR_DATABASE", "analytics")
    user: str = os.getenv("PGVECTOR_USER", "analytics")
    password: str = os.getenv("PGVECTOR_PASSWORD", "analytics")
    schema: str = os.getenv("PGVECTOR_SCHEMA", "analytics_features")
    table: str = os.getenv("PGVECTOR_TABLE", "product_embeddings")
    embedding_dim: int = int(os.getenv("PGVECTOR_EMBEDDING_DIM", "384"))

    @property
    def qualified_table(self) -> str:
        return f"{self.schema}.{self.table}"


EXCLUDE_COLUMNS = {"product_id", "updated_at", "created_at", "deleted"}


def fetch_products(limit: int = 1000) -> list[dict]:
    conn = psycopg2.connect(
        host=os.getenv("STAGING_DB_HOST", "localhost"),
        port=int(os.getenv("STAGING_DB_PORT", "5433")),
        dbname=os.getenv("STAGING_DB_NAME", "analytics"),
        user=os.getenv("STAGING_DB_USER", "analytics"),
        password=os.getenv("STAGING_DB_PASSWORD", "analytics"),
    )
    try:
        with conn.cursor(cursor_factory=DictCursor) as cur:
            cur.execute(
                """
                select *
                from staging_staging.stg_product
                order by ingested_at desc
                limit %s
                """,
                (limit,),
            )
            rows = cur.fetchall()
            products: list[dict] = []
            for row in rows:
                data = dict(row)
                if not data.get("product_id"):
                    continue
                products.append(data)
            return products
    finally:
        conn.close()


def ensure_table(config: PgVectorConfig):
    from psycopg2 import sql

    conn = psycopg2.connect(
        host=config.host,
        port=config.port,
        dbname=config.database,
        user=config.user,
        password=config.password,
    )
    try:
        with conn.cursor() as cur:
            cur.execute(
                sql.SQL("CREATE SCHEMA IF NOT EXISTS {}").format(sql.Identifier(config.schema))
            )
            cur.execute(
                sql.SQL(
                    """
                    CREATE TABLE IF NOT EXISTS {table} (
                        product_id bigint PRIMARY KEY,
                        embedding vector(%s),
                        updated_at timestamp DEFAULT now()
                    )
                    """
                ).format(table=sql.Identifier(config.schema, config.table)),
                (config.embedding_dim,),
            )
            conn.commit()
    finally:
        conn.close()


def build_text(product: dict) -> str:
    parts: list[str] = []
    for key, value in product.items():
        if key in EXCLUDE_COLUMNS:
            continue
        if value is None:
            continue
        text = ""
        if isinstance(value, (int, float)):
            text = f"{key}: {value}"
        elif isinstance(value, bool):
            text = f"{key}: {'yes' if value else 'no'}"
        else:
            v = str(value).strip()
            if not v:
                continue
            text = f"{key}: {v}"
        parts.append(text)
    return ". ".join(parts)


def upsert_embeddings(records, embeddings, config: PgVectorConfig):
    from psycopg2 import sql

    conn = psycopg2.connect(
        host=config.host,
        port=config.port,
        dbname=config.database,
        user=config.user,
        password=config.password,
    )
    try:
        with conn.cursor() as cur:
            rows = [
                (product["product_id"], embedding.tolist())
                for product, embedding in zip(records, embeddings)
            ]
            insert_sql = sql.SQL(
                """
                INSERT INTO {table} (product_id, embedding)
                VALUES %s
                ON CONFLICT (product_id) DO UPDATE SET
                    embedding = excluded.embedding,
                    updated_at = now()
                """
            ).format(table=sql.Identifier(config.schema, config.table))
            execute_values(
                cur,
                insert_sql.as_string(cur),
                rows,
            )
        conn.commit()
    finally:
        conn.close()


def main(limit: int = 1000):
    config = PgVectorConfig()
    products = fetch_products(limit=limit)
    if not products:
        print("No products fetched for embedding generation.")
        return

    texts = [build_text(product) for product in products]
    products = [
        product for product, text in zip(products, texts) if text.strip()
    ]
    texts = [text for text in texts if text.strip()]

    if not texts:
        print("No textual content available for embeddings.")
        return

    model_name = os.getenv("EMBEDDING_MODEL", "sentence-transformers/all-MiniLM-L6-v2")
    model_path = os.getenv("EMBEDDING_MODEL_PATH")
    cache_dir = os.getenv("EMBEDDING_MODEL_CACHE_DIR")
    device = os.getenv("EMBEDDING_DEVICE", "cpu")
    model_kwargs = {"device": device}
    if cache_dir:
        model_kwargs["cache_folder"] = cache_dir
    if model_path and Path(model_path).exists():
        model = SentenceTransformer(model_path, **model_kwargs)
    else:
        model = SentenceTransformer(model_name, **model_kwargs)

    batch_size = int(os.getenv("EMBEDDING_BATCH_SIZE", "32"))
    embeddings = model.encode(texts, batch_size=batch_size, show_progress_bar=True)
    embedding_dim = len(embeddings[0])
    if embedding_dim != config.embedding_dim:
        raise ValueError(
            f"Configured embedding dimension ({config.embedding_dim}) does not match model output ({embedding_dim}). "
            "Update PGVECTOR_EMBEDDING_DIM or choose a model with matching dimensionality."
        )

    ensure_table(config)

    upsert_embeddings(products, embeddings, config)
    print(f"Generated embeddings for {len(products)} products.")


if __name__ == "__main__":
    main()
