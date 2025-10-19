# Data Profiling Report

**Generated**: 2025-10-18 23:30:59
**Database**: analytics (port 5433)

## Summary

| Schema | Table | Rows | Columns |
|--------|-------|------|---------|
| `staging_staging` | `stg_product` | 115 | 53 |
| `bronze` | `product_cdc` | 115 | 9 |

---

## staging_staging.stg_product

**Total Rows**: 115

### Column Statistics

| Column | Type | Nulls | Null % | Distinct |
|--------|------|-------|--------|----------|
| `product_id` | bigint | 0 | 0.0% | 115 |
| `net_uid` | uuid | 0 | 0.0% | 115 |
| `created` | timestamp with time zone | 0 | 0.0% | 1 |
| `updated` | timestamp with time zone | 0 | 0.0% | 1 |
| `deleted` | boolean | 0 | 0.0% | 1 |
| `name` | text | 0 | 0.0% | 25 |
| `vendor_code` | text | 0 | 0.0% | 114 |
| `description` | text | 0 | 0.0% | 1 |
| `size` | text | 0 | 0.0% | 1 |
| `weight` | numeric | 0 | 0.0% | 5 |
| `volume` | text | 0 | 0.0% | 1 |
| `image` | text | 0 | 0.0% | 1 |
| `main_original_number` | text | 0 | 0.0% | 73 |
| `measure_unit_id` | bigint | 0 | 0.0% | 2 |
| `top` | text | 0 | 0.0% | 7 |
| `name_pl` | text | 0 | 0.0% | 20 |
| `description_pl` | text | 0 | 0.0% | 17 |
| `notes_pl` | text | 0 | 0.0% | 1 |
| `synonyms_pl` | text | 0 | 0.0% | 1 |
| `name_ua` | text | 0 | 0.0% | 26 |
| `description_ua` | text | 0 | 0.0% | 18 |
| `notes_ua` | text | 0 | 0.0% | 1 |
| `synonyms_ua` | text | 0 | 0.0% | 1 |
| `search_name` | text | 0 | 0.0% | 25 |
| `search_description` | text | 0 | 0.0% | 1 |
| `search_size` | text | 0 | 0.0% | 1 |
| `search_vendor_code` | text | 0 | 0.0% | 114 |
| `search_name_pl` | text | 0 | 0.0% | 20 |
| `search_description_pl` | text | 0 | 0.0% | 17 |
| `search_synonyms_pl` | text | 0 | 0.0% | 1 |
| `search_name_ua` | text | 0 | 0.0% | 26 |
| `search_description_ua` | text | 0 | 0.0% | 18 |
| `search_synonyms_ua` | text | 0 | 0.0% | 1 |
| `has_analogue` | boolean | 0 | 0.0% | 2 |
| `has_image` | boolean | 0 | 0.0% | 1 |
| `is_for_sale` | boolean | 0 | 0.0% | 1 |
| `is_for_web` | boolean | 0 | 0.0% | 1 |
| `is_for_zero_sale` | boolean | 0 | 0.0% | 1 |
| `has_component` | boolean | 0 | 0.0% | 1 |
| `ucgfea` | text | 0 | 0.0% | 2 |
| `standard` | text | 0 | 0.0% | 7 |
| `order_standard` | text | 0 | 0.0% | 1 |
| `packing_standard` | text | 0 | 0.0% | 2 |
| `source_amg_id` | bytea | 0 | 0.0% | 115 |
| `source_fenix_id` | bytea | 115 | 100.0% | 0 |
| `parent_amg_id` | bytea | 0 | 0.0% | 10 |
| `parent_fenix_id` | bytea | 115 | 100.0% | 0 |
| `source_amg_code` | bigint | 0 | 0.0% | 115 |
| `source_fenix_code` | bigint | 115 | 100.0% | 0 |
| `is_snapshot` | text | 0 | 0.0% | 2 |

### High Null Columns (> 50%)

- **source_fenix_id**: 100.0% null (115 / 115)
- **parent_fenix_id**: 100.0% null (115 / 115)
- **source_fenix_code**: 100.0% null (115 / 115)

### Categorical Columns (≤ 20 distinct values)

**created** (1 distinct):

- `2023-01-20 17:25:15+00:00`: 115 occurrences

**updated** (1 distinct):

- `2023-01-20 17:12:42+00:00`: 115 occurrences

**deleted** (1 distinct):

- `False`: 115 occurrences

**description** (1 distinct):

- ``: 115 occurrences

**size** (1 distinct):

- ``: 115 occurrences

**weight** (5 distinct):

- `0.0`: 110 occurrences
- `0.021`: 2 occurrences
- `0.015`: 1 occurrences
- `0.115`: 1 occurrences
- `0.35`: 1 occurrences

