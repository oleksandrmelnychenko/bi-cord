#!/usr/bin/env python3
"""
Generate dbt staging models for all Product-related tables.
Automatically creates SQL models from schema DDL.
"""

import re
from pathlib import Path
from typing import List, Dict

# Product-related tables to create staging models for
PRODUCT_TABLES = [
    'ProductAnalogue',
    'ProductAvailability',
    'ProductAvailabilityCartLimits',
    'ProductCapitalization',
    'ProductCapitalizationItem',
    'ProductCarBrand',
    'ProductCategory',
    'ProductGroup',
    'ProductGroupDiscount',
    'ProductImage',
    'ProductIncome',
    'ProductIncomeItem',
    'ProductLocation',
    'ProductLocationHistory',
    'ProductOriginalNumber',
    'ProductPlacement',
    'ProductPlacementHistory',
    'ProductPlacementMovement',
    'ProductPlacementStorage',
    'ProductPricing',
    'ProductProductGroup',
    'ProductReservation',
    'ProductSet',
    'ProductSlug',
    'ProductSpecification',
    'ProductSubGroup',
    'ProductTransfer',
    'ProductTransferItem',
    'ProductWriteOffRule',
    'MeasureUnit'  # Referenced by Product table
]

def parse_table_schema(schema_file: Path, table_name: str) -> List[Dict]:
    """
    Extract column definitions from SQL DDL.

    Returns:
        List[Dict]: [{'name': str, 'type': str, 'nullable': bool}]
    """
    with open(schema_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find table definition
    pattern = f"create table {table_name}\\s*\\((.*?)\\)\\s*go"
    match = re.search(pattern, content, re.DOTALL | re.IGNORECASE)

    if not match:
        print(f"⚠️  Table {table_name} not found in schema")
        return []

    table_def = match.group(1)
    columns = []

    # Parse each line
    for line in table_def.split('\n'):
        line = line.strip()

        # Skip empty lines, constraints, and comments
        if not line or line.startswith('constraint') or line.startswith('--'):
            continue

        # Extract column name and type
        parts = line.split(None, 2)
        if len(parts) < 2:
            continue

        col_name = parts[0].strip('[]')  # Remove brackets if present
        col_type = parts[1]

        # Skip if it's a constraint keyword
        if col_name.lower() in ['constraint', 'primary', 'foreign', 'unique', 'check']:
            continue

        # Determine nullability
        nullable = 'not null' not in line.lower()

        # Map SQL Server types to PostgreSQL types
        pg_type = map_sql_type_to_pg(col_type)

        columns.append({
            'name': col_name,
            'type': col_type,
            'pg_type': pg_type,
            'nullable': nullable
        })

    return columns

def map_sql_type_to_pg(sql_type: str) -> str:
    """Map SQL Server types to PostgreSQL types for casting."""
    type_map = {
        'bigint': 'bigint',
        'int': 'integer',
        'smallint': 'smallint',
        'tinyint': 'smallint',
        'bit': 'boolean',
        'decimal': 'numeric',
        'numeric': 'numeric',
        'float': 'numeric',
        'real': 'real',
        'money': 'numeric',
        'datetime2': 'timestamp',
        'datetime': 'timestamp',
        'date': 'date',
        'time': 'time',
        'uniqueidentifier': 'uuid',
        'nvarchar': 'text',
        'varchar': 'text',
        'nchar': 'text',
        'char': 'text',
        'text': 'text',
        'ntext': 'text',
        'varbinary': 'bytea',
        'binary': 'bytea',
        'image': 'bytea'
    }

    # Extract base type (handle types like 'nvarchar(120)')
    base_type = sql_type.split('(')[0].lower()
    return type_map.get(base_type, 'text')

def generate_dbt_model(table_name: str, columns: List[Dict]) -> str:
    """Generate dbt SQL model for a table."""

    # Convert table name to snake_case
    model_name = re.sub(r'(?<!^)(?=[A-Z])', '_', table_name).lower()

    # Generate column selections
    column_lines = []
    for col in columns:
        col_lower = re.sub(r'(?<!^)(?=[A-Z])', '_', col['name']).lower()

        # Handle special conversions
        if col['type'] == 'datetime2' or col['type'] == 'datetime':
            # Check if it's a timestamp in milliseconds
            if col['name'] in ['Created', 'Updated']:
                cast_expr = f"to_timestamp((cdc_payload->'payload'->'after'->>'{col['name']}')::bigint / 1000)"
            else:
                cast_expr = f"(cdc_payload->'payload'->'after'->>'{col['name']}')::timestamp"
        elif col['pg_type'] == 'uuid':
            cast_expr = f"(cdc_payload->'payload'->'after'->>'{col['name']}')::{col['pg_type']}"
        elif col['pg_type'] == 'bytea':
            cast_expr = f"(cdc_payload->'payload'->'after'->>'{col['name']}')::{col['pg_type']}"
        else:
            cast_expr = f"(cdc_payload->'payload'->'after'->>'{col['name']}')::{col['pg_type']}"

        column_lines.append(f"        {cast_expr} as {col_lower}")

    columns_sql = ',\n'.join(column_lines)

    # Generate model
    model = f"""{{{{
  config(
    materialized='view',
    schema='staging'
  )
}}}}

with source as (
    select * from {{{{ source('bronze', '{model_name}_cdc') }}}}
),

parsed as (
    select
{columns_sql},
        -- CDC Metadata
        cdc_payload->'payload'->>'op' as cdc_operation,
        (cdc_payload->'payload'->'source'->>'ts_ms')::bigint as source_ts_ms,
        to_timestamp((cdc_payload->'payload'->'source'->>'ts_ms')::bigint / 1000) as source_timestamp,
        (cdc_payload->'payload'->'source'->>'snapshot')::text as is_snapshot,
        kafka_offset,
        kafka_partition,
        kafka_topic,
        ingested_at
    from source
    where cdc_payload->'payload'->'after' is not null
),

deduplicated as (
    select
        *,
        row_number() over (
            partition by id
            order by source_ts_ms desc, kafka_offset desc
        ) as rn
    from parsed
)

select
    *
from deduplicated
where rn = 1 and deleted = false
"""

    return model

def generate_schema_yml(table_configs: List[Dict]) -> str:
    """Generate schema.yml for all Product tables."""

    lines = [
        "version: 2",
        "",
        "sources:",
        "  - name: bronze",
        "    description: 'Bronze layer containing raw CDC events from Debezium'",
        "    schema: bronze",
        "    tables:"
    ]

    # Add bronze sources
    for config in table_configs:
        model_name = re.sub(r'(?<!^)(?=[A-Z])', '_', config['table_name']).lower()
        lines.append(f"      - name: {model_name}_cdc")
        lines.append(f"        description: 'Raw {config['table_name']} CDC events'")
        lines.append("")

    lines.append("models:")

    # Add model definitions
    for config in table_configs:
        model_name = re.sub(r'(?<!^)(?=[A-Z])', '_', config['table_name']).lower()
        lines.append(f"  - name: stg_{model_name}")
        lines.append(f"    description: 'Staging model for {config['table_name']} table'")
        lines.append("    columns:")
        lines.append("      - name: id")
        lines.append("        description: 'Primary key'")
        lines.append("        tests:")
        lines.append("          - not_null")
        lines.append("          - unique")
        lines.append("")

    return '\n'.join(lines)

def main():
    """Generate all staging models."""
    base_dir = Path(__file__).parent.parent
    schema_file = base_dir / "docs" / "complete_schema.sql"
    output_dir = base_dir / "dbt" / "models" / "staging" / "product_ecosystem"

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Reading schema from: {schema_file}")
    print(f"Output directory: {output_dir}")
    print("")

    table_configs = []

    for table_name in PRODUCT_TABLES:
        print(f"Processing {table_name}...")

        # Parse schema
        columns = parse_table_schema(schema_file, table_name)

        if not columns:
            print(f"  ❌ Skipped (no columns found)")
            continue

        # Generate model
        model_sql = generate_dbt_model(table_name, columns)

        # Write model file
        model_name = re.sub(r'(?<!^)(?=[A-Z])', '_', table_name).lower()
        output_file = output_dir / f"stg_{model_name}.sql"

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(model_sql)

        table_configs.append({
            'table_name': table_name,
            'model_name': model_name,
            'column_count': len(columns)
        })

        print(f"  ✅ Created stg_{model_name}.sql ({len(columns)} columns)")

    # Generate schema.yml
    schema_yml = generate_schema_yml(table_configs)
    schema_file = output_dir / "schema.yml"

    with open(schema_file, 'w', encoding='utf-8') as f:
        f.write(schema_yml)

    print("")
    print(f"✅ Generated {len(table_configs)} staging models")
    print(f"✅ Generated schema.yml with {len(table_configs)} sources")
    print("")
    print("📋 Summary:")
    for config in table_configs:
        print(f"   - stg_{config['model_name']}: {config['column_count']} columns")

if __name__ == "__main__":
    main()
