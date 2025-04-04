*** Settings ***
Documentation     Dữ liệu cho test cases tính điểm thưởng hóa đơn
Resource          ../CommonData.robot
Resource          ./CommonInvoiceData.robot

*** Variables ***
# Cấu hình tích điểm thưởng
${REWARD_TYPE_NONE}            0    # Không tích điểm
${REWARD_TYPE_INVOICE}         1    # Tích điểm theo hóa đơn
${REWARD_TYPE_PRODUCT}         2    # Tích điểm theo sản phẩm
${REWARD_POINTS_MONEY_RATIO}   10000    # 10,000đ = 1 điểm

# Template chuẩn cho tích điểm theo hóa đơn
&{STANDARD_INVOICE_REWARD_REQUEST}    
...    Invoice=&{invoice_body}
...    Payments=@{EMPTY}

# Template chuẩn cho tích điểm theo sản phẩm
&{STANDARD_PRODUCT_REWARD_REQUEST}    
...    Invoice=&{invoice_body}
...    Payments=@{EMPTY}

# Template chuẩn cho không tích điểm
&{STANDARD_NO_REWARD_REQUEST}    
...    Invoice=&{invoice_body}
...    Payments=@{EMPTY}

# Template chuẩn cho hóa đơn có khuyến mãi tích điểm
&{STANDARD_PROMOTION_REWARD_REQUEST}    
...    Invoice=&{invoice_body}
...    Payments=@{EMPTY}

# Sản phẩm có tích điểm
&{PRODUCT_WITH_REWARD_POINT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsRewardPoint=${TRUE}
...    RewardPoint=0

# Sản phẩm có điểm cố định
&{PRODUCT_WITH_FIXED_REWARD_POINT}    
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsRewardPoint=${TRUE}
...    RewardPoint=5

# Sản phẩm không tích điểm
&{PRODUCT_WITHOUT_REWARD_POINT}    
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsRewardPoint=${FALSE}
...    RewardPoint=0

# Khuyến mãi tặng điểm theo hóa đơn
&{INVOICE_PROMOTION_POINT_GIFT}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=12    # InvoicePointGift
...    Value=10
...    DiscountQuantity=1
...    SourceId=${VALID_PROMOTION_ID}
...    ProductId=0
...    CustomerGroupId=0

# Khuyến mãi tặng điểm theo sản phẩm
&{PRODUCT_PROMOTION_POINT_GIFT}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=13    # ProductPointGift
...    Value=20
...    DiscountQuantity=1
...    SourceId=${VALID_PROMOTION_ID}
...    ProductId=${PRODUCT_1}
...    CustomerGroupId=0

# Khuyến mãi mua X tặng Y điểm
&{BUY_X_GET_Y_POINT_PROMOTION}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=14    # BuyXGetYPoint
...    Value=30
...    DiscountQuantity=1
...    SourceId=${VALID_PROMOTION_ID}
...    ProductId=${PRODUCT_1}
...    CustomerGroupId=0
...    QuantityX=2
...    ProductIdY=0

# Invoice body với ví dụ cấu hình tích điểm theo hóa đơn
&{invoice_reward_body}    
...    BranchId=${DEFAULT_BRANCH_ID}
...    RetailerId=${RETAILER_ID}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    SoldById=${DEFAULT_USER_ID}
...    SoldBy=&{sold_by_body}
...    Code=HD_REWARD_001
...    Total=100000
...    InvoiceDetails=@{EMPTY}
...    InvoicePromotions=@{EMPTY}
...    Status=3
...    Type=1
...    RewardPointType=${REWARD_TYPE_INVOICE}
...    IsRewardPointUsingPriceAfterDiscount=${TRUE}
...    RewardPoint_MoneyPerPoint=${REWARD_POINTS_MONEY_RATIO}

# Sản phẩm với tích điểm cố định
&{fixed_point_product_detail}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsRewardPoint=${TRUE}
...    RewardPoint=5

# Sản phẩm không tích điểm
&{no_reward_product_detail}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsRewardPoint=${FALSE}
...    RewardPoint=0

# Sản phẩm với giá bằng 0
&{zero_price_product_detail}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=0
...    Discount=0
...    IsRewardPoint=${TRUE}
...    RewardPoint=0

# Phụ phí nhỏ để test làm tròn
&{small_surcharge_detail}
...    SurchargeId=${SURCHARGE_1_ID}
...    Price=5000
...    ValueRatio=0

# Template cho khuyến mãi tích điểm
&{invoice_promotion_point_gift}
...    PromotionId=${VALID_PROMOTION_ID}
...    Type=12    # InvoicePointGift
...    Value=10
...    DiscountQuantity=1
...    SourceId=${VALID_PROMOTION_ID}
...    ProductId=0
...    CustomerGroupId=0 