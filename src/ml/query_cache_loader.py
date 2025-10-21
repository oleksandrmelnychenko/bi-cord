"""
Query Embedding Cache Loader

Purpose: Pre-compute and cache embeddings for popular search queries
Performance Impact: Reduces query encoding from 2-3s to <5ms for cached queries

Usage:
    # Load from search analytics
    python -m src.ml.query_cache_loader --source=analytics --limit=1000

    # Load from manual list
    python -m src.ml.query_cache_loader --source=file --file=queries.txt

    # Load specific queries
    python -m src.ml.query_cache_loader --queries "тормозные колодки,brake pads,фільтр масляний"
"""

from __future__ import annotations

import argparse
import time
from typing import List, Dict, Optional
from dataclasses import dataclass

import torch
from sentence_transformers import SentenceTransformer
from psycopg2.extras import execute_values

from src.config import get_settings
from src.config.database import get_postgres_connection
from src.ml.embedding_pipeline_v2 import detect_device


@dataclass
class QueryCacheStats:
    """Statistics for cache loading operation"""
    queries_processed: int = 0
    queries_inserted: int = 0
    queries_updated: int = 0
    start_time: float = 0.0
    end_time: float = 0.0
    device: str = "cpu"

    @property
    def duration_seconds(self) -> float:
        return self.end_time - self.start_time

    @property
    def throughput_per_second(self) -> float:
        if self.duration_seconds > 0:
            return self.queries_processed / self.duration_seconds
        return 0.0

    def print_summary(self):
        print("\n" + "=" * 80)
        print("QUERY CACHE LOADER SUMMARY")
        print("=" * 80)
        print(f"Device: {self.device.upper()}")
        print(f"Queries Processed: {self.queries_processed:,}")
        print(f"Inserted: {self.queries_inserted:,}")
        print(f"Updated: {self.queries_updated:,}")
        print(f"Duration: {self.duration_seconds:.2f}s")
        print(f"Throughput: {self.throughput_per_second:.1f} queries/second")
        print("=" * 80 + "\n")


def load_model_for_caching(device: str) -> SentenceTransformer:
    """
    Load sentence transformer model optimized for batch encoding

    Args:
        device: Target device (cuda, mps, cpu)

    Returns:
        Loaded and optimized model
    """
    settings = get_settings()

    print(f"\nLoading model: {settings.ml.embedding_model}")
    print(f"Device: {device}")

    model = SentenceTransformer(settings.ml.embedding_model, device=device)

    if device == "cuda":
        model.half()
        print("Enabled FP16 mixed precision for GPU acceleration")

    _ = model.encode(["warm-up query"], show_progress_bar=False)
    print("Model loaded and ready\n")

    return model


def fetch_popular_queries_from_analytics(limit: int = 1000) -> List[str]:
    """
    Fetch most popular search queries from search analytics table

    Args:
        limit: Maximum number of queries to fetch

    Returns:
        List of popular query strings
    """
    with get_postgres_connection() as conn:
        cursor = conn.cursor()

        cursor.execute("""
            SELECT query_text, COUNT(*) as search_count
            FROM analytics_features.search_analytics
            WHERE query_text IS NOT NULL
                AND LENGTH(query_text) > 2
            GROUP BY query_text
            ORDER BY search_count DESC
            LIMIT %s
        """, (limit,))

        rows = cursor.fetchall()
        queries = [row[0] for row in rows if row[0]]

        print(f"Fetched {len(queries):,} popular queries from search analytics")
        return queries


