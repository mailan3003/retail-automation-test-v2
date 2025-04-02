*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# Dữ liệu hóa đơn chuẩn
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

&{STANDARD_INVOICE}
...    Code=HD_TEST_DISC001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu chiết khấu cố định
&{FIXED_DISCOUNT_INVOICE}
...    Code=HD_TEST_FIXED001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Discount=10000
...    DiscountRatio=0

# Dữ liệu chiết khấu theo phần trăm
&{PERCENT_DISCOUNT_INVOICE}
...    Code=HD_TEST_PERCENT001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Discount=0
...    DiscountRatio=10

# Dữ liệu khuyến mãi hóa đơn
&{PROMOTION_INVOICE}
...    Code=HD_TEST_PROMO001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    DiscountByPromotion=15000

# Dữ liệu voucher
&{VOUCHER_DISCOUNT_INVOICE}
...    Code=HD_TEST_VOUCHER001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    DiscountByCoupon=20000

# Dữ liệu sản phẩm với chiết khấu
&{PRODUCT_WITH_DISCOUNT}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=10000

&{PRODUCT_WITH_DISCOUNT_RATE}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    DiscountRatio=10
...    Discount=0

# Dữ liệu chiết khấu kết hợp
&{COMBINED_DISCOUNT_INVOICE}
...    Code=HD_TEST_COMBINED001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Discount=10000
...    DiscountByPromotion=5000
...    DiscountByCoupon=5000

# Dữ liệu voucher không cho phép kết hợp
&{NON_COMBINABLE_VOUCHER_INVOICE}
...    Code=HD_TEST_VOUCHER002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    DiscountByCoupon=20000
...    AllowMergeCouponWithOtherPromotion=0
...    PromotionId=${VALID_PROMOTION_ID}

# Dữ liệu khuyến mãi giảm giá sản phẩm
&{PROMOTION_ON_PRODUCT_INVOICE}
...    Code=HD_TEST_PROMO_PROD001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05

# Dữ liệu giảm giá tối đa cho voucher
&{VOUCHER_MAX_DISCOUNT_INVOICE}
...    Code=HD_TEST_VOUCHER003
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    DiscountByCoupon=15000
...    VoucherMaxDiscount=15000

# Dữ liệu chiết khấu làm tròn
&{ROUNDING_DISCOUNT_INVOICE}
...    Code=HD_TEST_ROUNDING001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Discount=10500
...    DiscountRatio=0

# Dữ liệu giảm giá phần trăm với cấu hình làm tròn
&{ROUNDING_PERCENT_DISCOUNT_INVOICE}
...    Code=HD_TEST_ROUNDING002
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Discount=0
...    DiscountRatio=12.34

# Dữ liệu cho khuyến mãi theo sản phẩm
&{PRODUCT_PROMOTION}
...    Type=PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT
...    Value=10000
...    ApplyForProductIds=${PRODUCT_1}

# Dữ liệu voucher
&{VOUCHER_DATA}
...    Code=VOUCHER001
...    Value=20000
...    MaxValue=30000
...    Type=1 # Giảm giá cố định
...    AllowMergeWithOtherPromotion=1
...    Status=1
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}

&{VOUCHER_PERCENT_DATA}
...    Code=VOUCHER002
...    Value=10
...    MaxValue=15000
...    Type=2 # Giảm giá phần trăm
...    AllowMergeWithOtherPromotion=1
...    Status=1
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}

&{NON_COMBINABLE_VOUCHER_DATA}
...    Code=VOUCHER003
...    Value=20000
...    MaxValue=30000
...    Type=1
...    AllowMergeWithOtherPromotion=0
...    Status=1
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}

# Template dữ liệu cho request
&{STANDARD_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}

&{FIXED_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${FIXED_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{PERCENT_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${PERCENT_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{PROMOTION_INVOICE_REQUEST}
...    Invoice=${PROMOTION_INVOICE}
...    Payments=@{EMPTY}

&{VOUCHER_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${VOUCHER_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{PRODUCT_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${STANDARD_INVOICE}
...    Payments=@{EMPTY}
...    InvoiceDetails=@{EMPTY}

&{COMBINED_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${COMBINED_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{NON_COMBINABLE_VOUCHER_INVOICE_REQUEST}
...    Invoice=${NON_COMBINABLE_VOUCHER_INVOICE}
...    Payments=@{EMPTY}

&{PROMOTION_ON_PRODUCT_INVOICE_REQUEST}
...    Invoice=${PROMOTION_ON_PRODUCT_INVOICE}
...    Payments=@{EMPTY}
...    Promotions=@{EMPTY}

&{VOUCHER_MAX_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${VOUCHER_MAX_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{ROUNDING_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${ROUNDING_DISCOUNT_INVOICE}
...    Payments=@{EMPTY}

&{ROUNDING_PERCENT_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${ROUNDING_PERCENT_DISCOUNT_INVOICE}
...    Payments=@{EMPTY} 