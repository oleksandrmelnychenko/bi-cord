# Hardware & Network Inventory Template

Use this worksheet to capture the physical and virtual resources allocated to the BI platform. Populate once hardware is confirmed; store completed version alongside infrastructure documentation.

## 1. Compute Nodes

| Role | Hostname | CPU (cores) | RAM (GB) | Storage (type/size) | OS / Kernel | Virtualization | Notes |
|------|----------|-------------|----------|---------------------|-------------|----------------|-------|
| Kafka Broker 1 | | | | | | | |
| Kafka Broker 2 | | | | | | | |
| Kafka Broker 3 | | | | | | | |
| MinIO Node 1 | | | | | | | |
| MinIO Node 2 | | | | | | | |
| MinIO Node 3 | | | | | | | |
| Trino Coordinator | | | | | | | |
| Trino Worker 1 | | | | | | | |
| Spark Master | | | | | | | |
| Spark Worker 1 | | | | | | | |
| PostgreSQL (pgvector) Primary | | | | | | | |
| Kubernetes Control Plane 1 | | | | | | | |
| Kubernetes Worker 1 | | | | | | | |
| GPU Node 1 | | | | | | | |

Add/remove rows based on actual topology.

## 2. Networking

- Core VLAN / Subnet for analytics zone: ``
- Firewall gateways: ``
- Load balancers / ingress controllers: ``
- DNS entries required: ``
- Bandwidth constraints / QoS considerations: ``

## 3. Storage & Backup

- MinIO bucket layout and retention policies:
- Backup schedule (MinIO, PostgreSQL, Kafka metadata):
- Snapshot/replication targets:
- Tape/archive integration (if applicable):

## 4. Access & Security

- LDAP/AD groups for platform access:
- Bastion hosts / jump boxes:
- SSH key management process:
- Patch management / OS updates cadence:

## 5. Contacts

- Platform owner:
- DBA lead:
- Network engineer:
- Security officer:
- On-call rotation:
