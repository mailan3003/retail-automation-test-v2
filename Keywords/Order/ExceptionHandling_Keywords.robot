*** Settings ***
Documentation    Keywords cho test cases xử lý ngoại lệ và lỗi trong hệ thống KiotViet
Resource         ../Utilities/Utilities.robot
Resource         ../../TestData/CommonData.robot
Resource         ../../TestData/Order/ExceptionHandlingData.robot
Resource         OrderCommandKeywords.robot
Library          Collections
Library          String
Library          json

*** Keywords ***
# =============================================================================
# GIVEN Keywords - Chuẩn bị dữ liệu test
# =============================================================================

Chuẩn Bị Dữ Liệu Đơn Hàng Với Điều Kiện "${condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện cụ thể để test ngoại lệ
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${condition}' == 'Sản phẩm trùng lặp'
    ...    Thiết Lập Dữ Liệu Sản Phẩm Trùng Lặp    ${request}
    ...    ELSE IF    '${condition}' == 'Không có quyền tạo đơn hàng'
    ...    Thiết Lập Dữ Liệu Không Có Quyền Tạo    ${request}
    ...    ELSE IF    '${condition}' == 'Không có quyền cập nhật đơn hàng'
    ...    Thiết Lập Dữ Liệu Không Có Quyền Cập Nhật    ${request}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khách Hàng "${customer_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện khách hàng cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${customer_condition}' == 'Khách hàng không tồn tại'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${NONEXISTENT_CUSTOMER_ID}
    ...    ELSE IF    '${customer_condition}' == 'Khách hàng không hoạt động'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${INACTIVE_CUSTOMER_ID}
    ...    ELSE IF    '${customer_condition}' == 'ID khách hàng không hợp lệ'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${INVALID_CUSTOMER_ID}
    ...    ELSE IF    '${customer_condition}' == 'Không thể cập nhật thông tin hóa đơn'
    ...    Thiết Lập Dữ Liệu Cập Nhật Hóa Đơn Khách Hàng    ${request}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên "${user_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện nhân viên cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${user_condition}' == 'Nhân viên không tồn tại'
    ...    Set To Dictionary    ${request["Order"]}    SoldById=${NONEXISTENT_USER_ID}
    ...    ELSE IF    '${user_condition}' == 'Nhân viên không hoạt động'
    ...    Set To Dictionary    ${request["Order"]}    SoldById=${INACTIVE_USER_ID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Giao Hàng "${delivery_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện đối tác giao hàng cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Thiết lập thông tin giao hàng cơ bản
    ${delivery_info}=    Create Dictionary
    ...    UsingCod=1
    ...    ReceiverName=Test Receiver
    ...    ReceiverPhone=0987654321
    ...    ReceiverAddress=123 Test Street
    ...    LocationId=${DEFAULT_LOCATION_ID}
    ...    WardId=${DEFAULT_WARD_ID}
    
    Run Keyword If    '${delivery_condition}' == 'Đối tác giao hàng không hợp lệ'
    ...    Set To Dictionary    ${delivery_info}    DeliveryBy=${INVALID_DELIVERY_PARTNER_ID}
    ...    ELSE IF    '${delivery_condition}' == 'Phương thức COD không hợp lệ'
    ...    Thiết Lập Dữ Liệu COD Không Hợp Lệ    ${delivery_info}
    ...    ELSE IF    '${delivery_condition}' == 'Cấu hình không cho phép COD'
    ...    Thiết Lập Dữ Liệu Cấu Hình COD Không Cho Phép    ${delivery_info}
    
    Set To Dictionary    ${request["Order"]}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Kênh Bán Hàng "${channel_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện kênh bán hàng cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${channel_condition}' == 'Kênh bán hàng không tồn tại'
    ...    Set To Dictionary    ${request["Order"]}    SaleChannelId=${NONEXISTENT_CHANNEL_ID}
    ...    ELSE IF    '${channel_condition}' == 'Kênh bán hàng không hoạt động'
    ...    Set To Dictionary    ${request["Order"]}    SaleChannelId=${INACTIVE_CHANNEL_ID}
    ...    ELSE IF    '${channel_condition}' == 'Kênh bán hàng không thuộc retailer'
    ...    Set To Dictionary    ${request["Order"]}    SaleChannelId=${OTHER_RETAILER_CHANNEL_ID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Hóa Đơn "${invoice_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện hóa đơn cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${invoice_condition}' == 'Trùng lặp mã đơn hàng online'
    ...    Set To Dictionary    ${request["Order"]}    Code=${DUPLICATED_ORDER_CODE}
    ...    ELSE IF    '${invoice_condition}' == 'Xung đột UUID đơn hàng'
    ...    Set To Dictionary    ${request["Order"]}    UUID=${CONFLICTED_UUID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Trùng Lặp Không Phải Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có sản phẩm trùng lặp không thuộc khuyến mãi
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Tạo danh sách chi tiết đơn hàng với sản phẩm trùng lặp
    ${order_details}=    Create List
    ${detail1}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=1    Price=100000
    ${detail2}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=2    Price=100000
    Append To List    ${order_details}    ${detail1}
    Append To List    ${order_details}    ${detail2}
    
    Set To Dictionary    ${request["Order"]}    OrderDetails=${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên Bán Hàng Không Tồn Tại "${user_id}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với nhân viên bán hàng không tồn tại
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request["Order"]}    SoldById=${user_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Quyền Hạn "${permission_type}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để test quyền hạn cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Thiết lập dữ liệu để trigger kiểm tra quyền cụ thể
    Run Keyword If    '${permission_type}' == 'Không có quyền Order._Create'
    ...    Set To Dictionary    ${request}    TestPermission=Order._Create
    ...    ELSE IF    '${permission_type}' == 'Không có quyền Order._Update'
    ...    Thiết Lập Dữ Liệu Cập Nhật Đơn Hàng    ${request}
    ...    ELSE IF    '${permission_type}' == 'Không có quyền Invoice.ModifySeller'
    ...    Thiết Lập Dữ Liệu Thay Đổi Nhân Viên Bán Hàng    ${request}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Gây Ra Ngoại Lệ "${exception_type}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để gây ra loại ngoại lệ cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${exception_type}' == 'KvValidateException'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${INVALID_CUSTOMER_ID}
    ...    ELSE IF    '${exception_type}' == 'KvValidateCustomerException'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${NONEXISTENT_CUSTOMER_ID}
    ...    ELSE IF    '${exception_type}' == 'KvValidateUserException'
    ...    Set To Dictionary    ${request["Order"]}    SoldById=${NONEXISTENT_USER_ID}
    ...    ELSE IF    '${exception_type}' == 'KvValidatePartnerDeliveryException'
    ...    Thiết Lập Dữ Liệu Đối Tác Giao Hàng Không Hợp Lệ    ${request}
    ...    ELSE IF    '${exception_type}' == 'KvValidateSaleChannelException'
    ...    Set To Dictionary    ${request["Order"]}    SaleChannelId=${NONEXISTENT_CHANNEL_ID}
    ...    ELSE IF    '${exception_type}' == 'KvValidateInvoiceException'
    ...    Set To Dictionary    ${request["Order"]}    Code=${DUPLICATED_ORDER_CODE}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Trùng Lặp Thuộc Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có sản phẩm trùng lặp thuộc khuyến mãi
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Tạo danh sách chi tiết đơn hàng với sản phẩm khuyến mãi trùng lặp
    ${order_details}=    Create List
    ${detail1}=    Create Dictionary    ProductId=${PROMOTION_PRODUCT_ID}    Quantity=1    Price=0    IsPromotion=${True}
    ${detail2}=    Create Dictionary    ProductId=${PROMOTION_PRODUCT_ID}    Quantity=1    Price=0    IsPromotion=${True}
    Append To List    ${order_details}    ${detail1}
    Append To List    ${order_details}    ${detail2}
    
    Set To Dictionary    ${request["Order"]}    OrderDetails=${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với UUID Xung Đột Có Thể Tự Động Xử Lý
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với UUID xung đột có thể tự động xử lý
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request["Order"]}    UUID=${AUTO_RESOLVABLE_UUID}
    Set To Dictionary    ${request}    AutoResolveConflict=${True}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Người Dùng Không Có Quyền
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với người dùng không có quyền
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request}    TestNoPermission=${True}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với UsingCod "${using_cod}" Và Đối Tác "${delivery_partner_status}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện COD và đối tác giao hàng
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    ${delivery_info}=    Create Dictionary
    ...    UsingCod=${using_cod}
    ...    ReceiverName=Test Receiver
    ...    ReceiverPhone=0987654321
    ...    ReceiverAddress=123 Test Street
    
    Run Keyword If    '${delivery_partner_status}' == 'Không hợp lệ'
    ...    Set To Dictionary    ${delivery_info}    DeliveryBy=${INVALID_DELIVERY_PARTNER_ID}
    ...    ELSE IF    '${delivery_partner_status}' == 'Hợp lệ'
    ...    Set To Dictionary    ${delivery_info}    DeliveryBy=${VALID_DELIVERY_PARTNER_ID}
    
    Set To Dictionary    ${request["Order"]}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Gây Ra "${exception_type}" Với Điều Kiện "${test_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để gây ra ngoại lệ hệ thống cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${exception_type}' == 'KvValidateOrderException' and '${test_condition}' == 'Đơn hàng không tồn tại'
    ...    Set To Dictionary    ${request["Order"]}    OrderId=${NONEXISTENT_ORDER_ID}
    ...    ELSE IF    '${exception_type}' == 'KvException' and '${test_condition}' == 'Lỗi hệ thống chung'
    ...    Set To Dictionary    ${request}    TriggerSystemError=${True}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# GIVEN Keywords cho Data Validation - Chuẩn bị dữ liệu test
# =============================================================================

Chuẩn Bị Dữ Liệu Đơn Hàng Với VAT Toggle "${vat_toggle_status}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để test VAT toggle
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Thiết lập sản phẩm có VAT
    ${order_details}=    Create List
    ${detail_with_vat}=    Create Dictionary    
    ...    ProductId=${PRODUCT_WITH_VAT_1_ID}    
    ...    Quantity=1    
    ...    Price=100000    
    ...    TaxPercentage=10
    Append To List    ${order_details}    ${detail_with_vat}
    Set To Dictionary    ${request["Order"]}    OrderDetails=${order_details}
    
    # Thiết lập cấu hình VAT toggle
    Set To Dictionary    ${request}    VATToggleStatus=${vat_toggle_status}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm "${product_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện sản phẩm cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    ${order_details}=    Create List
    
    Run Keyword If    '${product_condition}' == 'Sản phẩm thường trùng lặp'
    ...    Run Keywords
    ...    ${detail1}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=1    Price=100000    IsPromotion=${False}
    ...    AND    ${detail2}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=2    Price=100000    IsPromotion=${False}
    ...    AND    Append To List    ${order_details}    ${detail1}
    ...    AND    Append To List    ${order_details}    ${detail2}
    ...    ELSE IF    '${product_condition}' == 'Sản phẩm khuyến mãi trùng lặp'
    ...    Run Keywords
    ...    ${detail1}=    Create Dictionary    ProductId=${PRODUCT_ID_PROMOTION}    Quantity=1    Price=0    IsPromotion=${True}    SalePromotionId=87280
    ...    AND    ${detail2}=    Create Dictionary    ProductId=${PRODUCT_ID_PROMOTION}    Quantity=1    Price=0    IsPromotion=${True}    SalePromotionId=87280
    ...    AND    Append To List    ${order_details}    ${detail1}
    ...    AND    Append To List    ${order_details}    ${detail2}
    ...    ELSE IF    '${product_condition}' == 'Sản phẩm không phải Master trùng lặp'
    ...    Run Keywords
    ...    ${detail1}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=1    Price=100000    IsMaster=${False}
    ...    AND    ${detail2}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=2    Price=100000    IsMaster=${False}
    ...    AND    Append To List    ${order_details}    ${detail1}
    ...    AND    Append To List    ${order_details}    ${detail2}
    
    Set To Dictionary    ${request["Order"]}    OrderDetails=${order_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi "${promotion_condition}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện khuyến mãi cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    ${order_promotions}=    Create List
    
    Run Keyword If    '${promotion_condition}' == 'Khuyến mãi hợp lệ'
    ...    Run Keywords
    ...    ${promotion}=    Create Dictionary    Id=0    PromotionId=${VALID_PROMOTION_ID}
    ...    AND    Append To List    ${order_promotions}    ${promotion}
    ...    ELSE IF    '${promotion_condition}' == 'Khuyến mãi đã bị xóa'
    ...    Run Keywords
    ...    ${promotion}=    Create Dictionary    Id=0    PromotionId=${DELETE_PROMOTION_ID}
    ...    AND    Append To List    ${order_promotions}    ${promotion}
    ...    ELSE IF    '${promotion_condition}' == 'Khuyến mãi hết hạn'
    ...    Run Keywords
    ...    ${promotion}=    Create Dictionary    Id=0    PromotionId=${EXPIRED_PROMOTION_ID}
    ...    AND    Append To List    ${order_promotions}    ${promotion}
    
    Set To Dictionary    ${request["Order"]}    OrderPromotions=${order_promotions}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với COD "${using_cod}" Đối Tác "${partner_status}" Cấu Hình "${cod_config}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện COD và đối tác giao hàng
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    ${delivery_info}=    Create Dictionary
    ...    UsingCod=${using_cod}
    ...    ReceiverName=Test Receiver
    ...    ReceiverPhone=0987654321
    ...    ReceiverAddress=123 Test Street
    
    Run Keyword If    '${partner_status}' == 'Hợp lệ'
    ...    Set To Dictionary    ${delivery_info}    DeliveryBy=${VALID_DELIVERY_PARTNER_ID}
    ...    ELSE IF    '${partner_status}' == 'Không hợp lệ'
    ...    Set To Dictionary    ${delivery_info}    DeliveryBy=${INVALID_DELIVERY_PARTNER_ID}
    
    Set To Dictionary    ${delivery_info}    CODConfigAllowed=${'${cod_config}' == 'Cho phép'}
    Set To Dictionary    ${request["Order"]}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Cập Nhật Với CustomerId "${customer_id}" BranchTransfer "${is_branch_transfer}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng cập nhật với điều kiện khách hàng
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    Set To Dictionary    ${request["Order"]}    CustomerId=${customer_id}
    Set To Dictionary    ${request}    IsBranchTransfer=${is_branch_transfer}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với SoldById "${sold_by_id}" OrderMới "${is_new_order}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện nhân viên bán hàng
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request["Order"]}    SoldById=${sold_by_id}
    
    Run Keyword If    not ${is_new_order}
    ...    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Loại "${order_type}" Quyền "${permission_type}" CóQuyền "${has_permission}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để test quyền hạn
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${order_type}' == 'Cập nhật'
    ...    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    ...    ELSE IF    '${order_type}' == 'Thay đổi NV'
    ...    Run Keywords
    ...    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    ...    AND    Set To Dictionary    ${request["Order"]}    SoldById=${DIFFERENT_USER_ID}
    ...    AND    Set To Dictionary    ${request}    CompareSoldById=${SOLD_BY_ID}
    
    Set To Dictionary    ${request}    TestPermission=${permission_type}
    Set To Dictionary    ${request}    HasPermission=${has_permission}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với SaleChannelId "${channel_id}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với điều kiện kênh bán hàng
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${channel_id}' != '${None}'
    ...    Set To Dictionary    ${request["Order"]}    SaleChannelId=${channel_id}
    ...    ELSE
    ...    Remove From Dictionary    ${request["Order"]}    SaleChannelId
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với IsValid "${is_valid}" Kiểm Tra "${validation_type}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng để test bỏ qua xác thực
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Set To Dictionary    ${request}    IsValid=${is_valid}
    
    # Thiết lập dữ liệu lỗi để test khi không bỏ qua
    Run Keyword If    not ${is_valid}
    ...    Run Keyword If    '${validation_type}' == 'Kiểm tra khách hàng'
    ...    Set To Dictionary    ${request["Order"]}    CustomerId=${NONEXISTENT_CUSTOMER_ID}
    ...    ELSE IF    '${validation_type}' == 'Kiểm tra nhân viên'
    ...    Set To Dictionary    ${request["Order"]}    SoldById=${NONEXISTENT_USER_ID}
    ...    ELSE IF    '${validation_type}' == 'Kiểm tra quyền hạn'
    ...    Set To Dictionary    ${request}    TestPermission=Order._Create    HasPermission=${False}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Trường "${field_name}" Giá Trị "${field_value}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với giá trị biên cho trường cụ thể
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    Run Keyword If    '${field_value}' == '${None}'
    ...    Remove From Dictionary    ${request["Order"]}    ${field_name}
    ...    ELSE IF    '${field_value}' == '${EMPTY}'
    ...    Set To Dictionary    ${request["Order"]}    ${field_name}=${EMPTY}
    ...    ELSE
    ...    Set To Dictionary    ${request["Order"]}    ${field_name}=${field_value}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Lỗi Xác Thực
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có nhiều lỗi để test thứ tự ưu tiên
    ${request_json}=    Evaluate    json.dumps(${STANDARD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    
    # Thiết lập nhiều lỗi cùng lúc
    Set To Dictionary    ${request["Order"]}    CustomerId=${NONEXISTENT_CUSTOMER_ID}
    Set To Dictionary    ${request["Order"]}    SoldById=${NONEXISTENT_USER_ID}
    Set To Dictionary    ${request["Order"]}    SaleChannelId=${NONEXISTENT_CHANNEL_ID}
    Set To Dictionary    ${request}    TestPermission=Order._Create    HasPermission=${False}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Xác Thực Không Có Đơn Hàng Nào Được Tạo Trong Database
    [Documentation]    Xác thực không có đơn hàng nào được tạo trong database khi có lỗi
    ${query}=    Set Variable    SELECT COUNT(*) FROM [Order] WHERE CreatedDate >= DATEADD(minute, -5, GETDATE()) AND RetailerId = ?
    ${count}=    Fetch One    ${query}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${count[0]}    0
    ...    msg=Có đơn hàng được tạo trong database mặc dù có lỗi

Phản Hồi Phải Chứa Thông Báo Lỗi Cụ Thể Về Nhân Viên "${user_name}"
    [Documentation]    Xác thực response chứa thông báo lỗi cụ thể về nhân viên
    ${response_text}=    Convert To String    ${RESPONSE.text}
    Should Contain    ${response_text}    ${user_name}
    ...    msg=Response không chứa tên nhân viên cụ thể: ${user_name}

Xác Thực Thông Báo Lỗi Sử Dụng Hằng Số Từ KVMessage
    [Documentation]    Xác thực thông báo lỗi sử dụng hằng số từ KVMessage
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Run Keyword If    'MessageKey' in $response_json
    ...    Should Not Be Empty    ${response_json['MessageKey']}
    ...    msg=Thông báo lỗi không sử dụng hằng số từ KVMessage

Phản Hồi Phải Chứa ID Đơn Hàng Hợp Lệ
    [Documentation]    Xác thực response chứa ID đơn hàng hợp lệ
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Should Be True    ${response_json['Id']} > 0
    ...    msg=Response không chứa ID đơn hàng hợp lệ

Xác Thực Đơn Hàng Được Tạo Thành Công Với Sản Phẩm Khuyến Mãi Trùng Lặp
    [Documentation]    Xác thực đơn hàng được tạo thành công với sản phẩm khuyến mãi trùng lặp
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    ${order_id}=    Set Variable    ${response_json['Id']}
    
    # Kiểm tra đơn hàng trong database
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${count}=    Fetch One    ${query}    ${order_id}    ${PROMOTION_PRODUCT_ID}
    Should Be True    ${count[0]} >= 2
    ...    msg=Đơn hàng không có sản phẩm khuyến mãi trùng lặp như mong đợi

Phản Hồi Phải Chứa UUID Mới Được Tạo Tự Động
    [Documentation]    Xác thực response chứa UUID mới được tạo tự động
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Equal    ${response_json['UUID']}    ${AUTO_RESOLVABLE_UUID}
    ...    msg=UUID không được tạo mới tự động

Xác Thực UUID Mới Khác Với UUID Gốc Bị Xung Đột
    [Documentation]    Xác thực UUID mới khác với UUID gốc bị xung đột
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Equal    ${response_json['UUID']}    ${AUTO_RESOLVABLE_UUID}
    ...    msg=UUID mới không khác với UUID gốc bị xung đột

Xác Thực Không Có Dữ Liệu Nào Được Xử Lý Trong Database
    [Documentation]    Xác thực không có dữ liệu nào được xử lý trong database khi thiếu quyền
    ${query}=    Set Variable    SELECT COUNT(*) FROM [Order] WHERE CreatedDate >= DATEADD(minute, -5, GETDATE()) AND RetailerId = ?
    ${count}=    Fetch One    ${query}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${count[0]}    0
    ...    msg=Có dữ liệu được xử lý trong database mặc dù thiếu quyền

Xác Thực Thời Gian Phản Hồi Nhanh Do Kiểm Tra Quyền Sớm
    [Documentation]    Xác thực thời gian phản hồi nhanh do kiểm tra quyền sớm
    ${response_time}=    Get From Dictionary    ${RESPONSE.elapsed}    total_seconds
    Should Be True    ${response_time} < 1.0
    ...    msg=Thời gian phản hồi quá chậm, có thể không kiểm tra quyền sớm

Xác Thực Cấu Trúc Response Chứa Thông Tin Lỗi Đầy Đủ
    [Documentation]    Xác thực cấu trúc response chứa thông tin lỗi đầy đủ
    ${response_json}=    Set Variable    ${RESPONSE.json()}
    Dictionary Should Contain Key    ${response_json}    Message
    ...    msg=Response không chứa trường Message
    Dictionary Should Contain Key    ${response_json}    Success
    ...    msg=Response không chứa trường Success
    Should Be Equal    ${response_json['Success']}    ${False}
    ...    msg=Trường Success không có giá trị false khi có lỗi

# =============================================================================
# THEN Keywords cho Data Validation - Xác thực kết quả
# =============================================================================

Xác Thực TotalTax Trong Response Là "${expected_total_tax}"
    [Documentation]    Xác thực giá trị TotalTax trong response
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    Run Keyword If    '${expected_total_tax}' == '${None}'
    ...    Should Be Equal    ${response_data["Order"]["TotalTax"]}    ${None}    TotalTax phải là null khi VAT toggle không kích hoạt
    ...    ELSE
    ...    Should Be Equal As Numbers    ${response_data["Order"]["TotalTax"]}    ${expected_total_tax}    TotalTax không đúng với cấu hình VAT

Xác Thực Cấu Hình VAT Được Áp Dụng Đúng
    [Documentation]    Xác thực cấu hình VAT được áp dụng đúng cách
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    Should Have Nested Property    ${response_data}    Order.VATApplied
    Log    Cấu hình VAT đã được áp dụng đúng theo thiết lập hệ thống

Phản Hồi Phải Chứa Lỗi Đầu Tiên Theo Thứ Tự Ưu Tiên
    [Documentation]    Xác thực lỗi đầu tiên được trả về theo thứ tự ưu tiên
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    # Thứ tự ưu tiên: Permission -> Customer -> User -> SaleChannel
    Should Contain Any    ${response_data["message"]}    _invalid_Permission    Khách hàng không tồn tại    
    Log    Lỗi đầu tiên theo thứ tự ưu tiên đã được trả về đúng

Xác Thực Không Có Dữ Liệu Nào Được Lưu Trong Database
    [Documentation]    Xác thực không có dữ liệu nào được lưu trong database khi có nhiều lỗi
    ${query}=    Set Variable    SELECT COUNT(*) FROM [Order] WHERE CreatedDate >= DATEADD(minute, -5, GETDATE()) AND RetailerId = ?
    ${count}=    Fetch One    ${query}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${count[0]}    0
    ...    msg=Có dữ liệu được lưu trong database mặc dù có nhiều lỗi xác thực

Xác Thực SoldById Được Khôi Phục Về Giá Trị Ban Đầu
    [Documentation]    Xác thực SoldById được khôi phục khi không có quyền thay đổi
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Numbers    ${response_data["Order"]["SoldById"]}    ${SOLD_BY_ID}    SoldById phải được khôi phục về giá trị ban đầu khi không có quyền thay đổi
    Log    SoldById đã được khôi phục về giá trị ban đầu: ${SOLD_BY_ID}

# =============================================================================
# Helper Keywords - Các keyword hỗ trợ
# =============================================================================

Thiết Lập Dữ Liệu Sản Phẩm Trùng Lặp
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu sản phẩm trùng lặp trong đơn hàng
    ${order_details}=    Create List
    ${detail1}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=1    Price=100000
    ${detail2}=    Create Dictionary    ProductId=${PRODUCT_1}    Quantity=2    Price=100000
    Append To List    ${order_details}    ${detail1}
    Append To List    ${order_details}    ${detail2}
    Set To Dictionary    ${request["Order"]}    OrderDetails=${order_details}

Thiết Lập Dữ Liệu Không Có Quyền Tạo
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu để test không có quyền tạo đơn hàng
    Set To Dictionary    ${request}    TestPermission=Order._Create
    Set To Dictionary    ${request}    HasPermission=${False}

Thiết Lập Dữ Liệu Không Có Quyền Cập Nhật
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu để test không có quyền cập nhật đơn hàng
    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    Set To Dictionary    ${request}    TestPermission=Order._Update
    Set To Dictionary    ${request}    HasPermission=${False}

Thiết Lập Dữ Liệu Cập Nhật Hóa Đơn Khách Hàng
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu để test cập nhật thông tin hóa đơn liên quan đến khách hàng
    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    Set To Dictionary    ${request["Order"]}    CustomerId=${DIFFERENT_CUSTOMER_ID}
    Set To Dictionary    ${request}    UpdateInvoiceCustomer=${True}

Thiết Lập Dữ Liệu COD Không Hợp Lệ
    [Arguments]    ${delivery_info}
    [Documentation]    Thiết lập dữ liệu COD không hợp lệ
    Set To Dictionary    ${delivery_info}    PaymentMethod=InvalidCOD
    Set To Dictionary    ${delivery_info}    ServiceAdd=${EMPTY}

Thiết Lập Dữ Liệu Cấu Hình COD Không Cho Phép
    [Arguments]    ${delivery_info}
    [Documentation]    Thiết lập dữ liệu cấu hình COD không cho phép
    Set To Dictionary    ${delivery_info}    PartnerCode=KiotViet
    Set To Dictionary    ${delivery_info}    UseCodByKvCarrier=${False}

Thiết Lập Dữ Liệu Cập Nhật Đơn Hàng
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu để test cập nhật đơn hàng
    Set To Dictionary    ${request["Order"]}    Id=${EXISTING_ORDER_ID}
    Set To Dictionary    ${request}    TestPermission=Order._Update

Thiết Lập Dữ Liệu Thay Đổi Nhân Viên Bán Hàng
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu để test thay đổi nhân viên bán hàng
    Set To Dictionary    ${request["Order"]}    SoldById=${DIFFERENT_USER_ID}
    Set To Dictionary    ${request}    TestPermission=Invoice.ModifySeller

Thiết Lập Dữ Liệu Đối Tác Giao Hàng Không Hợp Lệ
    [Arguments]    ${request}
    [Documentation]    Thiết lập dữ liệu đối tác giao hàng không hợp lệ
    ${delivery_info}=    Create Dictionary
    ...    UsingCod=1
    ...    DeliveryBy=${INVALID_DELIVERY_PARTNER_ID}
    ...    ReceiverName=Test Receiver
    ...    ReceiverPhone=0987654321
    Set To Dictionary    ${request["Order"]}    DeliveryInfo=${delivery_info} 