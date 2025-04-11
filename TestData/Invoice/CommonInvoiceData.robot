*** Settings ***
Documentation     Dữ liệu hóa đơn chuẩn dùng chung cho các test cases
Resource          ../CommonData.robot

*** Variables ***
# Chi tiết hóa đơn chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{STANDARD_INVOICE_DETAIL}
&{STANDARD_INVOICE_DETAIL}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0
&{STANDARD_INVOICE}
...    Code=HD_TEST_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}

# Template dữ liệu cho request
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

@{STANDARD_PAYMENT_BODY}
...    &{payment_body} 

&{payment_body} 
...    Method=Cash
...    Amount=100000


# promotion
@{invoice_promotion_body}    
...    &{promotion_body}

&{promotion_body}
...    Type=1
...    SalePromotionId=1589
...    PromotionId=10477
...    Discount=10000
...    DiscountRatio=null

# Surcharge details
&{surcharge_item_body}    
...    SurchargeId=${SURCHARGE_1_ID}
...    Price=10000
...    ValueRatio=0


&{surcharge_percent_item_body}
...    SurchargeId=${SURCHARGE_2_ID}
...    Price=0
...    ValueRatio=10

#Combo 
&{combo_product_detail_body}
...    ProductId=${COMBO_PRODUCT_1_ID}
...    Quantity=1
...    Price=250000
...    Discount=0
...    IsCombo=${TRUE}

&{combo_product_1_matterial_1_body}
...    ProductId=${COMBO_PRODUCT_1_MATTERIAL_1_ID}
...    Quantity=1
...    Price=100000

&{combo_product_1_matterial_2_body}
...    ProductId=${COMBO_PRODUCT_1_MATTERIAL_2_ID}
...    Quantity=1
...    Price=150000





# SoldBy Body
&{sold_by_body}    CreatedBy=0    CreatedDate=2025-03-27T06:44:21.083Z    GivenName=admin    Id=${DEFAULT_USER_ID}    IsActive=${True}    IsAdmin=${True}    Language=vi-VN    MobilePhone=03322553899    Type=0    UserName=admin    isDeleted=${False}

# InvoiceDetails Body
@{invoices_detail_body}    &{invoice_detail_1}
&{invoice_detail_1}    BasePrice=0    IsLotSerialControl=${False}    IsBatchExpireControl=${None}    IsRewardPoint=${False}    Note=    Price=0    ProductId=${PRODUCT_1}    Quantity=1    ProductCode=${PRODUCT_1_CODE}    Weight=${None}    ProductName=${PRODUCT_1_NAME}    OriginPrice=0    ProductFormulaHistoryId=${None}    ProductBatchExpireId=${None}    CategoryId=${CATEGORY_1_ID}    MasterProductId=${MASTER_PRODUCT_1_ID}    Unit=    ProductWarranty=@{Empty}    SupplyPromotionTypes=    Formulas=${None}    InvoiceDetailTaxs=@{Empty}    DetailTaxIds=${None}

# InvoiceOrderSurcharges Body
@{invoice_order_surcharges_body}    &{surcharge_1}    &{surcharge_2}
&{surcharge_1}    Code=TK001    CreatedDate=2025-03-28T02:47:37.950Z    Name=Phí VAT1    Order=1    Price=0    RetailerId=19809    SurValueRatio=10    SurchargeBranches=@{Empty}    SurchargeId=${SURCHARGE_1_ID}    UsageFlag=${True}    ValueRatio=10    isAuto=${True}    isReturnAuto=${False}
&{surcharge_2}    Code=TK002    CreatedDate=2025-03-28T02:47:38.940Z    Name=Phí VAT2    Order=2    Price=0    RetailerId=19809    SurValue=0    SurchargeBranches=@{Empty}    SurchargeId=${SURCHARGE_2_ID}    UsageFlag=${True}    Value=0    isAuto=${True}    isReturnAuto=${True}

# DeliveryDetail Body
&{delivery_detail_body}    Type=0    TypeName=    Status=1    Address=${None}    ContactNumber=0988673523    Receiver=Hung    DeliveryBy=${PARTNER_DELIVERY_1_ID}    LocationId=1    LocationName=An Giang - Huyện Chợ Mới    WardName=Thị trấn Chợ Mới    CustomerId=${None}    CustomerCode=${None}    BranchTakingAddressId=${None}    BranchTakingAddressStr="1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"    AdministrativeAreaId=${None}    WardId=10548    Weight=500    Height=10    Width=10    Length=10    IsChangeGBH=${False}    PackageType=0    Paymenter=0    ServiceCode=0    UseDefaultPartner=${False}    UsingOfBilling=${False}    UsingPriceCod=1    ChangeExpectedDelivery=${False}    WeightInput=500    LastLocation=An Giang - Huyện Chợ Mới    LastWard=Thị trấn Chợ Mới    PackageTypeObj=&{package_type_body}

