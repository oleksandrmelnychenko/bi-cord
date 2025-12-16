# Client & Sales Data Sync Plan

## 📊 Discovery Summary

Found **101 tables** related to Client and Sales in SQL Server `ConcordDb` (78.152.175.67)

### Tables with Data (Priority Sync):

| Table | Rows | Priority | Purpose |
|-------|------|----------|---------|
| **Client Tables** ||||
| `dbo.Client` | 20 | 🔴 HIGH | Main client/customer master data |
| `dbo.ClientBankDetails` | 10,803 | 🔴 HIGH | Client banking information |
| `dbo.ClientBankDetailAccountNumber` | 10,803 | 🟡 MEDIUM | Bank account numbers |
| `dbo.ClientBankDetailIbanNo` | 10,804 | 🟡 MEDIUM | IBAN numbers |
| `dbo.ClientAgreement` | 8 | 🟡 MEDIUM | Client agreements/contracts |
| `dbo.ClientInRole` | 20 | 🟡 MEDIUM | Client role assignments |
| `dbo.ClientSubClient` | 2 | 🟢 LOW | Sub-client relationships |
| `dbo.OrganizationClient` | 14 | 🟡 MEDIUM | Organization-level clients |
| `dbo.OrganizationClientAgreement` | 25 | 🟡 MEDIUM | Organization agreements |
| `dbo.RetailClient` | 253 | 🔴 HIGH | Retail/individual clients |
| **Sales Tables** ||||
| `dbo.Sale` | 0 | 🔴 HIGH | **EMPTY** - Main sales transactions |
| `dbo.SaleInvoiceDocument` | 209 | 🔴 HIGH | Sale invoices |
| `dbo.SaleInvoiceNumber` | 997 | 🟡 MEDIUM | Invoice numbering |
| `dbo.SaleBaseShiftStatus` | 450 | 🟡 MEDIUM | Sale status tracking |
| `dbo.SaleReturn` | 0 | 🟡 MEDIUM | **EMPTY** - Sale returns |
| `dbo.SaleReturnItem` | 0 | 🟡 MEDIUM | **EMPTY** - Return line items |
| **Order Tables** ||||
| `dbo.Order` | 0 | 🔴 HIGH | **EMPTY** - Customer orders |
| `dbo.OrderItem` | 0 | 🔴 HIGH | **EMPTY** - Order line items |
| `dbo.SupplyOrder` | 1 | 🟡 MEDIUM | Supply orders |
| `dbo.SupplyOrderItem` | 31 | 🟡 MEDIUM | Supply order items |
| `dbo.SupplyOrderDeliveryDocument` | 4 | 🟢 LOW | Delivery documents |
| `dbo.SupplyOrderNumber` | 3 | 🟢 LOW | Order numbering |
| `dbo.SupplyOrderPaymentDeliveryProtocolKey` | 489 | 🟡 MEDIUM | Payment protocols |
| `dbo.SupplyOrderUkrainePaymentDeliveryProtocolKey` | 37 | 🟢 LOW | Ukraine payment protocols |
| **Reference/Lookup Tables** ||||
| `dbo.ClientType` | 2 | 🟡 MEDIUM | Client type definitions |
| `dbo.ClientTypeRole` | 6 | 🟡 MEDIUM | Client type roles |
| `dbo.ClientTypeRoleTranslation` | 12 | 🟢 LOW | Translations |
| `dbo.ClientTypeTranslation` | 4 | 🟢 LOW | Translations |
| `dbo.PerfectClient` | 107 | 🟢 LOW | Perfect client definitions |
| `dbo.PerfectClientTranslation` | 208 | 🟢 LOW | Translations |
| `dbo.PerfectClientValue` | 102 | 🟢 LOW | Client values |
| `dbo.PerfectClientValueTranslation` | 192 | 🟢 LOW | Translations |

### Empty Tables (Monitor for Future):
- `dbo.Sale` (0 rows) ⚠️ **Critical but empty**
- `dbo.Order` (0 rows) ⚠️ **Critical but empty**
- `dbo.OrderItem` (0 rows) ⚠️ **Critical but empty**
- `dbo.SaleReturn`, `dbo.SaleReturnItem` (0 rows)
- 73+ other empty tables

---

## 🎯 Sync Strategy

### Phase 1: Core Client & Sales Data (Immediate)

