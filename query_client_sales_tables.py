#!/usr/bin/env python3
"""
Query SQL Server for Client and Sales related tables
"""
import pymssql
import sys

def main():
    try:
        print("Connecting to SQL Server 78.152.175.67...")
        conn = pymssql.connect(
            server='78.152.175.67',
            port=1433,
            user='ef_migrator',
            password='Grimm_jow92',
            database='ConcordDb'
        )

        cursor = conn.cursor()

        # Get Client/Sales related tables
        query = """
        SELECT
            t.TABLE_NAME,
            (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS c
             WHERE c.TABLE_NAME = t.TABLE_NAME AND c.TABLE_SCHEMA = 'dbo') as column_count
        FROM INFORMATION_SCHEMA.TABLES t
        WHERE t.TABLE_TYPE = 'BASE TABLE'
            AND t.TABLE_SCHEMA = 'dbo'
            AND (
                t.TABLE_NAME LIKE '%Client%'
                OR t.TABLE_NAME LIKE '%Customer%'
                OR t.TABLE_NAME LIKE '%Sale%'
                OR t.TABLE_NAME LIKE '%Order%'
                OR t.TABLE_NAME LIKE '%Invoice%'
                OR t.TABLE_NAME LIKE '%Cart%'
                OR t.TABLE_NAME LIKE '%Buyer%'
                OR t.TABLE_NAME LIKE '%Purchase%'
            )
        ORDER BY t.TABLE_NAME
        """

        cursor.execute(query)
        rows = cursor.fetchall()

        print("\n" + "=" * 70)
        print("CLIENT & SALES RELATED TABLES IN ConcordDb")
        print("=" * 70 + "\n")

        if rows:
            for row in rows:
                table_name = row[0]
                col_count = row[1]
                print(f"✓ dbo.{table_name:<50} ({col_count:>3} columns)")
            print(f"\n{'=' * 70}")
            print(f"Total: {len(rows)} tables found")
            print("=" * 70)

            # Get row counts for each table
            print("\nFetching row counts...")
            for row in rows:
                table_name = row[0]
                try:
                    cursor.execute(f"SELECT COUNT(*) FROM dbo.[{table_name}]")
                    count = cursor.fetchone()[0]
                    print(f"  dbo.{table_name:<50} {count:>10,} rows")
                except Exception as e:
                    print(f"  dbo.{table_name:<50} ERROR: {e}")
        else:
            print("❌ No Client/Sales related tables found.")
            print("\nShowing first 30 tables in database...")
            cursor.execute("""
                SELECT TOP 30 TABLE_NAME
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = 'dbo'
                ORDER BY TABLE_NAME
            """)
            for i, row in enumerate(cursor, 1):
                print(f"{i:2}. dbo.{row[0]}")

        cursor.close()
        conn.close()

    except Exception as e:
        print(f"\n❌ ERROR: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
