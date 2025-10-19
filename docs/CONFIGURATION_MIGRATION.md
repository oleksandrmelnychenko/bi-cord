# Configuration System Migration Guide

This guide explains how to migrate from hard-coded configuration to the centralized configuration system.

## Overview

The new configuration system provides:
- **Type-safe configuration** using Pydantic
- **Environment variable support** via `.env` files
- **Production validation** (enforces strong passwords in production)
- **Centralized settings** - single source of truth
- **Easy testing** - override config for tests

## Quick Start

### 1. Copy `.env.example` to `.env`

```bash
cp .env.example .env
```

### 2. Update `.env` with your actual credentials

```bash
# Edit .env file
nano .env

# At minimum, update these for production:
POSTGRES_PASSWORD=your_strong_password
MINIO_SECRET_KEY=your_secret_key
SQLSERVER_PASSWORD=your_sqlserver_password
```

### 3. Import and use settings

```python
from src.config import get_settings

settings = get_settings()
print(settings.postgres.host)  # localhost
print(settings.postgres.port)  # 5433
```

## Migration Patterns

### Pattern 1: Database Connections

#### Before (Hard-coded)
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5433,
    database="analytics",
    user="analytics",
    password="analytics",  # ❌ Hard-coded!
)
```

#### After (Config-based)
```python
from src.config.database import get_postgres_connection
from psycopg2.extras import DictCursor

# Option A: Context manager (recommended)
with get_postgres_connection(cursor_factory=DictCursor) as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM table")
    for row in cursor.fetchall():
        print(row['column'])

# Option B: Get connection params
from src.config import get_settings

settings = get_settings()
conn = psycopg2.connect(
    host=settings.postgres.host,
    port=settings.postgres.port,
    database=settings.postgres.database,
    user=settings.postgres.user,
    password=settings.postgres.password,
)
```

### Pattern 2: ML Model Configuration

#### Before (Hard-coded)
```python
from sentence_transformers import SentenceTransformer

# ❌ Hard-coded model name
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
device = "cpu"  # ❌ Hard-coded device
batch_size = 32  # ❌ Hard-coded batch size
```

#### After (Config-based)
```python
from sentence_transformers import SentenceTransformer
from src.config import get_settings

settings = get_settings()

# ✅ Configuration-driven
model = SentenceTransformer(settings.ml.embedding_model)
device = settings.ml.device  # Can be cpu, cuda, mps, or auto
batch_size = settings.ml.batch_size  # Configurable via env var
```

### Pattern 3: API Settings

#### Before (Hard-coded in FastAPI)
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# ❌ Hard-coded CORS origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
)
```

#### After (Config-based)
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.config import get_settings

settings = get_settings()
app = FastAPI(
    title=settings.project_name,
    version=settings.version,
    debug=settings.debug,
)

# ✅ Configuration-driven CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.api.cors_origins,
    allow_credentials=True,
)
```

### Pattern 4: Kafka Configuration

#### Before (Environment variables everywhere)
```python
import os
from kafka import KafkaConsumer

# ❌ Scattered environment variable access
consumer = KafkaConsumer(
    os.getenv('KAFKA_TOPIC', 'default-topic'),
    bootstrap_servers=os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'localhost:9092'),
    group_id=os.getenv('KAFKA_CONSUMER_GROUP', 'default-group'),
)
```

#### After (Config-based)
```python
from kafka import KafkaConsumer
from src.config import get_settings

settings = get_settings()

# ✅ Centralized configuration
consumer = KafkaConsumer(
    settings.kafka.topic_product,
    bootstrap_servers=settings.kafka.bootstrap_servers,
    group_id=f"{settings.kafka.consumer_group_prefix}-product",
    auto_offset_reset=settings.kafka.auto_offset_reset,
)
```

### Pattern 5: MinIO/S3 Configuration

#### Before (Hard-coded)
```python
from minio import Minio

# ❌ Hard-coded credentials
client = Minio(
    "localhost:9000",
    access_key="minioadmin",
    secret_key="minioadmin",
    secure=False,
)
```

#### After (Config-based)
```python
from minio import Minio
from src.config import get_settings

settings = get_settings()

