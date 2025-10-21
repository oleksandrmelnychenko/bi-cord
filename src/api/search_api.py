"""
FastAPI Semantic Search API for Product Catalog
Purpose: Production-ready REST API for AI-powered product search
Date: 2025-10-19
Requirements: FastAPI, sentence-transformers, psycopg2, pgvector
"""

from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any, Set, Tuple
from sentence_transformers import SentenceTransformer
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2.pool import SimpleConnectionPool
import os
from contextlib import contextmanager
import logging
import re
import time
from enum import Enum
import torch

from dataclasses import dataclass
from src.ml.ranking import RankingWeights, WEIGHT_PRESETS

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Product Semantic Search API",
    description="AI-powered product search using semantic embeddings and hybrid search",
    version="2.0.0"
)

# Global keyword cache (loaded from database on startup)
DYNAMIC_KEYWORDS: Dict[str, List[str]] = {
    "ukrainian": [],
    "polish": []
}

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database configuration
DB_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "localhost"),
    "port": int(os.getenv("POSTGRES_PORT", "5433")),
    "database": os.getenv("POSTGRES_DB", "analytics"),
    "user": os.getenv("POSTGRES_USER", "analytics"),
    "password": os.getenv("POSTGRES_PASSWORD", "analytics")
}

# Model configuration
MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"
EMBEDDING_DIM = 384
ZERO_VECTOR = [0.0] * EMBEDDING_DIM

# Global model instance (loaded once at startup)
embedding_model: Optional[SentenceTransformer] = None
db_pool: Optional[SimpleConnectionPool] = None


# ============================================================================
# Request/Response Models
# ============================================================================

class SearchRequest(BaseModel):
    """Unified request model for adaptive product search"""
    query: str = Field(..., description="Natural language search query", min_length=1, max_length=500)
    supplier_name: Optional[str] = Field(None, description="Filter by supplier name (e.g., 'SEM1', 'SABO')")
    weight_min: Optional[float] = Field(None, description="Minimum product weight in kg", ge=0)
    weight_max: Optional[float] = Field(None, description="Maximum product weight in kg", ge=0)
    is_for_sale: Optional[bool] = Field(None, description="Filter by for_sale status")
    is_for_web: Optional[bool] = Field(None, description="Filter by web availability")
    has_image: Optional[bool] = Field(None, description="Filter by image availability")
    limit: int = Field(20, description="Maximum number of results", ge=1, le=100)
    offset: int = Field(0, description="Number of leading results to skip", ge=0)
    weight_preset: Optional[str] = Field(
        None,
        description="Ranking weight preset override: balanced, exact_priority, semantic_priority, popularity_priority"
    )


class ProductResult(BaseModel):
    """Response model for a single product"""
    product_id: int
    vendor_code: Optional[str]
    name: Optional[str]
    ukrainian_name: Optional[str]
    main_original_number: Optional[str]
    supplier_name: Optional[str]
    weight: Optional[float]
    is_for_sale: Optional[bool]
    is_for_web: Optional[bool]
    has_image: Optional[bool]
    has_analogue: Optional[bool]
    similarity_score: float
    ranking_score: Optional[float] = None

    # Enhanced fields from dim_product_search
    total_available_amount: Optional[float] = None
    storage_count: Optional[int] = None
    original_number_ids: Optional[List[int]] = None
    analogue_product_ids: Optional[List[int]] = None
    availability_score: Optional[float] = None
    freshness_score: Optional[float] = None


class SearchResponse(BaseModel):
    """Response model for search results"""
    query: str
    total_results: int
    execution_time_ms: float
    results: List[ProductResult]
    search_id: Optional[int] = None  # Added for click tracking


class ClickTrackingRequest(BaseModel):
    """Request model for click tracking"""
    search_id: int = Field(..., description="ID of the search query from search_query_log")
    product_id: int = Field(..., description="ID of the clicked product")
    rank_position: int = Field(..., description="Position of product in search results (1-indexed)", ge=1)
    click_timestamp: Optional[str] = Field(None, description="ISO timestamp of click (server-side if not provided)")


class FeedbackRequest(BaseModel):
    """Request model for search feedback"""
    search_id: int = Field(..., description="ID of the search query")
    feedback_type: str = Field(..., description="Type of feedback: 'helpful', 'not_helpful', 'no_results', 'irrelevant'")
    comment: Optional[str] = Field(None, description="Optional user comment", max_length=500)


class ClickTrackingResponse(BaseModel):
    """Response model for click tracking"""
    success: bool
    message: str
    click_id: Optional[int] = None


class FeedbackResponse(BaseModel):
    """Response model for feedback submission"""
    success: bool
    message: str


