# Complete Database Schema Analysis

**Database**: ConcordDb (SQL Server)
**Source**: `~/Desktop/Cord/Db.rtf`
**Analysis Date**: 2025-10-18
**Total Tables**: **313 tables**

## Executive Summary

This document provides a comprehensive analysis of the ConcordDb database schema, revealing the full scope of the database beyond what's currently captured in our CDC pipeline.

### Key Findings

1. **Database Size**: 313 tables (not ~200 as initially estimated)
2. **Product Table**: 54 columns (currently capturing only 19 = **35% coverage**)
3. **Product Ecosystem**: 30 related tables for Product management
4. **Multilingual Support**: Extensive PL (Polish) and UA (Ukrainian) fields
5. **Search Optimization**: Dedicated search fields with synonyms support
6. **Source System Tracking**: Integration with AMG and Fenix legacy systems

## Product Table - Complete Analysis

### Current vs. Full Schema

| Metric | Current CDC | Full Schema | Gap |
|--------|-------------|-------------|-----|
| **Columns Captured** | 19 columns | 54 columns | **35 missing (65%)** |
| **Multilingual Fields** | 0 | 12 fields | **100% missing** |
| **Search Fields** | 0 | 12 fields | **100% missing** |
| **Source Tracking** | 0 | 6 fields | **100% missing** |
| **Business Flags** | 1 (IsActive) | 6 flags | **83% missing** |

### Complete Product Table Schema (54 columns)

#### Core Identity (5 columns)
- `ID` - bigint identity, primary key
- `NetUID` - uniqueidentifier, globally unique identifier
- `Created` - datetime2, creation timestamp
- `Updated` - datetime2, last update timestamp
- `Deleted` - bit, soft delete flag

#### Basic Product Information (10 columns) ✅ **Currently Captured**
- `Name` - nvarchar(120), product name
- `VendorCode` - nvarchar(40), vendor/SKU code
- `Description` - nvarchar(2000), product description
- `Size` - nvarchar(100), dimensions/size
- `Weight` - float, product weight
- `Volume` - nvarchar(max), volume specification
- `Image` - nvarchar(max), image URL/path
- `MainOriginalNumber` - nvarchar(80), main OEM number
- `MeasureUnitID` - bigint, FK to MeasureUnit
- `[Top]` - nvarchar(3), top product indicator

#### Multilingual Content (8 columns) ❌ **MISSING**
- `NamePL` - nvarchar(120), Polish product name
- `NameUA` - nvarchar(120), Ukrainian product name
- `DescriptionPL` - nvarchar(2000), Polish description
- `DescriptionUA` - nvarchar(2000), Ukrainian description
- `NotesPL` - nvarchar(2000), Polish notes
- `NotesUA` - nvarchar(2000), Ukrainian notes
- `SynonymsPL` - nvarchar(2000), Polish synonyms
- `SynonymsUA` - nvarchar(2000), Ukrainian synonyms

#### Search Optimization (10 columns) ❌ **MISSING**
- `SearchName` - nvarchar(120), searchable name (normalized)
- `SearchNamePL` - nvarchar(120), searchable Polish name
- `SearchNameUA` - nvarchar(120), searchable Ukrainian name
- `SearchDescription` - nvarchar(2000), searchable description
- `SearchDescriptionPL` - nvarchar(2000), searchable Polish description
- `SearchDescriptionUA` - nvarchar(2000), searchable Ukrainian description
- `SearchSize` - nvarchar(100), searchable size
- `SearchVendorCode` - nvarchar(40), searchable vendor code
- `SearchSynonymsPL` - nvarchar(2000), searchable Polish synonyms
- `SearchSynonymsUA` - nvarchar(2000), searchable Ukrainian synonyms

#### Business Flags (6 columns) ❌ **5 MISSING**
- `IsActive` - bit ✅ **Currently captured**
- `HasAnalogue` - bit ❌ Has alternative products
- `HasImage` - bit ❌ Has product images
- `IsForSale` - bit ❌ Available for sale
- `IsForWeb` - bit ❌ Display on website
- `IsForZeroSale` - bit ❌ Allow zero-price sale
- `HasComponent` - bit ❌ Has component products

#### Specifications & Standards (5 columns) ❌ **MISSING**
- `UCGFEA` - nvarchar(max), customs classification code
- `Standard` - nvarchar(max), product standard
- `OrderStandard` - nvarchar(max), ordering standard
- `PackingStandard` - nvarchar(max), packing standard

