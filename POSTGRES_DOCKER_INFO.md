# Postgres Database in Docker - Location & Access Guide

## 🐘 Container Information

### Container Details
- **Container Name**: `infra-postgres-1`
- **Image**: `pgvector/pgvector:pg15`
- **Status**: Running (created 44 hours ago)
- **Docker Compose File**: `/Users/oleksandrmelnychenko/Projects/bi-platform/infra/docker-compose.dev.yml`

### Port Mapping
- **Host Port**: `5433`
- **Container Port**: `5432`
- **Access**: `localhost:5433`

---

## 📍 Data Storage Locations

### 1. Database Data (Persistent)
**Docker Volume**: `infra_postgres-data`

```bash
# Volume location on host
/var/lib/docker/volumes/infra_postgres-data/_data

# Inside container
/var/lib/postgresql/data
```

This is where all your database data is stored:
- Tables (stg_product, dim_product, etc.)
- Indexes
- System catalogs
- Transaction logs

### 2. Initialization Scripts
**Bind Mount**: `./postgres/sql` → `/docker-entrypoint-initdb.d`

```bash
# Host location
/Users/oleksandrmelnychenko/Projects/bi-platform/infra/postgres/sql/

# Container location
/docker-entrypoint-initdb.d
```

**Note**: Currently empty (only .gitkeep file). SQL scripts here run only on first container startup.

---

## 🔌 Connection Details

### From Host Machine
```bash
Host: localhost
Port: 5433
Database: analytics
User: analytics
Password: analytics
```

### From Other Docker Containers
```bash
Host: postgres
Port: 5432
Database: analytics
User: analytics
Password: analytics
Network: bi-net
```

### Connection Strings

**psql (from host)**:
```bash
psql -h localhost -p 5433 -U analytics -d analytics
# or with password
PGPASSWORD=analytics psql -h localhost -p 5433 -U analytics -d analytics
```

**Python psycopg2**:
```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5433,
    database="analytics",
    user="analytics",
    password="analytics"
)
```

**dbt profiles.yml**:
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
      threads: 4
```

---

## 🛠️ Docker Commands

### View Container Status
```bash
docker ps | grep postgres
```

### View Container Logs
```bash
docker logs infra-postgres-1
# Follow logs
docker logs -f infra-postgres-1
```

### Execute Commands Inside Container
```bash
# Access psql inside container
docker exec -it infra-postgres-1 psql -U analytics -d analytics

# Execute a SQL command
docker exec -it infra-postgres-1 psql -U analytics -d analytics -c "SELECT COUNT(*) FROM staging_marts.dim_product;"
```

### Inspect Container Details
```bash
# Full inspection
docker inspect infra-postgres-1

# Just the mounts
docker inspect infra-postgres-1 --format='{{json .Mounts}}' | python3 -m json.tool

# Container IP address
docker inspect infra-postgres-1 --format='{{.NetworkSettings.Networks.infra_bi-net.IPAddress}}'
```

### Start/Stop/Restart
```bash
# Stop Postgres
docker stop infra-postgres-1

# Start Postgres
docker start infra-postgres-1

# Restart Postgres
docker restart infra-postgres-1

# Or using docker-compose
cd /Users/oleksandrmelnychenko/Projects/bi-platform/infra
docker-compose -f docker-compose.dev.yml stop postgres
docker-compose -f docker-compose.dev.yml start postgres
docker-compose -f docker-compose.dev.yml restart postgres
```

---

## 💾 Volume Management

### Inspect Volume
```bash
# List all volumes
docker volume ls | grep postgres

# Inspect the volume
docker volume inspect infra_postgres-data
```

### Backup Database
```bash
# Create a backup using pg_dump
docker exec infra-postgres-1 pg_dump -U analytics -d analytics -F c -f /tmp/backup.dump

