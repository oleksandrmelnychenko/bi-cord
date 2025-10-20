"""
FastAPI Semantic Search API for Product Catalog
Purpose: Production-ready REST API for AI-powered product search
Date: 2025-10-19
Requirements: FastAPI, sentence-transformers, psycopg2, pgvector
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from sentence_transformers import SentenceTransformer
import psycopg2
from psycopg2.extras import RealDictCursor
import os
from contextlib import contextmanager
import logging
import re
import time
from enum import Enum

from src.api.hybrid_search import hybrid_search as run_hybrid_search
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

# Global model instance (loaded once at startup)
embedding_model: Optional[SentenceTransformer] = None


# ============================================================================
# Request/Response Models
# ============================================================================

class SemanticSearchRequest(BaseModel):
    """Request model for semantic search"""
    query: str = Field(..., description="Natural language search query", min_length=1, max_length=500)
    limit: int = Field(20, description="Maximum number of results", ge=1, le=100)


class FilteredSearchRequest(BaseModel):
    """Request model for filtered semantic search"""
    query: str = Field(..., description="Natural language search query", min_length=1, max_length=500)
    supplier_name: Optional[str] = Field(None, description="Filter by supplier name (e.g., 'SEM1', 'SABO')")
    weight_min: Optional[float] = Field(None, description="Minimum product weight in kg", ge=0)
    weight_max: Optional[float] = Field(None, description="Maximum product weight in kg", ge=0)
    is_for_sale: Optional[bool] = Field(None, description="Filter by for_sale status")
    is_for_web: Optional[bool] = Field(None, description="Filter by web availability")
    has_image: Optional[bool] = Field(None, description="Filter by image availability")
    limit: int = Field(20, description="Maximum number of results", ge=1, le=100)


class HybridSearchRequest(BaseModel):
    """Request model for advanced hybrid search combining ALL techniques"""
    query: str = Field(..., description="Search query (any language)", min_length=1, max_length=500)
    limit: int = Field(20, description="Maximum number of results", ge=1, le=100)
    weight_preset: str = Field("balanced", description="Ranking weight preset: balanced, exact_priority, semantic_priority, popularity_priority")
    enable_fulltext: bool = Field(True, description="Enable full-text search (GIN indexes)")
    enable_trigram: bool = Field(True, description="Enable trigram fuzzy matching")
    enable_exact: bool = Field(True, description="Enable exact text matching")
    enable_vector: bool = Field(True, description="Enable vector semantic search")


class ProductResult(BaseModel):
    """Response model for a single product"""
    product_id: int
    vendor_code: Optional[str]
    name: Optional[str]
    polish_name: Optional[str]
    ukrainian_name: Optional[str]
    supplier_name: Optional[str]
    weight: Optional[float]
    is_for_sale: Optional[bool]
    is_for_web: Optional[bool]
    has_image: Optional[bool]
    similarity_score: float
    ranking_score: Optional[float] = None


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


# ============================================================================
# Database Connection
# ============================================================================

@contextmanager
def get_db_connection():
    """Context manager for database connections"""
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG, cursor_factory=RealDictCursor)
        yield conn
    except psycopg2.Error as e:
        logger.error(f"Database connection error: {e}")
        raise HTTPException(status_code=500, detail="Database connection failed")
    finally:
        if conn:
            conn.close()


# ============================================================================
# Startup/Shutdown Events
# ============================================================================

@app.on_event("startup")
async def startup_event():
    """Load embedding model and dynamic keywords on startup"""
    global embedding_model, DYNAMIC_KEYWORDS

    try:
        logger.info(f"Loading embedding model: {MODEL_NAME}")
        embedding_model = SentenceTransformer(MODEL_NAME)
        logger.info(f"✅ Model loaded successfully (dim={EMBEDDING_DIM})")
    except Exception as e:
        logger.error(f"Failed to load embedding model: {e}")
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

            logger.info(f"✅ Loaded {len(ukrainian_keywords)} Ukrainian keywords, {len(polish_keywords)} Polish keywords")

    except Exception as e:
        logger.warning(f"Failed to load dynamic keywords: {e}. Using fallback classification.")
        DYNAMIC_KEYWORDS['ukrainian'] = []
        DYNAMIC_KEYWORDS['polish'] = []


@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown"""
    logger.info("Shutting down search API")


