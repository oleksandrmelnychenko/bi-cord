create table AccountingDocumentName
(
    ID           bigint identity
        constraint PK_AccountingDocumentName
            primary key
                with (fillfactor = 60),
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null,
    DocumentType int                                   not null,
    NameUK       nvarchar(120),
    NamePL       nvarchar(120)
)
go

create table AccountingOperationName
(
    ID            bigint identity
        constraint PK_AccountingOperationName
            primary key,
    OperationType int                                   not null,
    CashNameUK    nvarchar(120),
    CashNamePL    nvarchar(120),
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    BankNamePL    nvarchar(120),
    BankNameUK    nvarchar(120)
)
go

create table ActProvidingServiceDocument
(
    ID            bigint identity
        constraint PK_ActProvidingServiceDocument
            primary key
                with (fillfactor = 60),
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(500),
    FileName      nvarchar(500),
    ContentType   nvarchar(500),
    GeneratedName nvarchar(500),
    Number        nvarchar(20)
)
go

create table AgreementType
(
    ID      bigint identity
        constraint PK_AgreementType
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(25),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table AgreementTypeCivilCode
(
    ID       bigint identity
        constraint PK_AgreementTypeCivilCode
            primary key,
    NetUID   uniqueidentifier default newid()      not null,
    Created  datetime2        default getutcdate() not null,
    Updated  datetime2                             not null,
    Deleted  bit              default 0            not null,
    CodeOneC nvarchar(25),
    NameUK   nvarchar(100),
    NamePL   nvarchar(100)
)
go

create table AgreementTypeTranslation
(
    ID              bigint identity
        constraint PK_AgreementTypeTranslation
            primary key,
    AgreementTypeID bigint                                not null
        constraint FK_AgreementTypeTranslation_AgreementType_AgreementTypeID
            references AgreementType
            on delete cascade,
    Created         datetime2        default getutcdate() not null,
    CultureCode     nvarchar(4),
    Deleted         bit              default 0            not null,
    Name            nvarchar(75),
    NetUID          uniqueidentifier default newid()      not null,
    Updated         datetime2                             not null
)
go

create index IX_AgreementTypeTranslation_AgreementTypeID
    on AgreementTypeTranslation (AgreementTypeID)
go

create table AllegroCategory
(
    ID               bigint identity
        constraint PK_AllegroCategory
            primary key
                with (fillfactor = 60),
    CategoryID       int                                   not null,
    Created          datetime2        default getutcdate() not null,
    Deleted          bit              default 0            not null,
    IsLeaf           bit                                   not null,
    Name             nvarchar(max),
    NetUID           uniqueidentifier default newid()      not null,
    ParentCategoryID int                                   not null,
    Position         int                                   not null,
    Updated          datetime2                             not null
)
go

create index IX_AllegroCategory_ParentCategoryID
    on AllegroCategory (ParentCategoryID)
    with (fillfactor = 60)
go

create index IX_AllegroCategory_CategoryID
    on AllegroCategory (CategoryID)
    with (fillfactor = 60)
go

create table AuditEntity
(
    ID               bigint identity
        constraint PK_AuditEntity
            primary key
                with (fillfactor = 60),
    BaseEntityNetUID uniqueidentifier                      not null,
    Created          datetime2        default getutcdate() not null,
    Deleted          bit              default 0            not null,
    NetUID           uniqueidentifier default newid()      not null,
    Type             int                                   not null,
    Updated          datetime2                             not null,
    UpdatedBy        nvarchar(max),
    UpdatedByNetUID  uniqueidentifier                      not null,
    EntityName       nvarchar(max)
)
go

create index IX_AuditEntity_BaseEntityNetUID
    on AuditEntity (BaseEntityNetUID)
    with (fillfactor = 60)
go

create table AuditEntityProperty
(
    ID            bigint identity
        constraint PK_AuditEntityProperty
            primary key
                with (fillfactor = 60),
    AuditEntityID bigint                                not null
        constraint FK_AuditEntityProperty_AuditEntity_AuditEntityID
            references AuditEntity
            on delete cascade,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    Description   nvarchar(max),
    Name          nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Type          int                                   not null,
    Updated       datetime2                             not null,
    Value         nvarchar(max)
)
go

create index IX_AuditEntityProperty_AuditEntityID
    on AuditEntityProperty (AuditEntityID)
    with (fillfactor = 60)
go

create table AuditEntityPropertyNameTranslation
(
    ID            bigint identity
        constraint PK_AuditEntityPropertyNameTranslation
            primary key,
    Created       datetime2        default getutcdate() not null,
    CultureCode   nvarchar(max),
    Deleted       bit              default 0            not null,
    Name          nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null,
    LocalizedName nvarchar(max)
)
go

create table Bank
(
    ID         bigint identity
        constraint PK_Bank
            primary key
                with (fillfactor = 60),
    NetUID     uniqueidentifier default newid()      not null,
    Created    datetime2        default getutcdate() not null,
    Updated    datetime2                             not null,
    Deleted    bit              default 0            not null,
    Name       nvarchar(100)                         not null,
    MfoCode    nvarchar(6)                           not null,
    EdrpouCode nvarchar(10)                          not null,
    City       nvarchar(150),
    Address    nvarchar(150),
    Phones     nvarchar(100)
)
go

create table BaseLifeCycleStatus
(
    ID                bigint identity
        constraint PK_BaseLifeCycleStatus
            primary key
                with (fillfactor = 60),
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    NetUID            uniqueidentifier default newid()      not null,
    SaleLifeCycleType int                                   not null,
    Updated           datetime2                             not null
)
go

create table BaseSalePaymentStatus
(
    ID                    bigint identity
        constraint PK_BaseSalePaymentStatus
            primary key
                with (fillfactor = 60),
    Amount                money                                 not null,
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    SalePaymentStatusType int                                   not null,
    Updated               datetime2                             not null
)
go

create table CalculationType
(
    ID      bigint identity
        constraint PK_CalculationType
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(25),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table CalculationTypeTranslation
(
    ID                bigint identity
        constraint PK_CalculationTypeTranslation
            primary key,
    CalculationTypeID bigint                                not null
        constraint FK_CalculationTypeTranslation_CalculationType_CalculationTypeID
            references CalculationType
            on delete cascade,
    Created           datetime2        default getutcdate() not null,
    CultureCode       nvarchar(4),
    Deleted           bit              default 0            not null,
    Name              nvarchar(75),
    NetUID            uniqueidentifier default newid()      not null,
    Updated           datetime2                             not null
)
go

create index IX_CalculationTypeTranslation_CalculationTypeID
    on CalculationTypeTranslation (CalculationTypeID)
go

create table CarBrand
(
    ID          bigint identity
        constraint PK_CarBrand
            primary key,
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    Name        nvarchar(100),
    Description nvarchar(250),
    ImageUrl    nvarchar(100),
    Alias       nvarchar(max)
)
go

create table Category
(
    ID             bigint identity
        constraint PK_Category
            primary key,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    Description    nvarchar(max),
    Name           nvarchar(max),
    NetUID         uniqueidentifier default newid()      not null,
    RootCategoryID bigint
        constraint FK_Category_Category_RootCategoryID
            references Category,
    Updated        datetime2                             not null
)
go

create index IX_Category_RootCategoryID
    on Category (RootCategoryID)
go

create table ChartMonth
(
    ID      bigint identity
        constraint PK_ChartMonth
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Number  int                                   not null,
    Updated datetime2                             not null
)
go

create table ChartMonthTranslation
(
    ID           bigint identity
        constraint PK_ChartMonthTranslation
            primary key,
    ChartMonthID bigint                                not null
        constraint FK_ChartMonthTranslation_ChartMonth_ChartMonthID
            references ChartMonth,
    Created      datetime2        default getutcdate() not null,
    CultureCode  nvarchar(max),
    Deleted      bit              default 0            not null,
    Name         nvarchar(max),
    NetUID       uniqueidentifier default newid()      not null,
    Updated      datetime2                             not null
)
go

create index IX_ChartMonthTranslation_ChartMonthID
    on ChartMonthTranslation (ChartMonthID)
go

create table ClientType
(
    ID             bigint identity
        constraint PK_ClientType
            primary key,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    Name           nvarchar(75),
    NetUID         uniqueidentifier default newid()      not null,
    Updated        datetime2                             not null,
    ClientTypeIcon nvarchar(max),
    AllowMultiple  bit              default 0            not null,
    Type           int              default 0            not null
)
go

create table ClientTypeRole
(
    ID              bigint identity
        constraint PK_ClientTypeRole
            primary key,
    ClientTypeID    bigint                                not null
        constraint FK_ClientTypeRole_ClientType_ClientTypeID
            references ClientType
            on delete cascade,
    Created         datetime2        default getutcdate() not null,
    Deleted         bit              default 0            not null,
    Description     nvarchar(max),
    Name            nvarchar(75),
    NetUID          uniqueidentifier default newid()      not null,
    Updated         datetime2                             not null,
    OrderExpireDays int              default 0            not null
)
go

create index IX_ClientTypeRole_ClientTypeID
    on ClientTypeRole (ClientTypeID)
go

create table ClientTypeRoleTranslation
(
    ID               bigint identity
        constraint PK_ClientTypeRoleTranslation
            primary key,
    ClientTypeRoleID bigint                                not null
        constraint FK_ClientTypeRoleTranslation_ClientTypeRole_ClientTypeRoleID
            references ClientTypeRole
            on delete cascade,
    Created          datetime2        default getutcdate() not null,
    CultureCode      nvarchar(4),
    Deleted          bit              default 0            not null,
    Description      nvarchar(max),
    Name             nvarchar(75),
    NetUID           uniqueidentifier default newid()      not null,
    Updated          datetime2                             not null
)
go

create index IX_ClientTypeRoleTranslation_ClientTypeRoleID
    on ClientTypeRoleTranslation (ClientTypeRoleID)
go

create table ClientTypeTranslation
(
    ID           bigint identity
        constraint PK_ClientTypeTranslation
            primary key,
    ClientTypeID bigint                                not null
        constraint FK_ClientTypeTranslation_ClientType_ClientTypeID
            references ClientType
            on delete cascade,
    Created      datetime2        default getutcdate() not null,
    CultureCode  nvarchar(4),
    Deleted      bit              default 0            not null,
    Name         nvarchar(75),
    NetUID       uniqueidentifier default newid()      not null,
    Updated      datetime2                             not null
)
go

create index IX_ClientTypeTranslation_ClientTypeID
    on ClientTypeTranslation (ClientTypeID)
go

create table ConsignmentItemMovementTypeName
(
    ID           bigint identity
        constraint PK_ConsignmentItemMovementTypeName
            primary key,
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null,
    NamePl       nvarchar(100),
    NameUa       nvarchar(100),
    MovementType int                                   not null
)
go

create table ConsignmentNoteSetting
(
    ID                 bigint identity
        constraint PK_ConsignmentNoteSetting
            primary key
                with (fillfactor = 60),
    NetUID             uniqueidentifier default newid()      not null,
    Created            datetime2        default getutcdate() not null,
    Updated            datetime2                             not null,
    Deleted            bit              default 0            not null,
    BrandAndNumberCar  nvarchar(200),
    TrailerNumber      nvarchar(200),
    Driver             nvarchar(200),
    Carrier            nvarchar(200),
    TypeTransportation nvarchar(200),
    UnloadingPoint     nvarchar(500),
    LoadingPoint       nvarchar(500),
    Customer           nvarchar(200),
    Name               nvarchar(200),
    ForReSale          bit              default 0            not null,
    CarGrossWeight     decimal(18, 2)   default 0.0          not null,
    CarHeight          int              default 0            not null,
    CarLabel           nvarchar(200),
    CarLength          int              default 0            not null,
    CarNetWeight       decimal(18, 2)   default 0.0          not null,
    CarWidth           int              default 0            not null,
    TrailerGrossWeight decimal(18, 2)   default 0.0          not null,
    TrailerHeight      int              default 0            not null,
    TrailerLabel       nvarchar(200),
    TrailerLength      int              default 0            not null,
    TrailerNetWeight   decimal(18, 2)   default 0.0          not null,
    TrailerWidth       int              default 0            not null
)
go

create table ConsumableProductCategory
(
    ID                      bigint identity
        constraint PK_ConsumableProductCategory
            primary key,
    Created                 datetime2        default getutcdate() not null,
    Deleted                 bit              default 0            not null,
    Description             nvarchar(450),
    Name                    nvarchar(150),
    NetUID                  uniqueidentifier default newid()      not null,
    Updated                 datetime2                             not null,
    IsSupplyServiceCategory bit              default 0            not null
)
go

create table ConsumableProductCategoryTranslation
(
    ID                          bigint identity
        constraint PK_ConsumableProductCategoryTranslation
            primary key,
    ConsumableProductCategoryID bigint                                not null
        constraint FK_ConsumableProductCategoryTranslation_ConsumableProductCategory_ConsumableProductCategoryID
            references ConsumableProductCategory,
    Created                     datetime2        default getutcdate() not null,
    CultureCode                 nvarchar(4),
    Deleted                     bit              default 0            not null,
    Description                 nvarchar(450),
    Name                        nvarchar(150),
    NetUID                      uniqueidentifier default newid()      not null,
    Updated                     datetime2                             not null
)
go

create index IX_ConsumableProductCategoryTranslation_ConsumableProductCategoryID
    on ConsumableProductCategoryTranslation (ConsumableProductCategoryID)
go

create table Country
(
    ID      bigint identity
        constraint PK_Country
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(150),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null,
    Code    nvarchar(25)
)
go

create table Currency
(
    ID       bigint identity
        constraint PK_Currency
            primary key,
    Code     nvarchar(25),
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    Name     nvarchar(150),
    NetUID   uniqueidentifier default newid()      not null,
    Updated  datetime2                             not null,
    CodeOneC nvarchar(25)
)
go

create table ClientBankDetailAccountNumber
(
    ID            bigint identity
        constraint PK_ClientBankDetailAccountNumber
            primary key
                with (fillfactor = 60),
    AccountNumber nvarchar(max),
    Created       datetime2        default getutcdate() not null,
    CurrencyID    bigint                                not null
        constraint FK_ClientBankDetailAccountNumber_Currency_CurrencyID
            references Currency
            on delete cascade,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null
)
go

create index IX_ClientBankDetailAccountNumber_CurrencyID
    on ClientBankDetailAccountNumber (CurrencyID)
    with (fillfactor = 60)
go

create table ClientBankDetailIbanNo
(
    ID         bigint identity
        constraint PK_ClientBankDetailIbanNo
            primary key
                with (fillfactor = 60),
    Created    datetime2        default getutcdate() not null,
    CurrencyID bigint                                not null
        constraint FK_ClientBankDetailIbanNo_Currency_CurrencyID
            references Currency
            on delete cascade,
    Deleted    bit              default 0            not null,
    IBANNO     nvarchar(max),
    NetUID     uniqueidentifier default newid()      not null,
    Updated    datetime2                             not null
)
go

create index IX_ClientBankDetailIbanNo_CurrencyID
    on ClientBankDetailIbanNo (CurrencyID)
    with (fillfactor = 60)
go

create table ClientBankDetails
(
    ID                       bigint identity
        constraint PK_ClientBankDetails
            primary key
                with (fillfactor = 60),
    AccountNumberID          bigint
        constraint FK_ClientBankDetails_ClientBankDetailAccountNumber_AccountNumberID
            references ClientBankDetailAccountNumber,
    BankAndBranch            nvarchar(max),
    ClientBankDetailIbanNoID bigint
        constraint FK_ClientBankDetails_ClientBankDetailIbanNo_ClientBankDetailIbanNoID
            references ClientBankDetailIbanNo,
    Created                  datetime2        default getutcdate() not null,
    Deleted                  bit              default 0            not null,
    NetUID                   uniqueidentifier default newid()      not null,
    Updated                  datetime2                             not null,
    BranchCode               nvarchar(max),
    Swift                    nvarchar(max),
    BankAddress              nvarchar(max)
)
go

create index IX_ClientBankDetails_AccountNumberID
    on ClientBankDetails (AccountNumberID)
    with (fillfactor = 60)
go

create index IX_ClientBankDetails_ClientBankDetailIbanNoID
    on ClientBankDetails (ClientBankDetailIbanNoID)
    with (fillfactor = 60)
go

create table CrossExchangeRate
(
    ID             bigint identity
        constraint PK_CrossExchangeRate
            primary key,
    Amount         decimal(30, 14)                       not null,
    Code           nvarchar(30),
    Created        datetime2        default getutcdate() not null,
    Culture        nvarchar(5),
    CurrencyFromID bigint                                not null
        constraint FK_CrossExchangeRate_Currency_CurrencyFromID
            references Currency,
    CurrencyToID   bigint                                not null
        constraint FK_CrossExchangeRate_Currency_CurrencyToID
            references Currency,
    Deleted        bit              default 0            not null,
    NetUID         uniqueidentifier default newid()      not null,
    Updated        datetime2                             not null
)
go

create index IX_CrossExchangeRate_CurrencyFromID
    on CrossExchangeRate (CurrencyFromID)
go

create index IX_CrossExchangeRate_CurrencyToID
    on CrossExchangeRate (CurrencyToID)
go

create table CurrencyTrader
(
    ID          bigint identity
        constraint PK_CurrencyTrader
            primary key,
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    FirstName   nvarchar(75),
    LastName    nvarchar(75),
    MiddleName  nvarchar(75),
    NetUID      uniqueidentifier default newid()      not null,
    PhoneNumber nvarchar(30),
    Updated     datetime2                             not null
)
go

create table CurrencyTraderExchangeRate
(
    ID               bigint identity
        constraint PK_CurrencyTraderExchangeRate
            primary key,
    Created          datetime2        default getutcdate()              not null,
    CurrencyName     nvarchar(25),
    CurrencyTraderID bigint                                             not null
        constraint FK_CurrencyTraderExchangeRate_CurrencyTrader_CurrencyTraderID
            references CurrencyTrader,
    Deleted          bit              default 0                         not null,
    ExchangeRate     money                                              not null,
    NetUID           uniqueidentifier default newid()                   not null,
    Updated          datetime2                                          not null,
    FromDate         datetime2        default '0001-01-01T00:00:00.000' not null
)
go

create index IX_CurrencyTraderExchangeRate_CurrencyTraderID
    on CurrencyTraderExchangeRate (CurrencyTraderID)
go

create table CurrencyTranslation
(
    ID          bigint identity
        constraint PK_CurrencyTranslation
            primary key,
    Created     datetime2        default getutcdate() not null,
    CultureCode nvarchar(max),
    CurrencyID  bigint                                not null
        constraint FK_CurrencyTranslation_Currency_CurrencyID
            references Currency
            on delete cascade,
    Deleted     bit              default 0            not null,
    Name        nvarchar(max),
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null
)
go

create index IX_CurrencyTranslation_CurrencyID
    on CurrencyTranslation (CurrencyID)
go

create table CustomersOwnTtn
(
    ID         bigint identity
        constraint PK_CustomersOwnTtn
            primary key,
    Number     nvarchar(150),
    TtnPDFPath nvarchar(max),
    NetUID     uniqueidentifier default newid()      not null,
    Created    datetime2        default getutcdate() not null,
    Updated    datetime2                             not null,
    Deleted    bit              default 0            not null
)
go

create table DashboardNodeModule
(
    ID          bigint identity
        constraint PK_DashboardNodeModule
            primary key,
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    Language    nvarchar(2),
    Module      nvarchar(75),
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null,
    CssClass    nvarchar(200),
    Description nvarchar(500)
)
go

create table DashboardNode
(
    ID                    bigint identity
        constraint PK_DashboardNode
            primary key
                with (fillfactor = 60),
    Created               datetime2        default getutcdate() not null,
    CssClass              nvarchar(200),
    DashboardNodeModuleID bigint
        constraint FK_DashboardNode_DashboardNodeModule_DashboardNodeModuleID
            references DashboardNodeModule,
    Deleted               bit              default 0            not null,
    Language              nvarchar(2),
    Module                nvarchar(75),
    NetUID                uniqueidentifier default newid()      not null,
    ParentDashboardNodeID bigint
        constraint FK_DashboardNode_DashboardNode_ParentDashboardNodeID
            references DashboardNode,
    Route                 nvarchar(4000),
    Updated               datetime2                             not null,
    DashboardNodeType     int              default 0            not null
)
go

create index IX_DashboardNode_DashboardNodeModuleID
    on DashboardNode (DashboardNodeModuleID)
go

create index IX_DashboardNode_ParentDashboardNodeID
    on DashboardNode (ParentDashboardNodeID)
go

create table Debt
(
    ID      bigint identity
        constraint PK_Debt
            primary key
                with (fillfactor = 60),
    Created datetime2        default getutcdate() not null,
    Days    int                                   not null,
    Deleted bit              default 0            not null,
    NetUID  uniqueidentifier default newid()      not null,
    Total   decimal(30, 14)                       not null,
    Updated datetime2                             not null
)
go

create table DeliveryProductProtocolNumber
(
    ID      bigint identity
        constraint PK_DeliveryProductProtocolNumber
            primary key
                with (fillfactor = 60),
    NetUID  uniqueidentifier default newid()      not null,
    Created datetime2        default getutcdate() not null,
    Updated datetime2                             not null,
    Deleted bit              default 0            not null,
    Number  nvarchar(20)
)
go

create table DocumentMonth
(
    ID          bigint identity
        constraint PK_DocumentMonth
            primary key,
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    CultureCode nvarchar(4),
    Name        nvarchar(25),
    Number      int                                   not null
)
go

create table EcommerceContactInfo
(
    ID      bigint identity
        constraint PK_EcommerceContactInfo
            primary key,
    NetUID  uniqueidentifier default newid()      not null,
    Created datetime2        default getutcdate() not null,
    Updated datetime2                             not null,
    Deleted bit              default 0            not null,
    Address nvarchar(250)                         not null,
    Phone   nvarchar(30)                          not null,
    Email   nvarchar(150)                         not null,
    SiteUrl nvarchar(200)                         not null,
    Locale  nvarchar(2),
    PixelId nvarchar(200)
)
go

create table EcommerceContacts
(
    ID      bigint identity
        constraint PK_EcommerceContacts
            primary key
                with (fillfactor = 60),
    NetUID  uniqueidentifier default newid()      not null,
    Created datetime2        default getutcdate() not null,
    Updated datetime2                             not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(150),
    Phone   nvarchar(30),
    Skype   nvarchar(150),
    Icq     nvarchar(20),
    Email   nvarchar(150),
    ImgUrl  nvarchar(4000)
)
go

create table EcommercePage
(
    ID            bigint identity
        constraint PK_EcommercePage
            primary key
                with (fillfactor = 60),
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    PageName      nvarchar(max),
    TitleUa       nvarchar(100),
    TitleRu       nvarchar(100),
    DescriptionUa nvarchar(1000),
    DescriptionRu nvarchar(1000),
    KeyWords      nvarchar(1000),
    LdJson        nvarchar(4000),
    UrlUa         nvarchar(1000),
    UrlRu         nvarchar(1000)
)
go

create table EcommerceRegion
(
    ID             bigint identity
        constraint PK_EcommerceRegion
            primary key,
    NetUID         uniqueidentifier default newid()      not null,
    Created        datetime2        default getutcdate() not null,
    Updated        datetime2                             not null,
    Deleted        bit              default 0            not null,
    NameUa         nvarchar(150),
    IsLocalPayment bit                                   not null,
    NameRu         nvarchar(150)
)
go

create table ExchangeRate
(
    ID         bigint identity
        constraint PK_ExchangeRate
            primary key,
    Created    datetime2        default getutcdate() not null,
    Culture    nvarchar(max),
    Deleted    bit              default 0            not null,
    NetUID     uniqueidentifier default newid()      not null,
    Updated    datetime2                             not null,
    Amount     decimal(30, 14)                       not null,
    Currency   nvarchar(max),
    CurrencyID bigint
        constraint FK_ExchangeRate_Currency_CurrencyID
            references Currency,
    Code       nvarchar(max)
)
go

create index IX_ExchangeRate_CurrencyID
    on ExchangeRate (CurrencyID)
go

create table FilterItem
(
    ID          bigint identity
        constraint PK_FilterItem
            primary key,
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    Description nvarchar(max),
    Name        nvarchar(max),
    NetUID      uniqueidentifier default newid()      not null,
    SQL         nvarchar(max),
    Updated     datetime2                             not null,
    Type        int              default 0            not null,
    [Order]     int              default 0            not null
)
go

create table FilterItemTranslation
(
    ID           bigint identity
        constraint PK_FilterItemTranslation
            primary key,
    Created      datetime2        default getutcdate() not null,
    CultureCode  nvarchar(max),
    Deleted      bit              default 0            not null,
    Description  nvarchar(max),
    FilterItemID bigint                                not null
        constraint FK_FilterItemTranslation_FilterItem_FilterItemID
            references FilterItem
            on delete cascade,
    Name         nvarchar(max),
    NetUID       uniqueidentifier default newid()      not null,
    Updated      datetime2                             not null
)
go

create index IX_FilterItemTranslation_FilterItemID
    on FilterItemTranslation (FilterItemID)
go

create table FilterOperationItem
(
    ID      bigint identity
        constraint PK_FilterOperationItem
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(25),
    NetUID  uniqueidentifier default newid()      not null,
    SQL     nvarchar(25),
    Updated datetime2                             not null
)
go

create table FilterOperationItemTranslation
(
    ID                    bigint identity
        constraint PK_FilterOperationItemTranslation
            primary key,
    Created               datetime2        default getutcdate() not null,
    CultureCode           nvarchar(max),
    Deleted               bit              default 0            not null,
    FilterOperationItemID bigint                                not null
        constraint FK_FilterOperationItemTranslation_FilterOperationItem_FilterOperationItemID
            references FilterOperationItem
            on delete cascade,
    Name                  nvarchar(max),
    NetUID                uniqueidentifier default newid()      not null,
    Updated               datetime2                             not null
)
go

create index IX_FilterOperationItemTranslation_FilterOperationItemID
    on FilterOperationItemTranslation (FilterOperationItemID)
go

create table GovCrossExchangeRate
(
    ID             bigint identity
        constraint PK_GovCrossExchangeRate
            primary key,
    NetUID         uniqueidentifier default newid()      not null,
    Created        datetime2        default getutcdate() not null,
    Updated        datetime2                             not null,
    Deleted        bit              default 0            not null,
    CurrencyFromID bigint                                not null
        constraint FK_GovCrossExchangeRate_Currency_CurrencyFromID
            references Currency,
    CurrencyToID   bigint                                not null
        constraint FK_GovCrossExchangeRate_Currency_CurrencyToID
            references Currency,
    Amount         decimal(30, 14)                       not null,
    Code           nvarchar(30),
    Culture        nvarchar(5)
)
go

create index IX_GovCrossExchangeRate_CurrencyFromID
    on GovCrossExchangeRate (CurrencyFromID)
go

create index IX_GovCrossExchangeRate_CurrencyToID
    on GovCrossExchangeRate (CurrencyToID)
go

create table GovExchangeRate
(
    ID         bigint identity
        constraint PK_GovExchangeRate
            primary key,
    NetUID     uniqueidentifier default newid()      not null,
    Created    datetime2        default getutcdate() not null,
    Updated    datetime2                             not null,
    Deleted    bit              default 0            not null,
    Culture    nvarchar(max),
    Amount     decimal(30, 14)                       not null,
    Currency   nvarchar(max),
    Code       nvarchar(max),
    CurrencyID bigint
        constraint FK_GovExchangeRate_Currency_CurrencyID
            references Currency
)
go

create index IX_GovExchangeRate_CurrencyID
    on GovExchangeRate (CurrencyID)
go

create table Incoterm
(
    ID           bigint identity
        constraint PK_Incoterm
            primary key,
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null,
    IncotermName nvarchar(250)
)
go

create table MeasureUnit
(
    ID          bigint identity
        constraint PK_MeasureUnit
            primary key,
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    Description nvarchar(max),
    Name        nvarchar(25),
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null,
    CodeOneC    nvarchar(25)
)
go

create table ConsumableProduct
(
    ID                          bigint identity
        constraint PK_ConsumableProduct
            primary key,
    ConsumableProductCategoryID bigint                                not null
        constraint FK_ConsumableProduct_ConsumableProductCategory_ConsumableProductCategoryID
            references ConsumableProductCategory,
    Created                     datetime2        default getutcdate() not null,
    Deleted                     bit              default 0            not null,
    Name                        nvarchar(150),
    NetUID                      uniqueidentifier default newid()      not null,
    Updated                     datetime2                             not null,
    VendorCode                  nvarchar(3),
    MeasureUnitID               bigint
        constraint FK_ConsumableProduct_MeasureUnit_MeasureUnitID
            references MeasureUnit
)
go

create index IX_ConsumableProduct_ConsumableProductCategoryID
    on ConsumableProduct (ConsumableProductCategoryID)
go

create index IX_ConsumableProduct_MeasureUnitID
    on ConsumableProduct (MeasureUnitID)
go

create table ConsumableProductTranslation
(
    ID                  bigint identity
        constraint PK_ConsumableProductTranslation
            primary key,
    ConsumableProductID bigint                                not null
        constraint FK_ConsumableProductTranslation_ConsumableProduct_ConsumableProductID
            references ConsumableProduct,
    Created             datetime2        default getutcdate() not null,
    CultureCode         nvarchar(4),
    Deleted             bit              default 0            not null,
    Name                nvarchar(150),
    NetUID              uniqueidentifier default newid()      not null,
    Updated             datetime2                             not null
)
go

create index IX_ConsumableProductTranslation_ConsumableProductID
    on ConsumableProductTranslation (ConsumableProductID)
go

create table MeasureUnitTranslation
(
    ID            bigint identity
        constraint PK_MeasureUnitTranslation
            primary key,
    Created       datetime2        default getutcdate() not null,
    CultureCode   nvarchar(max),
    Deleted       bit              default 0            not null,
    Description   nvarchar(max),
    MeasureUnitID bigint                                not null
        constraint FK_MeasureUnitTranslation_MeasureUnit_MeasureUnitID
            references MeasureUnit
            on delete cascade,
    Name          nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null
)
go

create index IX_MeasureUnitTranslation_MeasureUnitID
    on MeasureUnitTranslation (MeasureUnitID)
go

create table OrganizationClient
(
    ID           bigint identity
        constraint PK_OrganizationClient
            primary key,
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null,
    FullName     nvarchar(500),
    Address      nvarchar(500),
    Country      nvarchar(100),
    City         nvarchar(100),
    NIP          nvarchar(100),
    MarginAmount money                                 not null
)
go

create table OriginalNumber
(
    ID         bigint identity
        constraint PK_OriginalNumber
            primary key
                with (fillfactor = 60),
    Created    datetime2        default getutcdate() not null,
    Deleted    bit              default 0            not null,
    MainNumber nvarchar(max),
    NetUID     uniqueidentifier default newid()      not null,
    Number     nvarchar(max),
    Updated    datetime2                             not null
)
go

create table PackingMarking
(
    ID      bigint identity
        constraint PK_PackingMarking
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table PackingMarkingPayment
(
    ID      bigint identity
        constraint PK_PackingMarkingPayment
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table PaymentCostMovement
(
    ID            bigint identity
        constraint PK_PaymentCostMovement
            primary key,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    OperationName nvarchar(150),
    Updated       datetime2                             not null
)
go

create table PaymentCostMovementTranslation
(
    ID                    bigint identity
        constraint PK_PaymentCostMovementTranslation
            primary key,
    Created               datetime2        default getutcdate() not null,
    CultureCode           nvarchar(4),
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    OperationName         nvarchar(150),
    PaymentCostMovementID bigint                                not null
        constraint FK_PaymentCostMovementTranslation_PaymentCostMovement_PaymentCostMovementID
            references PaymentCostMovement,
    Updated               datetime2                             not null
)
go

create index IX_PaymentCostMovementTranslation_PaymentCostMovementID
    on PaymentCostMovementTranslation (PaymentCostMovementID)
go

create table PaymentMovement
(
    ID            bigint identity
        constraint PK_PaymentMovement
            primary key,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null,
    OperationName nvarchar(150)
)
go

create table PaymentMovementTranslation
(
    ID                bigint identity
        constraint PK_PaymentMovementTranslation
            primary key,
    Created           datetime2        default getutcdate() not null,
    CultureCode       nvarchar(4),
    Deleted           bit              default 0            not null,
    Name              nvarchar(150),
    NetUID            uniqueidentifier default newid()      not null,
    PaymentMovementID bigint                                not null
        constraint FK_PaymentMovementTranslation_PaymentMovement_PaymentMovementID
            references PaymentMovement,
    Updated           datetime2                             not null
)
go

create index IX_PaymentMovementTranslation_PaymentMovementID
    on PaymentMovementTranslation (PaymentMovementID)
go

create table PerfectClient
(
    ID               bigint identity
        constraint PK_PerfectClient
            primary key
                with (fillfactor = 60),
    Created          datetime2        default getutcdate() not null,
    Deleted          bit              default 0            not null,
    IsSelected       bit              default 0            not null,
    Lable            nvarchar(100),
    NetUID           uniqueidentifier default newid()      not null,
    Updated          datetime2                             not null,
    Value            nvarchar(max),
    Type             int              default 1            not null,
    Description      nvarchar(250),
    ClientTypeRoleID bigint
        constraint FK_PerfectClient_ClientTypeRole_ClientTypeRoleID
            references ClientTypeRole
)
go

create index IX_PerfectClient_ClientTypeRoleID
    on PerfectClient (ClientTypeRoleID)
go

create table PerfectClientTranslation
(
    ID              bigint identity
        constraint PK_PerfectClientTranslation
            primary key
                with (fillfactor = 70),
    Created         datetime2        default getutcdate() not null,
    CultureCode     nvarchar(max),
    Deleted         bit              default 0            not null,
    Description     nvarchar(max),
    Name            nvarchar(max),
    NetUID          uniqueidentifier default newid()      not null,
    PerfectClientID bigint                                not null
        constraint FK_PerfectClientTranslation_PerfectClient_PerfectClientID
            references PerfectClient,
    Updated         datetime2                             not null
)
go

create index IX_PerfectClientTranslation_PerfectClientID
    on PerfectClientTranslation (PerfectClientID)
go

create table PerfectClientValue
(
    ID              bigint identity
        constraint PK_PerfectClientValue
            primary key
                with (fillfactor = 60),
    Created         datetime2        default getutcdate() not null,
    Deleted         bit              default 0            not null,
    IsSelected      bit                                   not null,
    NetUID          uniqueidentifier default newid()      not null,
    PerfectClientID bigint                                not null
        constraint FK_PerfectClientValue_PerfectClient_PerfectClientID
            references PerfectClient
            on delete cascade,
    Updated         datetime2                             not null,
    Value           nvarchar(max)
)
go

create index IX_PerfectClientValue_PerfectClientID
    on PerfectClientValue (PerfectClientID)
go

create table PerfectClientValueTranslation
(
    ID                   bigint identity
        constraint PK_PerfectClientValueTranslation
            primary key
                with (fillfactor = 60),
    Created              datetime2        default getutcdate() not null,
    CultureCode          nvarchar(max),
    Deleted              bit              default 0            not null,
    NetUID               uniqueidentifier default newid()      not null,
    PerfectClientValueID bigint                                not null
        constraint FK_PerfectClientValueTranslation_PerfectClientValue_PerfectClientValueID
            references PerfectClientValue
            on delete cascade,
    Updated              datetime2                             not null,
    Value                nvarchar(max)
)
go

create index IX_PerfectClientValueTranslation_PerfectClientValueID
    on PerfectClientValueTranslation (PerfectClientValueID)
go

create table Permission
(
    ID              bigint identity
        constraint PK_Permission
            primary key,
    ControlId       nvarchar(max),
    Name            nvarchar(500),
    ImageUrl        nvarchar(max),
    Description     nvarchar(500),
    DashboardNodeID bigint                                not null
        constraint FK_Permission_DashboardNode_DashboardNodeID
            references DashboardNode
            on delete cascade,
    NetUID          uniqueidentifier default newid()      not null,
    Created         datetime2        default getutcdate() not null,
    Updated         datetime2                             not null,
    Deleted         bit              default 0            not null
)
go

create index IX_Permission_DashboardNodeID
    on Permission (DashboardNodeID)
go

create table PriceType
(
    ID      bigint identity
        constraint PK_PriceType
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(30),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table PriceTypeTranslation
(
    ID          bigint identity
        constraint PK_PriceTypeTranslation
            primary key,
    Created     datetime2        default getutcdate() not null,
    CultureCode nvarchar(4),
    Deleted     bit              default 0            not null,
    Name        nvarchar(50),
    NetUID      uniqueidentifier default newid()      not null,
    PriceTypeID bigint                                not null
        constraint FK_PriceTypeTranslation_PriceType_PriceTypeID
            references PriceType
            on delete cascade,
    Updated     datetime2                             not null
)
go

create index IX_PriceTypeTranslation_PriceTypeID
    on PriceTypeTranslation (PriceTypeID)
go

create table Pricing
(
    ID                    bigint identity
        constraint PK_Pricing
            primary key,
    BasePricingID         bigint
        constraint FK_Pricing_Pricing_BasePricingID
            references Pricing,
    Comment               nvarchar(max),
    Created               datetime2        default getutcdate() not null,
    CurrencyID            bigint
        constraint FK_Pricing_Currency_CurrencyID
            references Currency,
    Deleted               bit              default 0            not null,
    ExtraCharge           float,
    Name                  nvarchar(30),
    NetUID                uniqueidentifier default newid()      not null,
    Updated               datetime2                             not null,
    PriceTypeID           bigint
        constraint FK_Pricing_PriceType_PriceTypeID
            references PriceType,
    Culture               nvarchar(max),
    CalculatedExtraCharge money            default 0.0          not null,
    ForShares             bit              default 0            not null,
    ForVat                bit              default 0            not null,
    SortingPriority       int              default 0            not null
)
go

create table EcommerceDefaultPricing
(
    ID                   bigint identity
        constraint PK_EcommerceDefaultPricing
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    PricingID            bigint                                not null
        constraint FK_EcommerceDefaultPricing_Pricing_PricingID
            references Pricing,
    PromotionalPricingID bigint                                not null
        constraint FK_EcommerceDefaultPricing_Pricing_PromotionalPricingID
            references Pricing
)
go

create index IX_EcommerceDefaultPricing_PricingID
    on EcommerceDefaultPricing (PricingID)
go

create index IX_EcommerceDefaultPricing_PromotionalPricingID
    on EcommerceDefaultPricing (PromotionalPricingID)
go

create index IX_Pricing_BasePricingID
    on Pricing (BasePricingID)
go

create index IX_Pricing_CurrencyID
    on Pricing (CurrencyID)
go

create index IX_Pricing_PriceTypeID
    on Pricing (PriceTypeID)
go

create table PricingTranslation
(
    ID          bigint identity
        constraint PK_PricingTranslation
            primary key
                with (fillfactor = 60),
    Created     datetime2        default getutcdate() not null,
    CultureCode nvarchar(4),
    Deleted     bit              default 0            not null,
    Name        nvarchar(30),
    NetUID      uniqueidentifier default newid()      not null,
    PricingID   bigint                                not null
        constraint FK_PricingTranslation_Pricing_PricingID
            references Pricing
            on delete cascade,
    Updated     datetime2                             not null
)
go

create index IX_PricingTranslation_PricingID_CultureCode_Deleted
    on PricingTranslation (PricingID, CultureCode, Deleted)
go

create table Product
(
    ID                  bigint identity
        constraint PK_Product
            primary key
                with (fillfactor = 60),
    Created             datetime2        default getutcdate() not null,
    Deleted             bit              default 0            not null,
    Description         nvarchar(2000),
    HasAnalogue         bit                                   not null,
    HasImage            bit                                   not null,
    IsForSale           bit                                   not null,
    IsForWeb            bit                                   not null,
    IsForZeroSale       bit                                   not null,
    MainOriginalNumber  nvarchar(80),
    MeasureUnitID       bigint                                not null
        constraint FK_Product_MeasureUnit_MeasureUnitID
            references MeasureUnit,
    Name                nvarchar(120),
    NetUID              uniqueidentifier default newid()      not null,
    OrderStandard       nvarchar(max),
    PackingStandard     nvarchar(max),
    Size                nvarchar(100),
    UCGFEA              nvarchar(max),
    Updated             datetime2                             not null,
    VendorCode          nvarchar(40),
    Volume              nvarchar(max),
    Weight              float                                 not null,
    HasComponent        bit              default 0            not null,
    Image               nvarchar(max),
    [Top]               nvarchar(3),
    DescriptionPL       nvarchar(2000),
    DescriptionUA       nvarchar(2000),
    NamePL              nvarchar(120),
    NameUA              nvarchar(120),
    SourceAmgID         varbinary(16),
    SourceFenixID       varbinary(16),
    SearchDescriptionPL nvarchar(2000),
    SearchNamePL        nvarchar(120),
    NotesPL             nvarchar(2000),
    NotesUA             nvarchar(2000),
    SearchDescriptionUA nvarchar(2000),
    SearchNameUA        nvarchar(120),
    SearchSize          nvarchar(100),
    SearchVendorCode    nvarchar(40),
    SearchDescription   nvarchar(2000),
    SearchName          nvarchar(120),
    SearchSynonymsPL    nvarchar(2000),
    SearchSynonymsUA    nvarchar(2000),
    SynonymsPL          nvarchar(2000),
    SynonymsUA          nvarchar(2000),
    Standard            nvarchar(max),
    ParentAmgID         varbinary(16),
    ParentFenixID       varbinary(16),
    SourceAmgCode       bigint,
    SourceFenixCode     bigint
)
go

create table AllegroProductReservation
(
    ID            bigint identity
        constraint PK_AllegroProductReservation
            primary key,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    ProductID     bigint                                not null
        constraint FK_AllegroProductReservation_Product_ProductID
            references Product,
    Qty           float                                 not null,
    Updated       datetime2                             not null,
    AllegroItemID bigint           default 0            not null
)
go

create index IX_AllegroProductReservation_ProductID
    on AllegroProductReservation (ProductID)
go

create index IX_Product_MeasureUnitID
    on Product (MeasureUnitID)
    with (fillfactor = 60)
go

create index IX_Product_Description_Deleted
    on Product (Description, Deleted)
    with (fillfactor = 60)
go

create index IX_Product_MainOriginalNumber_Deleted
    on Product (MainOriginalNumber, Deleted)
    with (fillfactor = 60)
go

create index IX_Product_Name_Deleted
    on Product (Name, Deleted)
    with (fillfactor = 60)
go

create index IX_Product_VendorCode_Deleted
    on Product (VendorCode, Deleted)
    with (fillfactor = 60)
go

create unique index IX_Product_NetUID
    on Product (NetUID)
    with (fillfactor = 60)
go

create index IX_Product_Deleted_SearchNamePL_SearchVendorCode
    on Product (Deleted, SearchNamePL, SearchVendorCode)
    with (fillfactor = 60)
go

create index IX_Product_Deleted_SearchNameUA_SearchVendorCode
    on Product (Deleted, SearchNameUA, SearchVendorCode)
    with (fillfactor = 60)
go

create table ProductAnalogue
(
    ID                bigint identity
        constraint PK_ProductAnalogue
            primary key
                with (fillfactor = 60),
    AnalogueProductID bigint                                not null
        constraint FK_ProductAnalogue_Product_AnalogueProductID
            references Product,
    BaseProductID     bigint                                not null
        constraint FK_ProductAnalogue_Product_BaseProductID
            references Product,
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    NetUID            uniqueidentifier default newid()      not null,
    Updated           datetime2                             not null
)
go

create index IX_ProductAnalogue_AnalogueProductID
    on ProductAnalogue (AnalogueProductID)
    with (fillfactor = 60)
go

create index IX_ProductAnalogue_BaseProductID
    on ProductAnalogue (BaseProductID)
    with (fillfactor = 60)
go

create index IX_ProductAnalogue_Deleted_AnalogueProductID
    on ProductAnalogue (Deleted, AnalogueProductID)
    with (fillfactor = 60)
go

create index IX_ProductAnalogue_Deleted_BaseProductID
    on ProductAnalogue (Deleted, BaseProductID)
    with (fillfactor = 60)
go

create table ProductAvailabilityCartLimits
(
    ID                bigint identity
        primary key,
    ProductId         bigint not null
        unique
        references Product,
    MinAvailabilityUA float  not null
        check ([MinAvailabilityUA] >= 1),
    MaxAvailabilityUA float  not null
        check ([MaxAvailabilityUA] >= 1),
    MinAvailabilityPL float  not null
        check ([MinAvailabilityPL] >= 1),
    check ([MaxAvailabilityUA] > [MinAvailabilityUA])
)
go

create table ProductCarBrand
(
    ID         bigint identity
        constraint PK_ProductCarBrand
            primary key
                with (fillfactor = 60),
    NetUID     uniqueidentifier default newid()      not null,
    Created    datetime2        default getutcdate() not null,
    Updated    datetime2                             not null,
    Deleted    bit              default 0            not null,
    CarBrandID bigint                                not null
        constraint FK_ProductCarBrand_CarBrand_CarBrandID
            references CarBrand,
    ProductID  bigint                                not null
        constraint FK_ProductCarBrand_Product_ProductID
            references Product
)
go

create index IX_ProductCarBrand_CarBrandID
    on ProductCarBrand (CarBrandID)
    with (fillfactor = 60)
go

create index IX_ProductCarBrand_ProductID
    on ProductCarBrand (ProductID)
    with (fillfactor = 60)
go

create table ProductCategory
(
    ID         bigint identity
        constraint PK_ProductCategory
            primary key,
    CategoryID bigint                                not null
        constraint FK_ProductCategory_Category_CategoryID
            references Category,
    Created    datetime2        default getutcdate() not null,
    Deleted    bit              default 0            not null,
    NetUID     uniqueidentifier default newid()      not null,
    ProductID  bigint                                not null
        constraint FK_ProductCategory_Product_ProductID
            references Product,
    Updated    datetime2                             not null
)
go

create index IX_ProductCategory_CategoryID
    on ProductCategory (CategoryID)
go

create index IX_ProductCategory_ProductID
    on ProductCategory (ProductID)
go

create table ProductGroup
(
    ID            bigint identity
        constraint PK_ProductGroup
            primary key
                with (fillfactor = 60),
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    Description   nvarchar(max),
    FullName      nvarchar(max),
    Name          nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null,
    IsSubGroup    bit              default 0            not null,
    SourceFenixID varbinary(16),
    IsActive      bit              default 0            not null,
    SourceAmgID   varbinary(16)
)
go

create table PricingProductGroupDiscount
(
    ID                    bigint identity
        constraint PK_PricingProductGroupDiscount
            primary key
                with (fillfactor = 60),
    Amount                money                                 not null,
    BasePricingID         bigint
        constraint FK_PricingProductGroupDiscount_Pricing_BasePricingID
            references Pricing,
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    PricingID             bigint                                not null
        constraint FK_PricingProductGroupDiscount_Pricing_PricingID
            references Pricing,
    ProductGroupID        bigint                                not null
        constraint FK_PricingProductGroupDiscount_ProductGroup_ProductGroupID
            references ProductGroup,
    Updated               datetime2                             not null,
    CalculatedExtraCharge money            default 0.0          not null
)
go

create index IX_PricingProductGroupDiscount_BasePricingID
    on PricingProductGroupDiscount (BasePricingID)
go

create index IX_PricingProductGroupDiscount_PricingID
    on PricingProductGroupDiscount (PricingID)
go

create index IX_PricingProductGroupDiscount_ProductGroupID
    on PricingProductGroupDiscount (ProductGroupID)
go

create table ProductImage
(
    ID          bigint identity
        constraint PK_ProductImage
            primary key
                with (fillfactor = 60),
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    ImageUrl    nvarchar(500),
    NetUID      uniqueidentifier default newid()      not null,
    ProductID   bigint                                not null
        constraint FK_ProductImage_Product_ProductID
            references Product,
    Updated     datetime2                             not null,
    IsMainImage bit              default 0            not null
)
go

create index IX_ProductImage_ProductID
    on ProductImage (ProductID)
    with (fillfactor = 60)
go

create table ProductOriginalNumber
(
    ID                   bigint identity
        constraint PK_ProductOriginalNumber
            primary key
                with (fillfactor = 60),
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    NetUID               uniqueidentifier default newid()      not null,
    OriginalNumberID     bigint                                not null
        constraint FK_ProductOriginalNumber_OriginalNumber_OriginalNumberID
            references OriginalNumber,
    ProductID            bigint                                not null
        constraint FK_ProductOriginalNumber_Product_ProductID
            references Product,
    Updated              datetime2                             not null,
    IsMainOriginalNumber bit              default 0            not null
)
go

create index IX_ProductOriginalNumber_OriginalNumberID
    on ProductOriginalNumber (OriginalNumberID)
    with (fillfactor = 60)
go

create index IX_ProductOriginalNumber_ProductID
    on ProductOriginalNumber (ProductID)
    with (fillfactor = 60)
go

create index IX_ProductOriginalNumber_Deleted_OriginalNumberID
    on ProductOriginalNumber (Deleted, OriginalNumberID)
    with (fillfactor = 60)
go

create index IX_ProductOriginalNumber_Deleted_ProductID
    on ProductOriginalNumber (Deleted, ProductID)
    with (fillfactor = 60)
go

create table ProductPricing
(
    ID        bigint identity
        constraint PK_ProductPricing
            primary key
                with (fillfactor = 60),
    Created   datetime2        default getutcdate() not null,
    Deleted   bit              default 0            not null,
    NetUID    uniqueidentifier default newid()      not null,
    PricingID bigint                                not null
        constraint FK_ProductPricing_Pricing_PricingID
            references Pricing
            on delete cascade,
    ProductID bigint                                not null
        constraint FK_ProductPricing_Product_ProductID
            references Product
            on delete cascade,
    Updated   datetime2                             not null,
    Price     money            default 0.0          not null
)
go

create index IX_ProductPricing_PricingID
    on ProductPricing (PricingID)
    with (fillfactor = 60)
go

create index IX_ProductPricing_ProductID
    on ProductPricing (ProductID)
    with (fillfactor = 60)
go

create index IX_ProductPricing_Deleted_ProductID
    on ProductPricing (Deleted, ProductID)
    with (fillfactor = 60)
go

create index IX_ProductPricing_Deleted_PricingID
    on ProductPricing (Deleted, PricingID)
    with (fillfactor = 60)
go

create table ProductProductGroup
(
    ID             bigint identity
        constraint PK_ProductProductGroup
            primary key
                with (fillfactor = 60),
    Created        datetime2        default getutcdate()            not null,
    Deleted        bit              default 0                       not null,
    NetUID         uniqueidentifier default newid()                 not null,
    ProductGroupID bigint                                           not null
        constraint FK_ProductProductGroup_ProductGroup_ProductGroupID
            references ProductGroup,
    ProductID      bigint                                           not null
        constraint FK_ProductProductGroup_Product_ProductID
            references Product,
    Updated        datetime2                                        not null,
    OrderStandard  float            default 0.0000000000000000e+000 not null,
    VendorCode     nvarchar(50)
)
go

create index IX_ProductProductGroup_ProductGroupID
    on ProductProductGroup (ProductGroupID)
    with (fillfactor = 60)
go

create index IX_ProductProductGroup_ProductID
    on ProductProductGroup (ProductID)
    with (fillfactor = 60)
go

create index IX_ProductProductGroup_Deleted_ProductGroupID
    on ProductProductGroup (Deleted, ProductGroupID)
    with (fillfactor = 60)
go

create index IX_ProductProductGroup_Deleted_ProductID
    on ProductProductGroup (Deleted, ProductID)
    with (fillfactor = 60)
go

create index IX_ProductProductGroup_Deleted_ProductID_ProductGroupID
    on ProductProductGroup (Deleted, ProductID, ProductGroupID)
    with (fillfactor = 60)
go

create table ProductSet
(
    ID                 bigint identity
        constraint PK_ProductSet
            primary key
                with (fillfactor = 60),
    BaseProductID      bigint                                not null
        constraint FK_ProductSet_Product_BaseProductID
            references Product,
    ComponentProductID bigint                                not null
        constraint FK_ProductSet_Product_ComponentProductID
            references Product,
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null,
    SetComponentsQty   int              default 1            not null
)
go

create index IX_ProductSet_BaseProductID
    on ProductSet (BaseProductID)
    with (fillfactor = 60)
go

create index IX_ProductSet_ComponentProductID
    on ProductSet (ComponentProductID)
    with (fillfactor = 60)
go

create index IX_ProductSet_Deleted_BaseProductID
    on ProductSet (Deleted, BaseProductID)
    with (fillfactor = 60)
go

create index IX_ProductSet_Deleted_ComponentProductID
    on ProductSet (Deleted, ComponentProductID)
    with (fillfactor = 60)
go

create table ProductSlug
(
    ID        bigint identity
        constraint PK_ProductSlug
            primary key
                with (fillfactor = 60),
    NetUID    uniqueidentifier default newid()      not null,
    Created   datetime2        default getutcdate() not null,
    Updated   datetime2                             not null,
    Deleted   bit              default 0            not null,
    Url       nvarchar(250),
    Locale    nvarchar(4),
    ProductID bigint                                not null
        constraint FK_ProductSlug_Product_ProductID
            references Product
)
go

create index IX_ProductSlug_ProductID
    on ProductSlug (ProductID)
    with (fillfactor = 60)
go

create table ProductSubGroup
(
    ID                 bigint identity
        constraint PK_ProductSubGroup
            primary key,
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    NetUID             uniqueidentifier default newid()      not null,
    RootProductGroupID bigint                                not null
        constraint FK_ProductSubGroup_ProductGroup_RootProductGroupID
            references ProductGroup,
    SubProductGroupID  bigint                                not null
        constraint FK_ProductSubGroup_ProductGroup_SubProductGroupID
            references ProductGroup,
    Updated            datetime2                             not null
)
go

create index IX_ProductSubGroup_RootProductGroupID
    on ProductSubGroup (RootProductGroupID)
go

create index IX_ProductSubGroup_SubProductGroupID
    on ProductSubGroup (SubProductGroupID)
go

create table ProviderPricing
(
    ID            bigint identity
        constraint PK_ProviderPricing
            primary key
                with (fillfactor = 60),
    BasePricingID bigint
        constraint FK_ProviderPricing_Pricing_BasePricingID
            references Pricing,
    Created       datetime2        default getutcdate() not null,
    CurrencyID    bigint
        constraint FK_ProviderPricing_Currency_CurrencyID
            references Currency,
    Deleted       bit              default 0            not null,
    Name          nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null
)
go

create index IX_ProviderPricing_BasePricingID
    on ProviderPricing (BasePricingID)
    with (fillfactor = 60)
go

create index IX_ProviderPricing_CurrencyID
    on ProviderPricing (CurrencyID)
    with (fillfactor = 60)
go

create table Region
(
    ID      bigint identity
        constraint PK_Region
            primary key
                with (fillfactor = 60),
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(5),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table RegionCode
(
    ID       bigint identity
        constraint PK_RegionCode
            primary key
                with (fillfactor = 60),
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    NetUID   uniqueidentifier default newid()      not null,
    Updated  datetime2                             not null,
    Value    nvarchar(10),
    RegionID bigint           default 0            not null
        constraint FK_RegionCode_Region_RegionID
            references Region,
    City     nvarchar(150),
    District nvarchar(150)
)
go

create index IX_RegionCode_RegionID
    on RegionCode (RegionID)
    with (fillfactor = 60)
go

create table ResidenceCard
(
    ID       bigint identity
        constraint PK_ResidenceCard
            primary key,
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    FromDate datetime2                             not null,
    NetUID   uniqueidentifier default newid()      not null,
    ToDate   datetime2                             not null,
    Updated  datetime2                             not null
)
go

create table RetailClient
(
    ID                bigint identity
        constraint PK_RetailClient
            primary key
                with (fillfactor = 60),
    NetUID            uniqueidentifier default newid()      not null,
    Created           datetime2        default getutcdate() not null,
    Updated           datetime2                             not null,
    Deleted           bit              default 0            not null,
    Name              nvarchar(150),
    PhoneNumber       nvarchar(max)                         not null,
    ShoppingCartJson  nvarchar(max),
    EcommerceRegionId bigint
        constraint FK_RetailClient_EcommerceRegion_EcommerceRegionId
            references EcommerceRegion
)
go

create index IX_RetailClient_EcommerceRegionId
    on RetailClient (EcommerceRegionId)
    with (fillfactor = 60)
go

create table RetailPaymentStatus
(
    ID                      bigint identity
        constraint PK_RetailPaymentStatus
            primary key,
    NetUID                  uniqueidentifier default newid()      not null,
    Created                 datetime2        default getutcdate() not null,
    Updated                 datetime2                             not null,
    Deleted                 bit              default 0            not null,
    RetailPaymentStatusType int                                   not null,
    Amount                  decimal(18, 2)                        not null,
    PaidAmount              decimal(18, 2)   default 0.0          not null
)
go

create table RetailPaymentTypeTranslate
(
    ID                      bigint identity
        constraint PK_RetailPaymentTypeTranslate
            primary key,
    NetUID                  uniqueidentifier default newid()      not null,
    Created                 datetime2        default getutcdate() not null,
    Updated                 datetime2                             not null,
    Deleted                 bit              default 0            not null,
    LowPrice                nvarchar(250),
    CultureCode             nvarchar(5),
    FullPrice               nvarchar(250),
    Comment                 nvarchar(500),
    FastOrderSuccessMessage nvarchar(500),
    ScreenshotMessage       nvarchar(max)
)
go

create table SadPalletType
(
    ID       bigint identity
        constraint PK_SadPalletType
            primary key,
    NetUID   uniqueidentifier default newid()      not null,
    Created  datetime2        default getutcdate() not null,
    Updated  datetime2                             not null,
    Deleted  bit              default 0            not null,
    Name     nvarchar(100),
    CssClass nvarchar(50),
    Weight   float                                 not null
)
go

create table SaleBaseShiftStatus
(
    ID          bigint identity
        constraint PK_SaleBaseShiftStatus
            primary key
                with (fillfactor = 60),
    Comment     nvarchar(max),
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    NetUID      uniqueidentifier default newid()      not null,
    ShiftStatus int                                   not null,
    Updated     datetime2                             not null
)
go

create table SaleInvoiceDocument
(
    ID                          bigint identity
        constraint PK_SaleInvoiceDocument
            primary key
                with (fillfactor = 60),
    City                        nvarchar(max),
    ClientPaymentType           int                                   not null,
    Created                     datetime2        default getutcdate() not null,
    Deleted                     bit              default 0            not null,
    NetUID                      uniqueidentifier default newid()      not null,
    PaymentType                 int                                   not null,
    Updated                     datetime2                             not null,
    Vat                         money            default 0.0          not null,
    ShippingAmount              money            default 0.0          not null,
    ShippingAmountEur           money            default 0.0          not null,
    ExchangeRateAmount          money            default 0.0          not null,
    ShippingAmountWithoutVat    money            default 0.0          not null,
    ShippingAmountEurWithoutVat money            default 0.0          not null
)
go

create table SaleInvoiceNumber
(
    ID      bigint identity
        constraint PK_SaleInvoiceNumber
            primary key
                with (fillfactor = 60),
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    NetUID  uniqueidentifier default newid()      not null,
    Number  nvarchar(50),
    Updated datetime2                             not null
)
go

create table SaleMessageNumerator
(
    ID           bigint identity
        constraint PK_SaleMessageNumerator
            primary key,
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null,
    CountMessage bigint                                not null,
    Transfered   bit                                   not null
)
go

create table SaleReturnItemStatusName
(
    ID                   bigint identity
        constraint PK_SaleReturnItemStatusName
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    SaleReturnItemStatus int                                   not null,
    NameUK               nvarchar(120),
    NamePL               nvarchar(120)
)
go

create table SeoPage
(
    ID          bigint identity
        constraint PK_SeoPage
            primary key
                with (fillfactor = 60),
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    PageName    nvarchar(max),
    Title       nvarchar(100),
    Description nvarchar(1000),
    KeyWords    nvarchar(1000),
    LdJson      nvarchar(4000),
    Url         nvarchar(1000),
    Locale      nvarchar(max)
)
go

create table ServiceDetailItemKey
(
    ID      bigint identity
        constraint PK_ServiceDetailItemKey
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Symbol  nvarchar(max),
    Type    int                                   not null,
    Updated datetime2                             not null
)
go

create table Statham
(
    ID         bigint identity
        constraint PK_Statham
            primary key,
    Created    datetime2        default getutcdate() not null,
    Deleted    bit              default 0            not null,
    FirstName  nvarchar(50),
    LastName   nvarchar(50),
    MiddleName nvarchar(50),
    NetUID     uniqueidentifier default newid()      not null,
    Updated    datetime2                             not null
)
go

create table StathamCar
(
    ID        bigint identity
        constraint PK_StathamCar
            primary key,
    Created   datetime2        default getutcdate() not null,
    Deleted   bit              default 0            not null,
    NetUID    uniqueidentifier default newid()      not null,
    Number    nvarchar(150),
    StathamID bigint                                not null
        constraint FK_StathamCar_Statham_StathamID
            references Statham,
    Updated   datetime2                             not null,
    Volume    float                                 not null
)
go

create index IX_StathamCar_StathamID
    on StathamCar (StathamID)
go

create table StathamPassport
(
    ID                 bigint identity
        constraint PK_StathamPassport
            primary key,
    NetUID             uniqueidentifier default newid()      not null,
    Created            datetime2        default getutcdate() not null,
    Updated            datetime2                             not null,
    Deleted            bit              default 0            not null,
    PassportSeria      nvarchar(20),
    PassportNumber     nvarchar(20),
    PassportIssuedBy   nvarchar(250),
    City               nvarchar(150),
    Street             nvarchar(150),
    HouseNumber        nvarchar(50),
    PassportIssuedDate datetime2                             not null,
    PassportCloseDate  datetime2                             not null,
    StathamID          bigint                                not null
        constraint FK_StathamPassport_Statham_StathamID
            references Statham
)
go

create index IX_StathamPassport_StathamID
    on StathamPassport (StathamID)
go

create table SupplyDeliveryDocument
(
    ID                 bigint identity
        constraint PK_SupplyDeliveryDocument
            primary key,
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    Name               nvarchar(max),
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null,
    TransportationType int              default 0            not null
)
go

create table SupplyInformationDeliveryProtocolKey
(
    ID                 bigint identity
        constraint PK_SupplyInformationDeliveryProtocolKey
            primary key
                with (fillfactor = 70),
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    [Key]              nvarchar(max),
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null,
    IsDefault          bit              default 0            not null,
    KeyAssignedTo      int              default 0            not null,
    TransportationType int              default 0            not null
)
go

create table SupplyInformationDeliveryProtocolKeyTranslation
(
    ID                                     bigint identity
        constraint PK_SupplyInformationDeliveryProtocolKeyTranslation
            primary key,
    Created                                datetime2        default getutcdate() not null,
    CultureCode                            nvarchar(max),
    Deleted                                bit              default 0            not null,
    [Key]                                  nvarchar(max),
    NetUID                                 uniqueidentifier default newid()      not null,
    SupplyInformationDeliveryProtocolKeyID bigint                                not null
        constraint FK_SupplyInformationDeliveryProtocolKeyTranslation_SupplyInformationDeliveryProtocolKey_SupplyInformationDeliveryProtocolKeyID
            references SupplyInformationDeliveryProtocolKey,
    Updated                                datetime2                             not null
)
go

create index IX_SupplyInformationDeliveryProtocolKeyTranslation_SupplyInformationDeliveryProtocolKeyID
    on SupplyInformationDeliveryProtocolKeyTranslation (SupplyInformationDeliveryProtocolKeyID)
go

create table SupplyOrderNumber
(
    ID      bigint identity
        constraint PK_SupplyOrderNumber
            primary key
                with (fillfactor = 60),
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    NetUID  uniqueidentifier default newid()      not null,
    Number  nvarchar(max),
    Updated datetime2                             not null
)
go

create table SupplyOrderPaymentDeliveryProtocolKey
(
    ID      bigint identity
        constraint PK_SupplyOrderPaymentDeliveryProtocolKey
            primary key
                with (fillfactor = 60),
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    [Key]   nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table SupplyOrderUkrainePaymentDeliveryProtocolKey
(
    ID      bigint identity
        constraint PK_SupplyOrderUkrainePaymentDeliveryProtocolKey
            primary key,
    NetUID  uniqueidentifier default newid()      not null,
    Created datetime2        default getutcdate() not null,
    Updated datetime2                             not null,
    Deleted bit              default 0            not null,
    [Key]   nvarchar(150)
)
go

create table SupplyOrganization
(
    ID                   bigint identity
        constraint PK_SupplyOrganization
            primary key
                with (fillfactor = 60),
    AccountNumber        nvarchar(255),
    Address              nvarchar(255),
    Bank                 nvarchar(255),
    BankAccount          nvarchar(255),
    BankAccountEUR       nvarchar(255),
    BankAccountPLN       nvarchar(255),
    Beneficiary          nvarchar(255),
    BeneficiaryBank      nvarchar(255),
    ContactPersonComment nvarchar(255),
    ContactPersonEmail   nvarchar(255),
    ContactPersonName    nvarchar(255),
    ContactPersonPhone   nvarchar(255),
    ContactPersonSkype   nvarchar(255),
    ContactPersonViber   nvarchar(255),
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    IntermediaryBank     nvarchar(255),
    IsAgreementReceived  bit                                   not null,
    IsBillReceived       bit                                   not null,
    NIP                  nvarchar(255),
    Name                 nvarchar(255),
    NetUID               uniqueidentifier default newid()      not null,
    Swift                nvarchar(255),
    SwiftBic             nvarchar(255),
    Updated              datetime2                             not null,
    EmailAddress         nvarchar(255),
    PhoneNumber          nvarchar(255),
    Requisites           nvarchar(255),
    AgreementReceiveDate datetime2,
    BillReceiveDate      datetime2,
    SourceFenixCode      bigint,
    SourceFenixID        varbinary(16),
    OriginalRegionCode   nvarchar(10),
    SourceAmgCode        bigint,
    SourceAmgID          varbinary(16),
    IsNotResident        bit              default 0            not null,
    SROI                 nvarchar(max),
    TIN                  nvarchar(max),
    USREOU               nvarchar(max)
)
go

create table SupplyProForm
(
    ID            bigint identity
        constraint PK_SupplyProForm
            primary key
                with (fillfactor = 60),
    NetPrice      money                                 not null,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    Number        nvarchar(max),
    Updated       datetime2                             not null,
    DateFrom      datetime2,
    IsSkipped     bit              default 0            not null,
    ServiceNumber nvarchar(50)
)
go

create table ProFormDocument
(
    ID              bigint identity
        constraint PK_ProFormDocument
            primary key
                with (fillfactor = 60),
    Created         datetime2        default getutcdate() not null,
    Deleted         bit              default 0            not null,
    DocumentUrl     nvarchar(max),
    NetUID          uniqueidentifier default newid()      not null,
    SupplyProFormID bigint                                not null
        constraint FK_ProFormDocument_SupplyProForm_SupplyProFormID
            references SupplyProForm,
    Updated         datetime2                             not null,
    ContentType     nvarchar(max),
    FileName        nvarchar(max),
    GeneratedName   nvarchar(max)
)
go

create index IX_ProFormDocument_SupplyProFormID
    on ProFormDocument (SupplyProFormID)
    with (fillfactor = 60)
go

create table SupplyServiceAccountDocument
(
    ID            bigint identity
        constraint PK_SupplyServiceAccountDocument
            primary key
                with (fillfactor = 60),
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(500),
    FileName      nvarchar(500),
    ContentType   nvarchar(500),
    GeneratedName nvarchar(500),
    Number        nvarchar(20)
)
go

create table SupplyServiceNumber
(
    ID       bigint identity
        constraint PK_SupplyServiceNumber
            primary key
                with (fillfactor = 60),
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    IsPoland bit                                   not null,
    NetUID   uniqueidentifier default newid()      not null,
    Number   nvarchar(50),
    Updated  datetime2                             not null
)
go

create table SupportVideo
(
    ID          bigint identity
        constraint PK_SupportVideo
            primary key
                with (fillfactor = 60),
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    NameUk      nvarchar(150),
    NamePl      nvarchar(150),
    Url         nvarchar(250),
    DocumentUrl nvarchar(250)
)
go

create table TaxAccountingScheme
(
    ID                    bigint identity
        constraint PK_TaxAccountingScheme
            primary key,
    NetUID                uniqueidentifier default newid()      not null,
    Created               datetime2        default getutcdate() not null,
    Updated               datetime2                             not null,
    Deleted               bit              default 0            not null,
    CodeOneC              nvarchar(25),
    NameUK                nvarchar(100),
    NamePL                nvarchar(100),
    PurchaseTaxBaseMoment int              default 0            not null,
    SaleTaxBaseMoment     int              default 0            not null
)
go

create table OrganizationClientAgreement
(
    ID                       bigint identity
        constraint PK_OrganizationClientAgreement
            primary key,
    NetUID                   uniqueidentifier default newid()      not null,
    Created                  datetime2        default getutcdate() not null,
    Updated                  datetime2                             not null,
    Deleted                  bit              default 0            not null,
    Number                   nvarchar(50),
    FromDate                 datetime2                             not null,
    CurrencyID               bigint                                not null
        constraint FK_OrganizationClientAgreement_Currency_CurrencyID
            references Currency,
    OrganizationClientID     bigint                                not null
        constraint FK_OrganizationClientAgreement_OrganizationClient_OrganizationClientID
            references OrganizationClient,
    AgreementTypeCivilCodeID bigint
        constraint FK_OrganizationClientAgreement_AgreementTypeCivilCode_AgreementTypeCivilCodeID
            references AgreementTypeCivilCode,
    TaxAccountingSchemeID    bigint
        constraint FK_OrganizationClientAgreement_TaxAccountingScheme_TaxAccountingSchemeID
            references TaxAccountingScheme
)
go

create index IX_OrganizationClientAgreement_CurrencyID
    on OrganizationClientAgreement (CurrencyID)
go

create index IX_OrganizationClientAgreement_OrganizationClientID
    on OrganizationClientAgreement (OrganizationClientID)
go

create index IX_OrganizationClientAgreement_AgreementTypeCivilCodeID
    on OrganizationClientAgreement (AgreementTypeCivilCodeID)
go

create index IX_OrganizationClientAgreement_TaxAccountingSchemeID
    on OrganizationClientAgreement (TaxAccountingSchemeID)
go

create table TaxInspection
(
    ID                   bigint identity
        constraint PK_TaxInspection
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    InspectionNumber     nvarchar(50),
    InspectionType       nvarchar(150),
    InspectionName       nvarchar(250),
    InspectionRegionName nvarchar(250),
    InspectionRegionCode nvarchar(50),
    InspectionAddress    nvarchar(250),
    InspectionUSREOU     nvarchar(50)
)
go

create table TermsOfDelivery
(
    ID      bigint identity
        constraint PK_TermsOfDelivery
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(max),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table TransporterType
(
    ID      bigint identity
        constraint PK_TransporterType
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Name    nvarchar(50),
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null
)
go

create table Transporter
(
    ID                bigint identity
        constraint PK_Transporter
            primary key
                with (fillfactor = 60),
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    Name              nvarchar(max),
    NetUID            uniqueidentifier default newid()      not null,
    TransporterTypeID bigint
        constraint FK_Transporter_TransporterType_TransporterTypeID
            references TransporterType,
    Updated           datetime2                             not null,
    CssClass          nvarchar(max),
    Priority          int              default 0            not null,
    ImageUrl          nvarchar(max)
)
go

create index IX_Transporter_TransporterTypeID
    on Transporter (TransporterTypeID)
go

create table TransporterTypeTranslation
(
    ID                bigint identity
        constraint PK_TransporterTypeTranslation
            primary key,
    Created           datetime2        default getutcdate() not null,
    CultureCode       nvarchar(4),
    Deleted           bit              default 0            not null,
    Name              nvarchar(75),
    NetUID            uniqueidentifier default newid()      not null,
    TransporterTypeID bigint                                not null
        constraint FK_TransporterTypeTranslation_TransporterType_TransporterTypeID
            references TransporterType
            on delete cascade,
    Updated           datetime2                             not null
)
go

create index IX_TransporterTypeTranslation_TransporterTypeID
    on TransporterTypeTranslation (TransporterTypeID)
go

create table UserRole
(
    ID           bigint identity
        constraint PK_UserRole
            primary key,
    Created      datetime2        default getutcdate() not null,
    Dashboard    nvarchar(100),
    Deleted      bit              default 0            not null,
    Name         nvarchar(40),
    NetUID       uniqueidentifier default newid()      not null,
    Updated      datetime2                             not null,
    UserRoleType int              default 0            not null
)
go

create table RolePermission
(
    ID           bigint identity
        constraint PK_RolePermission
            primary key,
    UserRoleID   bigint                                not null
        constraint FK_RolePermission_UserRole_UserRoleID
            references UserRole
            on delete cascade,
    PermissionID bigint                                not null
        constraint FK_RolePermission_Permission_PermissionID
            references Permission
            on delete cascade,
    NetUID       uniqueidentifier default newid()      not null,
    Created      datetime2        default getutcdate() not null,
    Updated      datetime2                             not null,
    Deleted      bit              default 0            not null
)
go

create index IX_RolePermission_PermissionID
    on RolePermission (PermissionID)
go

create index IX_RolePermission_UserRoleID
    on RolePermission (UserRoleID)
go

create table UserRoleDashboardNode
(
    ID              bigint identity
        constraint PK_UserRoleDashboardNode
            primary key
                with (fillfactor = 60),
    UserRoleID      bigint                                not null
        constraint FK_UserRoleDashboardNode_UserRole_UserRoleID
            references UserRole
            on delete cascade,
    DashboardNodeID bigint                                not null
        constraint FK_UserRoleDashboardNode_DashboardNode_DashboardNodeID
            references DashboardNode
            on delete cascade,
    NetUID          uniqueidentifier default newid()      not null,
    Created         datetime2        default getutcdate() not null,
    Updated         datetime2                             not null,
    Deleted         bit              default 0            not null
)
go

create index IX_UserRoleDashboardNode_DashboardNodeID
    on UserRoleDashboardNode (DashboardNodeID)
go

create index IX_UserRoleDashboardNode_UserRoleID
    on UserRoleDashboardNode (UserRoleID)
go

create table UserRoleTranslation
(
    ID          bigint identity
        constraint PK_UserRoleTranslation
            primary key,
    Created     datetime2        default getutcdate() not null,
    CultureCode nvarchar(4),
    Deleted     bit              default 0            not null,
    Name        nvarchar(75),
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null,
    UserRoleID  bigint                                not null
        constraint FK_UserRoleTranslation_UserRole_UserRoleID
            references UserRole
            on delete cascade
)
go

create index IX_UserRoleTranslation_UserRoleID
    on UserRoleTranslation (UserRoleID)
go

create table VatRate
(
    ID      bigint identity
        constraint PK_VatRate
            primary key,
    NetUID  uniqueidentifier default newid()                 not null,
    Created datetime2        default getutcdate()            not null,
    Updated datetime2                                        not null,
    Deleted bit              default 0                       not null,
    Value   float            default 0.0000000000000000e+000 not null
)
go

create table Organization
(
    ID                    bigint identity
        constraint PK_Organization
            primary key
                with (fillfactor = 60),
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    Name                  nvarchar(100),
    NetUID                uniqueidentifier default newid()      not null,
    Updated               datetime2                             not null,
    Code                  nvarchar(5),
    Culture               nvarchar(max),
    Address               nvarchar(250),
    FullName              nvarchar(150),
    IsIndividual          bit              default 0            not null,
    PFURegistrationDate   datetime2,
    PFURegistrationNumber nvarchar(150),
    PhoneNumber           nvarchar(150),
    RegistrationDate      datetime2,
    RegistrationNumber    nvarchar(150),
    SROI                  nvarchar(150),
    TIN                   nvarchar(100),
    USREOU                nvarchar(100),
    CurrencyID            bigint
        constraint FK_Organization_Currency_CurrencyID
            references Currency,
    StorageID             bigint,
    TaxInspectionID       bigint
        constraint FK_Organization_TaxInspection_TaxInspectionID
            references TaxInspection,
    Manager               nvarchar(200),
    TypeTaxation          int              default 0            not null,
    VatRateID             bigint
        constraint FK_Organization_VatRate_VatRateID
            references VatRate,
    IsVatAgreements       bit              default 0            not null
)
go

create table Agreement
(
    ID                          bigint identity
        constraint PK_Agreement
            primary key
                with (fillfactor = 60),
    AmountDebt                  money                                            not null,
    Created                     datetime2        default getutcdate()            not null,
    CurrencyID                  bigint
        constraint FK_Agreement_Currency_CurrencyID
            references Currency,
    Deleted                     bit              default 0                       not null,
    NetUID                      uniqueidentifier default newid()                 not null,
    NumberDaysDebt              int                                              not null,
    Updated                     datetime2                                        not null,
    OrganizationID              bigint
        constraint FK_Agreement_Organization_OrganizationID
            references Organization,
    PricingID                   bigint
        constraint FK_Agreement_Pricing_PricingID
            references Pricing,
    IsAccounting                bit              default 0                       not null,
    IsActive                    bit              default 0                       not null,
    IsControlAmountDebt         bit              default 0                       not null,
    IsControlNumberDaysDebt     bit              default 0                       not null,
    IsManagementAccounting      bit              default 0                       not null,
    WithVATAccounting           bit              default 0                       not null,
    Name                        nvarchar(100),
    ProviderPricingID           bigint
        constraint FK_Agreement_ProviderPricing_ProviderPricingID
            references ProviderPricing,
    DeferredPayment             nvarchar(max),
    TermsOfPayment              nvarchar(max),
    IsPrePaymentFull            bit              default 0                       not null,
    PrePaymentPercentages       float            default 0.0000000000000000e+000 not null,
    IsPrePayment                bit              default 0                       not null,
    IsDefault                   bit              default 0                       not null,
    Number                      nvarchar(50),
    TaxAccountingSchemeID       bigint
        constraint FK_Agreement_TaxAccountingScheme_TaxAccountingSchemeID
            references TaxAccountingScheme,
    AgreementTypeCivilCodeID    bigint
        constraint FK_Agreement_AgreementTypeCivilCode_AgreementTypeCivilCodeID
            references AgreementTypeCivilCode,
    FromDate                    datetime2,
    ToDate                      datetime2,
    PromotionalPricingID        bigint
        constraint FK_Agreement_Pricing_PromotionalPricingID
            references Pricing,
    IsSelected                  bit              default 0                       not null,
    ForReSale                   bit              default 0                       not null,
    WithAgreementLine           bit              default 0                       not null,
    SourceFenixID               varbinary(16),
    SourceAmgCode               bigint,
    SourceAmgID                 varbinary(16),
    SourceFenixCode             bigint,
    IsDefaultForSyncConsignment bit              default CONVERT([bit], 0)       not null,
    HasPromotionalPricing       bit              default CONVERT([bit], 0)       not null
)
go

create index IX_Agreement_PricingID
    on Agreement (PricingID)
    with (fillfactor = 60)
go

create index IX_Agreement_ProviderPricingID
    on Agreement (ProviderPricingID)
    with (fillfactor = 60)
go

create index IX_Agreement_OrganizationID
    on Agreement (OrganizationID)
    with (fillfactor = 60)
go

create index IX_Agreement_CurrencyID
    on Agreement (CurrencyID)
    with (fillfactor = 60)
go

create index IX_Agreement_TaxAccountingSchemeID
    on Agreement (TaxAccountingSchemeID)
    with (fillfactor = 60)
go

create index IX_Agreement_AgreementTypeCivilCodeID
    on Agreement (AgreementTypeCivilCodeID)
    with (fillfactor = 60)
go

create index IX_Agreement_PromotionalPricingID
    on Agreement (PromotionalPricingID)
    with (fillfactor = 60)
go

create index IX_Organization_CurrencyID
    on Organization (CurrencyID)
go

create index IX_Organization_StorageID
    on Organization (StorageID)
go

create index IX_Organization_TaxInspectionID
    on Organization (TaxInspectionID)
go

create index IX_Organization_VatRateID
    on Organization (VatRateID)
go

create table OrganizationTranslation
(
    ID             bigint identity
        constraint PK_OrganizationTranslation
            primary key
                with (fillfactor = 60),
    Created        datetime2        default getutcdate() not null,
    CultureCode    nvarchar(max),
    Deleted        bit              default 0            not null,
    Name           nvarchar(100),
    NetUID         uniqueidentifier default newid()      not null,
    OrganizationID bigint                                not null
        constraint FK_OrganizationTranslation_Organization_OrganizationID
            references Organization
            on delete cascade,
    Updated        datetime2                             not null
)
go

create index IX_OrganizationTranslation_OrganizationID
    on OrganizationTranslation (OrganizationID)
go

create table PaymentRegister
(
    ID             bigint identity
        constraint PK_PaymentRegister
            primary key
                with (fillfactor = 60),
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    Name           nvarchar(100),
    NetUID         uniqueidentifier default newid()      not null,
    Updated        datetime2                             not null,
    Type           int              default 0            not null,
    OrganizationID bigint           default 0            not null
        constraint FK_PaymentRegister_Organization_OrganizationID
            references Organization,
    AccountNumber  nvarchar(50),
    BankName       nvarchar(100),
    City           nvarchar(100),
    FromDate       datetime2,
    IBAN           nvarchar(50),
    SortCode       nvarchar(20),
    SwiftCode      nvarchar(50),
    ToDate         datetime2,
    IsActive       bit              default 0            not null,
    IsMain         bit              default 0            not null,
    IsForRetail    bit              default 0            not null,
    CVV            nvarchar(3),
    IsSelected     bit              default 0            not null
)
go

create table PaymentCurrencyRegister
(
    ID                bigint identity
        constraint PK_PaymentCurrencyRegister
            primary key
                with (fillfactor = 60),
    Amount            money                                 not null,
    Created           datetime2        default getutcdate() not null,
    CurrencyID        bigint                                not null
        constraint FK_PaymentCurrencyRegister_Currency_CurrencyID
            references Currency,
    Deleted           bit              default 0            not null,
    NetUID            uniqueidentifier default newid()      not null,
    PaymentRegisterID bigint                                not null
        constraint FK_PaymentCurrencyRegister_PaymentRegister_PaymentRegisterID
            references PaymentRegister,
    Updated           datetime2                             not null,
    InitialAmount     money            default 0.0          not null
)
go

create index IX_PaymentCurrencyRegister_CurrencyID
    on PaymentCurrencyRegister (CurrencyID)
go

create index IX_PaymentCurrencyRegister_PaymentRegisterID
    on PaymentCurrencyRegister (PaymentRegisterID)
go

create index IX_PaymentRegister_OrganizationID
    on PaymentRegister (OrganizationID)
go

create table SaleNumber
(
    ID             bigint identity
        constraint PK_SaleNumber
            primary key
                with (fillfactor = 60),
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    NetUID         uniqueidentifier default newid()      not null,
    Updated        datetime2                             not null,
    Value          nvarchar(max),
    OrganizationID bigint           default 0            not null
        constraint FK_SaleNumber_Organization_OrganizationID
            references Organization
)
go

create index IX_SaleNumber_OrganizationID
    on SaleNumber (OrganizationID)
    with (fillfactor = 60)
go

create table Storage
(
    ID                 bigint identity
        constraint PK_Storage
            primary key
                with (fillfactor = 60),
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    Name               nvarchar(40),
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null,
    Locale             nvarchar(10),
    OrganizationID     bigint
        constraint FK_Storage_Organization_OrganizationID
            references Organization,
    ForDefective       bit              default 0            not null,
    ForVatProducts     bit              default 0            not null,
    AvailableForReSale bit              default 0            not null,
    ForEcommerce       bit              default 0            not null,
    RetailPriority     int              default 0            not null,
    IsResale           bit              default 0            not null
)
go

alter table Organization
    add constraint FK_Organization_Storage_StorageID
        foreign key (StorageID) references Storage
go

create table ProductAvailability
(
    ID        bigint identity
        constraint PK_ProductAvailability
            primary key
                with (fillfactor = 60),
    Amount    float                                 not null,
    Created   datetime2        default getutcdate() not null,
    Deleted   bit              default 0            not null,
    NetUID    uniqueidentifier default newid()      not null,
    ProductID bigint                                not null
        constraint FK_ProductAvailability_Product_ProductID
            references Product,
    StorageID bigint                                not null
        constraint FK_ProductAvailability_Storage_StorageID
            references Storage,
    Updated   datetime2                             not null
)
go

create index IX_ProductAvailability_ProductID
    on ProductAvailability (ProductID)
    with (fillfactor = 60)
go

create index IX_ProductAvailability_StorageID_Amount_ProductID_Deleted
    on ProductAvailability (StorageID, Amount, ProductID, Deleted)
    with (fillfactor = 60)
go

create index IX_ProductAvailability_Amount
    on ProductAvailability (Amount)
    with (fillfactor = 60)
go

create index IX_ProductAvailability_ID_Deleted_ProductID
    on ProductAvailability (ID, Deleted, ProductID)
    with (fillfactor = 60)
go

create index IX_ProductAvailability_ID_Deleted_StorageID
    on ProductAvailability (ID, Deleted, StorageID)
    with (fillfactor = 60)
go

create index IX_ProductAvailability_Deleted_ProductID
    on ProductAvailability (Deleted, ProductID)
    with (fillfactor = 60)
go

create index IX_Storage_OrganizationID
    on Storage (OrganizationID)
go

create table SupplyOrganizationAgreement
(
    ID                       bigint identity
        constraint PK_SupplyOrganizationAgreement
            primary key
                with (fillfactor = 60),
    Created                  datetime2        default getutcdate()                  not null,
    CurrencyID               bigint                                                 not null
        constraint FK_SupplyOrganizationAgreement_Currency_CurrencyID
            references Currency
            on delete cascade,
    CurrentAmount            money                                                  not null,
    Deleted                  bit              default 0                             not null,
    Name                     nvarchar(150),
    NetUID                   uniqueidentifier default newid()                       not null,
    SupplyOrganizationID     bigint                                                 not null
        constraint FK_SupplyOrganizationAgreement_SupplyOrganization_SupplyOrganizationID
            references SupplyOrganization
            on delete cascade,
    Updated                  datetime2                                              not null,
    AgreementTypeCivilCodeID bigint
        constraint FK_SupplyOrganizationAgreement_AgreementTypeCivilCode_AgreementTypeCivilCodeID
            references AgreementTypeCivilCode,
    TaxAccountingSchemeID    bigint
        constraint FK_SupplyOrganizationAgreement_TaxAccountingScheme_TaxAccountingSchemeID
            references TaxAccountingScheme,
    AccountingCurrentAmount  money            default 0.00                          not null,
    SourceFenixCode          bigint,
    SourceFenixID            varbinary(16),
    ExistTo                  datetime2        default '0001-01-01T00:00:00.0000000' not null,
    OrganizationID           bigint           default CONVERT([bigint], 0)          not null
        constraint FK_SupplyOrganizationAgreement_Organization_OrganizationID
            references Organization,
    ExistFrom                datetime2        default '0001-01-01T00:00:00.0000000' not null,
    SourceAmgCode            bigint,
    SourceAmgID              varbinary(16),
    Number                   nvarchar(50)
)
go

create index IX_SupplyOrganizationAgreement_CurrencyID
    on SupplyOrganizationAgreement (CurrencyID)
go

create index IX_SupplyOrganizationAgreement_SupplyOrganizationID
    on SupplyOrganizationAgreement (SupplyOrganizationID)
go

create index IX_SupplyOrganizationAgreement_AgreementTypeCivilCodeID
    on SupplyOrganizationAgreement (AgreementTypeCivilCodeID)
go

create index IX_SupplyOrganizationAgreement_TaxAccountingSchemeID
    on SupplyOrganizationAgreement (TaxAccountingSchemeID)
go

create index IX_SupplyOrganizationAgreement_OrganizationID
    on SupplyOrganizationAgreement (OrganizationID)
go

create table SupplyOrganizationDocument
(
    ID                            bigint identity
        constraint PK_SupplyOrganizationDocument
            primary key
                with (fillfactor = 60),
    ContentType                   nvarchar(max),
    Created                       datetime2        default getutcdate() not null,
    Deleted                       bit              default 0            not null,
    DocumentUrl                   nvarchar(max),
    FileName                      nvarchar(max),
    GeneratedName                 nvarchar(max),
    NetUID                        uniqueidentifier default newid()      not null,
    SupplyOrganizationAgreementID bigint                                not null
        constraint FK_SupplyOrganizationDocument_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    Updated                       datetime2                             not null
)
go

create index IX_SupplyOrganizationDocument_SupplyOrganizationAgreementID
    on SupplyOrganizationDocument (SupplyOrganizationAgreementID)
go

create table WorkPermit
(
    ID       bigint identity
        constraint PK_WorkPermit
            primary key,
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    FromDate datetime2                             not null,
    NetUID   uniqueidentifier default newid()      not null,
    ToDate   datetime2                             not null,
    Updated  datetime2                             not null
)
go

create table WorkingContract
(
    ID               bigint identity
        constraint PK_WorkingContract
            primary key,
    Created          datetime2        default getutcdate() not null,
    CurrentWorkplace nvarchar(max),
    Delegation       nvarchar(max),
    Deleted          bit              default 0            not null,
    FromDate         datetime2                             not null,
    KindOfWork       nvarchar(max),
    NetUID           uniqueidentifier default newid()      not null,
    NightWork        nvarchar(max),
    PlaceOfWork      nvarchar(max),
    Premium          nvarchar(max),
    StudyLeave       nvarchar(max),
    ToDate           datetime2                             not null,
    Updated          datetime2                             not null,
    VacationDays     nvarchar(max),
    WorkTimeSize     nvarchar(max)
)
go

create table UserDetails
(
    ID                           bigint identity
        constraint PK_UserDetails
            primary key,
    Accommodation                nvarchar(max),
    AdditionalSchools            nvarchar(max),
    Address                      nvarchar(max),
    BasicHealtAndSagetyEducation nvarchar(max),
    Caveats                      nvarchar(max),
    Created                      datetime2        default getutcdate() not null,
    DateOfBirth                  datetime2                             not null,
    Deleted                      bit              default 0            not null,
    DocumentsExpirationDate      datetime2                             not null,
    Education                    nvarchar(max),
    FamilyStatus                 nvarchar(max),
    FathersName                  nvarchar(max),
    FirstName                    nvarchar(max),
    HasPermissionToOperateCarts  bit                                   not null,
    IsBigFamily                  bit                                   not null,
    LastName                     nvarchar(max),
    MedicalCertificateToDate     datetime2                             not null,
    MiddleName                   nvarchar(max),
    MothersName                  nvarchar(max),
    NetUID                       uniqueidentifier default newid()      not null,
    NumberOfDependents           int                                   not null,
    PassportNumber               nvarchar(max),
    Profession                   nvarchar(max),
    Registration                 nvarchar(max),
    ResidenceCardID              bigint                                not null
        constraint FK_UserDetails_ResidenceCard_ResidenceCardID
            references ResidenceCard,
    SocialSecurityNumber         nvarchar(max),
    SpecializedTraining          nvarchar(max),
    TIN                          nvarchar(max),
    Updated                      datetime2                             not null,
    VATIN                        nvarchar(max),
    VocationalCourses            nvarchar(max),
    WorkExperience               float                                 not null,
    WorkHeight                   float                                 not null,
    WorkPermitID                 bigint                                not null
        constraint FK_UserDetails_WorkPermit_WorkPermitID
            references WorkPermit,
    WorkingContractID            bigint                                not null
        constraint FK_UserDetails_WorkingContract_WorkingContractID
            references WorkingContract
)
go

create table [User]
(
    ID            bigint identity
        constraint PK_User
            primary key
                with (fillfactor = 60),
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    Email         nvarchar(max),
    FirstName     nvarchar(max),
    LastName      nvarchar(max),
    MiddleName    nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    PhoneNumber   nvarchar(max),
    Region        nvarchar(max),
    Updated       datetime2                             not null,
    UserRoleID    bigint
        constraint FK_User_UserRole_UserRoleID
            references UserRole,
    IsActive      bit              default 1            not null,
    Abbreviation  nvarchar(max),
    UserDetailsId bigint
        constraint FK_User_UserDetails_UserDetailsId
            references UserDetails
)
go

create table ActProvidingService
(
    ID           bigint identity
        constraint PK_ActProvidingService
            primary key
                with (fillfactor = 60),
    NetUID       uniqueidentifier default newid()                       not null,
    Created      datetime2        default getutcdate()                  not null,
    Updated      datetime2                                              not null,
    Deleted      bit              default 0                             not null,
    IsAccounting bit                                                    not null,
    Price        decimal(30, 14)                                        not null,
    UserID       bigint           default CONVERT([bigint], 0)          not null
        constraint FK_ActProvidingService_User_UserID
            references [User],
    Comment      nvarchar(2000),
    FromDate     datetime2        default '0001-01-01T00:00:00.0000000' not null,
    Number       nvarchar(50)
)
go

create index IX_ActProvidingService_UserID
    on ActProvidingService (UserID)
    with (fillfactor = 60)
go

create table Client
(
    ID                      bigint identity
        constraint PK_Client
            primary key
                with (fillfactor = 60),
    Comment                 nvarchar(max),
    Created                 datetime2        default getutcdate() not null,
    Deleted                 bit              default 0            not null,
    NetUID                  uniqueidentifier default newid()      not null,
    TIN                     nvarchar(30),
    USREOU                  nvarchar(30),
    Updated                 datetime2                             not null,
    AccountantNumber        nvarchar(max),
    ActualAddress           nvarchar(max),
    DeliveryAddress         nvarchar(max),
    DirectorNumber          nvarchar(max),
    EmailAddress            nvarchar(max),
    FaxNumber               nvarchar(max),
    ICQ                     nvarchar(max),
    LegalAddress            nvarchar(max),
    MobileNumber            nvarchar(max),
    RegionID                bigint
        constraint FK_Client_Region_RegionID
            references Region,
    SMSNumber               nvarchar(max),
    ClientNumber            nvarchar(max),
    SROI                    nvarchar(max),
    Name                    nvarchar(150),
    FullName                nvarchar(200),
    IsIndividual            bit              default 0            not null,
    RegionCodeID            bigint
        constraint FK_Client_RegionCode_RegionCodeID
            references RegionCode,
    IsActive                bit              default 0            not null,
    IsSubClient             bit              default 0            not null,
    Abbreviation            nvarchar(max),
    IsBlocked               bit              default 0            not null,
    IsTradePoint            bit              default 0            not null,
    Brand                   nvarchar(max),
    ClientBankDetailsID     bigint
        constraint FK_Client_ClientBankDetails_ClientBankDetailsID
            references ClientBankDetails,
    CountryID               bigint
        constraint FK_Client_Country_CountryID
            references Country,
    Manufacturer            nvarchar(max),
    TermsOfDeliveryID       bigint
        constraint FK_Client_TermsOfDelivery_TermsOfDeliveryID
            references TermsOfDelivery,
    SupplierContactName     nvarchar(max),
    SupplierName            nvarchar(max),
    PackingMarkingID        bigint
        constraint FK_Client_PackingMarking_PackingMarkingID
            references PackingMarking,
    PackingMarkingPaymentID bigint
        constraint FK_Client_PackingMarkingPayment_PackingMarkingPaymentID
            references PackingMarkingPayment,
    IncotermsElse           nvarchar(max),
    IsPayForDelivery        bit              default 0            not null,
    IsIncotermsElse         bit              default 0            not null,
    SupplierCode            nvarchar(40),
    IsTemporaryClient       bit              default 0            not null,
    FirstName               nvarchar(150),
    LastName                nvarchar(150),
    MiddleName              nvarchar(150),
    SourceFenixID           varbinary(16),
    HouseNumber             nvarchar(250),
    Street                  nvarchar(250),
    ZipCode                 nvarchar(250),
    ClearCartAfterDays      int              default 3            not null,
    IsFromECommerce         bit              default 0            not null,
    Manager                 nvarchar(250),
    IsForRetail             bit              default 0            not null,
    IsWorkplace             bit              default 0            not null,
    OriginalRegionCode      nvarchar(10),
    SourceAmgCode           bigint,
    SourceAmgID             varbinary(16),
    SourceFenixCode         bigint,
    IsNotResident           bit              default 0            not null,
    MainManagerID           bigint
        constraint FK_Client_User_MainManagerID
            references [User],
    MainClientID            bigint
        constraint FK_Client_Client_MainClientID
            references Client,
    OrderExpireDays         int              default 0            not null
)
go

create index IX_Client_RegionCodeID
    on Client (RegionCodeID)
    with (fillfactor = 60)
go

create index IX_Client_RegionID
    on Client (RegionID)
    with (fillfactor = 60)
go

create index IX_Client_ClientBankDetailsID
    on Client (ClientBankDetailsID)
    with (fillfactor = 60)
go

create index IX_Client_CountryID
    on Client (CountryID)
    with (fillfactor = 60)
go

create index IX_Client_TermsOfDeliveryID
    on Client (TermsOfDeliveryID)
    with (fillfactor = 60)
go

create index IX_Client_PackingMarkingID
    on Client (PackingMarkingID)
    with (fillfactor = 60)
go

create index IX_Client_PackingMarkingPaymentID
    on Client (PackingMarkingPaymentID)
    with (fillfactor = 60)
go

create unique index IX_Client_NetUID
    on Client (NetUID)
    with (fillfactor = 60)
go

create index IX_Client_MainManagerID
    on Client (MainManagerID)
    with (fillfactor = 60)
go

create index IX_Client_MainClientID
    on Client (MainClientID)
    with (fillfactor = 60)
go

create table ClientAgreement
(
    ID                      bigint identity
        constraint PK_ClientAgreement
            primary key
                with (fillfactor = 60),
    AgreementID             bigint                                not null
        constraint FK_ClientAgreement_Agreement_AgreementID
            references Agreement
            on delete cascade,
    ClientID                bigint                                not null
        constraint FK_ClientAgreement_Client_ClientID
            references Client
            on delete cascade,
    Created                 datetime2        default getutcdate() not null,
    Deleted                 bit              default 0            not null,
    NetUID                  uniqueidentifier default newid()      not null,
    Updated                 datetime2                             not null,
    ProductReservationTerm  int              default 0            not null,
    CurrentAmount           money            default 0.0          not null,
    OriginalClientAmgCode   bigint,
    OriginalClientFenixCode bigint
)
go

create index IX_ClientAgreement_AgreementID
    on ClientAgreement (AgreementID)
    with (fillfactor = 60)
go

create index IX_ClientAgreement_ClientID
    on ClientAgreement (ClientID)
    with (fillfactor = 60)
go

create index IX_ClientAgreement_NetUID
    on ClientAgreement (NetUID)
    with (fillfactor = 60)
go

create table ClientBalanceMovement
(
    ID                 bigint identity
        constraint PK_ClientBalanceMovement
            primary key
                with (fillfactor = 60),
    Amount             money                                 not null,
    ClientAgreementID  bigint                                not null
        constraint FK_ClientBalanceMovement_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    ExchangeRateAmount money                                 not null,
    MovementType       int                                   not null,
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null
)
go

create index IX_ClientBalanceMovement_ClientAgreementID
    on ClientBalanceMovement (ClientAgreementID)
    with (fillfactor = 60)
go

create table ClientContractDocument
(
    ID            bigint identity
        constraint PK_ClientContractDocument
            primary key,
    ClientID      bigint                                not null
        constraint FK_ClientContractDocument_Client_ClientID
            references Client,
    ContentType   nvarchar(max),
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(max),
    FileName      nvarchar(max),
    GeneratedName nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null
)
go

create index IX_ClientContractDocument_ClientID
    on ClientContractDocument (ClientID)
go

create table ClientGroup
(
    ID       bigint identity
        constraint PK_ClientGroup
            primary key,
    NetUID   uniqueidentifier default newid()              not null,
    Created  datetime2        default getutcdate()         not null,
    Updated  datetime2                                     not null,
    Deleted  bit              default 0                    not null,
    Name     nvarchar(500),
    ClientID bigint           default CONVERT([bigint], 0) not null
        constraint FK_ClientGroup_Client_ClientID
            references Client
)
go

create index IX_ClientGroup_ClientID
    on ClientGroup (ClientID)
go

create table ClientInRole
(
    ID               bigint identity
        constraint PK_ClientInRole
            primary key
                with (fillfactor = 60),
    ClientTypeID     bigint                                not null
        constraint FK_ClientInRole_ClientType_ClientTypeID
            references ClientType,
    ClientTypeRoleID bigint                                not null
        constraint FK_ClientInRole_ClientTypeRole_ClientTypeRoleID
            references ClientTypeRole,
    Created          datetime2        default getutcdate() not null,
    Deleted          bit              default 0            not null,
    NetUID           uniqueidentifier default newid()      not null,
    Updated          datetime2                             not null,
    ClientID         bigint           default 0            not null
        constraint FK_ClientInRole_Client_ClientID
            references Client
)
go

create index IX_ClientInRole_ClientTypeID
    on ClientInRole (ClientTypeID)
    with (fillfactor = 60)
go

create index IX_ClientInRole_ClientTypeRoleID
    on ClientInRole (ClientTypeRoleID)
    with (fillfactor = 60)
go

create unique index IX_ClientInRole_ClientID
    on ClientInRole (ClientID)
    with (fillfactor = 60)
go

create table ClientPerfectClient
(
    ID                   bigint identity
        constraint PK_ClientPerfectClient
            primary key
                with (fillfactor = 60),
    ClientID             bigint                                not null
        constraint FK_ClientPerfectClient_Client_ClientID
            references Client
            on delete cascade,
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    IsChecked            bit                                   not null,
    NetUID               uniqueidentifier default newid()      not null,
    PerfectClientID      bigint                                not null
        constraint FK_ClientPerfectClient_PerfectClient_PerfectClientID
            references PerfectClient
            on delete cascade,
    Updated              datetime2                             not null,
    Value                nvarchar(max),
    PerfectClientValueID bigint
        constraint FK_ClientPerfectClient_PerfectClientValue_PerfectClientValueID
            references PerfectClientValue
)
go

create index IX_ClientPerfectClient_ClientID
    on ClientPerfectClient (ClientID)
go

create index IX_ClientPerfectClient_PerfectClientID
    on ClientPerfectClient (PerfectClientID)
go

create index IX_ClientPerfectClient_PerfectClientValueID
    on ClientPerfectClient (PerfectClientValueID)
go

create table ClientRegistrationTask
(
    ID       bigint identity
        constraint PK_ClientRegistrationTask
            primary key
                with (fillfactor = 60),
    ClientID bigint                                not null
        constraint FK_ClientRegistrationTask_Client_ClientID
            references Client
            on delete cascade,
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    NetUID   uniqueidentifier default newid()      not null,
    Updated  datetime2                             not null,
    IsDone   bit              default 0            not null
)
go

create index IX_ClientRegistrationTask_ClientID
    on ClientRegistrationTask (ClientID)
    with (fillfactor = 60)
go

create table ClientSubClient
(
    ID           bigint identity
        constraint PK_ClientSubClient
            primary key
                with (fillfactor = 60),
    Created      datetime2        default getutcdate() not null,
    Deleted      bit              default 0            not null,
    NetUID       uniqueidentifier default newid()      not null,
    RootClientID bigint                                not null
        constraint FK_ClientSubClient_Client_RootClientID
            references Client,
    SubClientID  bigint                                not null
        constraint FK_ClientSubClient_Client_SubClientID
            references Client,
    Updated      datetime2                             not null
)
go

create index IX_ClientSubClient_RootClientID
    on ClientSubClient (RootClientID)
    with (fillfactor = 60)
go

create index IX_ClientSubClient_SubClientID
    on ClientSubClient (SubClientID)
    with (fillfactor = 60)
go

create table ClientUserProfile
(
    ID            bigint identity
        constraint PK_ClientUserProfile
            primary key,
    ClientID      bigint                                not null
        constraint FK_ClientUserProfile_Client_ClientID
            references Client
            on delete cascade,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    Updated       datetime2                             not null,
    UserProfileID bigint                                not null
        constraint FK_ClientUserProfile_User_UserProfileID
            references [User]
            on delete cascade
)
go

create index IX_ClientUserProfile_ClientID
    on ClientUserProfile (ClientID)
    with (fillfactor = 70)
go

create index IX_ClientUserProfile_UserProfileID
    on ClientUserProfile (UserProfileID)
go

create table ClientWorkplace
(
    ID            bigint identity
        constraint PK_ClientWorkplace
            primary key,
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    MainClientID  bigint                                not null
        constraint FK_ClientWorkplace_Client_MainClientID
            references Client,
    WorkplaceID   bigint                                not null
        constraint FK_ClientWorkplace_Client_WorkplaceID
            references Client,
    ClientGroupId bigint
        constraint FK_ClientWorkplace_ClientGroup_ClientGroupId
            references ClientGroup
)
go

create index IX_ClientWorkplace_MainClientID
    on ClientWorkplace (MainClientID)
go

create index IX_ClientWorkplace_WorkplaceID
    on ClientWorkplace (WorkplaceID)
go

create index IX_ClientWorkplace_ClientGroupId
    on ClientWorkplace (ClientGroupId)
go

create table ColumnItem
(
    ID       bigint identity
        constraint PK_ColumnItem
            primary key
                with (fillfactor = 60),
    Created  datetime2        default getutcdate() not null,
    Deleted  bit              default 0            not null,
    Name     nvarchar(max),
    NetUID   uniqueidentifier default newid()      not null,
    [Order]  int                                   not null,
    SQL      nvarchar(max),
    Type     int                                   not null,
    Updated  datetime2                             not null,
    UserID   bigint                                not null
        constraint FK_ColumnItem_User_UserID
            references [User]
            on delete cascade,
    CssClass nvarchar(max),
    Template nvarchar(max)    default N''
)
go

create index IX_ColumnItem_UserID
    on ColumnItem (UserID)
go

create table ColumnItemTranslation
(
    ID           bigint identity
        constraint PK_ColumnItemTranslation
            primary key,
    ColumnItemID bigint                                not null
        constraint FK_ColumnItemTranslation_ColumnItem_ColumnItemID
            references ColumnItem,
    Created      datetime2        default getutcdate() not null,
    CultureCode  nvarchar(max),
    Deleted      bit              default 0            not null,
    Name         nvarchar(max),
    NetUID       uniqueidentifier default newid()      not null,
    Updated      datetime2                             not null
)
go

create index IX_ColumnItemTranslation_ColumnItemID
    on ColumnItemTranslation (ColumnItemID)
go

create table ConsumablesStorage
(
    ID                bigint identity
        constraint PK_ConsumablesStorage
            primary key,
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    Description       nvarchar(250),
    Name              nvarchar(50),
    NetUID            uniqueidentifier default newid()      not null,
    OrganizationID    bigint                                not null
        constraint FK_ConsumablesStorage_Organization_OrganizationID
            references Organization,
    ResponsibleUserID bigint                                not null
        constraint FK_ConsumablesStorage_User_ResponsibleUserID
            references [User],
    Updated           datetime2                             not null
)
go

create table CompanyCar
(
    ID                     bigint identity
        constraint PK_CompanyCar
            primary key,
    Created                datetime2        default getutcdate()            not null,
    CreatedByID            bigint                                           not null
        constraint FK_CompanyCar_User_CreatedByID
            references [User],
    Deleted                bit              default 0                       not null,
    InCityConsumption      float                                            not null,
    LicensePlate           nvarchar(20),
    Mileage                bigint                                           not null,
    MixedModeConsumption   float                                            not null,
    NetUID                 uniqueidentifier default newid()                 not null,
    OutsideCityConsumption float                                            not null,
    TankCapacity           float                                            not null,
    Updated                datetime2                                        not null,
    UpdatedByID            bigint
        constraint FK_CompanyCar_User_UpdatedByID
            references [User],
    FuelAmount             float            default 0.0000000000000000e+000 not null,
    InitialMileage         bigint           default 0                       not null,
    ConsumablesStorageID   bigint           default 0                       not null
        constraint FK_CompanyCar_ConsumablesStorage_ConsumablesStorageID
            references ConsumablesStorage,
    OrganizationID         bigint           default 0                       not null
        constraint FK_CompanyCar_Organization_OrganizationID
            references Organization,
    CarBrand               nvarchar(100)
)
go

create index IX_CompanyCar_CreatedByID
    on CompanyCar (CreatedByID)
go

create index IX_CompanyCar_UpdatedByID
    on CompanyCar (UpdatedByID)
go

create unique index IX_CompanyCar_ConsumablesStorageID
    on CompanyCar (ConsumablesStorageID)
go

create index IX_CompanyCar_OrganizationID
    on CompanyCar (OrganizationID)
go

create index IX_ConsumablesStorage_OrganizationID
    on ConsumablesStorage (OrganizationID)
go

create index IX_ConsumablesStorage_ResponsibleUserID
    on ConsumablesStorage (ResponsibleUserID)
go

create table CrossExchangeRateHistory
(
    ID                  bigint identity
        constraint PK_CrossExchangeRateHistory
            primary key
                with (fillfactor = 60),
    Amount              decimal(30, 14)                       not null,
    Created             datetime2        default getutcdate() not null,
    CrossExchangeRateID bigint                                not null
        constraint FK_CrossExchangeRateHistory_CrossExchangeRate_CrossExchangeRateID
            references CrossExchangeRate,
    Deleted             bit              default 0            not null,
    NetUID              uniqueidentifier default newid()      not null,
    Updated             datetime2                             not null,
    UpdatedByID         bigint                                not null
        constraint FK_CrossExchangeRateHistory_User_UpdatedByID
            references [User]
)
go

create index IX_CrossExchangeRateHistory_CrossExchangeRateID
    on CrossExchangeRateHistory (CrossExchangeRateID)
    with (fillfactor = 60)
go

create index IX_CrossExchangeRateHistory_UpdatedByID
    on CrossExchangeRateHistory (UpdatedByID)
    with (fillfactor = 60)
go

create table DataSyncOperation
(
    ID            bigint identity
        constraint PK_DataSyncOperation
            primary key
                with (fillfactor = 60),
    NetUID        uniqueidentifier default newid()           not null,
    Created       datetime2        default getutcdate()      not null,
    Updated       datetime2                                  not null,
    Deleted       bit              default 0                 not null,
    OperationType int                                        not null,
    UserID        bigint                                     not null
        constraint FK_DataSyncOperation_User_UserID
            references [User]
            on delete cascade,
    ForAmg        bit              default CONVERT([bit], 0) not null
)
go

create index IX_DataSyncOperation_UserID
    on DataSyncOperation (UserID)
    with (fillfactor = 60)
go

create table DeliveryProductProtocol
(
    ID                              bigint identity
        constraint PK_DeliveryProductProtocol
            primary key
                with (fillfactor = 60),
    NetUID                          uniqueidentifier default newid()                       not null,
    Created                         datetime2        default getutcdate()                  not null,
    Updated                         datetime2                                              not null,
    Deleted                         bit              default 0                             not null,
    TransportationType              int              default 0                             not null,
    UserID                          bigint           default CONVERT([bigint], 0)          not null
        constraint FK_DeliveryProductProtocol_User_UserID
            references [User]
            on delete cascade,
    Comment                         nvarchar(500),
    FromDate                        datetime2        default '0001-01-01T00:00:00.0000000' not null,
    IsCompleted                     bit              default 0                             not null,
    IsPartiallyPlaced               bit              default 0                             not null,
    IsPlaced                        bit              default 0                             not null,
    OrganizationID                  bigint           default CONVERT([bigint], 0)          not null
        constraint FK_DeliveryProductProtocol_Organization_OrganizationID
            references Organization
            on delete cascade,
    DeliveryProductProtocolNumberID bigint           default CONVERT([bigint], 0)          not null
        constraint FK_DeliveryProductProtocol_DeliveryProductProtocolNumber_DeliveryProductProtocolNumberID
            references DeliveryProductProtocolNumber,
    IsShipped                       bit              default 0                             not null
)
go

create index IX_DeliveryProductProtocol_OrganizationID
    on DeliveryProductProtocol (OrganizationID)
go

create index IX_DeliveryProductProtocol_UserID
    on DeliveryProductProtocol (UserID)
go

create unique index IX_DeliveryProductProtocol_DeliveryProductProtocolNumberID
    on DeliveryProductProtocol (DeliveryProductProtocolNumberID)
go

create table DeliveryProductProtocolDocument
(
    ID                        bigint identity
        constraint PK_DeliveryProductProtocolDocument
            primary key,
    NetUID                    uniqueidentifier default newid()      not null,
    Created                   datetime2        default getutcdate() not null,
    Updated                   datetime2                             not null,
    Deleted                   bit              default 0            not null,
    DocumentUrl               nvarchar(500),
    FileName                  nvarchar(500),
    ContentType               nvarchar(500),
    GeneratedName             nvarchar(500),
    Number                    nvarchar(20),
    DeliveryProductProtocolID bigint                                not null
        constraint FK_DeliveryProductProtocolDocument_DeliveryProductProtocol_DeliveryProductProtocolID
            references DeliveryProductProtocol
)
go

create index IX_DeliveryProductProtocolDocument_DeliveryProductProtocolID
    on DeliveryProductProtocolDocument (DeliveryProductProtocolID)
go

create table DeliveryRecipient
(
    ID          bigint identity
        constraint PK_DeliveryRecipient
            primary key
                with (fillfactor = 60),
    ClientID    bigint                                not null
        constraint FK_DeliveryRecipient_Client_ClientID
            references Client,
    Created     datetime2        default getutcdate() not null,
    Deleted     bit              default 0            not null,
    FullName    nvarchar(max),
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null,
    Priority    int              default 0            not null,
    MobilePhone nvarchar(max)
)
go

create index IX_DeliveryRecipient_ClientID
    on DeliveryRecipient (ClientID)
    with (fillfactor = 60)
go

create table DeliveryRecipientAddress
(
    ID                  bigint identity
        constraint PK_DeliveryRecipientAddress
            primary key
                with (fillfactor = 60),
    Created             datetime2        default getutcdate() not null,
    Deleted             bit              default 0            not null,
    DeliveryRecipientID bigint                                not null
        constraint FK_DeliveryRecipientAddress_DeliveryRecipient_DeliveryRecipientID
            references DeliveryRecipient,
    NetUID              uniqueidentifier default newid()      not null,
    Updated             datetime2                             not null,
    Value               nvarchar(500),
    Priority            int              default 0            not null,
    City                nvarchar(250),
    Department          nvarchar(250)
)
go

create index IX_DeliveryRecipientAddress_DeliveryRecipientID
    on DeliveryRecipientAddress (DeliveryRecipientID)
    with (fillfactor = 60)
go

create table DepreciatedConsumableOrder
(
    ID                   bigint identity
        constraint PK_DepreciatedConsumableOrder
            primary key,
    Comment              nvarchar(250),
    CommissionHeadID     bigint                                not null
        constraint FK_DepreciatedConsumableOrder_User_CommissionHeadID
            references [User],
    Created              datetime2        default getutcdate() not null,
    CreatedByID          bigint                                not null
        constraint FK_DepreciatedConsumableOrder_User_CreatedByID
            references [User],
    Deleted              bit              default 0            not null,
    DepreciatedToID      bigint                                not null
        constraint FK_DepreciatedConsumableOrder_User_DepreciatedToID
            references [User],
    NetUID               uniqueidentifier default newid()      not null,
    Updated              datetime2                             not null,
    ConsumablesStorageID bigint           default 0            not null
        constraint FK_DepreciatedConsumableOrder_ConsumablesStorage_ConsumablesStorageID
            references ConsumablesStorage,
    Number               nvarchar(50),
    UpdatedByID          bigint
        constraint FK_DepreciatedConsumableOrder_User_UpdatedByID
            references [User]
)
go

create index IX_DepreciatedConsumableOrder_CommissionHeadID
    on DepreciatedConsumableOrder (CommissionHeadID)
go

create index IX_DepreciatedConsumableOrder_CreatedByID
    on DepreciatedConsumableOrder (CreatedByID)
go

create index IX_DepreciatedConsumableOrder_DepreciatedToID
    on DepreciatedConsumableOrder (DepreciatedToID)
go

create index IX_DepreciatedConsumableOrder_ConsumablesStorageID
    on DepreciatedConsumableOrder (ConsumablesStorageID)
go

create index IX_DepreciatedConsumableOrder_UpdatedByID
    on DepreciatedConsumableOrder (UpdatedByID)
go

create table DepreciatedOrder
(
    ID             bigint identity
        constraint PK_DepreciatedOrder
            primary key,
    NetUID         uniqueidentifier default newid()      not null,
    Created        datetime2        default getutcdate() not null,
    Updated        datetime2                             not null,
    Deleted        bit              default 0            not null,
    Number         nvarchar(50),
    Comment        nvarchar(500),
    FromDate       datetime2                             not null,
    StorageID      bigint                                not null
        constraint FK_DepreciatedOrder_Storage_StorageID
            references Storage,
    ResponsibleID  bigint                                not null
        constraint FK_DepreciatedOrder_User_ResponsibleID
            references [User],
    OrganizationID bigint                                not null
        constraint FK_DepreciatedOrder_Organization_OrganizationID
            references Organization,
    IsManagement   bit              default 0            not null
)
go

create index IX_DepreciatedOrder_OrganizationID
    on DepreciatedOrder (OrganizationID)
go

create index IX_DepreciatedOrder_ResponsibleID
    on DepreciatedOrder (ResponsibleID)
go

create index IX_DepreciatedOrder_StorageID
    on DepreciatedOrder (StorageID)
go

create table ExchangeRateHistory
(
    ID             bigint identity
        constraint PK_ExchangeRateHistory
            primary key
                with (fillfactor = 60),
    Amount         decimal(30, 14)                       not null,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    ExchangeRateID bigint                                not null
        constraint FK_ExchangeRateHistory_ExchangeRate_ExchangeRateID
            references ExchangeRate,
    NetUID         uniqueidentifier default newid()      not null,
    Updated        datetime2                             not null,
    UpdatedByID    bigint                                not null
        constraint FK_ExchangeRateHistory_User_UpdatedByID
            references [User]
)
go

create index IX_ExchangeRateHistory_ExchangeRateID
    on ExchangeRateHistory (ExchangeRateID)
    with (fillfactor = 60)
go

create index IX_ExchangeRateHistory_UpdatedByID
    on ExchangeRateHistory (UpdatedByID)
    with (fillfactor = 60)
go

create table GovCrossExchangeRateHistory
(
    ID                     bigint identity
        constraint PK_GovCrossExchangeRateHistory
            primary key
                with (fillfactor = 60),
    NetUID                 uniqueidentifier default newid()      not null,
    Created                datetime2        default getutcdate() not null,
    Updated                datetime2                             not null,
    Deleted                bit              default 0            not null,
    Amount                 decimal(30, 14)                       not null,
    UpdatedByID            bigint                                not null
        constraint FK_GovCrossExchangeRateHistory_User_UpdatedByID
            references [User],
    GovCrossExchangeRateID bigint                                not null
        constraint FK_GovCrossExchangeRateHistory_GovCrossExchangeRate_GovCrossExchangeRateID
            references GovCrossExchangeRate
)
go

create index IX_GovCrossExchangeRateHistory_GovCrossExchangeRateID
    on GovCrossExchangeRateHistory (GovCrossExchangeRateID)
go

create index IX_GovCrossExchangeRateHistory_UpdatedByID
    on GovCrossExchangeRateHistory (UpdatedByID)
go

create table GovExchangeRateHistory
(
    ID                bigint identity
        constraint PK_GovExchangeRateHistory
            primary key
                with (fillfactor = 60),
    NetUID            uniqueidentifier default newid()      not null,
    Created           datetime2        default getutcdate() not null,
    Updated           datetime2                             not null,
    Deleted           bit              default 0            not null,
    Amount            decimal(30, 14)                       not null,
    GovExchangeRateID bigint                                not null
        constraint FK_GovExchangeRateHistory_GovExchangeRate_GovExchangeRateID
            references GovExchangeRate,
    UpdatedByID       bigint                                not null
        constraint FK_GovExchangeRateHistory_User_UpdatedByID
            references [User]
)
go

create index IX_GovExchangeRateHistory_GovExchangeRateID
    on GovExchangeRateHistory (GovExchangeRateID)
    with (fillfactor = 60)
go

create index IX_GovExchangeRateHistory_UpdatedByID
    on GovExchangeRateHistory (UpdatedByID)
    with (fillfactor = 60)
go

create table MisplacedSale
(
    ID                  bigint identity
        constraint PK_MisplacedSale
            primary key,
    NetUID              uniqueidentifier default newid()      not null,
    Created             datetime2        default getutcdate() not null,
    Updated             datetime2                             not null,
    Deleted             bit              default 0            not null,
    SaleID              bigint,
    RetailClientID      bigint                                not null
        constraint FK_MisplacedSale_RetailClient_RetailClientID
            references RetailClient,
    MisplacedSaleStatus int              default 0            not null,
    UserID              bigint
        constraint FK_MisplacedSale_User_UserID
            references [User]
)
go

create index IX_MisplacedSale_RetailClientID
    on MisplacedSale (RetailClientID)
go

create index IX_MisplacedSale_UserID
    on MisplacedSale (UserID)
go

create table PaymentRegisterCurrencyExchange
(
    ID                            bigint identity
        constraint PK_PaymentRegisterCurrencyExchange
            primary key,
    Amount                        money                                              not null,
    Created                       datetime2        default getutcdate()              not null,
    Deleted                       bit              default 0                         not null,
    ExchangeRate                  money                                              not null,
    FromPaymentCurrencyRegisterID bigint                                             not null
        constraint FK_PaymentRegisterCurrencyExchange_PaymentCurrencyRegister_FromPaymentCurrencyRegisterID
            references PaymentCurrencyRegister,
    NetUID                        uniqueidentifier default newid()                   not null,
    ToPaymentCurrencyRegisterID   bigint                                             not null
        constraint FK_PaymentRegisterCurrencyExchange_PaymentCurrencyRegister_ToPaymentCurrencyRegisterID
            references PaymentCurrencyRegister,
    Updated                       datetime2                                          not null,
    UserID                        bigint                                             not null
        constraint FK_PaymentRegisterCurrencyExchange_User_UserID
            references [User],
    CurrencyTraderID              bigint
        constraint FK_PaymentRegisterCurrencyExchange_CurrencyTrader_CurrencyTraderID
            references CurrencyTrader,
    Number                        nvarchar(50),
    Comment                       nvarchar(450),
    FromDate                      datetime2        default '0001-01-01T00:00:00.000' not null,
    IsCanceled                    bit              default 0                         not null,
    IncomeNumber                  nvarchar(150)
)
go

create index IX_PaymentRegisterCurrencyExchange_FromPaymentCurrencyRegisterID
    on PaymentRegisterCurrencyExchange (FromPaymentCurrencyRegisterID)
go

create index IX_PaymentRegisterCurrencyExchange_ToPaymentCurrencyRegisterID
    on PaymentRegisterCurrencyExchange (ToPaymentCurrencyRegisterID)
go

create index IX_PaymentRegisterCurrencyExchange_UserID
    on PaymentRegisterCurrencyExchange (UserID)
go

create index IX_PaymentRegisterCurrencyExchange_CurrencyTraderID
    on PaymentRegisterCurrencyExchange (CurrencyTraderID)
go

create table PaymentRegisterTransfer
(
    ID                            bigint identity
        constraint PK_PaymentRegisterTransfer
            primary key,
    Amount                        money                                              not null,
    Created                       datetime2        default getutcdate()              not null,
    Deleted                       bit              default 0                         not null,
    FromPaymentCurrencyRegisterID bigint                                             not null
        constraint FK_PaymentRegisterTransfer_PaymentCurrencyRegister_FromPaymentCurrencyRegisterID
            references PaymentCurrencyRegister,
    NetUID                        uniqueidentifier default newid()                   not null,
    ToPaymentCurrencyRegisterID   bigint                                             not null
        constraint FK_PaymentRegisterTransfer_PaymentCurrencyRegister_ToPaymentCurrencyRegisterID
            references PaymentCurrencyRegister,
    Updated                       datetime2                                          not null,
    UserID                        bigint                                             not null
        constraint FK_PaymentRegisterTransfer_User_UserID
            references [User],
    Number                        nvarchar(50),
    Comment                       nvarchar(450),
    FromDate                      datetime2        default '0001-01-01T00:00:00.000' not null,
    IsCanceled                    bit              default 0                         not null,
    TypeOfOperation               int              default 0                         not null
)
go

create index IX_PaymentRegisterTransfer_FromPaymentCurrencyRegisterID
    on PaymentRegisterTransfer (FromPaymentCurrencyRegisterID)
go

create index IX_PaymentRegisterTransfer_ToPaymentCurrencyRegisterID
    on PaymentRegisterTransfer (ToPaymentCurrencyRegisterID)
go

create index IX_PaymentRegisterTransfer_UserID
    on PaymentRegisterTransfer (UserID)
go

create table PreOrder
(
    ID           bigint identity
        constraint PK_PreOrder
            primary key,
    NetUID       uniqueidentifier default newid()                 not null,
    Created      datetime2        default getutcdate()            not null,
    Updated      datetime2                                        not null,
    Deleted      bit              default 0                       not null,
    Comment      nvarchar(250),
    MobileNumber nvarchar(25),
    ProductID    bigint                                           not null
        constraint FK_PreOrder_Product_ProductID
            references Product,
    ClientID     bigint
        constraint FK_PreOrder_Client_ClientID
            references Client,
    Qty          float            default 0.0000000000000000e+000 not null,
    Culture      nvarchar(4)
)
go

create index IX_PreOrder_ClientID
    on PreOrder (ClientID)
go

create index IX_PreOrder_ProductID
    on PreOrder (ProductID)
go

create table ProductCapitalization
(
    ID             bigint identity
        constraint PK_ProductCapitalization
            primary key,
    NetUID         uniqueidentifier default newid()              not null,
    Created        datetime2        default getutcdate()         not null,
    Updated        datetime2                                     not null,
    Deleted        bit              default 0                    not null,
    Number         nvarchar(50),
    Comment        nvarchar(500),
    FromDate       datetime2                                     not null,
    OrganizationID bigint                                        not null
        constraint FK_ProductCapitalization_Organization_OrganizationID
            references Organization,
    ResponsibleID  bigint                                        not null
        constraint FK_ProductCapitalization_User_ResponsibleID
            references [User],
    StorageID      bigint           default CONVERT([bigint], 0) not null
        constraint FK_ProductCapitalization_Storage_StorageID
            references Storage
)
go

create index IX_ProductCapitalization_OrganizationID
    on ProductCapitalization (OrganizationID)
    with (fillfactor = 60)
go

create index IX_ProductCapitalization_ResponsibleID
    on ProductCapitalization (ResponsibleID)
    with (fillfactor = 60)
go

create index IX_ProductCapitalization_StorageID
    on ProductCapitalization (StorageID)
    with (fillfactor = 60)
go

create table ProductCapitalizationItem
(
    ID                      bigint identity
        constraint PK_ProductCapitalizationItem
            primary key
                with (fillfactor = 60),
    NetUID                  uniqueidentifier default newid()      not null,
    Created                 datetime2        default getutcdate() not null,
    Updated                 datetime2                             not null,
    Deleted                 bit              default 0            not null,
    Qty                     float                                 not null,
    RemainingQty            float                                 not null,
    Weight                  float                                 not null,
    UnitPrice               money                                 not null,
    ProductID               bigint                                not null
        constraint FK_ProductCapitalizationItem_Product_ProductID
            references Product,
    ProductCapitalizationID bigint                                not null
        constraint FK_ProductCapitalizationItem_ProductCapitalization_ProductCapitalizationID
            references ProductCapitalization
)
go

create index IX_ProductCapitalizationItem_ProductCapitalizationID
    on ProductCapitalizationItem (ProductCapitalizationID)
    with (fillfactor = 60)
go

create index IX_ProductCapitalizationItem_ProductID
    on ProductCapitalizationItem (ProductID)
    with (fillfactor = 60)
go

create table ProductGroupDiscount
(
    ID                bigint identity
        constraint PK_ProductGroupDiscount
            primary key
                with (fillfactor = 60),
    ClientAgreementID bigint                                not null
        constraint FK_ProductGroupDiscount_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    DiscountRate      float                                 not null,
    IsActive          bit              default 1            not null,
    NetUID            uniqueidentifier default newid()      not null,
    ProductGroupID    bigint                                not null
        constraint FK_ProductGroupDiscount_ProductGroup_ProductGroupID
            references ProductGroup,
    Updated           datetime2                             not null
)
go

create index IX_ProductGroupDiscount_ClientAgreementID
    on ProductGroupDiscount (ClientAgreementID)
    with (fillfactor = 60)
go

create index IX_ProductGroupDiscount_ProductGroupID
    on ProductGroupDiscount (ProductGroupID)
    with (fillfactor = 60)
go

create table ProductIncome
(
    ID                bigint identity
        constraint PK_ProductIncome
            primary key
                with (fillfactor = 60),
    NetUID            uniqueidentifier default newid()           not null,
    Created           datetime2        default getutcdate()      not null,
    Updated           datetime2                                  not null,
    Deleted           bit              default 0                 not null,
    FromDate          datetime2                                  not null,
    Number            nvarchar(50),
    UserID            bigint                                     not null
        constraint FK_ProductIncome_User_UserID
            references [User],
    StorageID         bigint                                     not null
        constraint FK_ProductIncome_Storage_StorageID
            references Storage,
    Comment           nvarchar(500),
    ProductIncomeType int              default 0                 not null,
    IsHide            bit              default 0                 not null,
    IsFromOneC        bit              default CONVERT([bit], 0) not null
)
go

create index IX_ProductIncome_StorageID
    on ProductIncome (StorageID)
    with (fillfactor = 60)
go

create index IX_ProductIncome_UserID
    on ProductIncome (UserID)
    with (fillfactor = 60)
go

create table ProductPlacementHistory
(
    ID                  bigint identity
        constraint PK_ProductPlacementHistory
            primary key,
    Placement           nvarchar(500),
    ProductId           bigint                                not null
        constraint FK_ProductPlacementHistory_Product_ProductId
            references Product
            on delete cascade,
    StorageId           bigint                                not null
        constraint FK_ProductPlacementHistory_Storage_StorageId
            references Storage
            on delete cascade,
    Qty                 float                                 not null,
    StorageLocationType int                                   not null,
    AdditionType        int                                   not null,
    UserId              bigint                                not null
        constraint FK_ProductPlacementHistory_User_UserId
            references [User]
            on delete cascade,
    NetUID              uniqueidentifier default newid()      not null,
    Created             datetime2        default getutcdate() not null,
    Updated             datetime2                             not null,
    Deleted             bit              default 0            not null
)
go

create index IX_ProductPlacementHistory_ProductId
    on ProductPlacementHistory (ProductId)
go

create index IX_ProductPlacementHistory_StorageId
    on ProductPlacementHistory (StorageId)
go

create index IX_ProductPlacementHistory_UserId
    on ProductPlacementHistory (UserId)
go

create table ProductSpecification
(
    ID                bigint identity
        constraint PK_ProductSpecification
            primary key
                with (fillfactor = 60),
    AddedByID         bigint                                not null
        constraint FK_ProductSpecification_User_AddedByID
            references [User],
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    NetUID            uniqueidentifier default newid()      not null,
    ProductID         bigint                                not null
        constraint FK_ProductSpecification_Product_ProductID
            references Product,
    SpecificationCode nvarchar(100),
    Updated           datetime2                             not null,
    Name              nvarchar(500),
    IsActive          bit              default 0            not null,
    DutyPercent       money            default 0.0          not null,
    Locale            nvarchar(4),
    CustomsValue      decimal(18, 2)   default 0.0          not null,
    Duty              decimal(18, 2)   default 0.0          not null,
    VATPercent        decimal(18, 2)   default 0.0          not null,
    VATValue          decimal(18, 2)   default 0.0          not null
)
go

create index IX_ProductSpecification_AddedByID
    on ProductSpecification (AddedByID)
    with (fillfactor = 60)
go

create index IX_ProductSpecification_ProductID
    on ProductSpecification (ProductID)
    with (fillfactor = 60)
go

create table ProductTransfer
(
    ID             bigint identity
        constraint PK_ProductTransfer
            primary key,
    NetUID         uniqueidentifier default newid()      not null,
    Created        datetime2        default getutcdate() not null,
    Updated        datetime2                             not null,
    Deleted        bit              default 0            not null,
    Number         nvarchar(50),
    Comment        nvarchar(500),
    FromDate       datetime2                             not null,
    ResponsibleID  bigint                                not null
        constraint FK_ProductTransfer_User_ResponsibleID
            references [User],
    FromStorageID  bigint                                not null
        constraint FK_ProductTransfer_Storage_FromStorageID
            references Storage,
    ToStorageID    bigint                                not null
        constraint FK_ProductTransfer_Storage_ToStorageID
            references Storage,
    OrganizationID bigint                                not null
        constraint FK_ProductTransfer_Organization_OrganizationID
            references Organization,
    IsManagement   bit              default 0            not null
)
go

create table Consignment
(
    ID                 bigint identity
        constraint PK_Consignment
            primary key
                with (fillfactor = 60),
    NetUID             uniqueidentifier default newid()              not null,
    Created            datetime2        default getutcdate()         not null,
    Updated            datetime2                                     not null,
    Deleted            bit              default 0                    not null,
    FromDate           datetime2                                     not null,
    OrganizationID     bigint                                        not null
        constraint FK_Consignment_Organization_OrganizationID
            references Organization,
    ProductIncomeID    bigint                                        not null
        constraint FK_Consignment_ProductIncome_ProductIncomeID
            references ProductIncome,
    IsVirtual          bit              default 0                    not null,
    StorageID          bigint           default CONVERT([bigint], 0) not null
        constraint FK_Consignment_Storage_StorageID
            references Storage,
    ProductTransferID  bigint
        constraint FK_Consignment_ProductTransfer_ProductTransferID
            references ProductTransfer,
    IsImportedFromOneC bit              default 0                    not null
)
go

create index IX_Consignment_OrganizationID
    on Consignment (OrganizationID)
    with (fillfactor = 60)
go

create index IX_Consignment_ProductIncomeID
    on Consignment (ProductIncomeID)
    with (fillfactor = 60)
go

create index IX_Consignment_StorageID
    on Consignment (StorageID)
    with (fillfactor = 60)
go

create index IX_Consignment_ProductTransferID
    on Consignment (ProductTransferID)
    with (fillfactor = 60)
go

create table ConsignmentItem
(
    ID                     bigint identity
        constraint PK_ConsignmentItem
            primary key
                with (fillfactor = 60),
    NetUID                 uniqueidentifier default newid()      not null,
    Created                datetime2        default getutcdate() not null,
    Updated                datetime2                             not null,
    Deleted                bit              default 0            not null,
    Qty                    float                                 not null,
    RemainingQty           float                                 not null,
    Weight                 float                                 not null,
    Price                  decimal(30, 14)                       not null,
    DutyPercent            money                                 not null,
    ProductID              bigint                                not null
        constraint FK_ConsignmentItem_Product_ProductID
            references Product,
    ConsignmentID          bigint                                not null
        constraint FK_ConsignmentItem_Consignment_ConsignmentID
            references Consignment,
    ProductIncomeItemID    bigint                                not null,
    ProductSpecificationID bigint                                not null
        constraint FK_ConsignmentItem_ProductSpecification_ProductSpecificationID
            references ProductSpecification,
    RootConsignmentItemID  bigint
        constraint FK_ConsignmentItem_ConsignmentItem_RootConsignmentItemID
            references ConsignmentItem,
    NetPrice               decimal(30, 14)                       not null,
    AccountingPrice        decimal(30, 14)                       not null,
    ExchangeRate           money                                 not null
)
go

create index IX_ConsignmentItem_ConsignmentID
    on ConsignmentItem (ConsignmentID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItem_ProductID
    on ConsignmentItem (ProductID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItem_ProductIncomeItemID
    on ConsignmentItem (ProductIncomeItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItem_ProductSpecificationID
    on ConsignmentItem (ProductSpecificationID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItem_RootConsignmentItemID
    on ConsignmentItem (RootConsignmentItemID)
    with (fillfactor = 60)
go

create index IX_ProductTransfer_FromStorageID
    on ProductTransfer (FromStorageID)
go

create index IX_ProductTransfer_OrganizationID
    on ProductTransfer (OrganizationID)
go

create index IX_ProductTransfer_ResponsibleID
    on ProductTransfer (ResponsibleID)
go

create index IX_ProductTransfer_ToStorageID
    on ProductTransfer (ToStorageID)
go

create table ProductWriteOffRule
(
    ID             bigint identity
        constraint PK_ProductWriteOffRule
            primary key,
    NetUID         uniqueidentifier default newid()      not null,
    Created        datetime2        default getutcdate() not null,
    Updated        datetime2                             not null,
    Deleted        bit              default 0            not null,
    RuleLocale     nvarchar(4),
    RuleType       int                                   not null,
    CreatedByID    bigint                                not null
        constraint FK_ProductWriteOffRule_User_CreatedByID
            references [User],
    UpdatedByID    bigint
        constraint FK_ProductWriteOffRule_User_UpdatedByID
            references [User],
    ProductID      bigint
        constraint FK_ProductWriteOffRule_Product_ProductID
            references Product
            on delete cascade,
    ProductGroupID bigint
        constraint FK_ProductWriteOffRule_ProductGroup_ProductGroupID
            references ProductGroup
            on delete cascade
)
go

create index IX_ProductWriteOffRule_CreatedByID
    on ProductWriteOffRule (CreatedByID)
go

create index IX_ProductWriteOffRule_ProductGroupID
    on ProductWriteOffRule (ProductGroupID)
go

create index IX_ProductWriteOffRule_ProductID
    on ProductWriteOffRule (ProductID)
go

create index IX_ProductWriteOffRule_UpdatedByID
    on ProductWriteOffRule (UpdatedByID)
go

create table ReSale
(
    ID                      bigint identity
        constraint PK_ReSale
            primary key,
    NetUID                  uniqueidentifier default newid()              not null,
    Created                 datetime2        default getutcdate()         not null,
    Updated                 datetime2                                     not null,
    Deleted                 bit              default 0                    not null,
    Comment                 nvarchar(250),
    ClientAgreementID       bigint
        constraint FK_ReSale_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    OrganizationID          bigint                                        not null
        constraint FK_ReSale_Organization_OrganizationID
            references Organization,
    UserID                  bigint                                        not null
        constraint FK_ReSale_User_UserID
            references [User],
    SaleNumberID            bigint
        constraint FK_ReSale_SaleNumber_SaleNumberID
            references SaleNumber,
    ChangedToInvoice        datetime2,
    ChangedToInvoiceByID    bigint
        constraint FK_ReSale_User_ChangedToInvoiceByID
            references [User],
    BaseLifeCycleStatusID   bigint           default CONVERT([bigint], 0) not null
        constraint FK_ReSale_BaseLifeCycleStatus_BaseLifeCycleStatusID
            references BaseLifeCycleStatus,
    BaseSalePaymentStatusID bigint           default CONVERT([bigint], 0) not null
        constraint FK_ReSale_BaseSalePaymentStatus_BaseSalePaymentStatusID
            references BaseSalePaymentStatus,
    FromStorageID           bigint           default CONVERT([bigint], 0) not null
        constraint FK_ReSale_Storage_FromStorageID
            references Storage,
    IsCompleted             bit              default 0                    not null,
    TotalPaymentAmount      decimal(30, 14)  default 0.0                  not null
)
go

create index IX_ReSale_ClientAgreementID
    on ReSale (ClientAgreementID)
go

create index IX_ReSale_OrganizationID
    on ReSale (OrganizationID)
go

create index IX_ReSale_UserID
    on ReSale (UserID)
go

create index IX_ReSale_SaleNumberID
    on ReSale (SaleNumberID)
go

create index IX_ReSale_ChangedToInvoiceByID
    on ReSale (ChangedToInvoiceByID)
go

create index IX_ReSale_BaseLifeCycleStatusID
    on ReSale (BaseLifeCycleStatusID)
go

create index IX_ReSale_BaseSalePaymentStatusID
    on ReSale (BaseSalePaymentStatusID)
go

create index IX_ReSale_FromStorageID
    on ReSale (FromStorageID)
go

create table SaleReturn
(
    ID                bigint identity
        constraint PK_SaleReturn
            primary key,
    NetUID            uniqueidentifier default newid()              not null,
    Created           datetime2        default getutcdate()         not null,
    Updated           datetime2                                     not null,
    Deleted           bit              default 0                    not null,
    FromDate          datetime2                                     not null,
    ClientID          bigint                                        not null
        constraint FK_SaleReturn_Client_ClientID
            references Client,
    CreatedByID       bigint           default CONVERT([bigint], 0) not null
        constraint FK_SaleReturn_User_CreatedByID
            references [User],
    UpdatedByID       bigint
        constraint FK_SaleReturn_User_UpdatedByID
            references [User],
    Number            nvarchar(50),
    IsCanceled        bit              default 0                    not null,
    CanceledByID      bigint
        constraint FK_SaleReturn_User_CanceledByID
            references [User],
    ClientAgreementID bigint           default CONVERT([bigint], 0) not null
        constraint FK_SaleReturn_ClientAgreement_ClientAgreementID
            references ClientAgreement
)
go

create index IX_SaleReturn_ClientID
    on SaleReturn (ClientID)
go

create index IX_SaleReturn_CreatedByID
    on SaleReturn (CreatedByID)
go

create index IX_SaleReturn_UpdatedByID
    on SaleReturn (UpdatedByID)
go

create index IX_SaleReturn_CanceledByID
    on SaleReturn (CanceledByID)
go

create index IX_SaleReturn_ClientAgreementID
    on SaleReturn (ClientAgreementID)
go

create table ServicePayer
(
    ID             bigint identity
        constraint PK_ServicePayer
            primary key,
    ClientID       bigint                                not null
        constraint FK_ServicePayer_Client_ClientID
            references Client,
    Comment        nvarchar(max),
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    FirstName      nvarchar(max),
    LastName       nvarchar(max),
    MiddleName     nvarchar(max),
    MobilePhone    nvarchar(max),
    NetUID         uniqueidentifier default newid()      not null,
    PaymentAddress nvarchar(max),
    PaymentCard    nvarchar(max),
    ServiceType    int                                   not null,
    Updated        datetime2                             not null
)
go

create index IX_ServicePayer_ClientID
    on ServicePayer (ClientID)
go

create table ShipmentList
(
    ID            bigint identity
        constraint PK_ShipmentList
            primary key,
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    Number        nvarchar(50),
    Comment       nvarchar(500),
    FromDate      datetime2                             not null,
    IsSent        bit                                   not null,
    TransporterID bigint                                not null
        constraint FK_ShipmentList_Transporter_TransporterID
            references Transporter,
    ResponsibleID bigint                                not null
        constraint FK_ShipmentList_User_ResponsibleID
            references [User]
)
go

create index IX_ShipmentList_ResponsibleID
    on ShipmentList (ResponsibleID)
go

create index IX_ShipmentList_TransporterID
    on ShipmentList (TransporterID)
go

create table SupplyInformationTask
(
    ID          bigint identity
        constraint PK_SupplyInformationTask
            primary key
                with (fillfactor = 60),
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    Comment     nvarchar(500),
    FromDate    datetime2                             not null,
    UserID      bigint                                not null
        constraint FK_SupplyInformationTask_User_UserID
            references [User],
    UpdatedByID bigint
        constraint FK_SupplyInformationTask_User_UpdatedByID
            references [User],
    DeletedByID bigint
        constraint FK_SupplyInformationTask_User_DeletedByID
            references [User],
    GrossPrice  money                                 not null
)
go

create index IX_SupplyInformationTask_DeletedByID
    on SupplyInformationTask (DeletedByID)
go

create index IX_SupplyInformationTask_UpdatedByID
    on SupplyInformationTask (UpdatedByID)
go

create index IX_SupplyInformationTask_UserID
    on SupplyInformationTask (UserID)
go

create table SupplyOrderUkraine
(
    ID                                   bigint identity
        constraint PK_SupplyOrderUkraine
            primary key,
    NetUID                               uniqueidentifier default newid()                       not null,
    Created                              datetime2        default getutcdate()                  not null,
    Updated                              datetime2                                              not null,
    Deleted                              bit              default 0                             not null,
    FromDate                             datetime2                                              not null,
    IsPlaced                             bit                                                    not null,
    Number                               nvarchar(50),
    Comment                              nvarchar(500),
    ResponsibleID                        bigint                                                 not null
        constraint FK_SupplyOrderUkraine_User_ResponsibleID
            references [User],
    OrganizationID                       bigint                                                 not null
        constraint FK_SupplyOrderUkraine_Organization_OrganizationID
            references Organization,
    ClientAgreementID                    bigint           default CONVERT([bigint], 0)          not null
        constraint FK_SupplyOrderUkraine_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    SupplierID                           bigint           default CONVERT([bigint], 0)          not null
        constraint FK_SupplyOrderUkraine_Client_SupplierID
            references Client,
    ShipmentAmount                       decimal(30, 14)                                        not null,
    IsDirectFromSupplier                 bit              default 0                             not null,
    InvNumber                            nvarchar(50),
    AdditionalAmount                     money            default 0.0                           not null,
    AdditionalPaymentCurrencyID          bigint
        constraint FK_SupplyOrderUkraine_Currency_AdditionalPaymentCurrencyID
            references Currency,
    AdditionalPercent                    float            default 0.0000000000000000e+000       not null,
    AdditionalPaymentFromDate            datetime2,
    InvDate                              datetime2        default '0001-01-01T00:00:00.0000000' not null,
    VatPercent                           money            default 0.0                           not null,
    ShipmentAmountLocal                  decimal(30, 14)  default 0.0                           not null,
    IsPartialPlaced                      bit              default 0                             not null,
    TotalAccountingDeliveryExpenseAmount decimal(18, 2)   default 0.0                           not null,
    TotalDeliveryExpenseAmount           decimal(18, 2)   default 0.0                           not null
)
go

create table DeliveryExpense
(
    ID                              bigint identity
        constraint PK_DeliveryExpense
            primary key,
    InvoiceNumber                   nvarchar(50),
    FromDate                        datetime2                             not null,
    GrossAmount                     money                                 not null,
    VatPercent                      money                                 not null,
    AccountingGrossAmount           money                                 not null,
    AccountingVatPercent            money                                 not null,
    SupplyOrderUkraineID            bigint                                not null
        constraint FK_DeliveryExpense_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    SupplyOrganizationID            bigint                                not null
        constraint FK_DeliveryExpense_SupplyOrganization_SupplyOrganizationID
            references SupplyOrganization,
    SupplyOrganizationAgreementID   bigint                                not null
        constraint FK_DeliveryExpense_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    ConsumableProductID             bigint
        constraint FK_DeliveryExpense_ConsumableProduct_ConsumableProductID
            references ConsumableProduct,
    ActProvidingServiceDocumentID   bigint
        constraint FK_DeliveryExpense_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    ActProvidingServiceID           bigint
        constraint FK_DeliveryExpense_ActProvidingService_ActProvidingServiceID
            references ActProvidingService,
    UserID                          bigint                                not null
        constraint FK_DeliveryExpense_User_UserID
            references [User],
    NetUID                          uniqueidentifier default newid()      not null,
    Created                         datetime2        default getutcdate() not null,
    Updated                         datetime2                             not null,
    Deleted                         bit              default 0            not null,
    AccountingActProvidingServiceID bigint
        constraint FK_DeliveryExpense_ActProvidingService_AccountingActProvidingServiceID
            references ActProvidingService
)
go

create unique index IX_DeliveryExpense_ActProvidingServiceDocumentID
    on DeliveryExpense (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_DeliveryExpense_ActProvidingServiceID
    on DeliveryExpense (ActProvidingServiceID)
    where [ActProvidingServiceID] IS NOT NULL
go

create index IX_DeliveryExpense_ConsumableProductID
    on DeliveryExpense (ConsumableProductID)
go

create index IX_DeliveryExpense_SupplyOrderUkraineID
    on DeliveryExpense (SupplyOrderUkraineID)
go

create index IX_DeliveryExpense_SupplyOrganizationAgreementID
    on DeliveryExpense (SupplyOrganizationAgreementID)
go

create index IX_DeliveryExpense_SupplyOrganizationID
    on DeliveryExpense (SupplyOrganizationID)
go

create index IX_DeliveryExpense_UserID
    on DeliveryExpense (UserID)
go

create unique index IX_DeliveryExpense_AccountingActProvidingServiceID
    on DeliveryExpense (AccountingActProvidingServiceID)
    where [AccountingActProvidingServiceID] IS NOT NULL
go

create table Sad
(
    ID                            bigint identity
        constraint PK_Sad
            primary key,
    Created                       datetime2        default getutcdate()                  not null,
    Deleted                       bit              default 0                             not null,
    NetUID                        uniqueidentifier default newid()                       not null,
    Updated                       datetime2                                              not null,
    Comment                       nvarchar(500),
    IsSend                        bit              default 0                             not null,
    Number                        nvarchar(50),
    ResponsibleID                 bigint           default CONVERT([bigint], 0)          not null
        constraint FK_Sad_User_ResponsibleID
            references [User],
    StathamCarID                  bigint
        constraint FK_Sad_StathamCar_StathamCarID
            references StathamCar,
    StathamID                     bigint
        constraint FK_Sad_Statham_StathamID
            references Statham,
    OrganizationID                bigint
        constraint FK_Sad_Organization_OrganizationID
            references Organization,
    FromDate                      datetime2        default '0001-01-01T00:00:00.0000000' not null,
    SupplyOrderUkraineID          bigint
        constraint FK_Sad_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    MarginAmount                  money            default 0.0                           not null,
    OrganizationClientID          bigint
        constraint FK_Sad_OrganizationClient_OrganizationClientID
            references OrganizationClient,
    OrganizationClientAgreementID bigint
        constraint FK_Sad_OrganizationClientAgreement_OrganizationClientAgreementID
            references OrganizationClientAgreement,
    IsFromSale                    bit              default 0                             not null,
    SadType                       int              default 0                             not null,
    ClientID                      bigint
        constraint FK_Sad_Client_ClientID
            references Client,
    StathamPassportID             bigint
        constraint FK_Sad_StathamPassport_StathamPassportID
            references StathamPassport,
    ClientAgreementID             bigint
        constraint FK_Sad_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    VatPercent                    money            default 0.0                           not null
)
go

create index IX_Sad_ResponsibleID
    on Sad (ResponsibleID)
go

create index IX_Sad_StathamCarID
    on Sad (StathamCarID)
go

create index IX_Sad_StathamID
    on Sad (StathamID)
go

create index IX_Sad_OrganizationID
    on Sad (OrganizationID)
go

create unique index IX_Sad_SupplyOrderUkraineID
    on Sad (SupplyOrderUkraineID)
    where [SupplyOrderUkraineID] IS NOT NULL
go

create index IX_Sad_OrganizationClientID
    on Sad (OrganizationClientID)
go

create index IX_Sad_OrganizationClientAgreementID
    on Sad (OrganizationClientAgreementID)
go

create index IX_Sad_ClientID
    on Sad (ClientID)
go

create index IX_Sad_StathamPassportID
    on Sad (StathamPassportID)
go

create index IX_Sad_ClientAgreementID
    on Sad (ClientAgreementID)
go

create table SadDocument
(
    ID            bigint identity
        constraint PK_SadDocument
            primary key,
    ContentType   nvarchar(250),
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(250),
    FileName      nvarchar(250),
    GeneratedName nvarchar(250),
    NetUID        uniqueidentifier default newid()      not null,
    SadID         bigint                                not null
        constraint FK_SadDocument_Sad_SadID
            references Sad,
    Updated       datetime2                             not null
)
go

create index IX_SadDocument_SadID
    on SadDocument (SadID)
go

create table SadPallet
(
    ID              bigint identity
        constraint PK_SadPallet
            primary key,
    NetUID          uniqueidentifier default newid()      not null,
    Created         datetime2        default getutcdate() not null,
    Updated         datetime2                             not null,
    Deleted         bit              default 0            not null,
    SadID           bigint                                not null
        constraint FK_SadPallet_Sad_SadID
            references Sad,
    SadPalletTypeID bigint                                not null
        constraint FK_SadPallet_SadPalletType_SadPalletTypeID
            references SadPalletType,
    Comment         nvarchar(250),
    Number          nvarchar(50)
)
go

create index IX_SadPallet_SadID
    on SadPallet (SadID)
go

create index IX_SadPallet_SadPalletTypeID
    on SadPallet (SadPalletTypeID)
go

create index IX_SupplyOrderUkraine_OrganizationID
    on SupplyOrderUkraine (OrganizationID)
go

create index IX_SupplyOrderUkraine_ResponsibleID
    on SupplyOrderUkraine (ResponsibleID)
go

create index IX_SupplyOrderUkraine_ClientAgreementID
    on SupplyOrderUkraine (ClientAgreementID)
go

create index IX_SupplyOrderUkraine_SupplierID
    on SupplyOrderUkraine (SupplierID)
go

create index IX_SupplyOrderUkraine_AdditionalPaymentCurrencyID
    on SupplyOrderUkraine (AdditionalPaymentCurrencyID)
go

create table SupplyOrderUkraineDocument
(
    ID                   bigint identity
        constraint PK_SupplyOrderUkraineDocument
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    DocumentUrl          nvarchar(500),
    FileName             nvarchar(500),
    ContentType          nvarchar(500),
    GeneratedName        nvarchar(500),
    SupplyOrderUkraineID bigint                                not null
        constraint FK_SupplyOrderUkraineDocument_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine
)
go

create index IX_SupplyOrderUkraineDocument_SupplyOrderUkraineID
    on SupplyOrderUkraineDocument (SupplyOrderUkraineID)
go

create table SupplyPaymentTask
(
    ID                    bigint identity
        constraint PK_SupplyPaymentTask
            primary key,
    Created               datetime2        default getutcdate()      not null,
    Deleted               bit              default 0                 not null,
    NetUID                uniqueidentifier default newid()           not null,
    Updated               datetime2                                  not null,
    Comment               nvarchar(max),
    UserID                bigint
        constraint FK_SupplyPaymentTask_User_UserID
            references [User],
    PayToDate             datetime2,
    TaskAssignedTo        int              default 0                 not null,
    TaskStatus            int              default 0                 not null,
    TaskStatusUpdated     datetime2,
    GrossPrice            money            default 0.0               not null,
    NetPrice              money            default 0.0               not null,
    IsAvailableForPayment bit              default 0                 not null,
    DeletedByID           bigint
        constraint FK_SupplyPaymentTask_User_DeletedByID
            references [User],
    UpdatedByID           bigint
        constraint FK_SupplyPaymentTask_User_UpdatedByID
            references [User],
    IsAccounting          bit              default 0                 not null,
    IsImportedFromOneC    bit              default CONVERT([bit], 0) not null
)
go

create table BillOfLadingService
(
    ID                                 bigint identity
        constraint PK_BillOfLadingService
            primary key
                with (fillfactor = 60),
    NetUID                             uniqueidentifier default newid()              not null,
    Created                            datetime2        default getutcdate()         not null,
    Updated                            datetime2                                     not null,
    Deleted                            bit              default 0                    not null,
    IsActive                           bit                                           not null,
    FromDate                           datetime2,
    GrossPrice                         money                                         not null,
    NetPrice                           money                                         not null,
    Vat                                money                                         not null,
    AccountingGrossPrice               money                                         not null,
    AccountingNetPrice                 money                                         not null,
    AccountingVat                      money                                         not null,
    VatPercent                         float                                         not null,
    AccountingVatPercent               float                                         not null,
    Number                             nvarchar(max),
    ServiceNumber                      nvarchar(50),
    Name                               nvarchar(max),
    UserID                             bigint
        constraint FK_BillOfLadingService_User_UserID
            references [User],
    SupplyPaymentTaskID                bigint
        constraint FK_BillOfLadingService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    AccountingPaymentTaskID            bigint
        constraint FK_BillOfLadingService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    SupplyOrganizationAgreementID      bigint                                        not null
        constraint FK_BillOfLadingService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    LoadDate                           datetime2,
    BillOfLadingNumber                 nvarchar(max),
    TermDeliveryInDays                 nvarchar(max),
    SupplyOrganizationID               bigint                                        not null
        constraint FK_BillOfLadingService_SupplyOrganization_SupplyOrganizationID
            references SupplyOrganization,
    IsAutoCalculatedValue              bit                                           not null,
    SupplyExtraChargeType              int              default 0                    not null,
    TypeBillOfLadingService            int              default 0                    not null,
    DeliveryProductProtocolID          bigint           default CONVERT([bigint], 0) not null
        constraint FK_BillOfLadingService_DeliveryProductProtocol_DeliveryProductProtocolID
            references DeliveryProductProtocol,
    IsCalculatedValue                  bit              default 0                    not null,
    IsShipped                          bit              default 0                    not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                  not null,
    SupplyInformationTaskID            bigint
        constraint FK_BillOfLadingService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                    not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_BillOfLadingService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_BillOfLadingService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceID    bigint
        constraint FK_BillOfLadingService_ActProvidingService_AccountingActProvidingServiceID
            references ActProvidingService,
    ActProvidingServiceID              bigint
        constraint FK_BillOfLadingService_ActProvidingService_ActProvidingServiceID
            references ActProvidingService
)
go

create table BillOfLadingDocument
(
    ID                    bigint identity
        constraint PK_BillOfLadingDocument
            primary key
                with (fillfactor = 60),
    Amount                money                                 not null,
    ContentType           nvarchar(max),
    Created               datetime2        default getutcdate() not null,
    Date                  datetime2                             not null,
    Deleted               bit              default 0            not null,
    DocumentUrl           nvarchar(max),
    FileName              nvarchar(max),
    GeneratedName         nvarchar(max),
    NetUID                uniqueidentifier default newid()      not null,
    Number                nvarchar(max),
    Updated               datetime2                             not null,
    BillOfLadingServiceID bigint
        constraint FK_BillOfLadingDocument_BillOfLadingService_BillOfLadingServiceID
            references BillOfLadingService
)
go

create index IX_BillOfLadingDocument_BillOfLadingServiceID
    on BillOfLadingDocument (BillOfLadingServiceID)
    with (fillfactor = 60)
go

create index IX_BillOfLadingService_AccountingPaymentTaskID
    on BillOfLadingService (AccountingPaymentTaskID)
go

create index IX_BillOfLadingService_SupplyOrganizationAgreementID
    on BillOfLadingService (SupplyOrganizationAgreementID)
go

create index IX_BillOfLadingService_SupplyOrganizationID
    on BillOfLadingService (SupplyOrganizationID)
go

create index IX_BillOfLadingService_SupplyPaymentTaskID
    on BillOfLadingService (SupplyPaymentTaskID)
go

create index IX_BillOfLadingService_UserID
    on BillOfLadingService (UserID)
go

create unique index IX_BillOfLadingService_DeliveryProductProtocolID
    on BillOfLadingService (DeliveryProductProtocolID)
go

create unique index IX_BillOfLadingService_SupplyInformationTaskID
    on BillOfLadingService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_BillOfLadingService_ActProvidingServiceDocumentID
    on BillOfLadingService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_BillOfLadingService_SupplyServiceAccountDocumentID
    on BillOfLadingService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create unique index IX_BillOfLadingService_AccountingActProvidingServiceID
    on BillOfLadingService (AccountingActProvidingServiceID)
    where [AccountingActProvidingServiceID] IS NOT NULL
go

create unique index IX_BillOfLadingService_ActProvidingServiceID
    on BillOfLadingService (ActProvidingServiceID)
    where [ActProvidingServiceID] IS NOT NULL
go

create table ConsumablesOrder
(
    ID                   bigint identity
        constraint PK_ConsumablesOrder
            primary key,
    Comment              nvarchar(450),
    Created              datetime2        default getutcdate()              not null,
    Deleted              bit              default 0                         not null,
    NetUID               uniqueidentifier default newid()                   not null,
    Number               nvarchar(50),
    Updated              datetime2                                          not null,
    OrganizationFromDate datetime2        default '0001-01-01T00:00:00.000' not null,
    OrganizationNumber   nvarchar(50),
    IsPayed              bit              default 0                         not null,
    UserID               bigint                                             not null
        constraint FK_ConsumablesOrder_User_UserID
            references [User],
    ConsumablesStorageID bigint
        constraint FK_ConsumablesOrder_ConsumablesStorage_ConsumablesStorageID
            references ConsumablesStorage,
    SupplyPaymentTaskID  bigint
        constraint FK_ConsumablesOrder_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask
)
go

create index IX_ConsumablesOrder_UserID
    on ConsumablesOrder (UserID)
go

create index IX_ConsumablesOrder_ConsumablesStorageID
    on ConsumablesOrder (ConsumablesStorageID)
go

create unique index IX_ConsumablesOrder_SupplyPaymentTaskID
    on ConsumablesOrder (SupplyPaymentTaskID)
    where [SupplyPaymentTaskID] IS NOT NULL
go

create table ConsumablesOrderDocument
(
    ID                 bigint identity
        constraint PK_ConsumablesOrderDocument
            primary key,
    ConsumablesOrderID bigint                                not null
        constraint FK_ConsumablesOrderDocument_ConsumablesOrder_ConsumablesOrderID
            references ConsumablesOrder
            on delete cascade,
    ContentType        nvarchar(max),
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    DocumentUrl        nvarchar(max),
    FileName           nvarchar(max),
    GeneratedName      nvarchar(max),
    NetUID             uniqueidentifier default newid()      not null,
    Updated            datetime2                             not null
)
go

create index IX_ConsumablesOrderDocument_ConsumablesOrderID
    on ConsumablesOrderDocument (ConsumablesOrderID)
go

create table ConsumablesOrderItem
(
    ID                              bigint identity
        constraint PK_ConsumablesOrderItem
            primary key,
    ConsumableProductCategoryID     bigint                                           not null
        constraint FK_ConsumablesOrderItem_ConsumableProductCategory_ConsumableProductCategoryID
            references ConsumableProductCategory,
    ConsumableProductID             bigint
        constraint FK_ConsumablesOrderItem_ConsumableProduct_ConsumableProductID
            references ConsumableProduct,
    ConsumableProductOrganizationID bigint
        constraint FK_ConsumablesOrderItem_SupplyOrganization_ConsumableProductOrganizationID
            references SupplyOrganization,
    ConsumablesOrderID              bigint                                           not null
        constraint FK_ConsumablesOrderItem_ConsumablesOrder_ConsumablesOrderID
            references ConsumablesOrder,
    Created                         datetime2        default getutcdate()            not null,
    Deleted                         bit              default 0                       not null,
    NetUID                          uniqueidentifier default newid()                 not null,
    TotalPrice                      money                                            not null,
    Qty                             float                                            not null,
    Updated                         datetime2                                        not null,
    PricePerItem                    money            default 0.0                     not null,
    VAT                             money            default 0.0                     not null,
    VatPercent                      float            default 0.0000000000000000e+000 not null,
    IsService                       bit              default 0                       not null,
    SupplyOrganizationAgreementID   bigint
        constraint FK_ConsumablesOrderItem_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    TotalPriceWithVAT               money            default 0.0                     not null
)
go

create index IX_ConsumablesOrderItem_ConsumableProductCategoryID
    on ConsumablesOrderItem (ConsumableProductCategoryID)
go

create index IX_ConsumablesOrderItem_ConsumableProductID
    on ConsumablesOrderItem (ConsumableProductID)
go

create index IX_ConsumablesOrderItem_ConsumableProductOrganizationID
    on ConsumablesOrderItem (ConsumableProductOrganizationID)
go

create index IX_ConsumablesOrderItem_ConsumablesOrderID
    on ConsumablesOrderItem (ConsumablesOrderID)
go

create index IX_ConsumablesOrderItem_SupplyOrganizationAgreementID
    on ConsumablesOrderItem (SupplyOrganizationAgreementID)
go

create table ContainerService
(
    ID                                 bigint identity
        constraint PK_ContainerService
            primary key
                with (fillfactor = 60),
    NetPrice                           money                                            not null,
    BillOfLadingDocumentID             bigint
        constraint FK_ContainerService_BillOfLadingDocument_BillOfLadingDocumentID
            references BillOfLadingDocument,
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    LoadDate                           datetime2                                        not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    TermDeliveryInDays                 nvarchar(max),
    Updated                            datetime2                                        not null,
    SupplyPaymentTaskID                bigint
        constraint FK_ContainerService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    UserID                             bigint
        constraint FK_ContainerService_User_UserID
            references [User],
    ContainerOrganizationID            bigint
        constraint FK_ContainerService_SupplyOrganization_ContainerOrganizationID
            references SupplyOrganization,
    FromDate                           datetime2,
    GroosWeight                        float            default 0.0000000000000000e+000 not null,
    GrossPrice                         money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    IsCalculatedExtraCharge            bit              default 0                       not null,
    SupplyExtraChargeType              int              default 0                       not null,
    ContainerNumber                    nvarchar(max),
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_ContainerService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_ContainerService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_ContainerService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_ContainerService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_ContainerService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_ContainerService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_ContainerService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_ContainerService_BillOfLadingDocumentID
    on ContainerService (BillOfLadingDocumentID)
go

create index IX_ContainerService_SupplyPaymentTaskID
    on ContainerService (SupplyPaymentTaskID)
go

create index IX_ContainerService_UserID
    on ContainerService (UserID)
go

create index IX_ContainerService_ContainerOrganizationID
    on ContainerService (ContainerOrganizationID)
go

create index IX_ContainerService_SupplyOrganizationAgreementID
    on ContainerService (SupplyOrganizationAgreementID)
go

create index IX_ContainerService_AccountingPaymentTaskID
    on ContainerService (AccountingPaymentTaskID)
go

create unique index IX_ContainerService_SupplyInformationTaskID
    on ContainerService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_ContainerService_ActProvidingServiceDocumentID
    on ContainerService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_ContainerService_SupplyServiceAccountDocumentID
    on ContainerService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_ContainerService_AccountingActProvidingServiceId
    on ContainerService (AccountingActProvidingServiceId)
go

create index IX_ContainerService_ActProvidingServiceId
    on ContainerService (ActProvidingServiceId)
go

create table CustomAgencyService
(
    ID                                 bigint identity
        constraint PK_CustomAgencyService
            primary key,
    Created                            datetime2        default getutcdate()            not null,
    CustomAgencyOrganizationID         bigint
        constraint FK_CustomAgencyService_SupplyOrganization_CustomAgencyOrganizationID
            references SupplyOrganization,
    Deleted                            bit              default 0                       not null,
    FromDate                           datetime2,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    SupplyPaymentTaskID                bigint
        constraint FK_CustomAgencyService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_CustomAgencyService_User_UserID
            references [User],
    GrossPrice                         money            default 0.0                     not null,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_CustomAgencyService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_CustomAgencyService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_CustomAgencyService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_CustomAgencyService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_CustomAgencyService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_CustomAgencyService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_CustomAgencyService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_CustomAgencyService_CustomAgencyOrganizationID
    on CustomAgencyService (CustomAgencyOrganizationID)
go

create index IX_CustomAgencyService_SupplyPaymentTaskID
    on CustomAgencyService (SupplyPaymentTaskID)
go

create index IX_CustomAgencyService_UserID
    on CustomAgencyService (UserID)
go

create index IX_CustomAgencyService_SupplyOrganizationAgreementID
    on CustomAgencyService (SupplyOrganizationAgreementID)
go

create index IX_CustomAgencyService_AccountingPaymentTaskID
    on CustomAgencyService (AccountingPaymentTaskID)
go

create unique index IX_CustomAgencyService_SupplyInformationTaskID
    on CustomAgencyService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_CustomAgencyService_ActProvidingServiceDocumentID
    on CustomAgencyService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_CustomAgencyService_SupplyServiceAccountDocumentID
    on CustomAgencyService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_CustomAgencyService_AccountingActProvidingServiceId
    on CustomAgencyService (AccountingActProvidingServiceId)
go

create index IX_CustomAgencyService_ActProvidingServiceId
    on CustomAgencyService (ActProvidingServiceId)
go

create table DepreciatedConsumableOrderItem
(
    ID                           bigint identity
        constraint PK_DepreciatedConsumableOrderItem
            primary key,
    ConsumablesOrderItemID       bigint                                not null
        constraint FK_DepreciatedConsumableOrderItem_ConsumablesOrderItem_ConsumablesOrderItemID
            references ConsumablesOrderItem,
    Created                      datetime2        default getutcdate() not null,
    Deleted                      bit              default 0            not null,
    DepreciatedConsumableOrderID bigint                                not null
        constraint FK_DepreciatedConsumableOrderItem_DepreciatedConsumableOrder_DepreciatedConsumableOrderID
            references DepreciatedConsumableOrder,
    NetUID                       uniqueidentifier default newid()      not null,
    Qty                          float                                 not null,
    Updated                      datetime2                             not null
)
go

create index IX_DepreciatedConsumableOrderItem_ConsumablesOrderItemID
    on DepreciatedConsumableOrderItem (ConsumablesOrderItemID)
go

create index IX_DepreciatedConsumableOrderItem_DepreciatedConsumableOrderID
    on DepreciatedConsumableOrderItem (DepreciatedConsumableOrderID)
go

create table PlaneDeliveryService
(
    ID                                 bigint identity
        constraint PK_PlaneDeliveryService
            primary key,
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    FromDate                           datetime2,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    PlaneDeliveryOrganizationID        bigint
        constraint FK_PlaneDeliveryService_SupplyOrganization_PlaneDeliveryOrganizationID
            references SupplyOrganization,
    SupplyPaymentTaskID                bigint
        constraint FK_PlaneDeliveryService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_PlaneDeliveryService_User_UserID
            references [User],
    GrossPrice                         money            default 0.0                     not null,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_PlaneDeliveryService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_PlaneDeliveryService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_PlaneDeliveryService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_PlaneDeliveryService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_PlaneDeliveryService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_PlaneDeliveryService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_PlaneDeliveryService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_PlaneDeliveryService_PlaneDeliveryOrganizationID
    on PlaneDeliveryService (PlaneDeliveryOrganizationID)
go

create index IX_PlaneDeliveryService_SupplyPaymentTaskID
    on PlaneDeliveryService (SupplyPaymentTaskID)
go

create index IX_PlaneDeliveryService_UserID
    on PlaneDeliveryService (UserID)
go

create index IX_PlaneDeliveryService_SupplyOrganizationAgreementID
    on PlaneDeliveryService (SupplyOrganizationAgreementID)
go

create index IX_PlaneDeliveryService_AccountingPaymentTaskID
    on PlaneDeliveryService (AccountingPaymentTaskID)
go

create unique index IX_PlaneDeliveryService_SupplyInformationTaskID
    on PlaneDeliveryService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_PlaneDeliveryService_ActProvidingServiceDocumentID
    on PlaneDeliveryService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_PlaneDeliveryService_SupplyServiceAccountDocumentID
    on PlaneDeliveryService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_PlaneDeliveryService_AccountingActProvidingServiceId
    on PlaneDeliveryService (AccountingActProvidingServiceId)
go

create index IX_PlaneDeliveryService_ActProvidingServiceId
    on PlaneDeliveryService (ActProvidingServiceId)
go

create table PortCustomAgencyService
(
    ID                                 bigint identity
        constraint PK_PortCustomAgencyService
            primary key,
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    FromDate                           datetime2,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    PortCustomAgencyOrganizationID     bigint
        constraint FK_PortCustomAgencyService_SupplyOrganization_PortCustomAgencyOrganizationID
            references SupplyOrganization,
    SupplyPaymentTaskID                bigint
        constraint FK_PortCustomAgencyService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_PortCustomAgencyService_User_UserID
            references [User],
    GrossPrice                         money            default 0.0                     not null,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_PortCustomAgencyService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_PortCustomAgencyService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_PortCustomAgencyService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_PortCustomAgencyService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_PortCustomAgencyService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_PortCustomAgencyService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_PortCustomAgencyService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_PortCustomAgencyService_PortCustomAgencyOrganizationID
    on PortCustomAgencyService (PortCustomAgencyOrganizationID)
go

create index IX_PortCustomAgencyService_SupplyPaymentTaskID
    on PortCustomAgencyService (SupplyPaymentTaskID)
go

create index IX_PortCustomAgencyService_UserID
    on PortCustomAgencyService (UserID)
go

create index IX_PortCustomAgencyService_SupplyOrganizationAgreementID
    on PortCustomAgencyService (SupplyOrganizationAgreementID)
go

create index IX_PortCustomAgencyService_AccountingPaymentTaskID
    on PortCustomAgencyService (AccountingPaymentTaskID)
go

create unique index IX_PortCustomAgencyService_SupplyInformationTaskID
    on PortCustomAgencyService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_PortCustomAgencyService_ActProvidingServiceDocumentID
    on PortCustomAgencyService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_PortCustomAgencyService_SupplyServiceAccountDocumentID
    on PortCustomAgencyService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_PortCustomAgencyService_AccountingActProvidingServiceId
    on PortCustomAgencyService (AccountingActProvidingServiceId)
go

create index IX_PortCustomAgencyService_ActProvidingServiceId
    on PortCustomAgencyService (ActProvidingServiceId)
go

create table PortWorkService
(
    ID                                 bigint identity
        constraint PK_PortWorkService
            primary key,
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    SupplyPaymentTaskID                bigint
        constraint FK_PortWorkService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_PortWorkService_User_UserID
            references [User],
    PortWorkOrganizationID             bigint
        constraint FK_PortWorkService_SupplyOrganization_PortWorkOrganizationID
            references SupplyOrganization,
    GrossPrice                         money            default 0.0                     not null,
    FromDate                           datetime2,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_PortWorkService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_PortWorkService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_PortWorkService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_PortWorkService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_PortWorkService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_PortWorkService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_PortWorkService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_PortWorkService_SupplyPaymentTaskID
    on PortWorkService (SupplyPaymentTaskID)
go

create index IX_PortWorkService_UserID
    on PortWorkService (UserID)
go

create index IX_PortWorkService_PortWorkOrganizationID
    on PortWorkService (PortWorkOrganizationID)
go

create index IX_PortWorkService_SupplyOrganizationAgreementID
    on PortWorkService (SupplyOrganizationAgreementID)
go

create index IX_PortWorkService_AccountingPaymentTaskID
    on PortWorkService (AccountingPaymentTaskID)
go

create unique index IX_PortWorkService_SupplyInformationTaskID
    on PortWorkService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_PortWorkService_ActProvidingServiceDocumentID
    on PortWorkService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_PortWorkService_SupplyServiceAccountDocumentID
    on PortWorkService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_PortWorkService_AccountingActProvidingServiceId
    on PortWorkService (AccountingActProvidingServiceId)
go

create index IX_PortWorkService_ActProvidingServiceId
    on PortWorkService (ActProvidingServiceId)
go

create table SupplyOrderUkrainePaymentDeliveryProtocol
(
    ID                                             bigint identity
        constraint PK_SupplyOrderUkrainePaymentDeliveryProtocol
            primary key,
    NetUID                                         uniqueidentifier default newid()      not null,
    Created                                        datetime2        default getutcdate() not null,
    Updated                                        datetime2                             not null,
    Deleted                                        bit              default 0            not null,
    Value                                          money                                 not null,
    Discount                                       float                                 not null,
    SupplyOrderUkrainePaymentDeliveryProtocolKeyID bigint                                not null
        constraint [FK_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkrainePaymentDeliveryProtocolKey_SupplyOrderUkrainePaymentDeliveryProt~]
            references SupplyOrderUkrainePaymentDeliveryProtocolKey,
    UserID                                         bigint                                not null
        constraint FK_SupplyOrderUkrainePaymentDeliveryProtocol_User_UserID
            references [User],
    SupplyOrderUkraineID                           bigint                                not null
        constraint FK_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    SupplyPaymentTaskID                            bigint
        constraint FK_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    IsAccounting                                   bit              default 0            not null
)
go

create index IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkraineID
    on SupplyOrderUkrainePaymentDeliveryProtocol (SupplyOrderUkraineID)
go

create index IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyOrderUkrainePaymentDeliveryProtocolKeyID
    on SupplyOrderUkrainePaymentDeliveryProtocol (SupplyOrderUkrainePaymentDeliveryProtocolKeyID)
go

create index IX_SupplyOrderUkrainePaymentDeliveryProtocol_SupplyPaymentTaskID
    on SupplyOrderUkrainePaymentDeliveryProtocol (SupplyPaymentTaskID)
go

create index IX_SupplyOrderUkrainePaymentDeliveryProtocol_UserID
    on SupplyOrderUkrainePaymentDeliveryProtocol (UserID)
go

create index IX_SupplyPaymentTask_UserID
    on SupplyPaymentTask (UserID)
    with (fillfactor = 60)
go

create index IX_SupplyPaymentTask_DeletedByID
    on SupplyPaymentTask (DeletedByID)
    with (fillfactor = 60)
go

create index IX_SupplyPaymentTask_UpdatedByID
    on SupplyPaymentTask (UpdatedByID)
    with (fillfactor = 60)
go

create table SupplyPaymentTaskDocument
(
    ID                  bigint identity
        constraint PK_SupplyPaymentTaskDocument
            primary key,
    ContentType         nvarchar(max),
    Created             datetime2        default getutcdate() not null,
    Deleted             bit              default 0            not null,
    DocumentUrl         nvarchar(max),
    FileName            nvarchar(max),
    GeneratedName       nvarchar(max),
    NetUID              uniqueidentifier default newid()      not null,
    SupplyPaymentTaskID bigint                                not null
        constraint FK_SupplyPaymentTaskDocument_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated             datetime2                             not null
)
go

create index IX_SupplyPaymentTaskDocument_SupplyPaymentTaskID
    on SupplyPaymentTaskDocument (SupplyPaymentTaskID)
go

create table SupplyReturn
(
    ID                bigint identity
        constraint PK_SupplyReturn
            primary key,
    NetUID            uniqueidentifier default newid()           not null,
    Created           datetime2        default getutcdate()      not null,
    Updated           datetime2                                  not null,
    Deleted           bit              default 0                 not null,
    Number            nvarchar(50),
    Comment           nvarchar(500),
    FromDate          datetime2                                  not null,
    SupplierID        bigint                                     not null
        constraint FK_SupplyReturn_Client_SupplierID
            references Client,
    ClientAgreementID bigint                                     not null
        constraint FK_SupplyReturn_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    OrganizationID    bigint                                     not null
        constraint FK_SupplyReturn_Organization_OrganizationID
            references Organization,
    ResponsibleID     bigint                                     not null
        constraint FK_SupplyReturn_User_ResponsibleID
            references [User],
    StorageID         bigint                                     not null
        constraint FK_SupplyReturn_Storage_StorageID
            references Storage,
    IsManagement      bit              default CONVERT([bit], 0) not null
)
go

create index IX_SupplyReturn_ClientAgreementID
    on SupplyReturn (ClientAgreementID)
go

create index IX_SupplyReturn_OrganizationID
    on SupplyReturn (OrganizationID)
go

create index IX_SupplyReturn_ResponsibleID
    on SupplyReturn (ResponsibleID)
go

create index IX_SupplyReturn_StorageID
    on SupplyReturn (StorageID)
go

create index IX_SupplyReturn_SupplierID
    on SupplyReturn (SupplierID)
go

create table SupplyReturnItem
(
    ID                bigint identity
        constraint PK_SupplyReturnItem
            primary key,
    NetUID            uniqueidentifier default newid()              not null,
    Created           datetime2        default getutcdate()         not null,
    Updated           datetime2                                     not null,
    Deleted           bit              default 0                    not null,
    Qty               float                                         not null,
    ProductID         bigint                                        not null
        constraint FK_SupplyReturnItem_Product_ProductID
            references Product,
    SupplyReturnID    bigint                                        not null
        constraint FK_SupplyReturnItem_SupplyReturn_SupplyReturnID
            references SupplyReturn,
    ConsignmentItemID bigint           default CONVERT([bigint], 0) not null
        constraint FK_SupplyReturnItem_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem
)
go

create index IX_SupplyReturnItem_ProductID
    on SupplyReturnItem (ProductID)
go

create index IX_SupplyReturnItem_SupplyReturnID
    on SupplyReturnItem (SupplyReturnID)
go

create index IX_SupplyReturnItem_ConsignmentItemID
    on SupplyReturnItem (ConsignmentItemID)
go

create table TaxFreePackList
(
    ID                    bigint identity
        constraint PK_TaxFreePackList
            primary key,
    Created               datetime2        default getutcdate()                  not null,
    Deleted               bit              default 0                             not null,
    NetUID                uniqueidentifier default newid()                       not null,
    Updated               datetime2                                              not null,
    Comment               nvarchar(500),
    FromDate              datetime2        default '0001-01-01T00:00:00.0000000' not null,
    Number                nvarchar(50),
    OrganizationID        bigint
        constraint FK_TaxFreePackList_Organization_OrganizationID
            references Organization,
    ResponsibleID         bigint           default CONVERT([bigint], 0)          not null
        constraint FK_TaxFreePackList_User_ResponsibleID
            references [User],
    IsSent                bit              default 0                             not null,
    SupplyOrderUkraineID  bigint
        constraint FK_TaxFreePackList_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    IsFromSale            bit              default 0                             not null,
    ClientID              bigint
        constraint FK_TaxFreePackList_Client_ClientID
            references Client,
    MarginAmount          money            default 0.0                           not null,
    MaxPositionsInTaxFree int              default 0                             not null,
    MaxPriceLimit         decimal(18, 2)   default 0.0                           not null,
    MaxQtyInTaxFree       int              default 0                             not null,
    MinPriceLimit         decimal(18, 2)   default 0.0                           not null,
    WeightLimit           float            default 0.0000000000000000e+000       not null,
    ClientAgreementID     bigint
        constraint FK_TaxFreePackList_ClientAgreement_ClientAgreementID
            references ClientAgreement
)
go

create table TaxFree
(
    ID                   bigint identity
        constraint PK_TaxFree
            primary key
                with (fillfactor = 60),
    AmountInEur          money                                         not null,
    AmountInPLN          money                                         not null,
    AmountPayedStatham   money                                         not null,
    Created              datetime2        default getutcdate()         not null,
    CustomCode           nvarchar(150),
    DateOfIssue          datetime2,
    DateOfPrint          datetime2,
    DateOfStathamPayment datetime2,
    DateOfTabulation     datetime2,
    Deleted              bit              default 0                    not null,
    NetUID               uniqueidentifier default newid()              not null,
    Number               nvarchar(50),
    StathamID            bigint
        constraint FK_TaxFree_Statham_StathamID
            references Statham,
    TaxFreePackListID    bigint                                        not null
        constraint FK_TaxFree_TaxFreePackList_TaxFreePackListID
            references TaxFreePackList,
    TaxFreeStatus        int                                           not null,
    Updated              datetime2                                     not null,
    VatAmountInPLN       money                                         not null,
    Weight               float                                         not null,
    Comment              nvarchar(500),
    ResponsibleID        bigint           default CONVERT([bigint], 0) not null
        constraint FK_TaxFree_User_ResponsibleID
            references [User],
    StathamCarID         bigint
        constraint FK_TaxFree_StathamCar_StathamCarID
            references StathamCar,
    MarginAmount         money            default 0.0                  not null,
    VatPercent           money            default 0.0                  not null,
    CanceledDate         datetime2,
    ClosedDate           datetime2,
    FormedDate           datetime2,
    ReturnedDate         datetime2,
    SelectedDate         datetime2,
    StathamPassportID    bigint
        constraint FK_TaxFree_StathamPassport_StathamPassportID
            references StathamPassport
)
go

create table AdvancePayment
(
    ID                            bigint identity
        constraint PK_AdvancePayment
            primary key,
    NetUID                        uniqueidentifier default newid()                       not null,
    Created                       datetime2        default getutcdate()                  not null,
    Updated                       datetime2                                              not null,
    Deleted                       bit              default 0                             not null,
    Amount                        money                                                  not null,
    VatAmount                     money                                                  not null,
    VatPercent                    float                                                  not null,
    Comment                       nvarchar(450),
    UserID                        bigint                                                 not null
        constraint FK_AdvancePayment_User_UserID
            references [User],
    TaxFreeID                     bigint
        constraint FK_AdvancePayment_TaxFree_TaxFreeID
            references TaxFree,
    ClientAgreementID             bigint
        constraint FK_AdvancePayment_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    OrganizationClientAgreementID bigint
        constraint FK_AdvancePayment_OrganizationClientAgreement_OrganizationClientAgreementID
            references OrganizationClientAgreement,
    OrganizationID                bigint           default CONVERT([bigint], 0)          not null
        constraint FK_AdvancePayment_Organization_OrganizationID
            references Organization,
    FromDate                      datetime2        default '0001-01-01T00:00:00.0000000' not null,
    Number                        nvarchar(50),
    SadID                         bigint
        constraint FK_AdvancePayment_Sad_SadID
            references Sad
)
go

create index IX_AdvancePayment_ClientAgreementID
    on AdvancePayment (ClientAgreementID)
go

create index IX_AdvancePayment_OrganizationClientAgreementID
    on AdvancePayment (OrganizationClientAgreementID)
go

create index IX_AdvancePayment_TaxFreeID
    on AdvancePayment (TaxFreeID)
go

create index IX_AdvancePayment_UserID
    on AdvancePayment (UserID)
go

create index IX_AdvancePayment_OrganizationID
    on AdvancePayment (OrganizationID)
go

create index IX_AdvancePayment_SadID
    on AdvancePayment (SadID)
go

create table IncomePaymentOrder
(
    ID                            bigint identity
        constraint PK_IncomePaymentOrder
            primary key
                with (fillfactor = 60),
    Account                       int                                   not null,
    Amount                        money                                 not null,
    BankAccount                   nvarchar(50),
    ClientID                      bigint
        constraint FK_IncomePaymentOrder_Client_ClientID
            references Client,
    Comment                       nvarchar(450),
    Created                       datetime2        default getutcdate() not null,
    CurrencyID                    bigint                                not null
        constraint FK_IncomePaymentOrder_Currency_CurrencyID
            references Currency,
    Deleted                       bit              default 0            not null,
    ExchangeRate                  money                                 not null,
    FromDate                      datetime2                             not null,
    IsAccounting                  bit                                   not null,
    IsManagementAccounting        bit                                   not null,
    NetUID                        uniqueidentifier default newid()      not null,
    Number                        nvarchar(50),
    OrganizationID                bigint                                not null
        constraint FK_IncomePaymentOrder_Organization_OrganizationID
            references Organization,
    PaymentRegisterID             bigint                                not null
        constraint FK_IncomePaymentOrder_PaymentRegister_PaymentRegisterID
            references PaymentRegister,
    Updated                       datetime2                             not null,
    VAT                           money                                 not null,
    VatPercent                    float                                 not null,
    IncomePaymentOrderType        int              default 0            not null,
    UserID                        bigint           default 0            not null
        constraint FK_IncomePaymentOrder_User_UserID
            references [User],
    ColleagueID                   bigint
        constraint FK_IncomePaymentOrder_User_ColleagueID
            references [User],
    IsCanceled                    bit              default 0            not null,
    ClientAgreementID             bigint
        constraint FK_IncomePaymentOrder_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    EuroAmount                    money            default 0.0          not null,
    OverpaidAmount                money            default 0.0          not null,
    AgreementEuroExchangeRate     money            default 0.0          not null,
    OrganizationClientAgreementID bigint
        constraint FK_IncomePaymentOrder_OrganizationClientAgreement_OrganizationClientAgreementID
            references OrganizationClientAgreement,
    OrganizationClientID          bigint
        constraint FK_IncomePaymentOrder_OrganizationClient_OrganizationClientID
            references OrganizationClient,
    TaxFreeID                     bigint
        constraint FK_IncomePaymentOrder_TaxFree_TaxFreeID
            references TaxFree,
    SadID                         bigint
        constraint FK_IncomePaymentOrder_Sad_SadID
            references Sad,
    ArrivalNumber                 nvarchar(450),
    PaymentPurpose                nvarchar(450),
    OperationType                 int              default 0            not null,
    SupplyOrganizationAgreementID bigint
        constraint FK_IncomePaymentOrder_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    SupplyOrganizationID          bigint
        constraint FK_IncomePaymentOrder_SupplyOrganization_SupplyOrganizationID
            references SupplyOrganization,
    AgreementExchangedAmount      money            default 0.0          not null
)
go

create index IX_IncomePaymentOrder_ClientID
    on IncomePaymentOrder (ClientID)
go

create index IX_IncomePaymentOrder_CurrencyID
    on IncomePaymentOrder (CurrencyID)
go

create index IX_IncomePaymentOrder_OrganizationID
    on IncomePaymentOrder (OrganizationID)
go

create index IX_IncomePaymentOrder_PaymentRegisterID
    on IncomePaymentOrder (PaymentRegisterID)
go

create index IX_IncomePaymentOrder_UserID
    on IncomePaymentOrder (UserID)
go

create index IX_IncomePaymentOrder_ColleagueID
    on IncomePaymentOrder (ColleagueID)
go

create index IX_IncomePaymentOrder_ClientAgreementID
    on IncomePaymentOrder (ClientAgreementID)
go

create index IX_IncomePaymentOrder_OrganizationClientAgreementID
    on IncomePaymentOrder (OrganizationClientAgreementID)
go

create index IX_IncomePaymentOrder_OrganizationClientID
    on IncomePaymentOrder (OrganizationClientID)
go

create index IX_IncomePaymentOrder_TaxFreeID
    on IncomePaymentOrder (TaxFreeID)
go

create index IX_IncomePaymentOrder_SadID
    on IncomePaymentOrder (SadID)
go

create index IX_IncomePaymentOrder_SupplyOrganizationAgreementID
    on IncomePaymentOrder (SupplyOrganizationAgreementID)
go

create index IX_IncomePaymentOrder_SupplyOrganizationID
    on IncomePaymentOrder (SupplyOrganizationID)
go

create index IX_TaxFree_StathamID
    on TaxFree (StathamID)
go

create index IX_TaxFree_TaxFreePackListID
    on TaxFree (TaxFreePackListID)
go

create index IX_TaxFree_ResponsibleID
    on TaxFree (ResponsibleID)
go

create index IX_TaxFree_StathamCarID
    on TaxFree (StathamCarID)
go

create index IX_TaxFree_StathamPassportID
    on TaxFree (StathamPassportID)
go

create table TaxFreeDocument
(
    ID            bigint identity
        constraint PK_TaxFreeDocument
            primary key,
    ContentType   nvarchar(250),
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(250),
    FileName      nvarchar(250),
    GeneratedName nvarchar(250),
    NetUID        uniqueidentifier default newid()      not null,
    TaxFreeID     bigint                                not null
        constraint FK_TaxFreeDocument_TaxFree_TaxFreeID
            references TaxFree,
    Updated       datetime2                             not null
)
go

create index IX_TaxFreeDocument_TaxFreeID
    on TaxFreeDocument (TaxFreeID)
go

create index IX_TaxFreePackList_OrganizationID
    on TaxFreePackList (OrganizationID)
go

create index IX_TaxFreePackList_ResponsibleID
    on TaxFreePackList (ResponsibleID)
go

create unique index IX_TaxFreePackList_SupplyOrderUkraineID
    on TaxFreePackList (SupplyOrderUkraineID)
    where [SupplyOrderUkraineID] IS NOT NULL
go

create index IX_TaxFreePackList_ClientID
    on TaxFreePackList (ClientID)
go

create index IX_TaxFreePackList_ClientAgreementID
    on TaxFreePackList (ClientAgreementID)
go

create table TransportationService
(
    ID                                 bigint identity
        constraint PK_TransportationService
            primary key,
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    SupplyPaymentTaskID                bigint
        constraint FK_TransportationService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_TransportationService_User_UserID
            references [User],
    TransportationOrganizationID       bigint
        constraint FK_TransportationService_SupplyOrganization_TransportationOrganizationID
            references SupplyOrganization,
    GrossPrice                         money            default 0.0                     not null,
    FromDate                           datetime2,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    IsSealAndSignatureVerified         bit              default 0                       not null,
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_TransportationService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_TransportationService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_TransportationService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_TransportationService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_TransportationService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_TransportationService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_TransportationService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_TransportationService_SupplyPaymentTaskID
    on TransportationService (SupplyPaymentTaskID)
go

create index IX_TransportationService_UserID
    on TransportationService (UserID)
go

create index IX_TransportationService_TransportationOrganizationID
    on TransportationService (TransportationOrganizationID)
go

create index IX_TransportationService_SupplyOrganizationAgreementID
    on TransportationService (SupplyOrganizationAgreementID)
go

create index IX_TransportationService_AccountingPaymentTaskID
    on TransportationService (AccountingPaymentTaskID)
go

create unique index IX_TransportationService_SupplyInformationTaskID
    on TransportationService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_TransportationService_ActProvidingServiceDocumentID
    on TransportationService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_TransportationService_SupplyServiceAccountDocumentID
    on TransportationService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_TransportationService_AccountingActProvidingServiceId
    on TransportationService (AccountingActProvidingServiceId)
go

create index IX_TransportationService_ActProvidingServiceId
    on TransportationService (ActProvidingServiceId)
go

create index IX_User_UserRoleID
    on [User] (UserRoleID)
go

create index IX_User_UserDetailsId
    on [User] (UserDetailsId)
go

create index IX_UserDetails_ResidenceCardID
    on UserDetails (ResidenceCardID)
go

create index IX_UserDetails_WorkPermitID
    on UserDetails (WorkPermitID)
go

create index IX_UserDetails_WorkingContractID
    on UserDetails (WorkingContractID)
go

create table UserScreenResolution
(
    ID      bigint identity
        constraint PK_UserScreenResolution
            primary key,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Height  int                                   not null,
    NetUID  uniqueidentifier default newid()      not null,
    Updated datetime2                             not null,
    UserID  bigint                                not null
        constraint FK_UserScreenResolution_User_UserID
            references [User]
            on delete cascade,
    Width   int                                   not null
)
go

create index IX_UserScreenResolution_UserID
    on UserScreenResolution (UserID)
go

create table VehicleDeliveryService
(
    ID                                 bigint identity
        constraint PK_VehicleDeliveryService
            primary key
                with (fillfactor = 60),
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    FromDate                           datetime2,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    SupplyPaymentTaskID                bigint
        constraint FK_VehicleDeliveryService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_VehicleDeliveryService_User_UserID
            references [User],
    VehicleDeliveryOrganizationID      bigint
        constraint FK_VehicleDeliveryService_SupplyOrganization_VehicleDeliveryOrganizationID
            references SupplyOrganization,
    GrossPrice                         money            default 0.0                     not null,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Number                             nvarchar(max),
    IsSealAndSignatureVerified         bit              default 0                       not null,
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_VehicleDeliveryService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_VehicleDeliveryService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_VehicleDeliveryService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_VehicleDeliveryService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_VehicleDeliveryService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_VehicleDeliveryService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_VehicleDeliveryService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create table SupplyOrder
(
    ID                          bigint identity
        constraint PK_SupplyOrder
            primary key
                with (fillfactor = 60),
    NetPrice                    money                                            not null,
    ClientID                    bigint                                           not null
        constraint FK_SupplyOrder_Client_ClientID
            references Client,
    Created                     datetime2        default getutcdate()            not null,
    Deleted                     bit              default 0                       not null,
    NetUID                      uniqueidentifier default newid()                 not null,
    OrganizationID              bigint                                           not null
        constraint FK_SupplyOrder_Organization_OrganizationID
            references Organization,
    Qty                         float                                            not null,
    SupplyOrderNumberID         bigint                                           not null
        constraint FK_SupplyOrder_SupplyOrderNumber_SupplyOrderNumberID
            references SupplyOrderNumber
            on delete cascade,
    SupplyProFormID             bigint
        constraint FK_SupplyOrder_SupplyProForm_SupplyProFormID
            references SupplyProForm,
    Updated                     datetime2                                        not null,
    DateFrom                    datetime2,
    PortWorkServiceID           bigint
        constraint FK_SupplyOrder_PortWorkService_PortWorkServiceID
            references PortWorkService,
    TransportationServiceID     bigint
        constraint FK_SupplyOrder_TransportationService_TransportationServiceID
            references TransportationService,
    GrossPrice                  money            default 0.0                     not null,
    CustomAgencyServiceID       bigint
        constraint FK_SupplyOrder_CustomAgencyService_CustomAgencyServiceID
            references CustomAgencyService,
    PortCustomAgencyServiceID   bigint
        constraint FK_SupplyOrder_PortCustomAgencyService_PortCustomAgencyServiceID
            references PortCustomAgencyService,
    PlaneDeliveryServiceID      bigint
        constraint FK_SupplyOrder_PlaneDeliveryService_PlaneDeliveryServiceID
            references PlaneDeliveryService,
    VehicleDeliveryServiceID    bigint
        constraint FK_SupplyOrder_VehicleDeliveryService_VehicleDeliveryServiceID
            references VehicleDeliveryService,
    TransportationType          int              default 0                       not null,
    IsDocumentSet               bit              default 0                       not null,
    IsCompleted                 bit              default 0                       not null,
    IsOrderShipped              bit              default 0                       not null,
    OrderShippedDate            datetime2,
    CompleteDate                datetime2,
    ShipArrived                 datetime2,
    PlaneArrived                datetime2,
    VechicalArrived             datetime2,
    IsOrderArrived              bit              default 0                       not null,
    OrderArrivedDate            datetime2,
    IsPlaced                    bit              default 0                       not null,
    Comment                     nvarchar(500),
    ClientAgreementID           bigint           default CONVERT([bigint], 0)    not null
        constraint FK_SupplyOrder_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    IsGrossPricesCalculated     bit              default 0                       not null,
    IsFullyPlaced               bit              default 0                       not null,
    IsPartiallyPlaced           bit              default 0                       not null,
    IsOrderInsidePoland         bit              default 0                       not null,
    AdditionalAmount            money                                            not null,
    AdditionalPercent           float            default 0.0000000000000000e+000 not null,
    AdditionalPaymentCurrencyID bigint
        constraint FK_SupplyOrder_Currency_AdditionalPaymentCurrencyID
            references Currency,
    AdditionalPaymentFromDate   datetime2,
    IsApproved                  bit              default 0                       not null,
    ResponsibleId               bigint
        constraint FK_SupplyOrder_User_ResponsibleId
            references [User]
)
go

create table CreditNoteDocument
(
    ID            bigint identity
        constraint PK_CreditNoteDocument
            primary key,
    Amount        money                                              not null,
    ContentType   nvarchar(max),
    Created       datetime2        default getutcdate()              not null,
    Deleted       bit              default 0                         not null,
    DocumentUrl   nvarchar(max),
    FileName      nvarchar(max),
    GeneratedName nvarchar(max),
    NetUID        uniqueidentifier default newid()                   not null,
    Updated       datetime2                                          not null,
    SupplyOrderID bigint           default 0                         not null
        constraint FK_CreditNoteDocument_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Comment       nvarchar(max),
    FromDate      datetime2        default '0001-01-01T00:00:00.000' not null,
    Number        nvarchar(max)
)
go

create index IX_CreditNoteDocument_SupplyOrderID
    on CreditNoteDocument (SupplyOrderID)
go

create table CustomService
(
    ID                                 bigint identity
        constraint PK_CustomService
            primary key
                with (fillfactor = 60),
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    SupplyOrderID                      bigint                                           not null
        constraint FK_CustomService_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    SupplyPaymentTaskID                bigint
        constraint FK_CustomService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                            datetime2                                        not null,
    UserID                             bigint
        constraint FK_CustomService_User_UserID
            references [User],
    CustomOrganizationID               bigint
        constraint FK_CustomService_SupplyOrganization_CustomOrganizationID
            references SupplyOrganization,
    GrossPrice                         money            default 0.0                     not null,
    FromDate                           datetime2,
    Number                             nvarchar(max),
    SupplyCustomType                   int              default 0                       not null,
    ExciseDutyOrganizationID           bigint
        constraint FK_CustomService_SupplyOrganization_ExciseDutyOrganizationID
            references SupplyOrganization,
    NetPrice                           money            default 0.0                     not null,
    Vat                                money            default 0.0                     not null,
    Name                               nvarchar(max),
    VatPercent                         float            default 0.0000000000000000e+000 not null,
    ServiceNumber                      nvarchar(50),
    SupplyOrganizationAgreementID      bigint           default 0                       not null
        constraint FK_CustomService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_CustomService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_CustomService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_CustomService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_CustomService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_CustomService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_CustomService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create index IX_CustomService_SupplyOrderID
    on CustomService (SupplyOrderID)
go

create index IX_CustomService_SupplyPaymentTaskID
    on CustomService (SupplyPaymentTaskID)
go

create index IX_CustomService_UserID
    on CustomService (UserID)
go

create index IX_CustomService_CustomOrganizationID
    on CustomService (CustomOrganizationID)
go

create index IX_CustomService_ExciseDutyOrganizationID
    on CustomService (ExciseDutyOrganizationID)
go

create index IX_CustomService_SupplyOrganizationAgreementID
    on CustomService (SupplyOrganizationAgreementID)
go

create index IX_CustomService_AccountingPaymentTaskID
    on CustomService (AccountingPaymentTaskID)
go

create unique index IX_CustomService_SupplyInformationTaskID
    on CustomService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_CustomService_ActProvidingServiceDocumentID
    on CustomService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_CustomService_SupplyServiceAccountDocumentID
    on CustomService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_CustomService_AccountingActProvidingServiceId
    on CustomService (AccountingActProvidingServiceId)
go

create index IX_CustomService_ActProvidingServiceId
    on CustomService (ActProvidingServiceId)
go

create table MergedService
(
    ID                                 bigint identity
        constraint PK_MergedService
            primary key,
    NetUID                             uniqueidentifier default newid()                 not null,
    Created                            datetime2        default getutcdate()            not null,
    Updated                            datetime2                                        not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    FromDate                           datetime2,
    GrossPrice                         money                                            not null,
    NetPrice                           money                                            not null,
    Vat                                money                                            not null,
    VatPercent                         float                                            not null,
    Number                             nvarchar(50),
    ServiceNumber                      nvarchar(50),
    Name                               nvarchar(150),
    UserID                             bigint
        constraint FK_MergedService_User_UserID
            references [User],
    SupplyPaymentTaskID                bigint
        constraint FK_MergedService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    SupplyOrganizationAgreementID      bigint                                           not null
        constraint FK_MergedService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    SupplyOrganizationID               bigint                                           not null
        constraint FK_MergedService_SupplyOrganization_SupplyOrganizationID
            references SupplyOrganization,
    SupplyOrderID                      bigint
        constraint FK_MergedService_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    SupplyOrderUkraineID               bigint
        constraint FK_MergedService_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_MergedService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    DeliveryProductProtocolID          bigint
        constraint FK_MergedService_DeliveryProductProtocol_DeliveryProductProtocolID
            references DeliveryProductProtocol,
    IsCalculatedValue                  bit              default 0                       not null,
    IsAutoCalculatedValue              bit              default 0                       not null,
    SupplyExtraChargeType              int              default 0                       not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_MergedService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_MergedService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_MergedService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    ConsumableProductID                bigint
        constraint FK_MergedService_ConsumableProduct_ConsumableProductID
            references ConsumableProduct,
    AccountingActProvidingServiceID    bigint
        constraint FK_MergedService_ActProvidingService_AccountingActProvidingServiceID
            references ActProvidingService,
    ActProvidingServiceID              bigint
        constraint FK_MergedService_ActProvidingService_ActProvidingServiceID
            references ActProvidingService
)
go

create index IX_MergedService_SupplyOrganizationAgreementID
    on MergedService (SupplyOrganizationAgreementID)
go

create index IX_MergedService_SupplyOrganizationID
    on MergedService (SupplyOrganizationID)
go

create index IX_MergedService_SupplyPaymentTaskID
    on MergedService (SupplyPaymentTaskID)
go

create index IX_MergedService_UserID
    on MergedService (UserID)
go

create index IX_MergedService_SupplyOrderID
    on MergedService (SupplyOrderID)
go

create index IX_MergedService_SupplyOrderUkraineID
    on MergedService (SupplyOrderUkraineID)
go

create index IX_MergedService_AccountingPaymentTaskID
    on MergedService (AccountingPaymentTaskID)
go

create index IX_MergedService_DeliveryProductProtocolID
    on MergedService (DeliveryProductProtocolID)
go

create unique index IX_MergedService_SupplyInformationTaskID
    on MergedService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_MergedService_ActProvidingServiceDocumentID
    on MergedService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_MergedService_SupplyServiceAccountDocumentID
    on MergedService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_MergedService_ConsumableProductID
    on MergedService (ConsumableProductID)
go

create unique index IX_MergedService_AccountingActProvidingServiceID
    on MergedService (AccountingActProvidingServiceID)
    where [AccountingActProvidingServiceID] IS NOT NULL
go

create unique index IX_MergedService_ActProvidingServiceID
    on MergedService (ActProvidingServiceID)
    where [ActProvidingServiceID] IS NOT NULL
go

create table PackingListDocument
(
    ID            bigint identity
        constraint PK_PackingListDocument
            primary key,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    DocumentUrl   nvarchar(max),
    NetUID        uniqueidentifier default newid()      not null,
    SupplyOrderID bigint                                not null
        constraint FK_PackingListDocument_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated       datetime2                             not null,
    ContentType   nvarchar(max),
    FileName      nvarchar(max),
    GeneratedName nvarchar(max)
)
go

create index IX_PackingListDocument_SupplyOrderID
    on PackingListDocument (SupplyOrderID)
go

create table ResponsibilityDeliveryProtocol
(
    ID                bigint identity
        constraint PK_ResponsibilityDeliveryProtocol
            primary key,
    Created           datetime2        default getutcdate() not null,
    Deleted           bit              default 0            not null,
    NetUID            uniqueidentifier default newid()      not null,
    SupplyOrderID     bigint                                not null
        constraint FK_ResponsibilityDeliveryProtocol_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated           datetime2                             not null,
    SupplyOrderStatus int              default 0            not null,
    UserId            bigint           default 0            not null
        constraint FK_ResponsibilityDeliveryProtocol_User_UserId
            references [User]
)
go

create index IX_ResponsibilityDeliveryProtocol_SupplyOrderID
    on ResponsibilityDeliveryProtocol (SupplyOrderID)
    with (fillfactor = 60)
go

create index IX_ResponsibilityDeliveryProtocol_UserId
    on ResponsibilityDeliveryProtocol (UserId)
    with (fillfactor = 60)
go

create table SaleFutureReservation
(
    ID            bigint identity
        constraint PK_SaleFutureReservation
            primary key,
    ClientID      bigint                                not null
        constraint FK_SaleFutureReservation_Client_ClientID
            references Client,
    Count         float                                 not null,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    NetUID        uniqueidentifier default newid()      not null,
    ProductID     bigint                                not null
        constraint FK_SaleFutureReservation_Product_ProductID
            references Product,
    RemindDate    datetime2                             not null,
    SupplyOrderID bigint                                not null
        constraint FK_SaleFutureReservation_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated       datetime2                             not null
)
go

create index IX_SaleFutureReservation_ClientID
    on SaleFutureReservation (ClientID)
go

create index IX_SaleFutureReservation_ProductID
    on SaleFutureReservation (ProductID)
go

create index IX_SaleFutureReservation_SupplyOrderID
    on SaleFutureReservation (SupplyOrderID)
go

create table ServiceDetailItem
(
    ID                        bigint identity
        constraint PK_ServiceDetailItem
            primary key,
    Created                   datetime2        default getutcdate() not null,
    CustomAgencyServiceID     bigint
        constraint FK_ServiceDetailItem_CustomAgencyService_CustomAgencyServiceID
            references CustomAgencyService,
    CustomServiceID           bigint
        constraint FK_ServiceDetailItem_CustomService_CustomServiceID
            references CustomService,
    Deleted                   bit              default 0            not null,
    GrossPrice                decimal(18, 2)                        not null,
    NetPrice                  decimal(18, 2)                        not null,
    NetUID                    uniqueidentifier default newid()      not null,
    PlaneDeliveryServiceID    bigint
        constraint FK_ServiceDetailItem_PlaneDeliveryService_PlaneDeliveryServiceID
            references PlaneDeliveryService,
    PortCustomAgencyServiceID bigint
        constraint FK_ServiceDetailItem_PortCustomAgencyService_PortCustomAgencyServiceID
            references PortCustomAgencyService,
    PortWorkServiceID         bigint
        constraint FK_ServiceDetailItem_PortWorkService_PortWorkServiceID
            references PortWorkService,
    Qty                       float                                 not null,
    TransportationServiceID   bigint
        constraint FK_ServiceDetailItem_TransportationService_TransportationServiceID
            references TransportationService,
    UnitPrice                 decimal(18, 2)                        not null,
    Updated                   datetime2                             not null,
    Vat                       decimal(18, 2)                        not null,
    VatPercent                float                                 not null,
    VehicleDeliveryServiceID  bigint
        constraint FK_ServiceDetailItem_VehicleDeliveryService_VehicleDeliveryServiceID
            references VehicleDeliveryService,
    ServiceDetailItemKeyID    bigint           default 0            not null
        constraint FK_ServiceDetailItem_ServiceDetailItemKey_ServiceDetailItemKeyID
            references ServiceDetailItemKey,
    MergedServiceID           bigint
        constraint FK_ServiceDetailItem_MergedService_MergedServiceID
            references MergedService
)
go

create index IX_ServiceDetailItem_CustomAgencyServiceID
    on ServiceDetailItem (CustomAgencyServiceID)
go

create index IX_ServiceDetailItem_CustomServiceID
    on ServiceDetailItem (CustomServiceID)
go

create index IX_ServiceDetailItem_PlaneDeliveryServiceID
    on ServiceDetailItem (PlaneDeliveryServiceID)
go

create index IX_ServiceDetailItem_PortCustomAgencyServiceID
    on ServiceDetailItem (PortCustomAgencyServiceID)
go

create index IX_ServiceDetailItem_PortWorkServiceID
    on ServiceDetailItem (PortWorkServiceID)
go

create index IX_ServiceDetailItem_TransportationServiceID
    on ServiceDetailItem (TransportationServiceID)
go

create index IX_ServiceDetailItem_VehicleDeliveryServiceID
    on ServiceDetailItem (VehicleDeliveryServiceID)
go

create index IX_ServiceDetailItem_ServiceDetailItemKeyID
    on ServiceDetailItem (ServiceDetailItemKeyID)
go

create index IX_ServiceDetailItem_MergedServiceID
    on ServiceDetailItem (MergedServiceID)
go

create table SupplyInvoice
(
    ID                        bigint identity
        constraint PK_SupplyInvoice
            primary key
                with (fillfactor = 60),
    NetPrice                  money                                 not null,
    Created                   datetime2        default getutcdate() not null,
    Deleted                   bit              default 0            not null,
    NetUID                    uniqueidentifier default newid()      not null,
    Number                    nvarchar(100),
    Updated                   datetime2                             not null,
    IsShipped                 bit              default 0            not null,
    DateFrom                  datetime2,
    SupplyOrderID             bigint           default 0            not null
        constraint FK_SupplyInvoice_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    PaymentTo                 datetime2,
    ExtraCharge               money            default 0.0          not null,
    ServiceNumber             nvarchar(50),
    Comment                   nvarchar(500),
    IsFullyPlaced             bit              default 0            not null,
    IsPartiallyPlaced         bit              default 0            not null,
    DeliveryProductProtocolID bigint
        constraint FK_SupplyInvoice_DeliveryProductProtocol_DeliveryProductProtocolID
            references DeliveryProductProtocol,
    DateCustomDeclaration     datetime2,
    NumberCustomDeclaration   nvarchar(100),
    DeliveryAmount            money            default 0.0          not null,
    DiscountAmount            money            default 0.0          not null,
    RootSupplyInvoiceID       bigint
        constraint FK_SupplyInvoice_SupplyInvoice_RootSupplyInvoiceID
            references SupplyInvoice
)
go

create table ActReconciliation
(
    ID                   bigint identity
        constraint PK_ActReconciliation
            primary key
                with (fillfactor = 60),
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    FromDate             datetime2                             not null,
    Number               nvarchar(50),
    Comment              nvarchar(500),
    ResponsibleID        bigint                                not null
        constraint FK_ActReconciliation_User_ResponsibleID
            references [User],
    SupplyOrderUkraineID bigint
        constraint FK_ActReconciliation_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    SupplyInvoiceID      bigint
        constraint FK_ActReconciliation_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice
)
go

create index IX_ActReconciliation_ResponsibleID
    on ActReconciliation (ResponsibleID)
go

create index IX_ActReconciliation_SupplyOrderUkraineID
    on ActReconciliation (SupplyOrderUkraineID)
go

create index IX_ActReconciliation_SupplyInvoiceID
    on ActReconciliation (SupplyInvoiceID)
go

create table OrderProductSpecification
(
    ID                     bigint identity
        constraint PK_OrderProductSpecification
            primary key
                with (fillfactor = 60),
    NetUID                 uniqueidentifier default newid()      not null,
    Created                datetime2        default getutcdate() not null,
    Updated                datetime2                             not null,
    Deleted                bit              default 0            not null,
    Qty                    float                                 not null,
    SupplyInvoiceId        bigint
        constraint FK_OrderProductSpecification_SupplyInvoice_SupplyInvoiceId
            references SupplyInvoice,
    ProductSpecificationId bigint                                not null
        constraint FK_OrderProductSpecification_ProductSpecification_ProductSpecificationId
            references ProductSpecification,
    SadId                  bigint
        constraint FK_OrderProductSpecification_Sad_SadId
            references Sad,
    UnitPrice              decimal(18, 2)   default 0.0          not null
)
go

create index IX_OrderProductSpecification_ProductSpecificationId
    on OrderProductSpecification (ProductSpecificationId)
    with (fillfactor = 60)
go

create index IX_OrderProductSpecification_SupplyInvoiceId
    on OrderProductSpecification (SupplyInvoiceId)
    with (fillfactor = 60)
go

create index IX_OrderProductSpecification_SadId
    on OrderProductSpecification (SadId)
    with (fillfactor = 60)
go

create table SupplyInformationDeliveryProtocol
(
    ID                                     bigint identity
        constraint PK_SupplyInformationDeliveryProtocol
            primary key,
    Created                                datetime2        default getutcdate() not null,
    Deleted                                bit              default 0            not null,
    NetUID                                 uniqueidentifier default newid()      not null,
    SupplyOrderID                          bigint
        constraint FK_SupplyInformationDeliveryProtocol_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated                                datetime2                             not null,
    UserID                                 bigint                                not null
        constraint FK_SupplyInformationDeliveryProtocol_User_UserID
            references [User],
    SupplyInvoiceID                        bigint
        constraint FK_SupplyInformationDeliveryProtocol_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    Value                                  nvarchar(max),
    SupplyInformationDeliveryProtocolKeyID bigint           default 0            not null
        constraint FK_SupplyInformationDeliveryProtocol_SupplyInformationDeliveryProtocolKey_SupplyInformationDeliveryProtocolKeyID
            references SupplyInformationDeliveryProtocolKey
            on delete cascade,
    SupplyProFormID                        bigint
        constraint FK_SupplyInformationDeliveryProtocol_SupplyProForm_SupplyProFormID
            references SupplyProForm,
    IsDefault                              bit              default 0            not null
)
go

create index IX_SupplyInformationDeliveryProtocol_SupplyOrderID
    on SupplyInformationDeliveryProtocol (SupplyOrderID)
    with (fillfactor = 60)
go

create index IX_SupplyInformationDeliveryProtocol_SupplyProFormID
    on SupplyInformationDeliveryProtocol (SupplyProFormID)
    with (fillfactor = 60)
go

create index IX_SupplyInformationDeliveryProtocol_UserID
    on SupplyInformationDeliveryProtocol (UserID)
    with (fillfactor = 60)
go

create index IX_SupplyInformationDeliveryProtocol_SupplyInvoiceID
    on SupplyInformationDeliveryProtocol (SupplyInvoiceID)
    with (fillfactor = 60)
go

create index IX_SupplyInformationDeliveryProtocol_SupplyInformationDeliveryProtocolKeyID
    on SupplyInformationDeliveryProtocol (SupplyInformationDeliveryProtocolKeyID)
    with (fillfactor = 60)
go

create index IX_SupplyInvoice_SupplyOrderID
    on SupplyInvoice (SupplyOrderID)
    with (fillfactor = 60)
go

create index IX_SupplyInvoice_DeliveryProductProtocolID
    on SupplyInvoice (DeliveryProductProtocolID)
    with (fillfactor = 60)
go

create index IX_SupplyInvoice_RootSupplyInvoiceID
    on SupplyInvoice (RootSupplyInvoiceID)
go

create table SupplyInvoiceBillOfLadingService
(
    ID                    bigint identity
        constraint PK_SupplyInvoiceBillOfLadingService
            primary key,
    NetUID                uniqueidentifier default newid()      not null,
    Created               datetime2        default getutcdate() not null,
    Updated               datetime2                             not null,
    Deleted               bit              default 0            not null,
    SupplyInvoiceID       bigint                                not null
        constraint FK_SupplyInvoiceBillOfLadingService_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    BillOfLadingServiceID bigint                                not null
        constraint FK_SupplyInvoiceBillOfLadingService_BillOfLadingService_BillOfLadingServiceID
            references BillOfLadingService,
    AccountingValue       decimal(30, 14)                       not null,
    Value                 decimal(30, 14)                       not null,
    IsCalculatedValue     bit              default 0            not null
)
go

create index IX_SupplyInvoiceBillOfLadingService_BillOfLadingServiceID
    on SupplyInvoiceBillOfLadingService (BillOfLadingServiceID)
go

create index IX_SupplyInvoiceBillOfLadingService_SupplyInvoiceID
    on SupplyInvoiceBillOfLadingService (SupplyInvoiceID)
go

create table SupplyInvoiceDeliveryDocument
(
    ID                       bigint identity
        constraint PK_SupplyInvoiceDeliveryDocument
            primary key
                with (fillfactor = 60),
    NetUID                   uniqueidentifier default newid()      not null,
    Created                  datetime2        default getutcdate() not null,
    Updated                  datetime2                             not null,
    Deleted                  bit              default 0            not null,
    SupplyInvoiceID          bigint                                not null
        constraint FK_SupplyInvoiceDeliveryDocument_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    SupplyDeliveryDocumentID bigint                                not null
        constraint FK_SupplyInvoiceDeliveryDocument_SupplyDeliveryDocument_SupplyDeliveryDocumentID
            references SupplyDeliveryDocument,
    DocumentUrl              nvarchar(500),
    FileName                 nvarchar(500),
    GeneratedName            nvarchar(500),
    Number                   nvarchar(20),
    ContentType              nvarchar(500)
)
go

create index IX_SupplyInvoiceDeliveryDocument_SupplyDeliveryDocumentID
    on SupplyInvoiceDeliveryDocument (SupplyDeliveryDocumentID)
go

create index IX_SupplyInvoiceDeliveryDocument_SupplyInvoiceID
    on SupplyInvoiceDeliveryDocument (SupplyInvoiceID)
go

create table SupplyInvoiceMergedService
(
    ID                bigint identity
        constraint PK_SupplyInvoiceMergedService
            primary key
                with (fillfactor = 60),
    NetUID            uniqueidentifier default newid()      not null,
    Created           datetime2        default getutcdate() not null,
    Updated           datetime2                             not null,
    Deleted           bit              default 0            not null,
    SupplyInvoiceID   bigint                                not null
        constraint FK_SupplyInvoiceMergedService_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    MergedServiceID   bigint                                not null
        constraint FK_SupplyInvoiceMergedService_MergedService_MergedServiceID
            references MergedService,
    AccountingValue   decimal(30, 14)                       not null,
    Value             decimal(30, 14)                       not null,
    IsCalculatedValue bit              default 0            not null
)
go

create index IX_SupplyInvoiceMergedService_MergedServiceID
    on SupplyInvoiceMergedService (MergedServiceID)
go

create index IX_SupplyInvoiceMergedService_SupplyInvoiceID
    on SupplyInvoiceMergedService (SupplyInvoiceID)
go

create index IX_SupplyOrder_ClientID
    on SupplyOrder (ClientID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_OrganizationID
    on SupplyOrder (OrganizationID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_SupplyOrderNumberID
    on SupplyOrder (SupplyOrderNumberID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_SupplyProFormID
    on SupplyOrder (SupplyProFormID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_CustomAgencyServiceID
    on SupplyOrder (CustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_PortWorkServiceID
    on SupplyOrder (PortWorkServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_TransportationServiceID
    on SupplyOrder (TransportationServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_PortCustomAgencyServiceID
    on SupplyOrder (PortCustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_PlaneDeliveryServiceID
    on SupplyOrder (PlaneDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_VehicleDeliveryServiceID
    on SupplyOrder (VehicleDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_ClientAgreementID
    on SupplyOrder (ClientAgreementID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_AdditionalPaymentCurrencyID
    on SupplyOrder (AdditionalPaymentCurrencyID)
    with (fillfactor = 60)
go

create index IX_SupplyOrder_ResponsibleId
    on SupplyOrder (ResponsibleId)
go

create table SupplyOrderContainerService
(
    ID                 bigint identity
        constraint PK_SupplyOrderContainerService
            primary key,
    ContainerServiceID bigint                                not null
        constraint FK_SupplyOrderContainerService_ContainerService_ContainerServiceID
            references ContainerService,
    Created            datetime2        default getutcdate() not null,
    Deleted            bit              default 0            not null,
    NetUID             uniqueidentifier default newid()      not null,
    SupplyOrderID      bigint                                not null
        constraint FK_SupplyOrderContainerService_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated            datetime2                             not null
)
go

create index IX_SupplyOrderContainerService_ContainerServiceID
    on SupplyOrderContainerService (ContainerServiceID)
go

create index IX_SupplyOrderContainerService_SupplyOrderID
    on SupplyOrderContainerService (SupplyOrderID)
go

create table SupplyOrderDeliveryDocument
(
    ID                       bigint identity
        constraint PK_SupplyOrderDeliveryDocument
            primary key,
    Comment                  nvarchar(max),
    Created                  datetime2        default getutcdate() not null,
    Deleted                  bit              default 0            not null,
    IsReceived               bit              default 0            not null,
    NetUID                   uniqueidentifier default newid()      not null,
    ProcessedDate            datetime2                             not null,
    SupplyDeliveryDocumentID bigint                                not null
        constraint FK_SupplyOrderDeliveryDocument_SupplyDeliveryDocument_SupplyDeliveryDocumentID
            references SupplyDeliveryDocument,
    SupplyOrderID            bigint                                not null
        constraint FK_SupplyOrderDeliveryDocument_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    Updated                  datetime2                             not null,
    UserID                   bigint                                not null
        constraint FK_SupplyOrderDeliveryDocument_User_UserID
            references [User],
    IsProcessed              bit              default 0            not null,
    IsNotified               bit              default 0            not null,
    ContentType              nvarchar(max),
    DocumentUrl              nvarchar(max),
    FileName                 nvarchar(max),
    GeneratedName            nvarchar(max)
)
go

create index IX_SupplyOrderDeliveryDocument_SupplyOrderID
    on SupplyOrderDeliveryDocument (SupplyOrderID)
go

create index IX_SupplyOrderDeliveryDocument_UserID
    on SupplyOrderDeliveryDocument (UserID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderDeliveryDocument_SupplyDeliveryDocumentID
    on SupplyOrderDeliveryDocument (SupplyDeliveryDocumentID)
    with (fillfactor = 60)
go

create table SupplyOrderItem
(
    ID            bigint identity
        constraint PK_SupplyOrderItem
            primary key
                with (fillfactor = 60),
    Created       datetime2        default getutcdate()            not null,
    Deleted       bit              default 0                       not null,
    Description   nvarchar(max),
    ItemNo        nvarchar(max),
    NetUID        uniqueidentifier default newid()                 not null,
    ProductID     bigint                                           not null
        constraint FK_SupplyOrderItem_Product_ProductID
            references Product,
    Qty           float                                            not null,
    StockNo       nvarchar(max),
    SupplyOrderID bigint
        constraint FK_SupplyOrderItem_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    TotalAmount   money                                            not null,
    UnitPrice     money                                            not null,
    Updated       datetime2                                        not null,
    GrossWeight   float            default 0.0000000000000000e+000 not null,
    NetWeight     float            default 0.0000000000000000e+000 not null,
    IsPacked      bit              default 0                       not null
)
go

create table SupplyInvoiceOrderItem
(
    ID                bigint identity
        constraint PK_SupplyInvoiceOrderItem
            primary key
                with (fillfactor = 60),
    Created           datetime2        default getutcdate()         not null,
    Deleted           bit              default 0                    not null,
    NetUID            uniqueidentifier default newid()              not null,
    Qty               float                                         not null,
    SupplyInvoiceID   bigint                                        not null
        constraint FK_SupplyInvoiceOrderItem_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    SupplyOrderItemID bigint
        constraint FK_SupplyInvoiceOrderItem_SupplyOrderItem_SupplyOrderItemID
            references SupplyOrderItem,
    Updated           datetime2                                     not null,
    UnitPrice         money            default 0.0                  not null,
    RowNumber         int              default 0                    not null,
    ProductIsImported bit              default 0                    not null,
    ProductID         bigint           default CONVERT([bigint], 0) not null
        constraint FK_SupplyInvoiceOrderItem_Product_ProductID
            references Product
)
go

create index IX_SupplyInvoiceOrderItem_SupplyInvoiceID
    on SupplyInvoiceOrderItem (SupplyInvoiceID)
    with (fillfactor = 60)
go

create index IX_SupplyInvoiceOrderItem_SupplyOrderItemID
    on SupplyInvoiceOrderItem (SupplyOrderItemID)
    with (fillfactor = 60)
go

create index IX_SupplyInvoiceOrderItem_ProductID
    on SupplyInvoiceOrderItem (ProductID)
go

create index IX_SupplyOrderItem_ProductID
    on SupplyOrderItem (ProductID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderItem_SupplyOrderID
    on SupplyOrderItem (SupplyOrderID)
    with (fillfactor = 60)
go

create table SupplyOrderPaymentDeliveryProtocol
(
    ID                                      bigint identity
        constraint PK_SupplyOrderPaymentDeliveryProtocol
            primary key,
    Value                                   money                                            not null,
    Created                                 datetime2        default getutcdate()            not null,
    Deleted                                 bit              default 0                       not null,
    NetUID                                  uniqueidentifier default newid()                 not null,
    SupplyPaymentTaskID                     bigint
        constraint FK_SupplyOrderPaymentDeliveryProtocol_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                                 datetime2                                        not null,
    UserID                                  bigint                                           not null
        constraint FK_SupplyOrderPaymentDeliveryProtocol_User_UserID
            references [User],
    SupplyInvoiceID                         bigint
        constraint FK_SupplyOrderPaymentDeliveryProtocol_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    SupplyOrderPaymentDeliveryProtocolKeyID bigint           default 0                       not null
        constraint FK_SupplyOrderPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKey_SupplyOrderPaymentDeliveryProtocolKeyID
            references SupplyOrderPaymentDeliveryProtocolKey
            on delete cascade,
    SupplyProFormID                         bigint
        constraint FK_SupplyOrderPaymentDeliveryProtocol_SupplyProForm_SupplyProFormID
            references SupplyProForm,
    Discount                                float            default 0.0000000000000000e+000 not null,
    IsAccounting                            bit              default 0                       not null
)
go

create table PaymentDeliveryDocument
(
    ID                                   bigint identity
        constraint PK_PaymentDeliveryDocument
            primary key,
    ContentType                          nvarchar(max),
    Created                              datetime2        default getutcdate() not null,
    Deleted                              bit              default 0            not null,
    DocumentUrl                          nvarchar(max),
    FileName                             nvarchar(max),
    GeneratedName                        nvarchar(max),
    NetUID                               uniqueidentifier default newid()      not null,
    SupplyOrderPaymentDeliveryProtocolID bigint                                not null
        constraint FK_PaymentDeliveryDocument_SupplyOrderPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolID
            references SupplyOrderPaymentDeliveryProtocol,
    Updated                              datetime2                             not null
)
go

create index IX_PaymentDeliveryDocument_SupplyOrderPaymentDeliveryProtocolID
    on PaymentDeliveryDocument (SupplyOrderPaymentDeliveryProtocolID)
go

create index IX_SupplyOrderPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKeyID
    on SupplyOrderPaymentDeliveryProtocol (SupplyOrderPaymentDeliveryProtocolKeyID)
go

create index IX_SupplyOrderPaymentDeliveryProtocol_SupplyPaymentTaskID
    on SupplyOrderPaymentDeliveryProtocol (SupplyPaymentTaskID)
go

create index IX_SupplyOrderPaymentDeliveryProtocol_SupplyInvoiceID
    on SupplyOrderPaymentDeliveryProtocol (SupplyInvoiceID)
go

create index IX_SupplyOrderPaymentDeliveryProtocol_UserID
    on SupplyOrderPaymentDeliveryProtocol (UserID)
go

create index IX_SupplyOrderPaymentDeliveryProtocol_SupplyProFormID
    on SupplyOrderPaymentDeliveryProtocol (SupplyProFormID)
go

create table SupplyOrderPolandPaymentDeliveryProtocol
(
    ID                                      bigint identity
        constraint PK_SupplyOrderPolandPaymentDeliveryProtocol
            primary key,
    Created                                 datetime2        default getutcdate() not null,
    Deleted                                 bit              default 0            not null,
    FromDate                                datetime2                             not null,
    GrossPrice                              money                                 not null,
    Name                                    nvarchar(max),
    NetPrice                                money                                 not null,
    NetUID                                  uniqueidentifier default newid()      not null,
    Number                                  nvarchar(max),
    SupplyOrderID                           bigint                                not null
        constraint FK_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    SupplyOrderPaymentDeliveryProtocolKeyID bigint                                not null
        constraint FK_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKey_SupplyOrderPaymentDeliveryProtocolKeyID
            references SupplyOrderPaymentDeliveryProtocolKey
            on delete cascade,
    SupplyPaymentTaskID                     bigint                                not null
        constraint FK_SupplyOrderPolandPaymentDeliveryProtocol_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated                                 datetime2                             not null,
    UserID                                  bigint                                not null
        constraint FK_SupplyOrderPolandPaymentDeliveryProtocol_User_UserID
            references [User],
    Vat                                     money                                 not null,
    VatPercent                              float                                 not null,
    ServiceNumber                           nvarchar(50),
    IsAccounting                            bit              default 0            not null
)
go

create table OutcomePaymentOrder
(
    ID                                         bigint identity
        constraint PK_OutcomePaymentOrder
            primary key
                with (fillfactor = 60),
    Account                                    int                                              not null,
    Amount                                     money                                            not null,
    Comment                                    nvarchar(450),
    Created                                    datetime2        default getutcdate()            not null,
    Deleted                                    bit              default 0                       not null,
    FromDate                                   datetime2                                        not null,
    NetUID                                     uniqueidentifier default newid()                 not null,
    Number                                     nvarchar(50),
    OrganizationID                             bigint                                           not null
        constraint FK_OutcomePaymentOrder_Organization_OrganizationID
            references Organization,
    PaymentCurrencyRegisterID                  bigint                                           not null
        constraint FK_OutcomePaymentOrder_PaymentCurrencyRegister_PaymentCurrencyRegisterID
            references PaymentCurrencyRegister,
    Updated                                    datetime2                                        not null,
    UserID                                     bigint                                           not null
        constraint FK_OutcomePaymentOrder_User_UserID
            references [User],
    IsUnderReport                              bit              default 0                       not null,
    ColleagueID                                bigint
        constraint FK_OutcomePaymentOrder_User_ColleagueID
            references [User],
    IsUnderReportDone                          bit              default 0                       not null,
    AdvanceNumber                              nvarchar(50),
    ConsumableProductOrganizationID            bigint
        constraint FK_OutcomePaymentOrder_SupplyOrganization_ConsumableProductOrganizationID
            references SupplyOrganization,
    ExchangeRate                               money                                            not null,
    AfterExchangeAmount                        money            default 0.0                     not null,
    ClientAgreementID                          bigint
        constraint FK_OutcomePaymentOrder_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    SupplyOrderPolandPaymentDeliveryProtocolID bigint
        constraint FK_OutcomePaymentOrder_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderPolandPaymentDeliveryProtocolID
            references SupplyOrderPolandPaymentDeliveryProtocol,
    SupplyOrganizationAgreementID              bigint
        constraint FK_OutcomePaymentOrder_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    IsCanceled                                 bit              default 0                       not null,
    VAT                                        money            default 0.0                     not null,
    VatPercent                                 float            default 0.0000000000000000e+000 not null,
    OrganizationClientAgreementID              bigint
        constraint FK_OutcomePaymentOrder_OrganizationClientAgreement_OrganizationClientAgreementID
            references OrganizationClientAgreement,
    OrganizationClientID                       bigint
        constraint FK_OutcomePaymentOrder_OrganizationClient_OrganizationClientID
            references OrganizationClient,
    TaxFreeID                                  bigint
        constraint FK_OutcomePaymentOrder_TaxFree_TaxFreeID
            references TaxFree,
    SadID                                      bigint
        constraint FK_OutcomePaymentOrder_Sad_SadID
            references Sad,
    OperationType                              int              default 0                       not null,
    ClientID                                   bigint
        constraint FK_OutcomePaymentOrder_Client_ClientID
            references Client,
    CustomNumber                               nvarchar(50),
    PaymentPurpose                             nvarchar(500),
    EuroAmount                                 money            default 0.0                     not null,
    ArrivalNumber                              nvarchar(100),
    IsAccounting                               bit              default CONVERT([bit], 0)       not null,
    IsManagementAccounting                     bit              default CONVERT([bit], 0)       not null
)
go

create table AssignedPaymentOrder
(
    ID                            bigint identity
        constraint PK_AssignedPaymentOrder
            primary key,
    AssignedIncomePaymentOrderID  bigint
        constraint FK_AssignedPaymentOrder_IncomePaymentOrder_AssignedIncomePaymentOrderID
            references IncomePaymentOrder,
    AssignedOutcomePaymentOrderID bigint
        constraint FK_AssignedPaymentOrder_OutcomePaymentOrder_AssignedOutcomePaymentOrderID
            references OutcomePaymentOrder,
    Created                       datetime2        default getutcdate() not null,
    Deleted                       bit              default 0            not null,
    NetUID                        uniqueidentifier default newid()      not null,
    RootIncomePaymentOrderID      bigint
        constraint FK_AssignedPaymentOrder_IncomePaymentOrder_RootIncomePaymentOrderID
            references IncomePaymentOrder,
    RootOutcomePaymentOrderID     bigint
        constraint FK_AssignedPaymentOrder_OutcomePaymentOrder_RootOutcomePaymentOrderID
            references OutcomePaymentOrder,
    Updated                       datetime2                             not null
)
go

create unique index IX_AssignedPaymentOrder_AssignedIncomePaymentOrderID
    on AssignedPaymentOrder (AssignedIncomePaymentOrderID)
    where [AssignedIncomePaymentOrderID] IS NOT NULL
go

create unique index IX_AssignedPaymentOrder_AssignedOutcomePaymentOrderID
    on AssignedPaymentOrder (AssignedOutcomePaymentOrderID)
    where [AssignedOutcomePaymentOrderID] IS NOT NULL
go

create index IX_AssignedPaymentOrder_RootIncomePaymentOrderID
    on AssignedPaymentOrder (RootIncomePaymentOrderID)
go

create index IX_AssignedPaymentOrder_RootOutcomePaymentOrderID
    on AssignedPaymentOrder (RootOutcomePaymentOrderID)
go

create table CompanyCarFueling
(
    ID                              bigint identity
        constraint PK_CompanyCarFueling
            primary key,
    CompanyCarID                    bigint                                           not null
        constraint FK_CompanyCarFueling_CompanyCar_CompanyCarID
            references CompanyCar,
    Created                         datetime2        default getutcdate()            not null,
    Deleted                         bit              default 0                       not null,
    FuelAmount                      float                                            not null,
    NetUID                          uniqueidentifier default newid()                 not null,
    OutcomePaymentOrderID           bigint                                           not null
        constraint FK_CompanyCarFueling_OutcomePaymentOrder_OutcomePaymentOrderID
            references OutcomePaymentOrder,
    PricePerLiter                   money                                            not null,
    Updated                         datetime2                                        not null,
    ConsumableProductOrganizationID bigint           default 0                       not null
        constraint FK_CompanyCarFueling_SupplyOrganization_ConsumableProductOrganizationID
            references SupplyOrganization,
    TotalPrice                      money            default 0.0                     not null,
    VatAmount                       money            default 0.0                     not null,
    VatPercent                      float            default 0.0000000000000000e+000 not null,
    UserID                          bigint           default 0                       not null
        constraint FK_CompanyCarFueling_User_UserID
            references [User],
    TotalPriceWithVat               money            default 0.0                     not null,
    SupplyOrganizationAgreementID   bigint
        constraint FK_CompanyCarFueling_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement
)
go

create index IX_CompanyCarFueling_CompanyCarID
    on CompanyCarFueling (CompanyCarID)
go

create index IX_CompanyCarFueling_OutcomePaymentOrderID
    on CompanyCarFueling (OutcomePaymentOrderID)
go

create index IX_CompanyCarFueling_ConsumableProductOrganizationID
    on CompanyCarFueling (ConsumableProductOrganizationID)
go

create index IX_CompanyCarFueling_UserID
    on CompanyCarFueling (UserID)
go

create index IX_CompanyCarFueling_SupplyOrganizationAgreementID
    on CompanyCarFueling (SupplyOrganizationAgreementID)
go

create table CompanyCarRoadList
(
    ID                    bigint identity
        constraint PK_CompanyCarRoadList
            primary key,
    Comment               nvarchar(150),
    CompanyCarID          bigint                                           not null
        constraint FK_CompanyCarRoadList_CompanyCar_CompanyCarID
            references CompanyCar,
    Created               datetime2        default getutcdate()            not null,
    Deleted               bit              default 0                       not null,
    Mileage               bigint                                           not null,
    NetUID                uniqueidentifier default newid()                 not null,
    ResponsibleID         bigint                                           not null
        constraint FK_CompanyCarRoadList_User_ResponsibleID
            references [User],
    Updated               datetime2                                        not null,
    CreatedByID           bigint           default 0                       not null
        constraint FK_CompanyCarRoadList_User_CreatedByID
            references [User],
    UpdatedByID           bigint
        constraint FK_CompanyCarRoadList_User_UpdatedByID
            references [User],
    FuelAmount            float            default 0.0000000000000000e+000 not null,
    InCityKilometers      int              default 0                       not null,
    MixedModeKilometers   int              default 0                       not null,
    OutcomePaymentOrderID bigint
        constraint FK_CompanyCarRoadList_OutcomePaymentOrder_OutcomePaymentOrderID
            references OutcomePaymentOrder,
    OutsideCityKilometers int              default 0                       not null,
    TotalKilometers       int              default 0                       not null
)
go

create index IX_CompanyCarRoadList_CompanyCarID
    on CompanyCarRoadList (CompanyCarID)
go

create index IX_CompanyCarRoadList_ResponsibleID
    on CompanyCarRoadList (ResponsibleID)
go

create index IX_CompanyCarRoadList_CreatedByID
    on CompanyCarRoadList (CreatedByID)
go

create index IX_CompanyCarRoadList_UpdatedByID
    on CompanyCarRoadList (UpdatedByID)
go

create index IX_CompanyCarRoadList_OutcomePaymentOrderID
    on CompanyCarRoadList (OutcomePaymentOrderID)
go

create table CompanyCarRoadListDriver
(
    ID                   bigint identity
        constraint PK_CompanyCarRoadListDriver
            primary key,
    CompanyCarRoadListID bigint                                not null
        constraint FK_CompanyCarRoadListDriver_CompanyCarRoadList_CompanyCarRoadListID
            references CompanyCarRoadList,
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    NetUID               uniqueidentifier default newid()      not null,
    Updated              datetime2                             not null,
    UserID               bigint                                not null
        constraint FK_CompanyCarRoadListDriver_User_UserID
            references [User]
)
go

create index IX_CompanyCarRoadListDriver_CompanyCarRoadListID
    on CompanyCarRoadListDriver (CompanyCarRoadListID)
go

create index IX_CompanyCarRoadListDriver_UserID
    on CompanyCarRoadListDriver (UserID)
go

create index IX_OutcomePaymentOrder_OrganizationID
    on OutcomePaymentOrder (OrganizationID)
go

create index IX_OutcomePaymentOrder_PaymentCurrencyRegisterID
    on OutcomePaymentOrder (PaymentCurrencyRegisterID)
go

create index IX_OutcomePaymentOrder_UserID
    on OutcomePaymentOrder (UserID)
go

create index IX_OutcomePaymentOrder_ColleagueID
    on OutcomePaymentOrder (ColleagueID)
go

create index IX_OutcomePaymentOrder_ConsumableProductOrganizationID
    on OutcomePaymentOrder (ConsumableProductOrganizationID)
go

create index IX_OutcomePaymentOrder_SupplyOrganizationAgreementID
    on OutcomePaymentOrder (SupplyOrganizationAgreementID)
go

create index IX_OutcomePaymentOrder_ClientAgreementID
    on OutcomePaymentOrder (ClientAgreementID)
go

create index IX_OutcomePaymentOrder_SupplyOrderPolandPaymentDeliveryProtocolID
    on OutcomePaymentOrder (SupplyOrderPolandPaymentDeliveryProtocolID)
go

create index IX_OutcomePaymentOrder_OrganizationClientAgreementID
    on OutcomePaymentOrder (OrganizationClientAgreementID)
go

create index IX_OutcomePaymentOrder_OrganizationClientID
    on OutcomePaymentOrder (OrganizationClientID)
go

create index IX_OutcomePaymentOrder_TaxFreeID
    on OutcomePaymentOrder (TaxFreeID)
go

create index IX_OutcomePaymentOrder_SadID
    on OutcomePaymentOrder (SadID)
go

create index IX_OutcomePaymentOrder_ClientID
    on OutcomePaymentOrder (ClientID)
go

create table OutcomePaymentOrderConsumablesOrder
(
    ID                    bigint identity
        constraint PK_OutcomePaymentOrderConsumablesOrder
            primary key,
    ConsumablesOrderID    bigint                                not null
        constraint FK_OutcomePaymentOrderConsumablesOrder_ConsumablesOrder_ConsumablesOrderID
            references ConsumablesOrder,
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    OutcomePaymentOrderID bigint                                not null
        constraint FK_OutcomePaymentOrderConsumablesOrder_OutcomePaymentOrder_OutcomePaymentOrderID
            references OutcomePaymentOrder,
    Updated               datetime2                             not null
)
go

create index IX_OutcomePaymentOrderConsumablesOrder_ConsumablesOrderID
    on OutcomePaymentOrderConsumablesOrder (ConsumablesOrderID)
go

create index IX_OutcomePaymentOrderConsumablesOrder_OutcomePaymentOrderID
    on OutcomePaymentOrderConsumablesOrder (OutcomePaymentOrderID)
go

create table OutcomePaymentOrderSupplyPaymentTask
(
    ID                    bigint identity
        constraint PK_OutcomePaymentOrderSupplyPaymentTask
            primary key,
    Amount                money                                 not null,
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    OutcomePaymentOrderID bigint                                not null
        constraint FK_OutcomePaymentOrderSupplyPaymentTask_OutcomePaymentOrder_OutcomePaymentOrderID
            references OutcomePaymentOrder,
    SupplyPaymentTaskID   bigint                                not null
        constraint FK_OutcomePaymentOrderSupplyPaymentTask_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    Updated               datetime2                             not null
)
go

create index IX_OutcomePaymentOrderSupplyPaymentTask_OutcomePaymentOrderID
    on OutcomePaymentOrderSupplyPaymentTask (OutcomePaymentOrderID)
go

create index IX_OutcomePaymentOrderSupplyPaymentTask_SupplyPaymentTaskID
    on OutcomePaymentOrderSupplyPaymentTask (SupplyPaymentTaskID)
go

create table PaymentCostMovementOperation
(
    ID                               bigint identity
        constraint PK_PaymentCostMovementOperation
            primary key,
    ConsumablesOrderItemID           bigint
        constraint FK_PaymentCostMovementOperation_ConsumablesOrderItem_ConsumablesOrderItemID
            references ConsumablesOrderItem,
    Created                          datetime2        default getutcdate() not null,
    Deleted                          bit              default 0            not null,
    DepreciatedConsumableOrderItemID bigint
        constraint FK_PaymentCostMovementOperation_DepreciatedConsumableOrderItem_DepreciatedConsumableOrderItemID
            references DepreciatedConsumableOrderItem,
    NetUID                           uniqueidentifier default newid()      not null,
    PaymentCostMovementID            bigint                                not null
        constraint FK_PaymentCostMovementOperation_PaymentCostMovement_PaymentCostMovementID
            references PaymentCostMovement,
    Updated                          datetime2                             not null,
    CompanyCarFuelingID              bigint
        constraint FK_PaymentCostMovementOperation_CompanyCarFueling_CompanyCarFuelingID
            references CompanyCarFueling
)
go

create unique index IX_PaymentCostMovementOperation_ConsumablesOrderItemID
    on PaymentCostMovementOperation (ConsumablesOrderItemID)
    where [ConsumablesOrderItemID] IS NOT NULL
go

create unique index IX_PaymentCostMovementOperation_DepreciatedConsumableOrderItemID
    on PaymentCostMovementOperation (DepreciatedConsumableOrderItemID)
    where [DepreciatedConsumableOrderItemID] IS NOT NULL
go

create index IX_PaymentCostMovementOperation_PaymentCostMovementID
    on PaymentCostMovementOperation (PaymentCostMovementID)
go

create unique index IX_PaymentCostMovementOperation_CompanyCarFuelingID
    on PaymentCostMovementOperation (CompanyCarFuelingID)
    where [CompanyCarFuelingID] IS NOT NULL
go

create table PaymentMovementOperation
(
    ID                                bigint identity
        constraint PK_PaymentMovementOperation
            primary key
                with (fillfactor = 60),
    Created                           datetime2        default getutcdate() not null,
    Deleted                           bit              default 0            not null,
    IncomePaymentOrderID              bigint
        constraint FK_PaymentMovementOperation_IncomePaymentOrder_IncomePaymentOrderID
            references IncomePaymentOrder,
    NetUID                            uniqueidentifier default newid()      not null,
    PaymentMovementID                 bigint                                not null
        constraint FK_PaymentMovementOperation_PaymentMovement_PaymentMovementID
            references PaymentMovement,
    PaymentRegisterCurrencyExchangeID bigint
        constraint FK_PaymentMovementOperation_PaymentRegisterCurrencyExchange_PaymentRegisterCurrencyExchangeID
            references PaymentRegisterCurrencyExchange,
    PaymentRegisterTransferID         bigint
        constraint FK_PaymentMovementOperation_PaymentRegisterTransfer_PaymentRegisterTransferID
            references PaymentRegisterTransfer,
    Updated                           datetime2                             not null,
    OutcomePaymentOrderID             bigint
        constraint FK_PaymentMovementOperation_OutcomePaymentOrder_OutcomePaymentOrderID
            references OutcomePaymentOrder
)
go

create unique index IX_PaymentMovementOperation_IncomePaymentOrderID
    on PaymentMovementOperation (IncomePaymentOrderID)
    where [IncomePaymentOrderID] IS NOT NULL
go

create index IX_PaymentMovementOperation_PaymentMovementID
    on PaymentMovementOperation (PaymentMovementID)
go

create unique index IX_PaymentMovementOperation_PaymentRegisterCurrencyExchangeID
    on PaymentMovementOperation (PaymentRegisterCurrencyExchangeID)
    where [PaymentRegisterCurrencyExchangeID] IS NOT NULL
go

create unique index IX_PaymentMovementOperation_PaymentRegisterTransferID
    on PaymentMovementOperation (PaymentRegisterTransferID)
    where [PaymentRegisterTransferID] IS NOT NULL
go

create unique index IX_PaymentMovementOperation_OutcomePaymentOrderID
    on PaymentMovementOperation (OutcomePaymentOrderID)
    where [OutcomePaymentOrderID] IS NOT NULL
go

create index IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderID
    on SupplyOrderPolandPaymentDeliveryProtocol (SupplyOrderID)
go

create index IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderPaymentDeliveryProtocolKeyID
    on SupplyOrderPolandPaymentDeliveryProtocol (SupplyOrderPaymentDeliveryProtocolKeyID)
go

create index IX_SupplyOrderPolandPaymentDeliveryProtocol_SupplyPaymentTaskID
    on SupplyOrderPolandPaymentDeliveryProtocol (SupplyPaymentTaskID)
go

create index IX_SupplyOrderPolandPaymentDeliveryProtocol_UserID
    on SupplyOrderPolandPaymentDeliveryProtocol (UserID)
go

create index IX_VehicleDeliveryService_SupplyPaymentTaskID
    on VehicleDeliveryService (SupplyPaymentTaskID)
go

create index IX_VehicleDeliveryService_UserID
    on VehicleDeliveryService (UserID)
go

create index IX_VehicleDeliveryService_VehicleDeliveryOrganizationID
    on VehicleDeliveryService (VehicleDeliveryOrganizationID)
go

create index IX_VehicleDeliveryService_SupplyOrganizationAgreementID
    on VehicleDeliveryService (SupplyOrganizationAgreementID)
go

create index IX_VehicleDeliveryService_AccountingPaymentTaskID
    on VehicleDeliveryService (AccountingPaymentTaskID)
go

create unique index IX_VehicleDeliveryService_SupplyInformationTaskID
    on VehicleDeliveryService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_VehicleDeliveryService_ActProvidingServiceDocumentID
    on VehicleDeliveryService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_VehicleDeliveryService_SupplyServiceAccountDocumentID
    on VehicleDeliveryService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_VehicleDeliveryService_AccountingActProvidingServiceId
    on VehicleDeliveryService (AccountingActProvidingServiceId)
go

create index IX_VehicleDeliveryService_ActProvidingServiceId
    on VehicleDeliveryService (ActProvidingServiceId)
go

create table VehicleService
(
    ID                                 bigint identity
        constraint PK_VehicleService
            primary key
                with (fillfactor = 60),
    NetUID                             uniqueidentifier default newid()                 not null,
    Created                            datetime2        default getutcdate()            not null,
    Updated                            datetime2                                        not null,
    Deleted                            bit              default 0                       not null,
    IsActive                           bit                                              not null,
    FromDate                           datetime2,
    GrossPrice                         money                                            not null,
    NetPrice                           money                                            not null,
    Vat                                money                                            not null,
    VatPercent                         float                                            not null,
    Number                             nvarchar(max),
    ServiceNumber                      nvarchar(50),
    Name                               nvarchar(max),
    UserID                             bigint
        constraint FK_VehicleService_User_UserID
            references [User],
    SupplyPaymentTaskID                bigint
        constraint FK_VehicleService_SupplyPaymentTask_SupplyPaymentTaskID
            references SupplyPaymentTask,
    SupplyOrganizationAgreementID      bigint                                           not null
        constraint FK_VehicleService_SupplyOrganizationAgreement_SupplyOrganizationAgreementID
            references SupplyOrganizationAgreement,
    LoadDate                           datetime2                                        not null,
    GrossWeight                        float                                            not null,
    VehicleNumber                      nvarchar(max),
    TermDeliveryInDays                 nvarchar(max),
    BillOfLadingDocumentID             bigint
        constraint FK_VehicleService_BillOfLadingDocument_BillOfLadingDocumentID
            references BillOfLadingDocument,
    VehicleOrganizationID              bigint
        constraint FK_VehicleService_SupplyOrganization_VehicleOrganizationID
            references SupplyOrganization,
    IsCalculatedExtraCharge            bit                                              not null,
    SupplyExtraChargeType              int                                              not null,
    AccountingGrossPrice               money            default 0.0                     not null,
    AccountingNetPrice                 money            default 0.0                     not null,
    AccountingPaymentTaskID            bigint
        constraint FK_VehicleService_SupplyPaymentTask_AccountingPaymentTaskID
            references SupplyPaymentTask,
    AccountingVat                      money            default 0.0                     not null,
    AccountingVatPercent               float            default 0.0000000000000000e+000 not null,
    AccountingSupplyCostsWithinCountry money            default 0.0                     not null,
    SupplyInformationTaskID            bigint
        constraint FK_VehicleService_SupplyInformationTask_SupplyInformationTaskID
            references SupplyInformationTask,
    AccountingExchangeRate             money,
    ExchangeRate                       money,
    IsIncludeAccountingValue           bit              default 0                       not null,
    ActProvidingServiceDocumentID      bigint
        constraint FK_VehicleService_ActProvidingServiceDocument_ActProvidingServiceDocumentID
            references ActProvidingServiceDocument,
    SupplyServiceAccountDocumentID     bigint
        constraint FK_VehicleService_SupplyServiceAccountDocument_SupplyServiceAccountDocumentID
            references SupplyServiceAccountDocument,
    AccountingActProvidingServiceId    bigint
        constraint FK_VehicleService_ActProvidingService_AccountingActProvidingServiceId
            references ActProvidingService,
    ActProvidingServiceId              bigint
        constraint FK_VehicleService_ActProvidingService_ActProvidingServiceId
            references ActProvidingService
)
go

create table PackingList
(
    ID                    bigint identity
        constraint PK_PackingList
            primary key
                with (fillfactor = 60),
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    MarkNumber            nvarchar(100),
    NetUID                uniqueidentifier default newid()      not null,
    SupplyInvoiceID       bigint                                not null
        constraint FK_PackingList_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    Updated               datetime2                             not null,
    FromDate              datetime2        default getutcdate() not null,
    InvNo                 nvarchar(100),
    No                    nvarchar(100),
    PlNo                  nvarchar(100),
    RefNo                 nvarchar(100),
    IsDocumentsAdded      bit              default 0            not null,
    ContainerServiceID    bigint
        constraint FK_PackingList_ContainerService_ContainerServiceID
            references ContainerService,
    ExtraCharge           money            default 0.0          not null,
    Comment               nvarchar(500),
    IsPlaced              bit              default 0            not null,
    IsVatOneApplied       bit              default 0            not null,
    IsVatTwoApplied       bit              default 0            not null,
    VatOnePercent         decimal(18, 2)   default 0.0          not null,
    VatTwoPercent         decimal(18, 2)   default 0.0          not null,
    VehicleServiceId      bigint
        constraint FK_PackingList_VehicleService_VehicleServiceId
            references VehicleService,
    AccountingExtraCharge money            default 0.0          not null,
    RootPackingListID     bigint
        constraint FK_PackingList_PackingList_RootPackingListID
            references PackingList
)
go

create table DynamicProductPlacementColumn
(
    ID                   bigint identity
        constraint PK_DynamicProductPlacementColumn
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    FromDate             datetime2                             not null,
    SupplyOrderUkraineID bigint
        constraint FK_DynamicProductPlacementColumn_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    PackingListID        bigint
        constraint FK_DynamicProductPlacementColumn_PackingList_PackingListID
            references PackingList
)
go

create index IX_DynamicProductPlacementColumn_SupplyOrderUkraineID
    on DynamicProductPlacementColumn (SupplyOrderUkraineID)
go

create index IX_DynamicProductPlacementColumn_PackingListID
    on DynamicProductPlacementColumn (PackingListID)
    with (fillfactor = 60)
go

create table InvoiceDocument
(
    ID                                         bigint identity
        constraint PK_InvoiceDocument
            primary key
                with (fillfactor = 60),
    Created                                    datetime2        default getutcdate() not null,
    Deleted                                    bit              default 0            not null,
    DocumentUrl                                nvarchar(max),
    NetUID                                     uniqueidentifier default newid()      not null,
    SupplyInvoiceID                            bigint
        constraint FK_InvoiceDocument_SupplyInvoice_SupplyInvoiceID
            references SupplyInvoice,
    Updated                                    datetime2                             not null,
    ContentType                                nvarchar(max),
    FileName                                   nvarchar(max),
    GeneratedName                              nvarchar(max),
    PortWorkServiceID                          bigint
        constraint FK_InvoiceDocument_PortWorkService_PortWorkServiceID
            references PortWorkService,
    TransportationServiceID                    bigint
        constraint FK_InvoiceDocument_TransportationService_TransportationServiceID
            references TransportationService,
    ContainerServiceID                         bigint
        constraint FK_InvoiceDocument_ContainerService_ContainerServiceID
            references ContainerService,
    CustomServiceID                            bigint
        constraint FK_InvoiceDocument_CustomService_CustomServiceID
            references CustomService,
    CustomAgencyServiceID                      bigint
        constraint FK_InvoiceDocument_CustomAgencyService_CustomAgencyServiceID
            references CustomAgencyService,
    PlaneDeliveryServiceID                     bigint
        constraint FK_InvoiceDocument_PlaneDeliveryService_PlaneDeliveryServiceID
            references PlaneDeliveryService,
    PortCustomAgencyServiceID                  bigint
        constraint FK_InvoiceDocument_PortCustomAgencyService_PortCustomAgencyServiceID
            references PortCustomAgencyService,
    VehicleDeliveryServiceID                   bigint
        constraint FK_InvoiceDocument_VehicleDeliveryService_VehicleDeliveryServiceID
            references VehicleDeliveryService,
    SupplyOrderPolandPaymentDeliveryProtocolID bigint
        constraint FK_InvoiceDocument_SupplyOrderPolandPaymentDeliveryProtocol_SupplyOrderPolandPaymentDeliveryProtocolID
            references SupplyOrderPolandPaymentDeliveryProtocol,
    PackingListID                              bigint
        constraint FK_InvoiceDocument_PackingList_PackingListID
            references PackingList,
    MergedServiceID                            bigint
        constraint FK_InvoiceDocument_MergedService_MergedServiceID
            references MergedService,
    VehicleServiceId                           bigint
        constraint FK_InvoiceDocument_VehicleService_VehicleServiceId
            references VehicleService,
    Type                                       int              default 0            not null
)
go

create index IX_InvoiceDocument_SupplyInvoiceID
    on InvoiceDocument (SupplyInvoiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_PortWorkServiceID
    on InvoiceDocument (PortWorkServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_TransportationServiceID
    on InvoiceDocument (TransportationServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_ContainerServiceID
    on InvoiceDocument (ContainerServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_CustomServiceID
    on InvoiceDocument (CustomServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_CustomAgencyServiceID
    on InvoiceDocument (CustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_SupplyOrderPolandPaymentDeliveryProtocolID
    on InvoiceDocument (SupplyOrderPolandPaymentDeliveryProtocolID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_PlaneDeliveryServiceID
    on InvoiceDocument (PlaneDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_PortCustomAgencyServiceID
    on InvoiceDocument (PortCustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_VehicleDeliveryServiceID
    on InvoiceDocument (VehicleDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_PackingListID
    on InvoiceDocument (PackingListID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_MergedServiceID
    on InvoiceDocument (MergedServiceID)
    with (fillfactor = 60)
go

create index IX_InvoiceDocument_VehicleServiceId
    on InvoiceDocument (VehicleServiceId)
    with (fillfactor = 60)
go

create index IX_PackingList_SupplyInvoiceID
    on PackingList (SupplyInvoiceID)
    with (fillfactor = 60)
go

create index IX_PackingList_ContainerServiceID
    on PackingList (ContainerServiceID)
    with (fillfactor = 60)
go

create index IX_PackingList_VehicleServiceId
    on PackingList (VehicleServiceId)
    with (fillfactor = 60)
go

create index IX_PackingList_RootPackingListID
    on PackingList (RootPackingListID)
go

create table PackingListPackage
(
    ID            bigint identity
        constraint PK_PackingListPackage
            primary key,
    CBM           float                                 not null,
    Created       datetime2        default getutcdate() not null,
    Deleted       bit              default 0            not null,
    GrossWeight   float                                 not null,
    Height        int                                   not null,
    Lenght        int                                   not null,
    NetUID        uniqueidentifier default newid()      not null,
    NetWeight     float                                 not null,
    PackingListID bigint                                not null
        constraint FK_PackingListPackage_PackingList_PackingListID
            references PackingList,
    Type          int                                   not null,
    Updated       datetime2                             not null,
    Width         int                                   not null
)
go

create index IX_PackingListPackage_PackingListID
    on PackingListPackage (PackingListID)
go

create table PackingListPackageOrderItem
(
    ID                                 bigint identity
        constraint PK_PackingListPackageOrderItem
            primary key
                with (fillfactor = 60),
    Created                            datetime2        default getutcdate()            not null,
    Deleted                            bit              default 0                       not null,
    NetUID                             uniqueidentifier default newid()                 not null,
    PackingListID                      bigint
        constraint FK_PackingListPackageOrderItem_PackingList_PackingListID
            references PackingList,
    PackingListPackageID               bigint
        constraint FK_PackingListPackageOrderItem_PackingListPackage_PackingListPackageID
            references PackingListPackage,
    Qty                                float                                            not null,
    SupplyInvoiceOrderItemID           bigint                                           not null
        constraint FK_PackingListPackageOrderItem_SupplyInvoiceOrderItem_SupplyInvoiceOrderItemID
            references SupplyInvoiceOrderItem,
    Updated                            datetime2                                        not null,
    GrossWeight                        float            default 0.0000000000000000e+000 not null,
    IsErrorInPlaced                    bit              default 0                       not null,
    IsPlaced                           bit              default 0                       not null,
    IsReadyToPlaced                    bit              default 0                       not null,
    NetWeight                          float            default 0.0000000000000000e+000 not null,
    UnitPrice                          money            default 0.0                     not null,
    UploadedQty                        float            default 0.0000000000000000e+000 not null,
    Placement                          nvarchar(25),
    RemainingQty                       float            default 0.0000000000000000e+000 not null,
    UnitPriceEur                       money            default 0.0                     not null,
    GrossUnitPriceEur                  decimal(30, 14)                                  not null,
    ContainerUnitPriceEur              money            default 0.0                     not null,
    ExchangeRateAmount                 money            default 0.0                     not null,
    VatAmount                          money            default 0.0                     not null,
    VatPercent                         money            default 0.0                     not null,
    PlacedQty                          float            default 0.0000000000000000e+000 not null,
    AccountingGrossUnitPriceEur        decimal(30, 14)  default 0.0                     not null,
    AccountingContainerUnitPriceEur    money            default 0.0                     not null,
    AccountingGeneralGrossUnitPriceEur decimal(30, 14)  default 0.0                     not null,
    ExchangeRateAmountUahToEur         money            default 0.0                     not null,
    DeliveryPerItem                    decimal(30, 14)  default 0.0                     not null,
    ProductIsImported                  bit              default 0                       not null,
    UnitPriceEurWithVat                decimal(30, 14)  default 0.0                     not null
)
go

create index IX_PackingListPackageOrderItem_PackingListID
    on PackingListPackageOrderItem (PackingListID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItem_PackingListPackageID
    on PackingListPackageOrderItem (PackingListPackageID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItem_SupplyInvoiceOrderItemID
    on PackingListPackageOrderItem (SupplyInvoiceOrderItemID)
    with (fillfactor = 60)
go

create table PackingListPackageOrderItemSupplyService
(
    ID                            bigint identity
        constraint PK_PackingListPackageOrderItemSupplyService
            primary key
                with (fillfactor = 60),
    NetUID                        uniqueidentifier default newid()      not null,
    Created                       datetime2        default getutcdate() not null,
    Updated                       datetime2                             not null,
    Deleted                       bit              default 0            not null,
    NetValue                      decimal(30, 14)                       not null,
    Name                          nvarchar(250),
    ExchangeRateDate              datetime2        default getutcdate() not null,
    PackingListPackageOrderItemID bigint                                not null
        constraint FK_PackingListPackageOrderItemSupplyService_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem,
    CurrencyID                    bigint                                not null
        constraint FK_PackingListPackageOrderItemSupplyService_Currency_CurrencyID
            references Currency,
    BillOfLadingServiceID         bigint
        constraint FK_PackingListPackageOrderItemSupplyService_BillOfLadingService_BillOfLadingServiceID
            references BillOfLadingService,
    ContainerServiceID            bigint
        constraint FK_PackingListPackageOrderItemSupplyService_ContainerService_ContainerServiceID
            references ContainerService,
    CustomAgencyServiceID         bigint
        constraint FK_PackingListPackageOrderItemSupplyService_CustomAgencyService_CustomAgencyServiceID
            references CustomAgencyService,
    CustomServiceID               bigint
        constraint FK_PackingListPackageOrderItemSupplyService_CustomService_CustomServiceID
            references CustomService,
    MergedServiceID               bigint
        constraint FK_PackingListPackageOrderItemSupplyService_MergedService_MergedServiceID
            references MergedService,
    PlaneDeliveryServiceID        bigint
        constraint FK_PackingListPackageOrderItemSupplyService_PlaneDeliveryService_PlaneDeliveryServiceID
            references PlaneDeliveryService,
    PortCustomAgencyServiceID     bigint
        constraint FK_PackingListPackageOrderItemSupplyService_PortCustomAgencyService_PortCustomAgencyServiceID
            references PortCustomAgencyService,
    PortWorkServiceID             bigint
        constraint FK_PackingListPackageOrderItemSupplyService_PortWorkService_PortWorkServiceID
            references PortWorkService,
    TransportationServiceID       bigint
        constraint FK_PackingListPackageOrderItemSupplyService_TransportationService_TransportationServiceID
            references TransportationService,
    VehicleDeliveryServiceID      bigint
        constraint FK_PackingListPackageOrderItemSupplyService_VehicleDeliveryService_VehicleDeliveryServiceID
            references VehicleDeliveryService,
    VehicleServiceID              bigint
        constraint FK_PackingListPackageOrderItemSupplyService_VehicleService_VehicleServiceID
            references VehicleService,
    GeneralValue                  decimal(30, 14)                       not null,
    ManagementValue               decimal(30, 14)                       not null
)
go

create index IX_PackingListPackageOrderItemSupplyService_BillOfLadingServiceID
    on PackingListPackageOrderItemSupplyService (BillOfLadingServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_ContainerServiceID
    on PackingListPackageOrderItemSupplyService (ContainerServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_CurrencyID
    on PackingListPackageOrderItemSupplyService (CurrencyID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_CustomAgencyServiceID
    on PackingListPackageOrderItemSupplyService (CustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_CustomServiceID
    on PackingListPackageOrderItemSupplyService (CustomServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_MergedServiceID
    on PackingListPackageOrderItemSupplyService (MergedServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_PackingListPackageOrderItemID
    on PackingListPackageOrderItemSupplyService (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_PlaneDeliveryServiceID
    on PackingListPackageOrderItemSupplyService (PlaneDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_PortCustomAgencyServiceID
    on PackingListPackageOrderItemSupplyService (PortCustomAgencyServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_PortWorkServiceID
    on PackingListPackageOrderItemSupplyService (PortWorkServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_TransportationServiceID
    on PackingListPackageOrderItemSupplyService (TransportationServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_VehicleDeliveryServiceID
    on PackingListPackageOrderItemSupplyService (VehicleDeliveryServiceID)
    with (fillfactor = 60)
go

create index IX_PackingListPackageOrderItemSupplyService_VehicleServiceID
    on PackingListPackageOrderItemSupplyService (VehicleServiceID)
    with (fillfactor = 60)
go

create table SupplyOrderUkraineCartItem
(
    ID                            bigint identity
        constraint PK_SupplyOrderUkraineCartItem
            primary key,
    NetUID                        uniqueidentifier default newid()                       not null,
    Created                       datetime2        default getutcdate()                  not null,
    Updated                       datetime2                                              not null,
    Deleted                       bit              default 0                             not null,
    Comment                       nvarchar(500),
    UploadedQty                   float                                                  not null,
    ItemPriority                  int                                                    not null,
    ProductID                     bigint                                                 not null
        constraint FK_SupplyOrderUkraineCartItem_Product_ProductID
            references Product,
    CreatedByID                   bigint                                                 not null
        constraint FK_SupplyOrderUkraineCartItem_User_CreatedByID
            references [User],
    UpdatedByID                   bigint
        constraint FK_SupplyOrderUkraineCartItem_User_UpdatedByID
            references [User],
    ResponsibleID                 bigint
        constraint FK_SupplyOrderUkraineCartItem_User_ResponsibleID
            references [User],
    ReservedQty                   float            default 0.0000000000000000e+000       not null,
    FromDate                      datetime2        default '0001-01-01T00:00:00.0000000' not null,
    TaxFreePackListID             bigint
        constraint FK_SupplyOrderUkraineCartItem_TaxFreePackList_TaxFreePackListID
            references TaxFreePackList,
    UnpackedQty                   float            default 0.0000000000000000e+000       not null,
    NetWeight                     float            default 0.0000000000000000e+000       not null,
    UnitPrice                     money            default 0.0                           not null,
    SupplierID                    bigint
        constraint FK_SupplyOrderUkraineCartItem_Client_SupplierID
            references Client,
    PackingListPackageOrderItemID bigint
        constraint FK_SupplyOrderUkraineCartItem_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem,
    MaxQtyPerTF                   int              default 0                             not null,
    IsRecommended                 bit              default 0                             not null
)
go

create index IX_SupplyOrderUkraineCartItem_CreatedByID
    on SupplyOrderUkraineCartItem (CreatedByID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_ProductID
    on SupplyOrderUkraineCartItem (ProductID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_ResponsibleID
    on SupplyOrderUkraineCartItem (ResponsibleID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_UpdatedByID
    on SupplyOrderUkraineCartItem (UpdatedByID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_TaxFreePackListID
    on SupplyOrderUkraineCartItem (TaxFreePackListID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_SupplierID
    on SupplyOrderUkraineCartItem (SupplierID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItem_PackingListPackageOrderItemID
    on SupplyOrderUkraineCartItem (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create table SupplyOrderUkraineCartItemReservation
(
    ID                           bigint identity
        constraint PK_SupplyOrderUkraineCartItemReservation
            primary key,
    NetUID                       uniqueidentifier default newid()      not null,
    Created                      datetime2        default getutcdate() not null,
    Updated                      datetime2                             not null,
    Deleted                      bit              default 0            not null,
    Qty                          float                                 not null,
    ProductAvailabilityID        bigint                                not null
        constraint FK_SupplyOrderUkraineCartItemReservation_ProductAvailability_ProductAvailabilityID
            references ProductAvailability,
    SupplyOrderUkraineCartItemID bigint                                not null
        constraint FK_SupplyOrderUkraineCartItemReservation_SupplyOrderUkraineCartItem_SupplyOrderUkraineCartItemID
            references SupplyOrderUkraineCartItem
            on delete cascade,
    ConsignmentItemID            bigint
        constraint FK_SupplyOrderUkraineCartItemReservation_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem
)
go

create index IX_SupplyOrderUkraineCartItemReservation_ProductAvailabilityID
    on SupplyOrderUkraineCartItemReservation (ProductAvailabilityID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItemReservation_SupplyOrderUkraineCartItemID
    on SupplyOrderUkraineCartItemReservation (SupplyOrderUkraineCartItemID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItemReservation_ConsignmentItemID
    on SupplyOrderUkraineCartItemReservation (ConsignmentItemID)
    with (fillfactor = 60)
go

create table SupplyOrderUkraineItem
(
    Created                       datetime2        default getutcdate()            not null,
    Deleted                       bit              default 0                       not null,
    ID                            bigint identity
        constraint PK_SupplyOrderUkraineItem
            primary key
                with (fillfactor = 60),
    NetUID                        uniqueidentifier default newid()                 not null,
    Updated                       datetime2                                        not null,
    IsFullyPlaced                 bit                                              not null,
    Qty                           float                                            not null,
    PlacedQty                     float                                            not null,
    NetWeight                     float                                            not null,
    UnitPrice                     decimal(30, 14)                                  not null,
    ProductID                     bigint                                           not null
        constraint FK_SupplyOrderUkraineItem_Product_ProductID
            references Product,
    SupplyOrderUkraineID          bigint                                           not null
        constraint FK_SupplyOrderUkraineItem_SupplyOrderUkraine_SupplyOrderUkraineID
            references SupplyOrderUkraine,
    RemainingQty                  float            default 0.0000000000000000e+000 not null,
    NotOrdered                    bit              default 0                       not null,
    SupplierID                    bigint
        constraint FK_SupplyOrderUkraineItem_Client_SupplierID
            references Client,
    GrossUnitPrice                decimal(30, 14)                                  not null,
    GrossUnitPriceLocal           decimal(30, 14)                                  not null,
    UnitPriceLocal                decimal(30, 14)                                  not null,
    PackingListPackageOrderItemID bigint
        constraint FK_SupplyOrderUkraineItem_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem,
    ExchangeRateAmount            decimal(18, 2)   default 0.0                     not null,
    ConsignmentItemID             bigint
        constraint FK_SupplyOrderUkraineItem_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem,
    AccountingGrossUnitPrice      decimal(30, 14)  default 0.0                     not null,
    GrossWeight                   float            default 0.0000000000000000e+000 not null,
    ProductSpecificationID        bigint
        constraint FK_SupplyOrderUkraineItem_ProductSpecification_ProductSpecificationID
            references ProductSpecification,
    VatPercent                    money            default 0.0                     not null,
    VatAmount                     decimal(30, 14)                                  not null,
    VatAmountLocal                decimal(30, 14)                                  not null,
    AccountingGrossUnitPriceLocal decimal(30, 14)  default 0.0                     not null,
    UnitDeliveryAmountLocal       decimal(30, 14)  default 0.0                     not null,
    UnitDeliveryAmount            decimal(30, 14)  default 0.0                     not null,
    ProductIsImported             bit              default 0                       not null
)
go

create table ActReconciliationItem
(
    ID                       bigint identity
        constraint PK_ActReconciliationItem
            primary key
                with (fillfactor = 60),
    NetUID                   uniqueidentifier default newid()                 not null,
    Created                  datetime2        default getutcdate()            not null,
    Updated                  datetime2                                        not null,
    Deleted                  bit              default 0                       not null,
    HasDifference            bit                                              not null,
    NegativeDifference       bit                                              not null,
    OrderedQty               float                                            not null,
    ActualQty                float                                            not null,
    QtyDifference            float                                            not null,
    CommentUA                nvarchar(500),
    CommentPL                nvarchar(500),
    ProductID                bigint                                           not null
        constraint FK_ActReconciliationItem_Product_ProductID
            references Product,
    ActReconciliationID      bigint                                           not null
        constraint FK_ActReconciliationItem_ActReconciliation_ActReconciliationID
            references ActReconciliation,
    NetWeight                float            default 0.0000000000000000e+000 not null,
    UnitPrice                money            default 0.0                     not null,
    SupplyOrderUkraineItemID bigint
        constraint FK_ActReconciliationItem_SupplyOrderUkraineItem_SupplyOrderUkraineItemID
            references SupplyOrderUkraineItem,
    SupplyInvoiceOrderItemID bigint
        constraint FK_ActReconciliationItem_SupplyInvoiceOrderItem_SupplyInvoiceOrderItemID
            references SupplyInvoiceOrderItem
)
go

create index IX_ActReconciliationItem_ActReconciliationID
    on ActReconciliationItem (ActReconciliationID)
    with (fillfactor = 60)
go

create index IX_ActReconciliationItem_ProductID
    on ActReconciliationItem (ProductID)
    with (fillfactor = 60)
go

create index IX_ActReconciliationItem_SupplyOrderUkraineItemID
    on ActReconciliationItem (SupplyOrderUkraineItemID)
    with (fillfactor = 60)
go

create index IX_ActReconciliationItem_SupplyInvoiceOrderItemID
    on ActReconciliationItem (SupplyInvoiceOrderItemID)
    with (fillfactor = 60)
go

create table DepreciatedOrderItem
(
    ID                      bigint identity
        constraint PK_DepreciatedOrderItem
            primary key,
    NetUID                  uniqueidentifier default newid()      not null,
    Created                 datetime2        default getutcdate() not null,
    Updated                 datetime2                             not null,
    Deleted                 bit              default 0            not null,
    Qty                     float                                 not null,
    Reason                  nvarchar(150),
    ProductID               bigint                                not null
        constraint FK_DepreciatedOrderItem_Product_ProductID
            references Product,
    DepreciatedOrderID      bigint                                not null
        constraint FK_DepreciatedOrderItem_DepreciatedOrder_DepreciatedOrderID
            references DepreciatedOrder,
    ActReconciliationItemID bigint
        constraint FK_DepreciatedOrderItem_ActReconciliationItem_ActReconciliationItemID
            references ActReconciliationItem
)
go

create index IX_DepreciatedOrderItem_DepreciatedOrderID
    on DepreciatedOrderItem (DepreciatedOrderID)
go

create index IX_DepreciatedOrderItem_ProductID
    on DepreciatedOrderItem (ProductID)
go

create index IX_DepreciatedOrderItem_ActReconciliationItemID
    on DepreciatedOrderItem (ActReconciliationItemID)
go

create table DynamicProductPlacementRow
(
    ID                              bigint identity
        constraint PK_DynamicProductPlacementRow
            primary key
                with (fillfactor = 60),
    NetUID                          uniqueidentifier default newid()                 not null,
    Created                         datetime2        default getutcdate()            not null,
    Updated                         datetime2                                        not null,
    Deleted                         bit              default 0                       not null,
    SupplyOrderUkraineItemID        bigint
        constraint FK_DynamicProductPlacementRow_SupplyOrderUkraineItem_SupplyOrderUkraineItemID
            references SupplyOrderUkraineItem,
    DynamicProductPlacementColumnID bigint                                           not null
        constraint FK_DynamicProductPlacementRow_DynamicProductPlacementColumn_DynamicProductPlacementColumnID
            references DynamicProductPlacementColumn,
    Qty                             float            default 0.0000000000000000e+000 not null,
    PackingListPackageOrderItemID   bigint
        constraint FK_DynamicProductPlacementRow_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem
)
go

create table DynamicProductPlacement
(
    ID                           bigint identity
        constraint PK_DynamicProductPlacement
            primary key
                with (fillfactor = 60),
    NetUID                       uniqueidentifier default newid()      not null,
    Created                      datetime2        default getutcdate() not null,
    Updated                      datetime2                             not null,
    Deleted                      bit              default 0            not null,
    IsApplied                    bit              default 0            not null,
    Qty                          float                                 not null,
    StorageNumber                nvarchar(5),
    RowNumber                    nvarchar(5),
    CellNumber                   nvarchar(5),
    DynamicProductPlacementRowID bigint                                not null
        constraint FK_DynamicProductPlacement_DynamicProductPlacementRow_DynamicProductPlacementRowID
            references DynamicProductPlacementRow
)
go

create index IX_DynamicProductPlacement_DynamicProductPlacementRowID
    on DynamicProductPlacement (DynamicProductPlacementRowID)
    with (fillfactor = 60)
go

create index IX_DynamicProductPlacementRow_DynamicProductPlacementColumnID
    on DynamicProductPlacementRow (DynamicProductPlacementColumnID)
    with (fillfactor = 60)
go

create index IX_DynamicProductPlacementRow_SupplyOrderUkraineItemID
    on DynamicProductPlacementRow (SupplyOrderUkraineItemID)
    with (fillfactor = 60)
go

create index IX_DynamicProductPlacementRow_PackingListPackageOrderItemID
    on DynamicProductPlacementRow (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create table ProductTransferItem
(
    ID                      bigint identity
        constraint PK_ProductTransferItem
            primary key,
    NetUID                  uniqueidentifier default newid()      not null,
    Created                 datetime2        default getutcdate() not null,
    Updated                 datetime2                             not null,
    Deleted                 bit              default 0            not null,
    Qty                     float                                 not null,
    Reason                  nvarchar(150),
    ProductID               bigint                                not null
        constraint FK_ProductTransferItem_Product_ProductID
            references Product,
    ProductTransferID       bigint                                not null
        constraint FK_ProductTransferItem_ProductTransfer_ProductTransferID
            references ProductTransfer,
    ActReconciliationItemID bigint
        constraint FK_ProductTransferItem_ActReconciliationItem_ActReconciliationItemID
            references ActReconciliationItem
)
go

create index IX_ProductTransferItem_ActReconciliationItemID
    on ProductTransferItem (ActReconciliationItemID)
go

create index IX_ProductTransferItem_ProductID
    on ProductTransferItem (ProductID)
go

create index IX_ProductTransferItem_ProductTransferID
    on ProductTransferItem (ProductTransferID)
go

create index IX_SupplyOrderUkraineItem_ProductID
    on SupplyOrderUkraineItem (ProductID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineItem_SupplyOrderUkraineID
    on SupplyOrderUkraineItem (SupplyOrderUkraineID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineItem_SupplierID
    on SupplyOrderUkraineItem (SupplierID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineItem_PackingListPackageOrderItemID
    on SupplyOrderUkraineItem (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineItem_ConsignmentItemID
    on SupplyOrderUkraineItem (ConsignmentItemID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineItem_ProductSpecificationID
    on SupplyOrderUkraineItem (ProductSpecificationID)
    with (fillfactor = 60)
go

create table SupplyOrderVehicleService
(
    ID               bigint identity
        constraint PK_SupplyOrderVehicleService
            primary key
                with (fillfactor = 60),
    NetUID           uniqueidentifier default newid()      not null,
    Created          datetime2        default getutcdate() not null,
    Updated          datetime2                             not null,
    Deleted          bit              default 0            not null,
    SupplyOrderID    bigint                                not null
        constraint FK_SupplyOrderVehicleService_SupplyOrder_SupplyOrderID
            references SupplyOrder,
    VehicleServiceID bigint                                not null
        constraint FK_SupplyOrderVehicleService_VehicleService_VehicleServiceID
            references VehicleService
)
go

create index IX_SupplyOrderVehicleService_SupplyOrderID
    on SupplyOrderVehicleService (SupplyOrderID)
go

create index IX_SupplyOrderVehicleService_VehicleServiceID
    on SupplyOrderVehicleService (VehicleServiceID)
go

create index IX_VehicleService_BillOfLadingDocumentID
    on VehicleService (BillOfLadingDocumentID)
go

create index IX_VehicleService_SupplyOrganizationAgreementID
    on VehicleService (SupplyOrganizationAgreementID)
go

create index IX_VehicleService_SupplyPaymentTaskID
    on VehicleService (SupplyPaymentTaskID)
go

create index IX_VehicleService_UserID
    on VehicleService (UserID)
go

create index IX_VehicleService_VehicleOrganizationID
    on VehicleService (VehicleOrganizationID)
go

create index IX_VehicleService_AccountingPaymentTaskID
    on VehicleService (AccountingPaymentTaskID)
go

create unique index IX_VehicleService_SupplyInformationTaskID
    on VehicleService (SupplyInformationTaskID)
    where [SupplyInformationTaskID] IS NOT NULL
go

create unique index IX_VehicleService_ActProvidingServiceDocumentID
    on VehicleService (ActProvidingServiceDocumentID)
    where [ActProvidingServiceDocumentID] IS NOT NULL
go

create unique index IX_VehicleService_SupplyServiceAccountDocumentID
    on VehicleService (SupplyServiceAccountDocumentID)
    where [SupplyServiceAccountDocumentID] IS NOT NULL
go

create index IX_VehicleService_AccountingActProvidingServiceId
    on VehicleService (AccountingActProvidingServiceId)
go

create index IX_VehicleService_ActProvidingServiceId
    on VehicleService (ActProvidingServiceId)
go

create table Workplace
(
    ID            bigint identity
        constraint PK_Workplace
            primary key,
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    FirstName     nvarchar(150),
    MiddleName    nvarchar(150),
    LastName      nvarchar(150),
    Email         nvarchar(150),
    PhoneNumber   nvarchar(16),
    IsBlocked     bit                                   not null,
    MainClientID  bigint                                not null
        constraint FK_Workplace_Client_MainClientID
            references Client,
    ClientGroupID bigint
        constraint FK_Workplace_ClientGroup_ClientGroupID
            references ClientGroup,
    Abbreviation  nvarchar(max),
    Region        nvarchar(max)
)
go

create table ClientShoppingCart
(
    ID                               bigint identity
        constraint PK_ClientShoppingCart
            primary key,
    Created                          datetime2        default getutcdate()              not null,
    Deleted                          bit              default 0                         not null,
    NetUID                           uniqueidentifier default newid()                   not null,
    Updated                          datetime2                                          not null,
    ClientAgreementID                bigint           default 0                         not null
        constraint FK_ClientShoppingCart_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    ValidUntil                       datetime2        default '0001-01-01T00:00:00.000' not null,
    Number                           nvarchar(50),
    IsOfferProcessed                 bit              default 0                         not null,
    Comment                          nvarchar(450),
    OfferProcessingStatus            int              default 0                         not null,
    OfferProcessingStatusChangedByID bigint
        constraint FK_ClientShoppingCart_User_OfferProcessingStatusChangedByID
            references [User],
    IsOffer                          bit              default 0                         not null,
    CreatedByID                      bigint
        constraint FK_ClientShoppingCart_User_CreatedByID
            references [User],
    IsVatCart                        bit              default 0                         not null,
    WorkplaceID                      bigint
        constraint FK_ClientShoppingCart_Workplace_WorkplaceID
            references Workplace
)
go

create index IX_ClientShoppingCart_ClientAgreementID
    on ClientShoppingCart (ClientAgreementID)
go

create index IX_ClientShoppingCart_OfferProcessingStatusChangedByID
    on ClientShoppingCart (OfferProcessingStatusChangedByID)
go

create index IX_ClientShoppingCart_CreatedByID
    on ClientShoppingCart (CreatedByID)
go

create index IX_ClientShoppingCart_WorkplaceID
    on ClientShoppingCart (WorkplaceID)
go

create table [Order]
(
    ID                   bigint identity
        constraint PK_Order
            primary key
                with (fillfactor = 60),
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    NetUID               uniqueidentifier default newid()      not null,
    OrderSource          int                                   not null,
    Updated              datetime2                             not null,
    UserID               bigint
        constraint FK_Order_User_UserID
            references [User],
    ClientAgreementID    bigint           default 0            not null
        constraint FK_Order_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    OrderStatus          int              default 0            not null,
    IsMerged             bit              default 0            not null,
    ClientShoppingCartID bigint
        constraint FK_Order_ClientShoppingCart_ClientShoppingCartID
            references ClientShoppingCart
)
go

create index IX_Order_UserID
    on [Order] (UserID)
    with (fillfactor = 60)
go

create index IX_Order_ClientAgreementID
    on [Order] (ClientAgreementID)
    with (fillfactor = 60)
go

create index IX_Order_ClientShoppingCartID
    on [Order] (ClientShoppingCartID)
    with (fillfactor = 60)
go

create table OrderItem
(
    ID                               bigint identity
        constraint PK_OrderItem
            primary key
                with (fillfactor = 60),
    Created                          datetime2        default getutcdate()            not null,
    Deleted                          bit              default 0                       not null,
    NetUID                           uniqueidentifier default newid()                 not null,
    OrderID                          bigint
        constraint FK_OrderItem_Order_OrderID
            references [Order],
    ProductID                        bigint                                           not null
        constraint FK_OrderItem_Product_ProductID
            references Product
            on delete cascade,
    Updated                          datetime2                                        not null,
    Qty                              float                                            not null,
    UserId                           bigint
        constraint FK_OrderItem_User_UserId
            references [User],
    Comment                          nvarchar(450),
    IsValidForCurrentSale            bit              default 1                       not null,
    ClientShoppingCartID             bigint
        constraint FK_OrderItem_ClientShoppingCart_ClientShoppingCartID
            references ClientShoppingCart,
    PricePerItem                     decimal(30, 14)                                  not null,
    OneTimeDiscount                  money                                            not null,
    FromOfferQty                     float            default 0.0000000000000000e+000 not null,
    IsFromOffer                      bit              default 0                       not null,
    OrderedQty                       float            default 0.0000000000000000e+000 not null,
    ExchangeRateAmount               money            default 0.0                     not null,
    OfferProcessingStatus            int              default 0                       not null,
    OfferProcessingStatusChangedByID bigint
        constraint FK_OrderItem_User_OfferProcessingStatusChangedByID
            references [User],
    DiscountUpdatedByID              bigint
        constraint FK_OrderItem_User_DiscountUpdatedByID
            references [User],
    OneTimeDiscountComment           nvarchar(450),
    UnpackedQty                      float            default 0.0000000000000000e+000 not null,
    DiscountAmount                   money            default 0.0                     not null,
    PricePerItemWithoutVat           decimal(30, 14)                                  not null,
    ReturnedQty                      float            default 0.0000000000000000e+000 not null,
    AssignedSpecificationID          bigint
        constraint FK_OrderItem_ProductSpecification_AssignedSpecificationID
            references ProductSpecification,
    IsFromReSale                     bit              default 0                       not null,
    MisplacedSaleId                  bigint
        constraint FK_OrderItem_MisplacedSale_MisplacedSaleId
            references MisplacedSale,
    Vat                              decimal(30, 14)  default 0.0                     not null,
    InvoiceDocumentQty               float            default 0.0000000000000000e+000 not null,
    IsClosed                         bit              default CONVERT([bit], 0)       not null,
    StorageId                        bigint
        constraint FK_OrderItem_Storage_StorageId
            references Storage,
    IsFromShiftedItem                bit              default 0                       not null
)
go

create index IX_OrderItem_OrderID
    on OrderItem (OrderID)
    with (fillfactor = 60)
go

create index IX_OrderItem_ProductID
    on OrderItem (ProductID)
    with (fillfactor = 60)
go

create index IX_OrderItem_UserId
    on OrderItem (UserId)
    with (fillfactor = 60)
go

create index IX_OrderItem_ClientShoppingCartID
    on OrderItem (ClientShoppingCartID)
    with (fillfactor = 60)
go

create index IX_OrderItem_OfferProcessingStatusChangedByID
    on OrderItem (OfferProcessingStatusChangedByID)
    with (fillfactor = 60)
go

create index IX_OrderItem_DiscountUpdatedByID
    on OrderItem (DiscountUpdatedByID)
    with (fillfactor = 60)
go

create index IX_OrderItem_AssignedSpecificationID
    on OrderItem (AssignedSpecificationID)
    with (fillfactor = 60)
go

create index IX_OrderItem_MisplacedSaleId
    on OrderItem (MisplacedSaleId)
    with (fillfactor = 60)
go

create index IX_OrderItem_StorageId
    on OrderItem (StorageId)
go

create table OrderItemMerged
(
    ID             bigint identity
        constraint PK_OrderItemMerged
            primary key,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    NetUID         uniqueidentifier default newid()      not null,
    OldOrderID     bigint                                not null
        constraint FK_OrderItemMerged_Order_OldOrderID
            references [Order],
    OrderItemID    bigint                                not null
        constraint FK_OrderItemMerged_OrderItem_OrderItemID
            references OrderItem,
    Updated        datetime2                             not null,
    OldOrderItemID bigint           default 0            not null
        constraint FK_OrderItemMerged_OrderItem_OldOrderItemID
            references OrderItem
)
go

create index IX_OrderItemMerged_OldOrderID
    on OrderItemMerged (OldOrderID)
go

create index IX_OrderItemMerged_OrderItemID
    on OrderItemMerged (OrderItemID)
go

create index IX_OrderItemMerged_OldOrderItemID
    on OrderItemMerged (OldOrderItemID)
go

create table OrderItemMovement
(
    ID           bigint identity
        constraint PK_OrderItemMovement
            primary key
                with (fillfactor = 60),
    Created      datetime2        default getutcdate() not null,
    Deleted      bit              default 0            not null,
    MovementType int                                   not null,
    NetUID       uniqueidentifier default newid()      not null,
    OrderItemID  bigint                                not null
        constraint FK_OrderItemMovement_OrderItem_OrderItemID
            references OrderItem
            on delete cascade,
    Qty          float                                 not null,
    Updated      datetime2                             not null,
    UserID       bigint                                not null
        constraint FK_OrderItemMovement_User_UserID
            references [User]
            on delete cascade
)
go

create index IX_OrderItemMovement_OrderItemID
    on OrderItemMovement (OrderItemID)
go

create index IX_OrderItemMovement_UserID
    on OrderItemMovement (UserID)
go

create table OrderPackage
(
    ID      bigint identity
        constraint PK_OrderPackage
            primary key,
    CBM     float                                 not null,
    Created datetime2        default getutcdate() not null,
    Deleted bit              default 0            not null,
    Height  int                                   not null,
    Lenght  int                                   not null,
    NetUID  uniqueidentifier default newid()      not null,
    OrderID bigint                                not null
        constraint FK_OrderPackage_Order_OrderID
            references [Order],
    Updated datetime2                             not null,
    Weight  float                                 not null,
    Width   int                                   not null
)
go

create index IX_OrderPackage_OrderID
    on OrderPackage (OrderID)
go

create table OrderPackageItem
(
    ID             bigint identity
        constraint PK_OrderPackageItem
            primary key,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    NetUID         uniqueidentifier default newid()      not null,
    OrderItemID    bigint                                not null
        constraint FK_OrderPackageItem_OrderItem_OrderItemID
            references OrderItem,
    OrderPackageID bigint                                not null
        constraint FK_OrderPackageItem_OrderPackage_OrderPackageID
            references OrderPackage,
    Qty            float                                 not null,
    Updated        datetime2                             not null
)
go

create index IX_OrderPackageItem_OrderItemID
    on OrderPackageItem (OrderItemID)
go

create index IX_OrderPackageItem_OrderPackageID
    on OrderPackageItem (OrderPackageID)
go

create table OrderPackageUser
(
    ID             bigint identity
        constraint PK_OrderPackageUser
            primary key,
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    NetUID         uniqueidentifier default newid()      not null,
    OrderPackageID bigint                                not null
        constraint FK_OrderPackageUser_OrderPackage_OrderPackageID
            references OrderPackage,
    Updated        datetime2                             not null,
    UserID         bigint                                not null
        constraint FK_OrderPackageUser_User_UserID
            references [User]
)
go

create index IX_OrderPackageUser_OrderPackageID
    on OrderPackageUser (OrderPackageID)
go

create index IX_OrderPackageUser_UserID
    on OrderPackageUser (UserID)
go

create table ProductReservation
(
    ID                    bigint identity
        constraint PK_ProductReservation
            primary key
                with (fillfactor = 60),
    Created               datetime2        default getutcdate() not null,
    Deleted               bit              default 0            not null,
    NetUID                uniqueidentifier default newid()      not null,
    OrderItemID           bigint                                not null
        constraint FK_ProductReservation_OrderItem_OrderItemID
            references OrderItem
            on delete cascade,
    ProductAvailabilityID bigint                                not null
        constraint FK_ProductReservation_ProductAvailability_ProductAvailabilityID
            references ProductAvailability
            on delete cascade,
    Qty                   float                                 not null,
    Updated               datetime2                             not null,
    ConsignmentItemID     bigint
        constraint FK_ProductReservation_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem,
    IsReSaleReservation   bit              default 0            not null
)
go

create index IX_ProductReservation_OrderItemID
    on ProductReservation (OrderItemID)
go

create index IX_ProductReservation_ProductAvailabilityID
    on ProductReservation (ProductAvailabilityID)
    with (fillfactor = 60)
go

create index IX_ProductReservation_ConsignmentItemID
    on ProductReservation (ConsignmentItemID)
go

create table ReSaleAvailability
(
    ID                     bigint identity
        constraint PK_ReSaleAvailability
            primary key
                with (fillfactor = 60),
    NetUID                 uniqueidentifier default newid()                 not null,
    Created                datetime2        default getutcdate()            not null,
    Updated                datetime2                                        not null,
    Deleted                bit              default 0                       not null,
    Qty                    float                                            not null,
    RemainingQty           float                                            not null,
    ConsignmentItemID      bigint                                           not null
        constraint FK_ReSaleAvailability_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem,
    ProductAvailabilityID  bigint                                           not null
        constraint FK_ReSaleAvailability_ProductAvailability_ProductAvailabilityID
            references ProductAvailability,
    OrderItemID            bigint
        constraint FK_ReSaleAvailability_OrderItem_OrderItemID
            references OrderItem,
    ProductTransferItemID  bigint
        constraint FK_ReSaleAvailability_ProductTransferItem_ProductTransferItemID
            references ProductTransferItem,
    DepreciatedOrderItemID bigint
        constraint FK_ReSaleAvailability_DepreciatedOrderItem_DepreciatedOrderItemID
            references DepreciatedOrderItem,
    ProductReservationID   bigint
        constraint FK_ReSaleAvailability_ProductReservation_ProductReservationID
            references ProductReservation,
    PricePerItem           decimal(30, 14)                                  not null,
    ExchangeRate           money                                            not null,
    SupplyReturnItemId     bigint
        constraint FK_ReSaleAvailability_SupplyReturnItem_SupplyReturnItemId
            references SupplyReturnItem,
    InvoiceQty             float            default 0.0000000000000000e+000 not null
)
go

create index IX_ReSaleAvailability_ConsignmentItemID
    on ReSaleAvailability (ConsignmentItemID)
go

create index IX_ReSaleAvailability_DepreciatedOrderItemID
    on ReSaleAvailability (DepreciatedOrderItemID)
go

create index IX_ReSaleAvailability_OrderItemID
    on ReSaleAvailability (OrderItemID)
go

create index IX_ReSaleAvailability_ProductAvailabilityID
    on ReSaleAvailability (ProductAvailabilityID)
go

create index IX_ReSaleAvailability_ProductReservationID
    on ReSaleAvailability (ProductReservationID)
go

create index IX_ReSaleAvailability_ProductTransferItemID
    on ReSaleAvailability (ProductTransferItemID)
go

create index IX_ReSaleAvailability_SupplyReturnItemId
    on ReSaleAvailability (SupplyReturnItemId)
go

create table ReSaleItem
(
    ID                   bigint identity
        constraint PK_ReSaleItem
            primary key,
    NetUID               uniqueidentifier default newid()              not null,
    Created              datetime2        default getutcdate()         not null,
    Updated              datetime2                                     not null,
    Deleted              bit              default 0                    not null,
    Qty                  float                                         not null,
    ReSaleAvailabilityID bigint
        constraint FK_ReSaleItem_ReSaleAvailability_ReSaleAvailabilityID
            references ReSaleAvailability,
    ReSaleID             bigint                                        not null
        constraint FK_ReSaleItem_ReSale_ReSaleID
            references ReSale,
    PricePerItem         decimal(30, 14)                               not null,
    ExchangeRate         money            default 0.0                  not null,
    ExtraCharge          decimal(18, 2)   default 0.0                  not null,
    ProductID            bigint           default CONVERT([bigint], 0) not null
        constraint FK_ReSaleItem_Product_ProductID
            references Product
)
go

create index IX_ReSaleItem_ReSaleID
    on ReSaleItem (ReSaleID)
go

create index IX_ReSaleItem_ReSaleAvailabilityID
    on ReSaleItem (ReSaleAvailabilityID)
go

create index IX_ReSaleItem_ProductID
    on ReSaleItem (ProductID)
go

create table SadItem
(
    ID                           bigint identity
        constraint PK_SadItem
            primary key
                with (fillfactor = 60),
    NetUID                       uniqueidentifier default newid()                 not null,
    Created                      datetime2        default getutcdate()            not null,
    Updated                      datetime2                                        not null,
    Deleted                      bit              default 0                       not null,
    Qty                          float                                            not null,
    Comment                      nvarchar(500),
    SadID                        bigint                                           not null
        constraint FK_SadItem_Sad_SadID
            references Sad,
    SupplyOrderUkraineCartItemID bigint
        constraint FK_SadItem_SupplyOrderUkraineCartItem_SupplyOrderUkraineCartItemID
            references SupplyOrderUkraineCartItem,
    OrderItemID                  bigint
        constraint FK_SadItem_OrderItem_OrderItemID
            references OrderItem,
    SupplierID                   bigint
        constraint FK_SadItem_Client_SupplierID
            references Client,
    NetWeight                    float            default 0.0000000000000000e+000 not null,
    UnitPrice                    money            default 0.0                     not null,
    UnpackedQty                  float            default 0.0000000000000000e+000 not null,
    ConsignmentItemID            bigint
        constraint FK_SadItem_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem
)
go

create index IX_SadItem_SadID
    on SadItem (SadID)
go

create index IX_SadItem_SupplyOrderUkraineCartItemID
    on SadItem (SupplyOrderUkraineCartItemID)
go

create index IX_SadItem_OrderItemID
    on SadItem (OrderItemID)
go

create index IX_SadItem_SupplierID
    on SadItem (SupplierID)
go

create index IX_SadItem_ConsignmentItemID
    on SadItem (ConsignmentItemID)
go

create table SadPalletItem
(
    ID          bigint identity
        constraint PK_SadPalletItem
            primary key,
    NetUID      uniqueidentifier default newid()      not null,
    Created     datetime2        default getutcdate() not null,
    Updated     datetime2                             not null,
    Deleted     bit              default 0            not null,
    Qty         float                                 not null,
    SadItemID   bigint                                not null
        constraint FK_SadPalletItem_SadItem_SadItemID
            references SadItem,
    SadPalletID bigint                                not null
        constraint FK_SadPalletItem_SadPallet_SadPalletID
            references SadPallet
)
go

create index IX_SadPalletItem_SadItemID
    on SadPalletItem (SadItemID)
go

create index IX_SadPalletItem_SadPalletID
    on SadPalletItem (SadPalletID)
go

create table Sale
(
    ID                         bigint identity
        constraint PK_Sale
            primary key
                with (fillfactor = 60),
    ClientAgreementID          bigint                                not null
        constraint FK_Sale_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    Created                    datetime2        default getutcdate() not null,
    Deleted                    bit              default 0            not null,
    NetUID                     uniqueidentifier default newid()      not null,
    OrderID                    bigint                                not null
        constraint FK_Sale_Order_OrderID
            references [Order],
    Updated                    datetime2                             not null,
    UserID                     bigint
        constraint FK_Sale_User_UserID
            references [User],
    BaseLifeCycleStatusID      bigint           default 0            not null
        constraint FK_Sale_BaseLifeCycleStatus_BaseLifeCycleStatusID
            references BaseLifeCycleStatus,
    BaseSalePaymentStatusID    bigint           default 0            not null
        constraint FK_Sale_BaseSalePaymentStatus_BaseSalePaymentStatusID
            references BaseSalePaymentStatus,
    Comment                    nvarchar(450),
    SaleNumberID               bigint
        constraint FK_Sale_SaleNumber_SaleNumberID
            references SaleNumber,
    DeliveryRecipientID        bigint
        constraint FK_Sale_DeliveryRecipient_DeliveryRecipientID
            references DeliveryRecipient,
    DeliveryRecipientAddressID bigint
        constraint FK_Sale_DeliveryRecipientAddress_DeliveryRecipientAddressID
            references DeliveryRecipientAddress,
    TransporterID              bigint
        constraint FK_Sale_Transporter_TransporterID
            references Transporter,
    ShiftStatusID              bigint
        constraint FK_Sale_SaleBaseShiftStatus_ShiftStatusID
            references SaleBaseShiftStatus,
    ParentNetId                uniqueidentifier,
    IsMerged                   bit              default 0            not null,
    SaleInvoiceDocumentID      bigint
        constraint FK_Sale_SaleInvoiceDocument_SaleInvoiceDocumentID
            references SaleInvoiceDocument,
    SaleInvoiceNumberID        bigint
        constraint FK_Sale_SaleInvoiceNumber_SaleInvoiceNumberID
            references SaleInvoiceNumber,
    ChangedToInvoice           datetime2,
    OneTimeDiscountComment     nvarchar(450),
    ChangedToInvoiceByID       bigint
        constraint FK_Sale_User_ChangedToInvoiceByID
            references [User],
    ShipmentDate               datetime2,
    CashOnDeliveryAmount       money                                 not null,
    HasDocuments               bit              default 0            not null,
    IsCashOnDelivery           bit              default 0            not null,
    IsPrinted                  bit              default 0            not null,
    TTN                        nvarchar(max),
    ShippingAmount             money            default 0.0          not null,
    TaxFreePackListID          bigint
        constraint FK_Sale_TaxFreePackList_TaxFreePackListID
            references TaxFreePackList,
    SadID                      bigint
        constraint FK_Sale_Sad_SadID
            references Sad,
    IsVatSale                  bit              default 0            not null,
    ShippingAmountEur          money            default 0.0          not null,
    ExpiredDays                float            default 0.00         not null,
    IsLocked                   bit              default 0            not null,
    IsPaymentBillDownloaded    bit              default 0            not null,
    IsImported                 bit              default 0            not null,
    IsPrintedPaymentInvoice    bit              default 0            not null,
    IsAcceptedToPacking        bit              default 0            not null,
    RetailClientId             bigint
        constraint FK_Sale_RetailClient_RetailClientId
            references RetailClient,
    IsFullPayment              bit              default 0            not null,
    MisplacedSaleId            bigint
        constraint FK_Sale_MisplacedSale_MisplacedSaleId
            references MisplacedSale,
    WorkplaceID                bigint
        constraint FK_Sale_Workplace_WorkplaceID
            references Workplace,
    UpdateUserID               bigint
        constraint FK_Sale_User_UpdateUserID
            references [User],
    CustomersOwnTtnID          bigint
        constraint FK_Sale_CustomersOwnTtn_CustomersOwnTtnID
            references CustomersOwnTtn,
    IsDevelopment              bit              default 0            not null,
    WarehousesShipmentId       bigint,
    IsPrintedActProtocolEdit   bit              default 0            not null,
    BillDownloadDate           datetime2
)
go

create table ClientInDebt
(
    ID          bigint identity
        constraint PK_ClientInDebt
            primary key
                with (fillfactor = 60),
    AgreementID bigint                                not null
        constraint FK_ClientInDebt_Agreement_AgreementID
            references Agreement,
    ClientID    bigint                                not null
        constraint FK_ClientInDebt_Client_ClientID
            references Client,
    Created     datetime2        default getutcdate() not null,
    DebtID      bigint                                not null
        constraint FK_ClientInDebt_Debt_DebtID
            references Debt,
    Deleted     bit              default 0            not null,
    NetUID      uniqueidentifier default newid()      not null,
    Updated     datetime2                             not null,
    SaleID      bigint
        constraint FK_ClientInDebt_Sale_SaleID
            references Sale,
    ReSaleID    bigint
        constraint FK_ClientInDebt_ReSale_ReSaleID
            references ReSale
)
go

create index IX_ClientInDebt_AgreementID
    on ClientInDebt (AgreementID)
    with (fillfactor = 60)
go

create index IX_ClientInDebt_ClientID
    on ClientInDebt (ClientID)
    with (fillfactor = 60)
go

create index IX_ClientInDebt_DebtID
    on ClientInDebt (DebtID)
    with (fillfactor = 60)
go

create index IX_ClientInDebt_SaleID
    on ClientInDebt (SaleID)
    with (fillfactor = 60)
go

create index IX_ClientInDebt_ReSaleID
    on ClientInDebt (ReSaleID)
    with (fillfactor = 60)
go

create table CountSaleMessage
(
    ID                     bigint identity
        constraint PK_CountSaleMessage
            primary key,
    NetUID                 uniqueidentifier default newid()      not null,
    Created                datetime2        default getutcdate() not null,
    Updated                datetime2                             not null,
    Deleted                bit              default 0            not null,
    SaleID                 bigint                                not null
        constraint FK_CountSaleMessage_Sale_SaleID
            references Sale
            on delete cascade,
    SaleMessageNumeratorID bigint                                not null
        constraint FK_CountSaleMessage_SaleMessageNumerator_SaleMessageNumeratorID
            references SaleMessageNumerator
            on delete cascade,
    Transfered             bit                                   not null
)
go

create index IX_CountSaleMessage_SaleID
    on CountSaleMessage (SaleID)
go

create index IX_CountSaleMessage_SaleMessageNumeratorID
    on CountSaleMessage (SaleMessageNumeratorID)
go

create table ExpiredBillUserNotification
(
    ID                   bigint identity
        constraint PK_ExpiredBillUserNotification
            primary key,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null,
    UserNotificationType int                                   not null,
    Locked               bit                                   not null,
    Processed            bit                                   not null,
    CreatedByID          bigint                                not null
        constraint FK_ExpiredBillUserNotification_User_CreatedByID
            references [User],
    LockedByID           bigint
        constraint FK_ExpiredBillUserNotification_User_LockedByID
            references [User],
    LastViewedByID       bigint
        constraint FK_ExpiredBillUserNotification_User_LastViewedByID
            references [User],
    ProcessedByID        bigint
        constraint FK_ExpiredBillUserNotification_User_ProcessedByID
            references [User],
    SaleNumber           nvarchar(50),
    FromClient           nvarchar(250),
    ExpiredDays          float                                 not null,
    Deferred             bit                                   not null,
    SaleID               bigint                                not null
        constraint FK_ExpiredBillUserNotification_Sale_SaleID
            references Sale,
    ManagerID            bigint
        constraint FK_ExpiredBillUserNotification_User_ManagerID
            references [User],
    AppliedAction        int              default 0            not null
)
go

create index IX_ExpiredBillUserNotification_CreatedByID
    on ExpiredBillUserNotification (CreatedByID)
go

create index IX_ExpiredBillUserNotification_LastViewedByID
    on ExpiredBillUserNotification (LastViewedByID)
go

create index IX_ExpiredBillUserNotification_LockedByID
    on ExpiredBillUserNotification (LockedByID)
go

create index IX_ExpiredBillUserNotification_ManagerID
    on ExpiredBillUserNotification (ManagerID)
go

create index IX_ExpiredBillUserNotification_ProcessedByID
    on ExpiredBillUserNotification (ProcessedByID)
go

create index IX_ExpiredBillUserNotification_SaleID
    on ExpiredBillUserNotification (SaleID)
go

create table HistoryInvoiceEdit
(
    ID            bigint identity
        constraint PK_HistoryInvoiceEdit
            primary key,
    SaleID        bigint                                not null
        constraint FK_HistoryInvoiceEdit_Sale_SaleID
            references Sale,
    NetUID        uniqueidentifier default newid()      not null,
    Created       datetime2        default getutcdate() not null,
    Updated       datetime2                             not null,
    Deleted       bit              default 0            not null,
    IsDevelopment bit              default 0            not null,
    ApproveUpdate bit              default 0            not null,
    IsPrinted     bit              default 0            not null
)
go

create index IX_HistoryInvoiceEdit_SaleID
    on HistoryInvoiceEdit (SaleID)
go

create table IncomePaymentOrderSale
(
    ID                   bigint identity
        constraint PK_IncomePaymentOrderSale
            primary key,
    Amount               money                                 not null,
    Created              datetime2        default getutcdate() not null,
    Deleted              bit              default 0            not null,
    IncomePaymentOrderID bigint                                not null
        constraint FK_IncomePaymentOrderSale_IncomePaymentOrder_IncomePaymentOrderID
            references IncomePaymentOrder,
    NetUID               uniqueidentifier default newid()      not null,
    SaleID               bigint
        constraint FK_IncomePaymentOrderSale_Sale_SaleID
            references Sale,
    Updated              datetime2                             not null,
    ExchangeRate         money            default 0.0          not null,
    OverpaidAmount       money            default 0.0          not null,
    ReSaleID             bigint
        constraint FK_IncomePaymentOrderSale_ReSale_ReSaleID
            references ReSale
)
go

create index IX_IncomePaymentOrderSale_IncomePaymentOrderID
    on IncomePaymentOrderSale (IncomePaymentOrderID)
go

create index IX_IncomePaymentOrderSale_SaleID
    on IncomePaymentOrderSale (SaleID)
go

create index IX_IncomePaymentOrderSale_ReSaleID
    on IncomePaymentOrderSale (ReSaleID)
go

create table OrderItemBaseShiftStatus
(
    ID                   bigint identity
        constraint PK_OrderItemBaseShiftStatus
            primary key,
    Comment              nvarchar(max),
    Created              datetime2        default getutcdate()            not null,
    Deleted              bit              default 0                       not null,
    NetUID               uniqueidentifier default newid()                 not null,
    ShiftStatus          int                                              not null,
    Updated              datetime2                                        not null,
    Qty                  float            default 0.0000000000000000e+000 not null,
    OrderItemID          bigint           default 0                       not null
        constraint FK_OrderItemBaseShiftStatus_OrderItem_OrderItemID
            references OrderItem,
    SaleID               bigint
        constraint FK_OrderItemBaseShiftStatus_Sale_SaleID
            references Sale,
    UserID               bigint           default 0                       not null
        constraint FK_OrderItemBaseShiftStatus_User_UserID
            references [User],
    CurrentQty           float            default 0.0000000000000000e+000 not null,
    HistoryInvoiceEditID bigint
        constraint FK_OrderItemBaseShiftStatus_HistoryInvoiceEdit_HistoryInvoiceEditID
            references HistoryInvoiceEdit
)
go

create index IX_OrderItemBaseShiftStatus_OrderItemID
    on OrderItemBaseShiftStatus (OrderItemID)
go

create index IX_OrderItemBaseShiftStatus_SaleID
    on OrderItemBaseShiftStatus (SaleID)
go

create index IX_OrderItemBaseShiftStatus_UserID
    on OrderItemBaseShiftStatus (UserID)
go

create index IX_OrderItemBaseShiftStatus_HistoryInvoiceEditID
    on OrderItemBaseShiftStatus (HistoryInvoiceEditID)
go

create table RetailClientPaymentImage
(
    ID                    bigint identity
        constraint PK_RetailClientPaymentImage
            primary key,
    NetUID                uniqueidentifier default newid()              not null,
    Created               datetime2        default getutcdate()         not null,
    Updated               datetime2                                     not null,
    Deleted               bit              default 0                    not null,
    RetailClientId        bigint                                        not null
        constraint FK_RetailClientPaymentImage_RetailClient_RetailClientId
            references RetailClient,
    SaleId                bigint           default CONVERT([bigint], 0) not null
        constraint FK_RetailClientPaymentImage_Sale_SaleId
            references Sale,
    RetailPaymentStatusId bigint                                        not null
        constraint FK_RetailClientPaymentImage_RetailPaymentStatus_RetailPaymentStatusId
            references RetailPaymentStatus
            on delete cascade
)
go

create index IX_RetailClientPaymentImage_RetailClientId
    on RetailClientPaymentImage (RetailClientId)
go

create index IX_RetailClientPaymentImage_SaleId
    on RetailClientPaymentImage (SaleId)
go

create index IX_RetailClientPaymentImage_RetailPaymentStatusId
    on RetailClientPaymentImage (RetailPaymentStatusId)
go

create table RetailClientPaymentImageItem
(
    ID                         bigint identity
        constraint PK_RetailClientPaymentImageItem
            primary key
                with (fillfactor = 60),
    NetUID                     uniqueidentifier default newid()      not null,
    Created                    datetime2        default getutcdate() not null,
    Updated                    datetime2                             not null,
    Deleted                    bit              default 0            not null,
    ImgUrl                     nvarchar(1000),
    Amount                     money                                 not null,
    UserID                     bigint
        constraint FK_RetailClientPaymentImageItem_User_UserID
            references [User],
    RetailClientPaymentImageID bigint                                not null
        constraint FK_RetailClientPaymentImageItem_RetailClientPaymentImage_RetailClientPaymentImageID
            references RetailClientPaymentImage,
    PaymentType                int              default 0            not null,
    Comment                    nvarchar(500),
    IsLocked                   bit              default 0            not null
)
go

create index IX_RetailClientPaymentImageItem_RetailClientPaymentImageID
    on RetailClientPaymentImageItem (RetailClientPaymentImageID)
go

create index IX_RetailClientPaymentImageItem_UserID
    on RetailClientPaymentImageItem (UserID)
go

create index IX_Sale_ClientAgreementID
    on Sale (ClientAgreementID)
    with (fillfactor = 60)
go

create index IX_Sale_OrderID
    on Sale (OrderID)
    with (fillfactor = 60)
go

create index IX_Sale_UserID
    on Sale (UserID)
    with (fillfactor = 60)
go

create index IX_Sale_BaseLifeCycleStatusID
    on Sale (BaseLifeCycleStatusID)
    with (fillfactor = 60)
go

create index IX_Sale_BaseSalePaymentStatusID
    on Sale (BaseSalePaymentStatusID)
    with (fillfactor = 60)
go

create index IX_Sale_DeliveryRecipientAddressID
    on Sale (DeliveryRecipientAddressID)
    with (fillfactor = 60)
go

create index IX_Sale_SaleNumberID
    on Sale (SaleNumberID)
    with (fillfactor = 60)
go

create index IX_Sale_DeliveryRecipientID
    on Sale (DeliveryRecipientID)
    with (fillfactor = 60)
go

create index IX_Sale_TransporterID
    on Sale (TransporterID)
    with (fillfactor = 60)
go

create index IX_Sale_ShiftStatusID
    on Sale (ShiftStatusID)
    with (fillfactor = 60)
go

create unique index IX_Sale_NetUID
    on Sale (NetUID)
    with (fillfactor = 60)
go

create index IX_Sale_SaleInvoiceDocumentID
    on Sale (SaleInvoiceDocumentID)
    with (fillfactor = 60)
go

create index IX_Sale_SaleInvoiceNumberID
    on Sale (SaleInvoiceNumberID)
    with (fillfactor = 60)
go

create index IX_Sale_ChangedToInvoiceByID
    on Sale (ChangedToInvoiceByID)
    with (fillfactor = 60)
go

create index IX_Sale_TaxFreePackListID
    on Sale (TaxFreePackListID)
    with (fillfactor = 60)
go

create index IX_Sale_SadID
    on Sale (SadID)
    with (fillfactor = 60)
go

create index IX_Sale_RetailClientId
    on Sale (RetailClientId)
    with (fillfactor = 60)
go

create unique index IX_Sale_MisplacedSaleId
    on Sale (MisplacedSaleId)
    where [MisplacedSaleId] IS NOT NULL
go

create index IX_Sale_WorkplaceID
    on Sale (WorkplaceID)
go

create index IX_Sale_UpdateUserID
    on Sale (UpdateUserID)
go

create index IX_Sale_CustomersOwnTtnID
    on Sale (CustomersOwnTtnID)
go

create table SaleExchangeRate
(
    ID             bigint identity
        constraint PK_SaleExchangeRate
            primary key
                with (fillfactor = 60),
    Created        datetime2        default getutcdate() not null,
    Deleted        bit              default 0            not null,
    ExchangeRateID bigint                                not null
        constraint FK_SaleExchangeRate_ExchangeRate_ExchangeRateID
            references ExchangeRate,
    NetUID         uniqueidentifier default newid()      not null,
    SaleID         bigint                                not null
        constraint FK_SaleExchangeRate_Sale_SaleID
            references Sale,
    Updated        datetime2                             not null,
    Value          money                                 not null
)
go

create index IX_SaleExchangeRate_ExchangeRateID
    on SaleExchangeRate (ExchangeRateID)
go

create index IX_SaleExchangeRate_SaleID
    on SaleExchangeRate (SaleID)
go

create table SaleMerged
(
    ID           bigint identity
        constraint PK_SaleMerged
            primary key,
    Created      datetime2        default getutcdate() not null,
    Deleted      bit              default 0            not null,
    InputSaleID  bigint                                not null
        constraint FK_SaleMerged_Sale_InputSaleID
            references Sale,
    NetUID       uniqueidentifier default newid()      not null,
    OutputSaleID bigint                                not null
        constraint FK_SaleMerged_Sale_OutputSaleID
            references Sale,
    Updated      datetime2                             not null
)
go

create index IX_SaleMerged_InputSaleID
    on SaleMerged (InputSaleID)
go

create index IX_SaleMerged_OutputSaleID_Deleted
    on SaleMerged (OutputSaleID, Deleted)
go

create table SaleReturnItem
(
    ID                   bigint identity
        constraint PK_SaleReturnItem
            primary key
                with (fillfactor = 60),
    NetUID               uniqueidentifier default newid()              not null,
    Created              datetime2        default getutcdate()         not null,
    Updated              datetime2                                     not null,
    Deleted              bit              default 0                    not null,
    Qty                  float                                         not null,
    SaleReturnItemStatus int                                           not null,
    IsMoneyReturned      bit              default 0                    not null,
    OrderItemID          bigint                                        not null
        constraint FK_SaleReturnItem_OrderItem_OrderItemID
            references OrderItem,
    SaleReturnID         bigint                                        not null
        constraint FK_SaleReturnItem_SaleReturn_SaleReturnID
            references SaleReturn,
    CreatedByID          bigint           default CONVERT([bigint], 0) not null
        constraint FK_SaleReturnItem_User_CreatedByID
            references [User],
    MoneyReturnedByID    bigint
        constraint FK_SaleReturnItem_User_MoneyReturnedByID
            references [User],
    UpdatedByID          bigint
        constraint FK_SaleReturnItem_User_UpdatedByID
            references [User],
    MoneyReturnedAt      datetime2,
    Amount               decimal(30, 14)  default 0                    not null,
    ExchangeRateAmount   money            default 0.0                  not null,
    StorageID            bigint           default CONVERT([bigint], 0) not null
        constraint FK_SaleReturnItem_Storage_StorageID
            references Storage
)
go

create table ProductIncomeItem
(
    Created                       datetime2        default getutcdate()            not null,
    Deleted                       bit              default 0                       not null,
    ID                            bigint identity
        constraint PK_ProductIncomeItem
            primary key
                with (fillfactor = 60),
    NetUID                        uniqueidentifier default newid()                 not null,
    Updated                       datetime2                                        not null,
    SaleReturnItemID              bigint
        constraint FK_ProductIncomeItem_SaleReturnItem_SaleReturnItemID
            references SaleReturnItem
            on delete cascade,
    ProductIncomeID               bigint                                           not null
        constraint FK_ProductIncomeItem_ProductIncome_ProductIncomeID
            references ProductIncome
            on delete cascade,
    PackingListPackageOrderItemID bigint
        constraint FK_ProductIncomeItem_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem
            on delete cascade,
    Qty                           float            default 0.0000000000000000e+000 not null,
    SupplyOrderUkraineItemID      bigint
        constraint FK_ProductIncomeItem_SupplyOrderUkraineItem_SupplyOrderUkraineItemID
            references SupplyOrderUkraineItem
            on delete cascade,
    RemainingQty                  float            default 0.0000000000000000e+000 not null,
    ActReconciliationItemID       bigint
        constraint FK_ProductIncomeItem_ActReconciliationItem_ActReconciliationItemID
            references ActReconciliationItem
            on delete cascade,
    ProductCapitalizationItemID   bigint
        constraint FK_ProductIncomeItem_ProductCapitalizationItem_ProductCapitalizationItemID
            references ProductCapitalizationItem
            on delete cascade
)
go

alter table ConsignmentItem
    add constraint FK_ConsignmentItem_ProductIncomeItem_ProductIncomeItemID
        foreign key (ProductIncomeItemID) references ProductIncomeItem
go

create index IX_ProductIncomeItem_ProductIncomeID
    on ProductIncomeItem (ProductIncomeID)
    with (fillfactor = 60)
go

create index IX_ProductIncomeItem_PackingListPackageOrderItemID
    on ProductIncomeItem (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create unique index IX_ProductIncomeItem_SaleReturnItemID
    on ProductIncomeItem (SaleReturnItemID)
    where [SaleReturnItemID] IS NOT NULL
go

create index IX_ProductIncomeItem_SupplyOrderUkraineItemID
    on ProductIncomeItem (SupplyOrderUkraineItemID)
    with (fillfactor = 60)
go

create index IX_ProductIncomeItem_ActReconciliationItemID
    on ProductIncomeItem (ActReconciliationItemID)
    with (fillfactor = 60)
go

create unique index IX_ProductIncomeItem_ProductCapitalizationItemID
    on ProductIncomeItem (ProductCapitalizationItemID)
    where [ProductCapitalizationItemID] IS NOT NULL
    with (fillfactor = 60)
go

create table ProductPlacement
(
    ID                            bigint identity
        constraint PK_ProductPlacement
            primary key
                with (fillfactor = 60),
    NetUID                        uniqueidentifier default newid()           not null,
    Created                       datetime2        default getutcdate()      not null,
    Updated                       datetime2                                  not null,
    Deleted                       bit              default 0                 not null,
    Qty                           float                                      not null,
    StorageNumber                 nvarchar(5),
    RowNumber                     nvarchar(5),
    CellNumber                    nvarchar(5),
    ProductID                     bigint                                     not null
        constraint FK_ProductPlacement_Product_ProductID
            references Product,
    StorageID                     bigint                                     not null
        constraint FK_ProductPlacement_Storage_StorageID
            references Storage,
    PackingListPackageOrderItemID bigint
        constraint FK_ProductPlacement_PackingListPackageOrderItem_PackingListPackageOrderItemID
            references PackingListPackageOrderItem,
    SupplyOrderUkraineItemID      bigint
        constraint FK_ProductPlacement_SupplyOrderUkraineItem_SupplyOrderUkraineItemID
            references SupplyOrderUkraineItem,
    ProductIncomeItemID           bigint
        constraint FK_ProductPlacement_ProductIncomeItem_ProductIncomeItemID
            references ProductIncomeItem,
    ConsignmentItemID             bigint
        constraint FK_ProductPlacement_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem,
    IsOriginal                    bit              default CONVERT([bit], 0) not null,
    IsHistorySet                  bit              default CONVERT([bit], 0) not null
)
go

create table ProductLocation
(
    ID                     bigint identity
        constraint PK_ProductLocation
            primary key
                with (fillfactor = 60),
    NetUID                 uniqueidentifier default newid()                 not null,
    Created                datetime2        default getutcdate()            not null,
    Updated                datetime2                                        not null,
    Deleted                bit              default 0                       not null,
    Qty                    float                                            not null,
    StorageID              bigint                                           not null
        constraint FK_ProductLocation_Storage_StorageID
            references Storage,
    ProductPlacementID     bigint                                           not null
        constraint FK_ProductLocation_ProductPlacement_ProductPlacementID
            references ProductPlacement,
    OrderItemID            bigint
        constraint FK_ProductLocation_OrderItem_OrderItemID
            references OrderItem,
    DepreciatedOrderItemID bigint
        constraint FK_ProductLocation_DepreciatedOrderItem_DepreciatedOrderItemID
            references DepreciatedOrderItem,
    ProductTransferItemID  bigint
        constraint FK_ProductLocation_ProductTransferItem_ProductTransferItemID
            references ProductTransferItem,
    InvoiceDocumentQty     float            default 0.0000000000000000e+000 not null
)
go

create index IX_ProductLocation_OrderItemID
    on ProductLocation (OrderItemID)
go

create index IX_ProductLocation_ProductPlacementID
    on ProductLocation (ProductPlacementID)
go

create index IX_ProductLocation_StorageID
    on ProductLocation (StorageID)
go

create index IX_ProductLocation_DepreciatedOrderItemID
    on ProductLocation (DepreciatedOrderItemID)
go

create index IX_ProductLocation_ProductTransferItemID
    on ProductLocation (ProductTransferItemID)
go

create table ProductLocationHistory
(
    ID                     bigint identity
        constraint PK_ProductLocationHistory
            primary key,
    Qty                    float                                 not null,
    StorageID              bigint                                not null
        constraint FK_ProductLocationHistory_Storage_StorageID
            references Storage,
    ProductPlacementID     bigint                                not null
        constraint FK_ProductLocationHistory_ProductPlacement_ProductPlacementID
            references ProductPlacement,
    OrderItemID            bigint
        constraint FK_ProductLocationHistory_OrderItem_OrderItemID
            references OrderItem,
    DepreciatedOrderItemID bigint
        constraint FK_ProductLocationHistory_DepreciatedOrderItem_DepreciatedOrderItemID
            references DepreciatedOrderItem,
    TypeOfMovement         int                                   not null,
    NetUID                 uniqueidentifier default newid()      not null,
    Created                datetime2        default getutcdate() not null,
    Updated                datetime2                             not null,
    Deleted                bit              default 0            not null,
    HistoryInvoiceEditID   bigint
        constraint FK_ProductLocationHistory_HistoryInvoiceEdit_HistoryInvoiceEditID
            references HistoryInvoiceEdit
)
go

create index IX_ProductLocationHistory_DepreciatedOrderItemID
    on ProductLocationHistory (DepreciatedOrderItemID)
go

create index IX_ProductLocationHistory_OrderItemID
    on ProductLocationHistory (OrderItemID)
go

create index IX_ProductLocationHistory_ProductPlacementID
    on ProductLocationHistory (ProductPlacementID)
go

create index IX_ProductLocationHistory_StorageID
    on ProductLocationHistory (StorageID)
go

create index IX_ProductLocationHistory_HistoryInvoiceEditID
    on ProductLocationHistory (HistoryInvoiceEditID)
go

create index IX_ProductPlacement_ProductID
    on ProductPlacement (ProductID)
    with (fillfactor = 60)
go

create index IX_ProductPlacement_StorageID
    on ProductPlacement (StorageID)
    with (fillfactor = 60)
go

create index IX_ProductPlacement_PackingListPackageOrderItemID
    on ProductPlacement (PackingListPackageOrderItemID)
    with (fillfactor = 60)
go

create index IX_ProductPlacement_SupplyOrderUkraineItemID
    on ProductPlacement (SupplyOrderUkraineItemID)
    with (fillfactor = 60)
go

create index IX_ProductPlacement_ProductIncomeItemID
    on ProductPlacement (ProductIncomeItemID)
    with (fillfactor = 60)
go

create index IX_ProductPlacement_ConsignmentItemID
    on ProductPlacement (ConsignmentItemID)
    with (fillfactor = 60)
go

create table ProductPlacementMovement
(
    ID                     bigint identity
        constraint PK_ProductPlacementMovement
            primary key,
    NetUID                 uniqueidentifier default newid()              not null,
    Created                datetime2        default getutcdate()         not null,
    Updated                datetime2                                     not null,
    Deleted                bit              default 0                    not null,
    Qty                    float                                         not null,
    FromProductPlacementID bigint                                        not null
        constraint FK_ProductPlacementMovement_ProductPlacement_FromProductPlacementID
            references ProductPlacement,
    ToProductPlacementID   bigint                                        not null
        constraint FK_ProductPlacementMovement_ProductPlacement_ToProductPlacementID
            references ProductPlacement,
    Comment                nvarchar(500),
    Number                 nvarchar(50),
    ResponsibleID          bigint           default CONVERT([bigint], 0) not null
        constraint FK_ProductPlacementMovement_User_ResponsibleID
            references [User]
)
go

create index IX_ProductPlacementMovement_FromProductPlacementID
    on ProductPlacementMovement (FromProductPlacementID)
go

create index IX_ProductPlacementMovement_ToProductPlacementID
    on ProductPlacementMovement (ToProductPlacementID)
go

create index IX_ProductPlacementMovement_ResponsibleID
    on ProductPlacementMovement (ResponsibleID)
go

create table ProductPlacementStorage
(
    ID                 bigint identity
        constraint PK_ProductPlacementStorage
            primary key,
    Qty                float                                 not null,
    Placement          nvarchar(500),
    VendorCode         nvarchar(max),
    ProductPlacementId bigint                                not null
        constraint FK_ProductPlacementStorage_ProductPlacement_ProductPlacementId
            references ProductPlacement
            on delete cascade,
    ProductId          bigint                                not null
        constraint FK_ProductPlacementStorage_Product_ProductId
            references Product
            on delete cascade,
    StorageId          bigint                                not null
        constraint FK_ProductPlacementStorage_Storage_StorageId
            references Storage
            on delete cascade,
    NetUID             uniqueidentifier default newid()      not null,
    Created            datetime2        default getutcdate() not null,
    Updated            datetime2                             not null,
    Deleted            bit              default 0            not null
)
go

create index IX_ProductPlacementStorage_ProductId
    on ProductPlacementStorage (ProductId)
go

create index IX_ProductPlacementStorage_ProductPlacementId
    on ProductPlacementStorage (ProductPlacementId)
go

create index IX_ProductPlacementStorage_StorageId
    on ProductPlacementStorage (StorageId)
go

create index IX_SaleReturnItem_OrderItemID
    on SaleReturnItem (OrderItemID)
go

create index IX_SaleReturnItem_SaleReturnID
    on SaleReturnItem (SaleReturnID)
go

create index IX_SaleReturnItem_CreatedByID
    on SaleReturnItem (CreatedByID)
go

create index IX_SaleReturnItem_MoneyReturnedByID
    on SaleReturnItem (MoneyReturnedByID)
go

create index IX_SaleReturnItem_UpdatedByID
    on SaleReturnItem (UpdatedByID)
go

create index IX_SaleReturnItem_StorageID
    on SaleReturnItem (StorageID)
go

create table SaleReturnItemProductPlacement
(
    ID                 bigint identity
        constraint PK_SaleReturnItemProductPlacement
            primary key,
    ProductPlacementID bigint
        constraint FK_SaleReturnItemProductPlacement_ProductPlacement_ProductPlacementID
            references ProductPlacement,
    SaleReturnItemId   bigint                                           not null
        constraint FK_SaleReturnItemProductPlacement_SaleReturnItem_SaleReturnItemId
            references SaleReturnItem,
    NetUID             uniqueidentifier default newid()                 not null,
    Created            datetime2        default getutcdate()            not null,
    Updated            datetime2                                        not null,
    Deleted            bit              default 0                       not null,
    Qty                float            default 0.0000000000000000e+000 not null
)
go

create index IX_SaleReturnItemProductPlacement_ProductPlacementID
    on SaleReturnItemProductPlacement (ProductPlacementID)
go

create index IX_SaleReturnItemProductPlacement_SaleReturnItemId
    on SaleReturnItemProductPlacement (SaleReturnItemId)
go

create table ShipmentListItem
(
    ID                  bigint identity
        constraint PK_ShipmentListItem
            primary key,
    NetUID              uniqueidentifier default newid()           not null,
    Created             datetime2        default getutcdate()      not null,
    Updated             datetime2                                  not null,
    Deleted             bit              default 0                 not null,
    Comment             nvarchar(500),
    QtyPlaces           float                                      not null,
    SaleID              bigint                                     not null
        constraint FK_ShipmentListItem_Sale_SaleID
            references Sale,
    ShipmentListID      bigint                                     not null
        constraint FK_ShipmentListItem_ShipmentList_ShipmentListID
            references ShipmentList,
    IsChangeTransporter bit              default CONVERT([bit], 0) not null
)
go

create index IX_ShipmentListItem_SaleID
    on ShipmentListItem (SaleID)
go

create index IX_ShipmentListItem_ShipmentListID
    on ShipmentListItem (ShipmentListID)
go

create table SupplyOrderUkraineCartItemReservationProductPlacement
(
    ID                                      bigint identity
        constraint PK_SupplyOrderUkraineCartItemReservationProductPlacement
            primary key,
    NetUID                                  uniqueidentifier default newid()      not null,
    Created                                 datetime2        default getutcdate() not null,
    Updated                                 datetime2                             not null,
    Deleted                                 bit              default 0            not null,
    Qty                                     float                                 not null,
    ProductPlacementID                      bigint                                not null
        constraint FK_SupplyOrderUkraineCartItemReservationProductPlacement_ProductPlacement_ProductPlacementID
            references ProductPlacement,
    SupplyOrderUkraineCartItemReservationID bigint                                not null
        constraint [FK_SupplyOrderUkraineCartItemReservationProductPlacement_SupplyOrderUkraineCartItemReservation_SupplyOrderUkraineCartItemReserv~]
            references SupplyOrderUkraineCartItemReservation
            on delete cascade
)
go

create index IX_SupplyOrderUkraineCartItemReservationProductPlacement_ProductPlacementID
    on SupplyOrderUkraineCartItemReservationProductPlacement (ProductPlacementID)
    with (fillfactor = 60)
go

create index IX_SupplyOrderUkraineCartItemReservationProductPlacement_SupplyOrderUkraineCartItemReservationID
    on SupplyOrderUkraineCartItemReservationProductPlacement (SupplyOrderUkraineCartItemReservationID)
    with (fillfactor = 60)
go

create table TaxFreePackListOrderItem
(
    ID                bigint identity
        constraint PK_TaxFreePackListOrderItem
            primary key,
    NetUID            uniqueidentifier default newid()      not null,
    Created           datetime2        default getutcdate() not null,
    Updated           datetime2                             not null,
    Deleted           bit              default 0            not null,
    NetWeight         float                                 not null,
    Qty               float                                 not null,
    UnpackedQty       float                                 not null,
    OrderItemID       bigint                                not null
        constraint FK_TaxFreePackListOrderItem_OrderItem_OrderItemID
            references OrderItem,
    TaxFreePackListID bigint                                not null
        constraint FK_TaxFreePackListOrderItem_TaxFreePackList_TaxFreePackListID
            references TaxFreePackList,
    ConsignmentItemID bigint
        constraint FK_TaxFreePackListOrderItem_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem
)
go

create table TaxFreeItem
(
    ID                           bigint identity
        constraint PK_TaxFreeItem
            primary key,
    NetUID                       uniqueidentifier default newid()      not null,
    Created                      datetime2        default getutcdate() not null,
    Updated                      datetime2                             not null,
    Deleted                      bit              default 0            not null,
    Qty                          float                                 not null,
    Comment                      nvarchar(500),
    TaxFreeID                    bigint                                not null
        constraint FK_TaxFreeItem_TaxFree_TaxFreeID
            references TaxFree,
    SupplyOrderUkraineCartItemID bigint
        constraint FK_TaxFreeItem_SupplyOrderUkraineCartItem_SupplyOrderUkraineCartItemID
            references SupplyOrderUkraineCartItem,
    TaxFreePackListOrderItemID   bigint
        constraint FK_TaxFreeItem_TaxFreePackListOrderItem_TaxFreePackListOrderItemID
            references TaxFreePackListOrderItem
)
go

create table ConsignmentItemMovement
(
    ID                         bigint identity
        constraint PK_ConsignmentItemMovement
            primary key
                with (fillfactor = 60),
    NetUID                     uniqueidentifier default newid()                 not null,
    Created                    datetime2        default getutcdate()            not null,
    Updated                    datetime2                                        not null,
    Deleted                    bit              default 0                       not null,
    IsIncomeMovement           bit                                              not null,
    Qty                        float                                            not null,
    MovementType               int                                              not null,
    ConsignmentItemID          bigint                                           not null
        constraint FK_ConsignmentItemMovement_ConsignmentItem_ConsignmentItemID
            references ConsignmentItem
            on delete cascade,
    ProductIncomeItemID        bigint
        constraint FK_ConsignmentItemMovement_ProductIncomeItem_ProductIncomeItemID
            references ProductIncomeItem,
    DepreciatedOrderItemID     bigint
        constraint FK_ConsignmentItemMovement_DepreciatedOrderItem_DepreciatedOrderItemID
            references DepreciatedOrderItem,
    SupplyReturnItemID         bigint
        constraint FK_ConsignmentItemMovement_SupplyReturnItem_SupplyReturnItemID
            references SupplyReturnItem,
    OrderItemID                bigint
        constraint FK_ConsignmentItemMovement_OrderItem_OrderItemID
            references OrderItem,
    ProductTransferItemID      bigint
        constraint FK_ConsignmentItemMovement_ProductTransferItem_ProductTransferItemID
            references ProductTransferItem,
    OrderItemBaseShiftStatusID bigint
        constraint FK_ConsignmentItemMovement_OrderItemBaseShiftStatus_OrderItemBaseShiftStatusID
            references OrderItemBaseShiftStatus,
    TaxFreeItemID              bigint
        constraint FK_ConsignmentItemMovement_TaxFreeItem_TaxFreeItemID
            references TaxFreeItem,
    SadItemID                  bigint
        constraint FK_ConsignmentItemMovement_SadItem_SadItemID
            references SadItem,
    RemainingQty               float            default 0.0000000000000000e+000 not null,
    ReSaleItemId               bigint
        constraint FK_ConsignmentItemMovement_ReSaleItem_ReSaleItemId
            references ReSaleItem
)
go

create index IX_ConsignmentItemMovement_ConsignmentItemID
    on ConsignmentItemMovement (ConsignmentItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_DepreciatedOrderItemID
    on ConsignmentItemMovement (DepreciatedOrderItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_OrderItemBaseShiftStatusID
    on ConsignmentItemMovement (OrderItemBaseShiftStatusID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_OrderItemID
    on ConsignmentItemMovement (OrderItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_ProductIncomeItemID
    on ConsignmentItemMovement (ProductIncomeItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_ProductTransferItemID
    on ConsignmentItemMovement (ProductTransferItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_SadItemID
    on ConsignmentItemMovement (SadItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_SupplyReturnItemID
    on ConsignmentItemMovement (SupplyReturnItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_TaxFreeItemID
    on ConsignmentItemMovement (TaxFreeItemID)
    with (fillfactor = 60)
go

create index IX_ConsignmentItemMovement_ReSaleItemId
    on ConsignmentItemMovement (ReSaleItemId)
    with (fillfactor = 60)
go

create index IX_TaxFreeItem_SupplyOrderUkraineCartItemID
    on TaxFreeItem (SupplyOrderUkraineCartItemID)
    with (fillfactor = 60)
go

create index IX_TaxFreeItem_TaxFreeID
    on TaxFreeItem (TaxFreeID)
go

create index IX_TaxFreeItem_TaxFreePackListOrderItemID
    on TaxFreeItem (TaxFreePackListOrderItemID)
go

create index IX_TaxFreePackListOrderItem_OrderItemID
    on TaxFreePackListOrderItem (OrderItemID)
go

create index IX_TaxFreePackListOrderItem_TaxFreePackListID
    on TaxFreePackListOrderItem (TaxFreePackListID)
go

create index IX_TaxFreePackListOrderItem_ConsignmentItemID
    on TaxFreePackListOrderItem (ConsignmentItemID)
go

create table UpdateDataCarrier
(
    ID                   bigint identity
        constraint PK_UpdateDataCarrier
            primary key,
    SaleId               bigint                                     not null
        constraint FK_UpdateDataCarrier_Sale_SaleId
            references Sale
            on delete cascade,
    TransporterId        bigint
        constraint FK_UpdateDataCarrier_Transporter_TransporterId
            references Transporter,
    UserId               bigint
        constraint FK_UpdateDataCarrier_User_UserId
            references [User],
    IsCashOnDelivery     bit                                        not null,
    HasDocument          bit                                        not null,
    Comment              nvarchar(450),
    Number               nvarchar(max),
    MobilePhone          nvarchar(max),
    FullName             nvarchar(max),
    City                 nvarchar(max),
    Department           nvarchar(max),
    TtnPDFPath           nvarchar(max),
    NetUID               uniqueidentifier default newid()           not null,
    Created              datetime2        default getutcdate()      not null,
    Updated              datetime2                                  not null,
    Deleted              bit              default 0                 not null,
    ApproveUpdate        bit              default CONVERT([bit], 0) not null,
    ShipmentDate         datetime2,
    TTN                  nvarchar(max),
    CashOnDeliveryAmount money            default 0.0               not null,
    IsDevelopment        bit              default 0                 not null,
    IsEditTransporter    bit              default CONVERT([bit], 0) not null
)
go

create index IX_UpdateDataCarrier_SaleId
    on UpdateDataCarrier (SaleId)
go

create index IX_UpdateDataCarrier_TransporterId
    on UpdateDataCarrier (TransporterId)
go

create index IX_UpdateDataCarrier_UserId
    on UpdateDataCarrier (UserId)
go

create table WarehousesShipment
(
    ID                   bigint identity
        constraint PK_WarehousesShipment
            primary key,
    IsDevelopment        bit              default 0            not null,
    SaleId               bigint
        constraint FK_WarehousesShipment_Sale_SaleId
            references Sale,
    TransporterId        bigint
        constraint FK_WarehousesShipment_Transporter_TransporterId
            references Transporter,
    UserId               bigint
        constraint FK_WarehousesShipment_User_UserId
            references [User],
    IsCashOnDelivery     bit                                   not null,
    CashOnDeliveryAmount money                                 not null,
    HasDocument          bit                                   not null,
    ShipmentDate         datetime2,
    TTN                  nvarchar(max),
    Comment              nvarchar(450),
    Number               nvarchar(max),
    MobilePhone          nvarchar(max),
    FullName             nvarchar(max),
    City                 nvarchar(max),
    Department           nvarchar(max),
    TtnPDFPath           nvarchar(max),
    ApproveUpdate        bit                                   not null,
    NetUID               uniqueidentifier default newid()      not null,
    Created              datetime2        default getutcdate() not null,
    Updated              datetime2                             not null,
    Deleted              bit              default 0            not null
)
go

create unique index IX_WarehousesShipment_SaleId
    on WarehousesShipment (SaleId)
    where [SaleId] IS NOT NULL
go

create index IX_WarehousesShipment_TransporterId
    on WarehousesShipment (TransporterId)
go

create index IX_WarehousesShipment_UserId
    on WarehousesShipment (UserId)
go

create index IX_Workplace_ClientGroupID
    on Workplace (ClientGroupID)
go

create index IX_Workplace_MainClientID
    on Workplace (MainClientID)
go

create table WorkplaceClientAgreement
(
    ID                bigint identity
        constraint PK_WorkplaceClientAgreement
            primary key,
    NetUID            uniqueidentifier default newid()      not null,
    Created           datetime2        default getutcdate() not null,
    Updated           datetime2                             not null,
    Deleted           bit              default 0            not null,
    WorkplaceID       bigint                                not null
        constraint FK_WorkplaceClientAgreement_Workplace_WorkplaceID
            references Workplace,
    ClientAgreementID bigint                                not null
        constraint FK_WorkplaceClientAgreement_ClientAgreement_ClientAgreementID
            references ClientAgreement,
    IsSelected        bit                                   not null
)
go

create index IX_WorkplaceClientAgreement_ClientAgreementID
    on WorkplaceClientAgreement (ClientAgreementID)
go

create index IX_WorkplaceClientAgreement_WorkplaceID
    on WorkplaceClientAgreement (WorkplaceID)
go

create table __EFMigrationsHistory
(
    MigrationId    nvarchar(150) not null
        constraint PK___EFMigrationsHistory
            primary key
                with (fillfactor = 60),
    ProductVersion nvarchar(32)  not null
)
go

create table sysdiagrams
(
    name         sysname not null,
    principal_id int     not null,
    diagram_id   int identity
        primary key,
    version      int,
    definition   varbinary(max),
    constraint UK_principal_name
        unique (principal_id, name)
)
go

exec sp_addextendedproperty 'microsoft_database_tools_support', 1, 'SCHEMA', 'dbo', 'TABLE', 'sysdiagrams'
go


