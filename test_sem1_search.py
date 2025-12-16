#!/usr/bin/env python3
"""
Direct test of search functionality with SEM1 supplier filter
This tests the search logic without running the full API server
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import time

# Database configuration
DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "database": "analytics",
    "user": "analytics",
    "password": "analytics"
}

def test_sem1_search():
    """Test search with SEM1 supplier filter"""

    print("\n" + "="*60)
    print("  Testing Search with SEM1 Supplier Filter")
    print("="*60)

    start_time = time.time()

    try:
        # Connect to database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        # Test query with SEM1 filter
        query = """
            SELECT
                product_id,
                vendor_code,
                name,
                ukrainian_name,
                supplier_name,
                weight,
                is_for_sale,
                is_for_web,
                has_image,
                has_analogue
            FROM staging_marts.dim_product
            WHERE supplier_name = %s
                AND name IS NOT NULL
            ORDER BY product_id
            LIMIT 10;
        """

        cursor.execute(query, ('SEM1',))
        rows = cursor.fetchall()

        execution_time_ms = (time.time() - start_time) * 1000

        print(f"\n✅ Query executed successfully!")
        print(f"⏱️  Execution time: {execution_time_ms:.2f}ms")
        print(f"📊 Results found: {len(rows)} products")

        if rows:
            print(f"\n{'='*60}")
            print("  Sample SEM1 Products")
            print('='*60)

            for i, row in enumerate(rows, 1):
                print(f"\n{i}. Product ID: {row['product_id']}")
                print(f"   Vendor Code: {row['vendor_code']}")
                print(f"   Name: {row['name'][:60] if row['name'] else 'N/A'}...")
                print(f"   Ukrainian: {row['ukrainian_name'][:60] if row['ukrainian_name'] else 'N/A'}...")
                print(f"   Supplier: {row['supplier_name']}")
                print(f"   Weight: {row['weight']} kg" if row['weight'] else "   Weight: N/A")
                print(f"   For Sale: {'Yes' if row['is_for_sale'] else 'No'}")
                print(f"   Has Image: {'Yes' if row['has_image'] else 'No'}")

        # Get total count of SEM1 products
        cursor.execute("""
            SELECT COUNT(*) as total
            FROM staging_marts.dim_product
            WHERE supplier_name = 'SEM1'
        """)
        total = cursor.fetchone()['total']

        print(f"\n{'='*60}")
        print(f"  Total SEM1 products in database: {total:,}")
        print('='*60)

        cursor.close()
        conn.close()

        return True

    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False


def test_sem1_with_text_search():
    """Test combined SEM1 filter with text search"""

    print("\n" + "="*60)
    print("  Testing SEM1 + Text Search (brake pads)")
    print("="*60)

    start_time = time.time()

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        # Search for brake pads from SEM1
        search_pattern = "%brake%"

        query = """
            SELECT
                product_id,
                vendor_code,
                name,
                ukrainian_name,
                supplier_name,
                weight,
                is_for_sale
            FROM staging_marts.dim_product
            WHERE supplier_name = %s
                AND (
                    name ILIKE %s
                    OR ukrainian_name ILIKE %s
                    OR vendor_code ILIKE %s
                )
            ORDER BY
                CASE WHEN name ILIKE %s THEN 1 ELSE 2 END,
                product_id
            LIMIT 5;
        """

        cursor.execute(query, ('SEM1', search_pattern, search_pattern, search_pattern, search_pattern))
        rows = cursor.fetchall()

        execution_time_ms = (time.time() - start_time) * 1000

        print(f"\n✅ Combined search executed!")
        print(f"⏱️  Execution time: {execution_time_ms:.2f}ms")
        print(f"📊 Results found: {len(rows)} products")

        if rows:
            print(f"\n{'='*60}")
            print("  SEM1 Products Matching 'brake'")
            print('='*60)

            for i, row in enumerate(rows, 1):
                print(f"\n{i}. [{row['product_id']}] {row['vendor_code']}")
                print(f"   {row['name']}")
                if row['ukrainian_name']:
                    print(f"   🇺🇦 {row['ukrainian_name']}")
                print(f"   Supplier: {row['supplier_name']}")
                print(f"   For Sale: {'✅' if row['is_for_sale'] else '❌'}")
        else:
            print("\n⚠️  No results found for 'brake' in SEM1 products")
            print("   Try searching for other terms...")

        cursor.close()
        conn.close()

        return True

    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False


def test_supplier_stats():
    """Show statistics for all suppliers"""

    print("\n" + "="*60)
    print("  Supplier Statistics")
    print("="*60)

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        query = """
            SELECT
                supplier_name,
                COUNT(*) as product_count,
                COUNT(CASE WHEN is_for_sale THEN 1 END) as for_sale_count,
                COUNT(CASE WHEN has_image THEN 1 END) as with_image_count
            FROM staging_marts.dim_product
            WHERE supplier_name IS NOT NULL
            GROUP BY supplier_name
            ORDER BY product_count DESC
            LIMIT 10;
        """

        cursor.execute(query)
        rows = cursor.fetchall()

        print(f"\n{'Supplier':<15} {'Total':>10} {'For Sale':>10} {'With Image':>12}")
        print("-" * 60)

        for row in rows:
            print(f"{row['supplier_name']:<15} {row['product_count']:>10,} "
                  f"{row['for_sale_count']:>10,} {row['with_image_count']:>12,}")

        cursor.close()
        conn.close()

        return True

    except Exception as e:
        print(f"\n❌ Error: {e}")
        return False


if __name__ == "__main__":
    print("\n" + "="*60)
    print("  SEM1 SEARCH TEST SUITE")
    print("="*60)

    # Test 1: Basic SEM1 filter
    test_sem1_search()

    # Test 2: SEM1 + text search
    test_sem1_with_text_search()

    # Test 3: Supplier statistics
    test_supplier_stats()

    print("\n" + "="*60)
    print("  TEST SUITE COMPLETE")
    print("="*60)
    print("\n✅ All tests completed!")
