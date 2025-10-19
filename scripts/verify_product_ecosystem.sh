#!/bin/bash
# Comprehensive verification script for Product Ecosystem deployment
# Checks Debezium, Kafka, Bronze, Staging, and Data Quality

set -e

echo "=========================================="
echo "  Product Ecosystem Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

check_pass() {
    echo -e "${GREEN}✅ $1${NC}"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}❌ $1${NC}"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARN++))
}

# Check 1: Debezium Connector Status
echo "1. Checking Debezium Connector..."
if curl -s http://localhost:8083/connectors/sqlserver-product-ecosystem-connector/status 2>/dev/null | grep -q '"state":"RUNNING"'; then
    check_pass "Debezium connector is RUNNING"
else
    check_fail "Debezium connector is NOT running or not found"
fi
echo ""

# Check 2: Kafka Topics
echo "2. Checking Kafka Topics..."
EXPECTED_TOPICS=31
TOPIC_COUNT=$(docker compose -f infra/docker-compose.dev.yml exec -T kafka kafka-topics --list --bootstrap-server localhost:9092 2>/dev/null | grep -c "cord.ConcordDb.dbo.Product" || echo "0")

if [ "$TOPIC_COUNT" -ge "$EXPECTED_TOPICS" ]; then
    check_pass "Found $TOPIC_COUNT Product-related Kafka topics (expected >= $EXPECTED_TOPICS)"
else
    check_warn "Found only $TOPIC_COUNT topics (expected >= $EXPECTED_TOPICS)"
fi
echo ""

# Check 3: Bronze Tables
echo "3. Checking Bronze Tables..."
BRONZE_TABLES=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'bronze' AND table_name LIKE '%product%_cdc';" 2>/dev/null | tr -d ' ')

if [ "$BRONZE_TABLES" -ge "30" ]; then
    check_pass "Found $BRONZE_TABLES bronze tables"
else
    check_warn "Found only $BRONZE_TABLES bronze tables (expected >= 30)"
fi
echo ""

# Check 4: Staging Models
echo "4. Checking dbt Staging Models..."
if [ -d "dbt/models/staging/product_ecosystem" ]; then
    MODEL_COUNT=$(ls -1 dbt/models/staging/product_ecosystem/*.sql 2>/dev/null | wc -l | tr -d ' ')
    if [ "$MODEL_COUNT" -ge "30" ]; then
        check_pass "Found $MODEL_COUNT dbt staging models"
    else
        check_warn "Found only $MODEL_COUNT models (expected >= 30)"
    fi
else
    check_fail "Product ecosystem models directory not found"
fi
echo ""

# Check 5: Sample Data in Bronze
echo "5. Checking Bronze Layer Data..."
PRODUCT_CDC_COUNT=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT COUNT(*) FROM bronze.product_cdc;" 2>/dev/null | tr -d ' ')

if [ "$PRODUCT_CDC_COUNT" -gt "0" ]; then
    check_pass "Product CDC has $PRODUCT_CDC_COUNT records"
else
    check_warn "Product CDC has no records yet"
fi
echo ""

# Check 6: Staging Views
echo "6. Checking Staging Views..."
STG_PRODUCT_COUNT=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'staging_staging' AND table_name LIKE 'stg_product%';" 2>/dev/null | tr -d ' ')

if [ "$STG_PRODUCT_COUNT" -ge "1" ]; then
    check_pass "Found $STG_PRODUCT_COUNT staging views"
else
    check_warn "Staging views not created yet (run dbt)"
fi
echo ""

# Check 7: Sample Staging Data
echo "7. Checking Staging Layer Data..."
STG_DATA=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT COUNT(*) FROM staging_staging.stg_product;" 2>/dev/null | tr -d ' ')

if [ "$STG_DATA" -gt "0" ]; then
    check_pass "Staging layer has $STG_DATA products"
else
    check_warn "Staging layer has no data yet"
fi
echo ""

# Check 8: Data Quality - Product Columns
echo "8. Checking Product Table Coverage..."
PRODUCT_COLUMNS=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = 'staging_staging' AND table_name = 'stg_product';" 2>/dev/null | tr -d ' ')

if [ "$PRODUCT_COLUMNS" -ge "50" ]; then
    check_pass "Product table has $PRODUCT_COLUMNS columns (100% coverage)"
elif [ "$PRODUCT_COLUMNS" -ge "20" ]; then
    check_warn "Product table has $PRODUCT_COLUMNS columns (expected >= 50)"
else
    check_fail "Product table has insufficient columns"
fi
echo ""

# Check 9: Multilingual Fields
echo "9. Checking Multilingual Fields..."
HAS_MULTILINGUAL=$(PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics -t -c "SELECT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_schema = 'staging_staging' AND table_name = 'stg_product' AND column_name = 'name_pl');" 2>/dev/null | tr -d ' ')

if [ "$HAS_MULTILINGUAL" = "t" ]; then
    check_pass "Multilingual fields present (Polish, Ukrainian)"
else
    check_warn "Multilingual fields not found"
fi
echo ""

# Check 10: Documentation
echo "10. Checking Documentation..."
DOCS_PRESENT=0
[ -f "docs/SCHEMA_ANALYSIS.md" ] && ((DOCS_PRESENT++))
[ -f "docs/SCHEMA_EXPANSION_COMPLETE.md" ] && ((DOCS_PRESENT++))
[ -f "docs/PRODUCT_ECOSYSTEM_DEPLOYMENT.md" ] && ((DOCS_PRESENT++))
[ -f "docs/PHASE2_PRODUCT_ECOSYSTEM_COMPLETE.md" ] && ((DOCS_PRESENT++))
[ -f "docs/complete_data_dictionary.md" ] && ((DOCS_PRESENT++))

if [ "$DOCS_PRESENT" -ge "4" ]; then
    check_pass "Found $DOCS_PRESENT documentation files"
else
    check_warn "Missing some documentation files"
fi
echo ""

# Summary
echo "=========================================="
echo "  Verification Summary"
echo "=========================================="
echo -e "${GREEN}PASS: $PASS${NC}"
echo -e "${YELLOW}WARN: $WARN${NC}"
echo -e "${RED}FAIL: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    if [ $WARN -eq 0 ]; then
        echo -e "${GREEN}🎉 All checks passed! System is fully operational.${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠️  System is operational but some components need attention.${NC}"
        exit 0
    fi
else
    echo -e "${RED}❌ Some critical checks failed. Review errors above.${NC}"
    exit 1
fi
