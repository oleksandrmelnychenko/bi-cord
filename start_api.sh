#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "================================================================================"
echo "  Starting Product Search API"
echo "================================================================================"
echo ""

# Change to project directory
cd /Users/oleksandrmelnychenko/Projects/bi-platform

# Set environment variables
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5433
export POSTGRES_DB=analytics
export POSTGRES_USER=analytics
export POSTGRES_PASSWORD=analytics

# Check if port 8000 is already in use
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
    echo -e "${YELLOW}⚠️  Port 8000 is already in use!${NC}"
    echo ""
    echo "Kill the existing process? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
        echo "Killing process on port 8000..."
        kill -9 $(lsof -t -i:8000)
        sleep 2
    else
        echo "Exiting..."
        exit 1
    fi
fi

# Activate virtual environment
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}📦 Creating virtual environment...${NC}"
    python3 -m venv venv
    source venv/bin/activate
    echo -e "${YELLOW}📦 Installing dependencies...${NC}"
    pip install -r src/api/requirements.txt
else
    echo -e "${GREEN}✅ Activating virtual environment...${NC}"
    source venv/bin/activate
fi

echo ""
echo "================================================================================"
echo -e "${GREEN}🚀 API Server Starting...${NC}"
echo "================================================================================"
echo ""
echo -e "${BLUE}📍 API URLs:${NC}"
echo ""
echo -e "  🌐 Interactive API Docs (Swagger UI):"
echo -e "     ${GREEN}http://localhost:8000/docs${NC}"
echo ""
echo -e "  📖 Alternative API Docs (ReDoc):"
echo -e "     ${GREEN}http://localhost:8000/redoc${NC}"
echo ""
echo -e "  🏠 API Root (Info):"
echo -e "     ${GREEN}http://localhost:8000/${NC}"
echo ""
echo -e "  ❤️  Health Check:"
echo -e "     ${GREEN}http://localhost:8000/health${NC}"
echo ""
echo "================================================================================"
echo ""
echo -e "${YELLOW}💡 Tip: Open http://localhost:8000/docs in your browser${NC}"
echo -e "${YELLOW}    You can test all API endpoints interactively!${NC}"
echo ""
echo "================================================================================"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start uvicorn
uvicorn src.api.search_api:app --host 0.0.0.0 --port 8000 --reload
