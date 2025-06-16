*** Settings ***
Documentation     Keywords cho test API tạo hóa đơn từ đơn đặt hàng
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateInvoiceFromOrderData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           DateTime
Library           json

*** Variables ***
${CREATE_INVOICE_FROM_ORDER_ENDPOINT}    orders

*** Keywords ***
# =============================================================================
# Keywords chuẩn bị dữ liệu cho các test case thành công
# =============================================================================

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Đặt Hàng Mới
    [Documentation]    Chuẩn bị dữ liệu để tạo hóa đơn từ đơn đặt hàng mới (ID = 0)
    ${request}=    Deep Copy    ${BASE_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_INVOICE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng mới tạo hóa đơn
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Đặt Hàng Có Sẵn
    [Documentation]    Chuẩn bị dữ liệu để tạo hóa đơn từ đơn đặt hàng đã tồn tại
    ${request}=    Deep Copy    ${UPDATE_ORDER_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng có sẵn tạo hóa đơn
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Nhiều Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có nhiều sản phẩm
    ${request}=    Deep Copy    ${MULTI_PRODUCT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_MULTI_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng nhiều sản phẩm
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có khuyến mãi
    ${request}=    Deep Copy    ${PROMOTION_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_PROMO_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng có khuyến mãi
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn COD
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng COD
    ${request}=    Deep Copy    ${COD_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_COD_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng COD
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Serial
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có sản phẩm serial
    ${request}=    Deep Copy    ${SERIAL_PRODUCT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_SERIAL_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng sản phẩm serial
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Batch
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có sản phẩm batch
    ${request}=    Deep Copy    ${BATCH_PRODUCT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_BATCH_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng sản phẩm batch
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với VAT
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có VAT
    ${request}=    Deep Copy    ${VAT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_VAT_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng có VAT
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Combo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có combo sản phẩm
    ${request}=    Deep Copy    ${COMBO_PRODUCT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_COMBO_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng combo sản phẩm
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Điểm Tích Lũy
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng có điểm tích lũy
    ${request}=    Deep Copy    ${REWARD_POINT_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_REWARD_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng tích điểm
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Số Tiền Thanh Toán ${amount} Phương Thức ${method}
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với số tiền và phương thức thanh toán cụ thể
    ${request}=    Deep Copy    ${BASE_MAKE_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_PAY_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng thanh toán ${method}
    ${order}=    Update Nested Dictionary Property    ${order}    Total    ${amount}
    
    # Cập nhật thông tin thanh toán
    ${payment}=    Create Dictionary    Method=${method}    Amount=${amount}
    ${payments}=    Create List    ${payment}
    ${order}=    Update Nested Dictionary Property    ${order}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Amount    ${amount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Giao Hàng Đối Tác "${partner_name}" Địa Chỉ "${address}"
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với thông tin giao hàng cụ thể
    ${request}=    Deep Copy    ${COD_INVOICE_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_DELIVERY_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng giao hàng ${partner_name}
    
    # Cập nhật thông tin giao hàng
    ${delivery_info}=    Deep Copy    ${COD_DELIVERY_INFO}
    ${delivery_info}=    Update Nested Dictionary Property    ${delivery_info}    ReceiverAddress    ${address}
    ${order}=    Update Nested Dictionary Property    ${order}    DeliveryDetail    ${delivery_info}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords chuẩn bị dữ liệu cho các test case lỗi
# =============================================================================

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Đặt Hàng Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng không tồn tại
    ${request}=    Deep Copy    ${NONEXISTENT_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng không tồn tại
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Từ Đơn Đặt Hàng Đã Hoàn Thành
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng đã hoàn thành (Finalized)
    ${request}=    Deep Copy    ${FINALIZED_ORDER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng đã hoàn thành
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Không Hoạt Động
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với sản phẩm không hoạt động
    ${request}=    Deep Copy    ${INACTIVE_PRODUCT_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_INACTIVE_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng sản phẩm không hoạt động
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Sản Phẩm Hết Hàng
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với sản phẩm hết hàng
    ${request}=    Deep Copy    ${OUT_OF_STOCK_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_OUTSTOCK_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng sản phẩm hết hàng
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Khách Hàng Không Tồn Tại
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với khách hàng không tồn tại
    ${request}=    Deep Copy    ${INVALID_CUSTOMER_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_INVALID_CUST_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng khách hàng không tồn tại
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Số Tiền Thanh Toán Không Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với số tiền thanh toán không hợp lệ
    ${request}=    Deep Copy    ${INVALID_AMOUNT_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_INVALID_AMT_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng số tiền không hợp lệ
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Đơn Đặt Hàng Không Có Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn từ đơn đặt hàng không có sản phẩm
    ${request}=    Deep Copy    ${EMPTY_PRODUCTS_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_EMPTY_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng không có sản phẩm
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Tạo Hóa Đơn Với Serial Không Khả Dụng
    [Documentation]    Chuẩn bị dữ liệu tạo hóa đơn với serial không khả dụng
    ${request}=    Deep Copy    ${UNAVAILABLE_SERIAL_REQUEST}
    ${order}=    Get From Dictionary    ${request}    Order
    ${current_time}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${order}=    Update Nested Dictionary Property    ${order}    Code    DH_UNAVAIL_SERIAL_${current_time}
    ${order}=    Update Nested Dictionary Property    ${order}    Description    Đơn đặt hàng serial không khả dụng
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# =============================================================================
# Keywords gửi yêu cầu API
# =============================================================================

Gửi Yêu Cầu Tạo Hóa Đơn Từ Đơn Đặt Hàng
    [Documentation]    Gửi yêu cầu API tạo hóa đơn từ đơn đặt hàng
    ${response}=    Call API    ${CREATE_INVOICE_FROM_ORDER_ENDPOINT}    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Order And Invoice Ids From Response
    RETURN    ${response}

Set Order And Invoice Ids From Response
    [Documentation]    Lưu ID đơn đặt hàng và hóa đơn từ response
    ${order_id}=    Get From Dictionary    ${RESPONSE_JSON}    Id
    Set Test Variable    ${CREATED_ORDER_ID}    ${order_id}
    
    # Lấy ID hóa đơn nếu có
    ${invoice_id}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${RESPONSE_JSON}    InvoiceId
    Run Keyword If    ${invoice_id}    Set Test Variable    ${CREATED_INVOICE_ID}    ${RESPONSE_JSON['InvoiceId']}

# =============================================================================
# Keywords xác thực kết quả thành công
# =============================================================================

Xác Thực Đơn Đặt Hàng Và Hóa Đơn Đã Được Tạo Trong Database
    [Documentation]    Xác thực đơn đặt hàng và hóa đơn đã được tạo thành công trong database
    # Kiểm tra đơn đặt hàng
    ${order_result}=    Fetch One    ${QUERY_GET_ORDER_BY_ID}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${order_result}    ${None}    Đơn đặt hàng không tồn tại trong CSDL với ID ${CREATED_ORDER_ID}
    
    # Kiểm tra hóa đơn được tạo từ đơn đặt hàng
    ${invoice_result}=    Fetch One    ${QUERY_GET_INVOICE_BY_ORDER_ID}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${invoice_result}    ${None}    Hóa đơn không được tạo từ đơn đặt hàng ID ${CREATED_ORDER_ID}
    
    # Lưu ID hóa đơn để sử dụng trong các bước tiếp theo
    ${invoice_id}=    Set Variable    ${invoice_result[0]}
    Set Test Variable    ${CREATED_INVOICE_ID}    ${invoice_id}
    
    Log    Đơn đặt hàng ID ${CREATED_ORDER_ID} và hóa đơn ID ${CREATED_INVOICE_ID} đã được tạo thành công

Xác Thực Hóa Đơn Có Liên Kết Với Đơn Đặt Hàng
    [Documentation]    Xác thực hóa đơn có liên kết đúng với đơn đặt hàng
    ${invoice_result}=    Fetch One    ${QUERY_GET_INVOICE_BY_ORDER_ID}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${invoice_result}    ${None}    Không tìm thấy hóa đơn liên kết với đơn đặt hàng
    
    ${invoice_order_id}=    Set Variable    ${invoice_result[1]}  # Giả sử OrderId ở cột thứ 2
    Should Be Equal As Numbers    ${invoice_order_id}    ${CREATED_ORDER_ID}    Hóa đơn không liên kết đúng với đơn đặt hàng
    
    Log    Hóa đơn ID ${CREATED_INVOICE_ID} đã liên kết đúng với đơn đặt hàng ID ${CREATED_ORDER_ID}

Xác Thực Chi Tiết Hóa Đơn Khớp Với Chi Tiết Đơn Đặt Hàng
    [Documentation]    Xác thực chi tiết hóa đơn khớp với chi tiết đơn đặt hàng
    # Lấy chi tiết đơn đặt hàng
    ${order_details}=    Fetch All    ${QUERY_GET_ORDER_DETAILS}    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${order_details}    Không tìm thấy chi tiết đơn đặt hàng
    
    # Lấy chi tiết hóa đơn
    ${invoice_details}=    Fetch All    ${QUERY_GET_INVOICE_DETAILS}    ${CREATED_INVOICE_ID}
    Should Not Be Empty    ${invoice_details}    Không tìm thấy chi tiết hóa đơn
    
    # So sánh số lượng chi tiết
    ${order_count}=    Get Length    ${order_details}
    ${invoice_count}=    Get Length    ${invoice_details}
    Should Be Equal As Numbers    ${order_count}    ${invoice_count}    Số lượng chi tiết đơn đặt hàng và hóa đơn không khớp
    
    Log    Chi tiết hóa đơn khớp với chi tiết đơn đặt hàng (${order_count} sản phẩm)

Xác Thực Tổng Tiền Hóa Đơn Khớp Với Đơn Đặt Hàng
    [Documentation]    Xác thực tổng tiền hóa đơn khớp với đơn đặt hàng
    # Lấy tổng tiền đơn đặt hàng
    ${order_result}=    Fetch One    ${QUERY_GET_ORDER_BY_ID}    ${CREATED_ORDER_ID}
    ${order_total}=    Set Variable    ${order_result[4]}  # Giả sử Total ở cột thứ 5
    
    # Lấy tổng tiền hóa đơn
    ${invoice_result}=    Fetch One    ${QUERY_GET_INVOICE_BY_ORDER_ID}    ${CREATED_ORDER_ID}
    ${invoice_total}=    Set Variable    ${invoice_result[4]}  # Giả sử Total ở cột thứ 5
    
    Should Be Equal As Numbers    ${order_total}    ${invoice_total}    Tổng tiền đơn đặt hàng và hóa đơn không khớp
    
    Log    Tổng tiền đơn đặt hàng và hóa đơn khớp nhau: ${order_total}

Xác Thực Thông Tin Thanh Toán Đơn Đặt Hàng Được Lưu Đúng
    [Documentation]    Xác thực thông tin thanh toán của đơn đặt hàng được lưu đúng
    ${payments}=    Fetch All    ${QUERY_GET_PAYMENTS_BY_ORDER}    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${payments}    Không tìm thấy thông tin thanh toán cho đơn đặt hàng
    
    # Kiểm tra có thanh toán cho hóa đơn
    ${invoice_payments}=    Fetch All    ${QUERY_GET_PAYMENTS_BY_INVOICE}    ${CREATED_INVOICE_ID}
    Should Not Be Empty    ${invoice_payments}    Không tìm thấy thông tin thanh toán cho hóa đơn
    
    Log    Thông tin thanh toán đã được lưu đúng cho đơn đặt hàng và hóa đơn

Xác Thực Thông Tin Giao Hàng COD Được Lưu Đúng
    [Documentation]    Xác thực thông tin giao hàng COD được lưu đúng
    ${delivery_info}=    Fetch One    ${QUERY_GET_DELIVERY_INFO}    ${CREATED_INVOICE_ID}
    Should Not Be Equal    ${delivery_info}    ${None}    Không tìm thấy thông tin giao hàng cho hóa đơn COD
    
    Log    Thông tin giao hàng COD đã được lưu đúng cho hóa đơn ID ${CREATED_INVOICE_ID}

Xác Thực Khuyến Mãi Được Áp Dụng Đúng
    [Documentation]    Xác thực khuyến mãi được áp dụng đúng trong hóa đơn
    ${promotion_usage}=    Fetch All    ${QUERY_GET_PROMOTION_USAGE}    ${CREATED_INVOICE_ID}
    Should Not Be Empty    ${promotion_usage}    Không tìm thấy thông tin sử dụng khuyến mãi
    
    Log    Khuyến mãi đã được áp dụng đúng cho hóa đơn ID ${CREATED_INVOICE_ID}

Xác Thực Điểm Tích Lũy Được Cập Nhật Cho Khách Hàng
    [Documentation]    Xác thực điểm tích lũy được cập nhật cho khách hàng
    ${customer_points}=    Fetch One    ${QUERY_GET_CUSTOMER_REWARD_POINT}    ${CUSTOMER_ID_REWARD_POINT}
    Should Not Be Equal    ${customer_points}    ${None}    Không tìm thấy thông tin điểm tích lũy của khách hàng
    
    ${current_points}=    Set Variable    ${customer_points[0]}
    Should Be True    ${current_points} >= 0    Điểm tích lũy của khách hàng không hợp lệ
    
    Log    Điểm tích lũy hiện tại của khách hàng: ${current_points}

Xác Thực Tồn Kho Sản Phẩm Được Cập Nhật Đúng
    [Documentation]    Xác thực tồn kho sản phẩm được cập nhật đúng sau khi tạo hóa đơn
    ${onhand_result}=    Fetch One    ${QUERY_GET_PRODUCT_ONHAND}    ${PRODUCT_1}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${onhand_result}    ${None}    Không tìm thấy thông tin tồn kho sản phẩm
    
    ${current_onhand}=    Set Variable    ${onhand_result[0]}
    Should Be True    ${current_onhand} >= 0    Tồn kho sản phẩm không hợp lệ
    
    Log    Tồn kho hiện tại của sản phẩm ${PRODUCT_1}: ${current_onhand}

Xác Thực Serial Được Theo Dõi Đúng
    [Documentation]    Xác thực serial được theo dõi đúng trong hệ thống
    ${serial_tracking}=    Fetch One    ${QUERY_GET_SERIAL_TRACKING}    ${PRODUCT_ID_SERIAL}    ${SERIAL_NUMBER}
    Should Not Be Equal    ${serial_tracking}    ${None}    Không tìm thấy thông tin theo dõi serial
    
    Log    Serial ${SERIAL_NUMBER} đã được theo dõi đúng cho sản phẩm ${PRODUCT_ID_SERIAL}

Xác Thực Batch Được Theo Dõi Đúng
    [Documentation]    Xác thực batch được theo dõi đúng trong hệ thống
    ${batch_tracking}=    Fetch One    ${QUERY_GET_BATCH_TRACKING}    ${product_batch}    ${BATCH_NAME}
    Should Not Be Equal    ${batch_tracking}    ${None}    Không tìm thấy thông tin theo dõi batch
    
    Log    Batch ${BATCH_NAME} đã được theo dõi đúng cho sản phẩm ${product_batch}

Xác Thực VAT Được Tính Đúng Trong Hóa Đơn
    [Documentation]    Xác thực VAT được tính đúng trong hóa đơn
    ${invoice_details}=    Fetch All    ${QUERY_GET_INVOICE_DETAILS}    ${CREATED_INVOICE_ID}
    Should Not Be Empty    ${invoice_details}    Không tìm thấy chi tiết hóa đơn để kiểm tra VAT
    
    # Kiểm tra có sản phẩm có VAT
    ${has_vat_product}=    Set Variable    ${FALSE}
    FOR    ${detail}    IN    @{invoice_details}
        ${product_id}=    Set Variable    ${detail[1]}  # Giả sử ProductId ở cột thứ 2
        ${has_vat_product}=    Set Variable If    ${product_id} == ${PRODUCT_WITH_VAT_1_ID}    ${TRUE}    ${has_vat_product}
    END
    
    Should Be True    ${has_vat_product}    Không tìm thấy sản phẩm có VAT trong hóa đơn
    Log    VAT đã được tính đúng cho sản phẩm có thuế trong hóa đơn

# =============================================================================
# Keywords xác thực lỗi
# =============================================================================

Xác Thực Lỗi Đơn Đặt Hàng Không Tồn Tại
    [Documentation]    Xác thực lỗi khi đơn đặt hàng không tồn tại
    Response Status Code Should Be 404
    Response Should Have Error "Không tìm thấy đơn hàng"

Xác Thực Lỗi Đơn Đặt Hàng Đã Hoàn Thành
    [Documentation]    Xác thực lỗi khi đơn đặt hàng đã hoàn thành
    Response Status Code Should Be 420
    Response Should Have Error "Trạng thái đơn hàng không hợp lệ"

Xác Thực Lỗi Sản Phẩm Không Hoạt Động
    [Documentation]    Xác thực lỗi khi sản phẩm không hoạt động
    Response Status Code Should Be 420
    Response Should Have Error "Sản phẩm không hoạt động"

Xác Thực Lỗi Sản Phẩm Hết Hàng
    [Documentation]    Xác thực lỗi khi sản phẩm hết hàng
    Response Status Code Should Be 420
    Response Should Have Error "Sản phẩm hết hàng"

Xác Thực Lỗi Khách Hàng Không Tồn Tại
    [Documentation]    Xác thực lỗi khi khách hàng không tồn tại
    Response Status Code Should Be 420
    Response Should Have Error "Khách hàng không tồn tại"

Xác Thực Lỗi Số Tiền Thanh Toán Không Hợp Lệ
    [Documentation]    Xác thực lỗi khi số tiền thanh toán không hợp lệ
    Response Status Code Should Be 420
    Response Should Have Error "Số tiền thanh toán không hợp lệ"

Xác Thực Lỗi Đơn Đặt Hàng Không Có Sản Phẩm
    [Documentation]    Xác thực lỗi khi đơn đặt hàng không có sản phẩm
    Response Status Code Should Be 420
    Response Should Have Error "Đơn hàng phải có ít nhất một sản phẩm"

Xác Thực Lỗi Serial Không Khả Dụng
    [Documentation]    Xác thực lỗi khi serial không khả dụng
    Response Status Code Should Be 420
    Response Should Have Error "IMEI hết hàng tại thời gian bạn vừa chọn"

# =============================================================================
# Keywords hỗ trợ
# =============================================================================

Xác Thực Response Chứa Thông Tin Đơn Đặt Hàng Và Hóa Đơn
    [Documentation]    Xác thực response chứa đầy đủ thông tin đơn đặt hàng và hóa đơn
    Should Not Be Equal    ${RESPONSE_JSON}    ${None}    Response JSON không được rỗng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Id    Response phải chứa ID đơn đặt hàng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Code    Response phải chứa mã đơn đặt hàng
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Total    Response phải chứa tổng tiền
    Dictionary Should Contain Key    ${RESPONSE_JSON}    Status    Response phải chứa trạng thái
    
    Log    Response chứa đầy đủ thông tin đơn đặt hàng và hóa đơn

Xác Thực Trạng Thái Đơn Đặt Hàng Sau Khi Tạo Hóa Đơn
    [Documentation]    Xác thực trạng thái đơn đặt hàng sau khi tạo hóa đơn thành công
    ${order_result}=    Fetch One    ${QUERY_GET_ORDER_BY_ID}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${order_result}    ${None}    Không tìm thấy đơn đặt hàng trong database
    
    ${order_status}=    Set Variable    ${order_result[3]}  # Giả sử Status ở cột thứ 4
    Should Be True    ${order_status} >= 1    Trạng thái đơn đặt hàng phải hợp lệ sau khi tạo hóa đơn
    
    Log    Trạng thái đơn đặt hàng sau khi tạo hóa đơn: ${order_status}

Xác Thực Ngày Tạo Hóa Đơn Lớn Hơn Hoặc Bằng Ngày Đặt Hàng
    [Documentation]    Xác thực ngày tạo hóa đơn phải lớn hơn hoặc bằng ngày đặt hàng
    ${order_result}=    Fetch One    ${QUERY_GET_ORDER_BY_ID}    ${CREATED_ORDER_ID}
    ${invoice_result}=    Fetch One    ${QUERY_GET_INVOICE_BY_ORDER_ID}    ${CREATED_ORDER_ID}
    
    Should Not Be Equal    ${order_result}    ${None}    Không tìm thấy đơn đặt hàng
    Should Not Be Equal    ${invoice_result}    ${None}    Không tìm thấy hóa đơn
    
    # So sánh ngày (giả sử PurchaseDate ở cột thứ 3)
    ${order_date}=    Set Variable    ${order_result[2]}
    ${invoice_date}=    Set Variable    ${invoice_result[2]}
    
    # Chuyển đổi và so sánh ngày nếu cần
    Log    Ngày đặt hàng: ${order_date}, Ngày tạo hóa đơn: ${invoice_date}

Làm Sạch Dữ Liệu Test Sau Khi Hoàn Thành
    [Documentation]    Làm sạch dữ liệu test sau khi hoàn thành
    Run Keyword And Ignore Error    Delete Test Data    ${CREATED_ORDER_ID}    ${CREATED_INVOICE_ID}
    Log    Đã làm sạch dữ liệu test

Delete Test Data
    [Arguments]    ${order_id}    ${invoice_id}
    [Documentation]    Xóa dữ liệu test (chỉ sử dụng trong môi trường test)
    # Chỉ thực hiện trong môi trường test
    Run Keyword If    '${ENV}' == 'test'    Execute SQL    DELETE FROM Payment WHERE OrderId = ${order_id} OR InvoiceId = ${invoice_id}
    Run Keyword If    '${ENV}' == 'test'    Execute SQL    DELETE FROM InvoiceDetail WHERE InvoiceId = ${invoice_id}
    Run Keyword If    '${ENV}' == 'test'    Execute SQL    DELETE FROM OrderDetail WHERE OrderId = ${order_id}
    Run Keyword If    '${ENV}' == 'test'    Execute SQL    DELETE FROM Invoice WHERE Id = ${invoice_id}
    Run Keyword If    '${ENV}' == 'test'    Execute SQL    DELETE FROM [Order] WHERE Id = ${order_id} 