#### Source System Integration (6 columns) ❌ **MISSING**
- `SourceAmgID` - varbinary(16), AMG system identifier
- `SourceFenixID` - varbinary(16), Fenix system identifier
- `ParentAmgID` - varbinary(16), AMG parent product ID
- `ParentFenixID` - varbinary(16), Fenix parent product ID
- `SourceAmgCode` - bigint, AMG numeric code
- `SourceFenixCode` - bigint, Fenix numeric code

## Product Ecosystem - 30 Related Tables

### Core Product Relationships (10 tables)

1. **ProductCategory** - Product categorization
2. **ProductGroup** - Product grouping
3. **ProductSubGroup** - Sub-grouping hierarchy
4. **ProductProductGroup** - Many-to-many group assignment
5. **MeasureUnit** - Units of measurement (FK from Product)
6. **ProductCarBrand** - Car brand associations
7. **ProductSet** - Product sets/kits
8. **ProductAnalogue** - Alternative/substitute products
9. **ProductOriginalNumber** - OEM part numbers
10. **ProductSpecification** - Technical specifications

### Inventory & Availability (8 tables)

11. **ProductAvailability** - Stock availability
12. **ProductAvailabilityCartLimits** - Shopping cart limits
13. **ProductLocation** - Warehouse locations
14. **ProductLocationHistory** - Location change history
15. **ProductPlacement** - Physical placement
16. **ProductPlacementHistory** - Placement history
17. **ProductPlacementMovement** - Movement tracking
18. **ProductPlacementStorage** - Storage assignments

### Financial & Pricing (6 tables)

19. **ProductPricing** - Pricing information
20. **ProductGroupDiscount** - Group-based discounts
21. **ProductCapitalization** - Capitalization records
22. **ProductCapitalizationItem** - Capitalization items
23. **ProductWriteOffRule** - Write-off rules
24. **ProductReservation** - Reserved inventory

### Operations (6 tables)

25. **ProductIncome** - Incoming shipments
26. **ProductIncomeItem** - Income line items
27. **ProductTransfer** - Transfers between locations
28. **ProductTransferItem** - Transfer line items
29. **ProductImage** - Product images
30. **ProductSlug** - URL slugs for web

## Other Core Entities

### Sales & Orders (8+ tables)
- `Order` - Customer orders
- `OrderItem` - Order line items
- `Sale` - Completed sales
- `SaleItem` - Sale line items
- `SaleNumber` - Sale numbering
- `SaleInvoiceDocument` - Invoice documents
- `SaleInvoiceNumber` - Invoice numbering
- `BaseLifeCycleStatus` - Sale lifecycle stages
- `BaseSalePaymentStatus` - Payment status tracking

### Clients & Customers (15+ tables)
- `Client` - Customer master data
- `ClientType` - Client type classification
- `ClientTypeRole` - Client roles
- `ClientAgreement` - Customer agreements
- `ClientBankDetails` - Banking information
- `ClientBankDetailAccountNumber` - Account numbers
- `ClientBankDetailIbanNo` - IBAN numbers
- `DeliveryRecipient` - Delivery contacts
- `DeliveryRecipientAddress` - Delivery addresses
- `RegionCode` - Regional codes
- `Region` - Regions
- `Country` - Countries
- `RetailClient` - Retail customers
- `ClientShoppingCart` - Shopping carts
- `Transporter` - Shipping companies

### Inventory & Warehouse (10+ tables)
- `Storage` - Warehouses/storage facilities
- `Workplace` - Work locations
- `MisplacedSale` - Misplaced items
- `TaxFreePackList` - Tax-free packing
- `Sad` - Customs declarations
- `CustomersOwnTtn` - Customer TTN documents
- `Consignment` - Shipment consignments
- `ConsignmentItem` - Consignment items
- `ConsignmentNoteSetting` - Consignment settings

### Accounting & Finance (20+ tables)
- `Currency` - Currency master
- `CrossExchangeRate` - Exchange rates
- `CurrencyTrader` - Currency traders
- `CurrencyTraderExchangeRate` - Trader rates
- `AccountingDocumentName` - Document names
- `AccountingOperationName` - Operation names
- `ActProvidingService` - Service acts
- `ActReconciliation` - Reconciliation acts
- `PaymentOrder` - Payment orders
- `AssignedPaymentOrder` - Assigned payments
- `Bank` - Bank information
- `Debt` - Debt tracking
- `AdvancePayment` - Advance payments

### System & Configuration (30+ tables)
- `User` - System users
- `DashboardNode` - Dashboard navigation
- `DashboardNodeModule` - Dashboard modules
- `AuditEntity` - Audit trail entities
- `AuditEntityProperty` - Audit properties
- `EcommerceContactInfo` - E-commerce contacts
- `AllegroCategory` - Allegro marketplace categories
- `AllegroProductReservation` - Allegro reservations
- Various translation tables for multilingual support

## Data Profiling Priorities

