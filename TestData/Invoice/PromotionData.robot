*** Settings ***
Resource    ../CommonData.robot

*** Variables ***
# ==========================================
# Dữ liệu cơ bản cho hóa đơn khuyến mãi
# ==========================================
@{STANDARD_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}

&{STANDARD_INVOICE}
...    Code=HD_TEST_PROMO001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    Total=100000

# ==========================================
# Loại khuyến mãi
# ==========================================
${PROMOTION_TYPE_FIXED_AMOUNT}        1    # Giảm giá cố định
${PROMOTION_TYPE_PERCENTAGE}          2    # Giảm giá phần trăm
${PROMOTION_TYPE_BUY_X_GET_Y}         3    # Mua X tặng Y
${PROMOTION_TYPE_INVOICE_POINTS}      4    # Tặng điểm theo hóa đơn
${PROMOTION_TYPE_PRODUCT_POINTS}      5    # Tặng điểm theo sản phẩm
${PROMOTION_TYPE_PRODUCT_GIFT}        6    # Tặng sản phẩm
${PROMOTION_TYPE_VOUCHER_GIFT}        7    # Tặng voucher

# ==========================================
# Dữ liệu khuyến mãi giảm giá cố định
# ==========================================
&{FIXED_AMOUNT_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Discount=10000
...    PromotionInfo=Chương trình khuyến mại giảm giá hóa đơn VNĐ

&{INVOICE_WITH_FIXED_PROMOTION}
...    Code=HD_TEST_PROMO_FIXED_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=15000

# ==========================================
# Dữ liệu khuyến mãi giảm giá phần trăm
# ==========================================
&{PERCENTAGE_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_PERCENTAGE}
...    Value=10
...    Name=Khuyến mãi giảm 10%
...    MinSubtotalCondition=0
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    MaxDiscountValue=50000
...    IsActive=True

&{INVOICE_WITH_PERCENTAGE_PROMOTION}
...    Code=HD_TEST_PROMO_PERCENT_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=10000

# ==========================================
# Dữ liệu khuyến mãi có điều kiện tổng tiền tối thiểu
# ==========================================
&{MIN_SUBTOTAL_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=20000
...    Name=Khuyến mãi giảm 20.000đ cho hóa đơn từ 200.000đ
...    MinSubtotalCondition=200000
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    IsActive=True

&{INVOICE_WITH_MIN_SUBTOTAL_PROMOTION}
...    Code=HD_TEST_PROMO_MIN_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=200000
...    SubTotal=200000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=20000

# ==========================================
# Dữ liệu khuyến mãi cho nhóm khách hàng cụ thể
# ==========================================
&{CUSTOMER_GROUP_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=15000
...    Name=Khuyến mãi giảm 15.000đ cho khách hàng VIP
...    MinSubtotalCondition=0
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    CustomerGroupIds=1001
...    IsActive=True

&{INVOICE_WITH_CUSTOMER_GROUP_PROMOTION}
...    Code=HD_TEST_PROMO_GROUP_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    CustomerGroupId=1001
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=15000

# ==========================================
# Dữ liệu khuyến mãi theo sản phẩm
# ==========================================
&{PRODUCT_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT
...    Value=10000
...    Name=Khuyến mãi giảm 10.000đ cho sản phẩm
...    ApplyForProductIds=${PRODUCT_1}
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    IsActive=True

&{INVOICE_WITH_PRODUCT_PROMOTION}
...    Code=HD_TEST_PROMO_PRODUCT_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=90000

&{INVOICE_DETAIL_PROMOTION}
...    Type=PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT
...    Value=10000
...    InvoiceDetailId=1
...    ProductId=${PRODUCT_1}

# ==========================================
# Dữ liệu khuyến mãi mua X tặng Y
# ==========================================
&{BUY_X_GET_Y_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_BUY_X_GET_Y}
...    Value=1
...    Name=Mua 2 tặng 1
...    MinQuantityCondition=2
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    ProductIds=${PRODUCT_1}
...    IsActive=True

&{PRODUCT_BUY_X_GET_Y}
...    ProductId=${PRODUCT_1}
...    Quantity=3
...    Price=100000
...    Discount=100000    # Miễn phí cho sản phẩm thứ 3

@{BUY_X_GET_Y_DETAILS}
...    &{PRODUCT_BUY_X_GET_Y}

&{INVOICE_WITH_BUY_X_GET_Y_PROMOTION}
...    Code=HD_TEST_PROMO_BUYXGETY_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{BUY_X_GET_Y_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=200000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=100000

# ==========================================
# Dữ liệu khuyến mãi tặng sản phẩm
# ==========================================
&{PRODUCT_GIFT_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_PRODUCT_GIFT}
...    Name=Khuyến mãi tặng sản phẩm
...    GiftType=Product
...    GiftProductId=${PRODUCT_2}
...    GiftQuantity=1
...    MinSubtotalCondition=100000
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    IsActive=True

&{GIFT_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=0
...    Note=Quà tặng từ khuyến mãi
...    SalePromotionId=${VALID_PROMOTION_ID}

@{GIFT_INVOICE_DETAILS}
...    &{PRODUCT_1_DETAILS}
...    &{GIFT_PRODUCT_DETAIL}

&{INVOICE_WITH_PRODUCT_GIFT_PROMOTION}
...    Code=HD_TEST_PROMO_GIFT_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{GIFT_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    PromotionId=${VALID_PROMOTION_ID}

# ==========================================
# Dữ liệu khuyến mãi tặng voucher
# ==========================================
&{VOUCHER_GIFT_PROMOTION}
...    Id=${VALID_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_VOUCHER_GIFT}
...    Name=Khuyến mãi tặng voucher
...    GiftType=Voucher
...    VoucherValue=50000
...    VoucherQuantity=1
...    VoucherExpiredDays=30
...    MinSubtotalCondition=100000
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=1
...    IsActive=True

&{INVOICE_WITH_VOUCHER_GIFT_PROMOTION}
...    Code=HD_TEST_PROMO_VOUCHER_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=100000
...    PromotionId=${VALID_PROMOTION_ID}

# ==========================================
# Dữ liệu khuyến mãi khi áp dụng nhiều khuyến mãi
# ==========================================
&{MULTIPLE_PROMOTIONS_INVOICE}
...    Code=HD_TEST_PROMO_MULTI_001
...    BranchId=${BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    InvoiceDetails=@{STANDARD_INVOICE_DETAILS}
...    PurchaseDate=2024-05-05
...    Total=80000
...    PromotionId=${VALID_PROMOTION_ID}
...    DiscountByPromotion=20000

&{PROMOTION_1}
...    Id=${promotion_1}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=10000
...    ApplyForProductIds=${PRODUCT_1}

&{PROMOTION_2}
...    Id=${promotion_2}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=10000
...    ApplyForProductIds=${PRODUCT_1}

# ==========================================
# Dữ liệu khuyến mãi hết hạn và không hoạt động
# ==========================================
&{EXPIRED_PROMOTION}
...    Id=${EXPIRED_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=15000
...    Name=Khuyến mãi đã hết hạn
...    StartDate=2022-01-01
...    EndDate=2022-12-31
...    Status=1
...    IsActive=True

&{INACTIVE_PROMOTION}
...    Id=${INACTIVE_PROMOTION_ID}
...    Type=${PROMOTION_TYPE_FIXED_AMOUNT}
...    Value=15000
...    Name=Khuyến mãi không hoạt động
...    StartDate=${PAST_DATE}
...    EndDate=${FUTURE_DATE}
...    Status=0
...    IsActive=False

# ==========================================
# Request templates
# ==========================================
&{FIXED_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_FIXED_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${FIXED_AMOUNT_PROMOTION}

&{PERCENTAGE_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_PERCENTAGE_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${PERCENTAGE_PROMOTION}

&{MIN_SUBTOTAL_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_MIN_SUBTOTAL_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${MIN_SUBTOTAL_PROMOTION}

&{CUSTOMER_GROUP_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_CUSTOMER_GROUP_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${CUSTOMER_GROUP_PROMOTION}

&{PRODUCT_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_PRODUCT_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${PRODUCT_PROMOTION}

&{BUY_X_GET_Y_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_BUY_X_GET_Y_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${BUY_X_GET_Y_PROMOTION}

&{PRODUCT_GIFT_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_PRODUCT_GIFT_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${PRODUCT_GIFT_PROMOTION}

&{VOUCHER_GIFT_PROMOTION_REQUEST}
...    Invoice=${INVOICE_WITH_VOUCHER_GIFT_PROMOTION}
...    Payments=@{EMPTY}
...    Promotions=${VOUCHER_GIFT_PROMOTION}

&{MULTIPLE_PROMOTIONS_REQUEST}
...    Invoice=${MULTIPLE_PROMOTIONS_INVOICE}
...    Payments=@{EMPTY}
...    Promotions=@{EMPTY} 