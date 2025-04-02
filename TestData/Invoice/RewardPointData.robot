*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Configuration Constants for Reward Points
${MONEY_PER_POINT}    10000
${POINT_TO_MONEY}     100

# Standard invoice data
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

# Standard invoice data
&{STANDARD_INVOICE}
...    Code=HD_TEST_REWARD001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000

# Products with different point settings
&{PRODUCT_WITH_POINT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Point=10

&{PRODUCT_WITHOUT_POINT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    UsePoint=False

# Products with different point settings
&{PRODUCT_WITH_HIGH_POINT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Point=50

&{PRODUCT_WITH_LOW_POINT}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=50000
...    Point=5

# Invoice with invoice reward type
&{INVOICE_REWARD_TYPE}
...    Code=HD_TEST_REWARD002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000

# Invoice with product reward type
&{PRODUCT_REWARD_TYPE}
...    Code=HD_TEST_REWARD003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Product

# Invoice with discount for testing RewardPoint_ForDiscountInvoice
&{INVOICE_WITH_DISCOUNT}
...    Code=HD_TEST_REWARD004
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=90000
...    Discount=10000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000
...    RewardPoint_ForDiscountInvoice=True

# Invoice without discount point award
&{INVOICE_NO_DISCOUNT_POINT}
...    Code=HD_TEST_REWARD005
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=90000
...    Discount=10000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000
...    RewardPoint_ForDiscountInvoice=False

# Reward Point Promotion Data
&{PROMOTION_DONATE_POINT}
...    Id=1001
...    PromotionType=PROMOTION_INVOICE_DONATE_POINT
...    PromotionValue=20

&{PRODUCT_PROMOTION_DONATE_POINT}
...    Id=1002
...    PromotionType=PROMOTION_PRODUCT_DONATE_POINT
...    PromotionValue=5
...    ProductId=${PRODUCT_1}

# Invoice with point promotion
&{INVOICE_WITH_PROMOTION_POINT}
...    Code=HD_TEST_REWARD006
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000

# Product-specific promotion point data
&{INVOICE_WITH_PRODUCT_PROMOTION}
...    Code=HD_TEST_REWARD007
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Product

# Hóa đơn với nhiều sản phẩm khác nhau
@{MIXED_PRODUCT_DETAILS}
...    &{PRODUCT_WITH_POINT}
...    &{PRODUCT_WITHOUT_POINT}

&{INVOICE_WITH_MIXED_PRODUCTS}
...    Code=HD_TEST_REWARD008
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{MIXED_PRODUCT_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=200000
...    RewardPoint_Type=Product

# Invoice without customer ID (should not award points)
&{INVOICE_WITHOUT_CUSTOMER}
...    Code=HD_TEST_REWARD009
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=0
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000

# Invoice using reward points for payment
@{POINT_PAYMENT}
...    &{POINT_PAYMENT_DETAILS}

&{POINT_PAYMENT_DETAILS}
...    Method=Point
...    Amount=20000

&{INVOICE_WITH_POINT_PAYMENT}
...    Code=HD_TEST_REWARD010
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000
...    RewardPoint_ForInvoiceUsingRewardPoint=True

# Invoice using voucher
@{VOUCHER_PAYMENT}
...    &{VOUCHER_PAYMENT_DETAILS}

&{VOUCHER_PAYMENT_DETAILS}
...    Method=Voucher
...    Amount=20000
...    VoucherId=1001

&{INVOICE_WITH_VOUCHER}
...    Code=HD_TEST_REWARD011
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000
...    RewardPoint_ForInvoiceUsingVoucher=True

# Invoice with surcharge and tax
&{INVOICE_WITH_SURCHARGE_TAX}
...    Code=HD_TEST_REWARD012
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=115000
...    Surcharge=5000
...    TotalTax=10000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=10000

# Custom customer group with special point ratio
&{INVOICE_WITH_CUSTOMER_GROUP}
...    Code=HD_TEST_REWARD013
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Invoice
...    MoneyPerPoint=5000    # 5000 VND = 1 point (double points for VIP customers)
...    CustomerGroupId=1001

# Invoice with both invoice and product promotion
&{INVOICE_WITH_BOTH_PROMOTIONS}
...    Code=HD_TEST_REWARD014
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    RewardPoint_Type=Product

# Request templates
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

&{INVOICE_REWARD_TYPE_REQUEST}
...    Invoice=${INVOICE_REWARD_TYPE}
...    Payments=@{EMPTY}

&{PRODUCT_REWARD_TYPE_REQUEST}
...    Invoice=${PRODUCT_REWARD_TYPE}
...    Payments=@{EMPTY}

&{INVOICE_WITH_DISCOUNT_REQUEST}
...    Invoice=${INVOICE_WITH_DISCOUNT}
...    Payments=@{EMPTY}

&{INVOICE_NO_DISCOUNT_POINT_REQUEST}
...    Invoice=${INVOICE_NO_DISCOUNT_POINT}
...    Payments=@{EMPTY}

&{INVOICE_WITH_PROMOTION_POINT_REQUEST}
...    Invoice=${INVOICE_WITH_PROMOTION_POINT}
...    Payments=@{EMPTY}
...    Promotions=&{PROMOTION_DONATE_POINT}

&{INVOICE_WITH_PRODUCT_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_PRODUCT_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=&{PRODUCT_PROMOTION_DONATE_POINT}

&{INVOICE_WITH_MIXED_PRODUCTS_REQUEST}
...    Invoice=${INVOICE_WITH_MIXED_PRODUCTS}
...    Payments=@{EMPTY}

&{INVOICE_WITHOUT_CUSTOMER_REQUEST}
...    Invoice=${INVOICE_WITHOUT_CUSTOMER}
...    Payments=@{EMPTY}

&{INVOICE_WITH_POINT_PAYMENT_REQUEST}
...    Invoice=${INVOICE_WITH_POINT_PAYMENT}
...    Payments=@{POINT_PAYMENT}

&{INVOICE_WITH_VOUCHER_REQUEST}
...    Invoice=${INVOICE_WITH_VOUCHER}
...    Payments=@{VOUCHER_PAYMENT}

&{INVOICE_WITH_SURCHARGE_TAX_REQUEST}
...    Invoice=${INVOICE_WITH_SURCHARGE_TAX}
...    Payments=@{EMPTY}

&{INVOICE_WITH_CUSTOMER_GROUP_REQUEST}
...    Invoice=${INVOICE_WITH_CUSTOMER_GROUP}
...    Payments=@{EMPTY}

&{INVOICE_WITH_BOTH_PROMOTIONS_REQUEST}
...    Invoice=${INVOICE_WITH_BOTH_PROMOTIONS}
...    Payments=@{EMPTY}
...    Promotions=&{PROMOTION_DONATE_POINT}
...    ProductPromotions=&{PRODUCT_PROMOTION_DONATE_POINT} 