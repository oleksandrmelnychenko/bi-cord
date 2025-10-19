# Registering the SQL Server Debezium Connector

## Prerequisites
- Docker Compose stack from `infra/docker-compose.dev.yml` is running (Kafka, Connect, MinIO, etc.).
- SQL Server CDC is enabled and the credentials in `infra/kafka-connect/connectors/sqlserver-product.json` are populated.
- Debezium SQL Server connector JARs exist in `infra/kafka-connect/plugins` (already bundled in the Debezium image, keep placeholders for custom jars if needed).

## Steps

1. **Review connector config**
   - Open `infra/kafka-connect/connectors/sqlserver-product.json`.
   - Confirm the host (`78.152.175.67`), database (`ConcordDb`), and credentials match the target environment.
   - Adjust `table.include.list` to add more tables as needed (comma-separated).

2. **Deploy connector**
   ```bash
   curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d @infra/kafka-connect/connectors/sqlserver-product.json
   ```
   - If the connector already exists, update it:
     ```bash
     curl -X PUT http://localhost:8083/connectors/sqlserver-product-connector/config \
       -H "Content-Type: application/json" \
       -d @infra/kafka-connect/connectors/sqlserver-product.json
     ```

3. **Verify status**
   ```bash
   curl http://localhost:8083/connectors/sqlserver-product-connector/status | jq
   ```
   - Ensure the connector and tasks show `"state": "RUNNING"`.

4. **Check Kafka topics**
   ```bash
   docker compose -f infra/docker-compose.dev.yml exec kafka \
     kafka-console-consumer --bootstrap-server kafka:29092 \
     --topic cord.dbo.Product --from-beginning --max-messages 5
   ```
   - You should see JSON change events; abort with `Ctrl+C`.

5. **Troubleshooting**
   - Logs: `docker compose -f infra/docker-compose.dev.yml logs -f kafka-connect`
   - Common issues: firewall blocking SQL Server, wrong credentials, CDC not enabled, timezone mismatch.

## Next Actions
- Implement Prefect flow to land change events from Kafka into MinIO raw layer.
- Add additional connector configs for `OrderItem`, `Sale`, `Client`, etc., or expand the table list.
- Configure schema registry serialization (Avro/Protobuf) if needed for downstream tools.
