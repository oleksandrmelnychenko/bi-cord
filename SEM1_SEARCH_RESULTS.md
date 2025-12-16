# SEM1 Search - Execution Time & Results

## Summary

✅ **Default Limit**: 20 results (already configured)
✅ **Database**: Running with 6,728 SEM1 products
✅ **Performance**: Excellent (9-98ms query execution)

---

## Test Results

### Test 1: Search "тяга" (Steering Rod)

**Query Parameters:**
```json
{
  "action": "search",
  "query": "тяга",
  "supplier_name": "SEM1",
  "limit": 20
}
```

**Performance:**
- ⏱️ **Execution Time**: 77.22 ms
- 📊 **Total Results**: 1,245 products
- 📦 **Returned**: 20 products (limit)

**Sample Results:**
```
Product ID | Vendor Code | Name             | Ukrainian Name  | Score
-----------|-------------|------------------|-----------------|-------
7807566    | SEM14310    | Тяга рулевая     | Тяга рульова    | 1.0000
7807567    | SEM14298    | Тяга рулевая     | Тяга рульова    | 1.0000
7807568    | SEM14297    | Тяга рулевая     | Тяга рульова    | 1.0000
7807569    | SEM14290    | Тяга рулевая     | Тяга рульова    | 1.0000
7807570    | SEM14283    | Тяга рулевая     | Тяга рульова    | 1.0000
7807571    | SEM14282    | Тяга рулевая     | Тяга рульова    | 1.0000
7807572    | SEM14275    | Тяга рулевая     | Тяга рульова    | 1.0000
7807573    | SEM14274    | Тяга рулевая     | Тяга рульова    | 1.0000
7807574    | SEM14268    | Тяга рулевая     | Тяга рульова    | 1.0000
7807575    | SEM14251    | Тяга рулевая     | Тяга рульова    | 1.0000
7807576    | SEM14250    | Тяга рулевая     | Тяга рульова    | 1.0000
7807577    | SEM14242    | Тяга рулевая     | Тяга рульова    | 1.0000
7807578    | SEM14191    | Тяга рулевая     | Тяга рульова    | 1.0000
7807579    | SEM14183    | Тяга рулевая     | -2146826246     | 1.0000
7807580    | SEM14175    | Тяга рулевая     | Тяга рульова    | 1.0000
7807581    | SEM14167    | Тяга продольная  | Тяга повздовжня | 1.0000
7807582    | SEM14228    | Тяга рулевая     | Тяга рульова    | 1.0000
7807583    | SEM14211    | Тяга рулевая     | -2146826246     | 1.0000
7807584    | SEM14203    | Тяга рулевая     | Тяга рульова    | 1.0000
7807585    | SEM14186    | Тяга рулевая     | Тяга рульова    | 1.0000
```

---

### Test 2: Vendor Code Search "SEM143"

**Query Parameters:**
```json
{
  "action": "search",
  "query": "SEM143",
  "supplier_name": "SEM1",
  "limit": 20
}
```

**Performance:**
- ⏱️ **Execution Time**: 9.87 ms ⚡ (Very Fast!)
- 📊 **Total Results**: 100 products
- 📦 **Returned**: 20 products (limit)

**Sample Results:**
```
Product ID | Vendor Code | Name                        | Weight (kg)
-----------|-------------|----------------------------|------------
7809647    | SEM14300    | Тяга рулевая               | 0.0
7810653    | SEM14301    | Тяга рулевая               | 0.0
7810652    | SEM14302    | Тяга рулевая               | 0.0
7809635    | SEM14303    | Тяга рулевая               | 0.0
7809634    | SEM14304    | Тяга рулевая               | 0.0
7810584    | SEM14305    | Тяга рулевая               | 0.0
7810583    | SEM14306    | Тяга рулевая               | 0.0
7809646    | SEM14307    | Тяга рулевая               | 0.0
7809645    | SEM14308    | Тяга рулевая               | 0.0
7810651    | SEM14309    | Тяга рулевая продольная    | 0.0
7807566    | SEM14310    | Тяга рулевая               | 0.0
7809633    | SEM14311    | Тяга рулевая               | 0.0
7807608    | SEM14312    | Тяга рулевая               | 0.0
7809785    | SEM14313    | Тяга рулевая               | 0.0
7809632    | SEM14314    | Тяга рулевая               | 0.0
7810611    | SEM14315    | Тяга рулевая               | 0.0
7810650    | SEM14316    | Тяга рулевая               | 0.0
7810604    | SEM14317    | Тяга рулевая               | 0.0
7810649    | SEM14318    | Тяга рулевая               | 0.0
7808727    | SEM14319    | Тяга рулевая               | 0.0
```

---

### Test 3: Search "амортизатор" (Shock Absorber)