Based on the schema analysis, these tables should be profiled first:

### Tier 1 - Critical (High volume, high business value)
1. **Product** (61,443 rows confirmed) - Core entity
2. **Order** - Order management
3. **OrderItem** - Order details
4. **Sale** - Sales transactions
5. **Client** - Customer data
6. **ProductPricing** - Pricing data
7. **ProductAvailability** - Inventory levels

### Tier 2 - Important (Supporting entities)
8. **ProductCategory** - Product organization
9. **ProductImage** - Product visuals
10. **ProductGroup** - Product grouping
11. **ClientAgreement** - Customer contracts
12. **ProductAnalogue** - Product alternatives
13. **ProductSpecification** - Technical specs
14. **ProductOriginalNumber** - OEM numbers

### Tier 3 - Operational (Lower volume, transactional)
15. **ProductIncome** - Incoming inventory
16. **ProductTransfer** - Inventory movements
17. **ProductReservation** - Reserved stock
18. **ProductLocation** - Warehouse locations

## Implementation Priorities

### Phase 1: Expand Product CDC (Immediate)
**Goal**: Increase Product table coverage from 35% to 100%

**Tasks**:
1. Update `stg_product.sql` to extract all 54 columns from JSONB CDC payload
2. Add all multilingual fields (8 columns)
3. Add all search optimization fields (10 columns)
4. Add source system tracking fields (6 columns)
5. Add missing business flags (5 columns)
6. Add specifications/standards fields (5 columns)
7. Update schema documentation and tests

**Impact**: Full Product data for embeddings, search, and analytics

### Phase 2: Add Core Product Relations (Week 1)
**Goal**: Capture 10 most critical Product-related tables

**Tables**:
1. ProductCategory
2. ProductPricing
3. ProductImage
4. ProductAvailability
5. ProductGroup
6. ProductAnalogue
7. ProductSpecification
8. ProductOriginalNumber
9. MeasureUnit
10. ProductCarBrand

**Impact**: Complete product context for analytics and ML

### Phase 3: Add Order & Sale Entities (Week 2)
**Goal**: Enable transactional analytics

**Tables**:
1. Order
2. OrderItem
3. Sale
4. Client
5. ClientAgreement
6. BaseLifeCycleStatus
7. BaseSalePaymentStatus

**Impact**: Full customer journey and sales analytics

### Phase 4: Complete Inventory & Warehouse (Week 3)
**Goal**: Operational visibility

**Tables**:
- ProductLocation
- ProductAvailability
- ProductPlacement
- Storage
- ProductTransfer
- ProductIncome

**Impact**: Real-time inventory and warehouse analytics

## Data Quality Considerations

### Multilingual Data
- **Languages**: Polish (PL) and Ukrainian (UA)
- **Coverage**: Name, Description, Notes, Synonyms
- **Search**: Dedicated search fields for each language
- **Strategy**: Should embeddings generate separate vectors per language, or combined?

### Search Optimization
- **Purpose**: Normalized fields for fast full-text search
- **Coverage**: Name, Description, Size, VendorCode, Synonyms
- **Indexes**: Likely have full-text indexes on Search* fields in SQL Server
- **Use Case**: May want to use Search* fields for embeddings instead of raw fields

### Source System Integration
- **Systems**: AMG and Fenix (legacy systems)
- **IDs**: varbinary(16) identifiers + bigint codes
- **Purpose**: Data lineage and system integration
- **Use Case**: Track data provenance and enable cross-system lookups

## Next Steps

1. ✅ **Schema Extraction** - Complete (313 tables, 11,478 lines)
2. ✅ **Product Analysis** - Complete (54 columns identified, 30 related tables)
3. ⏳ **Copy to Docs** - In progress (complete_schema.sql created)
4. 🔜 **Data Dictionary** - Generate comprehensive documentation
5. 🔜 **Expand stg_product.sql** - Add missing 35 columns
6. 🔜 **Data Profiling** - Query actual row counts and distributions
7. 🔜 **Update Embeddings** - Include all textual fields

## Files Created

- `docs/complete_schema.sql` - Full DDL for all 313 tables (11,478 lines)
- `docs/SCHEMA_ANALYSIS.md` - This comprehensive analysis document
- `/tmp/all_tables.txt` - List of all 313 table names (sorted)

## References

- Original schema source: `~/Desktop/Cord/Db.rtf`
- Current staging model: `dbt/models/staging/product/stg_product.sql` (19 columns)
- Current data dictionary: `docs/data_dictionary.md` (5 tables, partial)
- Pipeline status: `docs/PIPELINE_STATUS.md`
- Embeddings status: `docs/EMBEDDINGS_COMPLETE.md`
