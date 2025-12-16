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
    "ukrainian": []
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
    """Universal request model for all search-related operations"""

    # Action selector
    action: str = Field(
        "search",
        description="Operation type: 'search' (product search), 'track_click' (log click), 'feedback' (submit feedback)"
    )

    # Search-specific fields (for action='search')
    query: Optional[str] = Field(None, description="Natural language search query", min_length=1, max_length=500)

    # Click tracking fields (for action='track_click')
    search_id: Optional[int] = Field(None, description="ID of the search query from search_query_log")
    clicked_product_id: Optional[int] = Field(None, description="ID of the clicked product")
    rank_position: Optional[int] = Field(None, description="Position of product in search results (1-indexed)")

    # Feedback fields (for action='feedback')
    feedback_type: Optional[str] = Field(None, description="Type of feedback")
    feedback_comment: Optional[str] = Field(None, description="Optional user comment", max_length=500)

    class Config:
        # Provide example for Swagger UI
        json_schema_extra = {
            "example": {
                "query": "тяга"
            }
        }


class ProductResult(BaseModel):
    """Response model for a single product"""
    product_id: int
    vendor_code: Optional[str]
    name: Optional[str]
    ukrainian_name: Optional[str]
    main_original_number: Optional[str]
    supplier_name: Optional[str]
    size: Optional[str] = None
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
    """Universal response model for all search-related operations"""

    # Universal fields
    action: str  # Echo back the action type
    success: bool = True
    execution_time_ms: float
    message: Optional[str] = None

    # Search-specific fields (for action='search')
    query: Optional[str] = None
    total_results: Optional[int] = None
    results: Optional[List[ProductResult]] = None
    search_id: Optional[int] = None

    # Click tracking fields (for action='track_click')
    click_id: Optional[int] = None


@dataclass
class SearchFilters:
    # No filters - search parses query only
    pass


def _build_filter_clause(filters: Optional[SearchFilters], alias: str = "p") -> Tuple[str, List[Any]]:
    # No filters - query-only search
    return "", []


