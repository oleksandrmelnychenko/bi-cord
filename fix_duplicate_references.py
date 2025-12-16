#!/usr/bin/env python3
"""
Fix duplicate 'as references' and 'as on' column definitions in dbt staging models.
Keeps only the first occurrence of each duplicate column.
"""

import re
from pathlib import Path

def fix_duplicate_columns(file_path):
    """Remove duplicate 'as references' and 'as on' lines from a SQL file."""
    with open(file_path, 'r') as f:
        lines = f.readlines()

    # Track which columns we've seen in the SELECT clause
    seen_references = False
    seen_on = False
    in_parsed_cte = False
    fixed_lines = []
    removed_count = 0

    for i, line in enumerate(lines):
        # Detect when we're in the parsed CTE
        if 'parsed as' in line.lower():
            in_parsed_cte = True
            seen_references = False
            seen_on = False

        # Reset when we exit the parsed CTE
        if in_parsed_cte and re.match(r'^\s*\),?\s*$', line):
            in_parsed_cte = False

        # Check if this line defines 'as references' or 'as on'
        is_references_line = 'as references' in line.lower()
        is_on_line = re.search(r'\bas on\b', line.lower())

        # If we're in the parsed CTE and find a duplicate, skip it
        if in_parsed_cte:
            if is_references_line:
                if seen_references:
                    print(f"  Removing duplicate 'as references' at line {i+1}: {line.strip()}")
                    removed_count += 1
                    continue
                else:
                    seen_references = True

            if is_on_line and not is_references_line:  # Don't confuse with other 'on' keywords
                if seen_on:
                    print(f"  Removing duplicate 'as on' at line {i+1}: {line.strip()}")
                    removed_count += 1
                    continue
                else:
                    seen_on = True

        fixed_lines.append(line)

    # Write back if we made changes
    if removed_count > 0:
        with open(file_path, 'w') as f:
            f.writelines(fixed_lines)
        print(f"  ✓ Removed {removed_count} duplicate column(s)")
        return True
    else:
        print(f"  ✓ No duplicates found")
        return False

def main():
    staging_dir = Path('/Users/oleksandrmelnychenko/Projects/bi-platform/dbt/models/staging/product_ecosystem')
    sql_files = list(staging_dir.glob('*.sql'))

    print(f"Processing {len(sql_files)} SQL files...\n")

    fixed_count = 0
    for sql_file in sorted(sql_files):
        print(f"Processing {sql_file.name}...")
        if fix_duplicate_columns(sql_file):
            fixed_count += 1

    print(f"\n{'='*60}")
    print(f"Summary: Fixed {fixed_count} files")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
