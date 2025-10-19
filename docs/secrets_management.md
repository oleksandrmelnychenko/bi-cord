# Secrets Management Strategy

## Requirements
- Avoid storing plaintext credentials or API keys in Git.
- Centralise management for SQL Server CDC credentials, MinIO keys, Kafka passwords, pgvector, and LLM tokens.
- Enable rotation without redeploying code.

## Recommended Approach
1. **Vault Deployment**
   - Use HashiCorp Vault (on-prem) with AppRole or Kubernetes auth.
   - Enable secrets engines:
     - KV v2 for static credentials (minio, Kafka, pgvector).
     - Database secrets engine for SQL Server if rotation is required.
   - Store environment-specific paths, e.g., `secret/cord/dev/sqlserver`.

2. **Prefect Integration**
   - Register Vault blocks for Prefect deployments.
   - Use Prefect Secret blocks to inject credentials into flows.

3. **dbt & Spark**
   - Configure environment variables via wrapper scripts that fetch secrets from Vault before launching dbt/spark-submit.

4. **Kafka Connect**
   - Replace plaintext in `sqlserver-product.json` with Vault-resolved environment variables.
   - Use Debezium’s support for externalized configuration (e.g., `value.converter.schemas.enable=${env:SCHEMAS_ENABLE:false}`).

5. **Documentation**
   - Maintain an access matrix in `docs/security/access_matrix.md` (to be created) tracking who can read/write each secret.

## Immediate Actions
- Deploy Vault or integrate with existing corporate secret store.
- Move SQL Server credential currently stored in `infra/kafka-connect/connectors/sqlserver-product.json` into Vault and reference via environment variables.
- Update local dev instructions to load secrets from `.env` file excluded by `.gitignore`.
