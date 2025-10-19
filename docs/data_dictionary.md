# Data Dictionary (Selected Entities)

## Product

| Column | Definition |
|---|---|
| `ID` | bigint identity constraint PK_Product primary key with (fillfactor = 60) |
| `Created` | datetime2 default getutcdate() not null |
| `Deleted` | bit default 0 not null |
| `Description` | nvarchar(2000) |
| `HasAnalogue` | bit not null |
| `HasImage` | bit not null |
| `IsForSale` | bit not null |
| `IsForWeb` | bit not null |
| `IsForZeroSale` | bit not null |
| `MainOriginalNumber` | nvarchar(80) |
| `MeasureUnitID` | bigint not null constraint FK_Product_MeasureUnit_MeasureUnitID references MeasureUnit |
| `Name` | nvarchar(120) |
| `NetUID` | uniqueidentifier default newid() not null |
| `OrderStandard` | nvarchar(max) |
| `PackingStandard` | nvarchar(max) |
| `Size` | nvarchar(100) |
| `UCGFEA` | nvarchar(max) |
| `Updated` | datetime2 not null |
| `VendorCode` | nvarchar(40) |
| `Volume` | nvarchar(max) |
| `Weight` | float not null |
| `HasComponent` | bit default 0 not null |
| `Image` | nvarchar(max) |
| `[Top]` | nvarchar(3) |
| `DescriptionPL` | nvarchar(2000) |
| `DescriptionUA` | nvarchar(2000) |
| `NamePL` | nvarchar(120) |
| `NameUA` | nvarchar(120) |
| `SourceAmgID` | varbinary(16) |
| `SourceFenixID` | varbinary(16) |
| `SearchDescriptionPL` | nvarchar(2000) |
| `SearchNamePL` | nvarchar(120) |
| `NotesPL` | nvarchar(2000) |
| `NotesUA` | nvarchar(2000) |
| `SearchDescriptionUA` | nvarchar(2000) |
| `SearchNameUA` | nvarchar(120) |
| `SearchSize` | nvarchar(100) |
| `SearchVendorCode` | nvarchar(40) |
| `SearchDescription` | nvarchar(2000) |
| `SearchName` | nvarchar(120) |
| `SearchSynonymsPL` | nvarchar(2000) |
| `SearchSynonymsUA` | nvarchar(2000) |
| `SynonymsPL` | nvarchar(2000) |
| `SynonymsUA` | nvarchar(2000) |
| `Standard` | nvarchar(max) |
| `ParentAmgID` | varbinary(16) |
| `ParentFenixID` | varbinary(16) |
| `SourceAmgCode` | bigint |
| `SourceFenixCode` | bigint |

## Order

| Column | Definition |
|---|---|
| `ID` | bigint identity constraint PK_Order primary key with (fillfactor = 60) |
| `Created` | datetime2 default getutcdate() not null |
| `Deleted` | bit default 0 not null |
| `NetUID` | uniqueidentifier default newid() not null |
| `OrderSource` | int not null |
| `Updated` | datetime2 not null |
| `UserID` | bigint constraint FK_Order_User_UserID references [User] |
| `ClientAgreementID` | bigint default 0 not null constraint FK_Order_ClientAgreement_ClientAgreementID references ClientAgreement |
| `OrderStatus` | int default 0 not null |
| `IsMerged` | bit default 0 not null |
| `ClientShoppingCartID` | bigint constraint FK_Order_ClientShoppingCart_ClientShoppingCartID references ClientShoppingCart |

## OrderItem

