#!/usr/bin/env python3
"""
Data profiling script for ConcordDb staging tables.
Generates statistics about row counts, null ratios, distinct values, and value distributions.
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import os
from datetime import datetime

# Database connection parameters
DB_CONFIG = {
    'host': os.getenv('PGVECTOR_HOST', 'localhost'),
    'port': int(os.getenv('PGVECTOR_PORT', '5433')),
    'database': os.getenv('PGVECTOR_DATABASE', 'analytics'),
    'user': os.getenv('PGVECTOR_USER', 'analytics'),
    'password': os.getenv('PGVECTOR_PASSWORD', 'analytics')
}

def get_connection():
    """Create database connection."""
    return psycopg2.connect(**DB_CONFIG)

def profile_table(conn, schema: str, table: str) -> dict:
    """
    Profile a single table with comprehensive statistics.

    Returns:
        dict: {
            'row_count': int,
            'column_count': int,
            'columns': [{name, type, null_count, null_ratio, distinct_count, sample_values}]
        }
    """
    with conn.cursor(cursor_factory=RealDictCursor) as cur:
        # Get total row count
        cur.execute(f"SELECT COUNT(*) as count FROM {schema}.{table}")
        row_count = cur.fetchone()['count']

        # Get column information
        cur.execute("""
            SELECT column_name, data_type
            FROM information_schema.columns
            WHERE table_schema = %s AND table_name = %s
            ORDER BY ordinal_position
        """, (schema, table))
        columns_info = cur.fetchall()

        profiled_columns = []

        for col_info in columns_info:
            col_name = col_info['column_name']
            data_type = col_info['data_type']

            # Skip CDC metadata columns for null/distinct analysis
            if col_name in ['kafka_offset', 'kafka_partition', 'kafka_topic', 'ingested_at', 'cdc_operation', 'source_timestamp']:
                continue

            # Null count
            cur.execute(f"SELECT COUNT(*) as null_count FROM {schema}.{table} WHERE {col_name} IS NULL")
            null_count = cur.fetchone()['null_count']
            null_ratio = (null_count / row_count * 100) if row_count > 0 else 0

            # Distinct count (for smaller cardinality)
            try:
                cur.execute(f"SELECT COUNT(DISTINCT {col_name}) as distinct_count FROM {schema}.{table}")
                distinct_count = cur.fetchone()['distinct_count']
            except Exception:
                distinct_count = None  # Complex types may not support DISTINCT

            # Sample values (top 5 by frequency)
            sample_values = []
            try:
                # Skip binary and complex types
                if data_type not in ['bytea', 'uuid', 'USER-DEFINED']:
                    cur.execute(f"""
                        SELECT {col_name}, COUNT(*) as freq
                        FROM {schema}.{table}
                        WHERE {col_name} IS NOT NULL
                        GROUP BY {col_name}
                        ORDER BY freq DESC
                        LIMIT 5
                    """)
                    sample_values = [
                        {'value': str(row[col_name])[:100], 'frequency': row['freq']}
                        for row in cur.fetchall()
                    ]
            except Exception:
                pass  # Some column types may not support grouping

            profiled_columns.append({
                'name': col_name,
                'type': data_type,
                'null_count': null_count,
                'null_ratio': round(null_ratio, 2),
                'distinct_count': distinct_count,
                'sample_values': sample_values
            })

        return {
            'schema': schema,
            'table': table,
            'row_count': row_count,
            'column_count': len(columns_info),
            'columns': profiled_columns
        }

def generate_markdown_report(profiles: list, output_path: str):
    """Generate markdown report from profiling results."""
    lines = [
        "# Data Profiling Report",
        "",
        f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        f"**Database**: {DB_CONFIG['database']} (port {DB_CONFIG['port']})",
        "",
        "## Summary",
        ""
    ]

    # Summary table
    lines.append("| Schema | Table | Rows | Columns |")
    lines.append("|--------|-------|------|---------|")
    for profile in profiles:
        lines.append(f"| `{profile['schema']}` | `{profile['table']}` | {profile['row_count']:,} | {profile['column_count']} |")
    lines.append("")

    # Detailed profiles
    for profile in profiles:
        lines.append("---")
        lines.append("")
        lines.append(f"## {profile['schema']}.{profile['table']}")
        lines.append("")
        lines.append(f"**Total Rows**: {profile['row_count']:,}")
        lines.append("")

        # Column statistics
        lines.append("### Column Statistics")
        lines.append("")
        lines.append("| Column | Type | Nulls | Null % | Distinct |")
        lines.append("|--------|------|-------|--------|----------|")

        for col in profile['columns']:
            distinct_str = f"{col['distinct_count']:,}" if col['distinct_count'] is not None else "N/A"
            lines.append(f"| `{col['name']}` | {col['type']} | {col['null_count']:,} | {col['null_ratio']:.1f}% | {distinct_str} |")

        lines.append("")

        # Value distributions for interesting columns
        high_null_columns = [c for c in profile['columns'] if c['null_ratio'] > 50]
        if high_null_columns:
            lines.append("### High Null Columns (> 50%)")
            lines.append("")
            for col in high_null_columns:
                lines.append(f"- **{col['name']}**: {col['null_ratio']:.1f}% null ({col['null_count']:,} / {profile['row_count']:,})")
            lines.append("")

        # Sample values for categorical columns (low cardinality)
        categorical_columns = [c for c in profile['columns'] if c['distinct_count'] and c['distinct_count'] <= 20 and c['sample_values']]
        if categorical_columns:
            lines.append("### Categorical Columns (≤ 20 distinct values)")
            lines.append("")
            for col in categorical_columns:
                lines.append(f"**{col['name']}** ({col['distinct_count']} distinct):")
                lines.append("")
                for sample in col['sample_values']:
                    lines.append(f"- `{sample['value']}`: {sample['frequency']:,} occurrences")
                lines.append("")

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f"✅ Data profiling report written to: {output_path}")

def main():
    """Main execution."""
    print("Connecting to database...")
    conn = get_connection()

    tables_to_profile = [
        ('staging_staging', 'stg_product'),
        ('bronze', 'product_cdc'),
    ]

    profiles = []

    for schema, table in tables_to_profile:
        print(f"Profiling {schema}.{table}...")
        try:
            profile = profile_table(conn, schema, table)
            profiles.append(profile)
            print(f"  ✅ {profile['row_count']:,} rows, {profile['column_count']} columns")
        except Exception as e:
            print(f"  ❌ Error: {e}")

    conn.close()

    # Generate report
    output_path = os.path.join(os.path.dirname(__file__), '..', 'docs', 'DATA_PROFILING_REPORT.md')
    generate_markdown_report(profiles, output_path)

    print("\n📊 Profiling Summary:")
    for profile in profiles:
        print(f"   {profile['schema']}.{profile['table']}: {profile['row_count']:,} rows")

if __name__ == "__main__":
    main()