@dataclass
class SearchFilters:
    supplier_name: Optional[str] = None
    weight_min: Optional[float] = None
    weight_max: Optional[float] = None
    is_for_sale: Optional[bool] = None
    is_for_web: Optional[bool] = None
    has_image: Optional[bool] = None
    vendor_code_query: Optional[str] = None


def _build_filter_clause(filters: Optional[SearchFilters], alias: str = "p") -> Tuple[str, List[Any]]:
    clauses: List[str] = []
    params: List[Any] = []

    if filters is None:
        return "", params

    if filters.supplier_name:
        clauses.append(f"{alias}.supplier_name = %s")
        params.append(filters.supplier_name)

    if filters.weight_min is not None:
        clauses.append(f"{alias}.weight >= %s")
        params.append(filters.weight_min)

    if filters.weight_max is not None:
        clauses.append(f"({alias}.weight <= %s)")
        params.append(filters.weight_max)

    if filters.is_for_sale is not None:
        clauses.append(f"{alias}.is_for_sale = %s")
        params.append(filters.is_for_sale)

    if filters.is_for_web is not None:
        clauses.append(f"{alias}.is_for_web = %s")
        params.append(filters.is_for_web)

    if filters.has_image is not None:
        clauses.append(f"{alias}.has_image = %s")
        params.append(filters.has_image)

    if filters.vendor_code_query:
        clauses.append(f"{alias}.vendor_code ILIKE %s")
        params.append(f"%{filters.vendor_code_query}%")

    if not clauses:
        return "", params

    return " AND " + " AND ".join(clauses), params


UNIFIED_SEARCH_SQL_TEMPLATE = """
WITH filtered_products AS (
    SELECT
        p.product_id,
        p.vendor_code,
        p.name,
        p.ukrainian_name,
        p.main_original_number,
        p.supplier_name,
        p.weight,
        p.is_for_sale,
        p.is_for_web,
        p.has_image,
        p.has_analogue,
        p.search_vector,
        p.created,
        p.updated
    FROM staging_marts.dim_product p
    WHERE p.deleted = false {filter_clause}
),
vector_candidates AS (
    SELECT
        fp.product_id,
        1 - (e.embedding <=> %s::vector) AS vector_score,
        0.0::float AS fulltext_score,
        0.0::float AS trigram_score,
        0.0::float AS exact_score
    FROM filtered_products fp
    JOIN analytics_features.product_embeddings e ON e.product_id = fp.product_id
    ORDER BY e.embedding <=> %s::vector
    LIMIT %s
),
fulltext_candidates AS (
    SELECT
        fp.product_id,
        0.0 AS vector_score,
        ts_rank_cd(fp.search_vector, plainto_tsquery('simple', %s)) AS fulltext_score,
        0.0 AS trigram_score,
        0.0 AS exact_score
    FROM filtered_products fp
    WHERE fp.search_vector @@ plainto_tsquery('simple', %s)
    ORDER BY fulltext_score DESC
    LIMIT %s
),
trigram_candidates AS (
    SELECT
        fp.product_id,
        0.0 AS vector_score,
        0.0 AS fulltext_score,
        GREATEST(
            similarity(fp.vendor_code, %s),
            similarity(fp.name, %s),
            similarity(fp.ukrainian_name, %s),
            similarity(COALESCE(fp.main_original_number, ''), %s)
        ) AS trigram_score,
        0.0 AS exact_score
    FROM filtered_products fp
    ORDER BY trigram_score DESC
    LIMIT %s
),
exact_candidates AS (
    SELECT
        fp.product_id,
        0.0 AS vector_score,
        0.0 AS fulltext_score,
        0.0 AS trigram_score,
        GREATEST(
            CASE WHEN fp.vendor_code ILIKE %s THEN 1.0 ELSE 0.0 END,
            CASE WHEN fp.name ILIKE %s THEN 0.95 ELSE 0.0 END,
            CASE WHEN fp.ukrainian_name ILIKE %s THEN 0.90 ELSE 0.0 END,
            CASE WHEN LOWER(COALESCE(fp.main_original_number,'')) = LOWER(%s) THEN 1.0 ELSE 0.0 END
        ) AS exact_score
    FROM filtered_products fp
    ORDER BY exact_score DESC
    LIMIT %s
),
unioned AS (
    SELECT * FROM vector_candidates
    UNION ALL
    SELECT * FROM fulltext_candidates
    UNION ALL
    SELECT * FROM trigram_candidates
    UNION ALL
    SELECT * FROM exact_candidates
),
aggregated AS (
    SELECT
        u.product_id,
        MAX(u.vector_score) AS vector_score,
        MAX(u.fulltext_score) AS fulltext_score,
        MAX(u.trigram_score) AS trigram_score,
        MAX(u.exact_score) AS exact_score
    FROM unioned u
    GROUP BY u.product_id
),
features AS (
    SELECT
        agg.product_id,
        agg.vector_score,
        agg.fulltext_score,
        agg.trigram_score,
        agg.exact_score,
        fp.vendor_code,
        fp.name,
        fp.ukrainian_name,
        fp.main_original_number,
        fp.supplier_name,
        fp.weight,
        fp.is_for_sale,
        fp.is_for_web,
        fp.has_image,
        fp.has_analogue,
        fp.created,
        fp.updated,
        COALESCE(pop.popularity_score, 0.0) AS popularity_score,
        COALESCE(pop.click_count, 0) AS click_count,
        COALESCE(pop.view_count, 0) AS view_count,
        COALESCE(pop.conversion_count, 0) AS conversion_count
    FROM aggregated agg
    JOIN filtered_products fp ON fp.product_id = agg.product_id
    LEFT JOIN analytics_features.product_popularity_scores pop ON pop.product_id = agg.product_id
),
scored AS (
    SELECT
        f.*,
        (%s * f.vector_score) +
        (%s * f.fulltext_score) +
        (%s * f.trigram_score) +
        (%s * f.exact_score) +
        (%s * f.popularity_score) +
        (%s * (
            CASE WHEN f.is_for_sale THEN 0.4 ELSE 0 END +
            CASE WHEN f.is_for_web THEN 0.3 ELSE 0 END +
            CASE WHEN f.has_image THEN 0.3 ELSE 0 END
        )) +
        (%s * LEAST(GREATEST(1.0 - (EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - COALESCE(f.updated, f.created))) / 86400.0) / 365.0, -1.0), 1.0))
        AS final_score
    FROM features f
)
SELECT
    scored.product_id,
    scored.vendor_code,
    scored.name,
    scored.ukrainian_name,
    scored.main_original_number,
    scored.supplier_name,
    scored.weight,
    scored.is_for_sale,
    scored.is_for_web,
    scored.has_image,
    scored.has_analogue,
    scored.vector_score,
    scored.fulltext_score,
    scored.trigram_score,
    scored.exact_score,
    scored.popularity_score,
    scored.click_count,
    scored.view_count,
    scored.conversion_count,
    scored.final_score,
    COUNT(*) OVER () AS total_count
FROM scored
ORDER BY final_score DESC, product_id
LIMIT %s OFFSET %s
"""