**volume** (1 distinct):

- `0.000`: 115 occurrences

**image** (1 distinct):

- ``: 115 occurrences

**measure_unit_id** (2 distinct):

- `73`: 113 occurrences
- `92`: 2 occurrences

**top** (7 distinct):

- `O`: 95 occurrences
- `A`: 9 occurrences
- `C`: 5 occurrences
- ``: 2 occurrences
- `N`: 2 occurrences

**name_pl** (20 distinct):

- `Drążek kierowniczy`: 47 occurrences
- `Resor pneumatyczny`: 43 occurrences
- `Lampa obrysowa`: 5 occurrences
- `Amortyzator`: 2 occurrences
- `Resor pneumatyczny kpl. Z met. podstava`: 2 occurrences

**description_pl** (17 distinct):

- ``: 99 occurrences
- `12 LED вдоль, красный`: 1 occurrences
- `6 LED вдоль, красный`: 1 occurrences
- `BPW`: 1 occurrences
- `12 LED вдоль, белый`: 1 occurrences

**notes_pl** (1 distinct):

- ``: 115 occurrences

**synonyms_pl** (1 distinct):

- ``: 115 occurrences

**description_ua** (18 distinct):

- ``: 97 occurrences
- `MAN`: 2 occurrences
- `12 LED вдоль, красный`: 1 occurrences
- `BPW 36K 2 шпильки-воздух, 4881MB, W01M588602, 08411672`: 1 occurrences
- `6 LED вдоль, красный`: 1 occurrences

**notes_ua** (1 distinct):

- ``: 115 occurrences

**synonyms_ua** (1 distinct):

- ``: 115 occurrences

**search_description** (1 distinct):

- ``: 115 occurrences

**search_size** (1 distinct):

- ``: 115 occurrences

**search_name_pl** (20 distinct):

- `Drazekkierowniczy`: 47 occurrences
- `Resorpneumatyczny`: 43 occurrences
- `Lampaobrysowa`: 5 occurrences
- `Amortyzator`: 2 occurrences
- `ResorpneumatycznykplZmetpodstava`: 2 occurrences

**search_description_pl** (17 distinct):

- ``: 99 occurrences
- `12LEDвдолькрасный`: 1 occurrences
- `6LEDвдолькрасный`: 1 occurrences
- `BPW`: 1 occurrences
- `12LEDвдольбелый`: 1 occurrences

**search_synonyms_pl** (1 distinct):

- ``: 115 occurrences

**search_description_ua** (18 distinct):

- ``: 97 occurrences
- `MAN`: 2 occurrences
- `12LEDвдолькрасный`: 1 occurrences
- `BPW36K2шпилькивоздух4881MBW01M58860208411672`: 1 occurrences
- `6LEDвдолькрасный`: 1 occurrences

**search_synonyms_ua** (1 distinct):

- ``: 115 occurrences

**has_analogue** (2 distinct):

- `True`: 77 occurrences
- `False`: 38 occurrences

**has_image** (1 distinct):

- `False`: 115 occurrences

**is_for_sale** (1 distinct):

- `False`: 115 occurrences

**is_for_web** (1 distinct):

- `True`: 115 occurrences

**is_for_zero_sale** (1 distinct):

- `False`: 115 occurrences

**has_component** (1 distinct):

- `False`: 115 occurrences

**ucgfea** (2 distinct):

- ``: 74 occurrences
- `4016995290    `: 41 occurrences

**standard** (7 distinct):

- `0.000`: 100 occurrences
- `10.000`: 6 occurrences
- `100.000`: 3 occurrences
- `50.000`: 2 occurrences
- `30.000`: 2 occurrences

**order_standard** (1 distinct):

- ``: 115 occurrences

**packing_standard** (2 distinct):

- `1.000`: 112 occurrences
- `0.000`: 3 occurrences

**is_snapshot** (2 distinct):

- `true`: 114 occurrences
- `first`: 1 occurrences

---

## bronze.product_cdc

**Total Rows**: 115

### Column Statistics

| Column | Type | Nulls | Null % | Distinct |
|--------|------|-------|--------|----------|
| `id` | bigint | 0 | 0.0% | 115 |
| `kafka_timestamp` | bigint | 0 | 0.0% | 33 |
| `kafka_key` | jsonb | 0 | 0.0% | 115 |
| `cdc_payload` | jsonb | 0 | 0.0% | 115 |
| `batch_file` | character varying | 0 | 0.0% | 1 |

### Categorical Columns (≤ 20 distinct values)

**batch_file** (1 distinct):

- `product/raw/batch=20251018T145647Z.jsonl`: 115 occurrences
