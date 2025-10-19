# Complete Data Dictionary

**Total Tables**: 311
**Source**: `docs/complete_schema.sql`

## Table of Contents

- [Product](#product)
- [ProductCategory](#productcategory)
- [ProductGroup](#productgroup)
- [ProductSubGroup](#productsubgroup)
- [ProductPricing](#productpricing)
- [ProductImage](#productimage)
- [ProductAvailability](#productavailability)
- [ProductAnalogue](#productanalogue)
- [ProductSpecification](#productspecification)
- [ProductOriginalNumber](#productoriginalnumber)
- [OrderItem](#orderitem)
- [Sale](#sale)
- [Client](#client)
- [ClientAgreement](#clientagreement)
- [ClientType](#clienttype)
- [MeasureUnit](#measureunit)
- [Currency](#currency)
- [Country](#country)
- [Region](#region)
- [AccountingDocumentName](#accountingdocumentname)
- [AccountingOperationName](#accountingoperationname)
- [ActProvidingService](#actprovidingservice)
- [ActProvidingServiceDocument](#actprovidingservicedocument)
- [ActReconciliation](#actreconciliation)
- [ActReconciliationItem](#actreconciliationitem)
- [AdvancePayment](#advancepayment)
- [Agreement](#agreement)
- [AgreementType](#agreementtype)
- [AgreementTypeCivilCode](#agreementtypecivilcode)
- [AgreementTypeTranslation](#agreementtypetranslation)
- [AllegroCategory](#allegrocategory)
- [AllegroProductReservation](#allegroproductreservation)
- [AssignedPaymentOrder](#assignedpaymentorder)
- [AuditEntity](#auditentity)
- [AuditEntityProperty](#auditentityproperty)
- [AuditEntityPropertyNameTranslation](#auditentitypropertynametranslation)
- [Bank](#bank)
- [BaseLifeCycleStatus](#baselifecyclestatus)
- [BaseSalePaymentStatus](#basesalepaymentstatus)
- [BillOfLadingDocument](#billofladingdocument)
- [BillOfLadingService](#billofladingservice)
- [CalculationType](#calculationtype)
- [CalculationTypeTranslation](#calculationtypetranslation)
- [CarBrand](#carbrand)
- [Category](#category)
- [ChartMonth](#chartmonth)
- [ChartMonthTranslation](#chartmonthtranslation)
- [ClientBalanceMovement](#clientbalancemovement)
- [ClientBankDetailAccountNumber](#clientbankdetailaccountnumber)
- [ClientBankDetailIbanNo](#clientbankdetailibanno)
- [ClientBankDetails](#clientbankdetails)
- [ClientContractDocument](#clientcontractdocument)
- [ClientGroup](#clientgroup)
- [ClientInDebt](#clientindebt)
- [ClientInRole](#clientinrole)
- [ClientPerfectClient](#clientperfectclient)
- [ClientRegistrationTask](#clientregistrationtask)
- [ClientShoppingCart](#clientshoppingcart)
- [ClientSubClient](#clientsubclient)
- [ClientTypeRole](#clienttyperole)
- [ClientTypeRoleTranslation](#clienttyperoletranslation)
- [ClientTypeTranslation](#clienttypetranslation)
- [ClientUserProfile](#clientuserprofile)
- [ClientWorkplace](#clientworkplace)
- [ColumnItem](#columnitem)
- [ColumnItemTranslation](#columnitemtranslation)
- [CompanyCar](#companycar)
- [CompanyCarFueling](#companycarfueling)
- [CompanyCarRoadList](#companycarroadlist)
- [CompanyCarRoadListDriver](#companycarroadlistdriver)
- [Consignment](#consignment)
- [ConsignmentItem](#consignmentitem)
- [ConsignmentItemMovement](#consignmentitemmovement)
- [ConsignmentItemMovementTypeName](#consignmentitemmovementtypename)
- [ConsignmentNoteSetting](#consignmentnotesetting)
- [ConsumableProduct](#consumableproduct)
- [ConsumableProductCategory](#consumableproductcategory)
- [ConsumableProductCategoryTranslation](#consumableproductcategorytranslation)
- [ConsumableProductTranslation](#consumableproducttranslation)
- [ConsumablesOrder](#consumablesorder)
- [ConsumablesOrderDocument](#consumablesorderdocument)
- [ConsumablesOrderItem](#consumablesorderitem)
- [ConsumablesStorage](#consumablesstorage)
- [ContainerService](#containerservice)
- [CountSaleMessage](#countsalemessage)
- [CreditNoteDocument](#creditnotedocument)
- [CrossExchangeRate](#crossexchangerate)
- [CrossExchangeRateHistory](#crossexchangeratehistory)
- [CurrencyTrader](#currencytrader)
- [CurrencyTraderExchangeRate](#currencytraderexchangerate)
- [CurrencyTranslation](#currencytranslation)
- [CustomAgencyService](#customagencyservice)
- [CustomService](#customservice)
- [CustomersOwnTtn](#customersownttn)
- [DashboardNode](#dashboardnode)
- [DashboardNodeModule](#dashboardnodemodule)
- [DataSyncOperation](#datasyncoperation)
- [Debt](#debt)
- [DeliveryExpense](#deliveryexpense)
- [DeliveryProductProtocol](#deliveryproductprotocol)
- [DeliveryProductProtocolDocument](#deliveryproductprotocoldocument)
- [DeliveryProductProtocolNumber](#deliveryproductprotocolnumber)
- [DeliveryRecipient](#deliveryrecipient)
- [DeliveryRecipientAddress](#deliveryrecipientaddress)
- [DepreciatedConsumableOrder](#depreciatedconsumableorder)
- [DepreciatedConsumableOrderItem](#depreciatedconsumableorderitem)
- [DepreciatedOrder](#depreciatedorder)
- [DepreciatedOrderItem](#depreciatedorderitem)
- [DocumentMonth](#documentmonth)
- [DynamicProductPlacement](#dynamicproductplacement)
- [DynamicProductPlacementColumn](#dynamicproductplacementcolumn)
- [DynamicProductPlacementRow](#dynamicproductplacementrow)
- [EcommerceContactInfo](#ecommercecontactinfo)
- [EcommerceContacts](#ecommercecontacts)
- [EcommerceDefaultPricing](#ecommercedefaultpricing)
- [EcommercePage](#ecommercepage)
- [EcommerceRegion](#ecommerceregion)
- [ExchangeRate](#exchangerate)
- [ExchangeRateHistory](#exchangeratehistory)
- [ExpiredBillUserNotification](#expiredbillusernotification)
- [FilterItem](#filteritem)
- [FilterItemTranslation](#filteritemtranslation)
- [FilterOperationItem](#filteroperationitem)
- [FilterOperationItemTranslation](#filteroperationitemtranslation)
- [GovCrossExchangeRate](#govcrossexchangerate)
- [GovCrossExchangeRateHistory](#govcrossexchangeratehistory)
- [GovExchangeRate](#govexchangerate)
- [GovExchangeRateHistory](#govexchangeratehistory)
- [HistoryInvoiceEdit](#historyinvoiceedit)
- [IncomePaymentOrder](#incomepaymentorder)
- [IncomePaymentOrderSale](#incomepaymentordersale)
- [Incoterm](#incoterm)
- [InvoiceDocument](#invoicedocument)
- [MeasureUnitTranslation](#measureunittranslation)
- [MergedService](#mergedservice)
- [MisplacedSale](#misplacedsale)
- [OrderItemBaseShiftStatus](#orderitembaseshiftstatus)
- [OrderItemMerged](#orderitemmerged)
- [OrderItemMovement](#orderitemmovement)
- [OrderPackage](#orderpackage)
- [OrderPackageItem](#orderpackageitem)
- [OrderPackageUser](#orderpackageuser)
- [OrderProductSpecification](#orderproductspecification)
- [Organization](#organization)
- [OrganizationClient](#organizationclient)
- [OrganizationClientAgreement](#organizationclientagreement)
- [OrganizationTranslation](#organizationtranslation)
- [OriginalNumber](#originalnumber)
- [OutcomePaymentOrder](#outcomepaymentorder)
- [OutcomePaymentOrderConsumablesOrder](#outcomepaymentorderconsumablesorder)
- [OutcomePaymentOrderSupplyPaymentTask](#outcomepaymentordersupplypaymenttask)
- [PackingList](#packinglist)
- [PackingListDocument](#packinglistdocument)
- [PackingListPackage](#packinglistpackage)
- [PackingListPackageOrderItem](#packinglistpackageorderitem)
- [PackingListPackageOrderItemSupplyService](#packinglistpackageorderitemsupplyservice)
- [PackingMarking](#packingmarking)
- [PackingMarkingPayment](#packingmarkingpayment)
- [PaymentCostMovement](#paymentcostmovement)
- [PaymentCostMovementOperation](#paymentcostmovementoperation)
- [PaymentCostMovementTranslation](#paymentcostmovementtranslation)
- [PaymentCurrencyRegister](#paymentcurrencyregister)
- [PaymentDeliveryDocument](#paymentdeliverydocument)
- [PaymentMovement](#paymentmovement)
- [PaymentMovementOperation](#paymentmovementoperation)
- [PaymentMovementTranslation](#paymentmovementtranslation)
- [PaymentRegister](#paymentregister)
- [PaymentRegisterCurrencyExchange](#paymentregistercurrencyexchange)
- [PaymentRegisterTransfer](#paymentregistertransfer)
- [PerfectClient](#perfectclient)
- [PerfectClientTranslation](#perfectclienttranslation)
- [PerfectClientValue](#perfectclientvalue)
- [PerfectClientValueTranslation](#perfectclientvaluetranslation)
- [Permission](#permission)
- [PlaneDeliveryService](#planedeliveryservice)
- [PortCustomAgencyService](#portcustomagencyservice)
- [PortWorkService](#portworkservice)
- [PreOrder](#preorder)
- [PriceType](#pricetype)
- [PriceTypeTranslation](#pricetypetranslation)
- [Pricing](#pricing)
- [PricingProductGroupDiscount](#pricingproductgroupdiscount)
- [PricingTranslation](#pricingtranslation)
- [ProFormDocument](#proformdocument)
- [ProductAvailabilityCartLimits](#productavailabilitycartlimits)
- [ProductCapitalization](#productcapitalization)
- [ProductCapitalizationItem](#productcapitalizationitem)
- [ProductCarBrand](#productcarbrand)
- [ProductGroupDiscount](#productgroupdiscount)
- [ProductIncome](#productincome)
- [ProductIncomeItem](#productincomeitem)
- [ProductLocation](#productlocation)
- [ProductLocationHistory](#productlocationhistory)
- [ProductPlacement](#productplacement)
- [ProductPlacementHistory](#productplacementhistory)
- [ProductPlacementMovement](#productplacementmovement)
- [ProductPlacementStorage](#productplacementstorage)
- [ProductProductGroup](#productproductgroup)
- [ProductReservation](#productreservation)
- [ProductSet](#productset)
- [ProductSlug](#productslug)
- [ProductTransfer](#producttransfer)
- [ProductTransferItem](#producttransferitem)
- [ProductWriteOffRule](#productwriteoffrule)
- [ProviderPricing](#providerpricing)
- [ReSale](#resale)
- [ReSaleAvailability](#resaleavailability)
- [ReSaleItem](#resaleitem)
- [RegionCode](#regioncode)
- [ResidenceCard](#residencecard)
- [ResponsibilityDeliveryProtocol](#responsibilitydeliveryprotocol)
- [RetailClient](#retailclient)
- [RetailClientPaymentImage](#retailclientpaymentimage)
- [RetailClientPaymentImageItem](#retailclientpaymentimageitem)
- [RetailPaymentStatus](#retailpaymentstatus)
- [RetailPaymentTypeTranslate](#retailpaymenttypetranslate)
- [RolePermission](#rolepermission)
- [Sad](#sad)
- [SadDocument](#saddocument)
- [SadItem](#saditem)
- [SadPallet](#sadpallet)
- [SadPalletItem](#sadpalletitem)
- [SadPalletType](#sadpallettype)
- [SaleBaseShiftStatus](#salebaseshiftstatus)
- [SaleExchangeRate](#saleexchangerate)
- [SaleFutureReservation](#salefuturereservation)
- [SaleInvoiceDocument](#saleinvoicedocument)
- [SaleInvoiceNumber](#saleinvoicenumber)
- [SaleMerged](#salemerged)
- [SaleMessageNumerator](#salemessagenumerator)
- [SaleNumber](#salenumber)
- [SaleReturn](#salereturn)
- [SaleReturnItem](#salereturnitem)
- [SaleReturnItemProductPlacement](#salereturnitemproductplacement)
- [SaleReturnItemStatusName](#salereturnitemstatusname)
- [SeoPage](#seopage)
- [ServiceDetailItem](#servicedetailitem)
- [ServiceDetailItemKey](#servicedetailitemkey)
- [ServicePayer](#servicepayer)
- [ShipmentList](#shipmentlist)
- [ShipmentListItem](#shipmentlistitem)
- [Statham](#statham)
- [StathamCar](#stathamcar)
- [StathamPassport](#stathampassport)
- [Storage](#storage)
- [SupplyDeliveryDocument](#supplydeliverydocument)
- [SupplyInformationDeliveryProtocol](#supplyinformationdeliveryprotocol)
- [SupplyInformationDeliveryProtocolKey](#supplyinformationdeliveryprotocolkey)
- [SupplyInformationDeliveryProtocolKeyTranslation](#supplyinformationdeliveryprotocolkeytranslation)
- [SupplyInformationTask](#supplyinformationtask)
- [SupplyInvoice](#supplyinvoice)
- [SupplyInvoiceBillOfLadingService](#supplyinvoicebillofladingservice)
- [SupplyInvoiceDeliveryDocument](#supplyinvoicedeliverydocument)
- [SupplyInvoiceMergedService](#supplyinvoicemergedservice)
- [SupplyInvoiceOrderItem](#supplyinvoiceorderitem)
- [SupplyOrder](#supplyorder)
- [SupplyOrderContainerService](#supplyordercontainerservice)
- [SupplyOrderDeliveryDocument](#supplyorderdeliverydocument)
- [SupplyOrderItem](#supplyorderitem)
- [SupplyOrderNumber](#supplyordernumber)
- [SupplyOrderPaymentDeliveryProtocol](#supplyorderpaymentdeliveryprotocol)
- [SupplyOrderPaymentDeliveryProtocolKey](#supplyorderpaymentdeliveryprotocolkey)
- [SupplyOrderPolandPaymentDeliveryProtocol](#supplyorderpolandpaymentdeliveryprotocol)
- [SupplyOrderUkraine](#supplyorderukraine)
- [SupplyOrderUkraineCartItem](#supplyorderukrainecartitem)
- [SupplyOrderUkraineCartItemReservation](#supplyorderukrainecartitemreservation)
- [SupplyOrderUkraineCartItemReservationProductPlacement](#supplyorderukrainecartitemreservationproductplacement)
- [SupplyOrderUkraineDocument](#supplyorderukrainedocument)
- [SupplyOrderUkraineItem](#supplyorderukraineitem)
- [SupplyOrderUkrainePaymentDeliveryProtocol](#supplyorderukrainepaymentdeliveryprotocol)
- [SupplyOrderUkrainePaymentDeliveryProtocolKey](#supplyorderukrainepaymentdeliveryprotocolkey)
- [SupplyOrderVehicleService](#supplyordervehicleservice)
- [SupplyOrganization](#supplyorganization)
- [SupplyOrganizationAgreement](#supplyorganizationagreement)
- [SupplyOrganizationDocument](#supplyorganizationdocument)
- [SupplyPaymentTask](#supplypaymenttask)
- [SupplyPaymentTaskDocument](#supplypaymenttaskdocument)
- [SupplyProForm](#supplyproform)
- [SupplyReturn](#supplyreturn)
- [SupplyReturnItem](#supplyreturnitem)
- [SupplyServiceAccountDocument](#supplyserviceaccountdocument)
- [SupplyServiceNumber](#supplyservicenumber)
- [SupportVideo](#supportvideo)
- [TaxAccountingScheme](#taxaccountingscheme)
- [TaxFree](#taxfree)
- [TaxFreeDocument](#taxfreedocument)
- [TaxFreeItem](#taxfreeitem)
- [TaxFreePackList](#taxfreepacklist)
- [TaxFreePackListOrderItem](#taxfreepacklistorderitem)
- [TaxInspection](#taxinspection)
- [TermsOfDelivery](#termsofdelivery)
- [TransportationService](#transportationservice)
- [Transporter](#transporter)
- [TransporterType](#transportertype)
- [TransporterTypeTranslation](#transportertypetranslation)
- [UpdateDataCarrier](#updatedatacarrier)
- [UserDetails](#userdetails)
- [UserRole](#userrole)
- [UserRoleDashboardNode](#userroledashboardnode)
- [UserRoleTranslation](#userroletranslation)
- [UserScreenResolution](#userscreenresolution)
- [VatRate](#vatrate)
- [VehicleDeliveryService](#vehicledeliveryservice)
- [VehicleService](#vehicleservice)
- [WarehousesShipment](#warehousesshipment)
- [WorkPermit](#workpermit)
- [WorkingContract](#workingcontract)
- [Workplace](#workplace)
- [WorkplaceClientAgreement](#workplaceclientagreement)
- [__EFMigrationsHistory](#__efmigrationshistory)
- [sysdiagrams](#sysdiagrams)

---

## Product

**Columns**: 52 | **Foreign Keys**: 0 | **Indexes**: 8

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(2000) |  |
| `HasAnalogue` | bit | not null |
| `HasImage` | bit | not null |
| `IsForSale` | bit | not null |
| `IsForWeb` | bit | not null |
| `IsForZeroSale` | bit | not null |
| `MainOriginalNumber` | nvarchar(80) |  |
| `MeasureUnitID` | bigint | not null |
| `references` | MeasureUnit |  |
| `Name` | nvarchar(120) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderStandard` | nvarchar(max) |  |
| `PackingStandard` | nvarchar(max) |  |
| `Size` | nvarchar(100) |  |
| `UCGFEA` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `VendorCode` | nvarchar(40) |  |
| `Volume` | nvarchar(max) |  |
| `Weight` | float | not null |
| `HasComponent` | bit | default 0            not null |
| `Image` | nvarchar(max) |  |
| `Top` | nvarchar(3) |  |
| `DescriptionPL` | nvarchar(2000) |  |
| `DescriptionUA` | nvarchar(2000) |  |
| `NamePL` | nvarchar(120) |  |
| `NameUA` | nvarchar(120) |  |
| `SourceAmgID` | varbinary(16) |  |
| `SourceFenixID` | varbinary(16) |  |
| `SearchDescriptionPL` | nvarchar(2000) |  |
| `SearchNamePL` | nvarchar(120) |  |
| `NotesPL` | nvarchar(2000) |  |
| `NotesUA` | nvarchar(2000) |  |
| `SearchDescriptionUA` | nvarchar(2000) |  |
| `SearchNameUA` | nvarchar(120) |  |
| `SearchSize` | nvarchar(100) |  |
| `SearchVendorCode` | nvarchar(40) |  |
| `SearchDescription` | nvarchar(2000) |  |
| `SearchName` | nvarchar(120) |  |
| `SearchSynonymsPL` | nvarchar(2000) |  |
| `SearchSynonymsUA` | nvarchar(2000) |  |
| `SynonymsPL` | nvarchar(2000) |  |
| `SynonymsUA` | nvarchar(2000) |  |
| `Standard` | nvarchar(max) |  |
| `ParentAmgID` | varbinary(16) |  |
| `ParentFenixID` | varbinary(16) |  |
| `SourceAmgCode` | bigint |  |
| `SourceFenixCode` | bigint |  |

**Indexes**:

- `IX_Product_MeasureUnitID`
- `IX_Product_Description_Deleted`
- `IX_Product_MainOriginalNumber_Deleted`
- `IX_Product_Name_Deleted`
- `IX_Product_VendorCode_Deleted`
- `IX_Product_NetUID`
- `IX_Product_Deleted_SearchNamePL_SearchVendorCode`
- `IX_Product_Deleted_SearchNameUA_SearchVendorCode`

---

## ProductCategory

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CategoryID` | bigint | not null |
| `references` | Category |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProductCategory_CategoryID`
- `IX_ProductCategory_ProductID`

---

## ProductGroup

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `FullName` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `IsSubGroup` | bit | default 0            not null |
| `SourceFenixID` | varbinary(16) |  |
| `IsActive` | bit | default 0            not null |
| `SourceAmgID` | varbinary(16) |  |

---

## ProductSubGroup

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `RootProductGroupID` | bigint | not null |
| `references` | ProductGroup |  |
| `SubProductGroupID` | bigint | not null |
| `references` | ProductGroup |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProductSubGroup_RootProductGroupID`
- `IX_ProductSubGroup_SubProductGroupID`

---

## ProductPricing

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PricingID` | bigint | not null |
| `references` | Pricing |  |
| `on` | delete | cascade |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `Price` | money | default 0.0          not null |

**Indexes**:

- `IX_ProductPricing_PricingID`
- `IX_ProductPricing_ProductID`
- `IX_ProductPricing_Deleted_ProductID`
- `IX_ProductPricing_Deleted_PricingID`

---

## ProductImage

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `ImageUrl` | nvarchar(500) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Updated` | datetime2 | not null |
| `IsMainImage` | bit | default 0            not null |

**Indexes**:

- `IX_ProductImage_ProductID`

---

## ProductAvailability

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | float | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProductAvailability_ProductID`
- `IX_ProductAvailability_StorageID_Amount_ProductID_Deleted`
- `IX_ProductAvailability_Amount`
- `IX_ProductAvailability_ID_Deleted_ProductID`
- `IX_ProductAvailability_ID_Deleted_StorageID`
- `IX_ProductAvailability_Deleted_ProductID`

---

## ProductAnalogue

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AnalogueProductID` | bigint | not null |
| `references` | Product |  |
| `BaseProductID` | bigint | not null |
| `references` | Product |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProductAnalogue_AnalogueProductID`
- `IX_ProductAnalogue_BaseProductID`
- `IX_ProductAnalogue_Deleted_AnalogueProductID`
- `IX_ProductAnalogue_Deleted_BaseProductID`

---

## ProductSpecification

**Columns**: 20 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AddedByID` | bigint | not null |
| `references` | unknown | [User] |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `SpecificationCode` | nvarchar(100) |  |
| `Updated` | datetime2 | not null |
| `Name` | nvarchar(500) |  |
| `IsActive` | bit | default 0            not null |
| `DutyPercent` | money | default 0.0          not null |
| `Locale` | nvarchar(4) |  |
| `CustomsValue` | decimal(18, 2) | default 0.0          not null |
| `Duty` | decimal(18, 2) | default 0.0          not null |
| `VATPercent` | decimal(18, 2) | default 0.0          not null |
| `VATValue` | decimal(18, 2) | default 0.0          not null |

**Indexes**:

- `IX_ProductSpecification_AddedByID`
- `IX_ProductSpecification_ProductID`

---

## ProductOriginalNumber

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OriginalNumberID` | bigint | not null |
| `references` | OriginalNumber |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Updated` | datetime2 | not null |
| `IsMainOriginalNumber` | bit | default 0            not null |

**Indexes**:

- `IX_ProductOriginalNumber_OriginalNumberID`
- `IX_ProductOriginalNumber_ProductID`
- `IX_ProductOriginalNumber_Deleted_OriginalNumberID`
- `IX_ProductOriginalNumber_Deleted_ProductID`

---

## OrderItem

**Columns**: 46 | **Foreign Keys**: 0 | **Indexes**: 9

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `OrderID` | bigint |  |
| `references` | unknown | [Order] |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `Qty` | float | not null |
| `UserId` | bigint |  |
| `references` | unknown | [User] |
| `Comment` | nvarchar(450) |  |
| `IsValidForCurrentSale` | bit | default 1                       not null |
| `ClientShoppingCartID` | bigint |  |
| `references` | ClientShoppingCart |  |
| `PricePerItem` | decimal(30, 14) | not null |
| `OneTimeDiscount` | money | not null |
| `FromOfferQty` | float | default 0.0000000000000000e+000 not null |
| `IsFromOffer` | bit | default 0                       not null |
| `OrderedQty` | float | default 0.0000000000000000e+000 not null |
| `ExchangeRateAmount` | money | default 0.0                     not null |
| `OfferProcessingStatus` | int | default 0                       not null |
| `OfferProcessingStatusChangedByID` | bigint |  |
| `references` | unknown | [User] |
| `DiscountUpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `OneTimeDiscountComment` | nvarchar(450) |  |
| `UnpackedQty` | float | default 0.0000000000000000e+000 not null |
| `DiscountAmount` | money | default 0.0                     not null |
| `PricePerItemWithoutVat` | decimal(30, 14) | not null |
| `ReturnedQty` | float | default 0.0000000000000000e+000 not null |
| `AssignedSpecificationID` | bigint |  |
| `references` | ProductSpecification |  |
| `IsFromReSale` | bit | default 0                       not null |
| `MisplacedSaleId` | bigint |  |
| `references` | MisplacedSale |  |
| `Vat` | decimal(30, 14) | default 0.0                     not null |
| `InvoiceDocumentQty` | float | default 0.0000000000000000e+000 not null |
| `IsClosed` | bit | default CONVERT([bit], 0)       not null |
| `StorageId` | bigint |  |
| `references` | Storage |  |
| `IsFromShiftedItem` | bit | default 0                       not null |

**Indexes**:

- `IX_OrderItem_OrderID`
- `IX_OrderItem_ProductID`
- `IX_OrderItem_UserId`
- `IX_OrderItem_ClientShoppingCartID`
- `IX_OrderItem_OfferProcessingStatusChangedByID`
- `IX_OrderItem_DiscountUpdatedByID`
- `IX_OrderItem_AssignedSpecificationID`
- `IX_OrderItem_MisplacedSaleId`
- `IX_OrderItem_StorageId`

---

## Sale

**Columns**: 72 | **Foreign Keys**: 0 | **Indexes**: 21

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientAgreementID` | bigint | not null |
| `references` | ClientAgreement |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderID` | bigint | not null |
| `references` | unknown | [Order] |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `BaseLifeCycleStatusID` | bigint | default 0            not null |
| `references` | BaseLifeCycleStatus |  |
| `BaseSalePaymentStatusID` | bigint | default 0            not null |
| `references` | BaseSalePaymentStatus |  |
| `Comment` | nvarchar(450) |  |
| `SaleNumberID` | bigint |  |
| `references` | SaleNumber |  |
| `DeliveryRecipientID` | bigint |  |
| `references` | DeliveryRecipient |  |
| `DeliveryRecipientAddressID` | bigint |  |
| `references` | DeliveryRecipientAddress |  |
| `TransporterID` | bigint |  |
| `references` | Transporter |  |
| `ShiftStatusID` | bigint |  |
| `references` | SaleBaseShiftStatus |  |
| `ParentNetId` | uniqueidentifier |  |
| `IsMerged` | bit | default 0            not null |
| `SaleInvoiceDocumentID` | bigint |  |
| `references` | SaleInvoiceDocument |  |
| `SaleInvoiceNumberID` | bigint |  |
| `references` | SaleInvoiceNumber |  |
| `ChangedToInvoice` | datetime2 |  |
| `OneTimeDiscountComment` | nvarchar(450) |  |
| `ChangedToInvoiceByID` | bigint |  |
| `references` | unknown | [User] |
| `ShipmentDate` | datetime2 |  |
| `CashOnDeliveryAmount` | money | not null |
| `HasDocuments` | bit | default 0            not null |
| `IsCashOnDelivery` | bit | default 0            not null |
| `IsPrinted` | bit | default 0            not null |
| `TTN` | nvarchar(max) |  |
| `ShippingAmount` | money | default 0.0          not null |
| `TaxFreePackListID` | bigint |  |
| `references` | TaxFreePackList |  |
| `SadID` | bigint |  |
| `references` | Sad |  |
| `IsVatSale` | bit | default 0            not null |
| `ShippingAmountEur` | money | default 0.0          not null |
| `ExpiredDays` | float | default 0.00         not null |
| `IsLocked` | bit | default 0            not null |
| `IsPaymentBillDownloaded` | bit | default 0            not null |
| `IsImported` | bit | default 0            not null |
| `IsPrintedPaymentInvoice` | bit | default 0            not null |
| `IsAcceptedToPacking` | bit | default 0            not null |
| `RetailClientId` | bigint |  |
| `references` | RetailClient |  |
| `IsFullPayment` | bit | default 0            not null |
| `MisplacedSaleId` | bigint |  |
| `references` | MisplacedSale |  |
| `WorkplaceID` | bigint |  |
| `references` | Workplace |  |
| `UpdateUserID` | bigint |  |
| `references` | unknown | [User] |
| `CustomersOwnTtnID` | bigint |  |
| `references` | CustomersOwnTtn |  |
| `IsDevelopment` | bit | default 0            not null |
| `WarehousesShipmentId` | bigint |  |
| `IsPrintedActProtocolEdit` | bit | default 0            not null |
| `BillDownloadDate` | datetime2 |  |

**Indexes**:

- `IX_Sale_ClientAgreementID`
- `IX_Sale_OrderID`
- `IX_Sale_UserID`
- `IX_Sale_BaseLifeCycleStatusID`
- `IX_Sale_BaseSalePaymentStatusID`
- `IX_Sale_DeliveryRecipientAddressID`
- `IX_Sale_SaleNumberID`
- `IX_Sale_DeliveryRecipientID`
- `IX_Sale_TransporterID`
- `IX_Sale_ShiftStatusID`
- `IX_Sale_NetUID`
- `IX_Sale_SaleInvoiceDocumentID`
- `IX_Sale_SaleInvoiceNumberID`
- `IX_Sale_ChangedToInvoiceByID`
- `IX_Sale_TaxFreePackListID`
- `IX_Sale_SadID`
- `IX_Sale_RetailClientId`
- `IX_Sale_MisplacedSaleId`
- `IX_Sale_WorkplaceID`
- `IX_Sale_UpdateUserID`
- `IX_Sale_CustomersOwnTtnID`

---

## Client

**Columns**: 75 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `TIN` | nvarchar(30) |  |
| `USREOU` | nvarchar(30) |  |
| `Updated` | datetime2 | not null |
| `AccountantNumber` | nvarchar(max) |  |
| `ActualAddress` | nvarchar(max) |  |
| `DeliveryAddress` | nvarchar(max) |  |
| `DirectorNumber` | nvarchar(max) |  |
| `EmailAddress` | nvarchar(max) |  |
| `FaxNumber` | nvarchar(max) |  |
| `ICQ` | nvarchar(max) |  |
| `LegalAddress` | nvarchar(max) |  |
| `MobileNumber` | nvarchar(max) |  |
| `RegionID` | bigint |  |
| `references` | Region |  |
| `SMSNumber` | nvarchar(max) |  |
| `ClientNumber` | nvarchar(max) |  |
| `SROI` | nvarchar(max) |  |
| `Name` | nvarchar(150) |  |
| `FullName` | nvarchar(200) |  |
| `IsIndividual` | bit | default 0            not null |
| `RegionCodeID` | bigint |  |
| `references` | RegionCode |  |
| `IsActive` | bit | default 0            not null |
| `IsSubClient` | bit | default 0            not null |
| `Abbreviation` | nvarchar(max) |  |
| `IsBlocked` | bit | default 0            not null |
| `IsTradePoint` | bit | default 0            not null |
| `Brand` | nvarchar(max) |  |
| `ClientBankDetailsID` | bigint |  |
| `references` | ClientBankDetails |  |
| `CountryID` | bigint |  |
| `references` | Country |  |
| `Manufacturer` | nvarchar(max) |  |
| `TermsOfDeliveryID` | bigint |  |
| `references` | TermsOfDelivery |  |
| `SupplierContactName` | nvarchar(max) |  |
| `SupplierName` | nvarchar(max) |  |
| `PackingMarkingID` | bigint |  |
| `references` | PackingMarking |  |
| `PackingMarkingPaymentID` | bigint |  |
| `references` | PackingMarkingPayment |  |
| `IncotermsElse` | nvarchar(max) |  |
| `IsPayForDelivery` | bit | default 0            not null |
| `IsIncotermsElse` | bit | default 0            not null |
| `SupplierCode` | nvarchar(40) |  |
| `IsTemporaryClient` | bit | default 0            not null |
| `FirstName` | nvarchar(150) |  |
| `LastName` | nvarchar(150) |  |
| `MiddleName` | nvarchar(150) |  |
| `SourceFenixID` | varbinary(16) |  |
| `HouseNumber` | nvarchar(250) |  |
| `Street` | nvarchar(250) |  |
| `ZipCode` | nvarchar(250) |  |
| `ClearCartAfterDays` | int | default 3            not null |
| `IsFromECommerce` | bit | default 0            not null |
| `Manager` | nvarchar(250) |  |
| `IsForRetail` | bit | default 0            not null |
| `IsWorkplace` | bit | default 0            not null |
| `OriginalRegionCode` | nvarchar(10) |  |
| `SourceAmgCode` | bigint |  |
| `SourceAmgID` | varbinary(16) |  |
| `SourceFenixCode` | bigint |  |
| `IsNotResident` | bit | default 0            not null |
| `MainManagerID` | bigint |  |
| `references` | unknown | [User] |
| `MainClientID` | bigint |  |
| `references` | Client |  |
| `OrderExpireDays` | int | default 0            not null |

**Indexes**:

- `IX_Client_RegionCodeID`
- `IX_Client_RegionID`
- `IX_Client_ClientBankDetailsID`
- `IX_Client_CountryID`
- `IX_Client_TermsOfDeliveryID`
- `IX_Client_PackingMarkingID`
- `IX_Client_PackingMarkingPaymentID`
- `IX_Client_NetUID`
- `IX_Client_MainManagerID`
- `IX_Client_MainClientID`

---

## ClientAgreement

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AgreementID` | bigint | not null |
| `references` | Agreement |  |
| `on` | delete | cascade |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `ProductReservationTerm` | int | default 0            not null |
| `CurrentAmount` | money | default 0.0          not null |
| `OriginalClientAmgCode` | bigint |  |
| `OriginalClientFenixCode` | bigint |  |

**Indexes**:

- `IX_ClientAgreement_AgreementID`
- `IX_ClientAgreement_ClientID`
- `IX_ClientAgreement_NetUID`

---

## ClientType

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `ClientTypeIcon` | nvarchar(max) |  |
| `AllowMultiple` | bit | default 0            not null |
| `Type` | int | default 0            not null |

---

## MeasureUnit

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(25) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `CodeOneC` | nvarchar(25) |  |

---

## Currency

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Code` | nvarchar(25) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `CodeOneC` | nvarchar(25) |  |

---

## Country

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Code` | nvarchar(25) |  |

---

## Region

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(5) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## AccountingDocumentName

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentType` | int | not null |
| `NameUK` | nvarchar(120) |  |
| `NamePL` | nvarchar(120) |  |

---

## AccountingOperationName

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `OperationType` | int | not null |
| `CashNameUK` | nvarchar(120) |  |
| `CashNamePL` | nvarchar(120) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `BankNamePL` | nvarchar(120) |  |
| `BankNameUK` | nvarchar(120) |  |

---

## ActProvidingService

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                             not null |
| `IsAccounting` | bit | not null |
| `Price` | decimal(30, 14) | not null |
| `UserID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | unknown | [User] |
| `Comment` | nvarchar(2000) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `Number` | nvarchar(50) |  |

**Indexes**:

- `IX_ActProvidingService_UserID`

---

## ActProvidingServiceDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(500) |  |
| `FileName` | nvarchar(500) |  |
| `ContentType` | nvarchar(500) |  |
| `GeneratedName` | nvarchar(500) |  |
| `Number` | nvarchar(20) |  |

---

## ActReconciliation

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `SupplyOrderUkraineID` | bigint |  |
| `references` | SupplyOrderUkraine |  |
| `SupplyInvoiceID` | bigint |  |
| `references` | SupplyInvoice |  |

**Indexes**:

- `IX_ActReconciliation_ResponsibleID`
- `IX_ActReconciliation_SupplyOrderUkraineID`
- `IX_ActReconciliation_SupplyInvoiceID`

---

## ActReconciliationItem

**Columns**: 24 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `HasDifference` | bit | not null |
| `NegativeDifference` | bit | not null |
| `OrderedQty` | float | not null |
| `ActualQty` | float | not null |
| `QtyDifference` | float | not null |
| `CommentUA` | nvarchar(500) |  |
| `CommentPL` | nvarchar(500) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `ActReconciliationID` | bigint | not null |
| `references` | ActReconciliation |  |
| `NetWeight` | float | default 0.0000000000000000e+000 not null |
| `UnitPrice` | money | default 0.0                     not null |
| `SupplyOrderUkraineItemID` | bigint |  |
| `references` | SupplyOrderUkraineItem |  |
| `SupplyInvoiceOrderItemID` | bigint |  |
| `references` | SupplyInvoiceOrderItem |  |

**Indexes**:

- `IX_ActReconciliationItem_ActReconciliationID`
- `IX_ActReconciliationItem_ProductID`
- `IX_ActReconciliationItem_SupplyOrderUkraineItemID`
- `IX_ActReconciliationItem_SupplyInvoiceOrderItemID`

---

## AdvancePayment

**Columns**: 24 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                             not null |
| `Amount` | money | not null |
| `VatAmount` | money | not null |
| `VatPercent` | float | not null |
| `Comment` | nvarchar(450) |  |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `TaxFreeID` | bigint |  |
| `references` | TaxFree |  |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |
| `OrganizationClientAgreementID` | bigint |  |
| `references` | OrganizationClientAgreement |  |
| `OrganizationID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | Organization |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `Number` | nvarchar(50) |  |
| `SadID` | bigint |  |
| `references` | Sad |  |

**Indexes**:

- `IX_AdvancePayment_ClientAgreementID`
- `IX_AdvancePayment_OrganizationClientAgreementID`
- `IX_AdvancePayment_TaxFreeID`
- `IX_AdvancePayment_UserID`
- `IX_AdvancePayment_OrganizationID`
- `IX_AdvancePayment_SadID`

---

## Agreement

**Columns**: 48 | **Foreign Keys**: 0 | **Indexes**: 7

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AmountDebt` | money | not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `NumberDaysDebt` | int | not null |
| `Updated` | datetime2 | not null |
| `OrganizationID` | bigint |  |
| `references` | Organization |  |
| `PricingID` | bigint |  |
| `references` | Pricing |  |
| `IsAccounting` | bit | default 0                       not null |
| `IsActive` | bit | default 0                       not null |
| `IsControlAmountDebt` | bit | default 0                       not null |
| `IsControlNumberDaysDebt` | bit | default 0                       not null |
| `IsManagementAccounting` | bit | default 0                       not null |
| `WithVATAccounting` | bit | default 0                       not null |
| `Name` | nvarchar(100) |  |
| `ProviderPricingID` | bigint |  |
| `references` | ProviderPricing |  |
| `DeferredPayment` | nvarchar(max) |  |
| `TermsOfPayment` | nvarchar(max) |  |
| `IsPrePaymentFull` | bit | default 0                       not null |
| `PrePaymentPercentages` | float | default 0.0000000000000000e+000 not null |
| `IsPrePayment` | bit | default 0                       not null |
| `IsDefault` | bit | default 0                       not null |
| `Number` | nvarchar(50) |  |
| `TaxAccountingSchemeID` | bigint |  |
| `references` | TaxAccountingScheme |  |
| `AgreementTypeCivilCodeID` | bigint |  |
| `references` | AgreementTypeCivilCode |  |
| `FromDate` | datetime2 |  |
| `ToDate` | datetime2 |  |
| `PromotionalPricingID` | bigint |  |
| `references` | Pricing |  |
| `IsSelected` | bit | default 0                       not null |
| `ForReSale` | bit | default 0                       not null |
| `WithAgreementLine` | bit | default 0                       not null |
| `SourceFenixID` | varbinary(16) |  |
| `SourceAmgCode` | bigint |  |
| `SourceAmgID` | varbinary(16) |  |
| `SourceFenixCode` | bigint |  |
| `IsDefaultForSyncConsignment` | bit | default CONVERT([bit], 0)       not null |
| `HasPromotionalPricing` | bit | default CONVERT([bit], 0)       not null |

**Indexes**:

- `IX_Agreement_PricingID`
- `IX_Agreement_ProviderPricingID`
- `IX_Agreement_OrganizationID`
- `IX_Agreement_CurrencyID`
- `IX_Agreement_TaxAccountingSchemeID`
- `IX_Agreement_AgreementTypeCivilCodeID`
- `IX_Agreement_PromotionalPricingID`

---

## AgreementType

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(25) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## AgreementTypeCivilCode

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CodeOneC` | nvarchar(25) |  |
| `NameUK` | nvarchar(100) |  |
| `NamePL` | nvarchar(100) |  |

---

## AgreementTypeTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `AgreementTypeID` | bigint | not null |
| `references` | AgreementType |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_AgreementTypeTranslation_AgreementTypeID`

---

## AllegroCategory

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `CategoryID` | int | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsLeaf` | bit | not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ParentCategoryID` | int | not null |
| `Position` | int | not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_AllegroCategory_ParentCategoryID`
- `IX_AllegroCategory_CategoryID`

---

## AllegroProductReservation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |
| `AllegroItemID` | bigint | default 0            not null |

**Indexes**:

- `IX_AllegroProductReservation_ProductID`

---

## AssignedPaymentOrder

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `AssignedIncomePaymentOrderID` | bigint |  |
| `references` | IncomePaymentOrder |  |
| `AssignedOutcomePaymentOrderID` | bigint |  |
| `references` | OutcomePaymentOrder |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `RootIncomePaymentOrderID` | bigint |  |
| `references` | IncomePaymentOrder |  |
| `RootOutcomePaymentOrderID` | bigint |  |
| `references` | OutcomePaymentOrder |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_AssignedPaymentOrder_AssignedIncomePaymentOrderID`
- `IX_AssignedPaymentOrder_AssignedOutcomePaymentOrderID`
- `IX_AssignedPaymentOrder_RootIncomePaymentOrderID`
- `IX_AssignedPaymentOrder_RootOutcomePaymentOrderID`

---

## AuditEntity

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `BaseEntityNetUID` | uniqueidentifier | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Type` | int | not null |
| `Updated` | datetime2 | not null |
| `UpdatedBy` | nvarchar(max) |  |
| `UpdatedByNetUID` | uniqueidentifier | not null |
| `EntityName` | nvarchar(max) |  |

**Indexes**:

- `IX_AuditEntity_BaseEntityNetUID`

---

## AuditEntityProperty

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AuditEntityID` | bigint | not null |
| `references` | AuditEntity |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Type` | int | not null |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |

**Indexes**:

- `IX_AuditEntityProperty_AuditEntityID`

---

## AuditEntityPropertyNameTranslation

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `LocalizedName` | nvarchar(max) |  |

---

## Bank

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) | not null |
| `MfoCode` | nvarchar(6) | not null |
| `EdrpouCode` | nvarchar(10) | not null |
| `City` | nvarchar(150) |  |
| `Address` | nvarchar(150) |  |
| `Phones` | nvarchar(100) |  |

---

## BaseLifeCycleStatus

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SaleLifeCycleType` | int | not null |
| `Updated` | datetime2 | not null |

---

## BaseSalePaymentStatus

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SalePaymentStatusType` | int | not null |
| `Updated` | datetime2 | not null |

---

## BillOfLadingDocument

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | money | not null |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Date` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `BillOfLadingServiceID` | bigint |  |
| `references` | BillOfLadingService |  |

**Indexes**:

- `IX_BillOfLadingDocument_BillOfLadingServiceID`

---

## BillOfLadingService

**Columns**: 54 | **Foreign Keys**: 0 | **Indexes**: 11

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `IsActive` | bit | not null |
| `FromDate` | datetime2 |  |
| `GrossPrice` | money | not null |
| `NetPrice` | money | not null |
| `Vat` | money | not null |
| `AccountingGrossPrice` | money | not null |
| `AccountingNetPrice` | money | not null |
| `AccountingVat` | money | not null |
| `VatPercent` | float | not null |
| `AccountingVatPercent` | float | not null |
| `Number` | nvarchar(max) |  |
| `ServiceNumber` | nvarchar(50) |  |
| `Name` | nvarchar(max) |  |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `SupplyOrganizationAgreementID` | bigint | not null |
| `references` | SupplyOrganizationAgreement |  |
| `LoadDate` | datetime2 |  |
| `BillOfLadingNumber` | nvarchar(max) |  |
| `TermDeliveryInDays` | nvarchar(max) |  |
| `SupplyOrganizationID` | bigint | not null |
| `references` | SupplyOrganization |  |
| `IsAutoCalculatedValue` | bit | not null |
| `SupplyExtraChargeType` | int | default 0                    not null |
| `TypeBillOfLadingService` | int | default 0                    not null |
| `DeliveryProductProtocolID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | DeliveryProductProtocol |  |
| `IsCalculatedValue` | bit | default 0                    not null |
| `IsShipped` | bit | default 0                    not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                  not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                    not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_BillOfLadingService_AccountingPaymentTaskID`
- `IX_BillOfLadingService_SupplyOrganizationAgreementID`
- `IX_BillOfLadingService_SupplyOrganizationID`
- `IX_BillOfLadingService_SupplyPaymentTaskID`
- `IX_BillOfLadingService_UserID`
- `IX_BillOfLadingService_DeliveryProductProtocolID`
- `IX_BillOfLadingService_SupplyInformationTaskID`
- `IX_BillOfLadingService_ActProvidingServiceDocumentID`
- `IX_BillOfLadingService_SupplyServiceAccountDocumentID`
- `IX_BillOfLadingService_AccountingActProvidingServiceID`
- `IX_BillOfLadingService_ActProvidingServiceID`

---

## CalculationType

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(25) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## CalculationTypeTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CalculationTypeID` | bigint | not null |
| `references` | CalculationType |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_CalculationTypeTranslation_CalculationTypeID`

---

## CarBrand

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) |  |
| `Description` | nvarchar(250) |  |
| `ImageUrl` | nvarchar(100) |  |
| `Alias` | nvarchar(max) |  |

---

## Category

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `RootCategoryID` | bigint |  |
| `references` | Category |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_Category_RootCategoryID`

---

## ChartMonth

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | int | not null |
| `Updated` | datetime2 | not null |

---

## ChartMonthTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ChartMonthID` | bigint | not null |
| `references` | ChartMonth |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ChartMonthTranslation_ChartMonthID`

---

## ClientBalanceMovement

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | money | not null |
| `ClientAgreementID` | bigint | not null |
| `references` | ClientAgreement |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `ExchangeRateAmount` | money | not null |
| `MovementType` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientBalanceMovement_ClientAgreementID`

---

## ClientBankDetailAccountNumber

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AccountNumber` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `on` | delete | cascade |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientBankDetailAccountNumber_CurrencyID`

---

## ClientBankDetailIbanNo

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `on` | delete | cascade |
| `Deleted` | bit | default 0            not null |
| `IBANNO` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientBankDetailIbanNo_CurrencyID`

---

## ClientBankDetails

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AccountNumberID` | bigint |  |
| `references` | ClientBankDetailAccountNumber |  |
| `BankAndBranch` | nvarchar(max) |  |
| `ClientBankDetailIbanNoID` | bigint |  |
| `references` | ClientBankDetailIbanNo |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `BranchCode` | nvarchar(max) |  |
| `Swift` | nvarchar(max) |  |
| `BankAddress` | nvarchar(max) |  |

**Indexes**:

- `IX_ClientBankDetails_AccountNumberID`
- `IX_ClientBankDetails_ClientBankDetailIbanNoID`

---

## ClientContractDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientContractDocument_ClientID`

---

## ClientGroup

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Name` | nvarchar(500) |  |
| `ClientID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Client |  |

**Indexes**:

- `IX_ClientGroup_ClientID`

---

## ClientInDebt

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AgreementID` | bigint | not null |
| `references` | Agreement |  |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `Created` | datetime2 | default getutcdate() not null |
| `DebtID` | bigint | not null |
| `references` | Debt |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `SaleID` | bigint |  |
| `references` | Sale |  |
| `ReSaleID` | bigint |  |
| `references` | ReSale |  |

**Indexes**:

- `IX_ClientInDebt_AgreementID`
- `IX_ClientInDebt_ClientID`
- `IX_ClientInDebt_DebtID`
- `IX_ClientInDebt_SaleID`
- `IX_ClientInDebt_ReSaleID`

---

## ClientInRole

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientTypeID` | bigint | not null |
| `references` | ClientType |  |
| `ClientTypeRoleID` | bigint | not null |
| `references` | ClientTypeRole |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `ClientID` | bigint | default 0            not null |
| `references` | Client |  |

**Indexes**:

- `IX_ClientInRole_ClientTypeID`
- `IX_ClientInRole_ClientTypeRoleID`
- `IX_ClientInRole_ClientID`

---

## ClientPerfectClient

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsChecked` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PerfectClientID` | bigint | not null |
| `references` | PerfectClient |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |
| `PerfectClientValueID` | bigint |  |
| `references` | PerfectClientValue |  |

**Indexes**:

- `IX_ClientPerfectClient_ClientID`
- `IX_ClientPerfectClient_PerfectClientID`
- `IX_ClientPerfectClient_PerfectClientValueID`

---

## ClientRegistrationTask

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `IsDone` | bit | default 0            not null |

**Indexes**:

- `IX_ClientRegistrationTask_ClientID`

---

## ClientShoppingCart

**Columns**: 21 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()              not null |
| `Deleted` | bit | default 0                         not null |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `Updated` | datetime2 | not null |
| `ClientAgreementID` | bigint | default 0                         not null |
| `references` | ClientAgreement |  |
| `ValidUntil` | datetime2 | default '0001-01-01T00:00:00.000' not null |
| `Number` | nvarchar(50) |  |
| `IsOfferProcessed` | bit | default 0                         not null |
| `Comment` | nvarchar(450) |  |
| `OfferProcessingStatus` | int | default 0                         not null |
| `OfferProcessingStatusChangedByID` | bigint |  |
| `references` | unknown | [User] |
| `IsOffer` | bit | default 0                         not null |
| `CreatedByID` | bigint |  |
| `references` | unknown | [User] |
| `IsVatCart` | bit | default 0                         not null |
| `WorkplaceID` | bigint |  |
| `references` | Workplace |  |

**Indexes**:

- `IX_ClientShoppingCart_ClientAgreementID`
- `IX_ClientShoppingCart_OfferProcessingStatusChangedByID`
- `IX_ClientShoppingCart_CreatedByID`
- `IX_ClientShoppingCart_WorkplaceID`

---

## ClientSubClient

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `RootClientID` | bigint | not null |
| `references` | Client |  |
| `SubClientID` | bigint | not null |
| `references` | Client |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientSubClient_RootClientID`
- `IX_ClientSubClient_SubClientID`

---

## ClientTypeRole

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientTypeID` | bigint | not null |
| `references` | ClientType |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `OrderExpireDays` | int | default 0            not null |

**Indexes**:

- `IX_ClientTypeRole_ClientTypeID`

---

## ClientTypeRoleTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientTypeRoleID` | bigint | not null |
| `references` | ClientTypeRole |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientTypeRoleTranslation_ClientTypeRoleID`

---

## ClientTypeTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientTypeID` | bigint | not null |
| `references` | ClientType |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ClientTypeTranslation_ClientTypeID`

---

## ClientUserProfile

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `on` | delete | cascade |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UserProfileID` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |

**Indexes**:

- `IX_ClientUserProfile_ClientID`
- `IX_ClientUserProfile_UserProfileID`

---

## ClientWorkplace

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `MainClientID` | bigint | not null |
| `references` | Client |  |
| `WorkplaceID` | bigint | not null |
| `references` | Client |  |
| `ClientGroupId` | bigint |  |
| `references` | ClientGroup |  |

**Indexes**:

- `IX_ClientWorkplace_MainClientID`
- `IX_ClientWorkplace_WorkplaceID`
- `IX_ClientWorkplace_ClientGroupId`

---

## ColumnItem

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Order` | int | not null |
| `SQL` | nvarchar(max) |  |
| `Type` | int | not null |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |
| `CssClass` | nvarchar(max) |  |
| `Template` | nvarchar(max) | default N'' |

**Indexes**:

- `IX_ColumnItem_UserID`

---

## ColumnItemTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ColumnItemID` | bigint | not null |
| `references` | ColumnItem |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ColumnItemTranslation_ColumnItemID`

---

## CompanyCar

**Columns**: 23 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `CreatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `Deleted` | bit | default 0                       not null |
| `InCityConsumption` | float | not null |
| `LicensePlate` | nvarchar(20) |  |
| `Mileage` | bigint | not null |
| `MixedModeConsumption` | float | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `OutsideCityConsumption` | float | not null |
| `TankCapacity` | float | not null |
| `Updated` | datetime2 | not null |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `FuelAmount` | float | default 0.0000000000000000e+000 not null |
| `InitialMileage` | bigint | default 0                       not null |
| `ConsumablesStorageID` | bigint | default 0                       not null |
| `references` | ConsumablesStorage |  |
| `OrganizationID` | bigint | default 0                       not null |
| `references` | Organization |  |
| `CarBrand` | nvarchar(100) |  |

**Indexes**:

- `IX_CompanyCar_CreatedByID`
- `IX_CompanyCar_UpdatedByID`
- `IX_CompanyCar_ConsumablesStorageID`
- `IX_CompanyCar_OrganizationID`

---

## CompanyCarFueling

**Columns**: 22 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CompanyCarID` | bigint | not null |
| `references` | CompanyCar |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `FuelAmount` | float | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `OutcomePaymentOrderID` | bigint | not null |
| `references` | OutcomePaymentOrder |  |
| `PricePerLiter` | money | not null |
| `Updated` | datetime2 | not null |
| `ConsumableProductOrganizationID` | bigint | default 0                       not null |
| `references` | SupplyOrganization |  |
| `TotalPrice` | money | default 0.0                     not null |
| `VatAmount` | money | default 0.0                     not null |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `UserID` | bigint | default 0                       not null |
| `references` | unknown | [User] |
| `TotalPriceWithVat` | money | default 0.0                     not null |
| `SupplyOrganizationAgreementID` | bigint |  |
| `references` | SupplyOrganizationAgreement |  |

**Indexes**:

- `IX_CompanyCarFueling_CompanyCarID`
- `IX_CompanyCarFueling_OutcomePaymentOrderID`
- `IX_CompanyCarFueling_ConsumableProductOrganizationID`
- `IX_CompanyCarFueling_UserID`
- `IX_CompanyCarFueling_SupplyOrganizationAgreementID`

---

## CompanyCarRoadList

**Columns**: 23 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Comment` | nvarchar(150) |  |
| `CompanyCarID` | bigint | not null |
| `references` | CompanyCar |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `Mileage` | bigint | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `Updated` | datetime2 | not null |
| `CreatedByID` | bigint | default 0                       not null |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `FuelAmount` | float | default 0.0000000000000000e+000 not null |
| `InCityKilometers` | int | default 0                       not null |
| `MixedModeKilometers` | int | default 0                       not null |
| `OutcomePaymentOrderID` | bigint |  |
| `references` | OutcomePaymentOrder |  |
| `OutsideCityKilometers` | int | default 0                       not null |
| `TotalKilometers` | int | default 0                       not null |

**Indexes**:

- `IX_CompanyCarRoadList_CompanyCarID`
- `IX_CompanyCarRoadList_ResponsibleID`
- `IX_CompanyCarRoadList_CreatedByID`
- `IX_CompanyCarRoadList_UpdatedByID`
- `IX_CompanyCarRoadList_OutcomePaymentOrderID`

---

## CompanyCarRoadListDriver

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CompanyCarRoadListID` | bigint | not null |
| `references` | CompanyCarRoadList |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_CompanyCarRoadListDriver_CompanyCarRoadListID`
- `IX_CompanyCarRoadListDriver_UserID`

---

## Consignment

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `FromDate` | datetime2 | not null |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `ProductIncomeID` | bigint | not null |
| `references` | ProductIncome |  |
| `IsVirtual` | bit | default 0                    not null |
| `StorageID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Storage |  |
| `ProductTransferID` | bigint |  |
| `references` | ProductTransfer |  |
| `IsImportedFromOneC` | bit | default 0                    not null |

**Indexes**:

- `IX_Consignment_OrganizationID`
- `IX_Consignment_ProductIncomeID`
- `IX_Consignment_StorageID`
- `IX_Consignment_ProductTransferID`

---

## ConsignmentItem

**Columns**: 24 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `RemainingQty` | float | not null |
| `Weight` | float | not null |
| `Price` | decimal(30, 14) | not null |
| `DutyPercent` | money | not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `ConsignmentID` | bigint | not null |
| `references` | Consignment |  |
| `ProductIncomeItemID` | bigint | not null |
| `ProductSpecificationID` | bigint | not null |
| `references` | ProductSpecification |  |
| `RootConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |
| `NetPrice` | decimal(30, 14) | not null |
| `AccountingPrice` | decimal(30, 14) | not null |
| `ExchangeRate` | money | not null |

**Indexes**:

- `IX_ConsignmentItem_ConsignmentID`
- `IX_ConsignmentItem_ProductID`
- `IX_ConsignmentItem_ProductIncomeItemID`
- `IX_ConsignmentItem_ProductSpecificationID`
- `IX_ConsignmentItem_RootConsignmentItemID`

---

## ConsignmentItemMovement

**Columns**: 32 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `IsIncomeMovement` | bit | not null |
| `Qty` | float | not null |
| `MovementType` | int | not null |
| `ConsignmentItemID` | bigint | not null |
| `references` | ConsignmentItem |  |
| `on` | delete | cascade |
| `ProductIncomeItemID` | bigint |  |
| `references` | ProductIncomeItem |  |
| `DepreciatedOrderItemID` | bigint |  |
| `references` | DepreciatedOrderItem |  |
| `SupplyReturnItemID` | bigint |  |
| `references` | SupplyReturnItem |  |
| `OrderItemID` | bigint |  |
| `references` | OrderItem |  |
| `ProductTransferItemID` | bigint |  |
| `references` | ProductTransferItem |  |
| `OrderItemBaseShiftStatusID` | bigint |  |
| `references` | OrderItemBaseShiftStatus |  |
| `TaxFreeItemID` | bigint |  |
| `references` | TaxFreeItem |  |
| `SadItemID` | bigint |  |
| `references` | SadItem |  |
| `RemainingQty` | float | default 0.0000000000000000e+000 not null |
| `ReSaleItemId` | bigint |  |
| `references` | ReSaleItem |  |

**Indexes**:

- `IX_ConsignmentItemMovement_ConsignmentItemID`
- `IX_ConsignmentItemMovement_DepreciatedOrderItemID`
- `IX_ConsignmentItemMovement_OrderItemBaseShiftStatusID`
- `IX_ConsignmentItemMovement_OrderItemID`
- `IX_ConsignmentItemMovement_ProductIncomeItemID`
- `IX_ConsignmentItemMovement_ProductTransferItemID`
- `IX_ConsignmentItemMovement_SadItemID`
- `IX_ConsignmentItemMovement_SupplyReturnItemID`
- `IX_ConsignmentItemMovement_TaxFreeItemID`
- `IX_ConsignmentItemMovement_ReSaleItemId`

---

## ConsignmentItemMovementTypeName

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `NamePl` | nvarchar(100) |  |
| `NameUa` | nvarchar(100) |  |
| `MovementType` | int | not null |

---

## ConsignmentNoteSetting

**Columns**: 29 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `BrandAndNumberCar` | nvarchar(200) |  |
| `TrailerNumber` | nvarchar(200) |  |
| `Driver` | nvarchar(200) |  |
| `Carrier` | nvarchar(200) |  |
| `TypeTransportation` | nvarchar(200) |  |
| `UnloadingPoint` | nvarchar(500) |  |
| `LoadingPoint` | nvarchar(500) |  |
| `Customer` | nvarchar(200) |  |
| `Name` | nvarchar(200) |  |
| `ForReSale` | bit | default 0            not null |
| `CarGrossWeight` | decimal(18, 2) | default 0.0          not null |
| `CarHeight` | int | default 0            not null |
| `CarLabel` | nvarchar(200) |  |
| `CarLength` | int | default 0            not null |
| `CarNetWeight` | decimal(18, 2) | default 0.0          not null |
| `CarWidth` | int | default 0            not null |
| `TrailerGrossWeight` | decimal(18, 2) | default 0.0          not null |
| `TrailerHeight` | int | default 0            not null |
| `TrailerLabel` | nvarchar(200) |  |
| `TrailerLength` | int | default 0            not null |
| `TrailerNetWeight` | decimal(18, 2) | default 0.0          not null |
| `TrailerWidth` | int | default 0            not null |

---

## ConsumableProduct

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumableProductCategoryID` | bigint | not null |
| `references` | ConsumableProductCategory |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `VendorCode` | nvarchar(3) |  |
| `MeasureUnitID` | bigint |  |
| `references` | MeasureUnit |  |

**Indexes**:

- `IX_ConsumableProduct_ConsumableProductCategoryID`
- `IX_ConsumableProduct_MeasureUnitID`

---

## ConsumableProductCategory

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(450) |  |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `IsSupplyServiceCategory` | bit | default 0            not null |

---

## ConsumableProductCategoryTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumableProductCategoryID` | bigint | not null |
| `references` | ConsumableProductCategory |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(450) |  |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ConsumableProductCategoryTranslation_ConsumableProductCategoryID`

---

## ConsumableProductTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumableProductID` | bigint | not null |
| `references` | ConsumableProduct |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ConsumableProductTranslation_ConsumableProductID`

---

## ConsumablesOrder

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Comment` | nvarchar(450) |  |
| `Created` | datetime2 | default getutcdate()              not null |
| `Deleted` | bit | default 0                         not null |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `Number` | nvarchar(50) |  |
| `Updated` | datetime2 | not null |
| `OrganizationFromDate` | datetime2 | default '0001-01-01T00:00:00.000' not null |
| `OrganizationNumber` | nvarchar(50) |  |
| `IsPayed` | bit | default 0                         not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `ConsumablesStorageID` | bigint |  |
| `references` | ConsumablesStorage |  |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |

**Indexes**:

- `IX_ConsumablesOrder_UserID`
- `IX_ConsumablesOrder_ConsumablesStorageID`
- `IX_ConsumablesOrder_SupplyPaymentTaskID`

---

## ConsumablesOrderDocument

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumablesOrderID` | bigint | not null |
| `references` | ConsumablesOrder |  |
| `on` | delete | cascade |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ConsumablesOrderDocument_ConsumablesOrderID`

---

## ConsumablesOrderItem

**Columns**: 23 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumableProductCategoryID` | bigint | not null |
| `references` | ConsumableProductCategory |  |
| `ConsumableProductID` | bigint |  |
| `references` | ConsumableProduct |  |
| `ConsumableProductOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `ConsumablesOrderID` | bigint | not null |
| `references` | ConsumablesOrder |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `TotalPrice` | money | not null |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |
| `PricePerItem` | money | default 0.0                     not null |
| `VAT` | money | default 0.0                     not null |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `IsService` | bit | default 0                       not null |
| `SupplyOrganizationAgreementID` | bigint |  |
| `references` | SupplyOrganizationAgreement |  |
| `TotalPriceWithVAT` | money | default 0.0                     not null |

**Indexes**:

- `IX_ConsumablesOrderItem_ConsumableProductCategoryID`
- `IX_ConsumablesOrderItem_ConsumableProductID`
- `IX_ConsumablesOrderItem_ConsumableProductOrganizationID`
- `IX_ConsumablesOrderItem_ConsumablesOrderID`
- `IX_ConsumablesOrderItem_SupplyOrganizationAgreementID`

---

## ConsumablesStorage

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(250) |  |
| `Name` | nvarchar(50) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `ResponsibleUserID` | bigint | not null |
| `references` | unknown | [User] |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ConsumablesStorage_OrganizationID`
- `IX_ConsumablesStorage_ResponsibleUserID`

---

## ContainerService

**Columns**: 52 | **Foreign Keys**: 0 | **Indexes**: 11

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetPrice` | money | not null |
| `BillOfLadingDocumentID` | bigint |  |
| `references` | BillOfLadingDocument |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `LoadDate` | datetime2 | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `TermDeliveryInDays` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `ContainerOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `FromDate` | datetime2 |  |
| `GroosWeight` | float | default 0.0000000000000000e+000 not null |
| `GrossPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `IsCalculatedExtraCharge` | bit | default 0                       not null |
| `SupplyExtraChargeType` | int | default 0                       not null |
| `ContainerNumber` | nvarchar(max) |  |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_ContainerService_BillOfLadingDocumentID`
- `IX_ContainerService_SupplyPaymentTaskID`
- `IX_ContainerService_UserID`
- `IX_ContainerService_ContainerOrganizationID`
- `IX_ContainerService_SupplyOrganizationAgreementID`
- `IX_ContainerService_AccountingPaymentTaskID`
- `IX_ContainerService_SupplyInformationTaskID`
- `IX_ContainerService_ActProvidingServiceDocumentID`
- `IX_ContainerService_SupplyServiceAccountDocumentID`
- `IX_ContainerService_AccountingActProvidingServiceId`
- `IX_ContainerService_ActProvidingServiceId`

---

## CountSaleMessage

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SaleID` | bigint | not null |
| `references` | Sale |  |
| `on` | delete | cascade |
| `SaleMessageNumeratorID` | bigint | not null |
| `references` | SaleMessageNumerator |  |
| `on` | delete | cascade |
| `Transfered` | bit | not null |

**Indexes**:

- `IX_CountSaleMessage_SaleID`
- `IX_CountSaleMessage_SaleMessageNumeratorID`

---

## CreditNoteDocument

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | money | not null |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate()              not null |
| `Deleted` | bit | default 0                         not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `Updated` | datetime2 | not null |
| `SupplyOrderID` | bigint | default 0                         not null |
| `references` | SupplyOrder |  |
| `Comment` | nvarchar(max) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.000' not null |
| `Number` | nvarchar(max) |  |

**Indexes**:

- `IX_CreditNoteDocument_SupplyOrderID`

---

## CrossExchangeRate

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | decimal(30, 14) | not null |
| `Code` | nvarchar(30) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Culture` | nvarchar(5) |  |
| `CurrencyFromID` | bigint | not null |
| `references` | Currency |  |
| `CurrencyToID` | bigint | not null |
| `references` | Currency |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_CrossExchangeRate_CurrencyFromID`
- `IX_CrossExchangeRate_CurrencyToID`

---

## CrossExchangeRateHistory

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | decimal(30, 14) | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `CrossExchangeRateID` | bigint | not null |
| `references` | CrossExchangeRate |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UpdatedByID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_CrossExchangeRateHistory_CrossExchangeRateID`
- `IX_CrossExchangeRateHistory_UpdatedByID`

---

## CurrencyTrader

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FirstName` | nvarchar(75) |  |
| `LastName` | nvarchar(75) |  |
| `MiddleName` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PhoneNumber` | nvarchar(30) |  |
| `Updated` | datetime2 | not null |

---

## CurrencyTraderExchangeRate

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()              not null |
| `CurrencyName` | nvarchar(25) |  |
| `CurrencyTraderID` | bigint | not null |
| `references` | CurrencyTrader |  |
| `Deleted` | bit | default 0                         not null |
| `ExchangeRate` | money | not null |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `Updated` | datetime2 | not null |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.000' not null |

**Indexes**:

- `IX_CurrencyTraderExchangeRate_CurrencyTraderID`

---

## CurrencyTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `on` | delete | cascade |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_CurrencyTranslation_CurrencyID`

---

## CustomAgencyService

**Columns**: 43 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `CustomAgencyOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `Deleted` | bit | default 0                       not null |
| `FromDate` | datetime2 |  |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `GrossPrice` | money | default 0.0                     not null |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_CustomAgencyService_CustomAgencyOrganizationID`
- `IX_CustomAgencyService_SupplyPaymentTaskID`
- `IX_CustomAgencyService_UserID`
- `IX_CustomAgencyService_SupplyOrganizationAgreementID`
- `IX_CustomAgencyService_AccountingPaymentTaskID`
- `IX_CustomAgencyService_SupplyInformationTaskID`
- `IX_CustomAgencyService_ActProvidingServiceDocumentID`
- `IX_CustomAgencyService_SupplyServiceAccountDocumentID`
- `IX_CustomAgencyService_AccountingActProvidingServiceId`
- `IX_CustomAgencyService_ActProvidingServiceId`

---

## CustomService

**Columns**: 49 | **Foreign Keys**: 0 | **Indexes**: 12

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `CustomOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `GrossPrice` | money | default 0.0                     not null |
| `FromDate` | datetime2 |  |
| `Number` | nvarchar(max) |  |
| `SupplyCustomType` | int | default 0                       not null |
| `ExciseDutyOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_CustomService_SupplyOrderID`
- `IX_CustomService_SupplyPaymentTaskID`
- `IX_CustomService_UserID`
- `IX_CustomService_CustomOrganizationID`
- `IX_CustomService_ExciseDutyOrganizationID`
- `IX_CustomService_SupplyOrganizationAgreementID`
- `IX_CustomService_AccountingPaymentTaskID`
- `IX_CustomService_SupplyInformationTaskID`
- `IX_CustomService_ActProvidingServiceDocumentID`
- `IX_CustomService_SupplyServiceAccountDocumentID`
- `IX_CustomService_AccountingActProvidingServiceId`
- `IX_CustomService_ActProvidingServiceId`

---

## CustomersOwnTtn

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Number` | nvarchar(150) |  |
| `TtnPDFPath` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

---

## DashboardNode

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `CssClass` | nvarchar(200) |  |
| `DashboardNodeModuleID` | bigint |  |
| `references` | DashboardNodeModule |  |
| `Deleted` | bit | default 0            not null |
| `Language` | nvarchar(2) |  |
| `Module` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ParentDashboardNodeID` | bigint |  |
| `references` | DashboardNode |  |
| `Route` | nvarchar(4000) |  |
| `Updated` | datetime2 | not null |
| `DashboardNodeType` | int | default 0            not null |

**Indexes**:

- `IX_DashboardNode_DashboardNodeModuleID`
- `IX_DashboardNode_ParentDashboardNodeID`

---

## DashboardNodeModule

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Language` | nvarchar(2) |  |
| `Module` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `CssClass` | nvarchar(200) |  |
| `Description` | nvarchar(500) |  |

---

## DataSyncOperation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `OperationType` | int | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |
| `ForAmg` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_DataSyncOperation_UserID`

---

## Debt

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Days` | int | not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Total` | decimal(30, 14) | not null |
| `Updated` | datetime2 | not null |

---

## DeliveryExpense

**Columns**: 28 | **Foreign Keys**: 0 | **Indexes**: 8

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `InvoiceNumber` | nvarchar(50) |  |
| `FromDate` | datetime2 | not null |
| `GrossAmount` | money | not null |
| `VatPercent` | money | not null |
| `AccountingGrossAmount` | money | not null |
| `AccountingVatPercent` | money | not null |
| `SupplyOrderUkraineID` | bigint | not null |
| `references` | SupplyOrderUkraine |  |
| `SupplyOrganizationID` | bigint | not null |
| `references` | SupplyOrganization |  |
| `SupplyOrganizationAgreementID` | bigint | not null |
| `references` | SupplyOrganizationAgreement |  |
| `ConsumableProductID` | bigint |  |
| `references` | ConsumableProduct |  |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `ActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `AccountingActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_DeliveryExpense_ActProvidingServiceDocumentID`
- `IX_DeliveryExpense_ActProvidingServiceID`
- `IX_DeliveryExpense_ConsumableProductID`
- `IX_DeliveryExpense_SupplyOrderUkraineID`
- `IX_DeliveryExpense_SupplyOrganizationAgreementID`
- `IX_DeliveryExpense_SupplyOrganizationID`
- `IX_DeliveryExpense_UserID`
- `IX_DeliveryExpense_AccountingActProvidingServiceID`

---

## DeliveryProductProtocol

**Columns**: 22 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                             not null |
| `TransportationType` | int | default 0                             not null |
| `UserID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `IsCompleted` | bit | default 0                             not null |
| `IsPartiallyPlaced` | bit | default 0                             not null |
| `IsPlaced` | bit | default 0                             not null |
| `OrganizationID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | Organization |  |
| `on` | delete | cascade |
| `DeliveryProductProtocolNumberID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | DeliveryProductProtocolNumber |  |
| `IsShipped` | bit | default 0                             not null |

**Indexes**:

- `IX_DeliveryProductProtocol_OrganizationID`
- `IX_DeliveryProductProtocol_UserID`
- `IX_DeliveryProductProtocol_DeliveryProductProtocolNumberID`

---

## DeliveryProductProtocolDocument

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(500) |  |
| `FileName` | nvarchar(500) |  |
| `ContentType` | nvarchar(500) |  |
| `GeneratedName` | nvarchar(500) |  |
| `Number` | nvarchar(20) |  |
| `DeliveryProductProtocolID` | bigint | not null |
| `references` | DeliveryProductProtocol |  |

**Indexes**:

- `IX_DeliveryProductProtocolDocument_DeliveryProductProtocolID`

---

## DeliveryProductProtocolNumber

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Number` | nvarchar(20) |  |

---

## DeliveryRecipient

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FullName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Priority` | int | default 0            not null |
| `MobilePhone` | nvarchar(max) |  |

**Indexes**:

- `IX_DeliveryRecipient_ClientID`

---

## DeliveryRecipientAddress

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DeliveryRecipientID` | bigint | not null |
| `references` | DeliveryRecipient |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(500) |  |
| `Priority` | int | default 0            not null |
| `City` | nvarchar(250) |  |
| `Department` | nvarchar(250) |  |

**Indexes**:

- `IX_DeliveryRecipientAddress_DeliveryRecipientID`

---

## DepreciatedConsumableOrder

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Comment` | nvarchar(250) |  |
| `CommissionHeadID` | bigint | not null |
| `references` | unknown | [User] |
| `Created` | datetime2 | default getutcdate() not null |
| `CreatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `Deleted` | bit | default 0            not null |
| `DepreciatedToID` | bigint | not null |
| `references` | unknown | [User] |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `ConsumablesStorageID` | bigint | default 0            not null |
| `references` | ConsumablesStorage |  |
| `Number` | nvarchar(50) |  |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |

**Indexes**:

- `IX_DepreciatedConsumableOrder_CommissionHeadID`
- `IX_DepreciatedConsumableOrder_CreatedByID`
- `IX_DepreciatedConsumableOrder_DepreciatedToID`
- `IX_DepreciatedConsumableOrder_ConsumablesStorageID`
- `IX_DepreciatedConsumableOrder_UpdatedByID`

---

## DepreciatedConsumableOrderItem

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumablesOrderItemID` | bigint | not null |
| `references` | ConsumablesOrderItem |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DepreciatedConsumableOrderID` | bigint | not null |
| `references` | DepreciatedConsumableOrder |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_DepreciatedConsumableOrderItem_ConsumablesOrderItemID`
- `IX_DepreciatedConsumableOrderItem_DepreciatedConsumableOrderID`

---

## DepreciatedOrder

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `IsManagement` | bit | default 0            not null |

**Indexes**:

- `IX_DepreciatedOrder_OrganizationID`
- `IX_DepreciatedOrder_ResponsibleID`
- `IX_DepreciatedOrder_StorageID`

---

## DepreciatedOrderItem

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `Reason` | nvarchar(150) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `DepreciatedOrderID` | bigint | not null |
| `references` | DepreciatedOrder |  |
| `ActReconciliationItemID` | bigint |  |
| `references` | ActReconciliationItem |  |

**Indexes**:

- `IX_DepreciatedOrderItem_DepreciatedOrderID`
- `IX_DepreciatedOrderItem_ProductID`
- `IX_DepreciatedOrderItem_ActReconciliationItemID`

---

## DocumentMonth

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CultureCode` | nvarchar(4) |  |
| `Name` | nvarchar(25) |  |
| `Number` | int | not null |

---

## DynamicProductPlacement

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `IsApplied` | bit | default 0            not null |
| `Qty` | float | not null |
| `StorageNumber` | nvarchar(5) |  |
| `RowNumber` | nvarchar(5) |  |
| `CellNumber` | nvarchar(5) |  |
| `DynamicProductPlacementRowID` | bigint | not null |
| `references` | DynamicProductPlacementRow |  |

**Indexes**:

- `IX_DynamicProductPlacement_DynamicProductPlacementRowID`

---

## DynamicProductPlacementColumn

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `SupplyOrderUkraineID` | bigint |  |
| `references` | SupplyOrderUkraine |  |
| `PackingListID` | bigint |  |
| `references` | PackingList |  |

**Indexes**:

- `IX_DynamicProductPlacementColumn_SupplyOrderUkraineID`
- `IX_DynamicProductPlacementColumn_PackingListID`

---

## DynamicProductPlacementRow

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `SupplyOrderUkraineItemID` | bigint |  |
| `references` | SupplyOrderUkraineItem |  |
| `DynamicProductPlacementColumnID` | bigint | not null |
| `references` | DynamicProductPlacementColumn |  |
| `Qty` | float | default 0.0000000000000000e+000 not null |
| `PackingListPackageOrderItemID` | bigint |  |
| `references` | PackingListPackageOrderItem |  |

**Indexes**:

- `IX_DynamicProductPlacementRow_DynamicProductPlacementColumnID`
- `IX_DynamicProductPlacementRow_SupplyOrderUkraineItemID`
- `IX_DynamicProductPlacementRow_PackingListPackageOrderItemID`

---

## EcommerceContactInfo

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Address` | nvarchar(250) | not null |
| `Phone` | nvarchar(30) | not null |
| `Email` | nvarchar(150) | not null |
| `SiteUrl` | nvarchar(200) | not null |
| `Locale` | nvarchar(2) |  |
| `PixelId` | nvarchar(200) |  |

---

## EcommerceContacts

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `Phone` | nvarchar(30) |  |
| `Skype` | nvarchar(150) |  |
| `Icq` | nvarchar(20) |  |
| `Email` | nvarchar(150) |  |
| `ImgUrl` | nvarchar(4000) |  |

---

## EcommerceDefaultPricing

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `PricingID` | bigint | not null |
| `references` | Pricing |  |
| `PromotionalPricingID` | bigint | not null |
| `references` | Pricing |  |

**Indexes**:

- `IX_EcommerceDefaultPricing_PricingID`
- `IX_EcommerceDefaultPricing_PromotionalPricingID`

---

## EcommercePage

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `PageName` | nvarchar(max) |  |
| `TitleUa` | nvarchar(100) |  |
| `TitleRu` | nvarchar(100) |  |
| `DescriptionUa` | nvarchar(1000) |  |
| `DescriptionRu` | nvarchar(1000) |  |
| `KeyWords` | nvarchar(1000) |  |
| `LdJson` | nvarchar(4000) |  |
| `UrlUa` | nvarchar(1000) |  |
| `UrlRu` | nvarchar(1000) |  |

---

## EcommerceRegion

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `NameUa` | nvarchar(150) |  |
| `IsLocalPayment` | bit | not null |
| `NameRu` | nvarchar(150) |  |

---

## ExchangeRate

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Culture` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Amount` | decimal(30, 14) | not null |
| `Currency` | nvarchar(max) |  |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |
| `Code` | nvarchar(max) |  |

**Indexes**:

- `IX_ExchangeRate_CurrencyID`

---

## ExchangeRateHistory

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | decimal(30, 14) | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `ExchangeRateID` | bigint | not null |
| `references` | ExchangeRate |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UpdatedByID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_ExchangeRateHistory_ExchangeRateID`
- `IX_ExchangeRateHistory_UpdatedByID`

---

## ExpiredBillUserNotification

**Columns**: 26 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `UserNotificationType` | int | not null |
| `Locked` | bit | not null |
| `Processed` | bit | not null |
| `CreatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `LockedByID` | bigint |  |
| `references` | unknown | [User] |
| `LastViewedByID` | bigint |  |
| `references` | unknown | [User] |
| `ProcessedByID` | bigint |  |
| `references` | unknown | [User] |
| `SaleNumber` | nvarchar(50) |  |
| `FromClient` | nvarchar(250) |  |
| `ExpiredDays` | float | not null |
| `Deferred` | bit | not null |
| `SaleID` | bigint | not null |
| `references` | Sale |  |
| `ManagerID` | bigint |  |
| `references` | unknown | [User] |
| `AppliedAction` | int | default 0            not null |

**Indexes**:

- `IX_ExpiredBillUserNotification_CreatedByID`
- `IX_ExpiredBillUserNotification_LastViewedByID`
- `IX_ExpiredBillUserNotification_LockedByID`
- `IX_ExpiredBillUserNotification_ManagerID`
- `IX_ExpiredBillUserNotification_ProcessedByID`
- `IX_ExpiredBillUserNotification_SaleID`

---

## FilterItem

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SQL` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `Type` | int | default 0            not null |
| `Order` | int | default 0            not null |

---

## FilterItemTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `FilterItemID` | bigint | not null |
| `references` | FilterItem |  |
| `on` | delete | cascade |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_FilterItemTranslation_FilterItemID`

---

## FilterOperationItem

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(25) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SQL` | nvarchar(25) |  |
| `Updated` | datetime2 | not null |

---

## FilterOperationItemTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `FilterOperationItemID` | bigint | not null |
| `references` | FilterOperationItem |  |
| `on` | delete | cascade |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_FilterOperationItemTranslation_FilterOperationItemID`

---

## GovCrossExchangeRate

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CurrencyFromID` | bigint | not null |
| `references` | Currency |  |
| `CurrencyToID` | bigint | not null |
| `references` | Currency |  |
| `Amount` | decimal(30, 14) | not null |
| `Code` | nvarchar(30) |  |
| `Culture` | nvarchar(5) |  |

**Indexes**:

- `IX_GovCrossExchangeRate_CurrencyFromID`
- `IX_GovCrossExchangeRate_CurrencyToID`

---

## GovCrossExchangeRateHistory

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Amount` | decimal(30, 14) | not null |
| `UpdatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `GovCrossExchangeRateID` | bigint | not null |
| `references` | GovCrossExchangeRate |  |

**Indexes**:

- `IX_GovCrossExchangeRateHistory_GovCrossExchangeRateID`
- `IX_GovCrossExchangeRateHistory_UpdatedByID`

---

## GovExchangeRate

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Culture` | nvarchar(max) |  |
| `Amount` | decimal(30, 14) | not null |
| `Currency` | nvarchar(max) |  |
| `Code` | nvarchar(max) |  |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |

**Indexes**:

- `IX_GovExchangeRate_CurrencyID`

---

## GovExchangeRateHistory

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Amount` | decimal(30, 14) | not null |
| `GovExchangeRateID` | bigint | not null |
| `references` | GovExchangeRate |  |
| `UpdatedByID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_GovExchangeRateHistory_GovExchangeRateID`
- `IX_GovExchangeRateHistory_UpdatedByID`

---

## HistoryInvoiceEdit

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `SaleID` | bigint | not null |
| `references` | Sale |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `IsDevelopment` | bit | default 0            not null |
| `ApproveUpdate` | bit | default 0            not null |
| `IsPrinted` | bit | default 0            not null |

**Indexes**:

- `IX_HistoryInvoiceEdit_SaleID`

---

## IncomePaymentOrder

**Columns**: 53 | **Foreign Keys**: 0 | **Indexes**: 13

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Account` | int | not null |
| `Amount` | money | not null |
| `BankAccount` | nvarchar(50) |  |
| `ClientID` | bigint |  |
| `references` | Client |  |
| `Comment` | nvarchar(450) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `Deleted` | bit | default 0            not null |
| `ExchangeRate` | money | not null |
| `FromDate` | datetime2 | not null |
| `IsAccounting` | bit | not null |
| `IsManagementAccounting` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(50) |  |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `PaymentRegisterID` | bigint | not null |
| `references` | PaymentRegister |  |
| `Updated` | datetime2 | not null |
| `VAT` | money | not null |
| `VatPercent` | float | not null |
| `IncomePaymentOrderType` | int | default 0            not null |
| `UserID` | bigint | default 0            not null |
| `references` | unknown | [User] |
| `ColleagueID` | bigint |  |
| `references` | unknown | [User] |
| `IsCanceled` | bit | default 0            not null |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |
| `EuroAmount` | money | default 0.0          not null |
| `OverpaidAmount` | money | default 0.0          not null |
| `AgreementEuroExchangeRate` | money | default 0.0          not null |
| `OrganizationClientAgreementID` | bigint |  |
| `references` | OrganizationClientAgreement |  |
| `OrganizationClientID` | bigint |  |
| `references` | OrganizationClient |  |
| `TaxFreeID` | bigint |  |
| `references` | TaxFree |  |
| `SadID` | bigint |  |
| `references` | Sad |  |
| `ArrivalNumber` | nvarchar(450) |  |
| `PaymentPurpose` | nvarchar(450) |  |
| `OperationType` | int | default 0            not null |
| `SupplyOrganizationAgreementID` | bigint |  |
| `references` | SupplyOrganizationAgreement |  |
| `SupplyOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `AgreementExchangedAmount` | money | default 0.0          not null |

**Indexes**:

- `IX_IncomePaymentOrder_ClientID`
- `IX_IncomePaymentOrder_CurrencyID`
- `IX_IncomePaymentOrder_OrganizationID`
- `IX_IncomePaymentOrder_PaymentRegisterID`
- `IX_IncomePaymentOrder_UserID`
- `IX_IncomePaymentOrder_ColleagueID`
- `IX_IncomePaymentOrder_ClientAgreementID`
- `IX_IncomePaymentOrder_OrganizationClientAgreementID`
- `IX_IncomePaymentOrder_OrganizationClientID`
- `IX_IncomePaymentOrder_TaxFreeID`
- `IX_IncomePaymentOrder_SadID`
- `IX_IncomePaymentOrder_SupplyOrganizationAgreementID`
- `IX_IncomePaymentOrder_SupplyOrganizationID`

---

## IncomePaymentOrderSale

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IncomePaymentOrderID` | bigint | not null |
| `references` | IncomePaymentOrder |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SaleID` | bigint |  |
| `references` | Sale |  |
| `Updated` | datetime2 | not null |
| `ExchangeRate` | money | default 0.0          not null |
| `OverpaidAmount` | money | default 0.0          not null |
| `ReSaleID` | bigint |  |
| `references` | ReSale |  |

**Indexes**:

- `IX_IncomePaymentOrderSale_IncomePaymentOrderID`
- `IX_IncomePaymentOrderSale_SaleID`
- `IX_IncomePaymentOrderSale_ReSaleID`

---

## Incoterm

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `IncotermName` | nvarchar(250) |  |

---

## InvoiceDocument

**Columns**: 38 | **Foreign Keys**: 0 | **Indexes**: 13

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyInvoiceID` | bigint |  |
| `references` | SupplyInvoice |  |
| `Updated` | datetime2 | not null |
| `ContentType` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `PortWorkServiceID` | bigint |  |
| `references` | PortWorkService |  |
| `TransportationServiceID` | bigint |  |
| `references` | TransportationService |  |
| `ContainerServiceID` | bigint |  |
| `references` | ContainerService |  |
| `CustomServiceID` | bigint |  |
| `references` | CustomService |  |
| `CustomAgencyServiceID` | bigint |  |
| `references` | CustomAgencyService |  |
| `PlaneDeliveryServiceID` | bigint |  |
| `references` | PlaneDeliveryService |  |
| `PortCustomAgencyServiceID` | bigint |  |
| `references` | PortCustomAgencyService |  |
| `VehicleDeliveryServiceID` | bigint |  |
| `references` | VehicleDeliveryService |  |
| `SupplyOrderPolandPaymentDeliveryProtocolID` | bigint |  |
| `references` | SupplyOrderPolandPaymentDeliveryProtocol |  |
| `PackingListID` | bigint |  |
| `references` | PackingList |  |
| `MergedServiceID` | bigint |  |
| `references` | MergedService |  |
| `VehicleServiceId` | bigint |  |
| `references` | VehicleService |  |
| `Type` | int | default 0            not null |

**Indexes**:

- `IX_InvoiceDocument_SupplyInvoiceID`
- `IX_InvoiceDocument_PortWorkServiceID`
- `IX_InvoiceDocument_TransportationServiceID`
- `IX_InvoiceDocument_ContainerServiceID`
- `IX_InvoiceDocument_CustomServiceID`
- `IX_InvoiceDocument_CustomAgencyServiceID`
- `IX_InvoiceDocument_SupplyOrderPolandPaymentDeliveryProtocolID`
- `IX_InvoiceDocument_PlaneDeliveryServiceID`
- `IX_InvoiceDocument_PortCustomAgencyServiceID`
- `IX_InvoiceDocument_VehicleDeliveryServiceID`
- `IX_InvoiceDocument_PackingListID`
- `IX_InvoiceDocument_MergedServiceID`
- `IX_InvoiceDocument_VehicleServiceId`

---

## MeasureUnitTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `MeasureUnitID` | bigint | not null |
| `references` | MeasureUnit |  |
| `on` | delete | cascade |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_MeasureUnitTranslation_MeasureUnitID`

---

## MergedService

**Columns**: 54 | **Foreign Keys**: 0 | **Indexes**: 14

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `FromDate` | datetime2 |  |
| `GrossPrice` | money | not null |
| `NetPrice` | money | not null |
| `Vat` | money | not null |
| `VatPercent` | float | not null |
| `Number` | nvarchar(50) |  |
| `ServiceNumber` | nvarchar(50) |  |
| `Name` | nvarchar(150) |  |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `SupplyOrganizationAgreementID` | bigint | not null |
| `references` | SupplyOrganizationAgreement |  |
| `SupplyOrganizationID` | bigint | not null |
| `references` | SupplyOrganization |  |
| `SupplyOrderID` | bigint |  |
| `references` | SupplyOrder |  |
| `SupplyOrderUkraineID` | bigint |  |
| `references` | SupplyOrderUkraine |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `DeliveryProductProtocolID` | bigint |  |
| `references` | DeliveryProductProtocol |  |
| `IsCalculatedValue` | bit | default 0                       not null |
| `IsAutoCalculatedValue` | bit | default 0                       not null |
| `SupplyExtraChargeType` | int | default 0                       not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `ConsumableProductID` | bigint |  |
| `references` | ConsumableProduct |  |
| `AccountingActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceID` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_MergedService_SupplyOrganizationAgreementID`
- `IX_MergedService_SupplyOrganizationID`
- `IX_MergedService_SupplyPaymentTaskID`
- `IX_MergedService_UserID`
- `IX_MergedService_SupplyOrderID`
- `IX_MergedService_SupplyOrderUkraineID`
- `IX_MergedService_AccountingPaymentTaskID`
- `IX_MergedService_DeliveryProductProtocolID`
- `IX_MergedService_SupplyInformationTaskID`
- `IX_MergedService_ActProvidingServiceDocumentID`
- `IX_MergedService_SupplyServiceAccountDocumentID`
- `IX_MergedService_ConsumableProductID`
- `IX_MergedService_AccountingActProvidingServiceID`
- `IX_MergedService_ActProvidingServiceID`

---

## MisplacedSale

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SaleID` | bigint |  |
| `RetailClientID` | bigint | not null |
| `references` | RetailClient |  |
| `MisplacedSaleStatus` | int | default 0            not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |

**Indexes**:

- `IX_MisplacedSale_RetailClientID`
- `IX_MisplacedSale_UserID`

---

## OrderItemBaseShiftStatus

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `ShiftStatus` | int | not null |
| `Updated` | datetime2 | not null |
| `Qty` | float | default 0.0000000000000000e+000 not null |
| `OrderItemID` | bigint | default 0                       not null |
| `references` | OrderItem |  |
| `SaleID` | bigint |  |
| `references` | Sale |  |
| `UserID` | bigint | default 0                       not null |
| `references` | unknown | [User] |
| `CurrentQty` | float | default 0.0000000000000000e+000 not null |
| `HistoryInvoiceEditID` | bigint |  |
| `references` | HistoryInvoiceEdit |  |

**Indexes**:

- `IX_OrderItemBaseShiftStatus_OrderItemID`
- `IX_OrderItemBaseShiftStatus_SaleID`
- `IX_OrderItemBaseShiftStatus_UserID`
- `IX_OrderItemBaseShiftStatus_HistoryInvoiceEditID`

---

## OrderItemMerged

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OldOrderID` | bigint | not null |
| `references` | unknown | [Order] |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `Updated` | datetime2 | not null |
| `OldOrderItemID` | bigint | default 0            not null |
| `references` | OrderItem |  |

**Indexes**:

- `IX_OrderItemMerged_OldOrderID`
- `IX_OrderItemMerged_OrderItemID`
- `IX_OrderItemMerged_OldOrderItemID`

---

## OrderItemMovement

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `MovementType` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `on` | delete | cascade |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |

**Indexes**:

- `IX_OrderItemMovement_OrderItemID`
- `IX_OrderItemMovement_UserID`

---

## OrderPackage

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CBM` | float | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Height` | int | not null |
| `Lenght` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderID` | bigint | not null |
| `references` | unknown | [Order] |
| `Updated` | datetime2 | not null |
| `Weight` | float | not null |
| `Width` | int | not null |

**Indexes**:

- `IX_OrderPackage_OrderID`

---

## OrderPackageItem

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `OrderPackageID` | bigint | not null |
| `references` | OrderPackage |  |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_OrderPackageItem_OrderItemID`
- `IX_OrderPackageItem_OrderPackageID`

---

## OrderPackageUser

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderPackageID` | bigint | not null |
| `references` | OrderPackage |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_OrderPackageUser_OrderPackageID`
- `IX_OrderPackageUser_UserID`

---

## OrderProductSpecification

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `SupplyInvoiceId` | bigint |  |
| `references` | SupplyInvoice |  |
| `ProductSpecificationId` | bigint | not null |
| `references` | ProductSpecification |  |
| `SadId` | bigint |  |
| `references` | Sad |  |
| `UnitPrice` | decimal(18, 2) | default 0.0          not null |

**Indexes**:

- `IX_OrderProductSpecification_ProductSpecificationId`
- `IX_OrderProductSpecification_SupplyInvoiceId`
- `IX_OrderProductSpecification_SadId`

---

## Organization

**Columns**: 31 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Code` | nvarchar(5) |  |
| `Culture` | nvarchar(max) |  |
| `Address` | nvarchar(250) |  |
| `FullName` | nvarchar(150) |  |
| `IsIndividual` | bit | default 0            not null |
| `PFURegistrationDate` | datetime2 |  |
| `PFURegistrationNumber` | nvarchar(150) |  |
| `PhoneNumber` | nvarchar(150) |  |
| `RegistrationDate` | datetime2 |  |
| `RegistrationNumber` | nvarchar(150) |  |
| `SROI` | nvarchar(150) |  |
| `TIN` | nvarchar(100) |  |
| `USREOU` | nvarchar(100) |  |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |
| `StorageID` | bigint |  |
| `TaxInspectionID` | bigint |  |
| `references` | TaxInspection |  |
| `Manager` | nvarchar(200) |  |
| `TypeTaxation` | int | default 0            not null |
| `VatRateID` | bigint |  |
| `references` | VatRate |  |
| `IsVatAgreements` | bit | default 0            not null |

**Indexes**:

- `IX_Organization_CurrencyID`
- `IX_Organization_StorageID`
- `IX_Organization_TaxInspectionID`
- `IX_Organization_VatRateID`

---

## OrganizationClient

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `FullName` | nvarchar(500) |  |
| `Address` | nvarchar(500) |  |
| `Country` | nvarchar(100) |  |
| `City` | nvarchar(100) |  |
| `NIP` | nvarchar(100) |  |
| `MarginAmount` | money | not null |

---

## OrganizationClientAgreement

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Number` | nvarchar(50) |  |
| `FromDate` | datetime2 | not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `OrganizationClientID` | bigint | not null |
| `references` | OrganizationClient |  |
| `AgreementTypeCivilCodeID` | bigint |  |
| `references` | AgreementTypeCivilCode |  |
| `TaxAccountingSchemeID` | bigint |  |
| `references` | TaxAccountingScheme |  |

**Indexes**:

- `IX_OrganizationClientAgreement_CurrencyID`
- `IX_OrganizationClientAgreement_OrganizationClientID`
- `IX_OrganizationClientAgreement_AgreementTypeCivilCodeID`
- `IX_OrganizationClientAgreement_TaxAccountingSchemeID`

---

## OrganizationTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_OrganizationTranslation_OrganizationID`

---

## OriginalNumber

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `MainNumber` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |

---

## OutcomePaymentOrder

**Columns**: 53 | **Foreign Keys**: 0 | **Indexes**: 13

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Account` | int | not null |
| `Amount` | money | not null |
| `Comment` | nvarchar(450) |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `FromDate` | datetime2 | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Number` | nvarchar(50) |  |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `PaymentCurrencyRegisterID` | bigint | not null |
| `references` | PaymentCurrencyRegister |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `IsUnderReport` | bit | default 0                       not null |
| `ColleagueID` | bigint |  |
| `references` | unknown | [User] |
| `IsUnderReportDone` | bit | default 0                       not null |
| `AdvanceNumber` | nvarchar(50) |  |
| `ConsumableProductOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `ExchangeRate` | money | not null |
| `AfterExchangeAmount` | money | default 0.0                     not null |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |
| `SupplyOrderPolandPaymentDeliveryProtocolID` | bigint |  |
| `references` | SupplyOrderPolandPaymentDeliveryProtocol |  |
| `SupplyOrganizationAgreementID` | bigint |  |
| `references` | SupplyOrganizationAgreement |  |
| `IsCanceled` | bit | default 0                       not null |
| `VAT` | money | default 0.0                     not null |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `OrganizationClientAgreementID` | bigint |  |
| `references` | OrganizationClientAgreement |  |
| `OrganizationClientID` | bigint |  |
| `references` | OrganizationClient |  |
| `TaxFreeID` | bigint |  |
| `references` | TaxFree |  |
| `SadID` | bigint |  |
| `references` | Sad |  |
| `OperationType` | int | default 0                       not null |
| `ClientID` | bigint |  |
| `references` | Client |  |
| `CustomNumber` | nvarchar(50) |  |
| `PaymentPurpose` | nvarchar(500) |  |
| `EuroAmount` | money | default 0.0                     not null |
| `ArrivalNumber` | nvarchar(100) |  |
| `IsAccounting` | bit | default CONVERT([bit], 0)       not null |
| `IsManagementAccounting` | bit | default CONVERT([bit], 0)       not null |

**Indexes**:

- `IX_OutcomePaymentOrder_OrganizationID`
- `IX_OutcomePaymentOrder_PaymentCurrencyRegisterID`
- `IX_OutcomePaymentOrder_UserID`
- `IX_OutcomePaymentOrder_ColleagueID`
- `IX_OutcomePaymentOrder_ConsumableProductOrganizationID`
- `IX_OutcomePaymentOrder_SupplyOrganizationAgreementID`
- `IX_OutcomePaymentOrder_ClientAgreementID`
- `IX_OutcomePaymentOrder_SupplyOrderPolandPaymentDeliveryProtocolID`
- `IX_OutcomePaymentOrder_OrganizationClientAgreementID`
- `IX_OutcomePaymentOrder_OrganizationClientID`
- `IX_OutcomePaymentOrder_TaxFreeID`
- `IX_OutcomePaymentOrder_SadID`
- `IX_OutcomePaymentOrder_ClientID`

---

## OutcomePaymentOrderConsumablesOrder

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumablesOrderID` | bigint | not null |
| `references` | ConsumablesOrder |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OutcomePaymentOrderID` | bigint | not null |
| `references` | OutcomePaymentOrder |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_OutcomePaymentOrderConsumablesOrder_ConsumablesOrderID`
- `IX_OutcomePaymentOrderConsumablesOrder_OutcomePaymentOrderID`

---

## OutcomePaymentOrderSupplyPaymentTask

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OutcomePaymentOrderID` | bigint | not null |
| `references` | OutcomePaymentOrder |  |
| `SupplyPaymentTaskID` | bigint | not null |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_OutcomePaymentOrderSupplyPaymentTask_OutcomePaymentOrderID`
- `IX_OutcomePaymentOrderSupplyPaymentTask_SupplyPaymentTaskID`

---

## PackingList

**Columns**: 30 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `MarkNumber` | nvarchar(100) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyInvoiceID` | bigint | not null |
| `references` | SupplyInvoice |  |
| `Updated` | datetime2 | not null |
| `FromDate` | datetime2 | default getutcdate() not null |
| `InvNo` | nvarchar(100) |  |
| `No` | nvarchar(100) |  |
| `PlNo` | nvarchar(100) |  |
| `RefNo` | nvarchar(100) |  |
| `IsDocumentsAdded` | bit | default 0            not null |
| `ContainerServiceID` | bigint |  |
| `references` | ContainerService |  |
| `ExtraCharge` | money | default 0.0          not null |
| `Comment` | nvarchar(500) |  |
| `IsPlaced` | bit | default 0            not null |
| `IsVatOneApplied` | bit | default 0            not null |
| `IsVatTwoApplied` | bit | default 0            not null |
| `VatOnePercent` | decimal(18, 2) | default 0.0          not null |
| `VatTwoPercent` | decimal(18, 2) | default 0.0          not null |
| `VehicleServiceId` | bigint |  |
| `references` | VehicleService |  |
| `AccountingExtraCharge` | money | default 0.0          not null |
| `RootPackingListID` | bigint |  |
| `references` | PackingList |  |

**Indexes**:

- `IX_PackingList_SupplyInvoiceID`
- `IX_PackingList_ContainerServiceID`
- `IX_PackingList_VehicleServiceId`
- `IX_PackingList_RootPackingListID`

---

## PackingListDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |
| `ContentType` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |

**Indexes**:

- `IX_PackingListDocument_SupplyOrderID`

---

## PackingListPackage

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `CBM` | float | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `GrossWeight` | float | not null |
| `Height` | int | not null |
| `Lenght` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `NetWeight` | float | not null |
| `PackingListID` | bigint | not null |
| `references` | PackingList |  |
| `Type` | int | not null |
| `Updated` | datetime2 | not null |
| `Width` | int | not null |

**Indexes**:

- `IX_PackingListPackage_PackingListID`

---

## PackingListPackageOrderItem

**Columns**: 37 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `PackingListID` | bigint |  |
| `references` | PackingList |  |
| `PackingListPackageID` | bigint |  |
| `references` | PackingListPackage |  |
| `Qty` | float | not null |
| `SupplyInvoiceOrderItemID` | bigint | not null |
| `references` | SupplyInvoiceOrderItem |  |
| `Updated` | datetime2 | not null |
| `GrossWeight` | float | default 0.0000000000000000e+000 not null |
| `IsErrorInPlaced` | bit | default 0                       not null |
| `IsPlaced` | bit | default 0                       not null |
| `IsReadyToPlaced` | bit | default 0                       not null |
| `NetWeight` | float | default 0.0000000000000000e+000 not null |
| `UnitPrice` | money | default 0.0                     not null |
| `UploadedQty` | float | default 0.0000000000000000e+000 not null |
| `Placement` | nvarchar(25) |  |
| `RemainingQty` | float | default 0.0000000000000000e+000 not null |
| `UnitPriceEur` | money | default 0.0                     not null |
| `GrossUnitPriceEur` | decimal(30, 14) | not null |
| `ContainerUnitPriceEur` | money | default 0.0                     not null |
| `ExchangeRateAmount` | money | default 0.0                     not null |
| `VatAmount` | money | default 0.0                     not null |
| `VatPercent` | money | default 0.0                     not null |
| `PlacedQty` | float | default 0.0000000000000000e+000 not null |
| `AccountingGrossUnitPriceEur` | decimal(30, 14) | default 0.0                     not null |
| `AccountingContainerUnitPriceEur` | money | default 0.0                     not null |
| `AccountingGeneralGrossUnitPriceEur` | decimal(30, 14) | default 0.0                     not null |
| `ExchangeRateAmountUahToEur` | money | default 0.0                     not null |
| `DeliveryPerItem` | decimal(30, 14) | default 0.0                     not null |
| `ProductIsImported` | bit | default 0                       not null |
| `UnitPriceEurWithVat` | decimal(30, 14) | default 0.0                     not null |

**Indexes**:

- `IX_PackingListPackageOrderItem_PackingListID`
- `IX_PackingListPackageOrderItem_PackingListPackageID`
- `IX_PackingListPackageOrderItem_SupplyInvoiceOrderItemID`

---

## PackingListPackageOrderItemSupplyService

**Columns**: 38 | **Foreign Keys**: 0 | **Indexes**: 13

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `NetValue` | decimal(30, 14) | not null |
| `Name` | nvarchar(250) |  |
| `ExchangeRateDate` | datetime2 | default getutcdate() not null |
| `PackingListPackageOrderItemID` | bigint | not null |
| `references` | PackingListPackageOrderItem |  |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `BillOfLadingServiceID` | bigint |  |
| `references` | BillOfLadingService |  |
| `ContainerServiceID` | bigint |  |
| `references` | ContainerService |  |
| `CustomAgencyServiceID` | bigint |  |
| `references` | CustomAgencyService |  |
| `CustomServiceID` | bigint |  |
| `references` | CustomService |  |
| `MergedServiceID` | bigint |  |
| `references` | MergedService |  |
| `PlaneDeliveryServiceID` | bigint |  |
| `references` | PlaneDeliveryService |  |
| `PortCustomAgencyServiceID` | bigint |  |
| `references` | PortCustomAgencyService |  |
| `PortWorkServiceID` | bigint |  |
| `references` | PortWorkService |  |
| `TransportationServiceID` | bigint |  |
| `references` | TransportationService |  |
| `VehicleDeliveryServiceID` | bigint |  |
| `references` | VehicleDeliveryService |  |
| `VehicleServiceID` | bigint |  |
| `references` | VehicleService |  |
| `GeneralValue` | decimal(30, 14) | not null |
| `ManagementValue` | decimal(30, 14) | not null |

**Indexes**:

- `IX_PackingListPackageOrderItemSupplyService_BillOfLadingServiceID`
- `IX_PackingListPackageOrderItemSupplyService_ContainerServiceID`
- `IX_PackingListPackageOrderItemSupplyService_CurrencyID`
- `IX_PackingListPackageOrderItemSupplyService_CustomAgencyServiceID`
- `IX_PackingListPackageOrderItemSupplyService_CustomServiceID`
- `IX_PackingListPackageOrderItemSupplyService_MergedServiceID`
- `IX_PackingListPackageOrderItemSupplyService_PackingListPackageOrderItemID`
- `IX_PackingListPackageOrderItemSupplyService_PlaneDeliveryServiceID`
- `IX_PackingListPackageOrderItemSupplyService_PortCustomAgencyServiceID`
- `IX_PackingListPackageOrderItemSupplyService_PortWorkServiceID`
- `IX_PackingListPackageOrderItemSupplyService_TransportationServiceID`
- `IX_PackingListPackageOrderItemSupplyService_VehicleDeliveryServiceID`
- `IX_PackingListPackageOrderItemSupplyService_VehicleServiceID`

---

## PackingMarking

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## PackingMarkingPayment

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## PaymentCostMovement

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OperationName` | nvarchar(150) |  |
| `Updated` | datetime2 | not null |

---

## PaymentCostMovementOperation

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ConsumablesOrderItemID` | bigint |  |
| `references` | ConsumablesOrderItem |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DepreciatedConsumableOrderItemID` | bigint |  |
| `references` | DepreciatedConsumableOrderItem |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentCostMovementID` | bigint | not null |
| `references` | PaymentCostMovement |  |
| `Updated` | datetime2 | not null |
| `CompanyCarFuelingID` | bigint |  |
| `references` | CompanyCarFueling |  |

**Indexes**:

- `IX_PaymentCostMovementOperation_ConsumablesOrderItemID`
- `IX_PaymentCostMovementOperation_DepreciatedConsumableOrderItemID`
- `IX_PaymentCostMovementOperation_PaymentCostMovementID`
- `IX_PaymentCostMovementOperation_CompanyCarFuelingID`

---

## PaymentCostMovementTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OperationName` | nvarchar(150) |  |
| `PaymentCostMovementID` | bigint | not null |
| `references` | PaymentCostMovement |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PaymentCostMovementTranslation_PaymentCostMovementID`

---

## PaymentCurrencyRegister

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentRegisterID` | bigint | not null |
| `references` | PaymentRegister |  |
| `Updated` | datetime2 | not null |
| `InitialAmount` | money | default 0.0          not null |

**Indexes**:

- `IX_PaymentCurrencyRegister_CurrencyID`
- `IX_PaymentCurrencyRegister_PaymentRegisterID`

---

## PaymentDeliveryDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrderPaymentDeliveryProtocolID` | bigint | not null |
| `references` | SupplyOrderPaymentDeliveryProtocol |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PaymentDeliveryDocument_SupplyOrderPaymentDeliveryProtocolID`

---

## PaymentMovement

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `OperationName` | nvarchar(150) |  |

---

## PaymentMovementOperation

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IncomePaymentOrderID` | bigint |  |
| `references` | IncomePaymentOrder |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentMovementID` | bigint | not null |
| `references` | PaymentMovement |  |
| `PaymentRegisterCurrencyExchangeID` | bigint |  |
| `references` | PaymentRegisterCurrencyExchange |  |
| `PaymentRegisterTransferID` | bigint |  |
| `references` | PaymentRegisterTransfer |  |
| `Updated` | datetime2 | not null |
| `OutcomePaymentOrderID` | bigint |  |
| `references` | OutcomePaymentOrder |  |

**Indexes**:

- `IX_PaymentMovementOperation_IncomePaymentOrderID`
- `IX_PaymentMovementOperation_PaymentMovementID`
- `IX_PaymentMovementOperation_PaymentRegisterCurrencyExchangeID`
- `IX_PaymentMovementOperation_PaymentRegisterTransferID`
- `IX_PaymentMovementOperation_OutcomePaymentOrderID`

---

## PaymentMovementTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentMovementID` | bigint | not null |
| `references` | PaymentMovement |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PaymentMovementTranslation_PaymentMovementID`

---

## PaymentRegister

**Columns**: 24 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Type` | int | default 0            not null |
| `OrganizationID` | bigint | default 0            not null |
| `references` | Organization |  |
| `AccountNumber` | nvarchar(50) |  |
| `BankName` | nvarchar(100) |  |
| `City` | nvarchar(100) |  |
| `FromDate` | datetime2 |  |
| `IBAN` | nvarchar(50) |  |
| `SortCode` | nvarchar(20) |  |
| `SwiftCode` | nvarchar(50) |  |
| `ToDate` | datetime2 |  |
| `IsActive` | bit | default 0            not null |
| `IsMain` | bit | default 0            not null |
| `IsForRetail` | bit | default 0            not null |
| `CVV` | nvarchar(3) |  |
| `IsSelected` | bit | default 0            not null |

**Indexes**:

- `IX_PaymentRegister_OrganizationID`

---

## PaymentRegisterCurrencyExchange

**Columns**: 21 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate()              not null |
| `Deleted` | bit | default 0                         not null |
| `ExchangeRate` | money | not null |
| `FromPaymentCurrencyRegisterID` | bigint | not null |
| `references` | PaymentCurrencyRegister |  |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `ToPaymentCurrencyRegisterID` | bigint | not null |
| `references` | PaymentCurrencyRegister |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `CurrencyTraderID` | bigint |  |
| `references` | CurrencyTrader |  |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(450) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.000' not null |
| `IsCanceled` | bit | default 0                         not null |
| `IncomeNumber` | nvarchar(150) |  |

**Indexes**:

- `IX_PaymentRegisterCurrencyExchange_FromPaymentCurrencyRegisterID`
- `IX_PaymentRegisterCurrencyExchange_ToPaymentCurrencyRegisterID`
- `IX_PaymentRegisterCurrencyExchange_UserID`
- `IX_PaymentRegisterCurrencyExchange_CurrencyTraderID`

---

## PaymentRegisterTransfer

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Amount` | money | not null |
| `Created` | datetime2 | default getutcdate()              not null |
| `Deleted` | bit | default 0                         not null |
| `FromPaymentCurrencyRegisterID` | bigint | not null |
| `references` | PaymentCurrencyRegister |  |
| `NetUID` | uniqueidentifier | default newid()                   not null |
| `ToPaymentCurrencyRegisterID` | bigint | not null |
| `references` | PaymentCurrencyRegister |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(450) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.000' not null |
| `IsCanceled` | bit | default 0                         not null |
| `TypeOfOperation` | int | default 0                         not null |

**Indexes**:

- `IX_PaymentRegisterTransfer_FromPaymentCurrencyRegisterID`
- `IX_PaymentRegisterTransfer_ToPaymentCurrencyRegisterID`
- `IX_PaymentRegisterTransfer_UserID`

---

## PerfectClient

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsSelected` | bit | default 0            not null |
| `Lable` | nvarchar(100) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |
| `Type` | int | default 1            not null |
| `Description` | nvarchar(250) |  |
| `ClientTypeRoleID` | bigint |  |
| `references` | ClientTypeRole |  |

**Indexes**:

- `IX_PerfectClient_ClientTypeRoleID`

---

## PerfectClientTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 70) |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Description` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PerfectClientID` | bigint | not null |
| `references` | PerfectClient |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PerfectClientTranslation_PerfectClientID`

---

## PerfectClientValue

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsSelected` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PerfectClientID` | bigint | not null |
| `references` | PerfectClient |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |

**Indexes**:

- `IX_PerfectClientValue_PerfectClientID`

---

## PerfectClientValueTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PerfectClientValueID` | bigint | not null |
| `references` | PerfectClientValue |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |

**Indexes**:

- `IX_PerfectClientValueTranslation_PerfectClientValueID`

---

## Permission

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ControlId` | nvarchar(max) |  |
| `Name` | nvarchar(500) |  |
| `ImageUrl` | nvarchar(max) |  |
| `Description` | nvarchar(500) |  |
| `DashboardNodeID` | bigint | not null |
| `references` | DashboardNode |  |
| `on` | delete | cascade |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_Permission_DashboardNodeID`

---

## PlaneDeliveryService

**Columns**: 43 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `FromDate` | datetime2 |  |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `PlaneDeliveryOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `GrossPrice` | money | default 0.0                     not null |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_PlaneDeliveryService_PlaneDeliveryOrganizationID`
- `IX_PlaneDeliveryService_SupplyPaymentTaskID`
- `IX_PlaneDeliveryService_UserID`
- `IX_PlaneDeliveryService_SupplyOrganizationAgreementID`
- `IX_PlaneDeliveryService_AccountingPaymentTaskID`
- `IX_PlaneDeliveryService_SupplyInformationTaskID`
- `IX_PlaneDeliveryService_ActProvidingServiceDocumentID`
- `IX_PlaneDeliveryService_SupplyServiceAccountDocumentID`
- `IX_PlaneDeliveryService_AccountingActProvidingServiceId`
- `IX_PlaneDeliveryService_ActProvidingServiceId`

---

## PortCustomAgencyService

**Columns**: 43 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `FromDate` | datetime2 |  |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `PortCustomAgencyOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `GrossPrice` | money | default 0.0                     not null |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_PortCustomAgencyService_PortCustomAgencyOrganizationID`
- `IX_PortCustomAgencyService_SupplyPaymentTaskID`
- `IX_PortCustomAgencyService_UserID`
- `IX_PortCustomAgencyService_SupplyOrganizationAgreementID`
- `IX_PortCustomAgencyService_AccountingPaymentTaskID`
- `IX_PortCustomAgencyService_SupplyInformationTaskID`
- `IX_PortCustomAgencyService_ActProvidingServiceDocumentID`
- `IX_PortCustomAgencyService_SupplyServiceAccountDocumentID`
- `IX_PortCustomAgencyService_AccountingActProvidingServiceId`
- `IX_PortCustomAgencyService_ActProvidingServiceId`

---

## PortWorkService

**Columns**: 43 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `PortWorkOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `GrossPrice` | money | default 0.0                     not null |
| `FromDate` | datetime2 |  |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_PortWorkService_SupplyPaymentTaskID`
- `IX_PortWorkService_UserID`
- `IX_PortWorkService_PortWorkOrganizationID`
- `IX_PortWorkService_SupplyOrganizationAgreementID`
- `IX_PortWorkService_AccountingPaymentTaskID`
- `IX_PortWorkService_SupplyInformationTaskID`
- `IX_PortWorkService_ActProvidingServiceDocumentID`
- `IX_PortWorkService_SupplyServiceAccountDocumentID`
- `IX_PortWorkService_AccountingActProvidingServiceId`
- `IX_PortWorkService_ActProvidingServiceId`

---

## PreOrder

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Comment` | nvarchar(250) |  |
| `MobileNumber` | nvarchar(25) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `ClientID` | bigint |  |
| `references` | Client |  |
| `Qty` | float | default 0.0000000000000000e+000 not null |
| `Culture` | nvarchar(4) |  |

**Indexes**:

- `IX_PreOrder_ClientID`
- `IX_PreOrder_ProductID`

---

## PriceType

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(30) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## PriceTypeTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(50) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PriceTypeID` | bigint | not null |
| `references` | PriceType |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PriceTypeTranslation_PriceTypeID`

---

## Pricing

**Columns**: 20 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `BasePricingID` | bigint |  |
| `references` | Pricing |  |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |
| `Deleted` | bit | default 0            not null |
| `ExtraCharge` | float |  |
| `Name` | nvarchar(30) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `PriceTypeID` | bigint |  |
| `references` | PriceType |  |
| `Culture` | nvarchar(max) |  |
| `CalculatedExtraCharge` | money | default 0.0          not null |
| `ForShares` | bit | default 0            not null |
| `ForVat` | bit | default 0            not null |
| `SortingPriority` | int | default 0            not null |

**Indexes**:

- `IX_Pricing_BasePricingID`
- `IX_Pricing_CurrencyID`
- `IX_Pricing_PriceTypeID`

---

## PricingProductGroupDiscount

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Amount` | money | not null |
| `BasePricingID` | bigint |  |
| `references` | Pricing |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PricingID` | bigint | not null |
| `references` | Pricing |  |
| `ProductGroupID` | bigint | not null |
| `references` | ProductGroup |  |
| `Updated` | datetime2 | not null |
| `CalculatedExtraCharge` | money | default 0.0          not null |

**Indexes**:

- `IX_PricingProductGroupDiscount_BasePricingID`
- `IX_PricingProductGroupDiscount_PricingID`
- `IX_PricingProductGroupDiscount_ProductGroupID`

---

## PricingTranslation

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(30) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PricingID` | bigint | not null |
| `references` | Pricing |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_PricingTranslation_PricingID_CultureCode_Deleted`

---

## ProFormDocument

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyProFormID` | bigint | not null |
| `references` | SupplyProForm |  |
| `Updated` | datetime2 | not null |
| `ContentType` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |

**Indexes**:

- `IX_ProFormDocument_SupplyProFormID`

---

## ProductAvailabilityCartLimits

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ProductId` | bigint | not null |
| `unique` | unknown |  |
| `references` | Product |  |
| `MinAvailabilityUA` | float | not null |
| `check` | unknown | ([MinAvailabilityUA] >= 1) |
| `MaxAvailabilityUA` | float | not null |
| `check` | unknown | ([MaxAvailabilityUA] >= 1) |
| `MinAvailabilityPL` | float | not null |
| `check` | unknown | ([MinAvailabilityPL] >= 1) |
| `check` | unknown | ([MaxAvailabilityUA] > [MinAvailabilityUA]) |

---

## ProductCapitalization

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `StorageID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Storage |  |

**Indexes**:

- `IX_ProductCapitalization_OrganizationID`
- `IX_ProductCapitalization_ResponsibleID`
- `IX_ProductCapitalization_StorageID`

---

## ProductCapitalizationItem

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `RemainingQty` | float | not null |
| `Weight` | float | not null |
| `UnitPrice` | money | not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `ProductCapitalizationID` | bigint | not null |
| `references` | ProductCapitalization |  |

**Indexes**:

- `IX_ProductCapitalizationItem_ProductCapitalizationID`
- `IX_ProductCapitalizationItem_ProductID`

---

## ProductCarBrand

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CarBrandID` | bigint | not null |
| `references` | CarBrand |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |

**Indexes**:

- `IX_ProductCarBrand_CarBrandID`
- `IX_ProductCarBrand_ProductID`

---

## ProductGroupDiscount

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ClientAgreementID` | bigint | not null |
| `references` | ClientAgreement |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DiscountRate` | float | not null |
| `IsActive` | bit | default 1            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductGroupID` | bigint | not null |
| `references` | ProductGroup |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProductGroupDiscount_ClientAgreementID`
- `IX_ProductGroupDiscount_ProductGroupID`

---

## ProductIncome

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `FromDate` | datetime2 | not null |
| `Number` | nvarchar(50) |  |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `Comment` | nvarchar(500) |  |
| `ProductIncomeType` | int | default 0                 not null |
| `IsHide` | bit | default 0                 not null |
| `IsFromOneC` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_ProductIncome_StorageID`
- `IX_ProductIncome_UserID`

---

## ProductIncomeItem

**Columns**: 27 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Updated` | datetime2 | not null |
| `SaleReturnItemID` | bigint |  |
| `references` | SaleReturnItem |  |
| `on` | delete | cascade |
| `ProductIncomeID` | bigint | not null |
| `references` | ProductIncome |  |
| `on` | delete | cascade |
| `PackingListPackageOrderItemID` | bigint |  |
| `references` | PackingListPackageOrderItem |  |
| `on` | delete | cascade |
| `Qty` | float | default 0.0000000000000000e+000 not null |
| `SupplyOrderUkraineItemID` | bigint |  |
| `references` | SupplyOrderUkraineItem |  |
| `on` | delete | cascade |
| `RemainingQty` | float | default 0.0000000000000000e+000 not null |
| `ActReconciliationItemID` | bigint |  |
| `references` | ActReconciliationItem |  |
| `on` | delete | cascade |
| `ProductCapitalizationItemID` | bigint |  |
| `references` | ProductCapitalizationItem |  |
| `on` | delete | cascade |

**Indexes**:

- `IX_ProductIncomeItem_ProductIncomeID`
- `IX_ProductIncomeItem_PackingListPackageOrderItemID`
- `IX_ProductIncomeItem_SaleReturnItemID`
- `IX_ProductIncomeItem_SupplyOrderUkraineItemID`
- `IX_ProductIncomeItem_ActReconciliationItemID`
- `IX_ProductIncomeItem_ProductCapitalizationItemID`

---

## ProductLocation

**Columns**: 19 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Qty` | float | not null |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `ProductPlacementID` | bigint | not null |
| `references` | ProductPlacement |  |
| `OrderItemID` | bigint |  |
| `references` | OrderItem |  |
| `DepreciatedOrderItemID` | bigint |  |
| `references` | DepreciatedOrderItem |  |
| `ProductTransferItemID` | bigint |  |
| `references` | ProductTransferItem |  |
| `InvoiceDocumentQty` | float | default 0.0000000000000000e+000 not null |

**Indexes**:

- `IX_ProductLocation_OrderItemID`
- `IX_ProductLocation_ProductPlacementID`
- `IX_ProductLocation_StorageID`
- `IX_ProductLocation_DepreciatedOrderItemID`
- `IX_ProductLocation_ProductTransferItemID`

---

## ProductLocationHistory

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Qty` | float | not null |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `ProductPlacementID` | bigint | not null |
| `references` | ProductPlacement |  |
| `OrderItemID` | bigint |  |
| `references` | OrderItem |  |
| `DepreciatedOrderItemID` | bigint |  |
| `references` | DepreciatedOrderItem |  |
| `TypeOfMovement` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `HistoryInvoiceEditID` | bigint |  |
| `references` | HistoryInvoiceEdit |  |

**Indexes**:

- `IX_ProductLocationHistory_DepreciatedOrderItemID`
- `IX_ProductLocationHistory_OrderItemID`
- `IX_ProductLocationHistory_ProductPlacementID`
- `IX_ProductLocationHistory_StorageID`
- `IX_ProductLocationHistory_HistoryInvoiceEditID`

---

## ProductPlacement

**Columns**: 25 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `Qty` | float | not null |
| `StorageNumber` | nvarchar(5) |  |
| `RowNumber` | nvarchar(5) |  |
| `CellNumber` | nvarchar(5) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `PackingListPackageOrderItemID` | bigint |  |
| `references` | PackingListPackageOrderItem |  |
| `SupplyOrderUkraineItemID` | bigint |  |
| `references` | SupplyOrderUkraineItem |  |
| `ProductIncomeItemID` | bigint |  |
| `references` | ProductIncomeItem |  |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |
| `IsOriginal` | bit | default CONVERT([bit], 0) not null |
| `IsHistorySet` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_ProductPlacement_ProductID`
- `IX_ProductPlacement_StorageID`
- `IX_ProductPlacement_PackingListPackageOrderItemID`
- `IX_ProductPlacement_SupplyOrderUkraineItemID`
- `IX_ProductPlacement_ProductIncomeItemID`
- `IX_ProductPlacement_ConsignmentItemID`

---

## ProductPlacementHistory

**Columns**: 19 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Placement` | nvarchar(500) |  |
| `ProductId` | bigint | not null |
| `references` | Product |  |
| `on` | delete | cascade |
| `StorageId` | bigint | not null |
| `references` | Storage |  |
| `on` | delete | cascade |
| `Qty` | float | not null |
| `StorageLocationType` | int | not null |
| `AdditionType` | int | not null |
| `UserId` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_ProductPlacementHistory_ProductId`
- `IX_ProductPlacementHistory_StorageId`
- `IX_ProductPlacementHistory_UserId`

---

## ProductPlacementMovement

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Qty` | float | not null |
| `FromProductPlacementID` | bigint | not null |
| `references` | ProductPlacement |  |
| `ToProductPlacementID` | bigint | not null |
| `references` | ProductPlacement |  |
| `Comment` | nvarchar(500) |  |
| `Number` | nvarchar(50) |  |
| `ResponsibleID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_ProductPlacementMovement_FromProductPlacementID`
- `IX_ProductPlacementMovement_ToProductPlacementID`
- `IX_ProductPlacementMovement_ResponsibleID`

---

## ProductPlacementStorage

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Qty` | float | not null |
| `Placement` | nvarchar(500) |  |
| `VendorCode` | nvarchar(max) |  |
| `ProductPlacementId` | bigint | not null |
| `references` | ProductPlacement |  |
| `on` | delete | cascade |
| `ProductId` | bigint | not null |
| `references` | Product |  |
| `on` | delete | cascade |
| `StorageId` | bigint | not null |
| `references` | Storage |  |
| `on` | delete | cascade |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_ProductPlacementStorage_ProductId`
- `IX_ProductPlacementStorage_ProductPlacementId`
- `IX_ProductPlacementStorage_StorageId`

---

## ProductProductGroup

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `ProductGroupID` | bigint | not null |
| `references` | ProductGroup |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Updated` | datetime2 | not null |
| `OrderStandard` | float | default 0.0000000000000000e+000 not null |
| `VendorCode` | nvarchar(50) |  |

**Indexes**:

- `IX_ProductProductGroup_ProductGroupID`
- `IX_ProductProductGroup_ProductID`
- `IX_ProductProductGroup_Deleted_ProductGroupID`
- `IX_ProductProductGroup_Deleted_ProductID`
- `IX_ProductProductGroup_Deleted_ProductID_ProductGroupID`

---

## ProductReservation

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `on` | delete | cascade |
| `ProductAvailabilityID` | bigint | not null |
| `references` | ProductAvailability |  |
| `on` | delete | cascade |
| `Qty` | float | not null |
| `Updated` | datetime2 | not null |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |
| `IsReSaleReservation` | bit | default 0            not null |

**Indexes**:

- `IX_ProductReservation_OrderItemID`
- `IX_ProductReservation_ProductAvailabilityID`
- `IX_ProductReservation_ConsignmentItemID`

---

## ProductSet

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `BaseProductID` | bigint | not null |
| `references` | Product |  |
| `ComponentProductID` | bigint | not null |
| `references` | Product |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `SetComponentsQty` | int | default 1            not null |

**Indexes**:

- `IX_ProductSet_BaseProductID`
- `IX_ProductSet_ComponentProductID`
- `IX_ProductSet_Deleted_BaseProductID`
- `IX_ProductSet_Deleted_ComponentProductID`

---

## ProductSlug

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Url` | nvarchar(250) |  |
| `Locale` | nvarchar(4) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |

**Indexes**:

- `IX_ProductSlug_ProductID`

---

## ProductTransfer

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `FromStorageID` | bigint | not null |
| `references` | Storage |  |
| `ToStorageID` | bigint | not null |
| `references` | Storage |  |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `IsManagement` | bit | default 0            not null |

**Indexes**:

- `IX_ProductTransfer_FromStorageID`
- `IX_ProductTransfer_OrganizationID`
- `IX_ProductTransfer_ResponsibleID`
- `IX_ProductTransfer_ToStorageID`

---

## ProductTransferItem

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `Reason` | nvarchar(150) |  |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `ProductTransferID` | bigint | not null |
| `references` | ProductTransfer |  |
| `ActReconciliationItemID` | bigint |  |
| `references` | ActReconciliationItem |  |

**Indexes**:

- `IX_ProductTransferItem_ActReconciliationItemID`
- `IX_ProductTransferItem_ProductID`
- `IX_ProductTransferItem_ProductTransferID`

---

## ProductWriteOffRule

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `RuleLocale` | nvarchar(4) |  |
| `RuleType` | int | not null |
| `CreatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `ProductID` | bigint |  |
| `references` | Product |  |
| `on` | delete | cascade |
| `ProductGroupID` | bigint |  |
| `references` | ProductGroup |  |
| `on` | delete | cascade |

**Indexes**:

- `IX_ProductWriteOffRule_CreatedByID`
- `IX_ProductWriteOffRule_ProductGroupID`
- `IX_ProductWriteOffRule_ProductID`
- `IX_ProductWriteOffRule_UpdatedByID`

---

## ProviderPricing

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `BasePricingID` | bigint |  |
| `references` | Pricing |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrencyID` | bigint |  |
| `references` | Currency |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ProviderPricing_BasePricingID`
- `IX_ProviderPricing_CurrencyID`

---

## ReSale

**Columns**: 26 | **Foreign Keys**: 0 | **Indexes**: 8

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Comment` | nvarchar(250) |  |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `SaleNumberID` | bigint |  |
| `references` | SaleNumber |  |
| `ChangedToInvoice` | datetime2 |  |
| `ChangedToInvoiceByID` | bigint |  |
| `references` | unknown | [User] |
| `BaseLifeCycleStatusID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | BaseLifeCycleStatus |  |
| `BaseSalePaymentStatusID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | BaseSalePaymentStatus |  |
| `FromStorageID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Storage |  |
| `IsCompleted` | bit | default 0                    not null |
| `TotalPaymentAmount` | decimal(30, 14) | default 0.0                  not null |

**Indexes**:

- `IX_ReSale_ClientAgreementID`
- `IX_ReSale_OrganizationID`
- `IX_ReSale_UserID`
- `IX_ReSale_SaleNumberID`
- `IX_ReSale_ChangedToInvoiceByID`
- `IX_ReSale_BaseLifeCycleStatusID`
- `IX_ReSale_BaseSalePaymentStatusID`
- `IX_ReSale_FromStorageID`

---

## ReSaleAvailability

**Columns**: 26 | **Foreign Keys**: 0 | **Indexes**: 7

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Qty` | float | not null |
| `RemainingQty` | float | not null |
| `ConsignmentItemID` | bigint | not null |
| `references` | ConsignmentItem |  |
| `ProductAvailabilityID` | bigint | not null |
| `references` | ProductAvailability |  |
| `OrderItemID` | bigint |  |
| `references` | OrderItem |  |
| `ProductTransferItemID` | bigint |  |
| `references` | ProductTransferItem |  |
| `DepreciatedOrderItemID` | bigint |  |
| `references` | DepreciatedOrderItem |  |
| `ProductReservationID` | bigint |  |
| `references` | ProductReservation |  |
| `PricePerItem` | decimal(30, 14) | not null |
| `ExchangeRate` | money | not null |
| `SupplyReturnItemId` | bigint |  |
| `references` | SupplyReturnItem |  |
| `InvoiceQty` | float | default 0.0000000000000000e+000 not null |

**Indexes**:

- `IX_ReSaleAvailability_ConsignmentItemID`
- `IX_ReSaleAvailability_DepreciatedOrderItemID`
- `IX_ReSaleAvailability_OrderItemID`
- `IX_ReSaleAvailability_ProductAvailabilityID`
- `IX_ReSaleAvailability_ProductReservationID`
- `IX_ReSaleAvailability_ProductTransferItemID`
- `IX_ReSaleAvailability_SupplyReturnItemId`

---

## ReSaleItem

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Qty` | float | not null |
| `ReSaleAvailabilityID` | bigint |  |
| `references` | ReSaleAvailability |  |
| `ReSaleID` | bigint | not null |
| `references` | ReSale |  |
| `PricePerItem` | decimal(30, 14) | not null |
| `ExchangeRate` | money | default 0.0                  not null |
| `ExtraCharge` | decimal(18, 2) | default 0.0                  not null |
| `ProductID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Product |  |

**Indexes**:

- `IX_ReSaleItem_ReSaleID`
- `IX_ReSaleItem_ReSaleAvailabilityID`
- `IX_ReSaleItem_ProductID`

---

## RegionCode

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(10) |  |
| `RegionID` | bigint | default 0            not null |
| `references` | Region |  |
| `City` | nvarchar(150) |  |
| `District` | nvarchar(150) |  |

**Indexes**:

- `IX_RegionCode_RegionID`

---

## ResidenceCard

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ToDate` | datetime2 | not null |
| `Updated` | datetime2 | not null |

---

## ResponsibilityDeliveryProtocol

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |
| `SupplyOrderStatus` | int | default 0            not null |
| `UserId` | bigint | default 0            not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_ResponsibilityDeliveryProtocol_SupplyOrderID`
- `IX_ResponsibilityDeliveryProtocol_UserId`

---

## RetailClient

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(150) |  |
| `PhoneNumber` | nvarchar(max) | not null |
| `ShoppingCartJson` | nvarchar(max) |  |
| `EcommerceRegionId` | bigint |  |
| `references` | EcommerceRegion |  |

**Indexes**:

- `IX_RetailClient_EcommerceRegionId`

---

## RetailClientPaymentImage

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `RetailClientId` | bigint | not null |
| `references` | RetailClient |  |
| `SaleId` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Sale |  |
| `RetailPaymentStatusId` | bigint | not null |
| `references` | RetailPaymentStatus |  |
| `on` | delete | cascade |

**Indexes**:

- `IX_RetailClientPaymentImage_RetailClientId`
- `IX_RetailClientPaymentImage_SaleId`
- `IX_RetailClientPaymentImage_RetailPaymentStatusId`

---

## RetailClientPaymentImageItem

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `ImgUrl` | nvarchar(1000) |  |
| `Amount` | money | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `RetailClientPaymentImageID` | bigint | not null |
| `references` | RetailClientPaymentImage |  |
| `PaymentType` | int | default 0            not null |
| `Comment` | nvarchar(500) |  |
| `IsLocked` | bit | default 0            not null |

**Indexes**:

- `IX_RetailClientPaymentImageItem_RetailClientPaymentImageID`
- `IX_RetailClientPaymentImageItem_UserID`

---

## RetailPaymentStatus

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `RetailPaymentStatusType` | int | not null |
| `Amount` | decimal(18, 2) | not null |
| `PaidAmount` | decimal(18, 2) | default 0.0          not null |

---

## RetailPaymentTypeTranslate

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `LowPrice` | nvarchar(250) |  |
| `CultureCode` | nvarchar(5) |  |
| `FullPrice` | nvarchar(250) |  |
| `Comment` | nvarchar(500) |  |
| `FastOrderSuccessMessage` | nvarchar(500) |  |
| `ScreenshotMessage` | nvarchar(max) |  |

---

## RolePermission

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `UserRoleID` | bigint | not null |
| `references` | UserRole |  |
| `on` | delete | cascade |
| `PermissionID` | bigint | not null |
| `references` | Permission |  |
| `on` | delete | cascade |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_RolePermission_PermissionID`
- `IX_RolePermission_UserRoleID`

---

## Sad

**Columns**: 34 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Deleted` | bit | default 0                             not null |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Updated` | datetime2 | not null |
| `Comment` | nvarchar(500) |  |
| `IsSend` | bit | default 0                             not null |
| `Number` | nvarchar(50) |  |
| `ResponsibleID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | unknown | [User] |
| `StathamCarID` | bigint |  |
| `references` | StathamCar |  |
| `StathamID` | bigint |  |
| `references` | Statham |  |
| `OrganizationID` | bigint |  |
| `references` | Organization |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `SupplyOrderUkraineID` | bigint |  |
| `references` | SupplyOrderUkraine |  |
| `MarginAmount` | money | default 0.0                           not null |
| `OrganizationClientID` | bigint |  |
| `references` | OrganizationClient |  |
| `OrganizationClientAgreementID` | bigint |  |
| `references` | OrganizationClientAgreement |  |
| `IsFromSale` | bit | default 0                             not null |
| `SadType` | int | default 0                             not null |
| `ClientID` | bigint |  |
| `references` | Client |  |
| `StathamPassportID` | bigint |  |
| `references` | StathamPassport |  |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |
| `VatPercent` | money | default 0.0                           not null |

**Indexes**:

- `IX_Sad_ResponsibleID`
- `IX_Sad_StathamCarID`
- `IX_Sad_StathamID`
- `IX_Sad_OrganizationID`
- `IX_Sad_SupplyOrderUkraineID`
- `IX_Sad_OrganizationClientID`
- `IX_Sad_OrganizationClientAgreementID`
- `IX_Sad_ClientID`
- `IX_Sad_StathamPassportID`
- `IX_Sad_ClientAgreementID`

---

## SadDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ContentType` | nvarchar(250) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(250) |  |
| `FileName` | nvarchar(250) |  |
| `GeneratedName` | nvarchar(250) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SadID` | bigint | not null |
| `references` | Sad |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SadDocument_SadID`

---

## SadItem

**Columns**: 22 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Qty` | float | not null |
| `Comment` | nvarchar(500) |  |
| `SadID` | bigint | not null |
| `references` | Sad |  |
| `SupplyOrderUkraineCartItemID` | bigint |  |
| `references` | SupplyOrderUkraineCartItem |  |
| `OrderItemID` | bigint |  |
| `references` | OrderItem |  |
| `SupplierID` | bigint |  |
| `references` | Client |  |
| `NetWeight` | float | default 0.0000000000000000e+000 not null |
| `UnitPrice` | money | default 0.0                     not null |
| `UnpackedQty` | float | default 0.0000000000000000e+000 not null |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |

**Indexes**:

- `IX_SadItem_SadID`
- `IX_SadItem_SupplyOrderUkraineCartItemID`
- `IX_SadItem_OrderItemID`
- `IX_SadItem_SupplierID`
- `IX_SadItem_ConsignmentItemID`

---

## SadPallet

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SadID` | bigint | not null |
| `references` | Sad |  |
| `SadPalletTypeID` | bigint | not null |
| `references` | SadPalletType |  |
| `Comment` | nvarchar(250) |  |
| `Number` | nvarchar(50) |  |

**Indexes**:

- `IX_SadPallet_SadID`
- `IX_SadPallet_SadPalletTypeID`

---

## SadPalletItem

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `SadItemID` | bigint | not null |
| `references` | SadItem |  |
| `SadPalletID` | bigint | not null |
| `references` | SadPallet |  |

**Indexes**:

- `IX_SadPalletItem_SadItemID`
- `IX_SadPalletItem_SadPalletID`

---

## SadPalletType

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(100) |  |
| `CssClass` | nvarchar(50) |  |
| `Weight` | float | not null |

---

## SaleBaseShiftStatus

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ShiftStatus` | int | not null |
| `Updated` | datetime2 | not null |

---

## SaleExchangeRate

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `ExchangeRateID` | bigint | not null |
| `references` | ExchangeRate |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SaleID` | bigint | not null |
| `references` | Sale |  |
| `Updated` | datetime2 | not null |
| `Value` | money | not null |

**Indexes**:

- `IX_SaleExchangeRate_ExchangeRateID`
- `IX_SaleExchangeRate_SaleID`

---

## SaleFutureReservation

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `Count` | float | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `RemindDate` | datetime2 | not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SaleFutureReservation_ClientID`
- `IX_SaleFutureReservation_ProductID`
- `IX_SaleFutureReservation_SupplyOrderID`

---

## SaleInvoiceDocument

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `City` | nvarchar(max) |  |
| `ClientPaymentType` | int | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentType` | int | not null |
| `Updated` | datetime2 | not null |
| `Vat` | money | default 0.0          not null |
| `ShippingAmount` | money | default 0.0          not null |
| `ShippingAmountEur` | money | default 0.0          not null |
| `ExchangeRateAmount` | money | default 0.0          not null |
| `ShippingAmountWithoutVat` | money | default 0.0          not null |
| `ShippingAmountEurWithoutVat` | money | default 0.0          not null |

---

## SaleInvoiceNumber

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(50) |  |
| `Updated` | datetime2 | not null |

---

## SaleMerged

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `InputSaleID` | bigint | not null |
| `references` | Sale |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `OutputSaleID` | bigint | not null |
| `references` | Sale |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SaleMerged_InputSaleID`
- `IX_SaleMerged_OutputSaleID_Deleted`

---

## SaleMessageNumerator

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CountMessage` | bigint | not null |
| `Transfered` | bit | not null |

---

## SaleNumber

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Value` | nvarchar(max) |  |
| `OrganizationID` | bigint | default 0            not null |
| `references` | Organization |  |

**Indexes**:

- `IX_SaleNumber_OrganizationID`

---

## SaleReturn

**Columns**: 19 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `FromDate` | datetime2 | not null |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `CreatedByID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `Number` | nvarchar(50) |  |
| `IsCanceled` | bit | default 0                    not null |
| `CanceledByID` | bigint |  |
| `references` | unknown | [User] |
| `ClientAgreementID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | ClientAgreement |  |

**Indexes**:

- `IX_SaleReturn_ClientID`
- `IX_SaleReturn_CreatedByID`
- `IX_SaleReturn_UpdatedByID`
- `IX_SaleReturn_CanceledByID`
- `IX_SaleReturn_ClientAgreementID`

---

## SaleReturnItem

**Columns**: 25 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Qty` | float | not null |
| `SaleReturnItemStatus` | int | not null |
| `IsMoneyReturned` | bit | default 0                    not null |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `SaleReturnID` | bigint | not null |
| `references` | SaleReturn |  |
| `CreatedByID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | unknown | [User] |
| `MoneyReturnedByID` | bigint |  |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `MoneyReturnedAt` | datetime2 |  |
| `Amount` | decimal(30, 14) | default 0                    not null |
| `ExchangeRateAmount` | money | default 0.0                  not null |
| `StorageID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Storage |  |

**Indexes**:

- `IX_SaleReturnItem_OrderItemID`
- `IX_SaleReturnItem_SaleReturnID`
- `IX_SaleReturnItem_CreatedByID`
- `IX_SaleReturnItem_MoneyReturnedByID`
- `IX_SaleReturnItem_UpdatedByID`
- `IX_SaleReturnItem_StorageID`

---

## SaleReturnItemProductPlacement

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ProductPlacementID` | bigint |  |
| `references` | ProductPlacement |  |
| `SaleReturnItemId` | bigint | not null |
| `references` | SaleReturnItem |  |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Qty` | float | default 0.0000000000000000e+000 not null |

**Indexes**:

- `IX_SaleReturnItemProductPlacement_ProductPlacementID`
- `IX_SaleReturnItemProductPlacement_SaleReturnItemId`

---

## SaleReturnItemStatusName

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SaleReturnItemStatus` | int | not null |
| `NameUK` | nvarchar(120) |  |
| `NamePL` | nvarchar(120) |  |

---

## SeoPage

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `PageName` | nvarchar(max) |  |
| `Title` | nvarchar(100) |  |
| `Description` | nvarchar(1000) |  |
| `KeyWords` | nvarchar(1000) |  |
| `LdJson` | nvarchar(4000) |  |
| `Url` | nvarchar(1000) |  |
| `Locale` | nvarchar(max) |  |

---

## ServiceDetailItem

**Columns**: 30 | **Foreign Keys**: 0 | **Indexes**: 9

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CustomAgencyServiceID` | bigint |  |
| `references` | CustomAgencyService |  |
| `CustomServiceID` | bigint |  |
| `references` | CustomService |  |
| `Deleted` | bit | default 0            not null |
| `GrossPrice` | decimal(18, 2) | not null |
| `NetPrice` | decimal(18, 2) | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PlaneDeliveryServiceID` | bigint |  |
| `references` | PlaneDeliveryService |  |
| `PortCustomAgencyServiceID` | bigint |  |
| `references` | PortCustomAgencyService |  |
| `PortWorkServiceID` | bigint |  |
| `references` | PortWorkService |  |
| `Qty` | float | not null |
| `TransportationServiceID` | bigint |  |
| `references` | TransportationService |  |
| `UnitPrice` | decimal(18, 2) | not null |
| `Updated` | datetime2 | not null |
| `Vat` | decimal(18, 2) | not null |
| `VatPercent` | float | not null |
| `VehicleDeliveryServiceID` | bigint |  |
| `references` | VehicleDeliveryService |  |
| `ServiceDetailItemKeyID` | bigint | default 0            not null |
| `references` | ServiceDetailItemKey |  |
| `MergedServiceID` | bigint |  |
| `references` | MergedService |  |

**Indexes**:

- `IX_ServiceDetailItem_CustomAgencyServiceID`
- `IX_ServiceDetailItem_CustomServiceID`
- `IX_ServiceDetailItem_PlaneDeliveryServiceID`
- `IX_ServiceDetailItem_PortCustomAgencyServiceID`
- `IX_ServiceDetailItem_PortWorkServiceID`
- `IX_ServiceDetailItem_TransportationServiceID`
- `IX_ServiceDetailItem_VehicleDeliveryServiceID`
- `IX_ServiceDetailItem_ServiceDetailItemKeyID`
- `IX_ServiceDetailItem_MergedServiceID`

---

## ServiceDetailItemKey

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Symbol` | nvarchar(max) |  |
| `Type` | int | not null |
| `Updated` | datetime2 | not null |

---

## ServicePayer

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FirstName` | nvarchar(max) |  |
| `LastName` | nvarchar(max) |  |
| `MiddleName` | nvarchar(max) |  |
| `MobilePhone` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `PaymentAddress` | nvarchar(max) |  |
| `PaymentCard` | nvarchar(max) |  |
| `ServiceType` | int | not null |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_ServicePayer_ClientID`

---

## ShipmentList

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `IsSent` | bit | not null |
| `TransporterID` | bigint | not null |
| `references` | Transporter |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |

**Indexes**:

- `IX_ShipmentList_ResponsibleID`
- `IX_ShipmentList_TransporterID`

---

## ShipmentListItem

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `Comment` | nvarchar(500) |  |
| `QtyPlaces` | float | not null |
| `SaleID` | bigint | not null |
| `references` | Sale |  |
| `ShipmentListID` | bigint | not null |
| `references` | ShipmentList |  |
| `IsChangeTransporter` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_ShipmentListItem_SaleID`
- `IX_ShipmentListItem_ShipmentListID`

---

## Statham

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FirstName` | nvarchar(50) |  |
| `LastName` | nvarchar(50) |  |
| `MiddleName` | nvarchar(50) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## StathamCar

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(150) |  |
| `StathamID` | bigint | not null |
| `references` | Statham |  |
| `Updated` | datetime2 | not null |
| `Volume` | float | not null |

**Indexes**:

- `IX_StathamCar_StathamID`

---

## StathamPassport

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `PassportSeria` | nvarchar(20) |  |
| `PassportNumber` | nvarchar(20) |  |
| `PassportIssuedBy` | nvarchar(250) |  |
| `City` | nvarchar(150) |  |
| `Street` | nvarchar(150) |  |
| `HouseNumber` | nvarchar(50) |  |
| `PassportIssuedDate` | datetime2 | not null |
| `PassportCloseDate` | datetime2 | not null |
| `StathamID` | bigint | not null |
| `references` | Statham |  |

**Indexes**:

- `IX_StathamPassport_StathamID`

---

## Storage

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(40) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `Locale` | nvarchar(10) |  |
| `OrganizationID` | bigint |  |
| `references` | Organization |  |
| `ForDefective` | bit | default 0            not null |
| `ForVatProducts` | bit | default 0            not null |
| `AvailableForReSale` | bit | default 0            not null |
| `ForEcommerce` | bit | default 0            not null |
| `RetailPriority` | int | default 0            not null |
| `IsResale` | bit | default 0            not null |

**Indexes**:

- `IX_Storage_OrganizationID`

---

## SupplyDeliveryDocument

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `TransportationType` | int | default 0            not null |

---

## SupplyInformationDeliveryProtocol

**Columns**: 19 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrderID` | bigint |  |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `SupplyInvoiceID` | bigint |  |
| `references` | SupplyInvoice |  |
| `Value` | nvarchar(max) |  |
| `SupplyInformationDeliveryProtocolKeyID` | bigint | default 0            not null |
| `references` | SupplyInformationDeliveryProtocolKey |  |
| `on` | delete | cascade |
| `SupplyProFormID` | bigint |  |
| `references` | SupplyProForm |  |
| `IsDefault` | bit | default 0            not null |

**Indexes**:

- `IX_SupplyInformationDeliveryProtocol_SupplyOrderID`
- `IX_SupplyInformationDeliveryProtocol_SupplyProFormID`
- `IX_SupplyInformationDeliveryProtocol_UserID`
- `IX_SupplyInformationDeliveryProtocol_SupplyInvoiceID`
- `IX_SupplyInformationDeliveryProtocol_SupplyInformationDeliveryProtocolKeyID`

---

## SupplyInformationDeliveryProtocolKey

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 70) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Key` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `IsDefault` | bit | default 0            not null |
| `KeyAssignedTo` | int | default 0            not null |
| `TransportationType` | int | default 0            not null |

---

## SupplyInformationDeliveryProtocolKeyTranslation

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `Key` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyInformationDeliveryProtocolKeyID` | bigint | not null |
| `references` | SupplyInformationDeliveryProtocolKey |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SupplyInformationDeliveryProtocolKeyTranslation_SupplyInformationDeliveryProtocolKeyID`

---

## SupplyInformationTask

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `DeletedByID` | bigint |  |
| `references` | unknown | [User] |
| `GrossPrice` | money | not null |

**Indexes**:

- `IX_SupplyInformationTask_DeletedByID`
- `IX_SupplyInformationTask_UpdatedByID`
- `IX_SupplyInformationTask_UserID`

---

## SupplyInvoice

**Columns**: 27 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetPrice` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(100) |  |
| `Updated` | datetime2 | not null |
| `IsShipped` | bit | default 0            not null |
| `DateFrom` | datetime2 |  |
| `SupplyOrderID` | bigint | default 0            not null |
| `references` | SupplyOrder |  |
| `PaymentTo` | datetime2 |  |
| `ExtraCharge` | money | default 0.0          not null |
| `ServiceNumber` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `IsFullyPlaced` | bit | default 0            not null |
| `IsPartiallyPlaced` | bit | default 0            not null |
| `DeliveryProductProtocolID` | bigint |  |
| `references` | DeliveryProductProtocol |  |
| `DateCustomDeclaration` | datetime2 |  |
| `NumberCustomDeclaration` | nvarchar(100) |  |
| `DeliveryAmount` | money | default 0.0          not null |
| `DiscountAmount` | money | default 0.0          not null |
| `RootSupplyInvoiceID` | bigint |  |
| `references` | SupplyInvoice |  |

**Indexes**:

- `IX_SupplyInvoice_SupplyOrderID`
- `IX_SupplyInvoice_DeliveryProductProtocolID`
- `IX_SupplyInvoice_RootSupplyInvoiceID`

---

## SupplyInvoiceBillOfLadingService

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SupplyInvoiceID` | bigint | not null |
| `references` | SupplyInvoice |  |
| `BillOfLadingServiceID` | bigint | not null |
| `references` | BillOfLadingService |  |
| `AccountingValue` | decimal(30, 14) | not null |
| `Value` | decimal(30, 14) | not null |
| `IsCalculatedValue` | bit | default 0            not null |

**Indexes**:

- `IX_SupplyInvoiceBillOfLadingService_BillOfLadingServiceID`
- `IX_SupplyInvoiceBillOfLadingService_SupplyInvoiceID`

---

## SupplyInvoiceDeliveryDocument

**Columns**: 16 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SupplyInvoiceID` | bigint | not null |
| `references` | SupplyInvoice |  |
| `SupplyDeliveryDocumentID` | bigint | not null |
| `references` | SupplyDeliveryDocument |  |
| `DocumentUrl` | nvarchar(500) |  |
| `FileName` | nvarchar(500) |  |
| `GeneratedName` | nvarchar(500) |  |
| `Number` | nvarchar(20) |  |
| `ContentType` | nvarchar(500) |  |

**Indexes**:

- `IX_SupplyInvoiceDeliveryDocument_SupplyDeliveryDocumentID`
- `IX_SupplyInvoiceDeliveryDocument_SupplyInvoiceID`

---

## SupplyInvoiceMergedService

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SupplyInvoiceID` | bigint | not null |
| `references` | SupplyInvoice |  |
| `MergedServiceID` | bigint | not null |
| `references` | MergedService |  |
| `AccountingValue` | decimal(30, 14) | not null |
| `Value` | decimal(30, 14) | not null |
| `IsCalculatedValue` | bit | default 0            not null |

**Indexes**:

- `IX_SupplyInvoiceMergedService_MergedServiceID`
- `IX_SupplyInvoiceMergedService_SupplyInvoiceID`

---

## SupplyInvoiceOrderItem

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()         not null |
| `Deleted` | bit | default 0                    not null |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Qty` | float | not null |
| `SupplyInvoiceID` | bigint | not null |
| `references` | SupplyInvoice |  |
| `SupplyOrderItemID` | bigint |  |
| `references` | SupplyOrderItem |  |
| `Updated` | datetime2 | not null |
| `UnitPrice` | money | default 0.0                  not null |
| `RowNumber` | int | default 0                    not null |
| `ProductIsImported` | bit | default 0                    not null |
| `ProductID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | Product |  |

**Indexes**:

- `IX_SupplyInvoiceOrderItem_SupplyInvoiceID`
- `IX_SupplyInvoiceOrderItem_SupplyOrderItemID`
- `IX_SupplyInvoiceOrderItem_ProductID`

---

## SupplyOrder

**Columns**: 59 | **Foreign Keys**: 0 | **Indexes**: 13

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetPrice` | money | not null |
| `ClientID` | bigint | not null |
| `references` | Client |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `Qty` | float | not null |
| `SupplyOrderNumberID` | bigint | not null |
| `references` | SupplyOrderNumber |  |
| `on` | delete | cascade |
| `SupplyProFormID` | bigint |  |
| `references` | SupplyProForm |  |
| `Updated` | datetime2 | not null |
| `DateFrom` | datetime2 |  |
| `PortWorkServiceID` | bigint |  |
| `references` | PortWorkService |  |
| `TransportationServiceID` | bigint |  |
| `references` | TransportationService |  |
| `GrossPrice` | money | default 0.0                     not null |
| `CustomAgencyServiceID` | bigint |  |
| `references` | CustomAgencyService |  |
| `PortCustomAgencyServiceID` | bigint |  |
| `references` | PortCustomAgencyService |  |
| `PlaneDeliveryServiceID` | bigint |  |
| `references` | PlaneDeliveryService |  |
| `VehicleDeliveryServiceID` | bigint |  |
| `references` | VehicleDeliveryService |  |
| `TransportationType` | int | default 0                       not null |
| `IsDocumentSet` | bit | default 0                       not null |
| `IsCompleted` | bit | default 0                       not null |
| `IsOrderShipped` | bit | default 0                       not null |
| `OrderShippedDate` | datetime2 |  |
| `CompleteDate` | datetime2 |  |
| `ShipArrived` | datetime2 |  |
| `PlaneArrived` | datetime2 |  |
| `VechicalArrived` | datetime2 |  |
| `IsOrderArrived` | bit | default 0                       not null |
| `OrderArrivedDate` | datetime2 |  |
| `IsPlaced` | bit | default 0                       not null |
| `Comment` | nvarchar(500) |  |
| `ClientAgreementID` | bigint | default CONVERT([bigint], 0)    not null |
| `references` | ClientAgreement |  |
| `IsGrossPricesCalculated` | bit | default 0                       not null |
| `IsFullyPlaced` | bit | default 0                       not null |
| `IsPartiallyPlaced` | bit | default 0                       not null |
| `IsOrderInsidePoland` | bit | default 0                       not null |
| `AdditionalAmount` | money | not null |
| `AdditionalPercent` | float | default 0.0000000000000000e+000 not null |
| `AdditionalPaymentCurrencyID` | bigint |  |
| `references` | Currency |  |
| `AdditionalPaymentFromDate` | datetime2 |  |
| `IsApproved` | bit | default 0                       not null |
| `ResponsibleId` | bigint |  |
| `references` | unknown | [User] |

**Indexes**:

- `IX_SupplyOrder_ClientID`
- `IX_SupplyOrder_OrganizationID`
- `IX_SupplyOrder_SupplyOrderNumberID`
- `IX_SupplyOrder_SupplyProFormID`
- `IX_SupplyOrder_CustomAgencyServiceID`
- `IX_SupplyOrder_PortWorkServiceID`
- `IX_SupplyOrder_TransportationServiceID`
- `IX_SupplyOrder_PortCustomAgencyServiceID`
- `IX_SupplyOrder_PlaneDeliveryServiceID`
- `IX_SupplyOrder_VehicleDeliveryServiceID`
- `IX_SupplyOrder_ClientAgreementID`
- `IX_SupplyOrder_AdditionalPaymentCurrencyID`
- `IX_SupplyOrder_ResponsibleId`

---

## SupplyOrderContainerService

**Columns**: 10 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ContainerServiceID` | bigint | not null |
| `references` | ContainerService |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SupplyOrderContainerService_ContainerServiceID`
- `IX_SupplyOrderContainerService_SupplyOrderID`

---

## SupplyOrderDeliveryDocument

**Columns**: 21 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Comment` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsReceived` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ProcessedDate` | datetime2 | not null |
| `SupplyDeliveryDocumentID` | bigint | not null |
| `references` | SupplyDeliveryDocument |  |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `IsProcessed` | bit | default 0            not null |
| `IsNotified` | bit | default 0            not null |
| `ContentType` | nvarchar(max) |  |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |

**Indexes**:

- `IX_SupplyOrderDeliveryDocument_SupplyOrderID`
- `IX_SupplyOrderDeliveryDocument_UserID`
- `IX_SupplyOrderDeliveryDocument_SupplyDeliveryDocumentID`

---

## SupplyOrderItem

**Columns**: 20 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `Description` | nvarchar(max) |  |
| `ItemNo` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `Qty` | float | not null |
| `StockNo` | nvarchar(max) |  |
| `SupplyOrderID` | bigint |  |
| `references` | SupplyOrder |  |
| `TotalAmount` | money | not null |
| `UnitPrice` | money | not null |
| `Updated` | datetime2 | not null |
| `GrossWeight` | float | default 0.0000000000000000e+000 not null |
| `NetWeight` | float | default 0.0000000000000000e+000 not null |
| `IsPacked` | bit | default 0                       not null |

**Indexes**:

- `IX_SupplyOrderItem_ProductID`
- `IX_SupplyOrderItem_SupplyOrderID`

---

## SupplyOrderNumber

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |

---

## SupplyOrderPaymentDeliveryProtocol

**Columns**: 20 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Value` | money | not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `SupplyInvoiceID` | bigint |  |
| `references` | SupplyInvoice |  |
| `SupplyOrderPaymentDeliveryProtocolKeyID` | bigint | default 0                       not null |
| `references` | SupplyOrderPaymentDeliveryProtocolKey |  |
| `on` | delete | cascade |
| `SupplyProFormID` | bigint |  |
| `references` | SupplyProForm |  |
| `Discount` | float | default 0.0000000000000000e+000 not null |
| `IsAccounting` | bit | default 0                       not null |

**Indexes**:

- `IX_SupplyOrderPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKeyID`
- `IX_SupplyOrderPaymentDeliveryProtocol_SupplyPaymentTaskID`
- `IX_SupplyOrderPaymentDeliveryProtocol_SupplyInvoiceID`
- `IX_SupplyOrderPaymentDeliveryProtocol_UserID`
- `IX_SupplyOrderPaymentDeliveryProtocol_SupplyProFormID`

---

## SupplyOrderPaymentDeliveryProtocolKey

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Key` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## SupplyOrderPolandPaymentDeliveryProtocol

**Columns**: 24 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `GrossPrice` | money | not null |
| `Name` | nvarchar(max) |  |
| `NetPrice` | money | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(max) |  |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `SupplyOrderPaymentDeliveryProtocolKeyID` | bigint | not null |
| `references` | SupplyOrderPaymentDeliveryProtocolKey |  |
| `on` | delete | cascade |
| `SupplyPaymentTaskID` | bigint | not null |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `Vat` | money | not null |
| `VatPercent` | float | not null |
| `ServiceNumber` | nvarchar(50) |  |
| `IsAccounting` | bit | default 0            not null |

**Indexes**:

- `IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderID`
- `IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKeyID`
- `IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyPaymentTaskID`
- `IX_SupplyOrderPolandPaymentDeliveryProtocol_UserID`

---

## SupplyOrderUkraine

**Columns**: 32 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                             not null |
| `FromDate` | datetime2 | not null |
| `IsPlaced` | bit | not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `ClientAgreementID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | ClientAgreement |  |
| `SupplierID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | Client |  |
| `ShipmentAmount` | decimal(30, 14) | not null |
| `IsDirectFromSupplier` | bit | default 0                             not null |
| `InvNumber` | nvarchar(50) |  |
| `AdditionalAmount` | money | default 0.0                           not null |
| `AdditionalPaymentCurrencyID` | bigint |  |
| `references` | Currency |  |
| `AdditionalPercent` | float | default 0.0000000000000000e+000       not null |
| `AdditionalPaymentFromDate` | datetime2 |  |
| `InvDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `VatPercent` | money | default 0.0                           not null |
| `ShipmentAmountLocal` | decimal(30, 14) | default 0.0                           not null |
| `IsPartialPlaced` | bit | default 0                             not null |
| `TotalAccountingDeliveryExpenseAmount` | decimal(18, 2) | default 0.0                           not null |
| `TotalDeliveryExpenseAmount` | decimal(18, 2) | default 0.0                           not null |

**Indexes**:

- `IX_SupplyOrderUkraine_OrganizationID`
- `IX_SupplyOrderUkraine_ResponsibleID`
- `IX_SupplyOrderUkraine_ClientAgreementID`
- `IX_SupplyOrderUkraine_SupplierID`
- `IX_SupplyOrderUkraine_AdditionalPaymentCurrencyID`

---

## SupplyOrderUkraineCartItem

**Columns**: 30 | **Foreign Keys**: 0 | **Indexes**: 7

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                             not null |
| `Comment` | nvarchar(500) |  |
| `UploadedQty` | float | not null |
| `ItemPriority` | int | not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `CreatedByID` | bigint | not null |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `ResponsibleID` | bigint |  |
| `references` | unknown | [User] |
| `ReservedQty` | float | default 0.0000000000000000e+000       not null |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `TaxFreePackListID` | bigint |  |
| `references` | TaxFreePackList |  |
| `UnpackedQty` | float | default 0.0000000000000000e+000       not null |
| `NetWeight` | float | default 0.0000000000000000e+000       not null |
| `UnitPrice` | money | default 0.0                           not null |
| `SupplierID` | bigint |  |
| `references` | Client |  |
| `PackingListPackageOrderItemID` | bigint |  |
| `references` | PackingListPackageOrderItem |  |
| `MaxQtyPerTF` | int | default 0                             not null |
| `IsRecommended` | bit | default 0                             not null |

**Indexes**:

- `IX_SupplyOrderUkraineCartItem_CreatedByID`
- `IX_SupplyOrderUkraineCartItem_ProductID`
- `IX_SupplyOrderUkraineCartItem_ResponsibleID`
- `IX_SupplyOrderUkraineCartItem_UpdatedByID`
- `IX_SupplyOrderUkraineCartItem_TaxFreePackListID`
- `IX_SupplyOrderUkraineCartItem_SupplierID`
- `IX_SupplyOrderUkraineCartItem_PackingListPackageOrderItemID`

---

## SupplyOrderUkraineCartItemReservation

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `ProductAvailabilityID` | bigint | not null |
| `references` | ProductAvailability |  |
| `SupplyOrderUkraineCartItemID` | bigint | not null |
| `references` | SupplyOrderUkraineCartItem |  |
| `on` | delete | cascade |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |

**Indexes**:

- `IX_SupplyOrderUkraineCartItemReservation_ProductAvailabilityID`
- `IX_SupplyOrderUkraineCartItemReservation_SupplyOrderUkraineCartItemID`
- `IX_SupplyOrderUkraineCartItemReservation_ConsignmentItemID`

---

## SupplyOrderUkraineCartItemReservationProductPlacement

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `ProductPlacementID` | bigint | not null |
| `references` | ProductPlacement |  |
| `SupplyOrderUkraineCartItemReservationID` | bigint | not null |
| `references` | SupplyOrderUkraineCartItemReservation |  |
| `on` | delete | cascade |

**Indexes**:

- `IX_SupplyOrderUkraineCartItemReservationProductPlacement_ProductPlacementID`
- `IX_SupplyOrderUkraineCartItemReservationProductPlacement_SupplyOrderUkraineCartItemReservationID`

---

## SupplyOrderUkraineDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(500) |  |
| `FileName` | nvarchar(500) |  |
| `ContentType` | nvarchar(500) |  |
| `GeneratedName` | nvarchar(500) |  |
| `SupplyOrderUkraineID` | bigint | not null |
| `references` | SupplyOrderUkraine |  |

**Indexes**:

- `IX_SupplyOrderUkraineDocument_SupplyOrderUkraineID`

---

## SupplyOrderUkraineItem

**Columns**: 39 | **Foreign Keys**: 0 | **Indexes**: 6

| Column | Type | Attributes |
|--------|------|------------|
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Updated` | datetime2 | not null |
| `IsFullyPlaced` | bit | not null |
| `Qty` | float | not null |
| `PlacedQty` | float | not null |
| `NetWeight` | float | not null |
| `UnitPrice` | decimal(30, 14) | not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `SupplyOrderUkraineID` | bigint | not null |
| `references` | SupplyOrderUkraine |  |
| `RemainingQty` | float | default 0.0000000000000000e+000 not null |
| `NotOrdered` | bit | default 0                       not null |
| `SupplierID` | bigint |  |
| `references` | Client |  |
| `GrossUnitPrice` | decimal(30, 14) | not null |
| `GrossUnitPriceLocal` | decimal(30, 14) | not null |
| `UnitPriceLocal` | decimal(30, 14) | not null |
| `PackingListPackageOrderItemID` | bigint |  |
| `references` | PackingListPackageOrderItem |  |
| `ExchangeRateAmount` | decimal(18, 2) | default 0.0                     not null |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |
| `AccountingGrossUnitPrice` | decimal(30, 14) | default 0.0                     not null |
| `GrossWeight` | float | default 0.0000000000000000e+000 not null |
| `ProductSpecificationID` | bigint |  |
| `references` | ProductSpecification |  |
| `VatPercent` | money | default 0.0                     not null |
| `VatAmount` | decimal(30, 14) | not null |
| `VatAmountLocal` | decimal(30, 14) | not null |
| `AccountingGrossUnitPriceLocal` | decimal(30, 14) | default 0.0                     not null |
| `UnitDeliveryAmountLocal` | decimal(30, 14) | default 0.0                     not null |
| `UnitDeliveryAmount` | decimal(30, 14) | default 0.0                     not null |
| `ProductIsImported` | bit | default 0                       not null |

**Indexes**:

- `IX_SupplyOrderUkraineItem_ProductID`
- `IX_SupplyOrderUkraineItem_SupplyOrderUkraineID`
- `IX_SupplyOrderUkraineItem_SupplierID`
- `IX_SupplyOrderUkraineItem_PackingListPackageOrderItemID`
- `IX_SupplyOrderUkraineItem_ConsignmentItemID`
- `IX_SupplyOrderUkraineItem_ProductSpecificationID`

---

## SupplyOrderUkrainePaymentDeliveryProtocol

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 4

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Value` | money | not null |
| `Discount` | float | not null |
| `SupplyOrderUkrainePaymentDeliveryProtocolKeyID` | bigint | not null |
| `references` | SupplyOrderUkrainePaymentDeliveryProtocolKey |  |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `SupplyOrderUkraineID` | bigint | not null |
| `references` | SupplyOrderUkraine |  |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `IsAccounting` | bit | default 0            not null |

**Indexes**:

- `IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkraineID`
- `IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkrainePaymentDeliveryProtocolKeyID`
- `IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyPaymentTaskID`
- `IX_SupplyOrderUkrainePaymentDeliveryProtocol_UserID`

---

## SupplyOrderUkrainePaymentDeliveryProtocolKey

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Key` | nvarchar(150) |  |

---

## SupplyOrderVehicleService

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `SupplyOrderID` | bigint | not null |
| `references` | SupplyOrder |  |
| `VehicleServiceID` | bigint | not null |
| `references` | VehicleService |  |

**Indexes**:

- `IX_SupplyOrderVehicleService_SupplyOrderID`
- `IX_SupplyOrderVehicleService_VehicleServiceID`

---

## SupplyOrganization

**Columns**: 42 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AccountNumber` | nvarchar(255) |  |
| `Address` | nvarchar(255) |  |
| `Bank` | nvarchar(255) |  |
| `BankAccount` | nvarchar(255) |  |
| `BankAccountEUR` | nvarchar(255) |  |
| `BankAccountPLN` | nvarchar(255) |  |
| `Beneficiary` | nvarchar(255) |  |
| `BeneficiaryBank` | nvarchar(255) |  |
| `ContactPersonComment` | nvarchar(255) |  |
| `ContactPersonEmail` | nvarchar(255) |  |
| `ContactPersonName` | nvarchar(255) |  |
| `ContactPersonPhone` | nvarchar(255) |  |
| `ContactPersonSkype` | nvarchar(255) |  |
| `ContactPersonViber` | nvarchar(255) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IntermediaryBank` | nvarchar(255) |  |
| `IsAgreementReceived` | bit | not null |
| `IsBillReceived` | bit | not null |
| `NIP` | nvarchar(255) |  |
| `Name` | nvarchar(255) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Swift` | nvarchar(255) |  |
| `SwiftBic` | nvarchar(255) |  |
| `Updated` | datetime2 | not null |
| `EmailAddress` | nvarchar(255) |  |
| `PhoneNumber` | nvarchar(255) |  |
| `Requisites` | nvarchar(255) |  |
| `AgreementReceiveDate` | datetime2 |  |
| `BillReceiveDate` | datetime2 |  |
| `SourceFenixCode` | bigint |  |
| `SourceFenixID` | varbinary(16) |  |
| `OriginalRegionCode` | nvarchar(10) |  |
| `SourceAmgCode` | bigint |  |
| `SourceAmgID` | varbinary(16) |  |
| `IsNotResident` | bit | default 0            not null |
| `SROI` | nvarchar(max) |  |
| `TIN` | nvarchar(max) |  |
| `USREOU` | nvarchar(max) |  |

---

## SupplyOrganizationAgreement

**Columns**: 29 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()                  not null |
| `CurrencyID` | bigint | not null |
| `references` | Currency |  |
| `on` | delete | cascade |
| `CurrentAmount` | money | not null |
| `Deleted` | bit | default 0                             not null |
| `Name` | nvarchar(150) |  |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `SupplyOrganizationID` | bigint | not null |
| `references` | SupplyOrganization |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |
| `AgreementTypeCivilCodeID` | bigint |  |
| `references` | AgreementTypeCivilCode |  |
| `TaxAccountingSchemeID` | bigint |  |
| `references` | TaxAccountingScheme |  |
| `AccountingCurrentAmount` | money | default 0.00                          not null |
| `SourceFenixCode` | bigint |  |
| `SourceFenixID` | varbinary(16) |  |
| `ExistTo` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `OrganizationID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | Organization |  |
| `ExistFrom` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `SourceAmgCode` | bigint |  |
| `SourceAmgID` | varbinary(16) |  |
| `Number` | nvarchar(50) |  |

**Indexes**:

- `IX_SupplyOrganizationAgreement_CurrencyID`
- `IX_SupplyOrganizationAgreement_SupplyOrganizationID`
- `IX_SupplyOrganizationAgreement_AgreementTypeCivilCodeID`
- `IX_SupplyOrganizationAgreement_TaxAccountingSchemeID`
- `IX_SupplyOrganizationAgreement_OrganizationID`

---

## SupplyOrganizationDocument

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyOrganizationAgreementID` | bigint | not null |
| `references` | SupplyOrganizationAgreement |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SupplyOrganizationDocument_SupplyOrganizationAgreementID`

---

## SupplyPaymentTask

**Columns**: 22 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()      not null |
| `Deleted` | bit | default 0                 not null |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Updated` | datetime2 | not null |
| `Comment` | nvarchar(max) |  |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `PayToDate` | datetime2 |  |
| `TaskAssignedTo` | int | default 0                 not null |
| `TaskStatus` | int | default 0                 not null |
| `TaskStatusUpdated` | datetime2 |  |
| `GrossPrice` | money | default 0.0               not null |
| `NetPrice` | money | default 0.0               not null |
| `IsAvailableForPayment` | bit | default 0                 not null |
| `DeletedByID` | bigint |  |
| `references` | unknown | [User] |
| `UpdatedByID` | bigint |  |
| `references` | unknown | [User] |
| `IsAccounting` | bit | default 0                 not null |
| `IsImportedFromOneC` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_SupplyPaymentTask_UserID`
- `IX_SupplyPaymentTask_DeletedByID`
- `IX_SupplyPaymentTask_UpdatedByID`

---

## SupplyPaymentTaskDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ContentType` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(max) |  |
| `FileName` | nvarchar(max) |  |
| `GeneratedName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `SupplyPaymentTaskID` | bigint | not null |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_SupplyPaymentTaskDocument_SupplyPaymentTaskID`

---

## SupplyProForm

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetPrice` | money | not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `DateFrom` | datetime2 |  |
| `IsSkipped` | bit | default 0            not null |
| `ServiceNumber` | nvarchar(50) |  |

---

## SupplyReturn

**Columns**: 20 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `Number` | nvarchar(50) |  |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | not null |
| `SupplierID` | bigint | not null |
| `references` | Client |  |
| `ClientAgreementID` | bigint | not null |
| `references` | ClientAgreement |  |
| `OrganizationID` | bigint | not null |
| `references` | Organization |  |
| `ResponsibleID` | bigint | not null |
| `references` | unknown | [User] |
| `StorageID` | bigint | not null |
| `references` | Storage |  |
| `IsManagement` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_SupplyReturn_ClientAgreementID`
- `IX_SupplyReturn_OrganizationID`
- `IX_SupplyReturn_ResponsibleID`
- `IX_SupplyReturn_StorageID`
- `IX_SupplyReturn_SupplierID`

---

## SupplyReturnItem

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                    not null |
| `Qty` | float | not null |
| `ProductID` | bigint | not null |
| `references` | Product |  |
| `SupplyReturnID` | bigint | not null |
| `references` | SupplyReturn |  |
| `ConsignmentItemID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | ConsignmentItem |  |

**Indexes**:

- `IX_SupplyReturnItem_ProductID`
- `IX_SupplyReturnItem_SupplyReturnID`
- `IX_SupplyReturnItem_ConsignmentItemID`

---

## SupplyServiceAccountDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(500) |  |
| `FileName` | nvarchar(500) |  |
| `ContentType` | nvarchar(500) |  |
| `GeneratedName` | nvarchar(500) |  |
| `Number` | nvarchar(20) |  |

---

## SupplyServiceNumber

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `IsPoland` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Number` | nvarchar(50) |  |
| `Updated` | datetime2 | not null |

---

## SupportVideo

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `NameUk` | nvarchar(150) |  |
| `NamePl` | nvarchar(150) |  |
| `Url` | nvarchar(250) |  |
| `DocumentUrl` | nvarchar(250) |  |

---

## TaxAccountingScheme

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `CodeOneC` | nvarchar(25) |  |
| `NameUK` | nvarchar(100) |  |
| `NamePL` | nvarchar(100) |  |
| `PurchaseTaxBaseMoment` | int | default 0            not null |
| `SaleTaxBaseMoment` | int | default 0            not null |

---

## TaxFree

**Columns**: 37 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `AmountInEur` | money | not null |
| `AmountInPLN` | money | not null |
| `AmountPayedStatham` | money | not null |
| `Created` | datetime2 | default getutcdate()         not null |
| `CustomCode` | nvarchar(150) |  |
| `DateOfIssue` | datetime2 |  |
| `DateOfPrint` | datetime2 |  |
| `DateOfStathamPayment` | datetime2 |  |
| `DateOfTabulation` | datetime2 |  |
| `Deleted` | bit | default 0                    not null |
| `NetUID` | uniqueidentifier | default newid()              not null |
| `Number` | nvarchar(50) |  |
| `StathamID` | bigint |  |
| `references` | Statham |  |
| `TaxFreePackListID` | bigint | not null |
| `references` | TaxFreePackList |  |
| `TaxFreeStatus` | int | not null |
| `Updated` | datetime2 | not null |
| `VatAmountInPLN` | money | not null |
| `Weight` | float | not null |
| `Comment` | nvarchar(500) |  |
| `ResponsibleID` | bigint | default CONVERT([bigint], 0) not null |
| `references` | unknown | [User] |
| `StathamCarID` | bigint |  |
| `references` | StathamCar |  |
| `MarginAmount` | money | default 0.0                  not null |
| `VatPercent` | money | default 0.0                  not null |
| `CanceledDate` | datetime2 |  |
| `ClosedDate` | datetime2 |  |
| `FormedDate` | datetime2 |  |
| `ReturnedDate` | datetime2 |  |
| `SelectedDate` | datetime2 |  |
| `StathamPassportID` | bigint |  |
| `references` | StathamPassport |  |

**Indexes**:

- `IX_TaxFree_StathamID`
- `IX_TaxFree_TaxFreePackListID`
- `IX_TaxFree_ResponsibleID`
- `IX_TaxFree_StathamCarID`
- `IX_TaxFree_StathamPassportID`

---

## TaxFreeDocument

**Columns**: 12 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `ContentType` | nvarchar(250) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `DocumentUrl` | nvarchar(250) |  |
| `FileName` | nvarchar(250) |  |
| `GeneratedName` | nvarchar(250) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `TaxFreeID` | bigint | not null |
| `references` | TaxFree |  |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_TaxFreeDocument_TaxFreeID`

---

## TaxFreeItem

**Columns**: 14 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `Qty` | float | not null |
| `Comment` | nvarchar(500) |  |
| `TaxFreeID` | bigint | not null |
| `references` | TaxFree |  |
| `SupplyOrderUkraineCartItemID` | bigint |  |
| `references` | SupplyOrderUkraineCartItem |  |
| `TaxFreePackListOrderItemID` | bigint |  |
| `references` | TaxFreePackListOrderItem |  |

**Indexes**:

- `IX_TaxFreeItem_SupplyOrderUkraineCartItemID`
- `IX_TaxFreeItem_TaxFreeID`
- `IX_TaxFreeItem_TaxFreePackListOrderItemID`

---

## TaxFreePackList

**Columns**: 27 | **Foreign Keys**: 0 | **Indexes**: 5

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()                  not null |
| `Deleted` | bit | default 0                             not null |
| `NetUID` | uniqueidentifier | default newid()                       not null |
| `Updated` | datetime2 | not null |
| `Comment` | nvarchar(500) |  |
| `FromDate` | datetime2 | default '0001-01-01T00:00:00.0000000' not null |
| `Number` | nvarchar(50) |  |
| `OrganizationID` | bigint |  |
| `references` | Organization |  |
| `ResponsibleID` | bigint | default CONVERT([bigint], 0)          not null |
| `references` | unknown | [User] |
| `IsSent` | bit | default 0                             not null |
| `SupplyOrderUkraineID` | bigint |  |
| `references` | SupplyOrderUkraine |  |
| `IsFromSale` | bit | default 0                             not null |
| `ClientID` | bigint |  |
| `references` | Client |  |
| `MarginAmount` | money | default 0.0                           not null |
| `MaxPositionsInTaxFree` | int | default 0                             not null |
| `MaxPriceLimit` | decimal(18, 2) | default 0.0                           not null |
| `MaxQtyInTaxFree` | int | default 0                             not null |
| `MinPriceLimit` | decimal(18, 2) | default 0.0                           not null |
| `WeightLimit` | float | default 0.0000000000000000e+000       not null |
| `ClientAgreementID` | bigint |  |
| `references` | ClientAgreement |  |

**Indexes**:

- `IX_TaxFreePackList_OrganizationID`
- `IX_TaxFreePackList_ResponsibleID`
- `IX_TaxFreePackList_SupplyOrderUkraineID`
- `IX_TaxFreePackList_ClientID`
- `IX_TaxFreePackList_ClientAgreementID`

---

## TaxFreePackListOrderItem

**Columns**: 15 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `NetWeight` | float | not null |
| `Qty` | float | not null |
| `UnpackedQty` | float | not null |
| `OrderItemID` | bigint | not null |
| `references` | OrderItem |  |
| `TaxFreePackListID` | bigint | not null |
| `references` | TaxFreePackList |  |
| `ConsignmentItemID` | bigint |  |
| `references` | ConsignmentItem |  |

**Indexes**:

- `IX_TaxFreePackListOrderItem_OrderItemID`
- `IX_TaxFreePackListOrderItem_TaxFreePackListID`
- `IX_TaxFreePackListOrderItem_ConsignmentItemID`

---

## TaxInspection

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `InspectionNumber` | nvarchar(50) |  |
| `InspectionType` | nvarchar(150) |  |
| `InspectionName` | nvarchar(250) |  |
| `InspectionRegionName` | nvarchar(250) |  |
| `InspectionRegionCode` | nvarchar(50) |  |
| `InspectionAddress` | nvarchar(250) |  |
| `InspectionUSREOU` | nvarchar(50) |  |

---

## TermsOfDelivery

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## TransportationService

**Columns**: 44 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `TransportationOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `GrossPrice` | money | default 0.0                     not null |
| `FromDate` | datetime2 |  |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `IsSealAndSignatureVerified` | bit | default 0                       not null |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_TransportationService_SupplyPaymentTaskID`
- `IX_TransportationService_UserID`
- `IX_TransportationService_TransportationOrganizationID`
- `IX_TransportationService_SupplyOrganizationAgreementID`
- `IX_TransportationService_AccountingPaymentTaskID`
- `IX_TransportationService_SupplyInformationTaskID`
- `IX_TransportationService_ActProvidingServiceDocumentID`
- `IX_TransportationService_SupplyServiceAccountDocumentID`
- `IX_TransportationService_AccountingActProvidingServiceId`
- `IX_TransportationService_ActProvidingServiceId`

---

## Transporter

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `TransporterTypeID` | bigint |  |
| `references` | TransporterType |  |
| `Updated` | datetime2 | not null |
| `CssClass` | nvarchar(max) |  |
| `Priority` | int | default 0            not null |
| `ImageUrl` | nvarchar(max) |  |

**Indexes**:

- `IX_Transporter_TransporterTypeID`

---

## TransporterType

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(50) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |

---

## TransporterTypeTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `TransporterTypeID` | bigint | not null |
| `references` | TransporterType |  |
| `on` | delete | cascade |
| `Updated` | datetime2 | not null |

**Indexes**:

- `IX_TransporterTypeTranslation_TransporterTypeID`

---

## UpdateDataCarrier

**Columns**: 28 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `SaleId` | bigint | not null |
| `references` | Sale |  |
| `on` | delete | cascade |
| `TransporterId` | bigint |  |
| `references` | Transporter |  |
| `UserId` | bigint |  |
| `references` | unknown | [User] |
| `IsCashOnDelivery` | bit | not null |
| `HasDocument` | bit | not null |
| `Comment` | nvarchar(450) |  |
| `Number` | nvarchar(max) |  |
| `MobilePhone` | nvarchar(max) |  |
| `FullName` | nvarchar(max) |  |
| `City` | nvarchar(max) |  |
| `Department` | nvarchar(max) |  |
| `TtnPDFPath` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()           not null |
| `Created` | datetime2 | default getutcdate()      not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                 not null |
| `ApproveUpdate` | bit | default CONVERT([bit], 0) not null |
| `ShipmentDate` | datetime2 |  |
| `TTN` | nvarchar(max) |  |
| `CashOnDeliveryAmount` | money | default 0.0               not null |
| `IsDevelopment` | bit | default 0                 not null |
| `IsEditTransporter` | bit | default CONVERT([bit], 0) not null |

**Indexes**:

- `IX_UpdateDataCarrier_SaleId`
- `IX_UpdateDataCarrier_TransporterId`
- `IX_UpdateDataCarrier_UserId`

---

## UserDetails

**Columns**: 40 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Accommodation` | nvarchar(max) |  |
| `AdditionalSchools` | nvarchar(max) |  |
| `Address` | nvarchar(max) |  |
| `BasicHealtAndSagetyEducation` | nvarchar(max) |  |
| `Caveats` | nvarchar(max) |  |
| `Created` | datetime2 | default getutcdate() not null |
| `DateOfBirth` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `DocumentsExpirationDate` | datetime2 | not null |
| `Education` | nvarchar(max) |  |
| `FamilyStatus` | nvarchar(max) |  |
| `FathersName` | nvarchar(max) |  |
| `FirstName` | nvarchar(max) |  |
| `HasPermissionToOperateCarts` | bit | not null |
| `IsBigFamily` | bit | not null |
| `LastName` | nvarchar(max) |  |
| `MedicalCertificateToDate` | datetime2 | not null |
| `MiddleName` | nvarchar(max) |  |
| `MothersName` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `NumberOfDependents` | int | not null |
| `PassportNumber` | nvarchar(max) |  |
| `Profession` | nvarchar(max) |  |
| `Registration` | nvarchar(max) |  |
| `ResidenceCardID` | bigint | not null |
| `references` | ResidenceCard |  |
| `SocialSecurityNumber` | nvarchar(max) |  |
| `SpecializedTraining` | nvarchar(max) |  |
| `TIN` | nvarchar(max) |  |
| `Updated` | datetime2 | not null |
| `VATIN` | nvarchar(max) |  |
| `VocationalCourses` | nvarchar(max) |  |
| `WorkExperience` | float | not null |
| `WorkHeight` | float | not null |
| `WorkPermitID` | bigint | not null |
| `references` | WorkPermit |  |
| `WorkingContractID` | bigint | not null |
| `references` | WorkingContract |  |

**Indexes**:

- `IX_UserDetails_ResidenceCardID`
- `IX_UserDetails_WorkPermitID`
- `IX_UserDetails_WorkingContractID`

---

## UserRole

**Columns**: 9 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Dashboard` | nvarchar(100) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(40) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UserRoleType` | int | default 0            not null |

---

## UserRoleDashboardNode

**Columns**: 13 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `UserRoleID` | bigint | not null |
| `references` | UserRole |  |
| `on` | delete | cascade |
| `DashboardNodeID` | bigint | not null |
| `references` | DashboardNode |  |
| `on` | delete | cascade |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_UserRoleDashboardNode_DashboardNodeID`
- `IX_UserRoleDashboardNode_UserRoleID`

---

## UserRoleTranslation

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CultureCode` | nvarchar(4) |  |
| `Deleted` | bit | default 0            not null |
| `Name` | nvarchar(75) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UserRoleID` | bigint | not null |
| `references` | UserRole |  |
| `on` | delete | cascade |

**Indexes**:

- `IX_UserRoleTranslation_UserRoleID`

---

## UserScreenResolution

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 1

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `Height` | int | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Updated` | datetime2 | not null |
| `UserID` | bigint | not null |
| `references` | unknown | [User] |
| `on` | delete | cascade |
| `Width` | int | not null |

**Indexes**:

- `IX_UserScreenResolution_UserID`

---

## VatRate

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `Value` | float | default 0.0000000000000000e+000 not null |

---

## VehicleDeliveryService

**Columns**: 45 | **Foreign Keys**: 0 | **Indexes**: 10

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `Created` | datetime2 | default getutcdate()            not null |
| `Deleted` | bit | default 0                       not null |
| `FromDate` | datetime2 |  |
| `IsActive` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `Updated` | datetime2 | not null |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `VehicleDeliveryOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `GrossPrice` | money | default 0.0                     not null |
| `NetPrice` | money | default 0.0                     not null |
| `Vat` | money | default 0.0                     not null |
| `Number` | nvarchar(max) |  |
| `IsSealAndSignatureVerified` | bit | default 0                       not null |
| `Name` | nvarchar(max) |  |
| `VatPercent` | float | default 0.0000000000000000e+000 not null |
| `ServiceNumber` | nvarchar(50) |  |
| `SupplyOrganizationAgreementID` | bigint | default 0                       not null |
| `references` | SupplyOrganizationAgreement |  |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_VehicleDeliveryService_SupplyPaymentTaskID`
- `IX_VehicleDeliveryService_UserID`
- `IX_VehicleDeliveryService_VehicleDeliveryOrganizationID`
- `IX_VehicleDeliveryService_SupplyOrganizationAgreementID`
- `IX_VehicleDeliveryService_AccountingPaymentTaskID`
- `IX_VehicleDeliveryService_SupplyInformationTaskID`
- `IX_VehicleDeliveryService_ActProvidingServiceDocumentID`
- `IX_VehicleDeliveryService_SupplyServiceAccountDocumentID`
- `IX_VehicleDeliveryService_AccountingActProvidingServiceId`
- `IX_VehicleDeliveryService_ActProvidingServiceId`

---

## VehicleService

**Columns**: 52 | **Foreign Keys**: 0 | **Indexes**: 11

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `NetUID` | uniqueidentifier | default newid()                 not null |
| `Created` | datetime2 | default getutcdate()            not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0                       not null |
| `IsActive` | bit | not null |
| `FromDate` | datetime2 |  |
| `GrossPrice` | money | not null |
| `NetPrice` | money | not null |
| `Vat` | money | not null |
| `VatPercent` | float | not null |
| `Number` | nvarchar(max) |  |
| `ServiceNumber` | nvarchar(50) |  |
| `Name` | nvarchar(max) |  |
| `UserID` | bigint |  |
| `references` | unknown | [User] |
| `SupplyPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `SupplyOrganizationAgreementID` | bigint | not null |
| `references` | SupplyOrganizationAgreement |  |
| `LoadDate` | datetime2 | not null |
| `GrossWeight` | float | not null |
| `VehicleNumber` | nvarchar(max) |  |
| `TermDeliveryInDays` | nvarchar(max) |  |
| `BillOfLadingDocumentID` | bigint |  |
| `references` | BillOfLadingDocument |  |
| `VehicleOrganizationID` | bigint |  |
| `references` | SupplyOrganization |  |
| `IsCalculatedExtraCharge` | bit | not null |
| `SupplyExtraChargeType` | int | not null |
| `AccountingGrossPrice` | money | default 0.0                     not null |
| `AccountingNetPrice` | money | default 0.0                     not null |
| `AccountingPaymentTaskID` | bigint |  |
| `references` | SupplyPaymentTask |  |
| `AccountingVat` | money | default 0.0                     not null |
| `AccountingVatPercent` | float | default 0.0000000000000000e+000 not null |
| `AccountingSupplyCostsWithinCountry` | money | default 0.0                     not null |
| `SupplyInformationTaskID` | bigint |  |
| `references` | SupplyInformationTask |  |
| `AccountingExchangeRate` | money |  |
| `ExchangeRate` | money |  |
| `IsIncludeAccountingValue` | bit | default 0                       not null |
| `ActProvidingServiceDocumentID` | bigint |  |
| `references` | ActProvidingServiceDocument |  |
| `SupplyServiceAccountDocumentID` | bigint |  |
| `references` | SupplyServiceAccountDocument |  |
| `AccountingActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |
| `ActProvidingServiceId` | bigint |  |
| `references` | ActProvidingService |  |

**Indexes**:

- `IX_VehicleService_BillOfLadingDocumentID`
- `IX_VehicleService_SupplyOrganizationAgreementID`
- `IX_VehicleService_SupplyPaymentTaskID`
- `IX_VehicleService_UserID`
- `IX_VehicleService_VehicleOrganizationID`
- `IX_VehicleService_AccountingPaymentTaskID`
- `IX_VehicleService_SupplyInformationTaskID`
- `IX_VehicleService_ActProvidingServiceDocumentID`
- `IX_VehicleService_SupplyServiceAccountDocumentID`
- `IX_VehicleService_AccountingActProvidingServiceId`
- `IX_VehicleService_ActProvidingServiceId`

---

## WarehousesShipment

**Columns**: 26 | **Foreign Keys**: 0 | **Indexes**: 3

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `IsDevelopment` | bit | default 0            not null |
| `SaleId` | bigint |  |
| `references` | Sale |  |
| `TransporterId` | bigint |  |
| `references` | Transporter |  |
| `UserId` | bigint |  |
| `references` | unknown | [User] |
| `IsCashOnDelivery` | bit | not null |
| `CashOnDeliveryAmount` | money | not null |
| `HasDocument` | bit | not null |
| `ShipmentDate` | datetime2 |  |
| `TTN` | nvarchar(max) |  |
| `Comment` | nvarchar(450) |  |
| `Number` | nvarchar(max) |  |
| `MobilePhone` | nvarchar(max) |  |
| `FullName` | nvarchar(max) |  |
| `City` | nvarchar(max) |  |
| `Department` | nvarchar(max) |  |
| `TtnPDFPath` | nvarchar(max) |  |
| `ApproveUpdate` | bit | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |

**Indexes**:

- `IX_WarehousesShipment_SaleId`
- `IX_WarehousesShipment_TransporterId`
- `IX_WarehousesShipment_UserId`

---

## WorkPermit

**Columns**: 8 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `ToDate` | datetime2 | not null |
| `Updated` | datetime2 | not null |

---

## WorkingContract

**Columns**: 17 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `Created` | datetime2 | default getutcdate() not null |
| `CurrentWorkplace` | nvarchar(max) |  |
| `Delegation` | nvarchar(max) |  |
| `Deleted` | bit | default 0            not null |
| `FromDate` | datetime2 | not null |
| `KindOfWork` | nvarchar(max) |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `NightWork` | nvarchar(max) |  |
| `PlaceOfWork` | nvarchar(max) |  |
| `Premium` | nvarchar(max) |  |
| `StudyLeave` | nvarchar(max) |  |
| `ToDate` | datetime2 | not null |
| `Updated` | datetime2 | not null |
| `VacationDays` | nvarchar(max) |  |
| `WorkTimeSize` | nvarchar(max) |  |

---

## Workplace

**Columns**: 18 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `FirstName` | nvarchar(150) |  |
| `MiddleName` | nvarchar(150) |  |
| `LastName` | nvarchar(150) |  |
| `Email` | nvarchar(150) |  |
| `PhoneNumber` | nvarchar(16) |  |
| `IsBlocked` | bit | not null |
| `MainClientID` | bigint | not null |
| `references` | Client |  |
| `ClientGroupID` | bigint |  |
| `references` | ClientGroup |  |
| `Abbreviation` | nvarchar(max) |  |
| `Region` | nvarchar(max) |  |

**Indexes**:

- `IX_Workplace_ClientGroupID`
- `IX_Workplace_MainClientID`

---

## WorkplaceClientAgreement

**Columns**: 11 | **Foreign Keys**: 0 | **Indexes**: 2

| Column | Type | Attributes |
|--------|------|------------|
| `ID` | bigint | identity |
| `primary` | key |  |
| `NetUID` | uniqueidentifier | default newid()      not null |
| `Created` | datetime2 | default getutcdate() not null |
| `Updated` | datetime2 | not null |
| `Deleted` | bit | default 0            not null |
| `WorkplaceID` | bigint | not null |
| `references` | Workplace |  |
| `ClientAgreementID` | bigint | not null |
| `references` | ClientAgreement |  |
| `IsSelected` | bit | not null |

**Indexes**:

- `IX_WorkplaceClientAgreement_ClientAgreementID`
- `IX_WorkplaceClientAgreement_WorkplaceID`

---

## __EFMigrationsHistory

**Columns**: 4 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `MigrationId` | nvarchar(150) | not null |
| `primary` | key |  |
| `with` | unknown | (fillfactor = 60) |
| `ProductVersion` | nvarchar(32) | not null |

---

## sysdiagrams

**Columns**: 7 | **Foreign Keys**: 0 | **Indexes**: 0

| Column | Type | Attributes |
|--------|------|------------|
| `name` | sysname | not null |
| `principal_id` | int | not null |
| `diagram_id` | int | identity |
| `primary` | key |  |
| `version` | int |  |
| `definition` | varbinary(max) |  |
| `unique` | unknown | (principal_id, name) |

---
