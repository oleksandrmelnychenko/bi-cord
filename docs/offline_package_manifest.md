# Offline Package Manifest (Python 3.11, macOS x86_64)

| Package | Version | Wheel Filename | Notes |
|---------|---------|----------------|-------|
| prefect | 2.14.10 | `prefect-2.14.10-py3-none-any.whl` | Requires `httpx`, `pydantic`, etc. |
| kafka-python | 2.0.2 | `kafka_python-2.0.2-py2.py3-none-any.whl` | |
| boto3 | 1.34.143 | `boto3-1.34.143-py3-none-any.whl` | Includes `botocore`, `s3transfer`, `jmespath`. |
| botocore | 1.34.143 | `botocore-1.34.143-py3-none-any.whl` | Dependency of boto3. |
| s3transfer | 0.10.1 | `s3transfer-0.10.1-py3-none-any.whl` | Dependency of boto3. |
| jmespath | 1.0.1 | `jmespath-1.0.1-py3-none-any.whl` | Dependency of boto3. |
| psycopg2-binary | 2.9.9 | `psycopg2_binary-2.9.9-cp311-cp311-macosx_10_9_x86_64.whl` | Platform-specific. |
| sentence-transformers | 2.7.0 | `sentence_transformers-2.7.0-py3-none-any.whl` | Requires `torch`, `transformers`, `scikit-learn`, etc. |
| torch | 2.2.2 | `torch-2.2.2-cp311-none-macosx_10_9_x86_64.whl` | Ensure CPU-compatible build. |
| torchvision | 0.17.2 | `torchvision-0.17.2-cp311-cp311-macosx_10_9_x86_64.whl` | Required by some models. |
| transformers | 4.41.0 | `transformers-4.41.0-py3-none-any.whl` | Dependency of sentence-transformers. |
| accelerate | 0.29.3 | `accelerate-0.29.3-py3-none-any.whl` | Optional but recommended. |
| numpy | 1.26.4 | `numpy-1.26.4-cp311-cp311-macosx_10_9_x86_64.whl` | Used by many packages. |
| scipy | 1.13.1 | `scipy-1.13.1-cp311-cp311-macosx_10_9_x86_64.whl` | For scikit-learn. |
| scikit-learn | 1.4.2 | `scikit_learn-1.4.2-cp311-cp311-macosx_10_9_x86_64.whl` | For sentence-transformers. |
| pandas | 2.2.2 | `pandas-2.2.2-cp311-cp311-macosx_10_9_x86_64.whl` | Optional but useful. |
| pyspark | 3.5.1 | `pyspark-3.5.1-py2.py3-none-any.whl` | Includes Hadoop libs. |
| pyarrow | 15.0.2 | `pyarrow-15.0.2-cp311-cp311-macosx_10_15_x86_64.whl` | Match OS version. |
| great-expectations | 1.1.1 | `great_expectations-1.1.1-py3-none-any.whl` | Planned data quality checks. |
| prefect-dbt | 0.5.6 | `prefect_dbt-0.5.6-py3-none-any.whl` | Optional integration. |

Include dependency wheels (`charset-normalizer`, `urllib3`, `requests`, etc.) when preparing offline bundle. Adjust versions if compatibility issues arise.