# Copy backup from container to host
docker cp infra-postgres-1:/tmp/backup.dump ./postgres_backup_$(date +%Y%m%d).dump
```

### Restore Database
```bash
# Copy backup to container
docker cp ./postgres_backup.dump infra-postgres-1:/tmp/restore.dump

# Restore using pg_restore
docker exec infra-postgres-1 pg_restore -U analytics -d analytics -c /tmp/restore.dump
```

### Access Volume Data Directly (macOS/Docker Desktop)
```bash
# Docker Desktop stores volumes in a VM, not directly accessible
# Use docker exec instead:
docker exec -it infra-postgres-1 ls -la /var/lib/postgresql/data
```

---

## 🗂️ Database Structure

### Current Schemas
```sql
-- List schemas
\dn

-- Common schemas in your database:
- bronze         (CDC source data)
- staging_staging (dbt staging views)
- staging_marts   (dbt mart tables)
- public         (default schema)
```

### Current Tables Summary
```
staging_staging.stg_product              278,698 rows
staging_marts.dim_product                278,697 rows (117 MB)
staging_marts.dim_product_search         278,697 rows (172 MB)
bronze.product_cdc                       278,698 rows
```

---

## 🚀 Docker Compose Management

### Full Stack Commands

**Start all services**:
```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform/infra
docker-compose -f docker-compose.dev.yml up -d
```

**Start only Postgres**:
```bash
docker-compose -f docker-compose.dev.yml up -d postgres
```

**Stop all services**:
```bash
docker-compose -f docker-compose.dev.yml down
```

**Stop and remove volumes** (⚠️ DELETES ALL DATA):
```bash
docker-compose -f docker-compose.dev.yml down -v
```

**View service logs**:
```bash
docker-compose -f docker-compose.dev.yml logs -f postgres
```

---

## 🔍 Troubleshooting

### Can't Connect to Database

1. **Check container is running**:
   ```bash
   docker ps | grep postgres
   ```

2. **Check port is accessible**:
   ```bash
   lsof -i :5433
   ```

3. **Check container logs**:
   ```bash
   docker logs infra-postgres-1 | tail -20
   ```

### Database is Empty After Restart

**Problem**: Docker volume not persisted
**Solution**: Check volume is defined in docker-compose.yml (it is: `postgres-data`)

### Need to Reset Database Completely

```bash
# WARNING: This deletes all data!
cd /Users/oleksandrmelnychenko/Projects/bi-platform/infra
docker-compose -f docker-compose.dev.yml down
docker volume rm infra_postgres-data
docker-compose -f docker-compose.dev.yml up -d postgres

# Then rebuild your database
cd /Users/oleksandrmelnychenko/Projects/bi-platform
source venv/bin/activate
dbt run --select staging
dbt run --select marts
```

### Performance Issues

**Check container resources**:
```bash
docker stats infra-postgres-1
```

**Access Postgres logs**:
```bash
docker exec -it infra-postgres-1 tail -f /var/lib/postgresql/data/log/postgresql-*.log
```

---

## 📋 Quick Reference

| Item | Value |
|------|-------|
| Container Name | `infra-postgres-1` |
| Host Port | `5433` |
| Container Port | `5432` |
| Database | `analytics` |
| User | `analytics` |
| Password | `analytics` |
| Data Volume | `infra_postgres-data` |
| Network | `bi-net` |
| Image | `pgvector/pgvector:pg15` |

---

## 🔗 Related Files

- **Docker Compose**: `/Users/oleksandrmelnychenko/Projects/bi-platform/infra/docker-compose.dev.yml`
- **Init Scripts**: `/Users/oleksandrmelnychenko/Projects/bi-platform/infra/postgres/sql/`
- **dbt Project**: `/Users/oleksandrmelnychenko/Projects/bi-platform/dbt/`
- **Search API**: `/Users/oleksandrmelnychenko/Projects/bi-platform/src/api/search_api.py`

---

**Last Updated**: 2025-10-21
