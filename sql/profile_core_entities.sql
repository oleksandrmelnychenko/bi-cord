-- Core entity profiling queries

-- 1. Row counts
SELECT 'Product' AS table_name, COUNT(*) AS row_count FROM staging.stg_product
UNION ALL
SELECT 'Order' AS table_name, COUNT(*) AS row_count FROM staging.stg_order
UNION ALL
SELECT 'OrderItem' AS table_name, COUNT(*) AS row_count FROM staging.stg_order_item
UNION ALL
SELECT 'Sale' AS table_name, COUNT(*) AS row_count FROM staging.stg_sale
UNION ALL
SELECT 'Client' AS table_name, COUNT(*) AS row_count FROM staging.stg_client
ORDER BY table_name;

-- 2. Null ratios for selected columns
SELECT 'stg_product' AS table_name,
       column_name,
       NULLIF(COUNT(*) FILTER (WHERE value IS NULL)::numeric,0) / NULLIF(COUNT(*),0) AS null_ratio
FROM staging.stg_product
CROSS JOIN LATERAL (
    VALUES
        ('description', description),
        ('hasanalogue', hasanalogue::text),
        ('hasimage', hasimage::text),
        ('isforsale', isforsale::text),
        ('isforweb', isforweb::text),
        ('weight', weight::text),
        ('measureunitid', measureunitid::text)
) AS attr(column_name, value)
GROUP BY column_name;

-- Repeat for OrderItem
SELECT 'stg_order_item' AS table_name,
       column_name,
       NULLIF(COUNT(*) FILTER (WHERE value IS NULL)::numeric,0) / NULLIF(COUNT(*),0) AS null_ratio
FROM staging.stg_order_item
CROSS JOIN LATERAL (
    VALUES
        ('qty', qty::text),
        ('priceperitem', priceperitem::text),
        ('discountamount', discountamount::text),
        ('orderedqty', orderedqty::text),
        ('returnedqty', returnedqty::text)
) AS attr(column_name, value)
GROUP BY column_name;

-- 3. Min/Max timestamps to gauge data currency
SELECT 'stg_product' AS table_name,
       MIN(created_at) AS min_created,
       MAX(updated_at) AS max_updated
FROM staging.stg_product
UNION ALL
SELECT 'stg_order_item', MIN(created_at), MAX(updated_at) FROM staging.stg_order_item
UNION ALL
SELECT 'stg_sale', MIN(created), MAX(updated) FROM staging.stg_sale
UNION ALL
SELECT 'stg_client', MIN(created), MAX(updated) FROM staging.stg_client;

-- 4. Distinct counts for key business fields
SELECT 'stg_product' AS table_name,
       COUNT(DISTINCT vendor_code) AS distinct_vendor_codes,
       COUNT(DISTINCT measureunitid) AS distinct_measure_units,
       COUNT(DISTINCT isforsale) AS distinct_sale_flags
FROM staging.stg_product;

SELECT 'stg_order_item' AS table_name,
       COUNT(DISTINCT order_id) AS distinct_orders,
       COUNT(DISTINCT product_id) AS distinct_products,
       COUNT(DISTINCT user_id) AS distinct_users
FROM staging.stg_order_item;

SELECT 'stg_sale' AS table_name,
       COUNT(DISTINCT client_agreement_id) AS distinct_client_agreements,
       COUNT(DISTINCT transporter_id) AS distinct_transporters,
       COUNT(DISTINCT basesalepaymentstatusid) AS distinct_payment_statuses
FROM staging.stg_sale;

SELECT 'stg_client' AS table_name,
       COUNT(DISTINCT country_id) AS distinct_countries,
       COUNT(DISTINCT region_id) AS distinct_regions,
       COUNT(DISTINCT mainmanagerid) AS distinct_managers
FROM staging.stg_client;

-- 5. Example outlier detection for product weight
SELECT product_id,
       name,
       weight,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY weight) OVER () AS median_weight,
       percentile_cont(0.75) WITHIN GROUP (ORDER BY weight) OVER () AS p75_weight,
       percentile_cont(0.25) WITHIN GROUP (ORDER BY weight) OVER () AS p25_weight
FROM staging.stg_product
WHERE weight IS NOT NULL
ORDER BY weight DESC
LIMIT 50;

-- 6. Referential integrity check (OrderItem -> Product)
SELECT COUNT(*) AS orphan_order_items
FROM staging.stg_order_item oi
LEFT JOIN staging.stg_product p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

-- 7. Sales with missing shipments or invoices
SELECT COUNT(*) FILTER (WHERE shipment_date IS NULL) AS missing_shipment,
       COUNT(*) FILTER (WHERE saleinvoicedocumentid IS NULL) AS missing_invoice
FROM staging.stg_sale;
