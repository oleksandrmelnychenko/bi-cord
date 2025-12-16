# Data Pipeline Architecture - Complete Source to Destination Flow

## 📊 Overview

Your BI platform uses a **Change Data Capture (CDC)** pipeline to sync data from SQL Server source databases to PostgreSQL analytics database, with two different sync methods available.

---

## 🎯 Source Systems (SQL Server)

### Source Database 1: Product Master Data
**Type**: SQL Server
**Purpose**: Main product catalog (Product table only)

```
Host: 78.152.175.67
Port: 1433
Database: ConcordDb
Schema: dbo
User: ef_migrator
Password: Grimm_jow92
```

**Tables**:
- `dbo.Product` (278,698 rows synced)

---

### Source Database 2: Product Ecosystem Data
**Type**: SQL Server
**Purpose**: Related product data (availability, analogues, pricing, etc.)

```
Host: 10.67.24.18
Port: 1433
Database: ConcordDb
Schema: dbo
User: sa
Password: Fenix12345
```

**Tables** (31 tables):
- `dbo.Product`
- `dbo.ProductAnalogue`
- `dbo.ProductAvailability` ⚠️ Not synced yet
- `dbo.ProductAvailabilityCartLimits`
- `dbo.ProductCapitalization`
- `dbo.ProductCapitalizationItem`
- `dbo.ProductCarBrand`
- `dbo.ProductCategory`
- `dbo.ProductGroup`
- `dbo.ProductGroupDiscount`
- `dbo.ProductImage`
- `dbo.ProductIncome`
- `dbo.ProductIncomeItem`
- `dbo.ProductLocation`
- `dbo.ProductLocationHistory`
- `dbo.ProductOriginalNumber` ⚠️ Not synced yet
- `dbo.ProductPlacement`
- `dbo.ProductPlacementHistory`
- `dbo.ProductPlacementMovement`
- `dbo.ProductPlacementStorage`
- `dbo.ProductPricing`
- `dbo.ProductProductGroup`
- `dbo.ProductReservation`
- `dbo.ProductSet`
- `dbo.ProductSlug`
- `dbo.ProductSpecification`
- `dbo.ProductSubGroup`
- `dbo.ProductTransfer`
- `dbo.ProductTransferItem`
- `dbo.ProductWriteOffRule`
- `dbo.MeasureUnit`

---

## 🔄 Data Sync Methods

### Method 1: Kafka CDC Pipeline (Production Design)

**Architecture**: SQL Server → Debezium → Kafka → PostgreSQL Bronze

#### Components:
1. **Debezium Connector** (Kafka Connect)
   - Image: `debezium/connect:2.4`
   - Port: 8083
   - Status: ⚠️ Currently not running

2. **Kafka Broker**
   - Image: `confluentinc/cp-kafka:7.5.0`
   - Port: 9092
   - Status: ⚠️ Currently not running

3. **Zookeeper**
   - Image: `confluentinc/cp-zookeeper:7.5.0`
   - Port: 2181
   - Status: ⚠️ Currently not running

4. **Schema Registry**
   - Image: `confluentinc/cp-schema-registry:7.5.0`
   - Port: 8081
   - Status: ⚠️ Currently not running

#### Connector Configurations:

**Product Connector**:
```json
File: /infra/kafka-connect/connectors/sqlserver-product.json
Name: sqlserver-product-connector
Source: 78.152.175.67:1433/ConcordDb
Tables: dbo.Product
Topic Prefix: cord
```

**Product Ecosystem Connector**:
```json
File: /infra/kafka-connect/connectors/sqlserver-product-ecosystem.json
Name: sqlserver-product-ecosystem-connector
Source: 10.67.24.18:1433/ConcordDb
Tables: 31 product-related tables
Topic Prefix: cord
```

#### Data Flow (When Active):
```
SQL Server (Source)
    ↓ [Debezium CDC]
Kafka Topics (cord.dbo.Product, etc.)
    ↓ [Kafka Consumer]
PostgreSQL Bronze Layer (bronze.*_cdc tables)
    ↓ [dbt Staging]
PostgreSQL Staging Layer (staging_staging.stg_*)
    ↓ [dbt Marts]
PostgreSQL Mart Layer (staging_marts.dim_*)
```

---

### Method 2: Direct Loader (Currently Active) ✅

**Architecture**: SQL Server → Python Script → PostgreSQL Bronze

**Script**: `/src/transform/sqlserver_direct_loader.py`

#### What It Does:
1. Connects directly to SQL Server: `78.152.175.67:1433`
2. Fetches all products from `dbo.Product`
3. Wraps data in CDC-compatible JSON format
4. Bulk inserts into `bronze.product_cdc` table
5. Bypasses Kafka completely

#### Connection Details (Hardcoded):
```python
# SQL Server
SQLSERVER_CONFIG = {
    'host': '78.152.175.67',
    'port': 1433,
    'user': 'ef_migrator',
    'password': 'Grimm_jow92',
    'database': 'ConcordDb'
}

# PostgreSQL
POSTGRES_CONFIG = {
    'host': 'localhost',
    'port': 5433,
    'user': 'analytics',
    'password': 'analytics',
    'database': 'analytics'
}
```

#### Current Status:
✅ **Successfully loaded 278,698 products** into `bronze.product_cdc`

---

## 🗄️ Target System (PostgreSQL in Docker)

### Analytics Database
```
Container: infra-postgres-1
Image: pgvector/pgvector:pg15
Host: localhost
Port: 5433
Database: analytics
User: analytics
Password: analytics
Volume: infra_postgres-data
```

### Schema Structure:

#### Bronze Layer (Raw CDC Data)
**Schema**: `bronze`

