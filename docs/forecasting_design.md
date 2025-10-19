# Demand Forecasting Design

## Goal
Predict future product demand (daily/weekly sales) to improve purchasing, inventory, and customer offers. This builds on the existing staging layer and will feed both BI reports and recommendation logic.

## Target Metrics
- **Primary**: quantity sold per product (optionally by client, region, or channel) aggregated daily/weekly.
- **Secondary**: revenue, margin, returns, lead time between order and shipment.

## Data Sources
- `staging.stg_order_item`: quantities, prices, discounts, VAT, channel metadata.
- `staging.stg_sale`: shipment dates, transporter, payment status.
- `staging.stg_product`: product features (category, flags, weight).
- `staging.stg_client`: segment, geography, e-commerce flag.
- Optional external signals: holidays, promotions (future TODO).

## Feature Engineering
- Time-series features: lagged sales (7/14/28 days), moving averages, rolling std dev.
- Calendar features: day-of-week, month, quarter, holidays, seasonality index.
- Product attributes: category/group, weight, price tiers, IsForSale/IsForWeb flags.
- Client attributes (if client-level forecasts): country, manager, segment.
- Stock & logistics (future): availability, lead time, transporter performance.

## Model Roadmap
1. **Baseline**: Naïve (last period), seasonal naive, moving average.
2. **Classical**: Prophet/NeuralProphet, ARIMA/ETS for univariate product time-series.
3. **Machine Learning**: LightGBM/XGBoost with engineered features for global model.
4. **Advanced**: Temporal Fusion Transformer, N-BEATS, or Chronos for joint modeling.

## Pipeline Outline
1. Create a fact table `mart_sales_daily` via dbt aggregating order items into daily product sales.
2. Use Prefect flow to extract this fact table into parquet/Arrow dataset.
3. Train baseline models; store metrics in MLflow (MSE, MAE, MAPE, WAPE, service-level).
4. Persist forecasts back to warehouse (table `mart_forecast_product_day`).
5. Expose results via BI dashboards and for downstream recommendation/ranking.

## Evaluation Strategy
- Rolling-origin evaluation (time-series cross-validation) with hold-out weeks.
- Metrics by hierarchy: all products, main categories, key clients.
- Monitor bias (over/under forecast) and service-level (P90 absolute error).

## Operational Considerations
- Schedule retraining weekly/monthly depending on data volatility.
- Detect anomalies (zero sales due to stock-out) and incorporate as features.
- Allow for manual overrides and scenario planning in BI tool.
- Version control models & forecasts; maintain audit trail.

## Next Steps
- Build `mart_sales_daily` dbt model (Product × Date × Client or aggregated).
- Draft Prefect training flow skeleton in `src/ml/forecasting_pipeline.py`.
- Select baseline forecasting framework (Prophet or LightGBM) and gather offline packages.
- Define dashboard requirements with business stakeholders.
