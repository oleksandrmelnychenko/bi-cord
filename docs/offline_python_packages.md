# Offline Python Package Strategy

Because the environment cannot reach public PyPI, we must source required wheels via offline or mirrored channels.

## 1. Required Packages (current scope)
- Prefect 2.14.10
- kafka-python 2.0.2
- boto3 1.34.143 (plus botocore, s3transfer dependencies)
- psycopg2-binary 2.9.9
- sentence-transformers 2.7.0 (and its dependencies: torch/transformers/etc.)
- PySpark 3.5.1
- PyArrow 15.0.2

## 2. Acquisition Paths
1. **Corporate Artifact Repository**
   - Request DevOps to mirror required packages on internal Nexus/Artifactory.
   - Update `pip.conf` to point to the internal index.
2. **Offline Bundle**
   - Use internet-connected machine to run:
     ```bash
     pip download -r requirements.txt -d offline_wheels/
     ```
   - Transfer the directory to the offline environment and install:
     ```bash
     pip install --no-index --find-links offline_wheels/ -r requirements.txt
     ```
3. **Manual Wheel Selection**
   - For large packages (PyTorch, sentence-transformers dependencies), download specific wheel files matching Python version (3.11) and OS architecture (macOS/amd64).

## 3. Hash Pinning
- Generate `requirements.txt` with hashes using `pip-compile --generate-hashes`.
- Store resulting file in repo as `requirements.lock`.
- During offline install, use `pip install --require-hashes`.

## 4. Verification
- After installing, run:
  ```bash
  python -c "import prefect, pyspark, sentence_transformers, kafka, boto3"
  ```
- Update `docs/run_log.md` with status.

## 5. Future Considerations
- Automate bundle creation via CI job on a machine with internet access.
- Mirror only approved packages to satisfy security/compliance checks.