def _execute_unified_search(
    query_text: str,
    embedding_vector: List[float],
    filters: Optional[SearchFilters],
    ranking_weights: RankingWeights,
    fetch_limit: int,
    result_limit: int,
    result_offset: int,
    restrict_product_ids: Optional[List[int]] = None,
) -> Tuple[List[Dict[str, Any]], int]:
    embedding_str = format_embedding_for_postgres(embedding_vector)

    filter_clause, filter_params = _build_filter_clause(filters)
    if restrict_product_ids:
        filter_clause += (" AND " if filter_clause else " AND ") + "p.product_id = ANY(%s)"
        filter_params.append(restrict_product_ids)

    sql = UNIFIED_SEARCH_SQL_TEMPLATE.format(filter_clause=filter_clause)

    ts_query_input = query_text
    search_pattern = f"%{query_text}%"

    vector_limit = fetch_limit if ranking_weights.vector_similarity > 0 else 0
    fulltext_limit = fetch_limit
    trigram_limit = fetch_limit
    exact_limit = fetch_limit

    params: List[Any] = []
    params.extend(filter_params)
    params.extend([
        embedding_str,
        embedding_str,
        vector_limit,
        ts_query_input,
        ts_query_input,
        fulltext_limit,
        query_text,
        query_text,
        query_text,
        query_text,
        trigram_limit,
        search_pattern,
        search_pattern,
        search_pattern,
        query_text,
        exact_limit,
        ranking_weights.vector_similarity,
        ranking_weights.fulltext,
        ranking_weights.trigram,
        ranking_weights.exact_match,
        ranking_weights.popularity,
        ranking_weights.availability,
        ranking_weights.freshness,
        result_limit,
        result_offset,
    ])

    with get_db_connection() as conn:
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(sql, params)
        rows = cursor.fetchall()

    total_count = rows[0]['total_count'] if rows else 0

    return rows, total_count


# ============================================================================
# Database Connection
# ============================================================================

