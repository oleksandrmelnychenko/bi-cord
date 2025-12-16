#!/bin/bash

# Test script for unified search API with SEM1 supplier filter
# Make sure the API is running: uvicorn src.api.search_api:app --reload --port 8000

API_URL="http://localhost:8000"

echo ""
echo "============================================================"
echo "  UNIFIED SEARCH API - SEM1 SUPPLIER TEST"
echo "============================================================"
echo ""

# Test 1: Check API is running
echo "1️⃣  Testing API Health..."
echo "============================================================"
curl -s "${API_URL}/health" | python3 -m json.tool
echo ""

# Test 2: Get API documentation
echo ""
echo "2️⃣  API Documentation..."
echo "============================================================"
curl -s "${API_URL}/" | python3 -m json.tool
echo ""

# Test 3: Search with SEM1 supplier filter
echo ""
echo "3️⃣  Search with SEM1 Supplier Filter..."
echo "============================================================"
echo "Request:"
cat << 'EOF'
{
  "action": "search",
  "query": "тяга",
  "supplier_name": "SEM1",
  "limit": 5
}
EOF
echo ""
echo "Response:"
curl -s -X POST "${API_URL}/search" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "тяга",
    "supplier_name": "SEM1",
    "limit": 5
  }' | python3 -m json.tool
echo ""

# Test 4: Search SEM1 with vendor code
echo ""
echo "4️⃣  Search SEM1 by Vendor Code..."
echo "============================================================"
echo "Request:"
cat << 'EOF'
{
  "action": "search",
  "query": "SEM14310",
  "supplier_name": "SEM1",
  "limit": 3
}
EOF
echo ""
echo "Response:"
curl -s -X POST "${API_URL}/search" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "SEM14310",
    "supplier_name": "SEM1",
    "limit": 3
  }' | python3 -m json.tool
echo ""

# Test 5: Search with multiple filters
echo ""
echo "5️⃣  Search SEM1 with Multiple Filters..."
echo "============================================================"
echo "Request:"
cat << 'EOF'
{
  "action": "search",
  "query": "рулевая",
  "supplier_name": "SEM1",
  "weight_min": 0.0,
  "weight_max": 5.0,
  "limit": 10
}
EOF
echo ""
echo "Response:"
curl -s -X POST "${API_URL}/search" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "рулевая",
    "supplier_name": "SEM1",
    "weight_min": 0.0,
    "weight_max": 5.0,
    "limit": 10
  }' | python3 -m json.tool
echo ""

echo ""
echo "============================================================"
echo "  TEST SUITE COMPLETE"
echo "============================================================"
echo ""
echo "✅ All SEM1 search tests executed!"
echo ""
echo "To start the API server, run:"
echo "  cd /Users/oleksandrmelnychenko/Projects/bi-platform"
echo "  uvicorn src.api.search_api:app --reload --port 8000"
echo ""
