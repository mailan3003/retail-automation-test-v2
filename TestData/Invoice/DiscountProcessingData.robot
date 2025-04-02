*** Settings ***
Documentation     Dữ liệu cho các test case xử lý giảm giá hóa đơn
Resource          ../CommonData.robot

*** Variables ***
# Cấu hình hệ thống
${CURRENCY_DECIMAL_PLACE}                2
${CURRENCY_DECIMAL_PLACE_FOR_PRODUCT}    4

# Giảm giá cơ bản
${STANDARD_DISCOUNT_AMOUNT}              10000
${STANDARD_DISCOUNT_RATIO}               10
${PROMOTION_DISCOUNT_AMOUNT}             20000

# ID chương trình khuyến mãi
${PROMOTION_ID_1}                        1001
${PROMOTION_ID_2}                        1002
${INVALID_PROMOTION_ID}                  9999

# Giá sản phẩm để tính tỷ lệ giảm
${PRODUCT_PRICE_100K}                    100000
${PRODUCT_PRICE_200K}                    200000

# Dữ liệu hóa đơn chuẩn với giảm giá
&{INVOICE_WITH_DISCOUNT}
...    Code=HD_DISCOUNT_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Discount=${STANDARD_DISCOUNT_AMOUNT}
...    DiscountRatio=${STANDARD_DISCOUNT_RATIO}
...    InvoiceDetails=@{EMPTY}
...    PurchaseDate=2024-05-05

# Dữ liệu hóa đơn với giảm giá khuyến mãi
&{INVOICE_WITH_PROMOTION_DISCOUNT}
...    Code=HD_PROMO_001
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Discount=${PROMOTION_DISCOUNT_AMOUNT}
...    DiscountByPromotion=${PROMOTION_DISCOUNT_AMOUNT}
...    InvoicePromotions=@{EMPTY}
...    InvoiceDetails=@{EMPTY}
...    PurchaseDate=2024-05-05

# Chi tiết hóa đơn dưới dạng dictionary
&{INVOICE_DETAIL_100K}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=${PRODUCT_PRICE_100K}
...    Discount=0

&{INVOICE_DETAIL_200K}    
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=${PRODUCT_PRICE_200K}
...    Discount=0

# Thông tin khuyến mãi
&{PROMOTION_INFO_1}
...    PromotionId=${PROMOTION_ID_1}
...    PromotionName=Khuyến mãi 1
...    DiscountValue=${PROMOTION_DISCOUNT_AMOUNT}

# Yêu cầu chuẩn cho API request với giảm giá thông thường
&{DISCOUNT_INVOICE_REQUEST}
...    Invoice=${INVOICE_WITH_DISCOUNT}
...    Payments=@{EMPTY}

# Yêu cầu chuẩn cho API request với giảm giá từ khuyến mãi
&{PROMOTION_DISCOUNT_INVOICE_REQUEST}
...    Invoice=${INVOICE_WITH_PROMOTION_DISCOUNT}
...    Payments=@{EMPTY} 