@contextmanager
def get_db_connection():
    """Context manager for pooled database connections"""
    if db_pool is None:
        logger.error("Database connection pool not initialised")
        raise HTTPException(status_code=500, detail="Database pool unavailable")

    conn = None
    try:
        conn = db_pool.getconn()
        conn.autocommit = True
        yield conn
    except psycopg2.Error as e:
        logger.error(f"Database connection error: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")
    finally:
        if conn:
            db_pool.putconn(conn)


# ============================================================================
# Device Detection for GPU Acceleration
# ============================================================================

def detect_device() -> str:
    """
    Auto-detect best available device for inference

    Priority: CUDA GPU > Apple MPS > CPU
    Can be overridden with ML_DEVICE environment variable

    Returns:
        Device string: 'cuda', 'mps', or 'cpu'
    """
    device_override = os.getenv("ML_DEVICE", "auto").lower()

    if device_override != "auto":
        logger.info(f"Using configured device: {device_override}")
        return device_override

    if torch.cuda.is_available():
        gpu_name = torch.cuda.get_device_name(0)
        logger.info(f"GPU detected: {gpu_name}")
        logger.info(f"CUDA version: {torch.version.cuda}")
        return "cuda"
    elif torch.backends.mps.is_available():
        logger.info("Apple Silicon detected")
        return "mps"
    else:
        logger.info("No GPU detected, using CPU")
        return "cpu"


# ============================================================================
# Startup/Shutdown Events
# ============================================================================

@app.on_event("startup")
async def startup_event():
    """Load embedding model and dynamic keywords on startup"""
    global embedding_model, DYNAMIC_KEYWORDS, db_pool

    try:
        device = detect_device()
        logger.info(f"Loading embedding model: {MODEL_NAME}")
        logger.info(f"Target device: {device}")

        embedding_model = SentenceTransformer(MODEL_NAME, device=device)

        if device == "cuda":
            logger.info("Enabling FP16 mixed precision for GPU acceleration")
            embedding_model.half()

        _ = embedding_model.encode(["warm-up query"], show_progress_bar=False)

        logger.info(f"✅ Model loaded successfully on {device.upper()} (dim={EMBEDDING_DIM})")
    except Exception as e:
        logger.error(f"Failed to load embedding model: {e}")
        raise

    try:
        pool_min = int(os.getenv("POSTGRES_POOL_MIN", "1"))
        pool_max = int(os.getenv("POSTGRES_POOL_MAX", "10"))
        logger.info(f"Initialising PostgreSQL connection pool ({pool_min}-{pool_max})")
        connection_params = DB_CONFIG.copy()
        connection_params["cursor_factory"] = RealDictCursor
        db_pool = SimpleConnectionPool(
            minconn=pool_min,
            maxconn=pool_max,
            **connection_params,
        )
        logger.info("✅ Database connection pool initialised")
    except Exception as e:
        logger.error(f"Failed to initialise database pool: {e}")
        raise

    try:
        logger.info("Loading dynamic keywords from database...")
        with get_db_connection() as conn:
            cursor = conn.cursor()

            cursor.execute("""
                SELECT language, keyword
                FROM analytics_features.product_keyword_cache
                WHERE frequency >= 100
                ORDER BY frequency DESC
            """)
            rows = cursor.fetchall()

            ukrainian_keywords: List[str] = []
            polish_keywords: List[str] = []

            for row in rows:
                if row['language'] == 'ukrainian':
                    ukrainian_keywords.append(row['keyword'])
                elif row['language'] == 'polish':
                    polish_keywords.append(row['keyword'])

            DYNAMIC_KEYWORDS['ukrainian'] = ukrainian_keywords
            DYNAMIC_KEYWORDS['polish'] = polish_keywords

            logger.info(f"✅ Loaded {len(ukrainian_keywords)} Ukrainian keywords")
            logger.info(f"✅ Loaded {len(polish_keywords)} Polish keywords (for exclusion)")

    except Exception as e:
        logger.warning(f"Failed to load dynamic keywords: {e}. Using fallback classification.")
        DYNAMIC_KEYWORDS['ukrainian'] = []
        DYNAMIC_KEYWORDS['polish'] = []


@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    logger.info("Shutting down search API")
    global db_pool
    if db_pool is not None:
        db_pool.closeall()
        db_pool = None
        logger.info("Database connection pool closed")


@app.middleware("http")
async def log_request_latency(request: Request, call_next):
    """Log latency for incoming requests"""
    start_time = time.perf_counter()
    response = await call_next(request)
    duration_ms = (time.perf_counter() - start_time) * 1000
    logger.info(
        "%s %s completed in %.2f ms (status=%d)",
        request.method,
        request.url.path,
        duration_ms,
        response.status_code,
    )
    return response