# ============================================================================
# Helper Functions
# ============================================================================

def generate_embedding(text: str) -> List[float]:
    """Generate embedding for text query"""
    if embedding_model is None:
        raise HTTPException(status_code=500, detail="Embedding model not loaded")

    embedding = embedding_model.encode(text, convert_to_numpy=True)
    return embedding.tolist()


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

    if DYNAMIC_KEYWORDS['polish']:
        if any(keyword in query_lower for keyword in DYNAMIC_KEYWORDS['polish']) and len(query_stripped.split()) <= 5:
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


# ============================================================================
# Legacy Endpoints - Disabled in v3.0 (Single endpoint architecture)
# ============================================================================

# @app.post("/search/semantic", response_model=SearchResponse)
async def semantic_search_DISABLED(request: SemanticSearchRequest):
    """
    Pure semantic search using vector similarity.

    Use Case: "Find products semantically similar to this query"
    Performance: <100ms with HNSW index for top-20 results
    """
    import time
    start_time = time.time()

    try:
        # Generate query embedding
        query_embedding = generate_embedding(request.query)
        embedding_str = format_embedding_for_postgres(query_embedding)

        # Execute search query
        with get_db_connection() as conn:
            cursor = conn.cursor()

            query = """
                SELECT
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
                    1 - (e.embedding <=> %s::vector) AS similarity_score
                FROM staging_marts.dim_product p
                JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
                ORDER BY e.embedding <=> %s::vector
                LIMIT %s;
            """

            cursor.execute(query, (embedding_str, embedding_str, request.limit))
            rows = cursor.fetchall()

        # Format results
        results = [ProductResult(**dict(row)) for row in rows]

        execution_time_ms = (time.time() - start_time) * 1000

        return SearchResponse(
            query=request.query,
            total_results=len(results),
            execution_time_ms=round(execution_time_ms, 2),
            results=results
        )

    except Exception as e:
        logger.error(f"Semantic search failed: {e}")
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


# @app.post("/search/filtered", response_model=SearchResponse)
async def filtered_search_DISABLED(request: FilteredSearchRequest):
    """
    Filtered semantic search with business logic filters.

    Use Case: "Find similar products from specific supplier that meet criteria"
    Filters: supplier, weight range, sale status, web status, image availability
    """
    import time
    start_time = time.time()

    try:
        # Generate query embedding
        query_embedding = generate_embedding(request.query)
        embedding_str = format_embedding_for_postgres(query_embedding)

        # Build dynamic WHERE clause
        where_conditions = []
        filter_params = []

        if request.supplier_name:
            where_conditions.append("p.supplier_name = %s")
            filter_params.append(request.supplier_name)

        if request.weight_min is not None and request.weight_max is not None:
            where_conditions.append("p.weight BETWEEN %s AND %s")
            filter_params.extend([request.weight_min, request.weight_max])
        elif request.weight_min is not None:
            where_conditions.append("p.weight >= %s")
            filter_params.append(request.weight_min)
        elif request.weight_max is not None:
            where_conditions.append("p.weight <= %s")
            filter_params.append(request.weight_max)

        if request.is_for_sale is not None:
            where_conditions.append("p.is_for_sale = %s")
            filter_params.append(request.is_for_sale)

        if request.is_for_web is not None:
            where_conditions.append("p.is_for_web = %s")
            filter_params.append(request.is_for_web)

        if request.has_image is not None:
            where_conditions.append("p.has_image = %s")
            filter_params.append(request.has_image)

        # Build params in correct order: embedding (SELECT), filters (WHERE), embedding (ORDER BY), limit
        params = [embedding_str] + filter_params + [embedding_str, request.limit]

        # Execute search query
        with get_db_connection() as conn:
            cursor = conn.cursor()

            where_clause = f"WHERE {' AND '.join(where_conditions)}" if where_conditions else ""
            query = f"""
                SELECT
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
                    1 - (e.embedding <=> %s::vector) AS similarity_score
                FROM staging_marts.dim_product p
                JOIN analytics_features.product_embeddings e ON e.product_id = p.product_id
                {where_clause}
                ORDER BY e.embedding <=> %s::vector
                LIMIT %s;
            """

            cursor.execute(query, params)
            rows = cursor.fetchall()

        # Format results
        results = [ProductResult(**dict(row)) for row in rows]

        execution_time_ms = (time.time() - start_time) * 1000

        return SearchResponse(
            query=request.query,
            total_results=len(results),
            execution_time_ms=round(execution_time_ms, 2),
            results=results
        )

    except Exception as e:
        logger.error(f"Filtered search failed: {e}")
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


