*** Variables ***
&{INVOICE_DATA}
...    Invoice=${INVOICE}

&{INVOICE}
...    BranchId=${DEFAULT_BRANCH_ID}
...    RetailerId=${RETAILER_ID}
...    UpdateInvoiceId=0
...    UpdateReturnId=0
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SoldById=${DEFAULT_USER_ID}
...    SoldBy=&{SOLD_BY}
...    SaleChannelId=0
...    Seller=&{SELLER}
...    InvoiceDetails=@{INVOICE_DETAILS}
...    InvoiceOrderSurcharges=@{INVOICE_SURCHARGES}
...    InvoicePromotions=[]
...    UsingCod=0
...    Payments=@{PAYMENTS}
...    Status=1
...    Total=6350000
...    TotalTax=${None}
...    EnableVATToggle=${False}
...    RoundAmount=${None}
...    Surcharge=50000
...    Type=1
...    addToAccount=0
...    addToAccountSurplus=0
...    addToAccountAllocation=0
...    addToAccountPaymentAllocation=0
...    PayingAmount=6350000
...    TotalBeforeDiscount=6300000
...    ProductDiscount=0
...    InvoiceWarranties=[]
...    CreatedBy=${DEFAULT_USER_ID}

&{SOLD_BY}
...    Id=${DEFAULT_USER_ID}

&{SELLER}
...    Id=${DEFAULT_USER_ID}

@{INVOICE_DETAILS}
...    &{DETAIL_1}

&{DETAIL_1}
...    BasePrice=6300000
...    IsLotSerialControl=${False}
...    IsBatchExpireControl=${False}
...    IsRewardPoint=${False}
...    Note=${None}
...    Price=6300000
...    ProductId=${DEFAULT_PRODUCT_ID}
...    Quantity=1
...    Weight=0
...    OriginPrice=6300000
...    PriceByPromotion=${None}
...    ProductFormulaHistoryId=${None}
...    PromotionParentProductId=${None}
...    ProductBatchExpireId=${None}
...    CategoryId=${None}
...    MasterProductId=${DEFAULT_PRODUCT_ID}
...    Unit=${None}
...    ProductWarranty=[]
...    Formulas=${None}
...    InvoiceDetailTaxs=[]
...    DetailTaxIds=${None}

@{INVOICE_SURCHARGES}
...    &{SURCHARGE_1}

&{SURCHARGE_1}
...    Code=THK000001
...    RetailerId=${RETAILER_ID}
...    SurValue=50000
...    SurchargeBranches=${None}
...    SurchargeId=795
...    UsageFlag=${True}
...    Value=50000
...    isAuto=${True}
...    Price=50000

@{PAYMENTS}
...    &{PAYMENT_1}


&{PAYMENT_1}
...    Method=
...    Amount=
...    AccountId=${None}
...    UsePoint=${None}