# ============================================================================
# Helper Functions
# ============================================================================

def get_cached_query_embedding(query: str) -> Optional[List[float]]:
    """
    Look up pre-computed query embedding from cache

    Args:
        query: Search query text

    Returns:
        Cached embedding vector or None if not found

    Performance: <5ms cache hit vs 2-3s fresh encoding
    """
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT embedding FROM analytics_features.query_embeddings WHERE query_text = %s",
                (query,)
            )
            row = cursor.fetchone()

            logger.debug(f"Cache query returned row: {row is not None}")

            if row is not None:
                # Access by column name (connection pool uses DictCursor)
                embedding_vector = row['embedding'] if isinstance(row, dict) else row[0]
                logger.debug(f"Embedding vector type: {type(embedding_vector)}, value sample: {str(embedding_vector)[:100]}")

                # Parse pgvector string format: "[1.0,2.0,3.0]"
                if isinstance(embedding_vector, str):
                    # Remove brackets and split by comma
                    vector_str = embedding_vector.strip('[]')
                    embedding_list = [float(x) for x in vector_str.split(',')]
                    logger.info(f"Query cache HIT for: '{query[:50]}...' ({len(embedding_list)} dims)")

                    # Update usage stats
                    cursor.execute("""
                        UPDATE analytics_features.query_embeddings
                        SET usage_count = usage_count + 1, last_used = NOW()
                        WHERE query_text = %s
                    """, (query,))

                    return embedding_list
                elif hasattr(embedding_vector, '__iter__'):
                    # Already a list or array
                    embedding_list = list(embedding_vector)
                    logger.info(f"Query cache HIT for: '{query[:50]}...' ({len(embedding_list)} dims)")

                    # Update usage stats
                    cursor.execute("""
                        UPDATE analytics_features.query_embeddings
                        SET usage_count = usage_count + 1, last_used = NOW()
                        WHERE query_text = %s
                    """, (query,))

                    return embedding_list

    except Exception as e:
        logger.error(f"Cache lookup failed for query '{query}': {e}")
        import traceback
        logger.error(f"Full traceback: {traceback.format_exc()}")

    return None


