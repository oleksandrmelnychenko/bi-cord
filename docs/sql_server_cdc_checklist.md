# SQL Server CDC & Connectivity Checklist

## 1. Access & Credentials
- [ ] Identify source SQL Server instance/cluster hosting Cord schema.
- [ ] Provision a dedicated read-only login with `db_datareader`, `VIEW DATABASE STATE`, and `SELECT` on CDC metadata tables.
- [ ] Store credentials in Vault/secret manager; prohibit embedding in source code or config files.

## 2. Network
- [ ] Confirm IP ranges for analytics zone; open firewall for Debezium connector → SQL Server (default port 1433).
- [ ] Allow Debezium/Kafka Connect nodes to reach Kafka brokers, Schema Registry, and MinIO.
- [ ] Verify reverse connectivity for monitoring/alerting (Prometheus scrape endpoints).

## 3. SQL Server Configuration
- [ ] Enable SQL Server Agent (required for CDC).
- [ ] Turn on CDC at database level: `EXEC sys.sp_cdc_enable_db`.
- [ ] Enable CDC for target tables (`Product`, `[Order]`, `OrderItem`, `Sale`, `Client`, etc.) with appropriate capture instance names.
- [ ] Set retention period (default 3 days) according to ingestion SLA; document purge strategy.
- [ ] Monitor log growth; consider separate filegroup for CDC tables if storage pressure expected.

## 4. Debezium / Kafka Connect Setup
- [ ] Deploy Kafka Connect worker with SQL Server Debezium plugin installed.
- [ ] Configure connector JSON: connection string, include/exclude tables, snapshot mode (`initial_only` for bootstrap), `max.batch.size`, heartbeat interval.
- [ ] Set `tombstones.on.delete=true` to propagate delete events into lake/warehouse.
- [ ] Define dead-letter queue topic for connector errors; configure retry/backoff policies.
- [ ] Register schemas in Schema Registry (if using Avro/Protobuf) or configure JSON with schema evolution policy.

## 5. Bootstrap & Validation
- [ ] Run initial snapshot; capture offsets and store in Git-controlled ops repo.
- [ ] Consume sample change events; validate field mappings and data types.
- [ ] Load snapshot & incremental events into staging tables; run row-count parity checks vs. source.
- [ ] Establish monitoring alerts for connector lags, task failures, and CDC job health.

## 6. Documentation & Operations
- [ ] Create SOP for pausing/resuming connectors during maintenance.
- [ ] Define recovery procedure for lost offsets or connector rebalances.
- [ ] Record contact points (DBA, network, platform) and escalation path.
- [ ] Schedule periodic audits of permissions and firewall rules.
