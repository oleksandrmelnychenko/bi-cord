# `stg_product` Mapping Notes

## Source
- Table: `bronze.product_cdc`
- Schema: Debezium envelope JSON with keys `before`, `after`, `op`, `ts_ms`, etc.

## Target Columns
| Column         | Derivation                                   |
|----------------|-----------------------------------------------|
| `product_id`   | `after.ID`                                    |
| `name`         | `after.Name`                                  |
| `vendor_code`  | `after.VendorCode`                            |
| `weight`       | `after.Weight`                                |
| `created_at`   | `after.Created`                               |
| `updated_at`   | `after.Updated`                               |
| `is_deleted`   | `after.Deleted`                               |
| `source_ts`    | `source.ts_ms`                                |

## TODO
- Confirm case sensitivity and column names after first bronze load.
- Add JSON parsing logic in `stg_product.sql` using Iceberg struct/JSON functions.
- Filter tombstones (`op = 'd'`) and soft deletes (`is_deleted = 1`).
- Add additional descriptive columns (size, synonyms, multilingual fields) once verified.