Current tables:
- ✅ `product_cdc` (278,698 rows)
- ⚠️ `product_analogue_cdc` (0 rows - not loaded)
- ⚠️ `product_availability_cdc` (0 rows - not loaded)
- ⚠️ `product_original_number_cdc` (0 rows - not loaded)
- ... (28 more empty CDC tables)

#### Staging Layer (dbt Views)
**Schema**: `staging_staging`

All 31 views created:
- ✅ `stg_product` (278,698 rows)
- ⚠️ `stg_product_availability` (0 rows)
- ⚠️ `stg_product_analogue` (0 rows)
- ⚠️ `stg_product_original_number` (0 rows)
- ... (27 more views with 0 rows)

#### Mart Layer (dbt Tables)
**Schema**: `staging_marts`

Production-ready tables:
- ✅ `dim_product` (278,697 rows, 117 MB)
- ✅ `dim_product_search` (278,697 rows, 172 MB)

---

## 🔧 Data Transformation (dbt)

### dbt Project Location
```
/Users/oleksandrmelnychenko/Projects/bi-platform/dbt/
```

### Build Process:

**Step 1: Staging Layer**
```bash
dbt run --select staging
```
Creates 31 views that parse JSON from bronze CDC tables.

**Step 2: Mart Layer**
```bash
dbt run --select marts
```
Creates denormalized dimension tables with:
- Aggregated availability data
- Original number arrays
- Analogue product arrays
- ML ranking signals
- Multilingual content

### dbt Connection (profiles.yml)
```yaml
cord_bi:
  outputs:
    dev:
      type: postgres
      host: localhost
      port: 5433
      user: analytics
      password: analytics
      dbname: analytics
      schema: staging
```

---

## 📈 Data Flow Diagram

### Current Active Flow (Direct Loader):
```
┌─────────────────────────────────────────────────┐
│  SQL Server Source                              │
│  78.152.175.67:1433/ConcordDb                  │
│  dbo.Product (278,698 rows)                    │
└───────────────────┬─────────────────────────────┘
                    │
                    │ Python Direct Loader
                    │ (sqlserver_direct_loader.py)
                    │
                    ↓
┌─────────────────────────────────────────────────┐
│  PostgreSQL Bronze Layer                        │
│  bronze.product_cdc                             │
│  (278,698 rows in JSONB format)                │
└───────────────────┬─────────────────────────────┘
                    │
                    │ dbt Staging Models
                    │ (Parse JSONB, apply filters)
                    │
                    ↓
┌─────────────────────────────────────────────────┐
│  PostgreSQL Staging Layer                       │
│  staging_staging.stg_product                    │
│  (278,698 rows as SQL view)                    │
└───────────────────┬─────────────────────────────┘
                    │
                    │ dbt Mart Models
                    │ (Denormalize, aggregate)
                    │
                    ↓
┌─────────────────────────────────────────────────┐
│  PostgreSQL Mart Layer                          │
│  staging_marts.dim_product (278,697 rows)      │
│  staging_marts.dim_product_search (278,697)    │
└───────────────────┬─────────────────────────────┘
                    │
                    │ FastAPI Search
                    │ (search_api.py)
                    │
                    ↓
┌─────────────────────────────────────────────────┐
│  Search API Endpoint                            │
│  http://localhost:8000/search                   │
│  (10-98ms query performance)                    │
└─────────────────────────────────────────────────┘
```

---

## 🚦 Current Status Summary

### ✅ What's Working
- Direct loader syncing from SQL Server to PostgreSQL
- 278,698 products loaded in bronze layer
- All 31 dbt staging views created
- Both mart tables materialized (278,697 rows each)
- Search API integrated and running (10-98ms)
- 6,728 SEM1 products indexed and searchable

### ⚠️ What's Not Running
- Kafka/Zookeeper cluster (down)
- Debezium connectors (not active)
- Related table sync (availability, analogues, etc.)

### 📋 To Load Missing Data

#### Option 1: Start Kafka Pipeline
```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform/infra
docker-compose -f docker-compose.dev.yml up -d

# Register connectors
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @kafka-connect/connectors/sqlserver-product-ecosystem.json
```

#### Option 2: Extend Direct Loader
Create additional Python scripts for other tables:
- `product_availability_loader.py`
- `product_analogue_loader.py`
- `product_original_number_loader.py`

---

## 🔐 Security Notes

⚠️ **Warning**: Connection credentials are currently:
- Hardcoded in source files
- Stored in plaintext JSON configs
- Committed to git (check .gitignore)

**Recommendation**: Move to environment variables or secrets management.

---

## 📚 Related Files

### Configuration
- `/infra/docker-compose.dev.yml` - Docker services
- `/infra/kafka-connect/connectors/*.json` - Debezium configs
- `~/.dbt/profiles.yml` - dbt connection

### Scripts
- `/src/transform/sqlserver_direct_loader.py` - Direct sync
- `/dbt/models/staging/**/*.sql` - Staging transformations
- `/dbt/models/marts/**/*.sql` - Mart transformations

### Documentation
- `BUILD_DATABASE_TABLES.md` - How to build tables
- `DATABASE_BUILD_COMPLETE.md` - Build completion report
- `POSTGRES_DOCKER_INFO.md` - Docker database info
- `QUICK_REFERENCE.md` - Quick commands

---

## 🎯 Next Steps

1. **Decide on Sync Method**:
   - Keep direct loader (simpler, currently working)
   - Start Kafka pipeline (production-ready, real-time CDC)

2. **Load Related Tables**:
   - Availability data (for inventory counts)
   - Analogue relationships (for product alternatives)
   - Original numbers (for cross-references)

3. **Schedule Refreshes**:
   - Set up cron/Prefect for periodic syncs
   - Configure incremental updates
   - Monitor data freshness

---

**Last Updated**: 2025-10-21
