# Offline Install Verification Checklist

Before running Spark jobs or Prefect flows, confirm the following modules are available:

- [ ] `python3 -c "import prefect"`
- [ ] `python3 -c "import pyspark"`
- [ ] `python3 -c "import kafka"`
- [ ] `python3 -c "import boto3"`
- [ ] `python3 -c "import psycopg2"`
- [ ] `python3 -c "import sentence_transformers"`
- [ ] `python3 -c "import pyarrow"`

Optional (for future steps):
- [ ] `python3 -c "import great_expectations"`
- [ ] `python3 -c "import prefect_dbt"`

Record verification results in `docs/run_log.md`.
