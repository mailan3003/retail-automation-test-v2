*** Settings ***
Documentation     Keywords cho chức năng hoàn thiện đơn hàng
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../../TestData/Order/CompleteOrderData.robot
Resource          ../../TestData/CommonData.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           json

*** Keywords ***
# =============================================================================
# Keywords chuẩn bị dữ liệu test
# =============================================================================

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng cơ bản
    ${request_json}=    Evaluate    json.dumps(${BASE_COMPLETE_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Và Tạo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng và tạo hóa đơn
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_AND_MAKE_INVOICE_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng COD
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng COD
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_COD_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Thanh Toán
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có thanh toán
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_ORDER_WITH_PAYMENT_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có khuyến mãi
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_ORDER_WITH_PROMOTION_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Serial
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có sản phẩm serial
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_SERIAL_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Lô
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có sản phẩm lô
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_BATCH_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Combo
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có combo
    ${request_json}=    Evaluate    json.dumps(${COMPLETE_COMBO_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Với Khách Hàng "${customer_id}" Tổng Tiền ${total} Và Complete ${complete}
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng với tham số tùy chỉnh
    ${request_json}=    Evaluate    json.dumps(${BASE_COMPLETE_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set To Dictionary    ${request["Order"]}    CustomerId=${customer_id}
    Set To Dictionary    ${request["Order"]}    Total=${total}
    Set To Dictionary    ${request}    Complete=${complete}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords chuẩn bị dữ liệu lỗi
# =============================================================================

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng đã hoàn thiện (lỗi)
    ${request_json}=    Evaluate    json.dumps(${ALREADY_FINALIZED_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng không tồn tại (lỗi)
    ${request_json}=    Evaluate    json.dumps(${NONEXISTENT_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Hết Hàng
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng có sản phẩm hết hàng (lỗi)
    ${request_json}=    Evaluate    json.dumps(${OUT_OF_STOCK_ORDER_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng ID Không Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu hoàn thiện đơn hàng ID không hợp lệ (lỗi)
    ${request_json}=    Evaluate    json.dumps(${INVALID_ORDER_ID_REQUEST})    json
    ${request}=    Evaluate    json.loads($request_json)    json
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords gửi yêu cầu API
# =============================================================================

Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    [Documentation]    Gửi yêu cầu hoàn thiện đơn hàng đến API
    ${response}=    Call API With BranchId    ${COMPLETE_ORDER_ENDPOINT}    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Completed Order Id From Response
    RETURN    ${response}

Set Completed Order Id From Response
    [Documentation]    Lưu ID đơn hàng đã hoàn thiện từ response
    ${order_id}=    Get From Dictionary    ${RESPONSE_JSON}    Id
    Set Test Variable    ${COMPLETED_ORDER_ID}    ${order_id}

# =============================================================================
# Keywords xác thực response
# =============================================================================

Phản Hồi Phải Chứa Lỗi "${expected_error}"
    [Documentation]    Xác thực thông báo lỗi trong response
    ${response_text}=    Set Variable    ${RESPONSE.text}
    Should Contain    ${response_text}    ${expected_error}    
    ...    Response phải chứa thông báo lỗi "${expected_error}", nhưng thực tế là: ${response_text}

Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Xác thực response chứa thông tin đơn hàng đã hoàn thiện
    Should Not Be Equal    ${RESPONSE_JSON}    ${None}    Response JSON không được rỗng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Id    Response phải chứa ID đơn hàng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Code    Response phải chứa mã đơn hàng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Status    Response phải chứa trạng thái đơn hàng
    ${status}=    Get From Dictionary    ${RESPONSE_JSON}    Status
    Should Be Equal As Numbers    ${status}    3    Trạng thái đơn hàng phải là 3 (Finalized)

Xác Thực Response Chứa Thông Tin Thanh Toán
    [Documentation]    Xác thực response chứa thông tin thanh toán
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Payments    Response phải chứa thông tin thanh toán
    ${payments}=    Get From Dictionary    ${RESPONSE_JSON}    Payments
    Should Not Be Empty    ${payments}    Danh sách thanh toán không được rỗng

Xác Thực Response Chứa Thông Tin Giao Hàng COD
    [Documentation]    Xác thực response chứa thông tin giao hàng COD
    Dictionary Should Contain Key    ${RESPONSE_JSON}    DeliveryInfo    Response phải chứa thông tin giao hàng
    ${delivery_info}=    Get From Dictionary    ${RESPONSE_JSON}    DeliveryInfo
    Should Not Be Equal    ${delivery_info}    ${None}    Thông tin giao hàng không được rỗng
    Dictionary Should Contain Key    ${delivery_info}    UsingCod    Thông tin giao hàng phải chứa UsingCod
    ${using_cod}=    Get From Dictionary    ${delivery_info}    UsingCod
    Should Be Equal As Numbers    ${using_cod}    1    UsingCod phải bằng 1

# =============================================================================
# Keywords xác thực database
# =============================================================================

Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    [Documentation]    Xác thực đơn hàng đã được hoàn thiện trong database
    ${order_id}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    Id
    ${result}=    Fetch One    ${QUERY_GET_ORDER_BY_ID}    ${order_id}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy đơn hàng với ID ${order_id}
    ${db_status}=    Set Variable    ${result[2]}
    Should Be Equal As Numbers    ${db_status}    3    
    ...    Trạng thái đơn hàng trong database phải là 3 (Finalized), nhưng thực tế là ${db_status}
    Log    Đơn hàng ID ${order_id} đã được hoàn thiện thành công với trạng thái ${db_status}

Xác Thực Thông Tin Chi Tiết Đơn Hàng Trong Database
    [Documentation]    Xác thực thông tin chi tiết đơn hàng trong database
    ${order_id}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    Id
    ${details}=    Fetch All    ${QUERY_GET_ORDER_DETAILS_BY_ORDER_ID}    ${order_id}
    Should Not Be Empty    ${details}    Chi tiết đơn hàng không được rỗng
    ${expected_details}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    OrderDetails
    ${details_count}=    Get Length    ${details}
    ${expected_count}=    Get Length    ${expected_details}
    Should Be Equal As Numbers    ${details_count}    ${expected_count}    
    ...    Số lượng chi tiết đơn hàng phải là ${expected_count}, nhưng thực tế là ${details_count}
    Log    Xác thực thành công ${details_count} chi tiết đơn hàng

Xác Thực Thông Tin Thanh Toán Trong Database
    [Documentation]    Xác thực thông tin thanh toán trong database
    ${order_id}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    Id
    ${payments}=    Fetch All    ${QUERY_GET_PAYMENTS_BY_ORDER_ID}    ${order_id}
    ${expected_payments}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    Payments
    ${payments_count}=    Get Length    ${payments}
    ${expected_count}=    Get Length    ${expected_payments}
    Should Be Equal As Numbers    ${payments_count}    ${expected_count}    
    ...    Số lượng thanh toán phải là ${expected_count}, nhưng thực tế là ${payments_count}
    Log    Xác thực thành công ${payments_count} thanh toán

Xác Thực Thông Tin Giao Hàng COD Trong Database
    [Documentation]    Xác thực thông tin giao hàng COD trong database
    ${order_id}=    Get From Dictionary    ${REQUEST_DATA["Order"]}    Id
    ${delivery_info}=    Fetch One    ${QUERY_GET_DELIVERY_INFO_BY_ORDER_ID}    ${order_id}
    Should Not Be Equal    ${delivery_info}    None    Không tìm thấy thông tin giao hàng cho đơn hàng ${order_id}
    ${using_cod}=    Set Variable    ${delivery_info[3]}
    Should Be Equal As Numbers    ${using_cod}    1    
    ...    UsingCod phải bằng 1, nhưng thực tế là ${using_cod}
    Log    Xác thực thành công thông tin giao hàng COD cho đơn hàng ${order_id}

Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${product_id}" Chi Nhánh "${branch_id}"
    [Documentation]    Xác thực tồn kho đã được cập nhật sau khi hoàn thiện đơn hàng
    ${inventory}=    Fetch One    ${QUERY_GET_INVENTORY_BY_PRODUCT_BRANCH}    ${product_id}    ${branch_id}    ${RETAILER_ID}
    Should Not Be Equal    ${inventory}    None    
    ...    Không tìm thấy thông tin tồn kho cho sản phẩm ${product_id} tại chi nhánh ${branch_id}
    ${on_hand}=    Set Variable    ${inventory[0]}
    ${available}=    Set Variable    ${inventory[1]}
    Should Be True    ${on_hand} >= 0    Tồn kho OnHand phải >= 0, nhưng thực tế là ${on_hand}
    Should Be True    ${available} >= 0    Tồn kho Available phải >= 0, nhưng thực tế là ${available}
    Log    Tồn kho sản phẩm ${product_id}: OnHand=${on_hand}, Available=${available}

Xác Thực Dư Nợ Khách Hàng Đã Được Cập Nhật Cho Khách Hàng "${customer_id}"
    [Documentation]    Xác thực dư nợ khách hàng đã được cập nhật sau khi hoàn thiện đơn hàng
    ${customer_debt}=    Fetch One    ${QUERY_GET_CUSTOMER_DEBT}    ${customer_id}    ${RETAILER_ID}
    Should Not Be Equal    ${customer_debt}    None    
    ...    Không tìm thấy thông tin khách hàng ${customer_id}
    ${debt_limit}=    Set Variable    ${customer_debt[0]}
    ${debt}=    Set Variable    ${customer_debt[1]}
    Should Be True    ${debt} >= 0    Dư nợ khách hàng phải >= 0, nhưng thực tế là ${debt}
    Log    Dư nợ khách hàng ${customer_id}: DebtLimit=${debt_limit}, Debt=${debt}

# =============================================================================
# Keywords xác thực nghiệp vụ cụ thể
# =============================================================================

Xác Thực Đơn Hàng Đã Được Hoàn Thiện Và Tạo Hóa Đơn
    [Documentation]    Xác thực đơn hàng đã được hoàn thiện và tạo hóa đơn
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    # Kiểm tra hóa đơn được tạo từ đơn hàng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    InvoiceId    Response phải chứa ID hóa đơn được tạo
    ${invoice_id}=    Get From Dictionary    ${RESPONSE_JSON}    InvoiceId
    Should Be True    ${invoice_id} > 0    ID hóa đơn phải > 0, nhưng thực tế là ${invoice_id}
    Log    Đơn hàng đã được hoàn thiện và tạo hóa đơn với ID ${invoice_id}

Xác Thực Đơn Hàng COD Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng COD đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    Xác Thực Response Chứa Thông Tin Giao Hàng COD
    Xác Thực Thông Tin Giao Hàng COD Trong Database

Xác Thực Đơn Hàng Có Thanh Toán Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng có thanh toán đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    Xác Thực Response Chứa Thông Tin Thanh Toán
    Xác Thực Thông Tin Thanh Toán Trong Database

Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng có khuyến mãi đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    # Kiểm tra thông tin khuyến mãi
    ${total}=    Get From Dictionary    ${RESPONSE_JSON}    Total
    ${discount}=    Get From Dictionary    ${RESPONSE_JSON}    Discount
    Should Be True    ${discount} > 0    Chiết khấu phải > 0, nhưng thực tế là ${discount}
    Log    Đơn hàng có khuyến mãi đã được hoàn thiện: Total=${total}, Discount=${discount}

Xác Thực Đơn Hàng Có Sản Phẩm Serial Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng có sản phẩm serial đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${PRODUCT_ID_SERIAL}" Chi Nhánh "${DEFAULT_BRANCH_ID}"

Xác Thực Đơn Hàng Có Sản Phẩm Lô Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng có sản phẩm lô đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${product_batch}" Chi Nhánh "${DEFAULT_BRANCH_ID}"

Xác Thực Đơn Hàng Có Combo Đã Được Hoàn Thiện
    [Documentation]    Xác thực đơn hàng có combo đã được hoàn thiện
    Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${COMBO_PRODUCT_1_ID}" Chi Nhánh "${DEFAULT_BRANCH_ID}"
    # Kiểm tra tồn kho của các sản phẩm thành phần combo
    Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${COMBO_PRODUCT_1_MATTERIAL_1_ID}" Chi Nhánh "${DEFAULT_BRANCH_ID}"
    Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${COMBO_PRODUCT_1_MATTERIAL_2_ID}" Chi Nhánh "${DEFAULT_BRANCH_ID}"

# =============================================================================
# Keywords xác thực lỗi
# =============================================================================

Xác Thực Lỗi Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Xác thực lỗi khi hoàn thiện đơn hàng đã hoàn thiện
    Mã Trạng Thái Phải Là 420
    Phản Hồi Phải Chứa Lỗi "Đơn hàng đã được hoàn thiện"

Xác Thực Lỗi Đơn Hàng Không Tồn Tại
    [Documentation]    Xác thực lỗi khi hoàn thiện đơn hàng không tồn tại
    Mã Trạng Thái Phải Là 404
    Phản Hồi Phải Chứa Lỗi "Không tìm thấy đơn hàng"

Xác Thực Lỗi Sản Phẩm Hết Hàng
    [Documentation]    Xác thực lỗi khi hoàn thiện đơn hàng có sản phẩm hết hàng
    Mã Trạng Thái Phải Là 420
    Phản Hồi Phải Chứa Lỗi "Sản phẩm không đủ tồn kho"

Xác Thực Lỗi ID Đơn Hàng Không Hợp Lệ
    [Documentation]    Xác thực lỗi khi hoàn thiện đơn hàng với ID không hợp lệ
    Mã Trạng Thái Phải Là 420
    Phản Hồi Phải Chứa Lỗi "ID đơn hàng không hợp lệ" 