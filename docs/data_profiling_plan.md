# Data Profiling Plan

This plan outlines how to validate and "learn" the Concord database using real data. It complements `docs/complete_data_dictionary.md` and the SQL profiling script in `sql/profile_core_entities.sql`.

## Objectives
- Quantify data volume, completeness, and recency for core entities (Product, Order, OrderItem, Sale, Client).
- Detect anomalies (nulls, outliers, referential gaps) before ML/reporting work.
- Produce repeatable reports to track data quality over time.

## Prerequisites
- Staging views are materialised (`staging.stg_product`, `staging.stg_order_item`, `staging.stg_sale`, `staging.stg_client`, `staging.stg_order`).
- Access to analytics Postgres (or your warehouse) with read permissions.
- Python env `venv-py311` or psql client.

## Profiling Steps

1. **Row Counts and Growth**
   ```sql
   \i sql/profile_core_entities.sql  -- psql shorthand to execute script
   ```
   - Record counts per entity.
   - If CDC timestamps exist, extend with daily counts to watch growth.

2. **Null Ratios & Completeness**
   - Script calculates null ratios for key columns.
   - Extend the VALUES list per table for additional columns (e.g., `descriptionua`, `searchsynonymspl`).
   - Capture results into `docs/DATA_PROFILING_REPORT.md` (create if missing).

3. **Temporal Coverage**
   - Min/Max of `created_at`, `updated_at`, `shipment_date` reveals data currency.
   - If gaps exist (e.g., no updates in 30 days), flag for investigation.

4. **Distinct Cardinalities**
   - Understand diversity of codes (vendor_code, measure units, transporters).
   - Useful for forecasting/recommendation feature engineering.

5. **Outlier Detection**
   - Weight percentiles highlight heavy items; extend with price, discount, lead time.
   - Export to CSV for deeper analysis if needed.

6. **Referential Integrity**
   - `orphan_order_items` query ensures no missing product references.
   - Add similar checks (Sale -> Client, Order -> User).

7. **Business Rule Checks**
   - Example: `missing_shipment` and `missing_invoice` counts.
   - Add more (e.g., `IsForSale=1` but `IsForWeb=0`, `IsCashOnDelivery=1` with zero amount).

## Automating Profiling
- Convert SQL into a dbt exposure or incremental snapshot.
- Use Great Expectations to formalise expectations.
- Schedule via Prefect; log metrics to monitoring dashboards.

## Documentation & Follow-up
- Store results per run in `docs/DATA_PROFILING_REPORT.md` with date stamps.
- Annotate anomalies and remediation actions.
- Update data dictionary with business meaning discovered during profiling.

## Next Targets
- Extend profiling to pricing, inventory, transporter, and agreement tables.
- Profile historical fact tables for seasonality (needed for forecasting).
- Build dashboards summarising the metrics (Superset/Metabase).
