*** Settings ***
Documentation     Keywords cho test cases API của InputValidationTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../../TestData/Invoice/Invoice_Validation_Data.robot
Resource          InvoiceCommonKeywords.robot
Resource          ../CommonKeywords.robot
Resource          ../Customer/CustomerCommonKeywords.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../PriceBook/PriceBookCommonKeywords.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime
Library           OperatingSystem
Library           Collections
Library           String
Library           json
Resource          ../../Config/Env_api.robot
Library           ../../Resources/RedisLibrary.py    ${REDIS_HOST}    ${REDIS_PORT}    ${REDIS_DB}    ${REDIS_PASSWORD}
*** Variables ***
${CUSTOMER_OTHER_BRANCH}    1000009380
${CUSTOMER_CODE_OTHER_BRANCH}   KH000004
${BRANCH_NOT_EXIST}    4234325
${SERIAL_SOLD}    GSU1Y
${PRODUCT_ID_STOCK_OUT}    1000017692
${PRODUCT_CODE_STOCK_OUT}    HHAM0001
${PRODUCT_ID_NT}   1000017642
${PRODUCT_CODE_NT}    HHVAT0001

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
   ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Chi Nhánh
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    BranchId    ${None}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chi Nhánh Không Tồn Tại
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    BranchId    ${BRANCH_NOT_EXIST}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trước Ngày Khóa Sổ
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    PurchaseDate    25-04-2025
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    BranchId    ${BRANCH_ID_NHANH_A}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Tồn Tại
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    7835222
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn ${product_code} Với Khách Hàng Chi Nhánh Khác
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${product_code}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${CUSTOMER_CODE_OTHER_BRANCH}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thiếu Người Bán
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SoldById    ${None}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Bán Không Tồn Tại
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SoldById   5355333335
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Ngày Trong Tương Lai
    ${current_date}=    Get Current Date   
    ${future_date}=    Add Time To Date    ${current_date}    3 day   
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    PurchaseDate    ${future_date}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Không Có Sản Phẩm
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${None}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Không Tồn Tại
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${None}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Sản Phẩm Bằng 0
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    0
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Sản Phẩm Âm
    ${request}   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    -1
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng Gian Không Cho Phép Bán Âm
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${PRODUCT_CODE_STOCK_OUT}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
    
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${ma_hh} Gian Không Cho Phép Bán Âm
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${ma_hh}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    10
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giá Bán Âm
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Price    -1
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đã Ngừng Kinh Doanh
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${INACTIVE_PRODUCT_CODE}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    ProductId    ${product_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Hết Hàng
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    0
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Serial Không Tồn Tại
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${PRODUCT_CODE_SERIAL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId     ${product_id}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   88888
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Đã Bán
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${PRODUCT_CODE_SERIAL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    IsLotSerialControl    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   ${SERIAL_SOLD}  
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Serial Số Lượng Không Hợp Lệ
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${PRODUCT_CODE_SERIAL}
    ${data_product}     Update Nested Dictionary Property    ${data_product}    ProductId    ${product_id}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    IsLotSerialControl    ${TRUE}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    SerialNumbers   ${SERIAL_SOLD}  
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    Quantity    2
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Lô Date ${ma_hh} Không Đủ Số Lượng
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${ma_hh}
    ${product_batch_expire_id}=   Lấy ID Batch của Hàng Lô      ${product_id}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    120000
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId   ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    IsBatchExpireControl   ${true}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductBatchExpireId   ${product_batch_expire_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PRODUCT_BATCH_EXPIRE_ID}   ${product_batch_expire_id}
    RETURN     ${request}



Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Bảo Hành Không Có Thời Hạn
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}  Deep Copy     ${STANDARD_INVOICE_DETAIL}
    ${warranty_data}=    Deep Copy    ${invoice_warranty_body}
    ${data_product}=    Update Nested Dictionary Property  ${data_product}    UseWarranty    ${true}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails    ${data_product}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoiceDetails.ProductWarranty    ${warranty_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức Thanh Toán Có Số Tiền Âm
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payment_data}=    Deep Copy   ${payment_body} 
    ${payment_data}=    Update Nested Dictionary Property  ${payment_data}    Amount    -1000
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng ${customer_code} Thay Toán ${payment} Gian Bật Không Cho Phép Nợ
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${customer_code}
    ${product_id}=   Lấy Thông tin Sản Phẩm     ${PRODUCT_CODE_NT}
    ${request}=    Deep Copy   ${invoice_request_body_not_delivery}
    ${product_data}=    Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${product_data}=    Update Nested Dictionary Property  ${product_data}   ProductId    ${product_id}
    ${payment_data}=    Deep Copy   ${payment_body} 
    ${payment_data}=    Update Nested Dictionary Property  ${payment_data}    Amount    ${payment}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.InvoiceDetails    ${product_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice.CustomerId   ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}


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
    [Arguments]    ${invoice_id}    ${product_code}    ${quantity}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${product_code}
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
    [Arguments]    ${invoice_id}    ${product_code}    ${batch_id}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${product_code}
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
    [Arguments]    ${invoice_id}    ${pricebook_code}
    ${pricebook_id}=   Lấy Id Bảng Giá Theo Tên Bảng Giá    ${pricebook_code}
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
    [Arguments]    ${invoice_id}    ${product_code}    ${quantity}
    ${product_id}=   Lấy Thông tin Sản Phẩm      ${product_code}
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

# CustomerDelivery Test Keywords - AIGenerated
Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Không Hoạt Động
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${INACTIVE_CUSTOMER_CODE}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    
    # Giả định hệ thống biết rằng khách hàng có ID này không hoạt động 
    # khi validate trong service
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Đã Bị Xóa
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${DELETED_CUSTOMER_CODE}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    
    # Giả định hệ thống biết rằng khách hàng có ID này đã bị xóa
    # khi validate trong service
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Người Bán Không Hoạt Động
    ${sold_by_id}=    Lấy Thông tin Người Dùng Theo Tên   ${INACTIVE_SOLD_BY_NAME}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SoldById    ${sold_by_id}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với ID Khách Hàng Không Hợp Lệ
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId  -1
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Không Tồn Tại
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SaleChannelId    ${NON_EXIST_SALE_CHANNEL_ID}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Khác Cửa Hàng
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SaleChannelId    ${DIFFERENT_SHOP_SALE_CHANNEL_ID}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kênh Bán Không Hoạt Động
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    SaleChannelId    ${INACTIVE_SALE_CHANNEL_ID}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
# Redis Operations for UUID tests
Lưu UUID Vào Redis
    [Arguments]    ${uuid}
    ${redis_key}=    Set Variable    cache:InvoiceProcessing:retailerId_${RETAILER_ID}:${uuid}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Create Key    ${redis_key}    ${timestamp}    ex=60
    RETURN    ${redis_key}

Kiểm Tra UUID Tồn Tại Trong Redis
    [Arguments]    ${uuid}
    ${redis_key}=    Set Variable    cache:InvoiceProcessing:retailerId_${RETAILER_ID}:${uuid}
    Key Should Exist    ${redis_key}

Xóa UUID Từ Redis
    [Arguments]    ${redis_key}
    Delete Key    ${redis_key}
    Key Should Not Exist    ${redis_key}

Xác Thực Redis UUID Đã Được Lưu
    [Arguments]    ${uuid}
    Kiểm Tra UUID Tồn Tại Trong Redis    ${uuid}

Xóa Redis UUID
    [Arguments]    ${redis_key}
    Xóa UUID Từ Redis    ${redis_key}

# Duplicate Invoice UUID test cases

Chuẩn Bị Dữ Liệu Hóa Đơn Với Trùng Uuid
    ${uuid}=    Set Variable    550e8400-e29b-41d4-a716-446655440000
    ${invoice_code}=    Set Variable    HD001
    
    # Create Redis cache entry to simulate existing UUID
    ${redis_key}=    Lưu UUID Vào Redis    ${uuid}
    
    # Prepare invoice data with duplicate UUID
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    Uuid    ${uuid}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    Code    ${invoice_code}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# UUID Check Keywords
Chuẩn Bị Dữ Liệu Hóa Đơn Với Trùng Uuid Trong Cơ sở dữ liệu
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    Uuid    ${DUPLICATE_UUID}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    Code    HD001
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    ${DUPLICATE_CUSTOMER_ID}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}

Tạo hóa đơn với UUID trùng lặp
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Trùng Uuid Trong Cơ sở dữ liệu
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã Trạng Thái Phải Là 200

# Keywords for Promotion Limits Testing
Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Có Giới Hạn Sử Dụng
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${LIMITED_PROMOTION_CODE}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn  ${promotion_id}
    # Tạo dữ liệu khuyến mãi với giới hạn sử dụng
    ${promotion_data}=    Create Dictionary
    ...    PromotionId=${promotion_id}
    ...    LimitPromotionUsage=${TRUE}
    ...    LimitPromotionUsageType=2
    ...    Type=1
    ...    SalePromotionId=${info_promotion[0]}
    ...    Discount=${info_promotion[1]}
    ...    DiscountRatio=${None}
    
    @{promotions_list}=    Create List   ${promotion_data}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${LIMITED_CUSTOMER_CODE}
    # Cập nhật dữ liệu hóa đơn
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    CustomerId    ${customer_id}
    ${request_invoice}=    Update Nested Dictionary Property  ${request_invoice}    InvoicePromotions    ${promotions_list}
    ${request}=    Update Nested Dictionary Property  ${request}    Invoice    ${request_invoice}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN     ${request}