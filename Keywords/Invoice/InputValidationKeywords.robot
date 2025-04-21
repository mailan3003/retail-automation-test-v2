*** Settings ***
Documentation     Keywords cho test cases API của InputValidationTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/Invoice_Validation_Data.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${STANDARD_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Không Hợp Lệ
    ${data}=    Set Variable    ${INVALID_CODE_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Trùng
    ${data}=    Set Variable    ${INVOICE_DUPLICATED_CODE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Mã Dài
    ${data}=    Set Variable    ${LONG_CODE_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật
    [Arguments]    ${data}=${UPDATE_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Từ Đơn Hàng
    [Arguments]    ${data}=${ORDER_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    ${data}=    Set Variable    ${INVALID_CUSTOMER_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    ${data}=    Set Variable    ${OTHER_BRANCH_CUSTOMER_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    ${data}=    Set Variable    ${POINT_PAYMENT_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn COD
    [Arguments]    ${delivery_info}=${VALID_DELIVERY_INFO}
    ${data}=    Set Variable    ${COD_INVOICE}
    Run Keyword If    ${delivery_info} != ${None}    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng
    ${data}=    Set Variable    ${OUT_OF_STOCK_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Hợp Lệ
    ${data}=    Set Variable    ${INVALID_SERIAL_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Trùng
    ${data}=    Set Variable    ${DUPLICATE_SERIAL_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Theo Lô
    [Arguments]    ${data}=${BATCH_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá
    ${data}=    Set Variable    ${OVERPAYMENT_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sổ Giá
    [Arguments]    ${data}=${PRICEBOOK_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Và Khuyến Mãi
    ${data}=    Set Variable    ${VOUCHER_PROMOTION_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Kê Đơn
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{prescription_product}=    Create Dictionary
    ...    ProductId=${PRESCRIPTION_DRUG_ID}
    ...    Quantity=1
    ...    Price=50000
    
    ${details}=    Create List    ${prescription_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Hoạt Động
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{inactive_product}=    Create Dictionary
    ...    ProductId=${INACTIVE_PRODUCT_ID}
    ...    Quantity=1
    ...    Price=100000
    
    ${details}=    Create List    ${inactive_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    
    &{combo_product}=    Create Dictionary
    ...    ProductId=${COMBO_PRODUCT_ID}
    ...    Quantity=1
    ...    Price=300000
    
    ${details}=    Create List    ${combo_product}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Gửi Yêu Cầu Tạo Hóa Đơn    
    ${response}=    Call API    invoices    ${REQUEST_DATA} 
    Set Test Variable    ${RESPONSE}     ${response}

# DB Validation Keywords
Xác Thực Hóa Đơn Trong DB
    [Documentation]    Xác thực hóa đơn tồn tại trong CSDL và các thông tin chi tiết
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Xác Thực Hóa Đơn Tồn Tại    ${invoice_id}

Xác Thực Hóa Đơn Tồn Tại
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

Xác Thực Chi Tiết Hóa Đơn
    [Arguments]    ${invoice_id}    ${product_id}    ${quantity}
    ${query}=    Set Variable    SELECT InvoiceId, ProductId, Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Log     ${result}
    Log     ${invoice_id}
    Log     ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${quantity}    Số lượng sản phẩm không khớp

Xác Thực Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${method}    ${amount}
    ${query}=    Set Variable    SELECT InvoiceId, Method, Value FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}
    Should Not Be Equal    ${result}    None    Thanh toán không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${amount}    Số tiền thanh toán không khớp

Xác Thực Thông Tin Giao Hàng
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT InvoiceId, ReceiverName, ReceiverPhone FROM DeliveryInfo WHERE InvoiceId = ?
    ${delivery_info}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${delivery_info}    None    Thông tin giao hàng không tồn tại
    Should Be Equal    ${delivery_info[1]}    Test Receiver    Tên người nhận không đúng
    Should Be Equal    ${delivery_info[2]}    0987654321    SĐT người nhận không đúng

Xác Thực Thông Tin Lô
    [Arguments]    ${invoice_id}    ${product_id}    ${batch_id}
    ${query}=    Set Variable    SELECT Id FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${detail_id}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${detail_id}    None    Chi tiết hóa đơn không tồn tại
    
    ${query}=    Set Variable    SELECT InvoiceDetailId, BatchId FROM InvoiceDetailBatch WHERE BatchId = ?
    ${batch_info}=    Fetch One    ${query}    ${batch_id}
    Should Not Be Equal    ${batch_info}    None    Thông tin lô không tồn tại
    Should Be Equal As Numbers    ${batch_info[0]}    ${detail_id[0]}    ID chi tiết hóa đơn không khớp

Xác Thực Tiền Thừa
    [Arguments]    ${invoice_id}    ${expected_change}
    ${query}=    Set Variable    SELECT Total, TotalPayment FROM Invoice WHERE Id = ?
    ${invoice_totals}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${invoice_totals}    None    Hóa đơn không tồn tại
    ${change}=    Evaluate    ${invoice_totals[1]} - ${invoice_totals[0]}
    Should Be True    ${change} >= ${expected_change}    Tiền thừa không đúng

Xác Thực Thông Tin Sổ Giá
    [Arguments]    ${invoice_id}    ${pricebook_id}
    ${query}=    Set Variable    SELECT PriceBookId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại
    Should Be Equal As Numbers    ${result[0]}    ${pricebook_id}    PriceBookId không đúng

Xác Thực Thông Tin Combo
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT COUNT(*) FROM InvoiceComboDetail WHERE InvoiceId = ?
    ${combo_count}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${combo_count}    None    Thông tin combo không tồn tại
    Should Be True    ${combo_count[0]} > 0    Không có chi tiết combo

Xác Thực Hóa Đơn Từ Đơn Hàng
    [Arguments]    ${invoice_id}    ${order_id}
    Xác Thực Hóa Đơn Tồn Tại    ${invoice_id}
    ${query}=    Set Variable    SELECT OrderId FROM Invoice WHERE Id = ?
    ${invoice_order_id}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${invoice_order_id}    None    Hóa đơn không tồn tại
    Should Be Equal As Numbers    ${invoice_order_id[0]}    ${order_id}    OrderId trong hóa đơn không đúng

Xác Thực Hóa Đơn Cập Nhật
    [Arguments]    ${invoice_id}    ${old_invoice_id}
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${old_invoice_status}=    Fetch One    ${query}    ${old_invoice_id}
    Should Not Be Equal    ${old_invoice_status}    None    Hóa đơn cũ không tồn tại
    Should Be Equal As Numbers    ${old_invoice_status[0]}    3    Hóa đơn cũ chưa được đánh dấu đã cập nhật 

Xác Thực Hóa Đơn Tồn Tại Trong DB
    [Arguments]    ${invoice_id}    
    ${query}=    Set Variable    SELECT Id, Code, Status FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
Xác Thực Chi Tiết Hóa Đơn Trong DB
    [Arguments]    ${invoice_id}    ${product_id}    ${quantity}
    ${query}=    Set Variable    SELECT InvoiceId, ProductId, Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${quantity}    Số lượng sản phẩm không khớp

Xác Thực Thanh Toán Hóa Đơn Trong DB
    [Arguments]    ${invoice_id}    ${method}    ${amount}
    ${query}=    Set Variable    SELECT InvoiceId, Method, Value FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}
    Should Not Be Equal    ${result}    None    Thanh toán không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${amount}    Số tiền thanh toán không khớp