Sync these **critical tables** first:

```
Core Client Data (5 tables):
├── dbo.Client (20 rows) - Master client table
├── dbo.RetailClient (253 rows) - Individual customers
├── dbo.OrganizationClient (14 rows) - Business customers
├── dbo.ClientBankDetails (10,803 rows) - Banking info
└── dbo.ClientAgreement (8 rows) - Contracts

Core Sales Data (2 tables with data):
├── dbo.SaleInvoiceDocument (209 rows) - Invoices issued
└── dbo.SaleInvoiceNumber (997 rows) - Invoice tracking

Core Reference Data (4 tables):
├── dbo.ClientType (2 rows)
├── dbo.ClientTypeRole (6 rows)
├── dbo.SaleBaseShiftStatus (450 rows)
└── dbo.PerfectClient (107 rows)
```

**Total Phase 1**: ~11 tables, ~12,879 rows

---

### Phase 2: Extended Client Relationships (Next)

```
Extended Client Data:
├── dbo.ClientBankDetailAccountNumber (10,803 rows)
├── dbo.ClientBankDetailIbanNo (10,804 rows)
├── dbo.ClientInRole (20 rows)
├── dbo.OrganizationClientAgreement (25 rows)
└── dbo.ClientSubClient (2 rows)
```

**Total Phase 2**: 5 tables, ~21,654 rows

---

### Phase 3: Supply Orders & Payment (After)

```
Supply Order Data:
├── dbo.SupplyOrder (1 row)
├── dbo.SupplyOrderItem (31 rows)
├── dbo.SupplyOrderPaymentDeliveryProtocolKey (489 rows)
├── dbo.SupplyOrderDeliveryDocument (4 rows)
└── dbo.SupplyOrderNumber (3 rows)
```

**Total Phase 3**: 5 tables, ~528 rows

---

### Phase 4: Translations & Lookups (Optional)

```
Translation Tables:
├── dbo.ClientTypeTranslation (4 rows)
├── dbo.ClientTypeRoleTranslation (12 rows)
├── dbo.PerfectClientTranslation (208 rows)
└── dbo.PerfectClientValueTranslation (192 rows)
```

**Total Phase 4**: 4 tables, ~416 rows

---

## 🔧 Implementation Options

### Option 1: Debezium Kafka Connector (Recommended for Production)

**Pros**:
- Real-time CDC (captures inserts/updates/deletes as they happen)
- Automatic schema evolution
- Scalable and production-ready
- Already configured for Product tables

**Cons**:
- Requires Kafka stack to be running
- More complex setup

**Config File**: Create `/infra/kafka-connect/connectors/sqlserver-client-sales.json`

```json
{
  "name": "sqlserver-client-sales-connector",
  "config": {
    "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "database.hostname": "78.152.175.67",
    "database.port": "1433",
    "database.user": "ef_migrator",
    "database.password": "Grimm_jow92",
    "database.dbname": "ConcordDb",
    "database.names": "ConcordDb",
    "database.encrypt": "false",
    "database.server.name": "cord",
    "schema.history.internal.kafka.bootstrap.servers": "kafka:29092",
    "schema.history.internal.kafka.topic": "schema-changes.cord.client-sales",
    "table.include.list": "dbo.Client,dbo.RetailClient,dbo.OrganizationClient,dbo.ClientBankDetails,dbo.ClientAgreement,dbo.SaleInvoiceDocument,dbo.SaleInvoiceNumber,dbo.ClientType,dbo.ClientTypeRole,dbo.SaleBaseShiftStatus,dbo.PerfectClient",
    "snapshot.mode": "initial",
    "topic.prefix": "cord",
    "include.schema.changes": "false",
    "decimal.handling.mode": "string",
    "time.precision.mode": "connect"
  }
}
```

---

### Option 2: Direct Python Loader (Quick Start)

**Pros**:
- Works immediately (no Kafka needed)
- Simple to understand and modify
- Good for initial data load

**Cons**:
- No real-time updates
- Manual refresh needed
- Not suitable for high-frequency changes

**Script**: Create `/src/transform/client_sales_loader.py` (similar to `sqlserver_direct_loader.py`)

---

## 📋 Step-by-Step Implementation (Direct Loader)

### Step 1: Create Direct Loader Script

