*** Settings ***
Documentation     Dữ liệu test cho chức năng hoàn thiện đơn hàng
Resource          ../CommonData.robot
Resource          ../../Config/Env_api.robot

*** Variables ***
# =============================================================================
# API Endpoints
# =============================================================================
${COMPLETE_ORDER_ENDPOINT}    orders

# =============================================================================
# SQL Queries cho verification
# =============================================================================
${QUERY_GET_ORDER_BY_ID}                    SELECT Id, Code, Status, Total, CustomerId, SoldById, BranchId, RetailerId, ModifiedDate FROM [Order] WHERE Id = ? AND RetailerId = ?
${QUERY_GET_ORDER_DETAILS_BY_ORDER_ID}      SELECT ProductId, Quantity, Price, Total, Discount FROM OrderDetail WHERE OrderId = ? 
${QUERY_GET_PAYMENTS_BY_ORDER_ID}           SELECT Method, Amount, AccountId FROM Payment WHERE OrderId = ?
${QUERY_GET_DELIVERY_INFO_BY_ORDER_ID}      SELECT ReceiverName, ReceiverPhone, ReceiverAddress, UsingCod FROM DeliveryInfo WHERE OrderId = ?
${QUERY_GET_INVENTORY_BY_PRODUCT_BRANCH}    SELECT OnHand, Available FROM Inventory WHERE ProductId = ? AND BranchId = ? AND RetailerId = ?
${QUERY_GET_CUSTOMER_DEBT}                  SELECT DebtLimit, Debt FROM Customer WHERE Id = ? AND RetailerId = ?

# =============================================================================
# Request Templates cho hoàn thiện đơn hàng
# =============================================================================

