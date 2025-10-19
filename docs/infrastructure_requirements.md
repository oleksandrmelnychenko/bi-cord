# Infrastructure Requirements & Checklist

## 1. Hardware Sizing Targets

| Component | Purpose | Minimum | Recommended |
|-----------|---------|---------|-------------|
| SQL Server Replica | Read-only source for CDC | Existing production replica | Dedicated read replica to isolate CDC workload |
| Kafka Cluster | CDC ingestion buffer | 3 brokers, 4 vCPU, 16 GB RAM, 500 GB SSD each | 3–5 brokers, 8 vCPU, 32 GB RAM, 1 TB NVMe each |
| ZooKeeper / KRaft | Kafka metadata (if not using KRaft) | Co-locate with Kafka | Separate quorum or KRaft mode |
| MinIO Object Storage | Landing + lake (Delta/Iceberg) | 3 nodes, 8 TB raw, RAID-10 | 4+ nodes, 40 TB raw, erasure coding |
| Trino/Presto Workers | Interactive SQL, BI queries | 3 nodes, 8 vCPU, 32 GB RAM | Horizontal scale as concurrency grows |
| Spark Cluster | Heavy batch ML/ETL | 3 nodes, 16 vCPU, 64 GB RAM | Expand to GPU-enabled nodes for ML workloads |
| PostgreSQL (pgvector/metadata) | Vector store + metadata | HA pair, 8 vCPU, 32 GB RAM | Add Citus/Patroni for clustering if required |
| Kubernetes Control Plane | Orchestrate APIs, Prefect, MLflow | 3 masters, 4 vCPU, 16 GB RAM | Align with organisation’s standard |
| GPU Nodes | LLM inference & embedding models | 1 node, 1×A6000/RTX 6000 | 2+ nodes for redundancy, MIG partitioning |
| Monitoring Stack | Prometheus, Grafana, Loki | 2 nodes, 4 vCPU, 16 GB RAM | Scale with retention/pipeline volume |

## 2. Network & Security
- Segregate production OLTP network from analytics zone; enforce read-only SQL Server credentials.
- Establish firewall rules for CDC connector (Debezium) to reach SQL Server, Kafka, and MinIO.
- Configure TLS for all intra-cluster communication (Kafka, MinIO, Trino, PostgreSQL, Kubernetes API).
- Integrate with corporate identity provider (LDAP/AD) for Superset, Prefect UI, and JupyterHub.
- Document backup/restore pipeline for MinIO buckets, PostgreSQL databases, and Kafka cluster metadata.

## 3. Platform Services
- **Secrets Management:** Deploy HashiCorp Vault or equivalent; integrate Prefect, dbt, and API services.
- **Container Registry:** On-prem registry (Harbor, Nexus) hosting service images and model artifacts.
- **CI/CD:** GitLab Runner or Jenkins with pipelines for dbt tests, Prefect deployments, container build/push.
- **Logging:** Fluent Bit → Loki/Elastic stack; centralise FastAPI, Prefect, Kafka connect logs.

## 4. LLM & ML Serving
- Reserve GPU nodes with CUDA drivers, NCCL, and container runtimes (NVIDIA Container Toolkit).
- Host text-generation serving stack (vLLM or TGI) behind internal API gateway; enforce rate limits and audit logging.
- Provide offline training environment with JupyterHub/Spark integration and dataset access control.

## 5. Open Questions
- Finalise rack location, power, and cooling expectations for new hardware.
- Confirm whether existing corporate monitoring covers Kafka/MinIO or new stack must be integrated manually.
- Decide on license-management for proprietary models/tools (if any) and retention policies for raw CDC data.

## 6. Action Items
1. Inventory available hardware and virtualisation capacity.
2. Submit procurement requests for any gaps (storage expansion, GPUs, network gear).
3. Draft network diagram showing connectivity between OLTP, CDC, lakehouse, and serving layers.
4. Prepare security review including backup, disaster recovery, and access provisioning.
