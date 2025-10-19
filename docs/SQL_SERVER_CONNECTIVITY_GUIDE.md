# SQL Server Connectivity Troubleshooting Guide

**Date**: 2025-10-18
**Status**: Phase 2 Deployment Blocked
**Issue**: Unable to connect to ConcordDb SQL Server at 10.67.24.18:1433

## Current Situation

### What's Working ✅
- **Phase 1**: Product table (54 columns, 115 products) fully operational
- **Existing Connector**: `sqlserver-product-connector` is RUNNING
- **Bronze Infrastructure**: All 30 new bronze tables created
- **dbt Models**: 30 staging models generated and ready
- **Data Quality**: 100% coverage on Product table (multilingual, search fields)
- **Embeddings**: 115 products vectorized (384-dim) with all 54 columns

### What's Blocked 🔴
- **Phase 2 Deployment**: Cannot deploy Debezium connector for 30 additional Product tables
- **Root Cause**: TCP/IP connection timeout to SQL Server at 10.67.24.18:1433

## Error Details

### Error Message
```json
{
  "error_code": 400,
  "message": "Connector configuration is invalid and contains the following 1 error(s):\nUnable to connect. Check this and other connection properties. Error: The TCP/IP connection to the host 10.67.24.18, port 1433 has failed. Error: \"connect timed out. Verify the connection properties."
}
```

### Attempted Configuration
```json
{
  "name": "sqlserver-product-ecosystem-connector",
  "config": {
    "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "database.hostname": "10.67.24.18",
    "database.port": "1433",
    "database.user": "cord_cdc",
    "database.password": "***",
    "database.names": "ConcordDb",
    "table.include.list": "dbo.Product,dbo.ProductAnalogue,dbo.ProductAvailability,...(31 tables)",
    "topic.prefix": "cord",
    "schema.history.internal.kafka.bootstrap.servers": "localhost:9092",
    "schema.history.internal.kafka.topic": "schema-changes.cord.product-ecosystem"
  }
}
```

## Diagnostic Steps

### 1. Check Network Connectivity
```bash
# Test basic connectivity
ping 10.67.24.18

# Test SQL Server port
nc -zv 10.67.24.18 1433

# Alternative telnet test
telnet 10.67.24.18 1433
```

**Expected**: Connection should succeed
**If Fails**: Network issue (VPN, firewall, routing)

### 2. Verify VPN Connection
```bash
# Check active network interfaces
ifconfig | grep -A 2 tun

# Check VPN status (if using specific VPN client)
# Example for common VPN clients:
networksetup -listallnetworkservices
```

**Required**: VPN must be active if SQL Server is on private network

### 3. Test from Kafka Connect Container
```bash
# Enter Kafka Connect container
docker compose -f infra/docker-compose.dev.yml exec kafka-connect bash

# Test connectivity from inside container
apt-get update && apt-get install -y iputils-ping netcat telnet

# Ping test
ping -c 3 10.67.24.18

# Port test
nc -zv 10.67.24.18 1433

# SQL Server specific test (if sqlcmd available)
/opt/mssql-tools/bin/sqlcmd -S 10.67.24.18,1433 -U cord_cdc -P '***' -Q "SELECT @@VERSION"
```

**Critical**: Kafka Connect container must have network route to SQL Server

### 4. Check Firewall Rules
```bash
# On macOS
sudo pfctl -s rules | grep 1433

# On Linux
sudo iptables -L -n | grep 1433

# On Windows (PowerShell as Admin)
Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*1433*"}
```

**Required Rules**:
- Allow outbound TCP to 10.67.24.18:1433
- Allow Docker containers to access host network (if SQL Server on host)

### 5. Verify SQL Server Configuration
```sql
-- On SQL Server, check if TCP/IP is enabled
EXEC xp_readerrorlog 0, 1, N'Server is listening on', N'any', NULL, NULL, N'DESC'

-- Check if remote connections allowed
SELECT name, value_in_use
FROM sys.configurations
WHERE name = 'remote access'

-- Check if SQL Server Browser running (for named instances)
-- Services → SQL Server Browser → Status = Running
```

**Required**:
- TCP/IP protocol enabled
- Remote access = 1 (enabled)
- SQL Server Browser running (if using named instance)

### 6. Test Credentials
```bash
# From local machine (if SQL tools installed)
sqlcmd -S 10.67.24.18,1433 -U cord_cdc -P '***' -Q "SELECT @@VERSION"

# Using Python (from project venv)
cd ~/Projects/bi-platform
source venv/bin/activate
python3 -c "
import pyodbc
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=10.67.24.18,1433;'
    'DATABASE=ConcordDb;'
    'UID=cord_cdc;'
    'PWD=***'
)
print('✅ Connection successful')
print(conn.execute('SELECT @@VERSION').fetchone()[0])
conn.close()
"
```

**Expected**: Successful authentication and query execution

## Common Solutions