# @app.post("/search/hybrid", response_model=SearchResponse)
async def hybrid_search_endpoint_DISABLED(request: HybridSearchRequest):
    """
    Advanced Hybrid Search combining ALL search techniques with ML ranking.

    Techniques Used (configurable):
        - Full-Text Search: PostgreSQL GIN indexes with ts_rank
        - Trigram Fuzzy Matching: Typo-tolerant search with similarity scores
        - Exact Text Matching: Fast ILIKE pattern matching
        - Vector Semantic Search: HNSW approximate nearest neighbor

    ML Ensemble Ranking:
        - Combines 7 signals: exact_match, fulltext, trigram, vector similarity,
          popularity, availability, freshness
        - Configurable weight presets: balanced, exact_priority, semantic_priority,
          popularity_priority

    Performance: <200ms for 278k products (all techniques running in parallel)
    """
    try:
        weights: Optional[RankingWeights] = WEIGHT_PRESETS.get(request.weight_preset)
        if weights is None:
            logger.warning(f"Unknown weight preset '{request.weight_preset}', using 'balanced'")
            weights = WEIGHT_PRESETS['balanced']

        result_dict: Dict[str, Any] = await run_hybrid_search(
            query=request.query,
            model=embedding_model,
            limit=request.limit,
            weights=weights,
            enable_fulltext=request.enable_fulltext,
            enable_trigram=request.enable_trigram,
            enable_exact=request.enable_exact,
            enable_vector=request.enable_vector,
        )

        results: List[ProductResult] = []
        for product in result_dict['results']:
            product['similarity_score'] = product.get('ranking_score', 0.0)
            results.append(ProductResult(**product))

        # Log the search query
        search_id = log_search_query(
            query=result_dict['query'],
            total_results=result_dict['total_results'],
            execution_time_ms=result_dict['execution_time_ms'],
            search_type="hybrid"
        )

        return SearchResponse(
            query=result_dict['query'],
            total_results=result_dict['total_results'],
            execution_time_ms=result_dict['execution_time_ms'],
            results=results,
            search_id=search_id
        )

    except Exception as e:
        logger.error(f"Hybrid search failed: {e}")
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


