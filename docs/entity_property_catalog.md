# Target Entity Property Catalog

Compiled from `Desktop/Cord/Db.rtf`. Use this as the canonical reference when building features, embeddings, and forecasting pipelines.

## Product (`Product`, `ProductAvailability`, related)
- Core attributes (`Db.rtf:1518`):
  - Identifiers: `ID`, `NetUID`, source codes (`SourceAmgID`, `SourceFenixID`, `Parent*`, `*Code`)
  - Naming & descriptions: `Name`, `Description`, multilingual variants (`NamePL`, `NameUA`, `DescriptionPL`, `DescriptionUA`), search fields (`SearchName*`, `SearchDescription*`, `Synonyms*`, `Notes*`)
  - Commerce flags: `IsForSale`, `IsForWeb`, `IsForZeroSale`, `HasAnalogue`, `HasImage`, `HasComponent`
  - Logistics: `MeasureUnitID`, `Weight`, `Volume`, `Size`, `SearchSize`, `OrderStandard`, `PackingStandard`, `Standard`
  - Catalog metadata: `MainOriginalNumber`, `VendorCode`, `SearchVendorCode`, `[Top]`, customs code `UCGFEA`
  - Audit: `Created`, `Updated`, `Deleted`
- Related tables to surface in staging/feature views:
  - `ProductCategory`, `ProductGroup`, `ProductSubGroup`, `ProductSpecification`
  - Pricing & stock: `ProductPricing`, `ProductAvailability`, `ProductAvailabilityCartLimits`
  - Media: `ProductImage`
  - Cross-references: `ProductOriginalNumber`, `ProductAnalogue`

## Order & OrderItem (`Db.rtf:9612`)
- `Order`:
  - Channel/metadata: `OrderSource`, `OrderStatus`, `IsMerged`
  - Relationships: `ClientAgreementID`, `UserID`, `ClientShoppingCartID`
  - Audit: `Created`, `Updated`, `Deleted`, `NetUID`
- `OrderItem`:
  - Quantities & pricing: `Qty`, `OrderedQty`, `PricePerItem`, `PricePerItemWithoutVat`, `OneTimeDiscount`, `DiscountAmount`, `Vat`, `InvoiceDocumentQty`
  - Flags & statuses: `IsValidForCurrentSale`, `IsFromOffer`, `OfferProcessingStatus`, `IsFromReSale`, `IsClosed`, `IsFromShiftedItem`
  - Relationships: `OrderID`, `ProductID`, `ClientShoppingCartID`, `AssignedSpecificationID`, `StorageId`
  - Audit & user actions: `Created`, `Updated`, `UserId`, `OfferProcessingStatusChangedByID`, `DiscountUpdatedByID`
  - Logistics: `UnpackedQty`, `ReturnedQty`, `MisplacedSaleId`

## Sale (`Db.rtf:10121`)
- Commercial data: `SaleNumberID`, `BaseLifeCycleStatusID`, `BaseSalePaymentStatusID`, `ShipmentDate`, `CashOnDeliveryAmount`, `ShippingAmount` (local & EUR), `IsFullPayment`, `HasDocuments`
- Fulfillment: `DeliveryRecipientID`, `DeliveryRecipientAddressID`, `TransporterID`, `ShiftStatusID`, `WarehousesShipmentId`, `TTN`, `CustomersOwnTtnID`
- Finance & compliance: `SaleInvoiceDocumentID`, `SaleInvoiceNumberID`, `TaxFreePackListID`, `SadID`, `IsVatSale`
- Governance: `IsLocked`, `IsPaymentBillDownloaded`, `IsImported`, `IsPrintedPaymentInvoice`, `IsAcceptedToPacking`, `IsPrintedActProtocolEdit`
- Relationships: `ClientAgreementID`, `OrderID`, `UserID`, `RetailClientId`, `WorkplaceID`, `MisplacedSaleId`
- Audit: `Created`, `Updated`, `Deleted`, `NetUID`, `BillDownloadDate`, `ChangedToInvoice*`

## Client (`Db.rtf:3435`)
- Identity: `Name`, `FullName`, `FirstName`, `LastName`, `MiddleName`, `ClientNumber`, `SupplierCode`, `TIN`, `USREOU`, `SROI`
- Contact details: `EmailAddress`, `MobileNumber`, `SMSNumber`, `FaxNumber`, `ICQ`, `ActualAddress`, `DeliveryAddress`, `LegalAddress`, `Brand`, `Manager`
- Classification flags: `IsIndividual`, `IsActive`, `IsSubClient`, `IsBlocked`, `IsTradePoint`, `IsForRetail`, `IsWorkplace`, `IsTemporaryClient`, `IsNotResident`, `IsFromECommerce`
- Logistics & finance: `CountryID`, `RegionID`, `RegionCodeID`, `TermsOfDeliveryID`, `PackingMarkingID`, `PackingMarkingPaymentID`, `ClientBankDetailsID`, `IncotermsElse`, `IsPayForDelivery`, `IsIncotermsElse`
- Hierarchies & ownership: `MainManagerID`, `MainClientID`
- Audit & source lineage: `NetUID`, `SourceAmg*`, `SourceFenix*`, `Created`, `Updated`, `Deleted`
- E-commerce config: `ClearCartAfterDays`, `OrderExpireDays`

## Usage Guidance
- **Embedding/Search:** Use complete textual attributes (names, descriptions, synonyms, notes, flags with labels) when building embeddings. Enrich with related categorical tables via joins in staging models.
- **Forecasting:** Leverage order/sale quantities, status transitions, pricing, payment, transporter, and lifecycle fields. Include client segment flags and product properties as regressors.
- **Recommendations:** Combine purchase history (OrderItem/Sale), client attributes, and product metadata. Include availability/pricing to filter suggestible items.
- **Reports:** Surface life-cycle statuses, financial flags, logistic tracking, and audit timestamps for dashboards and AI narrative generation.

## Next Steps
- Expand `stg_product`, `stg_order_item`, `stg_sale`, `stg_client` dbt models to expose all columns listed above plus joined metadata (group/category names, transporter names, etc.).
- Ensure ingestion flow captures entire Debezium payload so no attribute is lost in raw/bronze layers.
- Update feature store definitions to reference the enriched staging views.