def load_queries_from_file(file_path: str) -> List[str]:
    """
    Load queries from text file (one query per line)

    Args:
        file_path: Path to text file

    Returns:
        List of query strings
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        queries = [line.strip() for line in f if line.strip()]

    print(f"Loaded {len(queries):,} queries from file: {file_path}")
    return queries


def load_polish_keywords_from_db() -> set:
    """
    Load Polish keywords from database product_keyword_cache table

    Returns:
        Set of Polish words extracted from product polish_name column
    """
    try:
        with get_postgres_connection() as conn:
            cursor = conn.cursor()

            cursor.execute("""
                SELECT keyword
                FROM analytics_features.product_keyword_cache
                WHERE language = 'polish'
                    AND frequency >= 10
                ORDER BY frequency DESC
            """)

            rows = cursor.fetchall()
            polish_keywords = {row[0].lower() for row in rows if row[0]}

            print(f"Loaded {len(polish_keywords):,} Polish keywords from database for exclusion")
            return polish_keywords

    except Exception as e:
        print(f"Warning: Could not load Polish keywords from database: {e}")
        print("Falling back to character-based Polish detection only")
        return set()


# Global Polish keywords cache (loaded from database)
_POLISH_KEYWORDS_CACHE: Optional[set] = None


def classify_query_language(query: str, polish_keywords: Optional[set] = None) -> str:
    """
    Enhanced language classification based on character set and database-driven Polish keywords

    Detects and excludes Polish queries by checking against Polish words
    extracted from the product polish_name column

    Args:
        query: Query text
        polish_keywords: Optional set of Polish words (loaded from DB), if None will load automatically

    Returns:
        Language code: 'ukrainian', 'russian', 'polish', 'english', or 'unknown'
    """
    global _POLISH_KEYWORDS_CACHE

    # Polish-specific characters (ą, ć, ę, ł, ń, ó, ś, ź, ż)
    polish_chars = set('ąćęłńóśźżĄĆĘŁŃÓŚŹŻ')

    # Ukrainian-specific characters (і, ї, є, ґ)
    ukrainian_chars = set('іїєґІЇЄҐ')

    # General Cyrillic (shared by Russian, Ukrainian, Belarusian, etc.)
    cyrillic_general = set('абвгдежзийклмнопрстуфхцчшщъыьэюяАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ')

    # Russian-specific character (ы - not used in Ukrainian)
    russian_specific = set('ыъэЫЪЭ')

    # Load Polish keywords from database if not provided
    if polish_keywords is None:
        if _POLISH_KEYWORDS_CACHE is None:
            _POLISH_KEYWORDS_CACHE = load_polish_keywords_from_db()
        polish_keywords = _POLISH_KEYWORDS_CACHE

    query_lower = query.lower()
    query_chars = set(query_lower)
    query_words = query_lower.split()

    # Check for Polish special characters first (highest priority)
    if any(char in query_chars for char in polish_chars):
        return 'polish'

    # Check for Polish words from database (dynamic, comprehensive)
    if polish_keywords and any(word in polish_keywords for word in query_words):
        return 'polish'

    # Check for Ukrainian-specific characters
    if any(char in query_chars for char in ukrainian_chars):
        return 'ukrainian'

    # Check for Russian-specific characters
    if any(char in query_chars for char in russian_specific):
        return 'russian'

    # If contains general Cyrillic but no language-specific markers,
    # default to Ukrainian (our primary language)
    if any(char in query_chars for char in cyrillic_general):
        return 'ukrainian'

    # ASCII-only text
    if query.isascii() and len(query.strip()) > 0:
        return 'english'

    return 'unknown'


def upsert_query_embeddings_batch(
    queries: List[str],
    embeddings: List[List[float]],
    stats: QueryCacheStats
):
    """
    Upsert query embeddings into cache table in batch

    Filters out Polish and other excluded languages before inserting

    Args:
        queries: List of query texts
        embeddings: List of embedding vectors
        stats: Statistics tracker
    """
    if not queries:
        return

    # Excluded languages (Polish and others we don't want to cache)
    excluded_languages = {'polish', 'unknown'}

    with get_postgres_connection() as conn:
        cursor = conn.cursor()

        rows = []
        skipped_count = 0

        for query, embedding in zip(queries, embeddings):
            language = classify_query_language(query)

            # Skip Polish and unknown language queries
            if language in excluded_languages:
                skipped_count += 1
                print(f"  SKIPPING {language.upper()} query: '{query[:50]}...'")
                continue

            embedding_str = f"[{','.join(map(str, embedding))}]"
            rows.append((query, embedding_str, language))

        if rows:
            execute_values(
                cursor,
                """
                INSERT INTO analytics_features.query_embeddings (query_text, embedding, query_language)
                VALUES %s
                ON CONFLICT (query_text) DO UPDATE SET
                    embedding = EXCLUDED.embedding,
                    query_language = EXCLUDED.query_language,
                    updated_at = NOW()
                """,
                rows,
                template="(%s, %s::vector, %s)"
            )

            stats.queries_inserted += len(rows)

        if skipped_count > 0:
            print(f"  Skipped {skipped_count} excluded language queries")


def run_cache_loader(
    queries: List[str],
    batch_size: int = 32,
    device: Optional[str] = None
) -> QueryCacheStats:
    """
    Load query embeddings into cache

    Args:
        queries: List of queries to cache
        batch_size: Batch size for encoding
        device: Device override (None = auto-detect)

    Returns:
        Statistics for the operation
    """
    stats = QueryCacheStats()
    stats.start_time = time.time()

    if device is None:
        device = detect_device()
    stats.device = device

    model = load_model_for_caching(device)

    print(f"Processing {len(queries):,} queries in batches of {batch_size}\n")

    for i in range(0, len(queries), batch_size):
        batch_queries = queries[i:i + batch_size]

        embeddings = model.encode(
            batch_queries,
            batch_size=batch_size,
            show_progress_bar=False,
            convert_to_numpy=True
        )

        embeddings_list = [emb.tolist() for emb in embeddings]

        upsert_query_embeddings_batch(batch_queries, embeddings_list, stats)

        stats.queries_processed += len(batch_queries)

        if (i // batch_size + 1) % 10 == 0:
            print(f"Progress: {stats.queries_processed:,}/{len(queries):,} queries processed")

    stats.end_time = time.time()

    return stats


def main():
    """Main entry point for query cache loader"""
    parser = argparse.ArgumentParser(description="Load query embeddings into cache")
    parser.add_argument(
        "--source",
        choices=["analytics", "file", "manual"],
        default="manual",
        help="Source of queries"
    )
    parser.add_argument(
        "--file",
        type=str,
        help="Path to text file with queries (one per line)"
    )
    parser.add_argument(
        "--queries",
        type=str,
        help="Comma-separated list of queries"
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=1000,
        help="Maximum number of queries to load from analytics"
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=32,
        help="Batch size for encoding"
    )
    parser.add_argument(
        "--device",
        choices=["auto", "cuda", "mps", "cpu"],
        default="auto",
        help="Device for encoding (auto = auto-detect)"
    )

    args = parser.parse_args()

    print("\n" + "=" * 80)
    print("QUERY EMBEDDING CACHE LOADER")
    print("=" * 80)

    if args.source == "analytics":
        queries = fetch_popular_queries_from_analytics(limit=args.limit)
    elif args.source == "file":
        if not args.file:
            print("ERROR: --file required when --source=file")
            return
        queries = load_queries_from_file(args.file)
    elif args.source == "manual":
        if not args.queries:
            queries = [
                "тормозные колодки",
                "brake pads",
                "гвинт кріплення",
                "масляный фильтр",
                "амортизатор",
                "фільтр масляний",
                "klocki hamulcowe",
                "oil filter",
                "brake disc",
                "диск тормозной"
            ]
            print(f"Using default test queries: {len(queries)} queries")
        else:
            queries = [q.strip() for q in args.queries.split(",") if q.strip()]
            print(f"Loaded {len(queries)} queries from command line")
    else:
        print(f"Unknown source: {args.source}")
        return

    if not queries:
        print("No queries to process!")
        return

    device = args.device if args.device != "auto" else None

    stats = run_cache_loader(
        queries=queries,
        batch_size=args.batch_size,
        device=device
    )

    stats.print_summary()


if __name__ == "__main__":
    main()