def upsert_query_embedding_to_cache(query: str, embedding: List[float]):
    """
    Cache query embedding for future lookups

    Args:
        query: Search query text
        embedding: Embedding vector to cache
    """
    try:
        from src.ml.query_cache_loader import classify_query_language

        language = classify_query_language(query)
        embedding_str = f"[{','.join(map(str, embedding))}]"

        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO analytics_features.query_embeddings (query_text, embedding, query_language)
                VALUES (%s, %s::vector, %s)
                ON CONFLICT (query_text) DO UPDATE SET
                    embedding = EXCLUDED.embedding,
                    query_language = EXCLUDED.query_language,
                    updated_at = NOW()
            """, (query, embedding_str, language))

    except Exception as e:
        logger.warning(f"Failed to cache embedding for query '{query}': {e}")


def generate_embedding(text: str) -> List[float]:
    """
    Generate embedding for text query with cache support

    Performance Optimization:
    - Cache hit: <5ms (direct database lookup)
    - Cache miss: 2-3s CPU / 50-100ms GPU (fresh encoding)

    Args:
        text: Query text to encode

    Returns:
        384-dimensional embedding vector
    """
    cached_embedding = get_cached_query_embedding(text)
    if cached_embedding is not None:
        return cached_embedding

    logger.info(f"Query cache MISS for: '{text[:50]}...' - generating fresh embedding")

    if embedding_model is None:
        raise HTTPException(status_code=500, detail="Embedding model not loaded")

    embedding = embedding_model.encode(text, convert_to_numpy=True)
    embedding_list = embedding.tolist()

    upsert_query_embedding_to_cache(text, embedding_list)

    return embedding_list


def format_embedding_for_postgres(embedding: List[float]) -> str:
    """Format embedding as PostgreSQL vector literal"""
    return f"[{','.join(map(str, embedding))}]"


class QueryType(str, Enum):
    """Query classification types for intelligent routing"""
    VENDOR_CODE = "vendor_code"
    EXACT_PHRASE = "exact_phrase"
    NATURAL_LANGUAGE = "natural_language"


def classify_query(query: str) -> QueryType:
    """
    Intelligent query classification using dynamic keyword learning

    Self-Learning Classification:
        - VENDOR_CODE: Alphanumeric codes (e.g., "100623SAMKO", "SEM1-BP-001")
        - EXACT_PHRASE: Product names with common keywords (dynamically loaded from DB)
        - NATURAL_LANGUAGE: Descriptive queries (e.g., "brake pads for trucks")

    Keywords are automatically extracted from 278k products and refreshed periodically.
    This ensures the classifier adapts to the actual product catalog.
    """
    query_stripped: str = query.strip()
    query_lower: str = query_stripped.lower()

    vendor_code_pattern: re.Pattern = re.compile(r'^[A-Z0-9\-_]{5,30}$', re.IGNORECASE)
    if vendor_code_pattern.match(query_stripped):
        return QueryType.VENDOR_CODE

    cyrillic_pattern: re.Pattern = re.compile(r'[А-Яа-яЁёІіЇїЄєҐґ]')
    has_cyrillic: bool = bool(cyrillic_pattern.search(query_stripped))

    if has_cyrillic:
        if len(query_stripped.split()) <= 5:
            return QueryType.EXACT_PHRASE

        if DYNAMIC_KEYWORDS['ukrainian']:
            if any(keyword in query_lower for keyword in DYNAMIC_KEYWORDS['ukrainian']):
                return QueryType.EXACT_PHRASE

    return QueryType.NATURAL_LANGUAGE


def log_search_query(query: str, total_results: int, execution_time_ms: float,
                     search_type: str = "hybrid", user_id: Optional[str] = None,
                     session_id: Optional[str] = None) -> Optional[int]:
    """
    Log search query to database for analytics and learning-to-rank

    Returns:
        search_id (int): ID of the logged search query (query_id), or None if logging failed
    """
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()

            cursor.execute("""
                INSERT INTO analytics_features.search_query_log
                    (query_text, result_count, execution_time_ms, search_type, user_id, session_id, timestamp)
                VALUES (%s, %s, %s, %s, %s, %s, NOW())
                RETURNING query_id
            """, (query, total_results, execution_time_ms, search_type, user_id, session_id))

            row = cursor.fetchone()
            search_id = row['query_id'] if row else None

            conn.commit()

            logger.info(f"Logged search query: '{query}' (search_id={search_id})")
            return search_id

    except Exception as e:
        logger.error(f"Failed to log search query: {e}")
        return None


# ============================================================================
# API Endpoints
# ============================================================================

@app.get("/")
async def root():
    """API root endpoint"""
    return {
        "service": "Product AI Search API",
        "version": "3.0.0",
        "status": "healthy",
        "description": "World-class AI-powered product search with hybrid ML ranking",
        "endpoints": {
            "search": "POST /search - Main search endpoint with AI/ML hybrid ranking",
            "similar_products": "GET /search/similar/{product_id} - Find similar products",
            "click_tracking": "POST /search/click - Track user clicks for learning-to-rank",
            "feedback": "POST /search/feedback - Collect search quality feedback",
            "health": "GET /health - Health check"
        },
        "features": {
            "hybrid_search": "Combines 4 techniques: Full-text, Trigram, Exact, Vector (HNSW)",
            "ml_ranking": "7-signal ensemble ranking with configurable weights",
            "query_logging": "All searches logged for analytics and model training",
            "click_tracking": "Track user behavior for learning-to-rank",
            "multilingual": "Ukrainian, Polish, English support",
            "performance": "<200ms for 278k products",
            "auto_classification": "Intelligent query routing (vendor codes, exact phrases, NL)"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.fetchone()

        model_status = "loaded" if embedding_model is not None else "not_loaded"

        return {
            "status": "healthy",
            "database": "connected",
            "embedding_model": model_status,
            "model_name": MODEL_NAME,
            "embedding_dim": EMBEDDING_DIM
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=503, detail="Service unhealthy")



def _fetch_analogue_product_ids(
    base_product_ids: List[int],
    exclude_ids: Set[int],
    max_results: int,
) -> List[int]:
    if not base_product_ids or max_results <= 0:
        return []

    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT pa.base_product_i_d, pa.analogue_product_i_d
            FROM staging.product_analogue pa
            WHERE pa.base_product_i_d = ANY(%s)
            """,
            (base_product_ids,),
        )
        rows = cursor.fetchall()

    analogue_map: Dict[int, List[int]] = {}
    for base_id, analogue_id in rows:
        if analogue_id in exclude_ids:
            continue
        analogue_map.setdefault(base_id, [])
        if analogue_id not in analogue_map[base_id]:
            analogue_map[base_id].append(analogue_id)

    ordered_ids: List[int] = []
    seen: Set[int] = set()

    for base_id in base_product_ids:
        for analogue_id in analogue_map.get(base_id, []):
            if analogue_id in seen or analogue_id in exclude_ids:
                continue
            ordered_ids.append(analogue_id)
            seen.add(analogue_id)
            if len(ordered_ids) >= max_results:
                return ordered_ids

    return ordered_ids


