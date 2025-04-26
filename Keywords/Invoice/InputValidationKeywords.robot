*** Settings ***
Documentation     Keywords cho test cases API của InputValidationTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../../TestData/Invoice/Invoice_Validation_Data.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime
*** Variables ***
${CUSTOMER_OTHER_BRANCH}    1000009380
${BRANCH_NOT_EXIST}    4234325
${INACTIVE_PRODUCT_ID}    1000014522
${SERIAL_SOLD}    GSU1Y
${PRODUCT_ID_STOCK_OUT}    1000017692
${PRODUCT_ID_NT}   1000017642

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Chi Nhánh
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.BranchId    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chi Nhánh Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.BranchId    ${BRANCH_NOT_EXIST}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trước Ngày Khóa Sổ
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.PurchaseDate    25-04-2025
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.BranchId    ${BRANCH_ID_NHANH_A}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.CustomerId    7835222
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Chi Nhánh Khác
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.CustomerId    ${CUSTOMER_OTHER_BRANCH}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Người Bán
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.SoldById    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Bán Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.SoldById   5355333335
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trong Tương Lai
    ${current_date}=    Get Current Date   
    ${future_date}=    Add Time To Date    ${current_date}    3 day   
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.PurchaseDate    ${future_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Không Có Sản Phẩm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${None}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${None}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Sản Phẩm Bằng 0
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    0
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Sản Phẩm Âm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    -1
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng Gian Không Cho Phép Bán Âm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${PRODUCT_ID_STOCK_OUT}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
    
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${ma_hh} Gian Không Cho Phép Bán Âm
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    10
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${result[0]}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giá Bán Âm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Price    -1
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đã Ngừng Kinh Doanh
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${INACTIVE_PRODUCT_ID}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    0
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId    ${PRODUCT_ID_SERIAL}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   88888
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Đã Bán
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId    ${PRODUCT_ID_SERIAL}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    IsLotSerialControl    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   ${SERIAL_SOLD}  
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Số Lượng Không Hợp Lệ
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId    ${PRODUCT_ID_SERIAL}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    IsLotSerialControl    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   ${SERIAL_SOLD}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    2
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Lô Date ${ma_hh} Không Đủ Số Lượng
    ${query_1}=    Set Variable    SELECT ID FROM Product WHERE Code = ?
    ${query_2}=    Set Variable    SELECT ID FROM ProductBatchExpire WHERE ProductId = ?
    ${result}=    Fetch One    ${query_1}    ${ma_hh}
    ${result_batch}=    Fetch One    ${query_2}     ${result[0]}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    120000
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId   ${result[0]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsBatchExpireControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductBatchExpireId   ${result_batch[0]}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers    ${OVERPAYMENT_INVOICE}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Bảo Hành Không Có Thời Hạn
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    UseWarranty    ${true}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails.ProductWarranty    ${warranty_data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức Thanh Toán Có Số Tiền Âm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${payment_data}=    Deep Copy   ${payment_body} 
    ${payment_data}=    Update Nested Dictionary Property  ${payment_data}    Amount    -1000
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.Payments    ${payment_data}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng ${customer_code} Thay Toán ${payment} Gian Bật Không Cho Phép Nợ
    ${query_1}=    Set Variable    SELECT ID FROM Customer WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${customer_code}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${product_data}=    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${product_data}=    Update Nested Dictionary Property  ${product_data}   ProductId    ${PRODUCT_ID_NT}
    ${payment_data}=    Deep Copy   ${payment_body} 
    ${payment_data}=    Update Nested Dictionary Property  ${payment_data}    Amount    ${payment}
     ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${product_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.CustomerId    ${result[0]}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property  ${request}    PaymentMethod    ${POINT_PAYMENT_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn COD
    [Arguments]    ${delivery_info}=${VALID_DELIVERY_INFO}
    ${data}=    Set Variable    ${COD_INVOICE}
    Run Keyword If    ${delivery_info} != ${None}    Set To Dictionary    ${data}    DeliveryInfo=${delivery_info}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}
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