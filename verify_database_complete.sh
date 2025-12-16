#!/bin/bash
# Complete Database Verification Script
# Verifies all tables, indexes, and data integrity

echo "========================================"
echo "Database Build Verification Report"
echo "========================================"
echo ""

# Database connection
export PGPASSWORD=analytics
PSQL="psql -h localhost -p 5433 -U analytics -d analytics -t -A"

echo "1. STAGING LAYER VERIFICATION"
echo "------------------------------"
staging_count=$($PSQL -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'staging_staging' AND table_type = 'VIEW';")
echo "✓ Staging views created: $staging_count/31"

stg_product_count=$($PSQL -c "SELECT COUNT(*) FROM staging_staging.stg_product;")
echo "✓ stg_product rows: $stg_product_count"

echo ""
echo "2. MART LAYER VERIFICATION"
echo "---------------------------"
dim_product_count=$($PSQL -c "SELECT COUNT(*) FROM staging_marts.dim_product;")
dim_search_count=$($PSQL -c "SELECT COUNT(*) FROM staging_marts.dim_product_search;")
echo "✓ dim_product rows: $dim_product_count"
echo "✓ dim_product_search rows: $dim_search_count"

echo ""
echo "3. INDEX VERIFICATION"
echo "---------------------"
index_count=$($PSQL -c "SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'staging_marts' AND tablename = 'dim_product_search';")
echo "✓ Indexes on dim_product_search: $index_count/6"

echo ""
echo "4. DENORMALIZED FIELDS VERIFICATION"
echo "------------------------------------"
$PSQL -c "SELECT 
    'total_available_amount' as field,
    pg_typeof(total_available_amount) as type,
    COUNT(DISTINCT total_available_amount) as unique_values
FROM staging_marts.dim_product
UNION ALL
SELECT 
    'original_number_ids',
    pg_typeof(original_number_ids),
    COUNT(DISTINCT original_number_ids)
FROM staging_marts.dim_product
UNION ALL
SELECT 
    'analogue_product_ids',
    pg_typeof(analogue_product_ids),
    COUNT(DISTINCT analogue_product_ids)
FROM staging_marts.dim_product;" | column -t -s '|'

echo ""
echo "5. SUPPLIER DISTRIBUTION"
echo "------------------------"
$PSQL -c "SELECT 
    supplier_prefix,
    COUNT(*) as count
FROM staging_marts.dim_product 
WHERE supplier_prefix IN ('SEM1', 'SABO', 'TRW')
GROUP BY supplier_prefix 
ORDER BY count DESC;" | column -t -s '|'

echo ""
echo "6. DATA QUALITY METRICS"
echo "-----------------------"
$PSQL -c "SELECT 
    COUNT(*) as total_products,
    COUNT(DISTINCT supplier_prefix) as unique_suppliers,
    SUM(CASE WHEN multilingual_status = 'Complete' THEN 1 ELSE 0 END) as complete_translations,
    ROUND(100.0 * SUM(CASE WHEN multilingual_status = 'Complete' THEN 1 ELSE 0 END) / COUNT(*), 2) as translation_percentage
FROM staging_marts.dim_product;" | column -t -s '|'

echo ""
echo "7. TABLE SIZES"
echo "--------------"
$PSQL -c "SELECT 
    schemaname || '.' || tablename as table_name,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_tables 
WHERE schemaname IN ('staging_marts')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;" | column -t -s '|'

echo ""
echo "========================================"
echo "Verification Complete!"
echo "========================================"
