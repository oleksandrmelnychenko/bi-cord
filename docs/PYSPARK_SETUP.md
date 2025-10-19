# PySpark Setup - Installation Complete ✅

## Summary

PySpark and all required dependencies have been successfully installed in a **Python 3.11 virtual environment** (`venv-py311`). All packages import correctly, but **runtime execution requires additional Java/Hadoop configuration**.

## Installation Status

### ✅ What's Installed

**Python Environment**: Python 3.11.10
**Virtual Environment**: `/Users/oleksandrmelnychenko/Projects/bi-platform/venv-py311`

**Core Packages**:
- ✅ PySpark 3.5.1
- ✅ PyArrow 15.0.2
- ✅ Prefect 3.4.24 (upgraded from 2.14.10)
- ✅ boto3 1.34.143
- ✅ kafka-python 2.0.2
- ✅ psycopg2-binary 2.9.9
- ✅ sentence-transformers 2.7.0

**Supporting Libraries**:
- torch 2.9.0
- transformers 4.57.1
- numpy 1.26.4
- scipy 1.16.2
- scikit-learn 1.7.2
- All dependencies successfully resolved

### ✅ Import Verification

All packages import successfully:

```python
import pyspark          # ✅ PySpark version: 3.5.1
import prefect          # ✅ Prefect version: 3.4.24
import kafka            # ✅ kafka-python
import boto3            # ✅ AWS SDK
import psycopg2         # ✅ PostgreSQL driver
import sentence_transformers  # ✅ sentence-transformers version: 2.7.0
import pyarrow          # ✅ PyArrow version: 15.0.2
```

## Why Python 3.11?

**Python 3.13 compatibility issues**:
- PyArrow build failures (CMake errors, missing distutils)
- PySpark not yet certified for Python 3.13
- psycopg2-binary compilation errors

**Python 3.11 solution**:
- All packages have pre-built wheels
- Stable, mature ecosystem
- Full PySpark support

## Runtime Limitations

### ⚠️ Java Compatibility Issue

PySpark requires:
- **Java 8, 11, or 17** (tested and supported)
- Current system likely has **Java 21+**
- Error: `java.lang.UnsupportedOperationException: getSubject is not supported`

This is a known issue with PySpark 3.5.x and Java 21+.

### Solutions

**Option 1: Install Java 11** (recommended for PySpark)
```bash
brew install openjdk@11
export JAVA_HOME=$(/usr/libexec/java_home -v11)
export PATH="$JAVA_HOME/bin:$PATH"
```

**Option 2: Use PostgreSQL Approach** (already working)
- No Java dependency
- Simpler infrastructure
- Already processing 115 CDC records successfully
- Documented in `docs/BRONZE_LAYER_COMPLETE.md`

## Usage Instructions

### Activate Python 3.11 Environment

```bash
cd ~/Projects/bi-platform
source venv-py311/bin/activate
python --version  # Should show: Python 3.11.10
```

### Run PySpark Job (requires Java 11 setup)

```bash
cd ~/Projects/bi-platform
source venv-py311/bin/activate
export PYTHONPATH=src
export JAVA_HOME=$(/usr/libexec/java_home -v11)  # If Java 11 installed
python src/transform/spark_jobs/product_bronze_parquet.py
```

### Run Prefect Flow

```bash
cd ~/Projects/bi-platform
source venv-py311/bin/activate
export PYTHONPATH=src
export KAFKA_TOPIC="cord.ConcordDb.dbo.Product"
python src/ingestion/prefect_flows/kafka_to_minio.py
```

### Run Embeddings Pipeline

```bash
cd ~/Projects/bi-platform
source venv-py311/bin/activate
python src/ml/embedding_pipeline.py --limit 100
```

## File Structure

```
/Users/oleksandrmelnychenko/Projects/bi-platform/
├── venv/                          # Python 3.13 environment (PostgreSQL approach)
├── venv-py311/                    # Python 3.11 environment (PySpark)
├── src/
│   ├── ingestion/
│   │   ├── prefect_flows/
│   │   │   └── kafka_to_minio.py  # ✅ Works in both envs
│   │   └── utils/
│   │       └── minio_client.py
│   └── transform/
│       ├── direct_loader.py       # ✅ PostgreSQL loader (Python 3.13 venv)
│       └── spark_jobs/
│           ├── product_bronze_loader.py    # Requires Iceberg/Hive
│           └── product_bronze_parquet.py   # Simplified (requires Java 11)
└── requirements.txt
```

## Dependency Comparison

### Python 3.13 Environment (`venv`)
- ✅ Prefect 3.4.24
- ✅ boto3 1.40.55
- ✅ kafka-python 2.2.15
- ✅ psycopg2-binary 2.9.11
- ✅ dbt-postgres 1.9.1
- ❌ PySpark (incompatible)
- ❌ PyArrow (build fails)

