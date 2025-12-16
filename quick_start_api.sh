#!/bin/bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5433
export POSTGRES_DB=analytics
export POSTGRES_USER=analytics
export POSTGRES_PASSWORD=analytics

echo "Starting Search API on port 8000..."
python3 -m uvicorn src.api.search_api:app --host 0.0.0.0 --port 8000
