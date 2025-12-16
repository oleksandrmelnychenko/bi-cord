# 🌐 Product Search API - URLs

## Start the API Server

```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform
./start_api.sh
```

---

## 📍 Browse the API

### 🎯 Interactive API Documentation (Recommended)
**Swagger UI** - Test all endpoints in your browser:
```
http://localhost:8000/docs
```

**Features:**
- ✅ Interactive interface
- ✅ Try out API calls directly
- ✅ See request/response schemas
- ✅ Test with SEM1 parameters
- ✅ No coding required!

---

### 📖 Alternative Documentation
**ReDoc** - Beautiful API documentation:
```
http://localhost:8000/redoc
```

---

### 🏠 API Info
**Root Endpoint** - See available endpoints and features:
```
http://localhost:8000/
```

---

### ❤️ Health Check
**Health Status** - Check if API is running:
```
http://localhost:8000/health
```

---

## 🧪 Testing in Browser

### 1. Open Swagger UI
```
http://localhost:8000/docs
```

### 2. Find the `/search` endpoint (POST)

### 3. Click "Try it out"

### 4. Enter your request:

**Example 1: SEM1 Search**
```json
{
  "action": "search",
  "query": "тяга",
  "supplier_name": "SEM1",
  "limit": 20
}
```

**Example 2: SEM1 Vendor Code Search**
```json
{
  "action": "search",
  "query": "SEM14310",
  "supplier_name": "SEM1"
}
```

**Example 3: SEM1 with Filters**
```json
{
  "action": "search",
  "query": "амортизатор",
  "supplier_name": "SEM1",
  "weight_min": 0,
  "weight_max": 5,
  "limit": 20
}
```

### 5. Click "Execute" to see results!

---

## 📱 Quick Reference

| What | URL | Description |
|------|-----|-------------|
| **Interactive Docs** | `http://localhost:8000/docs` | ⭐ Best for testing |
| **API Docs** | `http://localhost:8000/redoc` | Beautiful documentation |
| **API Info** | `http://localhost:8000/` | Endpoints overview |
| **Health** | `http://localhost:8000/health` | Check status |
| **Search** | `http://localhost:8000/search` | Main endpoint (POST) |

---

## 🎨 Screenshots

### Swagger UI Preview
When you open `http://localhost:8000/docs`, you'll see:
- List of all endpoints
- Green "Try it out" buttons
- Request body editor
- Response viewer
- Schema documentation

### How to Test SEM1 Search:
1. Scroll to **POST /search**
2. Click **"Try it out"**
3. Edit the request body with SEM1 parameters
4. Click **"Execute"**
5. See results below!

---

## 💡 Pro Tips

1. **Use Swagger UI** (`/docs`) for the easiest testing experience
2. All endpoints use **POST /search** with different `action` parameters
3. Default `action` is `"search"`, so it's optional for product searches
4. Use `supplier_name: "SEM1"` to filter only SEM1 products
5. The response includes execution time, search_id, and ranked results

---

## 🔧 Troubleshooting

**Port already in use?**
```bash
# Kill process on port 8000
kill -9 $(lsof -t -i:8000)
```

**API not starting?**
```bash
# Install dependencies
pip3 install --user uvicorn fastapi sentence-transformers psycopg2-binary
```

**Database connection error?**
```bash
# Check PostgreSQL is running
docker ps | grep postgres
```

---

## 📚 Full Documentation

- **API Guide**: `UNIFIED_SEARCH_API_GUIDE.md`
- **SEM1 Examples**: `SEM1_SEARCH_EXAMPLE.md`
- **Live Results**: `SEM1_SEARCH_RESULTS.md`

---

## 🚀 Start Now!

```bash
./start_api.sh
```

Then open in your browser:
```
http://localhost:8000/docs
```

Enjoy exploring the API! 🎉
