"""
Hybrid Search Module - Combines ALL Search Techniques

This module implements a production-grade hybrid search system that combines:
1. PostgreSQL Full-Text Search (GIN indexes, ts_rank)
2. Trigram Fuzzy Matching (similarity)
3. Vector Semantic Search (HNSW, cosine similarity)
4. Exact Text Matching (ILIKE)
5. ML Ensemble Ranking (all signals combined)
6. Popularity Boosting (click-through data)

Usage:
    from src.api.hybrid_search import hybrid_search
    results = await hybrid_search("brake pads", limit=20)
"""

from __future__ import annotations

import time
from typing import Dict, List, Any, Optional
import asyncio

import psycopg2
from psycopg2.extras import DictCursor
from sentence_transformers import SentenceTransformer

from src.ml.ranking import rank_search_results, RankingWeights, WEIGHT_PRESETS
from src.ml.query_normalizer import normalize_query
from src.config.database import get_postgres_connection


# Common SELECT fields for all search queries
PRODUCT_SELECT_FIELDS = """
    p.product_id,
    p.vendor_code,
    p.name,
    p.polish_name,
    p.ukrainian_name,
    p.supplier_name,
    p.weight,
    p.is_for_sale,
    p.is_for_web,
    p.has_image,
    p.total_available_amount,
    p.storage_count,
    p.original_number_ids,
    p.analogue_product_ids,
    p.availability_score,
    p.freshness_score
"""


def get_db_connection():
    """
    Create database connection using centralized configuration

    DEPRECATED: Use get_postgres_connection() context manager instead
    """
    from src.config import get_settings
    settings = get_settings()

    return psycopg2.connect(
        host=settings.postgres.host,
        port=settings.postgres.port,
        database=settings.postgres.database,
        user=settings.postgres.user,
        password=settings.postgres.password,
    )


async def full_text_search(
    query: str,
    limit: int = 20,
) -> List[Dict[str, Any]]:
    """
    PostgreSQL Full-Text Search using GIN index with word-order invariant OR logic

    Normalizes query words and uses OR logic to handle:
    - Word order variations ("Гвинт кріплення" = "кріплення гвинта")
    - Grammatical cases ("гвинт" = "гвинта")
    - Ukrainian/Russian variants

    Returns products ranked by ts_rank_cd with boosting for products containing all words
    """
    with get_db_connection() as conn:
        cursor: DictCursor = conn.cursor(cursor_factory=DictCursor)

        normalized_words: List[str] = normalize_query(query, expand_cases=True)

        if not normalized_words:
            return []

        tsquery: str = ' | '.join(normalized_words)

        # TODO: Switch to dim_product_search after dbt build (has denormalized fields)
        sql: str = f"""
            SELECT
                {PRODUCT_SELECT_FIELDS},
                ts_rank_cd(p.search_vector, to_tsquery('simple', %s)) as fulltext_rank,
                0.0 as exact_match_score,
                0.0 as trigram_similarity,
                0.0 as similarity_score
            FROM staging_marts.dim_product p
            WHERE p.search_vector @@ to_tsquery('simple', %s)
            ORDER BY fulltext_rank DESC
            LIMIT %s
        """

        cursor.execute(sql, (tsquery, tsquery, limit * 2))  # Fetch more for reranking
        rows: List[Dict] = []
        for row in cursor.fetchall():
            product: Dict = dict(row)
            product['fulltext_rank'] = float(product.get('fulltext_rank', 0.0))
            product['exact_match_score'] = float(product.get('exact_match_score', 0.0))
            product['trigram_similarity'] = float(product.get('trigram_similarity', 0.0))
            product['similarity_score'] = float(product.get('similarity_score', 0.0))
            product['weight'] = float(product.get('weight', 0.0)) if product.get('weight') is not None else 0.0
            rows.append(product)
        return rows


async def trigram_fuzzy_search(
    query: str,
    limit: int = 20,
) -> List[Dict[str, Any]]:
    """
    Trigram Fuzzy Matching for typo-tolerant search

    Uses PostgreSQL pg_trgm extension
    """
    with get_db_connection() as conn:
        cursor: DictCursor = conn.cursor(cursor_factory=DictCursor)

        sql: str = f"""
            SELECT
                {PRODUCT_SELECT_FIELDS},
                GREATEST(
                    similarity(p.vendor_code, %s),
                    similarity(p.name, %s),
                    similarity(p.polish_name, %s),
                    similarity(p.ukrainian_name, %s)
                ) as trigram_similarity,
                0.0 as fulltext_rank,
                0.0 as exact_match_score,
                0.0 as similarity_score
            FROM staging_marts.dim_product p
            WHERE
                p.vendor_code %% %s
                OR p.name %% %s
                OR p.polish_name %% %s
                OR p.ukrainian_name %% %s
            ORDER BY trigram_similarity DESC
            LIMIT %s
        """

        cursor.execute(sql, (query, query, query, query, query, query, query, query, limit * 2))
        rows: List[Dict] = []
        for row in cursor.fetchall():
            product: Dict = dict(row)
            product['fulltext_rank'] = float(product.get('fulltext_rank', 0.0))
            product['exact_match_score'] = float(product.get('exact_match_score', 0.0))
            product['trigram_similarity'] = float(product.get('trigram_similarity', 0.0))
            product['similarity_score'] = float(product.get('similarity_score', 0.0))
            product['weight'] = float(product.get('weight', 0.0)) if product.get('weight') is not None else 0.0
            rows.append(product)
        return rows