@app.post("/search", response_model=SearchResponse)
async def adaptive_search(request: SearchRequest):
    start_time = time.perf_counter()

    try:
        query_type: QueryType = classify_query(request.query)

        filters = SearchFilters(
            supplier_name=request.supplier_name,
            weight_min=request.weight_min,
            weight_max=request.weight_max,
            is_for_sale=request.is_for_sale,
            is_for_web=request.is_for_web,
            has_image=request.has_image,
        )

        if query_type == QueryType.VENDOR_CODE:
            filters.vendor_code_query = request.query

        preset_key = request.weight_preset or (
            'exact_priority' if query_type in {QueryType.VENDOR_CODE, QueryType.EXACT_PHRASE} else 'balanced'
        )
        weights: RankingWeights = WEIGHT_PRESETS.get(preset_key, WEIGHT_PRESETS['balanced'])

        enable_vector_search: bool = (query_type == QueryType.NATURAL_LANGUAGE) and (embedding_model is not None)

        if not enable_vector_search:
            weights = RankingWeights(
                exact_match=weights.exact_match,
                fulltext=weights.fulltext,
                trigram=weights.trigram,
                vector_similarity=0.0,
                popularity=weights.popularity,
                availability=weights.availability,
                freshness=weights.freshness,
            ).normalize()

        embedding_vector = generate_embedding(request.query) if enable_vector_search else ZERO_VECTOR

        fetch_limit = min(request.limit + request.offset + 50, 200)

        rows, total_count = _execute_unified_search(
            query_text=request.query,
            embedding_vector=embedding_vector,
            filters=filters,
            ranking_weights=weights,
            fetch_limit=fetch_limit,
            result_limit=request.limit,
            result_offset=request.offset,
        )

        seen_ids: Set[int] = {row['product_id'] for row in rows}

        if total_count < request.offset + request.limit:
            base_ids = [row['product_id'] for row in rows]
            analogue_ids = _fetch_analogue_product_ids(base_ids, seen_ids, request.limit + fetch_limit)

            if analogue_ids:
                analogue_rows, _ = _execute_unified_search(
                    query_text=request.query,
                    embedding_vector=embedding_vector,
                    filters=filters,
                    ranking_weights=weights,
                    fetch_limit=fetch_limit,
                    result_limit=request.limit,
                    result_offset=0,
                    restrict_product_ids=analogue_ids,
                )

                for row in analogue_rows:
                    pid = row['product_id']
                    if pid in seen_ids:
                        continue
                    rows.append(row)
                    seen_ids.add(pid)
                    if len(rows) >= request.limit:
                        break

                total_count = max(total_count, request.offset + len(rows))

        rows.sort(key=lambda r: (-float(r.get('final_score', 0.0)), r.get('product_id')))

        execution_time_ms = (time.perf_counter() - start_time) * 1000

        products: List[ProductResult] = [
            ProductResult(
                product_id=row['product_id'],
                vendor_code=row.get('vendor_code'),
                name=row.get('name'),
                ukrainian_name=row.get('ukrainian_name'),
                main_original_number=row.get('main_original_number'),
                supplier_name=row.get('supplier_name'),
                weight=float(row['weight']) if row.get('weight') is not None else None,
                is_for_sale=row.get('is_for_sale'),
                is_for_web=row.get('is_for_web'),
                has_image=row.get('has_image'),
                has_analogue=row.get('has_analogue'),
                similarity_score=float(row.get('final_score', 0.0)),
                ranking_score=float(row.get('final_score', 0.0)),
            )
            for row in rows[:request.limit]
        ]

        # Log the search query
        search_id = log_search_query(
            query=request.query,
            total_results=total_count,
            execution_time_ms=execution_time_ms,
            search_type="adaptive"
        )

        return SearchResponse(
            query=request.query,
            total_results=total_count,
            execution_time_ms=round(execution_time_ms, 2),
            results=products,
            search_id=search_id
        )

    except Exception as exc:
        logger.error(f"Unified search failed: {exc}")
        raise HTTPException(status_code=500, detail=f"Search failed: {exc}")


