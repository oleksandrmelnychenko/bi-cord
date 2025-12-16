#!/usr/bin/env python3
"""
Direct search test - executes search logic without running full API
Shows execution time and results for SEM1 supplier filter
"""

import sys
import time
from typing import List, Dict, Any, Optional, Set, Tuple
from dataclasses import dataclass

# Add src to path
sys.path.insert(0, '/Users/oleksandrmelnychenko/Projects/bi-platform')

# Import the search components
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
    print("✅ psycopg2 imported successfully")
except ImportError:
    print("❌ psycopg2 not found. Installing...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--user", "psycopg2-binary"])
    import psycopg2
    from psycopg2.extras import RealDictCursor

# Database configuration
DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "database": "analytics",
    "user": "analytics",
    "password": "analytics"
}

ZERO_VECTOR = [0.0] * 384  # 384-dimensional zero vector

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

def execute_sem1_search(query: str, limit: int = 20):
    """Execute a search with SEM1 filter"""

    print("\n" + "="*80)
    print("  EXECUTING UNIFIED SEARCH WITH SEM1 FILTER")
    print("="*80)
    print(f"\nQuery: '{query}'")
    print(f"Supplier Filter: SEM1")
    print(f"Limit: {limit}")

    start_time = time.perf_counter()

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        # Build filters
        filters = SearchFilters(supplier_name="SEM1")
        filter_clause, filter_params = _build_filter_clause(filters)

        # Simplified search query (without embeddings for this demo)
        sql = f"""
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
                p.created,
                p.updated
            FROM staging_marts.dim_product p
            WHERE TRUE {filter_clause}
        ),
        fulltext_candidates AS (
            SELECT
                fp.product_id,
                0.0 AS vector_score,
                CASE
                    WHEN fp.name ILIKE %s THEN 1.0
                    WHEN fp.ukrainian_name ILIKE %s THEN 0.95
                    WHEN fp.vendor_code ILIKE %s THEN 0.9
                    ELSE 0.5
                END AS fulltext_score,
                0.0 AS trigram_score,
                0.0 AS exact_score
            FROM filtered_products fp
            WHERE
                fp.name ILIKE %s
                OR fp.ukrainian_name ILIKE %s
                OR fp.vendor_code ILIKE %s
            ORDER BY fulltext_score DESC
            LIMIT %s
        ),
        features AS (
            SELECT
                fc.product_id,
                fc.fulltext_score,
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
                fc.fulltext_score as final_score
            FROM fulltext_candidates fc
            JOIN filtered_products fp ON fp.product_id = fc.product_id
        )
        SELECT
            product_id,
            vendor_code,
            name,
            ukrainian_name,
            main_original_number,
            supplier_name,
            weight,
            is_for_sale,
            is_for_web,
            has_image,
            has_analogue,
            final_score,
            COUNT(*) OVER () AS total_count
        FROM features
        ORDER BY final_score DESC, product_id
        LIMIT %s
        """

        search_pattern = f"%{query}%"
        params = filter_params + [
            search_pattern, search_pattern, search_pattern,  # Scoring
            search_pattern, search_pattern, search_pattern,  # WHERE clause
            limit * 2,  # Fetch more for better ranking
            limit
        ]

        cursor.execute(sql, params)
        rows = cursor.fetchall()

        execution_time_ms = (time.perf_counter() - start_time) * 1000

        total_count = rows[0]['total_count'] if rows else 0

        # Display results
        print(f"\n{'='*80}")
        print(f"  SEARCH RESULTS")
        print(f"{'='*80}")
        print(f"\n⏱️  Execution Time: {execution_time_ms:.2f} ms")
        print(f"📊 Total Results: {total_count}")
        print(f"📦 Returned: {len(rows)} products")
        print(f"\n{'='*80}")

        if rows:
            for i, row in enumerate(rows, 1):
                print(f"\n{i}. Product ID: {row['product_id']}")
                print(f"   {'─'*76}")
                print(f"   Vendor Code:     {row['vendor_code']}")
                print(f"   Name:            {row['name'][:60] if row['name'] else 'N/A'}...")
                print(f"   Ukrainian:       {row['ukrainian_name'][:60] if row['ukrainian_name'] else 'N/A'}...")
                print(f"   Supplier:        {row['supplier_name']}")
                print(f"   Weight:          {row['weight']} kg" if row['weight'] else "   Weight:          N/A")
                print(f"   For Sale:        {'✅ Yes' if row['is_for_sale'] else '❌ No'}")
                print(f"   Has Image:       {'✅ Yes' if row['has_image'] else '❌ No'}")
                print(f"   Similarity:      {row['final_score']:.4f}")
        else:
            print("\n⚠️  No results found")

        print(f"\n{'='*80}")
        print(f"  PERFORMANCE SUMMARY")
        print(f"{'='*80}")
        print(f"  Query:           '{query}'")
        print(f"  Supplier:        SEM1")
        print(f"  Execution Time:  {execution_time_ms:.2f} ms")
        print(f"  Results:         {total_count} total, {len(rows)} returned")
        print(f"{'='*80}\n")

        cursor.close()
        conn.close()

        return rows, execution_time_ms, total_count

    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return [], 0, 0

if __name__ == "__main__":
    print("\n" + "="*80)
    print("  SEM1 SUPPLIER SEARCH - LIVE TEST")
    print("="*80)

    # Test 1: Search for "тяга" (steering rod)
    execute_sem1_search("тяга", limit=20)

    # Test 2: Search by vendor code
    print("\n")
    execute_sem1_search("SEM14", limit=20)

    # Test 3: Search for "рулевая" (steering)
    print("\n")
    execute_sem1_search("рулевая", limit=20)
