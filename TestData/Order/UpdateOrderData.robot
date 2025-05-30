*** Settings ***
Documentation     Dữ liệu test cho chức năng cập nhật đơn hàng
Resource          ../CommonData.robot
Resource          ../../Config/Env_api.robot

*** Variables ***
# =============================================================================
# API Endpoints
# =============================================================================
${UPDATE_ORDER_ENDPOINT}    orders

# =============================================================================
# Request Templates cho cập nhật đơn hàng
# =============================================================================

# Template cơ bản cho cập nhật đơn hàng
&{BASE_UPDATE_ORDER_REQUEST}
...    Order=&{EXISTING_ORDER_FOR_UPDATE}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho cập nhật đơn hàng offline
&{OFFLINE_ORDER_UPDATE_REQUEST}
...    Order=&{OFFLINE_ORDER_FOR_UPDATE}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho chuyển chi nhánh đơn hàng
&{BRANCH_TRANSFER_ORDER_REQUEST}
...    Order=&{BRANCH_TRANSFER_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho hoàn thiện đơn hàng
&{COMPLETE_ORDER_REQUEST}
...    Order=&{ORDER_FOR_COMPLETION}
...    Complete=${TRUE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho tạo hóa đơn từ đơn hàng
&{MAKE_INVOICE_FROM_ORDER_REQUEST}
...    Order=&{ORDER_FOR_INVOICE}
...    Complete=${FALSE}
...    MakeInvoice=${TRUE}
...    Amount=200000
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${FALSE}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# Template cho kết hợp đơn hàng
&{COMBINE_ORDER_REQUEST}
...    Order=&{COMBINED_ORDER}
...    Complete=${FALSE}
...    MakeInvoice=${FALSE}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${FALSE}
...    IsCombine=${TRUE}
...    OrderCodes=@{ORDER_CODES_TO_COMBINE}
...    UpdateCustomerIdInPayments=${FALSE}
...    FBPosParam=${None}

# =============================================================================
# Order Objects cho các test case
# =============================================================================

# Đơn hàng có sẵn để cập nhật
&{EXISTING_ORDER_FOR_UPDATE}
...    Id=${ORDER_ID}
...    Code=DH_UPDATE_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng cập nhật thông tin
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng offline để cập nhật
&{OFFLINE_ORDER_FOR_UPDATE}
...    Id=0
...    Code=DH_OFFLINE_001
...    UUID=OFFLINE_UUID_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng offline cập nhật
...    Total=150000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{OFFLINE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng chuyển chi nhánh
&{BRANCH_TRANSFER_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_TRANSFER_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng chuyển chi nhánh
...    Total=300000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${BRANCH_ID_NHANH_A}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{TRANSFER_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng để hoàn thiện
&{ORDER_FOR_COMPLETION}
...    Id=${ORDER_ID}
...    Code=DH_COMPLETE_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng hoàn thiện
...    Total=250000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMPLETION_ORDER_DETAILS}
...    Payments=@{COMPLETION_PAYMENTS}

# Đơn hàng để tạo hóa đơn
&{ORDER_FOR_INVOICE}
...    Id=${ORDER_ID}
...    Code=DH_INVOICE_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng tạo hóa đơn
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{INVOICE_ORDER_DETAILS}
...    Payments=@{INVOICE_PAYMENTS}

# Đơn hàng kết hợp
&{COMBINED_ORDER}
...    Id=0
...    Code=DH_COMBINED_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng kết hợp từ nhiều đơn
...    Total=500000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMBINED_ORDER_DETAILS}
...    Payments=@{EMPTY}

# =============================================================================
# Order Details cho các test case
# =============================================================================

# Chi tiết đơn hàng cập nhật
&{UPDATE_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm cập nhật

@{UPDATE_ORDER_DETAILS}    &{UPDATE_ORDER_DETAIL_1}

# Chi tiết đơn hàng offline
&{OFFLINE_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=150000
...    Total=150000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm offline

@{OFFLINE_ORDER_DETAILS}    &{OFFLINE_ORDER_DETAIL_1}

# Chi tiết đơn hàng chuyển chi nhánh
&{TRANSFER_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=3
...    Price=100000
...    Total=300000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm chuyển chi nhánh

@{TRANSFER_ORDER_DETAILS}    &{TRANSFER_ORDER_DETAIL_1}

# Chi tiết đơn hàng hoàn thiện
&{COMPLETION_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm hoàn thiện

&{COMPLETION_ORDER_DETAIL_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=50000
...    Total=50000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm hoàn thiện 2

@{COMPLETION_ORDER_DETAILS}    &{COMPLETION_ORDER_DETAIL_1}    &{COMPLETION_ORDER_DETAIL_2}

# Chi tiết đơn hàng tạo hóa đơn
&{INVOICE_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm tạo hóa đơn

@{INVOICE_ORDER_DETAILS}    &{INVOICE_ORDER_DETAIL_1}

# Chi tiết đơn hàng kết hợp
&{COMBINED_ORDER_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=3
...    Price=100000
...    Total=300000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm từ đơn 1

&{COMBINED_ORDER_DETAIL_2}
...    ProductId=${PRODUCT_2}
...    Quantity=1
...    Price=200000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm từ đơn 2

@{COMBINED_ORDER_DETAILS}    &{COMBINED_ORDER_DETAIL_1}    &{COMBINED_ORDER_DETAIL_2}

# =============================================================================
# Payment Details cho các test case
# =============================================================================

# Thanh toán hoàn thiện đơn hàng
&{COMPLETION_PAYMENT_1}
...    Method=Cash
...    Amount=250000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

@{COMPLETION_PAYMENTS}    &{COMPLETION_PAYMENT_1}

# Thanh toán tạo hóa đơn
&{INVOICE_PAYMENT_1}
...    Method=Cash
...    Amount=200000
...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}

@{INVOICE_PAYMENTS}    &{INVOICE_PAYMENT_1}

# =============================================================================
# Delivery Info cho các test case
# =============================================================================

# Thông tin giao hàng cập nhật
&{UPDATED_DELIVERY_INFO}
...    ReceiverName=Nguyễn Văn B
...    ReceiverPhone=0987654322
...    ReceiverAddress=456 Đường Nguyễn Huệ, Quận 1
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    Status=1
...    DeliveryMethod=1
...    PartnerDeliveryId=${PARTNER_DELIVERY_1_ID}
...    DeliveryPrice=${DEFAULT_DELIVERY_PRICE}
...    IsFreeShip=${DEFAULT_IS_FREE_SHIP}
...    Note=Giao hàng cập nhật

# Thông tin giao hàng COD
&{COD_DELIVERY_INFO}
...    ReceiverName=Trần Thị C
...    ReceiverPhone=0987654323
...    ReceiverAddress=789 Đường Lê Lợi, Quận 3
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    Status=1
...    DeliveryMethod=2
...    PartnerDeliveryId=${PARTNER_DELIVERY_1_ID}
...    DeliveryPrice=${DEFAULT_DELIVERY_PRICE}
...    IsFreeShip=${DEFAULT_IS_FREE_SHIP}
...    Note=Giao hàng COD
...    PaymentMethod=COD

# =============================================================================
# Error Test Data
# =============================================================================

# Đơn hàng với sản phẩm trùng lặp
&{DUPLICATE_PRODUCT_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_DUPLICATE_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm trùng lặp
...    Total=300000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{DUPLICATE_PRODUCT_DETAILS}
...    Payments=@{EMPTY}

# Chi tiết sản phẩm trùng lặp
&{DUPLICATE_PRODUCT_DETAIL_1}
...    ProductId=${PRODUCT_1}
...    Quantity=1
...    Price=100000
...    Total=100000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm 1

&{DUPLICATE_PRODUCT_DETAIL_2}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm 1 trùng lặp

@{DUPLICATE_PRODUCT_DETAILS}    &{DUPLICATE_PRODUCT_DETAIL_1}    &{DUPLICATE_PRODUCT_DETAIL_2}

# Đơn hàng với khách hàng không tồn tại
&{INVALID_CUSTOMER_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_INVALID_CUSTOMER_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${NONEXISTENT_CUSTOMER_ID}
...    Description=Đơn hàng khách hàng không tồn tại
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng với nhân viên không tồn tại
&{INVALID_USER_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_INVALID_USER_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng nhân viên không tồn tại
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=999999999
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng với kênh bán hàng không tồn tại
&{INVALID_CHANNEL_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_INVALID_CHANNEL_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng kênh bán hàng không tồn tại
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=999999999
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng với khuyến mãi đã xóa
&{DELETED_PROMOTION_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_DELETED_PROMOTION_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng khuyến mãi đã xóa
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{DELETED_PROMOTION_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Chi tiết đơn hàng với khuyến mãi đã xóa
&{DELETED_PROMOTION_ORDER_DETAIL}
...    ProductId=${PRODUCT_1}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm có khuyến mãi đã xóa
...    PromotionId=${DELETE_PROMOTION_ID}

@{DELETED_PROMOTION_ORDER_DETAILS}    &{DELETED_PROMOTION_ORDER_DETAIL}

# Đơn hàng với đối tác giao hàng không hợp lệ
&{INVALID_DELIVERY_PARTNER_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_INVALID_DELIVERY_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng đối tác giao hàng không hợp lệ
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{COD_PAYMENT_INVALID_PARTNER}
...    DeliveryDetail=&{INVALID_DELIVERY_INFO}

# Thanh toán COD với đối tác không hợp lệ
&{COD_PAYMENT_INVALID_PARTNER}
...    Method=COD
...    Amount=200000

@{COD_PAYMENT_INVALID_PARTNER}    &{COD_PAYMENT_INVALID_PARTNER}

# Thông tin giao hàng với đối tác không hợp lệ
&{INVALID_DELIVERY_INFO}
...    ReceiverName=Nguyễn Văn D
...    ReceiverPhone=0987654324
...    ReceiverAddress=321 Đường Hai Bà Trưng, Quận 1
...    LocationId=${DEFAULT_LOCATION_ID}
...    WardId=${DEFAULT_WARD_ID}
...    Status=1
...    DeliveryMethod=2
...    PartnerDeliveryId=999999999
...    DeliveryPrice=${DEFAULT_DELIVERY_PRICE}
...    IsFreeShip=${DEFAULT_IS_FREE_SHIP}
...    Note=Giao hàng đối tác không hợp lệ
...    PaymentMethod=COD

# =============================================================================
# Special Test Data
# =============================================================================

# Mã đơn hàng để kết hợp
@{ORDER_CODES_TO_COMBINE}    DH_001    DH_002    DH_003

# Đơn hàng với UUID trùng lặp
&{DUPLICATE_UUID_ORDER}
...    Id=0
...    Code=DH_DUPLICATE_UUID_001
...    UUID=${EXISTENT_INVOICE_UUID}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng UUID trùng lặp
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng với mã trùng lặp
&{DUPLICATE_CODE_ORDER}
...    Id=${ORDER_ID}
...    Code=${INVOICE_DUPLICATED_CODE}
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng mã trùng lặp
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{UPDATE_ORDER_DETAILS}
...    Payments=@{EMPTY}

# Đơn hàng với sản phẩm serial
&{SERIAL_PRODUCT_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_SERIAL_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm serial
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{SERIAL_PRODUCT_DETAILS}
...    Payments=@{EMPTY}

# Chi tiết sản phẩm serial
&{SERIAL_PRODUCT_DETAIL}
...    ProductId=${PRODUCT_ID_SERIAL}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm serial
...    SerialNumbers=SN001,SN002

@{SERIAL_PRODUCT_DETAILS}    &{SERIAL_PRODUCT_DETAIL}

# Đơn hàng với sản phẩm batch
&{BATCH_PRODUCT_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_BATCH_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm batch
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{BATCH_PRODUCT_DETAILS}
...    Payments=@{EMPTY}

# Chi tiết sản phẩm batch
&{BATCH_PRODUCT_DETAIL}
...    ProductId=${product_batch}
...    Quantity=2
...    Price=100000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm batch
...    BatchExpireId=${batch_1}
...    BatchProcessingType=FIFO

@{BATCH_PRODUCT_DETAILS}    &{BATCH_PRODUCT_DETAIL}

# Đơn hàng với sản phẩm combo
&{COMBO_PRODUCT_ORDER}
...    Id=${ORDER_ID}
...    Code=DH_COMBO_001
...    PurchaseDate=${EMPTY}
...    CustomerId=${DEFAULT_CUSTOMER_ID}
...    Description=Đơn hàng sản phẩm combo
...    Total=200000
...    Status=1
...    ModifiedDate=${EMPTY}
...    RetailerId=${RETAILER_ID}
...    BranchId=${DEFAULT_BRANCH_ID}
...    SoldById=${SOLD_BY_ID}
...    SaleChannelId=${CHANNEL_ID_1}
...    Discount=0
...    DiscountRatio=0
...    OrderDetails=@{COMBO_PRODUCT_DETAILS}
...    Payments=@{EMPTY}

# Chi tiết sản phẩm combo
&{COMBO_PRODUCT_DETAIL}
...    ProductId=${COMBO_PRODUCT_1_ID}
...    Quantity=1
...    Price=200000
...    Total=200000
...    Discount=0
...    DiscountRatio=0
...    Note=Sản phẩm combo
...    ComboDetails=@{COMBO_MATERIAL_DETAILS}

# Chi tiết nguyên liệu combo
&{COMBO_MATERIAL_1}
...    ProductId=${COMBO_PRODUCT_1_MATTERIAL_1_ID}
...    Quantity=2
...    Price=50000

&{COMBO_MATERIAL_2}
...    ProductId=${COMBO_PRODUCT_1_MATTERIAL_2_ID}
...    Quantity=1
...    Price=100000

@{COMBO_MATERIAL_DETAILS}    &{COMBO_MATERIAL_1}    &{COMBO_MATERIAL_2}
@{COMBO_PRODUCT_DETAILS}    &{COMBO_PRODUCT_DETAIL}

# =============================================================================
# Query Templates cho verification
# =============================================================================

# Query kiểm tra đơn hàng đã được cập nhật
${QUERY_CHECK_ORDER_UPDATED}    SELECT Id, Code, CustomerId, SoldById, BranchId, SaleChannelId, Total, Status, Description FROM [Order] WHERE Id = ?

# Query kiểm tra chi tiết đơn hàng
${QUERY_CHECK_ORDER_DETAILS}    SELECT ProductId, Quantity, Price, Total, Discount FROM OrderDetail WHERE OrderId = ?

# Query kiểm tra thanh toán đơn hàng
${QUERY_CHECK_ORDER_PAYMENTS}    SELECT Method, Amount, AccountId FROM Payment WHERE OrderId = ?

# Query kiểm tra thông tin giao hàng
${QUERY_CHECK_DELIVERY_INFO}    SELECT ReceiverName, ReceiverPhone, ReceiverAddress, PartnerDeliveryId FROM DeliveryInfo WHERE OrderId = ?

# Query kiểm tra log thay đổi
${QUERY_CHECK_AUDIT_LOG}    SELECT Action, TableName, RecordId, OldValue, NewValue FROM AuditTrail WHERE TableName = 'Order' AND RecordId = ? ORDER BY CreatedDate DESC

# Query kiểm tra hóa đơn được tạo từ đơn hàng
${QUERY_CHECK_INVOICE_FROM_ORDER}    SELECT Id, Code, OrderId, Total FROM Invoice WHERE OrderId = ?

# Query kiểm tra trạng thái hoàn thiện đơn hàng
${QUERY_CHECK_ORDER_COMPLETION}    SELECT Id, Status, CompletedDate FROM [Order] WHERE Id = ? AND Status = 3

# Query kiểm tra tồn kho sau khi cập nhật
${QUERY_CHECK_INVENTORY_AFTER_UPDATE}    SELECT ProductId, OnHand, Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?

# Query kiểm tra lịch sử tồn kho
${QUERY_CHECK_INVENTORY_TRACKING}    SELECT DocumentId, DocumentType, ProductId, Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ?

# Query kiểm tra batch tracking
${QUERY_CHECK_BATCH_TRACKING}    SELECT BatchExpireId, Value FROM BatchExpireTracking WHERE DocumentId = ? AND DocumentType = ?

# Query kiểm tra serial tracking
${QUERY_CHECK_SERIAL_TRACKING}    SELECT SerialNumber, Status FROM SerialTracking WHERE DocumentId = ? AND DocumentType = ? 