@app.post("/search/click", response_model=ClickTrackingResponse)
async def track_click(request: ClickTrackingRequest):
    """
    Track user clicks on search results for learning-to-rank

    This endpoint logs which products users click on for each search query.
    The data is used to:
        - Calculate click-through rates (CTR)
        - Train learning-to-rank models
        - Improve search relevance over time
        - Analyze user behavior patterns

    Use Case:
        When a user clicks on a product in search results, send this event to
        build behavioral signals for ML ranking.
    """
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()

            # Verify search_id exists
            cursor.execute(
                "SELECT query_id FROM analytics_features.search_query_log WHERE query_id = %s",
                (request.search_id,)
            )
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail=f"Search ID {request.search_id} not found")

            # Insert click event
            cursor.execute("""
                INSERT INTO analytics_features.search_click_log
                    (query_id, product_id, rank_position, clicked_at)
                VALUES (%s, %s, %s, NOW())
                RETURNING click_id
            """, (request.search_id, request.product_id, request.rank_position))

            row = cursor.fetchone()
            click_id = row['click_id'] if row else None

            conn.commit()

            logger.info(f"Logged click: search_id={request.search_id}, product_id={request.product_id}, rank={request.rank_position}")

            return ClickTrackingResponse(
                success=True,
                message="Click tracked successfully",
                click_id=click_id
            )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to track click: {e}")
        raise HTTPException(status_code=500, detail=f"Click tracking failed: {str(e)}")


@app.post("/search/feedback", response_model=FeedbackResponse)
async def submit_feedback(request: FeedbackRequest):
    """
    Collect user feedback on search quality

    This endpoint collects explicit feedback from users about search results.
    Feedback types:
        - 'helpful': Search results were relevant and helpful
        - 'not_helpful': Search results were not useful
        - 'no_results': No results found for the query
        - 'irrelevant': Results were not related to the query

    Use Case:
        Allow users to rate search quality, helping identify problem queries
        and improve search algorithms.
    """
    valid_feedback_types = {'helpful', 'not_helpful', 'no_results', 'irrelevant'}
    if request.feedback_type not in valid_feedback_types:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid feedback_type. Must be one of: {valid_feedback_types}"
        )

    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()

            # Verify search_id exists
            cursor.execute(
                "SELECT query_id FROM analytics_features.search_query_log WHERE query_id = %s",
                (request.search_id,)
            )
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail=f"Search ID {request.search_id} not found")

            # Store feedback (update search_query_log with feedback)
            cursor.execute("""
                UPDATE analytics_features.search_query_log
                SET feedback_type = %s, feedback_comment = %s, feedback_timestamp = NOW()
                WHERE query_id = %s
            """, (request.feedback_type, request.comment, request.search_id))

            conn.commit()

            logger.info(f"Logged feedback: search_id={request.search_id}, type={request.feedback_type}")

            return FeedbackResponse(
                success=True,
                message="Feedback submitted successfully"
            )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to submit feedback: {e}")
        raise HTTPException(status_code=500, detail=f"Feedback submission failed: {str(e)}")


@app.get("/search/similar/{product_id}", response_model=SearchResponse)
async def find_similar_products(
    product_id: int,
    limit: int = Query(10, ge=1, le=50, description="Maximum number of similar products")
):
    """
    Find products similar to a given product.

    Use Case: "Customers who viewed this also viewed..."
    Method: Product-to-product similarity using embeddings
    """
    import time
    start_time = time.time()

    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()

            # Check if product exists
            cursor.execute(
                "SELECT name FROM staging_marts.dim_product WHERE product_id = %s",
                (product_id,)
            )
            source_product = cursor.fetchone()

            if not source_product:
                raise HTTPException(status_code=404, detail=f"Product {product_id} not found")

            # Find similar products
            query = """
                SELECT
                    p.product_id,
                    p.vendor_code,
                    p.name,
                    p.ukrainian_name,
                    p.main_original_number,
                    p.supplier_name,
                    p.weight,
                    p.is_for_sale,
                    p.is_for_web,
                    p.has_image,
                    p.has_analogue,
                    1 - (e1.embedding <=> e2.embedding) AS similarity_score
                FROM analytics_features.product_embeddings e1
                CROSS JOIN analytics_features.product_embeddings e2
                JOIN staging_marts.dim_product p ON p.product_id = e2.product_id
                WHERE e1.product_id = %s
                    AND e2.product_id != %s
                ORDER BY e1.embedding <=> e2.embedding
                LIMIT %s;
            """

            cursor.execute(query, (product_id, product_id, limit))
            rows = cursor.fetchall()

        # Format results
        results = [ProductResult(**dict(row)) for row in rows]

        execution_time_ms = (time.time() - start_time) * 1000

        return SearchResponse(
            query=f"Similar to product {product_id}: {source_product['name']}",
            total_results=len(results),
            execution_time_ms=round(execution_time_ms, 2),
            results=results
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Similar products search failed: {e}")
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


# ============================================================================
# Run with: uvicorn src.api.search_api:app --reload --port 8000
# ============================================================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
