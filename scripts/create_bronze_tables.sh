#!/bin/bash
# Create bronze tables for all Product-related tables
# Usage: ./scripts/create_bronze_tables.sh

set -e  # Exit on error

echo "========================================"
echo "  Creating Bronze Tables"
echo "========================================"
echo ""

# Database connection parameters
DB_HOST="${PGHOST:-localhost}"
DB_PORT="${PGPORT:-5433}"
DB_NAME="${PGDATABASE:-analytics}"
DB_USER="${PGUSER:-analytics}"
DB_PASSWORD="${PGPASSWORD:-analytics}"

# Product-related tables (snake_case)
TABLES=(
  "product_analogue"
  "product_availability"
  "product_availability_cart_limits"
  "product_capitalization"
  "product_capitalization_item"
  "product_car_brand"
  "product_category"
  "product_group"
  "product_group_discount"
  "product_image"
  "product_income"
  "product_income_item"
  "product_location"
  "product_location_history"
  "product_original_number"
  "product_placement"
  "product_placement_history"
  "product_placement_movement"
  "product_placement_storage"
  "product_pricing"
  "product_product_group"
  "product_reservation"
  "product_set"
  "product_slug"
  "product_specification"
  "product_sub_group"
  "product_transfer"
  "product_transfer_item"
  "product_write_off_rule"
  "measure_unit"
)

SUCCESS_COUNT=0
FAIL_COUNT=0

for table in "${TABLES[@]}"; do
  echo "Creating bronze.${table}_cdc..."

  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS bronze.${table}_cdc (
    id BIGSERIAL PRIMARY KEY,
    kafka_topic VARCHAR(255),
    kafka_partition INT,
    kafka_offset BIGINT,
    kafka_timestamp BIGINT,
    kafka_key JSONB,
    cdc_payload JSONB,
    ingested_at TIMESTAMP DEFAULT NOW(),
    batch_file VARCHAR(500),
    UNIQUE(kafka_topic, kafka_partition, kafka_offset)
);

CREATE INDEX IF NOT EXISTS idx_${table}_cdc_ingested ON bronze.${table}_cdc(ingested_at);
CREATE INDEX IF NOT EXISTS idx_${table}_cdc_offset ON bronze.${table}_cdc(kafka_topic, kafka_partition, kafka_offset);

COMMENT ON TABLE bronze.${table}_cdc IS 'Raw CDC events for ${table} from Debezium';
COMMENT ON COLUMN bronze.${table}_cdc.cdc_payload IS 'Full Debezium CDC event (before, after, source, op)';
COMMENT ON COLUMN bronze.${table}_cdc.ingested_at IS 'Timestamp when record was loaded into bronze';
EOF

  if [ $? -eq 0 ]; then
    echo "  ✅ bronze.${table}_cdc created successfully"
    ((SUCCESS_COUNT++))
  else
    echo "  ❌ Failed to create bronze.${table}_cdc"
    ((FAIL_COUNT++))
  fi

  echo ""
done

echo "========================================"
echo "  Summary"
echo "========================================"
echo "  Success: $SUCCESS_COUNT tables"
echo "  Failed:  $FAIL_COUNT tables"
echo "  Total:   ${#TABLES[@]} tables"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
  echo "🎉 All bronze tables created successfully!"
  exit 0
else
  echo "⚠️  Some tables failed to create. Check errors above."
  exit 1
fi
