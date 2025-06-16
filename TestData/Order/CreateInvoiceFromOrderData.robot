*** Settings ***
Documentation     Dữ liệu test cho chức năng tạo hóa đơn từ đơn đặt hàng
Resource          ../CommonData.robot
Resource          ../Invoice/CommonInvoiceData.robot
Resource          ../../Config/Env_${ENV}.robot

*** Variables ***
# =============================================================================
# API Endpoints
# =============================================================================
${CREATE_INVOICE_FROM_ORDER_ENDPOINT}    orders

# =============================================================================
# Request Templates cho tạo hóa đơn từ đơn đặt hàng
# =============================================================================

# Template cơ bản cho tạo hóa đơn từ đơn hàng mới
&{BASE_MAKE_INVOICE_REQUEST}
...    Order=&{NEW_ORDER_FOR_INVOICE}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho cập nhật đơn hàng có sẵn và tạo hóa đơn
&{UPDATE_ORDER_MAKE_INVOICE_REQUEST}
...    Order=&{EXISTING_ORDER_FOR_INVOICE}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=150000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với nhiều sản phẩm
&{MULTI_PRODUCT_INVOICE_REQUEST}
...    Order=&{MULTI_PRODUCT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=350000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với khuyến mãi
&{PROMOTION_INVOICE_REQUEST}
...    Order=&{PROMOTION_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=180000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn COD
&{COD_INVOICE_REQUEST}
...    Order=&{COD_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=200000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với sản phẩm serial
&{SERIAL_PRODUCT_INVOICE_REQUEST}
...    Order=&{SERIAL_PRODUCT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=500000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với sản phẩm batch
&{BATCH_PRODUCT_INVOICE_REQUEST}
...    Order=&{BATCH_PRODUCT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=300000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với VAT
&{VAT_INVOICE_REQUEST}
...    Order=&{VAT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=110000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với combo sản phẩm
&{COMBO_PRODUCT_INVOICE_REQUEST}
...    Order=&{COMBO_PRODUCT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=250000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn với điểm tích lũy
&{REWARD_POINT_INVOICE_REQUEST}
...    Order=&{REWARD_POINT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=400000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# =============================================================================
# Order Objects cho các test case thành công
# =============================================================================

# Đơn hàng mới để tạo hóa đơn
&{NEW_ORDER_FOR_INVOICE}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng mới tạo hóa đơn
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SINGLE_PRODUCT_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

# Đơn hàng có sẵn để tạo hóa đơn
&{EXISTING_ORDER_FOR_INVOICE}
...    Id=${ORDER_ID}
...    Code=DH_EXISTING_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có sẵn tạo hóa đơn
...    Total=150000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{EXISTING_ORDER_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

# Đơn hàng với nhiều sản phẩm
&{MULTI_PRODUCT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng nhiều sản phẩm
...    Total=350000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{MULTI_PRODUCT_DETAILS}
...    Payments=@{MULTI_PAYMENT_LIST}

# Đơn hàng với khuyến mãi
&{PROMOTION_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có khuyến mãi
...    Total=180000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=20000
...    DiscountRatio=10
...    OrderDetails=@{PROMOTION_PRODUCT_DETAILS}
...    Payments=@{PROMOTION_PAYMENT_LIST}
...    Promotions=@{PROMOTION_LIST}

# Đơn hàng COD
&{COD_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng COD
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    UsingCod=1
...    OrderDetails=@{COD_PRODUCT_DETAILS}
...    Payments=@{COD_PAYMENT_LIST}
...    DeliveryDetail=&{COD_DELIVERY_INFO}

# Đơn hàng với sản phẩm serial
&{SERIAL_PRODUCT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm serial
...    Total=500000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SERIAL_PRODUCT_DETAILS}
...    Payments=@{SERIAL_PAYMENT_LIST}

# Đơn hàng với sản phẩm batch
&{BATCH_PRODUCT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm batch
...    Total=300000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BATCH_PRODUCT_DETAILS}
...    Payments=@{BATCH_PAYMENT_LIST}

# Đơn hàng với VAT
&{VAT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có VAT
...    Total=110000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{VAT_PRODUCT_DETAILS}
...    Payments=@{VAT_PAYMENT_LIST}

# Đơn hàng với combo sản phẩm
&{COMBO_PRODUCT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng combo sản phẩm
...    Total=250000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMBO_PRODUCT_DETAILS}
...    Payments=@{COMBO_PAYMENT_LIST}

# Đơn hàng với điểm tích lũy
&{REWARD_POINT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${CUSTOMER_ID_REWARD_POINT}
...    Description=Đơn hàng tích điểm
...    Total=400000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{REWARD_POINT_PRODUCT_DETAILS}
...    Payments=@{REWARD_POINT_PAYMENT_LIST}

# =============================================================================
# Order Details cho các test case
# =============================================================================

# Chi tiết đơn hàng đơn sản phẩm
&{SINGLE_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{SINGLE_PRODUCT_DETAILS}    &{SINGLE_PRODUCT_DETAIL}

# Chi tiết đơn hàng có sẵn
&{EXISTING_ORDER_DETAIL}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=150000
...    Total=150000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{EXISTING_ORDER_DETAILS}    &{EXISTING_ORDER_DETAIL}

# Chi tiết đơn hàng nhiều sản phẩm
&{MULTI_PRODUCT_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

&{MULTI_PRODUCT_DETAIL_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=150000
...    Total=150000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{MULTI_PRODUCT_DETAILS}    &{MULTI_PRODUCT_DETAIL_1}    &{MULTI_PRODUCT_DETAIL_2}

# Chi tiết đơn hàng khuyến mãi
&{PROMOTION_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_ID_PROMOTION}
...    Quantity=1
...    Price=200000
...    Total=180000
...    Discount=20000
...    DiscountRatio=10
...    Note=${EMPTY}

@{PROMOTION_PRODUCT_DETAILS}    &{PROMOTION_PRODUCT_DETAIL}

# Chi tiết đơn hàng COD
&{COD_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{COD_PRODUCT_DETAILS}    &{COD_PRODUCT_DETAIL}

# Chi tiết đơn hàng sản phẩm serial
&{SERIAL_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_ID_SERIAL}
...    Quantity=1
...    Price=500000
...    Total=500000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}
...    SerialNumbers=${SERIAL_NUMBER}

@{SERIAL_PRODUCT_DETAILS}    &{SERIAL_PRODUCT_DETAIL}

# Chi tiết đơn hàng sản phẩm batch
&{BATCH_PRODUCT_DETAIL}
...    ProductId=${product_batch}
...    Quantity=1
...    Price=300000
...    Total=300000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}
...    BatchName=${BATCH_NAME}

@{BATCH_PRODUCT_DETAILS}    &{BATCH_PRODUCT_DETAIL}

# Chi tiết đơn hàng VAT
&{VAT_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_WITH_VAT_1_ID}
...    Quantity=1
...    Price=100000
...    Total=110000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}
...    TaxDetails=@{VAT_TAX_DETAILS}

@{VAT_PRODUCT_DETAILS}    &{VAT_PRODUCT_DETAIL}

# Chi tiết đơn hàng combo
&{COMBO_PRODUCT_DETAIL}
...    ProductId=${COMBO_PRODUCT_1_ID}
...    Quantity=1
...    Price=250000
...    Total=250000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{COMBO_PRODUCT_DETAILS}    &{COMBO_PRODUCT_DETAIL}

# Chi tiết đơn hàng điểm tích lũy
&{REWARD_POINT_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_ID_REWARD_POINT}
...    Quantity=1
...    Price=400000
...    Total=400000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{REWARD_POINT_PRODUCT_DETAILS}    &{REWARD_POINT_PRODUCT_DETAIL}

# =============================================================================
# Payment Lists cho các test case
# =============================================================================

# Thanh toán tiền mặt cơ bản
&{CASH_PAYMENT_BASIC}
...    Method=Cash
...    Amount=100000

@{CASH_PAYMENT_LIST}    &{CASH_PAYMENT_BASIC}

# Thanh toán cho nhiều sản phẩm
&{MULTI_PAYMENT_CASH}
...    Method=Cash
...    Amount=350000

@{MULTI_PAYMENT_LIST}    &{MULTI_PAYMENT_CASH}

# Thanh toán cho khuyến mãi
&{PROMOTION_PAYMENT}
...    Method=Cash
...    Amount=180000

@{PROMOTION_PAYMENT_LIST}    &{PROMOTION_PAYMENT}

# Thanh toán COD
&{COD_PAYMENT}
...    Method=COD
...    Amount=200000

@{COD_PAYMENT_LIST}    &{COD_PAYMENT}

# Thanh toán sản phẩm serial
&{SERIAL_PAYMENT}
...    Method=Cash
...    Amount=500000

@{SERIAL_PAYMENT_LIST}    &{SERIAL_PAYMENT}

# Thanh toán sản phẩm batch
&{BATCH_PAYMENT}
...    Method=Cash
...    Amount=300000

@{BATCH_PAYMENT_LIST}    &{BATCH_PAYMENT}

# Thanh toán VAT
&{VAT_PAYMENT}
...    Method=Cash
...    Amount=110000

@{VAT_PAYMENT_LIST}    &{VAT_PAYMENT}

# Thanh toán combo
&{COMBO_PAYMENT}
...    Method=Cash
...    Amount=250000

@{COMBO_PAYMENT_LIST}    &{COMBO_PAYMENT}

# Thanh toán điểm tích lũy
&{REWARD_POINT_PAYMENT}
...    Method=Cash
...    Amount=400000

@{REWARD_POINT_PAYMENT_LIST}    &{REWARD_POINT_PAYMENT}

# =============================================================================
# Delivery Info cho COD
# =============================================================================

&{COD_DELIVERY_INFO}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường ABC, Quận 1
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    Status=1
...    DeliveryMethod=1
...    PartnerDeliveryId=${PARTNER_DELIVERY_1_ID}
...    UseDefaultPartner=${TRUE}

# =============================================================================
# Promotion Lists
# =============================================================================

&{PROMOTION_DETAIL}
...    PromotionId=${PROMOTION_ID_DISCOUNT_PRODUCT}
...    Type=1
...    Value=20000
...    Description=Khuyến mãi giảm giá sản phẩm

@{PROMOTION_LIST}    &{PROMOTION_DETAIL}

# =============================================================================
# Tax Details
# =============================================================================

&{VAT_TAX_DETAIL}
...    TaxId=${TAX_1_ID}
...    TaxType=1
...    TaxPercentage=${DEFAULT_TAX_RATE}

@{VAT_TAX_DETAILS}    &{VAT_TAX_DETAIL}

# =============================================================================
# Error Test Data Templates
# =============================================================================

# Template cho đơn hàng không tồn tại
&{NONEXISTENT_ORDER_REQUEST}
...    Order=&{NONEXISTENT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{NONEXISTENT_ORDER}
...    Id=${NONEXISTENT_ORDER_ID}
...    Code=DH_NONEXISTENT
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng không tồn tại
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SINGLE_PRODUCT_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

# Template cho đơn hàng đã hoàn thành
&{FINALIZED_ORDER_REQUEST}
...    Order=&{FINALIZED_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{FINALIZED_ORDER}
...    Id=${FINALIZED_ORDER_ID}
...    Code=DH_FINALIZED
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng đã hoàn thành
...    Total=100000
...    Status=3
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SINGLE_PRODUCT_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

# Template cho sản phẩm không hoạt động
&{INACTIVE_PRODUCT_REQUEST}
...    Order=&{INACTIVE_PRODUCT_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{INACTIVE_PRODUCT_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm không hoạt động
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{INACTIVE_PRODUCT_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

&{INACTIVE_PRODUCT_DETAIL}
...    ProductId=${INACTIVE_PRODUCT_ID}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{INACTIVE_PRODUCT_DETAILS}    &{INACTIVE_PRODUCT_DETAIL}

# Template cho sản phẩm hết hàng
&{OUT_OF_STOCK_REQUEST}
...    Order=&{OUT_OF_STOCK_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{OUT_OF_STOCK_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm hết hàng
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{OUT_OF_STOCK_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

&{OUT_OF_STOCK_DETAIL}
...    ProductId=${product_out_of_stock}
...    Quantity=999
...    Price=100000
...    Total=99900000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}

@{OUT_OF_STOCK_DETAILS}    &{OUT_OF_STOCK_DETAIL}

# Template cho khách hàng không tồn tại
&{INVALID_CUSTOMER_REQUEST}
...    Order=&{INVALID_CUSTOMER_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{INVALID_CUSTOMER_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${NONEXISTENT_CUSTOMER_ID}
...    Description=Đơn hàng khách hàng không tồn tại
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SINGLE_PRODUCT_DETAILS}
...    Payments=@{CASH_PAYMENT_LIST}

# Template cho số tiền thanh toán không hợp lệ
&{INVALID_AMOUNT_REQUEST}
...    Order=&{NEW_ORDER_FOR_INVOICE}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=-100000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho đơn hàng không có sản phẩm
&{EMPTY_PRODUCTS_REQUEST}
...    Order=&{EMPTY_PRODUCTS_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{EMPTY_PRODUCTS_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng không có sản phẩm
...    Total=0
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{EMPTY}
...    Payments=@{EMPTY}

# Template cho serial không khả dụng
&{UNAVAILABLE_SERIAL_REQUEST}
...    Order=&{UNAVAILABLE_SERIAL_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=500000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{UNAVAILABLE_SERIAL_ORDER}
...    Id=0
...    Code=${EMPTY}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng serial không khả dụng
...    Total=500000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UNAVAILABLE_SERIAL_DETAILS}
...    Payments=@{SERIAL_PAYMENT_LIST}

&{UNAVAILABLE_SERIAL_DETAIL}
...    ProductId=${PRODUCT_ID_SERIAL}
...    Quantity=1
...    Price=500000
...    Total=500000
...    Discount=0
...    DiscountRatio=0
...    Note=${EMPTY}
...    SerialNumbers=UNAVAILABLE_SERIAL_001

@{UNAVAILABLE_SERIAL_DETAILS}    &{UNAVAILABLE_SERIAL_DETAIL}

# =============================================================================
# SQL Queries cho verification
# =============================================================================

${QUERY_GET_ORDER_BY_ID}    SELECT * FROM [Order] WHERE Id = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_INVOICE_BY_ORDER_ID}    SELECT * FROM Invoice WHERE OrderId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_ORDER_DETAILS}    SELECT * FROM OrderDetail WHERE OrderId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_INVOICE_DETAILS}    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_PAYMENTS_BY_ORDER}    SELECT * FROM Payment WHERE OrderId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_PAYMENTS_BY_INVOICE}    SELECT * FROM Payment WHERE InvoiceId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_DELIVERY_INFO}    SELECT * FROM DeliveryInfo WHERE InvoiceId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_PROMOTION_USAGE}    SELECT * FROM PromotionUsage WHERE InvoiceId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_CUSTOMER_REWARD_POINT}    SELECT RewardPoint FROM Customer WHERE Id = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_PRODUCT_ONHAND}    SELECT OnHand FROM ProductBranch WHERE ProductId = ? AND BranchId = ? AND RetailerId = ${RETAILER_ID}
${QUERY_GET_SERIAL_TRACKING}    SELECT * FROM ImeiTracking WHERE ProductId = ? AND Serial = ? AND RetailerId = ${RETAILER_ID} ORDER BY TransDate DESC
${QUERY_GET_BATCH_TRACKING}    SELECT * FROM BatchExpireTracking WHERE ProductId = ? AND BatchName = ? AND RetailerId = ${RETAILER_ID} ORDER BY TransDate DESC 