| Column | Definition |
|---|---|
| `ID` | bigint identity constraint PK_OrderItem primary key with (fillfactor = 60) |
| `Created` | datetime2 default getutcdate() not null |
| `Deleted` | bit default 0 not null |
| `NetUID` | uniqueidentifier default newid() not null |
| `OrderID` | bigint constraint FK_OrderItem_Order_OrderID references [Order] |
| `ProductID` | bigint not null constraint FK_OrderItem_Product_ProductID references Product on delete cascade |
| `Updated` | datetime2 not null |
| `Qty` | float not null |
| `UserId` | bigint constraint FK_OrderItem_User_UserId references [User] |
| `Comment` | nvarchar(450) |
| `IsValidForCurrentSale` | bit default 1 not null |
| `ClientShoppingCartID` | bigint constraint FK_OrderItem_ClientShoppingCart_ClientShoppingCartID references ClientShoppingCart |
| `PricePerItem` | decimal(30, 14) not null |
| `OneTimeDiscount` | money not null |
| `FromOfferQty` | float default 0.0000000000000000e+000 not null |
| `IsFromOffer` | bit default 0 not null |
| `OrderedQty` | float default 0.0000000000000000e+000 not null |
| `ExchangeRateAmount` | money default 0.0 not null |
| `OfferProcessingStatus` | int default 0 not null |
| `OfferProcessingStatusChangedByID` | bigint constraint FK_OrderItem_User_OfferProcessingStatusChangedByID references [User] |
| `DiscountUpdatedByID` | bigint constraint FK_OrderItem_User_DiscountUpdatedByID references [User] |
| `OneTimeDiscountComment` | nvarchar(450) |
| `UnpackedQty` | float default 0.0000000000000000e+000 not null |
| `DiscountAmount` | money default 0.0 not null |
| `PricePerItemWithoutVat` | decimal(30, 14) not null |
| `ReturnedQty` | float default 0.0000000000000000e+000 not null |
| `AssignedSpecificationID` | bigint constraint FK_OrderItem_ProductSpecification_AssignedSpecificationID references ProductSpecification |
| `IsFromReSale` | bit default 0 not null |
| `MisplacedSaleId` | bigint constraint FK_OrderItem_MisplacedSale_MisplacedSaleId references MisplacedSale |
| `Vat` | decimal(30, 14) default 0.0 not null |
| `InvoiceDocumentQty` | float default 0.0000000000000000e+000 not null |
| `IsClosed` | bit default CONVERT([bit], 0) not null |
| `StorageId` | bigint constraint FK_OrderItem_Storage_StorageId references Storage |
| `IsFromShiftedItem` | bit default 0 not null |

## Sale

| Column | Definition |
|---|---|
| `ID` | bigint identity constraint PK_Sale primary key with (fillfactor = 60) |
| `ClientAgreementID` | bigint not null constraint FK_Sale_ClientAgreement_ClientAgreementID references ClientAgreement |
| `Created` | datetime2 default getutcdate() not null |
| `Deleted` | bit default 0 not null |
| `NetUID` | uniqueidentifier default newid() not null |
| `OrderID` | bigint not null constraint FK_Sale_Order_OrderID references [Order] |
| `Updated` | datetime2 not null |
| `UserID` | bigint constraint FK_Sale_User_UserID references [User] |
| `BaseLifeCycleStatusID` | bigint default 0 not null constraint FK_Sale_BaseLifeCycleStatus_BaseLifeCycleStatusID references BaseLifeCycleStatus |
| `BaseSalePaymentStatusID` | bigint default 0 not null constraint FK_Sale_BaseSalePaymentStatus_BaseSalePaymentStatusID references BaseSalePaymentStatus |
| `Comment` | nvarchar(450) |
| `SaleNumberID` | bigint constraint FK_Sale_SaleNumber_SaleNumberID references SaleNumber |
| `DeliveryRecipientID` | bigint constraint FK_Sale_DeliveryRecipient_DeliveryRecipientID references DeliveryRecipient |
| `DeliveryRecipientAddressID` | bigint constraint FK_Sale_DeliveryRecipientAddress_DeliveryRecipientAddressID references DeliveryRecipientAddress |
| `TransporterID` | bigint constraint FK_Sale_Transporter_TransporterID references Transporter |
| `ShiftStatusID` | bigint constraint FK_Sale_SaleBaseShiftStatus_ShiftStatusID references SaleBaseShiftStatus |
| `ParentNetId` | uniqueidentifier |
| `IsMerged` | bit default 0 not null |
| `SaleInvoiceDocumentID` | bigint constraint FK_Sale_SaleInvoiceDocument_SaleInvoiceDocumentID references SaleInvoiceDocument |
| `SaleInvoiceNumberID` | bigint constraint FK_Sale_SaleInvoiceNumber_SaleInvoiceNumberID references SaleInvoiceNumber |
| `ChangedToInvoice` | datetime2 |
| `OneTimeDiscountComment` | nvarchar(450) |
| `ChangedToInvoiceByID` | bigint constraint FK_Sale_User_ChangedToInvoiceByID references [User] |
| `ShipmentDate` | datetime2 |
| `CashOnDeliveryAmount` | money not null |
| `HasDocuments` | bit default 0 not null |
| `IsCashOnDelivery` | bit default 0 not null |
| `IsPrinted` | bit default 0 not null |
| `TTN` | nvarchar(max) |
| `ShippingAmount` | money default 0.0 not null |
| `TaxFreePackListID` | bigint constraint FK_Sale_TaxFreePackList_TaxFreePackListID references TaxFreePackList |
| `SadID` | bigint constraint FK_Sale_Sad_SadID references Sad |
| `IsVatSale` | bit default 0 not null |
| `ShippingAmountEur` | money default 0.0 not null |
| `ExpiredDays` | float default 0.00 not null |
| `IsLocked` | bit default 0 not null |
| `IsPaymentBillDownloaded` | bit default 0 not null |
| `IsImported` | bit default 0 not null |
| `IsPrintedPaymentInvoice` | bit default 0 not null |
| `IsAcceptedToPacking` | bit default 0 not null |
| `RetailClientId` | bigint constraint FK_Sale_RetailClient_RetailClientId references RetailClient |
| `IsFullPayment` | bit default 0 not null |
| `MisplacedSaleId` | bigint constraint FK_Sale_MisplacedSale_MisplacedSaleId references MisplacedSale |
| `WorkplaceID` | bigint constraint FK_Sale_Workplace_WorkplaceID references Workplace |
| `UpdateUserID` | bigint constraint FK_Sale_User_UpdateUserID references [User] |
| `CustomersOwnTtnID` | bigint constraint FK_Sale_CustomersOwnTtn_CustomersOwnTtnID references CustomersOwnTtn |
| `IsDevelopment` | bit default 0 not null |
| `WarehousesShipmentId` | bigint |
| `IsPrintedActProtocolEdit` | bit default 0 not null |
| `BillDownloadDate` | datetime2 |