### Solution 1: VPN Not Connected
**Symptom**: Timeout connecting to 10.67.24.18
**Fix**:
```bash
# Connect to corporate/office VPN
# Retry Debezium deployment after VPN connected
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @infra/kafka-connect/connectors/sqlserver-product-ecosystem.json
```

### Solution 2: Docker Network Isolation
**Symptom**: Host can connect, but Kafka Connect container cannot
**Fix Option 1** - Use Host Network:
```yaml
# infra/docker-compose.dev.yml
services:
  kafka-connect:
    network_mode: "host"  # Use host network instead of bridge
```

**Fix Option 2** - Add Host Alias:
```yaml
# infra/docker-compose.dev.yml
services:
  kafka-connect:
    extra_hosts:
      - "sqlserver:10.67.24.18"
```
Then change connector config to use `"database.hostname": "sqlserver"`

**Fix Option 3** - Use Host Gateway (macOS/Linux):
```yaml
# infra/docker-compose.dev.yml
services:
  kafka-connect:
    extra_hosts:
      - "host.docker.internal:host-gateway"
```
Then change connector to use `"database.hostname": "host.docker.internal"` if SQL Server on host

### Solution 3: Firewall Blocking
**Symptom**: Connection refused or timeout
**Fix (macOS)**:
```bash
# Temporarily disable firewall for testing
sudo pfctl -d

# Re-enable after testing
sudo pfctl -e
```

**Fix (Linux - iptables)**:
```bash
# Allow SQL Server port
sudo iptables -A OUTPUT -p tcp --dport 1433 -j ACCEPT
```

**Fix (Windows)**:
```powershell
# Add firewall rule (PowerShell as Admin)
New-NetFirewallRule -DisplayName "SQL Server" -Direction Outbound -Protocol TCP -RemotePort 1433 -Action Allow
```

### Solution 4: SQL Server Not Listening
**Symptom**: Connection refused immediately (not timeout)
**Fix**:
1. Open SQL Server Configuration Manager
2. SQL Server Network Configuration → Protocols for [Instance]
3. Enable TCP/IP protocol
4. Restart SQL Server service

### Solution 5: Wrong IP/Port
**Symptom**: Persistent timeout
**Verification**:
```bash
# Verify SQL Server IP from working connector
curl -s http://localhost:8083/connectors/sqlserver-product-connector/config | jq '.["database.hostname"]'

# Should show: "10.67.24.18"
```

**Fix**: Ensure both connectors use same hostname/port

### Solution 6: CDC Not Enabled on Additional Tables
**Symptom**: Connector deploys but no data flows
**Fix**:
```sql
-- On SQL Server (as sysadmin)
USE ConcordDb;
GO

-- Enable CDC on each new table
EXEC sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'ProductAnalogue',
    @role_name = NULL;

-- Repeat for all 30 tables...
-- Or use script to enable all at once:
DECLARE @table_name NVARCHAR(255)
DECLARE table_cursor CURSOR FOR
SELECT name FROM sys.tables
WHERE schema_id = SCHEMA_ID('dbo')
AND name LIKE 'Product%'
AND name NOT IN (SELECT DISTINCT ct.source_object_id FROM cdc.change_tables ct)

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @table_name

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sys.sp_cdc_enable_table
        @source_schema = N'dbo',
        @source_name = @table_name,
        @role_name = NULL

    PRINT 'CDC enabled on ' + @table_name
    FETCH NEXT FROM table_cursor INTO @table_name
END

CLOSE table_cursor
DEALLOCATE table_cursor
```

## Alternative Approaches

### Option 1: SSH Tunnel (If Direct Access Blocked)
```bash
# Create SSH tunnel to SQL Server
ssh -L 1433:10.67.24.18:1433 user@jump-server

# Update connector to use localhost:1433
# database.hostname: "localhost"
# database.port: "1433"
```

### Option 2: Bastion Host
```bash
# Set up bastion/jump server with SQL Server access
# Configure Kafka Connect to route through bastion
```

### Option 3: Cloud SQL Proxy (If SQL Server in Cloud)
```bash
# Azure SQL example
az sql server firewall-rule create \
  --resource-group myResourceGroup \
  --server myServerName \
  --name AllowKafkaConnect \
  --start-ip-address $(curl -s ifconfig.me) \
  --end-ip-address $(curl -s ifconfig.me)
```

### Option 4: Replicate Connector Configuration
```bash
# If existing Product connector works, replicate its exact network setup
curl -s http://localhost:8083/connectors/sqlserver-product-connector/config > /tmp/working-config.json

# Compare with new connector config
diff /tmp/working-config.json infra/kafka-connect/connectors/sqlserver-product-ecosystem.json

# Ensure network-related settings match exactly
```

## Verification Checklist

Before attempting deployment, verify:

- [ ] Can ping 10.67.24.18 from host
- [ ] Can connect to port 1433 (nc/telnet)
- [ ] VPN is active (if required)
- [ ] Can ping SQL Server from inside Kafka Connect container
- [ ] SQL Server TCP/IP protocol enabled
- [ ] SQL Server allows remote connections
- [ ] Firewall allows outbound TCP 1433
- [ ] Credentials valid (sqlcmd test)
- [ ] CDC enabled on all 31 tables
- [ ] Existing Product connector still RUNNING (baseline)