# Template cơ bản cho hoàn thiện đơn hàng
&{BASE_COMPLETE_ORDER_REQUEST}
...    Order=&{BASIC_ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng và tạo hóa đơn
&{COMPLETE_AND_MAKE_INVOICE_REQUEST}
...    Order=&{ORDER_FOR_COMPLETION_AND_INVOICE}
...    Complete=${TRUE}
...    MakeInvoice=${TRUE}
...    Amount=300000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng COD
&{COMPLETE_COD_ORDER_REQUEST}
...    Order=&{COD_ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng có thanh toán
&{COMPLETE_ORDER_WITH_PAYMENT_REQUEST}
...    Order=&{ORDER_WITH_PAYMENT_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=250000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng có khuyến mãi
&{COMPLETE_ORDER_WITH_PROMOTION_REQUEST}
...    Order=&{ORDER_WITH_PROMOTION_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng có sản phẩm serial
&{COMPLETE_SERIAL_ORDER_REQUEST}
...    Order=&{SERIAL_ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng có sản phẩm lô
&{COMPLETE_BATCH_ORDER_REQUEST}
...    Order=&{BATCH_ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng có combo
&{COMPLETE_COMBO_ORDER_REQUEST}
...    Order=&{COMBO_ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# =============================================================================
# Order Objects cho các test case
# =============================================================================

# Đơn hàng cơ bản để hoàn thiện
&{BASIC_ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_BASIC_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng cơ bản hoàn thiện
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BASIC_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng để hoàn thiện và tạo hóa đơn
&{ORDER_FOR_COMPLETION_AND_INVOICE}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_INVOICE_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng hoàn thiện và tạo hóa đơn
...    Total=300000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMPLETION_INVOICE_ORDER_DETAILS}
...    Payments=@{COMPLETION_INVOICE_PAYMENTS}

# Đơn hàng COD để hoàn thiện
&{COD_ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_COD_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng COD hoàn thiện
...    Total=150000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    UsingCod=1
...    OrderDetails=@{COD_COMPLETION_ORDER_DETAILS}
...    Payments=@{COD_COMPLETION_PAYMENTS}
...    DeliveryInfo=&{COD_DELIVERY_INFO}

# Đơn hàng có thanh toán để hoàn thiện
&{ORDER_WITH_PAYMENT_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_PAYMENT_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có thanh toán hoàn thiện
...    Total=250000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{PAYMENT_COMPLETION_ORDER_DETAILS}
...    Payments=@{PAYMENT_COMPLETION_PAYMENTS}

# Đơn hàng có khuyến mãi để hoàn thiện
&{ORDER_WITH_PROMOTION_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_PROMOTION_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng có khuyến mãi hoàn thiện
...    Total=180000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=20000
...    DiscountRatio=10
...    OrderDetails=@{PROMOTION_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng có sản phẩm serial để hoàn thiện
&{SERIAL_ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_SERIAL_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm serial hoàn thiện
...    Total=500000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SERIAL_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng có sản phẩm lô để hoàn thiện
&{BATCH_ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_BATCH_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm lô hoàn thiện
...    Total=300000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BATCH_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng có combo để hoàn thiện
&{COMBO_ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_COMBO_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng combo hoàn thiện
...    Total=400000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMBO_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# =============================================================================
# Order Details cho các test case
# =============================================================================

# Chi tiết đơn hàng cơ bản hoàn thiện
&{BASIC_COMPLETION_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm cơ bản hoàn thiện

@{BASIC_COMPLETION_ORDER_DETAILS}    &{BASIC_COMPLETION_DETAIL_1}

# Chi tiết đơn hàng hoàn thiện và tạo hóa đơn
&{COMPLETION_INVOICE_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm hoàn thiện tạo hóa đơn

&{COMPLETION_INVOICE_DETAIL_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm hoàn thiện tạo hóa đơn 2

@{COMPLETION_INVOICE_ORDER_DETAILS}    &{COMPLETION_INVOICE_DETAIL_1}    &{COMPLETION_INVOICE_DETAIL_2}

# Chi tiết đơn hàng COD hoàn thiện
&{COD_COMPLETION_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=150000
...    Total=150000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm COD hoàn thiện

@{COD_COMPLETION_ORDER_DETAILS}    &{COD_COMPLETION_DETAIL_1}

# Chi tiết đơn hàng có thanh toán hoàn thiện
&{PAYMENT_COMPLETION_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm có thanh toán hoàn thiện

&{PAYMENT_COMPLETION_DETAIL_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=50000
...    Total=50000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm có thanh toán hoàn thiện 2

@{PAYMENT_COMPLETION_ORDER_DETAILS}    &{PAYMENT_COMPLETION_DETAIL_1}    &{PAYMENT_COMPLETION_DETAIL_2}

# Chi tiết đơn hàng có khuyến mãi hoàn thiện
&{PROMOTION_COMPLETION_DETAIL_1}
...    ProductId=${PRODUCT_ID_PROMOTION}
...    Quantity=2
...    Price=100000
...    Total=180000
...    Discount=20000
...    DiscountRatio=10
...    Note=Sản phẩm khuyến mãi hoàn thiện

@{PROMOTION_COMPLETION_ORDER_DETAILS}    &{PROMOTION_COMPLETION_DETAIL_1}

# Chi tiết đơn hàng sản phẩm serial hoàn thiện
&{SERIAL_COMPLETION_DETAIL_1}
...    ProductId=${PRODUCT_ID_SERIAL}
...    Quantity=1
...    Price=500000
...    Total=500000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm serial hoàn thiện
...    SerialNumbers=${SERIAL_NUMBER}

@{SERIAL_COMPLETION_ORDER_DETAILS}    &{SERIAL_COMPLETION_DETAIL_1}

# Chi tiết đơn hàng sản phẩm lô hoàn thiện
&{BATCH_COMPLETION_DETAIL_1}
...    ProductId=${product_batch}
...    Quantity=3
...    Price=100000
...    Total=300000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm lô hoàn thiện
...    BatchName=${BATCH_NAME}

@{BATCH_COMPLETION_ORDER_DETAILS}    &{BATCH_COMPLETION_DETAIL_1}

# Chi tiết đơn hàng combo hoàn thiện
&{COMBO_COMPLETION_DETAIL_1}
...    ProductId=${COMBO_PRODUCT_1_ID}
...    Quantity=2
...    Price=200000
...    Total=400000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm combo hoàn thiện

@{COMBO_COMPLETION_ORDER_DETAILS}    &{COMBO_COMPLETION_DETAIL_1}

# =============================================================================
# Payment Details cho các test case
# =============================================================================

# Thanh toán hoàn thiện và tạo hóa đơn
&{COMPLETION_INVOICE_PAYMENT_1}
...    Method=Cash
...    Amount=300000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

@{COMPLETION_INVOICE_PAYMENTS}    &{COMPLETION_INVOICE_PAYMENT_1}

# Thanh toán COD hoàn thiện
&{COD_COMPLETION_PAYMENT_1}
...    Method=COD
...    Amount=150000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

@{COD_COMPLETION_PAYMENTS}    &{COD_COMPLETION_PAYMENT_1}

# Thanh toán có thanh toán hoàn thiện
&{PAYMENT_COMPLETION_PAYMENT_1}
...    Method=Cash
...    Amount=200000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

&{PAYMENT_COMPLETION_PAYMENT_2}
...    Method=Card
...    Amount=50000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

@{PAYMENT_COMPLETION_PAYMENTS}    &{PAYMENT_COMPLETION_PAYMENT_1}    &{PAYMENT_COMPLETION_PAYMENT_2}

# =============================================================================
# Delivery Info cho các test case
# =============================================================================

# Thông tin giao hàng COD
&{COD_DELIVERY_INFO}
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường ABC, Quận 1, TP.HCM
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID_1}
...    DeliveryBy=1
...    UseDefaultPartner=${TRUE}
...    Status=0
...    UsingCod=1
...    DeliveryPrice=${DEFAULT_DELIVERY_PRICE}
...    IsFreeShip=${DEFAULT_IS_FREE_SHIP}
...    Note=${DEFAULT_NOTE}

# =============================================================================
# Error Test Data
# =============================================================================

# Đơn hàng đã hoàn thiện (lỗi)
&{ALREADY_FINALIZED_ORDER_REQUEST}
...    Order=&{ALREADY_FINALIZED_ORDER}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{ALREADY_FINALIZED_ORDER}
...    Id=${FINALIZED_ORDER_ID}
...    Code=DH_ALREADY_FINALIZED
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng đã hoàn thiện
...    Total=100000
...    Status=3
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BASIC_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng không tồn tại (lỗi)
&{NONEXISTENT_ORDER_REQUEST}
...    Order=&{NONEXISTENT_ORDER}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
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
...    OrderDetails=@{BASIC_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng có sản phẩm hết hàng (lỗi)
&{OUT_OF_STOCK_ORDER_REQUEST}
...    Order=&{OUT_OF_STOCK_ORDER}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{OUT_OF_STOCK_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_OUT_OF_STOCK
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm hết hàng
...    Total=999900000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{OUT_OF_STOCK_ORDER_DETAILS}
...    Payments=@{EMPTY}

&{OUT_OF_STOCK_DETAIL}
...    ProductId=${product_out_of_stock}
...    Quantity=999
...    Price=1000000
...    Total=999000000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm hết hàng

@{OUT_OF_STOCK_ORDER_DETAILS}    &{OUT_OF_STOCK_DETAIL}

# Đơn hàng ID không hợp lệ (lỗi)
&{INVALID_ORDER_ID_REQUEST}
...    Order=&{INVALID_ORDER_ID_ORDER}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

&{INVALID_ORDER_ID_ORDER}
...    Id=0
...    Code=DH_INVALID_ID
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng ID không hợp lệ
...    Total=100000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BASIC_COMPLETION_ORDER_DETAILS}
...    Payments=@{EMPTY} 