### Python 3.11 Environment (`venv-py311`)
- ✅ Prefect 3.4.24
- ✅ boto3 1.34.143
- ✅ kafka-python 2.0.2
- ✅ psycopg2-binary 2.9.9
- ✅ PySpark 3.5.1
- ✅ PyArrow 15.0.2
- ✅ sentence-transformers 2.7.0
- ❌ dbt-postgres (not installed, not needed for PySpark)

## Recommendations

### For Current Data Pipeline (60K products)

**Use PostgreSQL approach** (`venv` with Python 3.13):
- ✅ Already working with 115 CDC records
- ✅ No Java dependency
- ✅ Simpler infrastructure
- ✅ Faster development iteration
- ✅ dbt integration complete
- ✅ Easier to debug and monitor

### For Future Scale (10M+ records)

**Switch to PySpark** (`venv-py311`):
1. Install Java 11: `brew install openjdk@11`
2. Set up Iceberg catalog (Hive metastore or AWS Glue)
3. Use `product_bronze_loader.py` for Iceberg tables
4. Or use `product_bronze_parquet.py` for simple parquet output

### For Embeddings Pipeline

**Use Python 3.11 environment** (`venv-py311`):
- ✅ sentence-transformers installed
- ✅ PyTorch 2.9.0 with Apple Silicon support
- ✅ Can process staging data from PostgreSQL
- ✅ All ML libraries available

## Next Steps

### Option 1: Continue with PostgreSQL (Recommended)

Bronze and staging layers are **already complete** using PostgreSQL:

```bash
# Use Python 3.13 environment
cd ~/Projects/bi-platform
source venv/bin/activate

# Bronze layer (already has 115 records)
python src/transform/direct_loader.py

# Staging layer (dbt)
cd dbt
dbt run --select stg_product  # 115 products transformed
dbt test --select stg_product  # All tests passing
```

See `docs/BRONZE_LAYER_COMPLETE.md` and `docs/STAGING_LAYER_COMPLETE.md`.

### Option 2: Set Up PySpark

If you specifically need PySpark:

1. **Install Java 11**:
   ```bash
   brew install openjdk@11
   echo 'export JAVA_HOME=$(/usr/libexec/java_home -v11)' >> ~/.zshrc
   source ~/.zshrc
   ```

2. **Test PySpark**:
   ```bash
   cd ~/Projects/bi-platform
   source venv-py311/bin/activate
   export PYTHONPATH=src
   python src/transform/spark_jobs/product_bronze_parquet.py
   ```

3. **Set Up Iceberg** (optional, for production scale):
   - Deploy Hive metastore container
   - Configure Iceberg catalog
   - Use `product_bronze_loader.py`

### Option 3: Run Embeddings Pipeline

```bash
cd ~/Projects/bi-platform
source venv-py311/bin/activate

# Generate embeddings from staging data
python src/ml/embedding_pipeline.py --source postgresql --limit 100
```

## Troubleshooting

### Issue: Java Version Conflict
**Error**: `java.lang.UnsupportedOperationException: getSubject is not supported`

**Solution**: Install and use Java 11:
```bash
brew install openjdk@11
export JAVA_HOME=$(/usr/libexec/java_home -v11)
```

### Issue: ModuleNotFoundError for pyspark
**Error**: `ModuleNotFoundError: No module named 'pyspark'`

**Solution**: Ensure you're using the Python 3.11 venv:
```bash
source venv-py311/bin/activate  # Not venv
python --version  # Should show 3.11.10
```

### Issue: Import Error for griffe.dataclasses
**Error**: `ModuleNotFoundError: No module named 'griffe.dataclasses'`

**Solution**: Already fixed by upgrading Prefect to 3.4.24

### Issue: PyArrow not found
**Error**: `ModuleNotFoundError: No module named 'pyarrow'`

**Solution**: PyArrow 15.0.2 is installed in `venv-py311`:
```bash
./venv-py311/bin/python -c "import pyarrow; print(pyarrow.__version__)"
```

## Summary

✅ **Installation Complete**: All PySpark dependencies successfully installed in Python 3.11 environment

⚠️ **Runtime Blocked**: Requires Java 11 (current system has newer Java version)

✅ **Alternative Working**: PostgreSQL-based pipeline is fully operational and handles current data volume efficiently

**Decision Point**:
- Continue with PostgreSQL approach (simpler, working today)
- Install Java 11 for PySpark (more complex, future-proofs for massive scale)

**Recommendation**: Use PostgreSQL approach until data volume exceeds 5-10M records, then revisit PySpark with proper Java setup.
