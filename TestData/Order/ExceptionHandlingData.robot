*** Variables ***
# =============================================================================
# API Endpoints
# =============================================================================
${ORDER_CREATE_ENDPOINT}    /orders

# =============================================================================
# Test Data cho Exception Handling
# =============================================================================

# Invalid/Non-existent IDs for testing exceptions
${NONEXISTENT_USER_ID}              999999999
${NONEXISTENT_USER_NAME}            Nhân viên không tồn tại
${INACTIVE_USER_ID}                 888888888
${INVALID_CUSTOMER_ID}              -1
${INACTIVE_CUSTOMER_ID}             777777777
${NONEXISTENT_CHANNEL_ID}           666666666
${INACTIVE_CHANNEL_ID}              555555555
${OTHER_RETAILER_CHANNEL_ID}        444444444
${INVALID_DELIVERY_PARTNER_ID}      333333333
${VALID_DELIVERY_PARTNER_ID}        1000000127

# Order and Invoice related test data
${EXISTING_ORDER_ID}                130047
${DIFFERENT_CUSTOMER_ID}            1002
${DIFFERENT_USER_ID}                1000000503
${DUPLICATED_ORDER_CODE}            DH_DUPLICATE_001
${CONFLICTED_UUID}                  CONFLICT_UUID_001
${AUTO_RESOLVABLE_UUID}             AUTO_RESOLVE_UUID_001
${PROMOTION_PRODUCT_ID}             1000015828

# Standard Order Request Template
&{STANDARD_ORDER_REQUEST}
...    Order=&{STANDARD_ORDER_OBJECT}
...    Complete=${False}
...    MakeInvoice=${False}
...    Amount=0
...    Orders=@{EMPTY}
...    FromManager=${False}
...    IsCombine=${False}
...    OrderCodes=@{EMPTY}
...    UpdateCustomerIdInPayments=${False}
...    FBPosParam=${None}

# Standard Order Object
&{STANDARD_ORDER_OBJECT}
...    Id=0
...    Code=DH_EXC_TEST_001
...    CustomerId=1000009032
...    SoldById=1000000495
...    BranchId=1000000025
...    RetailerId=19809
...    SaleChannelId=1000000042
...    Status=1
...    PurchaseDate=${EMPTY}
...    OrderDetails=@{STANDARD_ORDER_DETAILS}
...    DeliveryInfo=${None}
...    UUID=${EMPTY}

# Standard Order Details
@{STANDARD_ORDER_DETAILS}
...    &{STANDARD_ORDER_DETAIL_1}
...    &{STANDARD_ORDER_DETAIL_2}

&{STANDARD_ORDER_DETAIL_1}
...    ProductId=1000014178
...    ProductCode=HH0115
...    Quantity=1
...    Price=100000
...    Discount=0
...    IsPromotion=${False}

&{STANDARD_ORDER_DETAIL_2}
...    ProductId=1000014172
...    ProductCode=HH0116
...    Quantity=2
...    Price=150000
...    Discount=0
...    IsPromotion=${False}

# =============================================================================
# Error Messages và Exception Types
# =============================================================================

# KvValidateException Messages
${ERROR_PRODUCT_DUPLICATED}         ProductDuplicated
${ERROR_INVALID_PERMISSION}         _invalid_Permission

# KvValidateCustomerException Messages
${ERROR_CUSTOMER_NOT_EXIST}         Khách hàng không tồn tại
${ERROR_CUSTOMER_INACTIVE}          Khách hàng không hoạt động
${ERROR_INVALID_CUSTOMER_ID}        ID khách hàng không hợp lệ
${ERROR_CANNOT_UPDATE_INVOICE}      Không thể cập nhật thông tin hóa đơn liên quan đến khách hàng

# KvValidateUserException Messages
${ERROR_USER_NOT_EXIST}             Nhân viên bán hàng không tồn tại
${ERROR_USER_INACTIVE}              Nhân viên bán hàng không hoạt động

# KvValidatePartnerDeliveryException Messages
${ERROR_INVALID_DELIVERY_PARTNER}   Đối tác giao hàng không hợp lệ hoặc không hoạt động
${ERROR_INVALID_COD_METHOD}         Phương thức thanh toán COD không hợp lệ
${ERROR_COD_NOT_ALLOWED}            Cấu hình không cho phép sử dụng COD với đối tác KiotViet

# KvValidateSaleChannelException Messages
${ERROR_CHANNEL_NOT_EXIST}          Kênh bán hàng không tồn tại
${ERROR_CHANNEL_INACTIVE}           Kênh bán hàng không hoạt động
${ERROR_CHANNEL_WRONG_RETAILER}     Kênh bán hàng không thuộc cùng retailer