# @app.get("/search/similar/{product_id}", response_model=SearchResponse)
async def find_similar_products_DISABLED(
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
                    p.polish_name,
                    p.ukrainian_name,
                    p.supplier_name,
                    p.weight,
                    p.is_for_sale,
                    p.is_for_web,
                    p.has_image,
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


# @app.post("/search/exact", response_model=SearchResponse)
async def exact_match_search_DISABLED(request: SemanticSearchRequest):
    """
    Fast exact/partial text matching on vendor codes and product names

    Use Cases:
        - Vendor code lookup: "100623SAMKO", "SEM1-BP-001"
        - Exact product names: "Гвинт кріплення", "Klocki hamulcowe"

    Performance: <50ms (no ML inference, pure PostgreSQL text search)
    """
    start_time: float = time.time()

    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()

            search_pattern: str = f"%{request.query}%"

            query: str = """
                SELECT
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
                    CASE
                        WHEN p.vendor_code ILIKE %s THEN 1.0
                        WHEN p.name ILIKE %s THEN 0.95
                        WHEN p.polish_name ILIKE %s THEN 0.90
                        WHEN p.ukrainian_name ILIKE %s THEN 0.90
                        ELSE 0.8
                    END AS similarity_score
                FROM staging_marts.dim_product p
                WHERE
                    p.vendor_code ILIKE %s
                    OR p.name ILIKE %s
                    OR p.polish_name ILIKE %s
                    OR p.ukrainian_name ILIKE %s
                ORDER BY similarity_score DESC, p.product_id
                LIMIT %s;
            """

            cursor.execute(query, (
                search_pattern, search_pattern, search_pattern, search_pattern,
                search_pattern, search_pattern, search_pattern, search_pattern,
                request.limit
            ))
            rows = cursor.fetchall()

        results: List[ProductResult] = [ProductResult(**dict(row)) for row in rows]
        execution_time_ms: float = (time.time() - start_time) * 1000

        return SearchResponse(
            query=request.query,
            total_results=len(results),
            execution_time_ms=round(execution_time_ms, 2),
            results=results
        )

    except Exception as e:
        logger.error(f"Exact match search failed: {e}")
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


@app.post("/search", response_model=SearchResponse)
async def search(request: SemanticSearchRequest):
    """
    **Main Search Endpoint - World-Class AI-Powered Product Search**

    This endpoint combines the best of all search techniques with intelligent ML ranking:
        - **Full-text Search**: PostgreSQL GIN indexes with ts_rank
        - **Trigram Fuzzy Matching**: Typo-tolerant search for misspellings
        - **Exact Text Matching**: Fast exact matches for vendor codes
        - **Vector Semantic Search**: AI embeddings with HNSW indexing
        - **ML Ensemble Ranking**: 7-signal ranking (exact, semantic, popularity, availability, freshness)

    **Intelligent Query Classification** (automatic):
        - VENDOR_CODE: "100623SAMKO" → Prioritizes exact matching
        - EXACT_PHRASE: "Гвинт кріплення" → Prioritizes text matching
        - NATURAL_LANGUAGE: "brake pads for trucks" → Balanced semantic approach

    **Performance**: <200ms for 278,000 products
    **Languages**: Ukrainian, Polish, English
    **Auto-logged**: Every search is tracked for analytics and ML training
    """
    query_type: QueryType = classify_query(request.query)
    logger.info(f"Query '{request.query}' classified as: {query_type.value}")

    weight_preset: str = "balanced"
    if query_type == QueryType.VENDOR_CODE:
        weight_preset = "exact_priority"
        logger.info("Using exact_priority weights for vendor code query")
    elif query_type == QueryType.EXACT_PHRASE:
        weight_preset = "exact_priority"
        logger.info("Using exact_priority weights for exact phrase query")
    else:
        weight_preset = "balanced"
        logger.info("Using balanced weights for natural language query")

    weights: RankingWeights = WEIGHT_PRESETS[weight_preset]

    result_dict: Dict[str, Any] = await run_hybrid_search(
        query=request.query,
        model=embedding_model,
        limit=request.limit,
        weights=weights,
        enable_fulltext=True,
        enable_trigram=True,
        enable_exact=True,
        enable_vector=True,
    )

    results: List[ProductResult] = []
    for product in result_dict['results']:
        product['similarity_score'] = product.get('ranking_score', 0.0)
        results.append(ProductResult(**product))

    # Log the search query
    search_id = log_search_query(
        query=request.query,
        total_results=result_dict['total_results'],
        execution_time_ms=result_dict['execution_time_ms'],
        search_type="smart"
    )

    return SearchResponse(
        query=result_dict['query'],
        total_results=result_dict['total_results'],
        execution_time_ms=result_dict['execution_time_ms'],
        results=results,
        search_id=search_id
    )


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


# ============================================================================
# Run with: uvicorn src.api.search_api:app --reload --port 8000
# ============================================================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
