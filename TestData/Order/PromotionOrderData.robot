*** Settings ***
Resource    ../CommonData.robot
Resource    ../../Config/Env_api.robot

*** Variables ***
# Dữ liệu test cho chức năng xử lý khuyến mãi trong đơn hàng

# Cấu trúc request cơ bản cho đơn hàng có khuyến mãi
&{BASE_PROMOTION_ORDER_REQUEST}    
...    Order=&{PROMOTION_ORDER_DATA}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}
...    IsCombine=${FALSE}
...    FromManager=${FALSE}

# Dữ liệu đơn hàng có khuyến mãi cơ bản
&{PROMOTION_ORDER_DATA}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có khuyến mãi
...    Total=0
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    Discount=0
...    DiscountRatio=0
...    Surcharge=0
...    OrderDetails=@{PROMOTION_PRODUCT_DETAILS}
...    OrderPromotions=@{VALID_ORDER_PROMOTIONS}
...    Payments=@{EMPTY}

# Chi tiết sản phẩm có khuyến mãi
&{PROMOTION_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_ID_PROMOTION}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Note=${EMPTY}

@{PROMOTION_PRODUCT_DETAILS}    &{PROMOTION_PRODUCT_DETAIL}

# Khuyến mãi hợp lệ
&{VALID_ORDER_PROMOTION}
...    Id=0
...    PromotionId=${VALID_PROMOTION_ID}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=1
...    Value=10000
...    DiscountRatio=10
...    Description=Khuyến mãi hợp lệ
...    PromotionInfo=Khuyến mãi giảm giá: Giảm 10%

@{VALID_ORDER_PROMOTIONS}    &{VALID_ORDER_PROMOTION}

# Khuyến mãi đã bị xóa
&{DELETED_ORDER_PROMOTION}
...    Id=0
...    PromotionId=${DELETE_PROMOTION_ID}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=1
...    Value=10000
...    DiscountRatio=10
...    Description=Khuyến mãi đã bị xóa
...    PromotionInfo=${DELETE_PROMOTION_NAME}: Giảm 10%

@{DELETED_ORDER_PROMOTIONS}    &{DELETED_ORDER_PROMOTION}

# Nhiều khuyến mãi hợp lệ
&{SECOND_VALID_PROMOTION}
...    Id=0
...    PromotionId=${PROMOTION_ID_PERCENTAGE}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=2
...    Value=5000
...    DiscountRatio=5
...    Description=Khuyến mãi phần trăm
...    PromotionInfo=Khuyến mãi phần trăm: Giảm 5%

@{MULTIPLE_VALID_PROMOTIONS}    &{VALID_ORDER_PROMOTION}    &{SECOND_VALID_PROMOTION}

# Khuyến mãi cho nhóm khách hàng
&{CUSTOMER_GROUP_PROMOTION}
...    Id=0
...    PromotionId=${PROMOTION_ID_GROUP_CUSTOMER}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=3
...    Value=15000
...    DiscountRatio=15
...    Description=Khuyến mãi nhóm khách hàng
...    PromotionInfo=Khuyến mãi nhóm khách hàng: Giảm 15%

@{CUSTOMER_GROUP_PROMOTIONS}    &{CUSTOMER_GROUP_PROMOTION}

# Sản phẩm khuyến mãi (có thể trùng ProductId)
&{DUPLICATE_PROMOTION_PRODUCT}
...    ProductId=${PRODUCT_ID_PROMOTION}
...    Quantity=1
...    Price=50000
...    Total=50000
...    Discount=0
...    DiscountRatio=0
...    SalePromotionId=${PROMOTION_GIFT_ID}
...    Note=Sản phẩm khuyến mãi

@{PROMOTION_PRODUCTS_WITH_DUPLICATE}    &{PROMOTION_PRODUCT_DETAIL}    &{DUPLICATE_PROMOTION_PRODUCT}

# Đơn hàng có chiết khấu và phụ thu
&{ORDER_WITH_DISCOUNT_SURCHARGE}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có chiết khấu và phụ thu
...    Total=0
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    Discount=20000
...    DiscountRatio=0
...    Surcharge=5000
...    OrderDetails=@{PROMOTION_PRODUCT_DETAILS}
...    OrderPromotions=@{VALID_ORDER_PROMOTIONS}
...    Payments=@{EMPTY}

# Đơn hàng có tổng tiền = 0 (cần tính toán lại)
&{ORDER_WITH_ZERO_TOTAL}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng cần tính toán lại tổng tiền
...    Total=0
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${DEFAULT_USER_ID}
...    Discount=10000
...    DiscountRatio=0
...    Surcharge=2000
...    OrderDetails=@{PROMOTION_PRODUCT_DETAILS}
...    OrderPromotions=@{VALID_ORDER_PROMOTIONS}
...    Payments=@{EMPTY}

# Khuyến mãi không hợp lệ (PromotionId null)
&{INVALID_PROMOTION_NULL_ID}
...    Id=0
...    PromotionId=${NULL}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=1
...    Value=10000
...    DiscountRatio=10
...    Description=Khuyến mãi không hợp lệ
...    PromotionInfo=Khuyến mãi không hợp lệ

@{INVALID_PROMOTIONS_NULL_ID}    &{INVALID_PROMOTION_NULL_ID}

# Khuyến mãi hết hạn
&{EXPIRED_PROMOTION}
...    Id=0
...    PromotionId=${EXPIRED_PROMOTION_ID}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=1
...    Value=10000
...    DiscountRatio=10
...    Description=Khuyến mãi hết hạn
...    PromotionInfo=Khuyến mãi hết hạn: Giảm 10%

@{EXPIRED_PROMOTIONS}    &{EXPIRED_PROMOTION}

# Khuyến mãi không hoạt động
&{INACTIVE_PROMOTION}
...    Id=0
...    PromotionId=${INACTIVE_PROMOTION_ID}
...    SalePromotionId=${VALID_PROMOTION_SALE_ID}
...    Type=1
...    Value=10000
...    DiscountRatio=10
...    Description=Khuyến mãi không hoạt động
...    PromotionInfo=Khuyến mãi không hoạt động: Giảm 10%

@{INACTIVE_PROMOTIONS}    &{INACTIVE_PROMOTION}

# Dữ liệu cho test tính toán làm tròn tiền tệ
${DECIMAL_DISCOUNT_AMOUNT}    15.67
${DECIMAL_SURCHARGE_AMOUNT}    8.33
${DECIMAL_PRODUCT_PRICE}    99.99

# Dữ liệu cho test PromotionInfo với định dạng đặc biệt
${COMPLEX_PROMOTION_INFO}    Khuyến mãi đặc biệt: Giảm 20% cho đơn hàng trên 500k
${PROMOTION_INFO_WITH_COLON}    Khuyến mãi VIP: Giảm 100k: Áp dụng cho khách hàng VIP
${MALFORMED_PROMOTION_INFO}    Khuyến mãi không có dấu hai chấm

# Dữ liệu test cho các trường hợp biên
${ZERO_DISCOUNT}    0
${NEGATIVE_DISCOUNT}    -5000
${LARGE_DISCOUNT}    999999999
${ZERO_SURCHARGE}    0
${NEGATIVE_SURCHARGE}    -1000
${LARGE_SURCHARGE}    999999999 