# KvValidateInvoiceException Messages
${ERROR_DUPLICATE_ORDER_CODE}       Trùng lặp mã đơn hàng online
${ERROR_UUID_CONFLICT}              Xung đột UUID đơn hàng

# System Exception Messages
${ERROR_ORDER_NOT_FOUND}            Đơn hàng không tồn tại
${ERROR_SYSTEM_ERROR}               Lỗi hệ thống

# =============================================================================
# SQL Queries cho Database Verification
# =============================================================================

${QUERY_COUNT_RECENT_ORDERS}        SELECT COUNT(*) FROM [Order] WHERE CreatedDate >= DATEADD(minute, -5, GETDATE()) AND RetailerId = ?
${QUERY_COUNT_ORDER_DETAILS}        SELECT COUNT(*) FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
${QUERY_GET_ORDER_BY_ID}            SELECT * FROM [Order] WHERE Id = ?
${QUERY_GET_USER_BY_ID}             SELECT * FROM [User] WHERE Id = ? AND RetailerId = ?
${QUERY_GET_CUSTOMER_BY_ID}         SELECT * FROM Customer WHERE Id = ? AND RetailerId = ?
${QUERY_GET_CHANNEL_BY_ID}          SELECT * FROM SaleChannel WHERE Id = ? AND RetailerId = ?
${QUERY_GET_DELIVERY_PARTNER}       SELECT * FROM PartnerDelivery WHERE Id = ? AND IsActive = 1

# =============================================================================
# Test Configuration
# =============================================================================

# HTTP Status Codes
${HTTP_SUCCESS}                     200
${HTTP_BUSINESS_ERROR}              420
${HTTP_UNAUTHORIZED}                401
${HTTP_FORBIDDEN}                   403
${HTTP_NOT_FOUND}                   404
${HTTP_INTERNAL_ERROR}              500

# Test Timeouts and Limits
${RESPONSE_TIMEOUT_FAST}            1.0
${RESPONSE_TIMEOUT_NORMAL}          5.0
${MAX_RETRY_COUNT}                  3

# =============================================================================
# Mock Data cho Special Cases
# =============================================================================

# Data for testing promotion product duplicates (allowed)
&{PROMOTION_ORDER_DETAIL_1}
...    ProductId=${PROMOTION_PRODUCT_ID}
...    ProductCode=PROMO001
...    Quantity=1
...    Price=0
...    Discount=0
...    IsPromotion=${True}
...    PromotionId=87280

&{PROMOTION_ORDER_DETAIL_2}
...    ProductId=${PROMOTION_PRODUCT_ID}
...    ProductCode=PROMO001
...    Quantity=1
...    Price=0
...    Discount=0
...    IsPromotion=${True}
...    PromotionId=87280

# Data for testing COD delivery
&{COD_DELIVERY_INFO}
...    UsingCod=1
...    ReceiverName=Người nhận test
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test, Quận Test
...    LocationId=1
...    WardId=1
...    DeliveryBy=1000000127
...    UseDefaultPartner=${True}
...    ServiceAdd=Người gửi trả phí
...    Status=0

# Data for testing invalid COD delivery
&{INVALID_COD_DELIVERY_INFO}
...    UsingCod=1
...    ReceiverName=Người nhận test
...    ReceiverPhone=0987654321
...    ReceiverAddress=123 Đường Test, Quận Test
...    LocationId=1
...    WardId=1
...    DeliveryBy=${INVALID_DELIVERY_PARTNER_ID}
...    UseDefaultPartner=${False}
...    ServiceAdd=${EMPTY}
...    Status=0

# =============================================================================
# Permission Test Data
# =============================================================================

# Permission constants
${PERMISSION_ORDER_CREATE}          Order._Create
${PERMISSION_ORDER_UPDATE}          Order._Update
${PERMISSION_INVOICE_MODIFY_SELLER}  Invoice.ModifySeller
${PERMISSION_ORDER_MAKE_INVOICE}    Order.MakeInvoice

# Test scenarios for permissions
@{PERMISSION_TEST_SCENARIOS}
...    ${PERMISSION_ORDER_CREATE}
...    ${PERMISSION_ORDER_UPDATE}
...    ${PERMISSION_INVOICE_MODIFY_SELLER}

# =============================================================================
# Exception Type Constants
# =============================================================================