## Client

| Column | Definition |
|---|---|
| `ID` | bigint identity constraint PK_Client primary key with (fillfactor = 60) |
| `Comment` | nvarchar(max) |
| `Created` | datetime2 default getutcdate() not null |
| `Deleted` | bit default 0 not null |
| `NetUID` | uniqueidentifier default newid() not null |
| `TIN` | nvarchar(30) |
| `USREOU` | nvarchar(30) |
| `Updated` | datetime2 not null |
| `AccountantNumber` | nvarchar(max) |
| `ActualAddress` | nvarchar(max) |
| `DeliveryAddress` | nvarchar(max) |
| `DirectorNumber` | nvarchar(max) |
| `EmailAddress` | nvarchar(max) |
| `FaxNumber` | nvarchar(max) |
| `ICQ` | nvarchar(max) |
| `LegalAddress` | nvarchar(max) |
| `MobileNumber` | nvarchar(max) |
| `RegionID` | bigint constraint FK_Client_Region_RegionID references Region |
| `SMSNumber` | nvarchar(max) |
| `ClientNumber` | nvarchar(max) |
| `SROI` | nvarchar(max) |
| `Name` | nvarchar(150) |
| `FullName` | nvarchar(200) |
| `IsIndividual` | bit default 0 not null |
| `RegionCodeID` | bigint constraint FK_Client_RegionCode_RegionCodeID references RegionCode |
| `IsActive` | bit default 0 not null |
| `IsSubClient` | bit default 0 not null |
| `Abbreviation` | nvarchar(max) |
| `IsBlocked` | bit default 0 not null |
| `IsTradePoint` | bit default 0 not null |
| `Brand` | nvarchar(max) |
| `ClientBankDetailsID` | bigint constraint FK_Client_ClientBankDetails_ClientBankDetailsID references ClientBankDetails |
| `CountryID` | bigint constraint FK_Client_Country_CountryID references Country |
| `Manufacturer` | nvarchar(max) |
| `TermsOfDeliveryID` | bigint constraint FK_Client_TermsOfDelivery_TermsOfDeliveryID references TermsOfDelivery |
| `SupplierContactName` | nvarchar(max) |
| `SupplierName` | nvarchar(max) |
| `PackingMarkingID` | bigint constraint FK_Client_PackingMarking_PackingMarkingID references PackingMarking |
| `PackingMarkingPaymentID` | bigint constraint FK_Client_PackingMarkingPayment_PackingMarkingPaymentID references PackingMarkingPayment |
| `IncotermsElse` | nvarchar(max) |
| `IsPayForDelivery` | bit default 0 not null |
| `IsIncotermsElse` | bit default 0 not null |
| `SupplierCode` | nvarchar(40) |
| `IsTemporaryClient` | bit default 0 not null |
| `FirstName` | nvarchar(150) |
| `LastName` | nvarchar(150) |
| `MiddleName` | nvarchar(150) |
| `SourceFenixID` | varbinary(16) |
| `HouseNumber` | nvarchar(250) |
| `Street` | nvarchar(250) |
| `ZipCode` | nvarchar(250) |
| `ClearCartAfterDays` | int default 3 not null |
| `IsFromECommerce` | bit default 0 not null |
| `Manager` | nvarchar(250) |
| `IsForRetail` | bit default 0 not null |
| `IsWorkplace` | bit default 0 not null |
| `OriginalRegionCode` | nvarchar(10) |
| `SourceAmgCode` | bigint |
| `SourceAmgID` | varbinary(16) |
| `SourceFenixCode` | bigint |
| `IsNotResident` | bit default 0 not null |
| `MainManagerID` | bigint constraint FK_Client_User_MainManagerID references [User] |
| `MainClientID` | bigint constraint FK_Client_Client_MainClientID references Client |
| `OrderExpireDays` | int default 0 not null |