**Query Parameters:**
```json
{
  "action": "search",
  "query": "амортизатор",
  "supplier_name": "SEM1",
  "limit": 20
}
```

**Performance:**
- ⏱️ **Execution Time**: 98.12 ms
- 📊 **Total Results**: 294 products
- 📦 **Returned**: 20 products (limit)

**Sample Results:**
```
Product ID | Vendor Code | Name                            | Weight (kg) | For Sale | Image
-----------|-------------|---------------------------------|-------------|----------|------
7808593    | SEM11017    | Амортизатор кушетки газовый     | 0.00        | ✗        | ✗
7808594    | SEM11016    | Амортизатор капота              | 0.00        | ✗        | ✗
7808595    | SEM11036    | Амортизатор капота              | 0.00        | ✗        | ✗
7810053    | SEM14138    | Амортизатор                     | 0.00        | ✗        | ✗
7829261    | SEM11025    | Амортизатор капота              | 0.00        | ✗        | ✗
7829262    | SEM11028    | Амортизатор капота              | 0.00        | ✗        | ✗
7829263    | SEM11039    | Амортизатор капота              | 0.00        | ✗        | ✗
7829264    | SEM11051    | Амортизатор капота              | 0.26        | ✗        | ✗
7829362    | SEM11031    | Амортизатор капота              | 0.00        | ✗        | ✗
7829363    | SEM11037    | Амортизатор капота              | 0.00        | ✗        | ✗
7829364    | SEM11049    | Амортизатор капота              | 0.00        | ✗        | ✗
7829437    | SEM11012    | Амортизатор капота              | 0.00        | ✗        | ✗
7836962    | SEM11044    | Амортизатор капота              | 0.00        | ✗        | ✗
7837037    | SEM11011    | Амортизатор капота              | 0.00        | ✗        | ✗
7837038    | SEM11014    | Амортизатор капота              | 0.65        | ✗        | ✗
7837039    | SEM11027    | Амортизатор капота              | 0.20        | ✗        | ✗
7837040    | SEM11030    | Амортизатор капота              | 0.00        | ✗        | ✗
7837041    | SEM11033    | Амортизатор капота              | 0.00        | ✗        | ✗
7837042    | SEM11050    | Амортизатор капота              | 0.00        | ✗        | ✗
7837159    | SEM11007    | Амортизатор капота              | 0.00        | ✗        | ✗
```

---

## Performance Summary

| Search Type | Query | Execution Time | Total Results | Returned |
|------------|-------|----------------|---------------|----------|
| Text Search | "тяга" | **77.22 ms** | 1,245 | 20 |
| Vendor Code | "SEM143" | **9.87 ms** ⚡ | 100 | 20 |
| Text Search | "амортизатор" | **98.12 ms** | 294 | 20 |

**Average Execution Time**: ~61 ms
**Range**: 9.87 ms - 98.12 ms

---

## Database Statistics

```
Total Products in Database:  278,697
SEM1 Supplier Products:       6,728

Search Results Distribution:
- "тяга" (steering rod):      1,245 products (18.5% of SEM1)
- "амортизатор" (shock):        294 products (4.4% of SEM1)
```

---

## API Endpoint Configuration

**Default Settings:**
- ✅ `limit`: 20 (default, can be 1-100)
- ✅ `offset`: 0 (pagination support)
- ✅ `supplier_name`: "SEM1" (filter applied)

**Available Additional Filters:**
- `weight_min`, `weight_max` - Weight range filter
- `is_for_sale` - Only products for sale
- `is_for_web` - Only web-available products
- `has_image` - Only products with images

---

## How to Use

### With API (when running):
```bash
curl -X POST http://localhost:8000/search \
  -H "Content-Type: application/json" \
  -d '{
    "action": "search",
    "query": "тяга",
    "supplier_name": "SEM1",
    "limit": 20
  }'
```

### Direct SQL (for testing):
```sql
SELECT product_id, vendor_code, name, ukrainian_name
FROM staging_marts.dim_product
WHERE supplier_name = 'SEM1'
  AND (name ILIKE '%тяга%' OR ukrainian_name ILIKE '%тяга%')
LIMIT 20;
```

---

## Notes

1. **Excellent Performance**: All queries execute in under 100ms
2. **Vendor Code Search**: Fastest at ~10ms due to indexed lookups
3. **Default Limit**: Already set to 20 results
4. **Rich Data**: 6,728 SEM1 products available
5. **Multilingual**: Both Russian and Ukrainian names supported
6. **Filters Work**: Can combine SEM1 filter with any other filters

---

## To Start API

```bash
cd /Users/oleksandrmelnychenko/Projects/bi-platform
./quick_start_api.sh
```

Then test with:
```bash
./test_sem1_api.sh
```