# ✅ Configuration-driven
client = Minio(
    settings.minio.endpoint,
    access_key=settings.minio.access_key,
    secret_key=settings.minio.secret_key,
    secure=settings.minio.secure,
)
```

## Module-by-Module Migration Checklist

### ✅ Completed

- [x] `src/config/settings.py` - Configuration module created
- [x] `src/config/database.py` - Database utilities created
- [x] `src/api/hybrid_search.py` - Updated to use config
- [x] `.env.example` - Template created
- [x] `.gitignore` - Updated to exclude `.env`

### 🔄 Pending

- [ ] `src/api/search_api.py` - Update FastAPI app
- [ ] `src/ml/embedding_pipeline.py` - Update model loading
- [ ] `src/transform/sqlserver_direct_loader.py` - Update SQL Server connection
- [ ] `src/ingestion/prefect_flows/kafka_to_minio.py` - Update Kafka/MinIO config
- [ ] All Prefect flows - Update to use centralized config

## Testing the Migration

### 1. Validate Configuration

```bash
# Test configuration loads correctly
python -c "
from src.config import get_settings, validate_settings

validate_settings()
print('✅ Configuration validated successfully')
"
```

### 2. Test Database Connection

```bash
# Test PostgreSQL connection
python -c "
from src.config.database import test_postgres_connection

if test_postgres_connection():
    print('✅ PostgreSQL connection successful')
else:
    print('❌ PostgreSQL connection failed')
"
```

### 3. Run Existing Code

```bash
# Ensure backward compatibility
python -c "
from src.api.hybrid_search import get_db_connection

conn = get_db_connection()
print('✅ hybrid_search.py still works')
conn.close()
"
```

## Environment-Specific Configuration

### Development (.env)
```bash
ENVIRONMENT=development
DEBUG=true
POSTGRES_PASSWORD=analytics  # OK for development
ML_DEVICE=cpu
API_RELOAD=true
```

### Production (.env)
```bash
ENVIRONMENT=production
DEBUG=false
POSTGRES_PASSWORD=your_strong_production_password  # REQUIRED
ML_DEVICE=cuda  # Use GPU if available
API_RELOAD=false
API_WORKERS=4  # Scale to CPU cores

# Enable monitoring
SENTRY_DSN=https://your-sentry-dsn
PROMETHEUS_ENABLED=true
```

## Configuration Validation

The system automatically validates configuration on startup:

```python
from src.config import validate_settings

# This will raise ValueError if:
# - Production environment has default passwords
# - Required settings are missing
# - Invalid enum values are provided

validate_settings()
```

## Best Practices

### ✅ DO

- Import settings once at module level
- Use `get_settings()` which is cached
- Set environment-specific values in `.env`
- Use type hints with settings
- Validate production configs before deployment

### ❌ DON'T

- Hard-code credentials in source code
- Commit `.env` files to git
- Create Settings() directly (use `get_settings()`)
- Access `os.getenv()` directly (use settings)
- Share production `.env` files via insecure channels

## Troubleshooting

### Issue: "Configuration validation failed"

**Solution**: Check that you have strong passwords in production:

```bash
# .env
ENVIRONMENT=production
POSTGRES_PASSWORD=my_strong_password_123!  # Not "analytics"
```

### Issue: "Module 'src.config' not found"

**Solution**: Ensure `PYTHONPATH` includes `src`:

```bash
export PYTHONPATH="${PYTHONPATH}:$(pwd)/src"
# Or
PYTHONPATH=src python your_script.py
```

### Issue: Settings not updating

**Solution**: Clear the LRU cache:

```python
from src.config import get_settings

# Clear cache to reload settings
get_settings.cache_clear()
settings = get_settings()
```

## Next Steps

1. **Complete remaining migrations** - Update all modules listed in pending checklist
2. **Set up production `.env`** - Create production-specific configuration
3. **Enable observability** - Configure Sentry and Prometheus
4. **Document custom settings** - Add any application-specific config
5. **CI/CD integration** - Add config validation to deployment pipeline

## Support

For questions or issues:
1. Check this migration guide
2. Review `.env.example` for all available options
3. Examine `src/config/settings.py` for configuration structure
4. Test with `validate_settings()` for detailed error messages