# New simplified search SQL template based on business requirements
# No ML/vector search, no expensive trigram calculations
# Smart multi-term matching with normalized code search
UNIFIED_SEARCH_SQL_TEMPLATE = """
WITH matched_products AS (
    SELECT
        p.product_id,
        p.vendor_code,
        p.name,
        p.ukrainian_name,
        p.main_original_number,
        p.supplier_name,
        p.size,
        p.description,
        p.weight,
        p.is_for_sale,
        p.is_for_web,
        p.has_image,
        p.has_analogue,
        p.created,
        p.updated,
        p.total_available_amount,
        p.storage_count,
        p.original_number_ids,
        p.analogue_product_ids,
        p.availability_score,
        p.freshness_score,
        p.normalized_vendor_code,
        p.normalized_original_number,
        -- Match counting for scoring (all terms treated equally)
        (
            -- All term matches from multi-term conditions
            {multi_term_conditions}
            -- Exact matches bonus
            CASE WHEN LOWER(p.vendor_code) = LOWER(%s) THEN 15 ELSE 0 END +
            CASE WHEN LOWER(p.name) = LOWER(%s) THEN 12 ELSE 0 END
        ) AS match_score
    FROM staging_marts.dim_product p
    WHERE 1=1
        {multi_term_where}
),
scored AS (
    SELECT
        mp.*,
        COALESCE(pop.popularity_score, 0.0) AS popularity_score,
        COALESCE(pop.click_count, 0) AS click_count,
        COALESCE(pop.view_count, 0) AS view_count,
        COALESCE(pop.conversion_count, 0) AS conversion_count,
        -- Final score calculation
        (
            mp.match_score * 10.0 +
            COALESCE(pop.popularity_score, 0.0) * 2.0 +
            (CASE WHEN mp.is_for_sale THEN 1.0 ELSE 0 END) +
            (CASE WHEN mp.is_for_web THEN 0.8 ELSE 0 END) +
            (CASE WHEN mp.has_image THEN 0.6 ELSE 0 END) +
            -- Freshness score
            LEAST(GREATEST(1.0 - (EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - COALESCE(mp.updated, mp.created))) / 86400.0) / 365.0, 0.0), 1.0) * 0.5
        ) AS final_score
    FROM matched_products mp
    LEFT JOIN analytics_features.product_popularity_scores pop ON pop.product_id = mp.product_id
    WHERE mp.match_score > 0
)
SELECT
    scored.product_id,
    scored.vendor_code,
    scored.name,
    scored.ukrainian_name,
    scored.main_original_number,
    scored.supplier_name,
    scored.size,
    scored.weight,
    scored.is_for_sale,
    scored.is_for_web,
    scored.has_image,
    scored.has_analogue,
    scored.total_available_amount,
    scored.storage_count,
    scored.original_number_ids,
    scored.analogue_product_ids,
    scored.availability_score,
    scored.freshness_score,
    scored.match_score,
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
    embedding_vector: List[float],  # Not used in new implementation
    filters: Optional[SearchFilters],
    ranking_weights: RankingWeights,  # Not used in new implementation
    fetch_limit: int,
    result_limit: int,
    result_offset: int,
    restrict_product_ids: Optional[List[int]] = None,
) -> Tuple[List[Dict[str, Any]], int]:
    """
    Execute smart text-based search using query preprocessing and normalized fields
    """
    # Preprocess query to extract terms and generate variants
    processed = preprocess_search_query(query_text)

    # Build WHERE clause and CASE conditions for ALL terms equally
    # Using parameter placeholders instead of string injection
    multi_term_where = ""
    multi_term_conditions = ""
    all_term_params = []
    score_params = []

    if len(processed.terms) >= 1:
        # Combined search: ALL terms search ALL fields equally
        # Example: "Втулка 082564" finds products where:
        # - "Втулка" matches ANY field (name, code, size, description)
        # - AND "082564" matches ANY field

        # Build WHERE clause with parameter placeholders for all terms
        term_conditions = []
        term_score_conditions = []

        for idx, term in enumerate(processed.terms):
            # Generate both Latin 'x' and Cyrillic 'х' variants
            # This handles size patterns like "72х56" or "72x56"
            term_variants = []
            if 'x' in term.lower() or 'х' in term.lower():
                # Create both variants
                latin_term = term.replace('х', 'x').replace('Х', 'X')
                cyrillic_term = term.replace('x', 'х').replace('X', 'Х')
                term_variants = [latin_term, cyrillic_term]
            else:
                term_variants = [term]

            # Build OR conditions for all term variants across all fields
            field_conditions = []
            for variant in term_variants:
                pattern = f"%{variant}%"
                field_conditions.extend([
                    "p.vendor_code ILIKE %s",
                    "p.main_original_number ILIKE %s",
                    "p.name ILIKE %s",
                    "p.ukrainian_name ILIKE %s",
                    "p.size ILIKE %s",
                    "p.description ILIKE %s"
                ])
                all_term_params.extend([pattern] * 6)

            term_conditions.append("(" + " OR ".join(field_conditions) + ")")

            # Build scoring conditions for this term
            # Scoring: vendor_code=9, original_number=8, name=7, size=6, description=5
            for variant in term_variants:
                pattern = f"%{variant}%"

                term_score_conditions.append("CASE WHEN p.vendor_code ILIKE %s THEN 9 ELSE 0 END")
                score_params.append(pattern)

                term_score_conditions.append("CASE WHEN p.main_original_number ILIKE %s THEN 8 ELSE 0 END")
                score_params.append(pattern)

                term_score_conditions.append("CASE WHEN p.name ILIKE %s THEN 7 ELSE 0 END")
                score_params.append(pattern)

                term_score_conditions.append("CASE WHEN p.ukrainian_name ILIKE %s THEN 7 ELSE 0 END")
                score_params.append(pattern)

                term_score_conditions.append("CASE WHEN p.size ILIKE %s THEN 6 ELSE 0 END")
                score_params.append(pattern)

                term_score_conditions.append("CASE WHEN p.description ILIKE %s THEN 5 ELSE 0 END")
                score_params.append(pattern)

        if term_conditions:
            # Use AND between all term conditions (all must match)
            multi_term_where = "AND (" + " AND ".join(term_conditions) + ")"

        if term_score_conditions:
            multi_term_conditions = " + ".join(term_score_conditions) + " +"

    # Build SQL with multi-term placeholders
    sql = UNIFIED_SEARCH_SQL_TEMPLATE.format(
        multi_term_where=multi_term_where,
        multi_term_conditions=multi_term_conditions
    )

    # Check if we have any terms
    if not processed.terms:
        # If preprocessing failed or query is invalid, return empty results
        return [], 0

    # Build parameters list (same structure for single and multi-term queries)
    params: List[Any] = []

    # Scoring CASE parameters (in matched_products CTE)
    params.extend(score_params)

    # Exact match bonus parameters
    params.extend([
        query_text,  # LOWER(p.vendor_code) = LOWER
        query_text,  # LOWER(p.name) = LOWER
    ])

    # WHERE clause parameters (from all_term_params)
    params.extend(all_term_params)

    # LIMIT and OFFSET
    params.extend([
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

            for row in rows:
                if row['language'] == 'ukrainian':
                    ukrainian_keywords.append(row['keyword'])

            DYNAMIC_KEYWORDS['ukrainian'] = ukrainian_keywords

            logger.info(f"✅ Loaded {len(ukrainian_keywords)} Ukrainian keywords")

    except Exception as e:
        logger.warning(f"Failed to load dynamic keywords: {e}. Using fallback classification.")
        DYNAMIC_KEYWORDS['ukrainian'] = []


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


@dataclass
class ProcessedQuery:
    """Processed search query with variants and classification"""
    original: str
    normalized: str  # Trimmed, single spaces
    terms: List[str]  # Split terms for multi-term search
    normalized_variants: List[str]  # Variants without special chars
    leading_variants: List[str]  # Variants with/without leading 0/A
    is_multi_term: bool
    min_length_valid: bool  # At least 4 characters


def preprocess_search_query(query: str) -> ProcessedQuery:
    """
    Preprocess search query according to business requirements:
    - Min 4 characters validation
    - Trim and normalize whitespace
    - Split into terms for multi-term search
    - Generate normalized variants (no special chars)
    - Generate leading 0/A variants for Mercedes/SAF codes
    """
    if not query:
        return ProcessedQuery(
            original="",
            normalized="",
            terms=[],
            normalized_variants=[],
            leading_variants=[],
            is_multi_term=False,
            min_length_valid=False
        )

    # 1. Trim and normalize whitespace
    normalized = re.sub(r'\s+', ' ', query.strip())

    # 2. Check minimum length (4 chars)
    min_length_valid = len(normalized) >= 4

    # 3. Split into terms (for multi-term search like "Втулка 72х56")
    # Also split on 'x' and 'х' for size patterns like "72х56" -> ["72", "56"]
    terms = normalized.split()

    # Further split terms that contain 'x' or 'х' (size patterns)
    expanded_terms = []
    for term in terms:
        # Split on both Latin 'x' and Cyrillic 'х'
        if 'x' in term.lower() or 'х' in term.lower():
            # Split on both variants
            subterms = re.split(r'[xхXХ]', term)
            # Only expand if we get valid numeric/alphanumeric parts
            if len(subterms) > 1 and all(len(s.strip()) > 0 for s in subterms):
                expanded_terms.extend([s.strip() for s in subterms if s.strip()])
            else:
                expanded_terms.append(term)
        else:
            expanded_terms.append(term)

    terms = expanded_terms
    is_multi_term = len(terms) > 1

    # 4. Generate normalized variants (strip special characters)
    normalized_variants = []
    for term in terms:
        # Remove dots, dashes, slashes, spaces
        norm = re.sub(r'[.\-/\s]', '', term.upper())
        # For 'x' character: create variants with both Latin 'x' and Cyrillic 'х'
        # This handles size patterns like "72х56", "72x56", "72X56"
        if 'X' in norm or 'Х' in norm:
            # Create both variants
            latin_variant = norm.replace('Х', 'X')
            cyrillic_variant = norm.replace('X', 'Х')
            if latin_variant:
                normalized_variants.append(latin_variant)
            if cyrillic_variant:
                normalized_variants.append(cyrillic_variant)
        else:
            if norm:
                normalized_variants.append(norm)

    # 5. Generate leading 0/A variants (for Mercedes/SAF codes)
    leading_variants = []
    for term in terms:
        # Only for code-like terms (alphanumeric, not pure text)
        if re.match(r'^[A-Z0-9.\-/\s]+$', term.upper()):
            norm = re.sub(r'[.\-/\s]', '', term.upper())
            if norm:
                leading_variants.append(norm)  # Original
                leading_variants.append('0' + norm)  # With leading 0
                leading_variants.append('A' + norm)  # With leading A
                # Remove leading 0 if exists
                if norm.startswith('0'):
                    leading_variants.append(norm[1:])
                # Remove leading A if exists
                if norm.startswith('A'):
                    leading_variants.append(norm[1:])

    # Remove duplicates
    normalized_variants = list(set(normalized_variants))
    leading_variants = list(set(leading_variants))

    return ProcessedQuery(
        original=query,
        normalized=normalized,
        terms=terms,
        normalized_variants=normalized_variants,
        leading_variants=leading_variants,
        is_multi_term=is_multi_term,
        min_length_valid=min_length_valid
    )


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
        "description": "Universal AI-powered product search API with single unified endpoint",
        "endpoints": {
            "search": "POST /search - Universal endpoint (handles search, click tracking, and feedback)",
            "health": "GET /health - Health check"
        },
        "actions": {
            "search": {
                "description": "Product search with hybrid AI/ML ranking",
                "parameters": {"action": "search", "query": "required", "filters": "optional"}
            },
            "track_click": {
                "description": "Track user clicks for learning-to-rank",
                "parameters": {"action": "track_click", "search_id": "required", "clicked_product_id": "required", "rank_position": "required"}
            },
            "feedback": {
                "description": "Submit search quality feedback",
                "parameters": {"action": "feedback", "search_id": "required", "feedback_type": "required", "feedback_comment": "optional"}
            }
        },
        "features": {
            "single_endpoint": "All operations through one universal /search endpoint",
            "hybrid_search": "Combines 4 techniques: Full-text, Trigram, Exact, Vector (HNSW)",
            "ml_ranking": "7-signal ensemble ranking with configurable weights",
            "query_logging": "All searches logged for analytics and model training",
            "click_tracking": "Track user behavior for learning-to-rank",
            "multilingual": "Ukrainian, English",
            "performance": "<200ms for search, <50ms for tracking/feedback",
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
    # Disabled: analogue data is already provided in dim_product.analogue_product_ids field
    # The bronze.product_analogue_cdc table uses CDC format with JSONB payload which is complex to query
    # Users can use the analogue_product_ids field from the main search results instead
    return []


@app.post("/search", response_model=SearchResponse)
async def unified_search_endpoint(
    request: SearchRequest,
    limit: int = Query(20, ge=1, le=100, description="Maximum number of results"),
    offset: int = Query(0, ge=0, description="Number of results to skip (pagination)")
):
    """
    **UNIVERSAL SEARCH ENDPOINT - Handles ALL search-related operations**

    This single endpoint handles three types of operations based on the 'action' parameter:

    1. **Product Search** (action='search'):
       - Intelligent hybrid search combining vector, fulltext, trigram, and exact matching
       - Supports filters (supplier, weight, availability, etc.)
       - Auto-classifies queries (vendor codes, exact phrases, natural language)
       - Returns ranked product results

    2. **Click Tracking** (action='track_click'):
       - Logs user clicks on search results for learning-to-rank
       - Tracks click-through rates and user behavior patterns
       - Returns click_id for confirmation

    3. **Feedback Submission** (action='feedback'):
       - Collects user feedback on search quality
       - Supports feedback types: helpful, not_helpful, no_results, irrelevant
       - Returns success confirmation

    **Performance**: <200ms for search, <50ms for tracking/feedback
    **Languages**: Ukrainian, English
    """
    start_time = time.perf_counter()

    try:
        # Route based on action type
        if request.action == "search":
            return await _handle_search(request, start_time, limit, offset)
        elif request.action == "track_click":
            return await _handle_click_tracking(request, start_time)
        elif request.action == "feedback":
            return await _handle_feedback(request, start_time)
        else:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid action '{request.action}'. Must be 'search', 'track_click', or 'feedback'"
            )

    except HTTPException:
        raise
    except Exception as exc:
        logger.error(f"Unified search endpoint failed: {exc}")
        raise HTTPException(status_code=500, detail=f"Operation failed: {exc}")


async def _handle_search(request: SearchRequest, start_time: float, limit: int, offset: int) -> SearchResponse:
    """Handle product search operation"""

    if not request.query:
        raise HTTPException(status_code=400, detail="Query is required for search action")

    # Business validation: minimum 4 characters (after normalization)
    normalized_query = request.query.strip()
    if len(normalized_query) < 4:
        raise HTTPException(
            status_code=400,
            detail="Search query must be at least 4 characters long"
        )

    query_type: QueryType = classify_query(request.query)

    # No filters - query-only search
    filters = None

    # Auto-select ranking preset based on query type
    preset_key = 'exact_priority' if query_type in {QueryType.VENDOR_CODE, QueryType.EXACT_PHRASE} else 'balanced'
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

    fetch_limit = min(limit + offset + 50, 200)

    rows, total_count = _execute_unified_search(
        query_text=request.query,
        embedding_vector=embedding_vector,
        filters=filters,
        ranking_weights=weights,
        fetch_limit=fetch_limit,
        result_limit=limit,
        result_offset=offset,
    )

    seen_ids: Set[int] = {row['product_id'] for row in rows}

    if total_count < offset + limit:
        base_ids = [row['product_id'] for row in rows]
        analogue_ids = _fetch_analogue_product_ids(base_ids, seen_ids, limit + fetch_limit)

        if analogue_ids:
            analogue_rows, _ = _execute_unified_search(
                query_text=request.query,
                embedding_vector=embedding_vector,
                filters=filters,
                ranking_weights=weights,
                fetch_limit=fetch_limit,
                result_limit=limit,
                result_offset=0,
                restrict_product_ids=analogue_ids,
            )

            for row in analogue_rows:
                pid = row['product_id']
                if pid in seen_ids:
                    continue
                rows.append(row)
                seen_ids.add(pid)
                if len(rows) >= limit:
                    break

            total_count = max(total_count, offset + len(rows))

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
            size=row.get('size'),
            weight=float(row['weight']) if row.get('weight') is not None else None,
            is_for_sale=row.get('is_for_sale'),
            is_for_web=row.get('is_for_web'),
            has_image=row.get('has_image'),
            has_analogue=row.get('has_analogue'),
            similarity_score=float(row.get('final_score', 0.0)),
            ranking_score=float(row.get('final_score', 0.0)),
            total_available_amount=float(row['total_available_amount']) if row.get('total_available_amount') is not None else None,
            storage_count=row.get('storage_count'),
            original_number_ids=row.get('original_number_ids'),
            analogue_product_ids=row.get('analogue_product_ids'),
            availability_score=float(row['availability_score']) if row.get('availability_score') is not None else None,
            freshness_score=float(row['freshness_score']) if row.get('freshness_score') is not None else None,
        )
        for row in rows[:limit]
    ]

    # Log the search query
    search_id = log_search_query(
        query=request.query,
        total_results=total_count,
        execution_time_ms=execution_time_ms,
        search_type="adaptive"
    )

    return SearchResponse(
        action="search",
        success=True,
        execution_time_ms=round(execution_time_ms, 2),
        query=request.query,
        total_results=total_count,
        results=products,
        search_id=search_id
    )


async def _handle_click_tracking(request: SearchRequest, start_time: float) -> SearchResponse:
    """Handle click tracking operation"""

    if not request.search_id or not request.clicked_product_id or not request.rank_position:
        raise HTTPException(
            status_code=400,
            detail="search_id, clicked_product_id, and rank_position are required for track_click action"
        )

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
        """, (request.search_id, request.clicked_product_id, request.rank_position))

        row = cursor.fetchone()
        click_id = row['click_id'] if row else None

        conn.commit()

        logger.info(f"Logged click: search_id={request.search_id}, product_id={request.clicked_product_id}, rank={request.rank_position}")

    execution_time_ms = (time.perf_counter() - start_time) * 1000

    return SearchResponse(
        action="track_click",
        success=True,
        execution_time_ms=round(execution_time_ms, 2),
        message="Click tracked successfully",
        click_id=click_id
    )


async def _handle_feedback(request: SearchRequest, start_time: float) -> SearchResponse:
    """Handle feedback submission operation"""

    if not request.search_id or not request.feedback_type:
        raise HTTPException(
            status_code=400,
            detail="search_id and feedback_type are required for feedback action"
        )

    valid_feedback_types = {'helpful', 'not_helpful', 'no_results', 'irrelevant'}
    if request.feedback_type not in valid_feedback_types:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid feedback_type. Must be one of: {valid_feedback_types}"
        )

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
        """, (request.feedback_type, request.feedback_comment, request.search_id))

        conn.commit()

        logger.info(f"Logged feedback: search_id={request.search_id}, type={request.feedback_type}")

    execution_time_ms = (time.perf_counter() - start_time) * 1000

    return SearchResponse(
        action="feedback",
        success=True,
        execution_time_ms=round(execution_time_ms, 2),
        message="Feedback submitted successfully"
    )


# ============================================================================
# Run with: uvicorn src.api.search_api:app --reload --port 8000
# ============================================================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