${EXCEPTION_KV_VALIDATE}            KvValidateException
${EXCEPTION_KV_VALIDATE_CUSTOMER}   KvValidateCustomerException
${EXCEPTION_KV_VALIDATE_USER}       KvValidateUserException
${EXCEPTION_KV_VALIDATE_DELIVERY}   KvValidatePartnerDeliveryException
${EXCEPTION_KV_VALIDATE_CHANNEL}    KvValidateSaleChannelException
${EXCEPTION_KV_VALIDATE_INVOICE}    KvValidateInvoiceException
${EXCEPTION_KV_VALIDATE_ORDER}      KvValidateOrderException
${EXCEPTION_KV_GENERAL}             KvException

# =============================================================================
# Test Data Validation Rules
# =============================================================================

# Business rules for validation
${MIN_QUANTITY}                     0.001
${MAX_QUANTITY}                     999999
${MIN_PRICE}                        0
${MAX_PRICE}                        999999999
${MAX_DISCOUNT_PERCENTAGE}          100
${MAX_NOTE_LENGTH}                  500
${MAX_CODE_LENGTH}                  50

# =============================================================================
# Environment Specific Data
# =============================================================================

# These should be overridden by environment-specific configuration
${RETAILER_ID}                      ${EMPTY}
${BRANCH_ID}                        ${EMPTY}
${DEFAULT_USER_ID}                  ${EMPTY}

# =============================================================================
# Test Execution Configuration
# =============================================================================

# Test execution settings
${PARALLEL_EXECUTION}               ${False}
${CLEANUP_AFTER_TEST}               ${True}
${VERBOSE_LOGGING}                  ${True}
${SCREENSHOT_ON_FAILURE}            ${True}

# =============================================================================
# Additional Test Data for Edge Cases
# =============================================================================

# Edge case test data
${VERY_LONG_ORDER_CODE}             DH_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
${SPECIAL_CHARS_ORDER_CODE}         DH_@#$%^&*()
${UNICODE_ORDER_CODE}               DH_Đơn_Hàng_Tiếng_Việt_001
${EMPTY_ORDER_CODE}                 ${EMPTY}
${NULL_ORDER_CODE}                  ${None}

# Large numbers for testing limits
${VERY_LARGE_ID}                    999999999999999
${NEGATIVE_ID}                      -999999999
${ZERO_ID}                          0

# Date/Time test data
${PAST_DATE}                        2020-01-01T00:00:00
${FUTURE_DATE}                      2030-12-31T23:59:59
${INVALID_DATE}                     invalid-date-format

# =============================================================================
# Test Data for Specific Business Scenarios
# =============================================================================

# Scenario: Order with multiple payment methods
@{MULTIPLE_PAYMENT_METHODS}
...    Cash
...    Card

# Scenario: Order with complex delivery requirements
&{COMPLEX_DELIVERY_INFO}
...    UsingCod=1
...    ReceiverName=Nguyễn Văn A
...    ReceiverPhone=0123456789
...    ReceiverAddress=Số 123, Đường ABC, Phường XYZ
...    LocationId=1
...    WardId=1
...    DeliveryBy=1000000127
...    UseDefaultPartner=${True}
...    ServiceAdd=Người nhận trả phí
...    ExpectedDelivery=2024-12-31T10:00:00
...    DeliveryNote=Giao hàng trong giờ hành chính
...    Status=0

# Scenario: Order with tax calculations
&{ORDER_WITH_TAX}
...    TaxPercentage=10
...    TaxAmount=10000
...    TaxType=1
...    TaxId=2

# =============================================================================
# Cleanup and Maintenance Data
# =============================================================================

# Data for cleanup operations
@{CLEANUP_ORDER_CODES}
...    DH_EXC_TEST_001
...    DH_EXC_TEST_002
...    DH_EXC_TEST_003
...    ${DUPLICATED_ORDER_CODE}

${CLEANUP_QUERY_ORDERS}             DELETE FROM [Order] WHERE Code IN ('DH_EXC_TEST_001', 'DH_EXC_TEST_002', 'DH_EXC_TEST_003') AND RetailerId = ?
${CLEANUP_QUERY_ORDER_DETAILS}      DELETE FROM OrderDetail WHERE OrderId IN (SELECT Id FROM [Order] WHERE Code LIKE 'DH_EXC_TEST_%' AND RetailerId = ?)

# =============================================================================
# Documentation and Metadata
# =============================================================================

${TEST_SUITE_VERSION}               1.0.0
${TEST_SUITE_AUTHOR}                AI Generated Test Suite
${TEST_SUITE_DESCRIPTION}           Comprehensive test suite for exception handling in KiotViet Order API
${LAST_UPDATED}                     2024-12-19 