```bash
# Create the loader script
cp src/transform/sqlserver_direct_loader.py src/transform/client_sales_loader.py

# Modify to load Client and Sales tables
```

### Step 2: Create Bronze Layer Tables

```sql
-- Bronze CDC tables for Client/Sales
CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE bronze.client_cdc (
    id BIGSERIAL PRIMARY KEY,
    kafka_topic VARCHAR(255),
    kafka_partition INT,
    kafka_offset BIGINT,
    cdc_payload JSONB NOT NULL,
    ingested_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE bronze.retail_client_cdc (...);
CREATE TABLE bronze.organization_client_cdc (...);
CREATE TABLE bronze.sale_invoice_document_cdc (...);
-- etc.
```

### Step 3: Create dbt Staging Models

```bash
# In /dbt/models/staging/client/
stg_client.sql
stg_retail_client.sql
stg_organization_client.sql
stg_client_bank_details.sql

# In /dbt/models/staging/sales/
stg_sale_invoice_document.sql
stg_sale_invoice_number.sql
stg_sale_base_shift_status.sql
```

### Step 4: Create dbt Mart Models

```bash
# In /dbt/models/marts/
dim_client.sql           # Denormalized client dimension
dim_sale.sql             # Denormalized sales dimension
fact_invoices.sql        # Invoice fact table
```

---

## 🚀 Quick Start Commands

### Using Direct Loader (Fastest):

```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform

# Create and run the loader (to be created)
python3 src/transform/client_sales_loader.py

# Build dbt models
source venv/bin/activate
dbt run --select staging.client
dbt run --select staging.sales
dbt run --select marts.client
dbt run --select marts.sales
```

### Using Kafka (Production):

```bash
# Start Kafka stack
cd infra
docker-compose -f docker-compose.dev.yml up -d zookeeper kafka schema-registry kafka-connect

# Wait for services to start (30-60 seconds)
sleep 60

# Register connector
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @kafka-connect/connectors/sqlserver-client-sales.json

# Verify connector is running
curl http://localhost:8083/connectors/sqlserver-client-sales-connector/status
```

---

## 📊 Expected Output

### Bronze Layer:
```
bronze.client_cdc                      20 rows
bronze.retail_client_cdc              253 rows
bronze.organization_client_cdc         14 rows
bronze.client_bank_details_cdc     10,803 rows
bronze.sale_invoice_document_cdc      209 rows
```

### Staging Layer:
```
staging_staging.stg_client                     20 rows
staging_staging.stg_retail_client             253 rows
staging_staging.stg_organization_client        14 rows
staging_staging.stg_sale_invoice_document     209 rows
```

### Mart Layer:
```
staging_marts.dim_client          ~287 rows (all client types merged)
staging_marts.fact_invoices       ~209 rows (invoices with client joins)
```

---

## ⚠️ Important Notes

### Empty Critical Tables:
The following tables are **defined but empty** in the source:
- `dbo.Sale` (0 rows) - May populate when sales start
- `dbo.Order` (0 rows) - May populate when orders start
- `dbo.OrderItem` (0 rows) - May populate with orders

**Action**: Set up connectors now, they will auto-sync when data appears.

### Data Quality:
- Only **20 clients** in main Client table (test/dev environment?)
- **10,803 bank details** vs 20 clients = possible data inconsistency
- Most order/sale tables are empty = likely non-production database

---

## 🎯 Recommended Approach

**For immediate needs**: Use **Direct Loader** (Option 2)
- Fast implementation
- Get data flowing today
- Build analytics now

**For production**: Migrate to **Kafka CDC** (Option 1)
- Real-time updates
- Production-ready
- Consistent with Product sync architecture

---

## 📁 Files to Create

1. `/src/transform/client_sales_loader.py` - Direct loader script
2. `/infra/kafka-connect/connectors/sqlserver-client-sales.json` - Kafka connector
3. `/dbt/models/staging/client/*.sql` - Client staging models (5 files)
4. `/dbt/models/staging/sales/*.sql` - Sales staging models (4 files)
5. `/dbt/models/marts/dim_client.sql` - Client dimension
6. `/dbt/models/marts/fact_invoices.sql` - Invoice fact table

---

**Next Steps**: Which approach do you want to use?
1. Direct Loader (quick, works now)
2. Kafka CDC (production-ready, requires Kafka startup)

Let me know and I'll implement it!
