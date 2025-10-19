#!/usr/bin/env python3
"""
Generate comprehensive data dictionary from SQL DDL schema.
Parses complete_schema.sql and creates markdown documentation.
"""

import re
from collections import defaultdict
from pathlib import Path

def parse_schema_file(schema_path: str) -> dict:
    """
    Parse SQL DDL file and extract table definitions.

    Returns:
        dict: {table_name: {'columns': [...], 'indexes': [...], 'constraints': [...]}}
    """
    tables = {}
    current_table = None
    current_section = None

    with open(schema_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by 'go' statements
    statements = content.split('\ngo\n')

    for statement in statements:
        statement = statement.strip()

        # Check for CREATE TABLE
        create_match = re.match(r'create table (\w+)', statement, re.IGNORECASE)
        if create_match:
            current_table = create_match.group(1)
            tables[current_table] = {
                'columns': [],
                'indexes': [],
                'foreign_keys': [],
                'constraints': []
            }

            # Extract columns from table definition
            lines = statement.split('\n')
            in_columns = False

            for line in lines:
                line = line.strip()

                # Skip the CREATE TABLE line
                if line.startswith('create table'):
                    in_columns = True
                    continue

                # Skip opening parenthesis
                if line == '(':
                    continue

                # End of table definition
                if line == ')':
                    break

                # Parse column definition
                if in_columns and line and not line.startswith('constraint'):
                    # Remove trailing comma
                    line = line.rstrip(',')

                    # Check if it's a constraint
                    if 'constraint' in line.lower():
                        if 'references' in line.lower():
                            tables[current_table]['foreign_keys'].append(line)
                        else:
                            tables[current_table]['constraints'].append(line)
                    else:
                        # It's a column definition
                        tables[current_table]['columns'].append(line)

            continue

        # Check for CREATE INDEX
        index_match = re.match(r'create (?:unique )?index (\w+)\s+on (\w+)', statement, re.IGNORECASE)
        if index_match:
            index_name = index_match.group(1)
            table_name = index_match.group(2)

            if table_name in tables:
                tables[table_name]['indexes'].append(statement)

    return tables

def extract_column_info(column_def: str) -> dict:
    """
    Extract column name, type, and attributes from column definition.

    Example input:
        "ID bigint identity constraint PK_Product primary key with (fillfactor = 60)"

    Returns:
        {'name': 'ID', 'type': 'bigint', 'attributes': 'identity, primary key, ...'}
    """
    # Handle special case of [Top] or other bracketed names
    if column_def.strip().startswith('['):
        name_match = re.match(r'\[(\w+)\]\s+(.+)', column_def)
        if name_match:
            name = name_match.group(1)
            rest = name_match.group(2)
        else:
            return {'name': column_def[:50], 'type': 'unknown', 'attributes': ''}
    else:
        parts = column_def.split(None, 2)
        if len(parts) < 2:
            return {'name': column_def[:50], 'type': 'unknown', 'attributes': ''}

        name = parts[0]
        rest = column_def[len(name):].strip()

    # Extract type (next word or parenthesized expression)
    type_match = re.match(r'(\w+(?:\([^)]+\))?)\s*(.*)', rest)
    if type_match:
        col_type = type_match.group(1)
        attributes = type_match.group(2).strip()
    else:
        col_type = 'unknown'
        attributes = rest

    return {
        'name': name,
        'type': col_type,
        'attributes': attributes
    }

def generate_markdown_dictionary(tables: dict, output_path: str, focus_tables: list = None):
    """
    Generate markdown data dictionary.

    Args:
        tables: Parsed table definitions
        output_path: Path to write markdown file
        focus_tables: Optional list of tables to prioritize (will appear first)
    """
    lines = [
        "# Complete Data Dictionary",
        "",
        f"**Total Tables**: {len(tables)}",
        f"**Source**: `docs/complete_schema.sql`",
        "",
        "## Table of Contents",
        ""
    ]

    # Determine order: focus tables first, then alphabetical
    if focus_tables:
        ordered_tables = []
        for table in focus_tables:
            if table in tables:
                ordered_tables.append(table)

        # Add remaining tables alphabetically
        remaining = sorted([t for t in tables.keys() if t not in ordered_tables])
        ordered_tables.extend(remaining)
    else:
        ordered_tables = sorted(tables.keys())

    # Generate table of contents
    for table_name in ordered_tables:
        lines.append(f"- [{table_name}](#{table_name.lower()})")

    lines.append("")
    lines.append("---")
    lines.append("")

    # Generate table documentation
    for table_name in ordered_tables:
        table_info = tables[table_name]

        lines.append(f"## {table_name}")
        lines.append("")

        # Column count
        col_count = len(table_info['columns'])
        fk_count = len(table_info['foreign_keys'])
        idx_count = len(table_info['indexes'])

        lines.append(f"**Columns**: {col_count} | **Foreign Keys**: {fk_count} | **Indexes**: {idx_count}")
        lines.append("")

        # Columns table
        if table_info['columns']:
            lines.append("| Column | Type | Attributes |")
            lines.append("|--------|------|------------|")

            for col_def in table_info['columns']:
                col_info = extract_column_info(col_def)
                name = col_info['name']
                col_type = col_info['type']
                attrs = col_info['attributes'].replace('|', '\\|')  # Escape pipes

                # Truncate long attributes
                if len(attrs) > 100:
                    attrs = attrs[:97] + "..."

                lines.append(f"| `{name}` | {col_type} | {attrs} |")

            lines.append("")

        # Foreign Keys
        if table_info['foreign_keys']:
            lines.append("**Foreign Keys**:")
            lines.append("")
            for fk in table_info['foreign_keys']:
                # Extract referenced table
                ref_match = re.search(r'references (\w+)', fk, re.IGNORECASE)
                if ref_match:
                    ref_table = ref_match.group(1)
                    lines.append(f"- → `{ref_table}`")
            lines.append("")

        # Indexes
        if table_info['indexes']:
            lines.append("**Indexes**:")
            lines.append("")
            for idx in table_info['indexes']:
                # Extract index name
                idx_match = re.match(r'create (?:unique )?index (\w+)', idx, re.IGNORECASE)
                if idx_match:
                    idx_name = idx_match.group(1)
                    lines.append(f"- `{idx_name}`")
            lines.append("")

        lines.append("---")
        lines.append("")

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print(f"✅ Data dictionary generated: {output_path}")
    print(f"   {len(tables)} tables documented")

def main():
    """Main execution."""
    # Paths
    base_dir = Path(__file__).parent.parent
    schema_path = base_dir / "docs" / "complete_schema.sql"
    output_path = base_dir / "docs" / "complete_data_dictionary.md"

    print(f"Parsing schema: {schema_path}")

    # Parse schema
    tables = parse_schema_file(str(schema_path))

    print(f"Found {len(tables)} tables")

    # Focus tables (appear first in dictionary)
    focus_tables = [
        # Core product tables
        "Product",
        "ProductCategory",
        "ProductGroup",
        "ProductSubGroup",
        "ProductPricing",
        "ProductImage",
        "ProductAvailability",
        "ProductAnalogue",
        "ProductSpecification",
        "ProductOriginalNumber",

        # Orders & Sales
        "Order",
        "OrderItem",
        "Sale",

        # Clients
        "Client",
        "ClientAgreement",
        "ClientType",

        # Reference data
        "MeasureUnit",
        "Currency",
        "Country",
        "Region"
    ]

    # Generate dictionary
    generate_markdown_dictionary(tables, str(output_path), focus_tables)

    # Print summary
    print("\n📊 Schema Summary:")
    print(f"   Total tables: {len(tables)}")

    # Count tables with FKs
    tables_with_fks = sum(1 for t in tables.values() if t['foreign_keys'])
    print(f"   Tables with foreign keys: {tables_with_fks}")

    # Count total indexes
    total_indexes = sum(len(t['indexes']) for t in tables.values())
    print(f"   Total indexes: {total_indexes}")

    # Product-related tables
    product_tables = [t for t in tables.keys() if t.startswith('Product')]
    print(f"   Product-related tables: {len(product_tables)}")

    print(f"\n✅ Complete data dictionary written to: {output_path}")

if __name__ == "__main__":
    main()
