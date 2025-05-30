*** Settings ***
Documentation     Keywords cho test API cập nhật đơn hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/UpdateOrderData.robot
Resource          CreateOrderKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           DateTime
Library           json

*** Variables ***
${UPDATE_ORDER_ENDPOINT}    orders

*** Keywords ***
# =============================================================================
# Keywords chuẩn bị dữ liệu cho các test case thành công
# =============================================================================
Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản Để Cập Nhật
    [Documentation]    Chuẩn bị dữ liệu để tạo đơn đặt hàng cơ bản
   Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản 
   Gửi Yêu Cầu Tạo Đơn Hàng



Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng cơ bản
    ${request}=    Deep Copy      ${BASE_ORDER_REQUEST}
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${request}    Update Nested Dictionary Property    ${request}    Code    DH_UPDATE_${current_time}
    ${request}    Update Nested Dictionary Property    ${request}    Id    ${order_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Số Lượng Sản Phẩm Từ ${old_quantity} Thành ${new_quantity}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật số lượng sản phẩm trong đơn hàng
    ${request}=    Deep Copy     ${BASE_ORDER_REQUEST}
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${request}    Update Nested Dictionary Property    ${request}    Code    DH_QTY_${current_time}
    ${request}    Update Nested Dictionary Property    ${request}    Id    ${order_id}
    # Cập nhật chi tiết sản phẩm
    ${order_details}=    Get From Dictionary    ${request}  OrderDetails
    ${detail}=    Get From List    ${order_details}    0
    ${detail}=    Update Nested Dictionary Property    ${detail}    Quantity    ${new_quantity}
    ${new_total}=    Evaluate    ${new_quantity} * ${detail['Price']}
    ${detail}=    Update Nested Dictionary Property    ${detail}    Total    ${new_total}
    ${request}    Update Nested Dictionary Property    ${request}    Total    ${new_total}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Từ "${old_customer_id}" Thành "${new_customer_id}"
    [Documentation]    Chuẩn bị dữ liệu để cập nhật khách hàng trong đơn hàng
    ${request}=    Deep Copy     ${BASE_ORDER_REQUEST}
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${request}    Update Nested Dictionary Property    ${request}    Code    DH_CUST_${current_time}
    ${request}    Update Nested Dictionary Property    ${request}    Id    ${order_id}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    CustomerId    ${new_customer_id}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Cập nhật khách hàng từ ${old_customer_id} thành ${new_customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thanh Toán Phương Thức "${payment_method}" Số Tiền ${amount}
    [Documentation]    Chuẩn bị dữ liệu để cập nhật thông tin thanh toán
    ${request}=    Deep Copy    ${BASE_UPDATE_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_PAY_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Cập nhật thanh toán ${payment_method}
    
    # Cập nhật thông tin thanh toán
    ${payment}=    Create Dictionary    Method=${payment_method}    Amount=${amount}
    Run Keyword If    '${payment_method}' == 'Card'    Set To Dictionary    ${payment}    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ${payments}=    Create List    ${payment}
    ${order}=    Update Nested Dictionary Property    ${order}    Payments    ${payments}
    ${order}=    Update Nested Dictionary Property    ${order}    Total    ${amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Thông Tin Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu để cập nhật thông tin giao hàng
    ${request}=    Deep Copy    ${BASE_UPDATE_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_DELIVERY_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Cập nhật thông tin giao hàng
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${UPDATED_DELIVERY_INFO}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Từ "${old_channel_id}" Thành "${new_channel_id}"
    [Documentation]    Chuẩn bị dữ liệu để cập nhật kênh bán hàng
    ${request}=    Deep Copy    ${BASE_UPDATE_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_CHANNEL_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    SaleChannelId    ${new_channel_id}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Cập nhật kênh bán hàng từ ${old_channel_id} thành ${new_channel_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho đơn hàng offline
# =============================================================================

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Offline Với UUID "${uuid}"
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng offline với UUID cụ thể
    ${request}=    Deep Copy    ${OFFLINE_ORDER_UPDATE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_OFFLINE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    UUID    ${uuid}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng offline UUID ${uuid}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho chuyển chi nhánh
# =============================================================================

Chuẩn Bị Dữ Liệu Chuyển Chi Nhánh Đơn Hàng Từ "${old_branch_id}" Thành "${new_branch_id}"
    [Documentation]    Chuẩn bị dữ liệu để chuyển chi nhánh đơn hàng
    ${request}=    Deep Copy    ${BRANCH_TRANSFER_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_TRANSFER_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    BranchId    ${new_branch_id}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Chuyển chi nhánh từ ${old_branch_id} thành ${new_branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho hoàn thiện và tạo hóa đơn
# =============================================================================

Chuẩn Bị Dữ Liệu Cập Nhật Và Hoàn Thiện Đơn Hàng
    [Documentation]    Chuẩn bị dữ liệu để cập nhật và hoàn thiện đơn hàng
    ${request}=    Deep Copy    ${COMPLETE_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_COMPLETE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng hoàn thiện
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Và Tạo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu để cập nhật đơn hàng và tạo hóa đơn
    ${request}=    Deep Copy    ${MAKE_INVOICE_FROM_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_INVOICE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng tạo hóa đơn
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Kết Hợp Đơn Hàng
    [Documentation]    Chuẩn bị dữ liệu để kết hợp nhiều đơn hàng
    ${request}=    Deep Copy    ${COMBINE_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_COMBINE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn hàng kết hợp từ nhiều đơn
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho các test case lỗi
# =============================================================================

Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Trùng Lặp
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có sản phẩm trùng lặp
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${DUPLICATE_PRODUCT_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với UUID Trùng Lặp "${uuid}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có UUID trùng lặp
    ${request}=    Create Dictionary
    ${order}=    Deep Copy    ${DUPLICATE_UUID_ORDER}
    ${order}=    Update Nested Dictionary Property    ${order}    UUID    ${uuid}
    Set To Dictionary    ${request}    Order    ${order}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Mã Trùng Lặp "${code}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có mã trùng lặp
    ${request}=    Create Dictionary
    ${order}=    Deep Copy    ${DUPLICATE_CODE_ORDER}
    ${order}=    Update Nested Dictionary Property    ${order}    Code    ${code}
    Set To Dictionary    ${request}    Order    ${order}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khách Hàng Không Tồn Tại "${customer_id}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có khách hàng không tồn tại
    ${request}=    Create Dictionary
    ${order}=    Deep Copy    ${INVALID_CUSTOMER_ORDER}
    ${order}=    Update Nested Dictionary Property    ${order}    CustomerId    ${customer_id}
    Set To Dictionary    ${request}    Order    ${order}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên Không Tồn Tại "${user_id}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có nhân viên không tồn tại
    ${request}=    Create Dictionary
    ${order}=    Deep Copy    ${INVALID_USER_ORDER}
    ${order}=    Update Nested Dictionary Property    ${order}    SoldById    ${user_id}
    Set To Dictionary    ${request}    Order    ${order}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có kênh bán hàng không tồn tại
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${INVALID_CHANNEL_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi Đã Xóa
    [Documentation]    Chuẩn bị dữ liệu đơn hàng có khuyến mãi đã bị xóa
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${DELETED_PROMOTION_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu đơn hàng COD có đối tác giao hàng không hợp lệ
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${INVALID_DELIVERY_PARTNER_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    UpdateCustomerIdInPayments    ${FALSE}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords cho sản phẩm đặc biệt
# =============================================================================

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Serial
    [Documentation]    Chuẩn bị dữ liệu cập nhật đơn hàng có sản phẩm quản lý theo serial
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${SERIAL_PRODUCT_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Batch
    [Documentation]    Chuẩn bị dữ liệu cập nhật đơn hàng có sản phẩm quản lý theo lô
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${BATCH_PRODUCT_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set To Dictionary    ${request}    FBPosParam    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Với Sản Phẩm Combo
    [Documentation]    Chuẩn bị dữ liệu cập nhật đơn hàng có sản phẩm combo
    ${request}=    Create Dictionary
    Set To Dictionary    ${request}    Order    ${COMBO_PRODUCT_ORDER}
    Set To Dictionary    ${request}    Complete    ${FALSE}
    Set To Dictionary    ${request}    MakeInvoice    ${FALSE}
    Set To Dictionary    ${request}    Amount    0
    Set To Dictionary    ${request}    Orders    @{EMPTY}
    Set To Dictionary    ${request}    FromManager    ${FALSE}
    Set To Dictionary    ${request}    IsCombine    ${FALSE}
    Set To Dictionary    ${request}    OrderCodes    @{EMPTY}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords gửi yêu cầu API
# =============================================================================

Gửi Yêu Cầu Cập Nhật Đơn Hàng
    [Documentation]    Gửi yêu cầu cập nhật đơn hàng đến API
    ${response}=    Call API With BranchId    ${UPDATE_ORDER_ENDPOINT}    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Updated Order Id From Response
    RETURN    ${response}

Set Updated Order Id From Response
    [Documentation]    Lưu ID đơn hàng đã cập nhật từ response
    ${order_id}=    Get From Dictionary    ${RESPONSE_JSON}    Id
    Set Test Variable    ${UPDATED_ORDER_ID}    ${order_id}

# =============================================================================
# Keywords xác thực kết quả thành công
# =============================================================================

Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    [Documentation]    Xác thực đơn hàng đã được cập nhật trong database
    ${query}=    Set Variable    SELECT * FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL sau khi cập nhật

Xác Thực Log Thay Đổi Đã Được Ghi Nhận
    [Documentation]    Xác thực log thay đổi đã được ghi nhận trong audit trail
    ${result}=    Fetch One    ${QUERY_CHECK_AUDIT_LOG}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy log thay đổi cho đơn hàng

Xác Thực Số Lượng Sản Phẩm Đã Được Cập Nhật Thành ${expected_quantity}
    [Documentation]    Xác thực số lượng sản phẩm đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_DETAILS}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy chi tiết đơn hàng
    ${actual_quantity}=    Set Variable    ${result[1]}
    Should Be Equal As Numbers    ${actual_quantity}    ${expected_quantity}    Số lượng sản phẩm không được cập nhật đúng

Xác Thực Khách Hàng Đã Được Cập Nhật Thành "${expected_customer_id}"
    [Documentation]    Xác thực khách hàng đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_UPDATED}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    ${actual_customer_id}=    Set Variable    ${result[2]}
    Should Be Equal As Strings    ${actual_customer_id}    ${expected_customer_id}    Khách hàng không được cập nhật đúng

Xác Thực Thanh Toán Đã Được Cập Nhật Phương Thức "${expected_method}" Số Tiền ${expected_amount}
    [Documentation]    Xác thực thông tin thanh toán đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_PAYMENTS}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin thanh toán
    ${actual_method}=    Set Variable    ${result[0]}
    ${actual_amount}=    Set Variable    ${result[1]}
    Should Be Equal As Strings    ${actual_method}    ${expected_method}    Phương thức thanh toán không được cập nhật đúng
    Should Be Equal As Numbers    ${actual_amount}    ${expected_amount}    Số tiền thanh toán không được cập nhật đúng

Xác Thực Thông Tin Giao Hàng Đã Được Cập Nhật
    [Documentation]    Xác thực thông tin giao hàng đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_DELIVERY_INFO}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin giao hàng
    ${actual_receiver_name}=    Set Variable    ${result[0]}
    ${actual_receiver_phone}=    Set Variable    ${result[1]}
    Should Be Equal As Strings    ${actual_receiver_name}    Nguyễn Văn B    Tên người nhận không được cập nhật đúng
    Should Be Equal As Strings    ${actual_receiver_phone}    0987654322    Số điện thoại người nhận không được cập nhật đúng

Xác Thực Kênh Bán Hàng Đã Được Cập Nhật Thành "${expected_channel_id}"
    [Documentation]    Xác thực kênh bán hàng đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_UPDATED}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    ${actual_channel_id}=    Set Variable    ${result[5]}
    Should Be Equal As Strings    ${actual_channel_id}    ${expected_channel_id}    Kênh bán hàng không được cập nhật đúng

Xác Thực Chi Nhánh Đã Được Chuyển Thành "${expected_branch_id}"
    [Documentation]    Xác thực chi nhánh đã được chuyển đúng
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_UPDATED}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    ${actual_branch_id}=    Set Variable    ${result[4]}
    Should Be Equal As Strings    ${actual_branch_id}    ${expected_branch_id}    Chi nhánh không được chuyển đúng

Xác Thực Đơn Hàng Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng đã được hoàn thiện (status = 3)
    ${result}=    Fetch One    ${QUERY_CHECK_ORDER_COMPLETION}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không được hoàn thiện hoặc trạng thái không đúng

Xác Thực Hóa Đơn Đã Được Tạo Từ Đơn Hàng
    [Documentation]    Xác thực hóa đơn đã được tạo từ đơn hàng
    ${result}=    Fetch One    ${QUERY_CHECK_INVOICE_FROM_ORDER}    ${UPDATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy hóa đơn được tạo từ đơn hàng
    ${invoice_id}=    Set Variable    ${result[0]}
    Set Test Variable    ${CREATED_INVOICE_ID}    ${invoice_id}

Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm ${product_id}
    [Documentation]    Xác thực tồn kho đã được cập nhật đúng cho sản phẩm
    ${result}=    Fetch One    ${QUERY_CHECK_INVENTORY_AFTER_UPDATE}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin tồn kho cho sản phẩm

Xác Thực Lịch Sử Tồn Kho Đã Được Ghi Nhận Cho Sản Phẩm ${product_id}
    [Documentation]    Xác thực lịch sử tồn kho đã được ghi nhận
    ${result}=    Fetch One    ${QUERY_CHECK_INVENTORY_TRACKING}    ${UPDATED_ORDER_ID}    ${product_id}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy lịch sử tồn kho cho sản phẩm

Xác Thực Thông Tin Serial Đã Được Cập Nhật
    [Documentation]    Xác thực thông tin serial đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_SERIAL_TRACKING}    ${UPDATED_ORDER_ID}    3
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin serial tracking

Xác Thực Thông Tin Batch Đã Được Cập Nhật
    [Documentation]    Xác thực thông tin batch đã được cập nhật đúng
    ${result}=    Fetch One    ${QUERY_CHECK_BATCH_TRACKING}    ${UPDATED_ORDER_ID}    3
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy thông tin batch tracking

# =============================================================================
# Keywords xác thực lỗi
# =============================================================================

Xác Thực Lỗi Sản Phẩm Trùng Lặp Trong Đơn Hàng
    [Documentation]    Xác thực lỗi khi đơn hàng có sản phẩm trùng lặp
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Sản phẩm bị trùng lặp trong đơn hàng"

Xác Thực Lỗi UUID Trùng Lặp
    [Documentation]    Xác thực lỗi khi UUID đơn hàng trùng lặp
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "UUID đã tồn tại"

Xác Thực Lỗi Mã Đơn Hàng Trùng Lặp
    [Documentation]    Xác thực lỗi khi mã đơn hàng trùng lặp
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Mã đơn hàng đã tồn tại"

Xác Thực Lỗi Khách Hàng Không Tồn Tại
    [Documentation]    Xác thực lỗi khi khách hàng không tồn tại
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Khách hàng không tồn tại"

Xác Thực Lỗi Nhân Viên Không Tồn Tại
    [Documentation]    Xác thực lỗi khi nhân viên không tồn tại
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Nhân viên không tồn tại"

Xác Thực Lỗi Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Xác thực lỗi khi kênh bán hàng không tồn tại
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Kênh bán hàng không tồn tại"

Xác Thực Lỗi Khuyến Mãi Đã Bị Xóa
    [Documentation]    Xác thực lỗi khi khuyến mãi đã bị xóa
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Khuyến mãi đã bị xóa"

Xác Thực Lỗi Đối Tác Giao Hàng Không Hợp Lệ
    [Documentation]    Xác thực lỗi khi đối tác giao hàng không hợp lệ
    Mã trạng thái phải là 420
    Phản hồi phải chứa lỗi "Đối tác giao hàng không hợp lệ"

# =============================================================================
# Template Keywords cho test cases
# =============================================================================

Cập Nhật Số Lượng Sản Phẩm Và Xác Thực
    [Arguments]    ${old_quantity}    ${new_quantity}    ${expected_total}
    [Documentation]    Template keyword để cập nhật số lượng sản phẩm và xác thực kết quả
    Given Chuẩn Bị Dữ Liệu Cập Nhật Số Lượng Sản Phẩm Từ ${old_quantity} Thành ${new_quantity}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Số Lượng Sản Phẩm Đã Được Cập Nhật Thành ${new_quantity}

Cập Nhật Khách Hàng Và Xác Thực
    [Arguments]    ${old_customer_id}    ${new_customer_id}
    [Documentation]    Template keyword để cập nhật khách hàng và xác thực kết quả
    Given Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Từ "${old_customer_id}" Thành "${new_customer_id}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Khách Hàng Đã Được Cập Nhật Thành "${new_customer_id}"

Cập Nhật Thanh Toán Và Xác Thực
    [Arguments]    ${payment_method}    ${amount}
    [Documentation]    Template keyword để cập nhật thanh toán và xác thực kết quả
    Given Chuẩn Bị Dữ Liệu Cập Nhật Thanh Toán Phương Thức "${payment_method}" Số Tiền ${amount}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Thanh Toán Đã Được Cập Nhật Phương Thức "${payment_method}" Số Tiền ${amount}

Cập Nhật Kênh Bán Hàng Và Xác Thực
    [Arguments]    ${old_channel_id}    ${new_channel_id}
    [Documentation]    Template keyword để cập nhật kênh bán hàng và xác thực kết quả
    Given Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Từ "${old_channel_id}" Thành "${new_channel_id}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Cập Nhật Trong Database
    And Xác Thực Kênh Bán Hàng Đã Được Cập Nhật Thành "${new_channel_id}" 