&{default_delivery_detail_body}    
...    Type=0    
...    TypeName=    
...    Status=1    
...    Address=${None}    
...    ContactNumber=${None}    
...    Receiver=${None}    
...    DeliveryBy=${None}    
...    LocationId=${None}    
...    LocationName=${None}    
...    WardName=${None}    
...    CustomerId=${None}    
...    CustomerCode=${None}    
...    BranchTakingAddressId=${None}    
...    BranchTakingAddressStr="1,Phường Ba Ngòi,Thành phố Cam Ranh, Khánh Hòa 03322553899"
...    AdministrativeAreaId=${None}    
...    WardId=${None}    
...    Weight=500    
...    Height=10    
...    Width=10    
...    Length=10    
...    PackageType=0    
...    ChangeExpectedDelivery=${False}    
...    UsingPriceCod=1    
...    UseDefaultPartner=${False}    
...    WeightInput=500    
...    UsingOfBilling=${False}    
...    Paymenter=0    
...    LastLocation=${None}    
...    LastWard=${None}    
...    PackageTypeObj=&{package_type_body}    
...    TotalProductPrice=0    
...    IsChangeGBH=${False}    
...    Price=${None}    
...    Comments=${None}    
...    ServiceCodeText=${None}    
...    ServiceAdd=${None}    
...    ServiceCode=0    
...    PartnerDelivery=${None}    
...    PartnerCode=${None}    
...    PartnerName=${None}    
...    DeliveryCode=${None}

# PackageType Body
&{package_type_body}    Value=0    Name=gram

#Partner Delivery Body
&{partner_delivery_body}    
...    IdOld=0    
...    TotalInvoiced=0    
...    CompareCode=${PARTNER_DELIVERY_1_CODE}    
...    CompareName=Phạm Anh Tú    
...    Id=${PARTNER_DELIVERY_1_ID}    
...    RetailerId=${RETAILER_ID}    
...    Type=0    
...    Code=${PARTNER_DELIVERY_1_CODE}        
...    Name=Phạm Anh Tú    
...    ContactNumber=01679089901    
...    Address=${None}    
...    Email=${None}    
...    Comments=${None}    
...    CreatedDate=2025-03-28T10:40:23.963+07:00    
...    CreatedBy=${DEFAULT_USER_ID}    
...    ModifiedDate=${None}    
...    Debt=${None}    
...    ModifiedBy=${None}    
...    Uuid=${None}    
...    LocationId=${None}    
...    LocationName=    
...    WardName=    
...    isActive=${True}    
...    isDeleted=${False}    
...    SearchNumber=01679089901    
...    IsOmniChannel=${None}    
...    AdministrativeAreaId=${None}    
...    PartnerDeliveryGroupDetails=@{Empty}    
...    CustomName=Phạm Anh Tú - 01679089901





# Invoice Body
&{invoice_body}    BranchId=${DEFAULT_BRANCH_ID}    RetailerId=${RETAILER_ID}    UpdateInvoiceId=0    UpdateReturnId=0    IsChangeNormalToShippingDelivery=${False}    SoldById=${DEFAULT_USER_ID}    SoldBy=&{sold_by_body}    SaleChannelId=0    Seller=&{sold_by_body}    OrderCode=    Code=    InvoiceDetails=@{invoices_detail_body}    InvoiceOrderSurcharges=@{invoice_order_surcharges_body}    InvoicePromotions=@{Empty}    InvoiceSupplierPromotions=@{Empty}    DeliveryDetail=&{default_delivery_detail_body}    UsingCod=1    Payments=@{Empty}    Status=3    Total=0    TotalTax=${None}    EnableVATToggle=${False}    Surcharge=0    Type=1    addToAccount=0    PayingAmount=0    TotalBeforeDiscount=0    ProductDiscount=0    InvoiceWarranties=@{Empty}    CreatedBy=${DEFAULT_USER_ID}
&{invoice_request_body}     Invoice=&{invoice_body}

# Invoice body not delivery
&{invoice_body_not_delivery}    BranchId=${DEFAULT_BRANCH_ID}    RetailerId=${RETAILER_ID}    UpdateInvoiceId=0    UpdateReturnId=0    IsChangeNormalToShippingDelivery=${False}    SoldById=${DEFAULT_USER_ID}    SoldBy=&{sold_by_body}    SaleChannelId=0    Seller=&{sold_by_body}    OrderCode=    Code=    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}    InvoiceOrderSurcharges=@{EMPTY}    InvoicePromotions=@{EMPTY}    InvoiceSupplierPromotions=@{Empty}      UsingCod=0    Payments=@{EMPTY}     Total=0    TotalTax=${None}    EnableVATToggle=${False}    Surcharge=0    Type=1    addToAccount=0    PayingAmount=0    TotalBeforeDiscount=0    ProductDiscount=0    InvoiceWarranties=@{Empty}    CreatedBy=${DEFAULT_USER_ID}
&{invoice_request_body_not_delivery}    Invoice=&{invoice_body_not_delivery}

&{invoice_body_with_promotion}    BranchId=${DEFAULT_BRANCH_ID}    RetailerId=${RETAILER_ID}    UpdateInvoiceId=0    UpdateReturnId=0    IsChangeNormalToShippingDelivery=${False}    SoldById=${DEFAULT_USER_ID}    SoldBy=&{sold_by_body}    SaleChannelId=0    Seller=&{sold_by_body}    OrderCode=    Code=    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}    InvoiceOrderSurcharges=@{EMPTY}    InvoicePromotions=@{EMPTY}    InvoiceSupplierPromotions=@{invoice_promotion_body}         UsingCod=0    Payments=@{EMPTY}     Total=0    TotalTax=${None}    EnableVATToggle=${False}    Surcharge=0    Type=1    addToAccount=0    PayingAmount=0    TotalBeforeDiscount=0    ProductDiscount=0    InvoiceWarranties=@{Empty}    CreatedBy=${DEFAULT_USER_ID}
&{invoice_request_body_with_promotion}    Invoice=&{invoice_body_with_promotion}