async def exact_match_search(
    query: str,
    limit: int = 20,
) -> List[Dict[str, Any]]:
    """
    Fast exact/partial text matching with word-order invariance

    Normalizes query words and searches for individual words with boosting:
    - Products containing ALL query words get highest scores
    - Vendor code matches get priority
    - Individual word matches get progressively lower scores

    Returns results with exact_match_score
    """
    with get_db_connection() as conn:
        cursor: DictCursor = conn.cursor(cursor_factory=DictCursor)

        normalized_words: List[str] = normalize_query(query, expand_cases=True)

        if not normalized_words:
            return []

        word_patterns: List[str] = [f"%{word}%" for word in normalized_words]

        vendor_conditions: List[str] = [f"p.vendor_code ILIKE %s" for _ in word_patterns]
        name_conditions: List[str] = [f"p.name ILIKE %s" for _ in word_patterns]
        polish_conditions: List[str] = [f"p.polish_name ILIKE %s" for _ in word_patterns]
        ukrainian_conditions: List[str] = [f"p.ukrainian_name ILIKE %s" for _ in word_patterns]

        all_conditions: str = " OR ".join(
            vendor_conditions + name_conditions + polish_conditions + ukrainian_conditions
        )

        word_match_score: str = " + ".join([
            f"CASE WHEN (p.vendor_code ILIKE %s OR p.name ILIKE %s OR p.polish_name ILIKE %s OR p.ukrainian_name ILIKE %s) THEN 1 ELSE 0 END"
            for _ in word_patterns
        ])

        sql: str = f"""
            SELECT
                {PRODUCT_SELECT_FIELDS},
                GREATEST(
                    CASE WHEN ({' OR '.join(vendor_conditions)}) THEN 1.0 ELSE 0.0 END,
                    CASE WHEN ({' OR '.join(name_conditions)}) THEN 0.95 ELSE 0.0 END,
                    CASE WHEN ({' OR '.join(polish_conditions)}) THEN 0.90 ELSE 0.0 END,
                    CASE WHEN ({' OR '.join(ukrainian_conditions)}) THEN 0.90 ELSE 0.0 END
                ) + (({word_match_score}) * 0.05) AS exact_match_score,
                0.0 as fulltext_rank,
                0.0 as trigram_similarity,
                0.0 as similarity_score
            FROM staging_marts.dim_product p
            WHERE {all_conditions}
            ORDER BY exact_match_score DESC
            LIMIT %s
        """

        params: List[str] = (
            word_patterns * 4 +  # WHERE clause
            word_patterns * 4 +  # GREATEST clause (vendor, name, polish, ukrainian)
            word_patterns * 4 +  # word_match_score
            [limit * 2]
        )

        cursor.execute(sql, params)
        rows: List[Dict] = []
        for row in cursor.fetchall():
            product: Dict = dict(row)
            product['fulltext_rank'] = float(product.get('fulltext_rank', 0.0))
            product['exact_match_score'] = float(product.get('exact_match_score', 0.0))
            product['trigram_similarity'] = float(product.get('trigram_similarity', 0.0))
            product['similarity_score'] = float(product.get('similarity_score', 0.0))
            product['weight'] = float(product.get('weight', 0.0)) if product.get('weight') is not None else 0.0
            rows.append(product)
        return rows


async def vector_semantic_search(
    query: str,
    model: SentenceTransformer,
    limit: int = 20,
) -> List[Dict[str, Any]]:
    """
    Vector semantic search using HNSW index

    Returns results with similarity_score
    """
    # Generate query embedding
    query_embedding: List[float] = model.encode(query).tolist()

    with get_db_connection() as conn:
        cursor: DictCursor = conn.cursor(cursor_factory=DictCursor)

        sql: str = f"""
            SELECT
                {PRODUCT_SELECT_FIELDS},
                1 - (e.embedding <=> %s::vector) as similarity_score,
                0.0 as exact_match_score,
                0.0 as fulltext_rank,
                0.0 as trigram_similarity
            FROM analytics_features.product_embeddings e
            JOIN staging_marts.dim_product p ON e.product_id = p.product_id
            ORDER BY e.embedding <=> %s::vector
            LIMIT %s
        """

        cursor.execute(sql, (query_embedding, query_embedding, limit * 2))
        rows: List[Dict] = []
        for row in cursor.fetchall():
            product: Dict = dict(row)
            product['fulltext_rank'] = float(product.get('fulltext_rank', 0.0))
            product['exact_match_score'] = float(product.get('exact_match_score', 0.0))
            product['trigram_similarity'] = float(product.get('trigram_similarity', 0.0))
            product['similarity_score'] = float(product.get('similarity_score', 0.0))
            product['weight'] = float(product.get('weight', 0.0)) if product.get('weight') is not None else 0.0
            rows.append(product)
        return rows