## Resume Deployment Steps

Once connectivity restored:

### Step 1: Verify Connectivity
```bash
# Quick connectivity test
docker compose -f infra/docker-compose.dev.yml exec kafka-connect bash -c "nc -zv 10.67.24.18 1433"
```

### Step 2: Deploy Debezium Connector
```bash
cd ~/Projects/bi-platform

# Deploy connector for 31 Product tables
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @infra/kafka-connect/connectors/sqlserver-product-ecosystem.json

# Verify deployment
curl -s http://localhost:8083/connectors/sqlserver-product-ecosystem-connector/status | jq '.'
```

**Expected Output**:
```json
{
  "name": "sqlserver-product-ecosystem-connector",
  "connector": {
    "state": "RUNNING",
    "worker_id": "kafka-connect:8083"
  },
  "tasks": [
    {
      "id": 0,
      "state": "RUNNING",
      "worker_id": "kafka-connect:8083"
    }
  ]
}
```

### Step 3: Verify Kafka Topics
```bash
# List all Product-related topics
docker compose -f infra/docker-compose.dev.yml exec -T kafka \
  kafka-topics --list --bootstrap-server localhost:9092 | grep "cord.ConcordDb.dbo.Product"

# Expected: 31 topics
# cord.ConcordDb.dbo.Product
# cord.ConcordDb.dbo.ProductAnalogue
# cord.ConcordDb.dbo.ProductAvailability
# ... (28 more)
```

### Step 4: Wait for Initial Snapshot
```bash
# Monitor connector logs
docker compose -f infra/docker-compose.dev.yml logs -f kafka-connect | grep "snapshot"

# Expected: "Snapshot completed" messages for each table
```

**Estimated Time**: 5-10 minutes for initial snapshot of all 31 tables

### Step 5: Verify Bronze Data Ingestion
```bash
# Check if data flowing to bronze tables
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics <<EOF
SELECT
    'product_category_cdc' as table_name,
    COUNT(*) as record_count
FROM bronze.product_category_cdc
UNION ALL
SELECT 'product_pricing_cdc', COUNT(*) FROM bronze.product_pricing_cdc
UNION ALL
SELECT 'product_availability_cdc', COUNT(*) FROM bronze.product_availability_cdc
ORDER BY table_name;
EOF
```

### Step 6: Run dbt Models
```bash
cd ~/Projects/bi-platform/dbt
source ../venv/bin/activate

# Run all Product ecosystem models
dbt run --select product_ecosystem

# Expected: 30 models OK
```

### Step 7: Run Data Quality Tests
```bash
# Test all models
dbt test --select product_ecosystem

# Expected: 60 tests PASS (30 models × 2 tests each)
```

### Step 8: Verify Deployment
```bash
cd ~/Projects/bi-platform
./scripts/verify_product_ecosystem.sh
```

**Expected Output**:
```
✅ Debezium connector is RUNNING
✅ Found 31 Product-related Kafka topics
✅ Found 30 bronze tables
✅ Found 30 dbt staging models
✅ Product CDC has >0 records
✅ Found 30+ staging views
✅ Staging layer has data
🎉 All checks passed! System is fully operational.
```

## Monitoring After Deployment

### Check CDC Lag
```bash
# Monitor Kafka Connect metrics
curl -s http://localhost:8083/connectors/sqlserver-product-ecosystem-connector/status | \
  jq '.tasks[0] | {state: .state, worker_id: .worker_id}'

# Expected lag: <1 minute
```

### Check Data Freshness
```sql
-- Check latest CDC timestamps
SELECT
    'product_category' as table_name,
    MAX(ingested_at) as latest_ingested,
    NOW() - MAX(ingested_at) as lag
FROM bronze.product_category_cdc
UNION ALL
SELECT 'product_pricing', MAX(ingested_at), NOW() - MAX(ingested_at)
FROM bronze.product_pricing_cdc;
```

**Expected**: Lag <5 minutes (depending on change frequency)

## Contact Information

**SQL Server Admin**: [Contact info for DBA/network team]
**Network Team**: [Contact for VPN/firewall issues]
**Debezium Support**: https://debezium.io/documentation/
**Project Documentation**: `~/Projects/bi-platform/docs/`

## Related Documentation

- **Deployment Guide**: `docs/PRODUCT_ECOSYSTEM_DEPLOYMENT.md`
- **Phase 2 Summary**: `docs/PHASE2_PRODUCT_ECOSYSTEM_COMPLETE.md`
- **Verification Script**: `scripts/verify_product_ecosystem.sh`
- **Architecture Overview**: `README_IMPLEMENTATION.md`

---

**Created**: 2025-10-18
**Last Updated**: 2025-10-18
**Status**: Awaiting SQL Server connectivity resolution
**Next Action**: Follow diagnostic steps above to identify connectivity blocker
