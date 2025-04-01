*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

&{STANDARD_INVOICE}
...    Code=HD_TEST_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu cho làm tròn số
&{ROUNDING_UP_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100500
...    Discount=0

&{ROUNDING_DOWN_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100400
...    Discount=0

# Dữ liệu sản phẩm với thuế
&{PRODUCT_WITH_TAX}
...    ProductId=${product_with_vat}
...    Quantity=1
...    Price=100000
...    Discount=0
...    VATRate=${VAT_RATE}

# Dữ liệu khuyến mãi
&{PERCENT_DISCOUNT_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    DiscountRate=10
...    Discount=0

&{FIXED_DISCOUNT_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=10000

&{PROMOTION_INVOICE}
...    Code=HD_TEST_PROMO001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    PromotionId=${VALID_PROMOTION_ID}

# Dữ liệu thanh toán
@{MULTIPLE_PAYMENTS}
...    &{CASH_PAYMENT}
...    &{CARD_PAYMENT}

# Dữ liệu cho cập nhật số lượng tồn kho
&{INVENTORY_UPDATE_PRODUCT}
...    ProductId=${PRODUCT_1}
...    Quantity=5
...    Price=100000
...    Discount=0

# Dữ liệu làm tròn số
&{ROUNDING_UP_INVOICE}
...    Code=HD_TEST_ROUND_UP
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

&{ROUNDING_DOWN_INVOICE}
...    Code=HD_TEST_ROUND_DOWN
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Dữ liệu cho tính thuế
&{TAX_INVOICE}
...    Code=HD_TEST_TAX001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05
...    IsVAT=1

# Dữ liệu cho tính khấu trừ
&{DISCOUNT_INVOICE}
...    Code=HD_TEST_DISC001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05
...    Discount=10000

# Dữ liệu cho tồn kho
&{INVENTORY_INVOICE}
...    Code=HD_TEST_INV001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Dữ liệu khách hàng nợ
&{DEBT_CUSTOMER_INVOICE}
...    Code=HD_TEST_DEBT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu khách hàng nợ vượt hạn mức
&{DEBT_LIMIT_CUSTOMER_INVOICE}
...    Code=HD_TEST_DEBT002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_LIMIT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu khách hàng nợ tắt cảnh báo
&{DEBT_WARNING_OFF_CUSTOMER_INVOICE}
...    Code=HD_TEST_DEBT003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_WARNING_OFF_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu cho sản phẩm combo
&{COMBO_PRODUCT_DETAILS}
...    ProductId=${COMBO_PRODUCT_ID}
...    Quantity=1
...    Price=150000
...    Discount=0

&{COMBO_INVOICE}
...    Code=HD_TEST_COMBO001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Dữ liệu cho điểm thưởng
&{POINT_REWARD_TYPE_INVOICE}
...    Code=HD_TEST_POINT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    RewardPoint_Type=Invoice

&{POINT_REWARD_TYPE_PRODUCT}
...    Code=HD_TEST_POINT002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    RewardPoint_Type=Product

# Dữ liệu thanh toán dư
&{EXCESS_PAYMENT}
...    Method=Cash
...    Amount=200000

&{INVOICE_WITH_EXCESS_PAYMENT}
...    Code=HD_TEST_EXCESS001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    AddToAccountSurplus=1

# Dữ liệu thanh toán tự động phân bổ cho công nợ cũ
&{PAYMENT_ALLOCATION_INVOICE}
...    Code=HD_TEST_ALLOC001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEBT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    AutoPaymentAllocation=true
...    AddToAccount=1

# Dữ liệu thanh toán bằng điểm
&{POINT_PAYMENT}
...    Method=Point
...    Amount=50000
...    PointUsed=50

&{POINT_PAYMENT_INVOICE}
...    Code=HD_TEST_POINTPAY001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    PointToMoney=1000

# Dữ liệu hóa đơn với thông báo Zalo
&{ZALO_NOTIFICATION_INVOICE}
...    Code=HD_TEST_ZALO001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    IsUseZaloSmsConfirmInvoice=true

# Dữ liệu hóa đơn với nhiều loại sản phẩm để tính tổng
@{MULTIPLE_PRODUCTS_DETAILS}
...    &{PRODUCT_1_DETAILS}
...    &{PRODUCT_2_DETAILS}

&{MULTIPLE_PRODUCTS_INVOICE}
...    Code=HD_TEST_MULTI001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    PurchaseDate=2024-05-05

# Template dữ liệu cho request
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

&{ROUNDING_UP_INVOICE_REQUEST}
...    Invoice=${ROUNDING_UP_INVOICE}
...    Payments=@{EMPTY}

&{ROUNDING_DOWN_INVOICE_REQUEST}
...    Invoice=${ROUNDING_DOWN_INVOICE}
...    Payments=@{EMPTY}

&{TAX_INVOICE_REQUEST}
...    Invoice=${TAX_INVOICE}
...    Payments=@{EMPTY}

&{DISCOUNT_INVOICE_REQUEST}
...    Invoice=${DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{PROMOTION_INVOICE_REQUEST}
...    Invoice=${PROMOTION_INVOICE}
...    Payments=@{EMPTY}

&{INVENTORY_INVOICE_REQUEST}
...    Invoice=${INVENTORY_INVOICE}
...    Payments=@{EMPTY}

&{DEBT_CUSTOMER_INVOICE_REQUEST}
...    Invoice=${DEBT_CUSTOMER_INVOICE}
...    Payments=@{EMPTY}

&{DEBT_LIMIT_CUSTOMER_INVOICE_REQUEST}
...    Invoice=${DEBT_LIMIT_CUSTOMER_INVOICE}
...    Payments=@{EMPTY}

&{DEBT_WARNING_OFF_CUSTOMER_INVOICE_REQUEST}
...    Invoice=${DEBT_WARNING_OFF_CUSTOMER_INVOICE}
...    Payments=@{EMPTY}

&{MULTIPLE_PAYMENT_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{MULTIPLE_PAYMENTS}

&{COMBO_INVOICE_REQUEST}
...    Invoice=${COMBO_INVOICE}
...    Payments=@{EMPTY}

&{POINT_REWARD_TYPE_INVOICE_REQUEST}
...    Invoice=${POINT_REWARD_TYPE_INVOICE}
...    Payments=@{EMPTY}

&{POINT_REWARD_TYPE_PRODUCT_REQUEST}
...    Invoice=${POINT_REWARD_TYPE_PRODUCT}
...    Payments=@{EMPTY}

@{POINT_PAYMENT_LIST}
...    &{POINT_PAYMENT}

&{POINT_PAYMENT_INVOICE_REQUEST}
...    Invoice=${POINT_PAYMENT_INVOICE}
...    Payments=@{POINT_PAYMENT_LIST}

@{EXCESS_PAYMENT_LIST}
...    &{EXCESS_PAYMENT}

&{INVOICE_WITH_EXCESS_PAYMENT_REQUEST}
...    Invoice=${INVOICE_WITH_EXCESS_PAYMENT}
...    Payments=@{EXCESS_PAYMENT_LIST}

&{PAYMENT_ALLOCATION_INVOICE_REQUEST}
...    Invoice=${PAYMENT_ALLOCATION_INVOICE}
...    Payments=@{EXCESS_PAYMENT_LIST}

&{ZALO_NOTIFICATION_INVOICE_REQUEST}
...    Invoice=${ZALO_NOTIFICATION_INVOICE}
...    Payments=@{EMPTY}

&{MULTIPLE_PRODUCTS_INVOICE_REQUEST}
...    Invoice=${MULTIPLE_PRODUCTS_INVOICE}
...    Payments=@{EMPTY} 