async def fetch_popularity_scores(product_ids: List[int]) -> Dict[int, Dict]:
    """Fetch popularity scores for given product IDs"""
    if not product_ids:
        return {}

    with get_db_connection() as conn:
        cursor: DictCursor = conn.cursor(cursor_factory=DictCursor)

        sql: str = """
            SELECT
                product_id,
                view_count,
                click_count,
                conversion_count,
                popularity_score,
                trending_score
            FROM analytics_features.product_popularity_scores
            WHERE product_id = ANY(%s)
        """

        cursor.execute(sql, (product_ids,))
        rows: List[Dict] = [dict(row) for row in cursor.fetchall()]

        return {row['product_id']: row for row in rows}


async def hybrid_search(
    query: str,
    model: SentenceTransformer,
    limit: int = 20,
    weights: Optional[RankingWeights] = None,
    enable_fulltext: bool = True,
    enable_trigram: bool = True,
    enable_exact: bool = True,
    enable_vector: bool = True,
) -> Dict[str, Any]:
    """
    Hybrid Search combining ALL techniques

    Runs all search methods in parallel, merges results, and applies ML ranking

    Args:
        query: Search query string
        model: SentenceTransformer model for vector search
        limit: Number of results to return
        weights: Optional custom ranking weights
        enable_*: Flags to enable/disable specific search techniques

    Returns:
        Dict with query, results, execution time, and technique breakdown
    """
    start_time: float = time.time()

    # Run all search techniques in PARALLEL
    tasks: List[asyncio.Task] = []

    if enable_fulltext:
        tasks.append(asyncio.create_task(full_text_search(query, limit)))
    if enable_trigram:
        tasks.append(asyncio.create_task(trigram_fuzzy_search(query, limit)))
    if enable_exact:
        tasks.append(asyncio.create_task(exact_match_search(query, limit)))
    if enable_vector:
        tasks.append(asyncio.create_task(vector_semantic_search(query, model, limit)))

    # Wait for all searches to complete
    search_results: List[List[Dict]] = await asyncio.gather(*tasks)

    # Merge results by product_id (keeping best scores for each product)
    merged_results: Dict[int, Dict[str, Any]] = {}

    for result_set in search_results:
        for product in result_set:
            product_id: int = product['product_id']

            if product_id not in merged_results:
                merged_results[product_id] = product
            else:
                # Merge scores - keep maximum for each signal
                existing: Dict = merged_results[product_id]
                existing['exact_match_score'] = max(
                    existing.get('exact_match_score', 0.0),
                    product.get('exact_match_score', 0.0)
                )
                existing['fulltext_rank'] = max(
                    existing.get('fulltext_rank', 0.0),
                    product.get('fulltext_rank', 0.0)
                )
                existing['trigram_similarity'] = max(
                    existing.get('trigram_similarity', 0.0),
                    product.get('trigram_similarity', 0.0)
                )
                existing['similarity_score'] = max(
                    existing.get('similarity_score', 0.0),
                    product.get('similarity_score', 0.0)
                )

    # Convert to list
    results_list: List[Dict] = list(merged_results.values())

    # Fetch popularity scores
    product_ids: List[int] = [r['product_id'] for r in results_list]
    popularity_data: Dict[int, Dict] = await fetch_popularity_scores(product_ids)

    # Add popularity scores to results
    for result in results_list:
        pop_data: Dict = popularity_data.get(result['product_id'], {})
        result['click_count'] = pop_data.get('click_count', 0)
        result['view_count'] = pop_data.get('view_count', 0)
        result['conversion_count'] = pop_data.get('conversion_count', 0)

    # Apply ML ensemble ranking
    ranked_results: List[Dict] = rank_search_results(results_list, weights)

    # Trim to requested limit
    final_results: List[Dict] = ranked_results[:limit]

    execution_time_ms: float = (time.time() - start_time) * 1000

    return {
        "query": query,
        "total_results": len(final_results),
        "execution_time_ms": round(execution_time_ms, 2),
        "techniques_used": {
            "fulltext": enable_fulltext,
            "trigram": enable_trigram,
            "exact_match": enable_exact,
            "vector_semantic": enable_vector,
        },
        "results": final_results,
    }
