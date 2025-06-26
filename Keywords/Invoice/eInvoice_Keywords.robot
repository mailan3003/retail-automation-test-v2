*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../../TestData/Invoice/EInvoiceData.robot
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../Login/Login.robot
Library    ../../Resources/DatabaseLibrary.py
Library    DateTime
Library    uuid

*** Keywords ***

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá ${price} VND Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá và số lượng tùy chỉnh, thanh toán bằng tiền mặt, tự động tạo UUID
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    # Tạo UUID mới
    ${invoice_uuid}=    Evaluate    str(uuid.uuid4())    uuid
    Set Test Variable    ${INVOICE_UUID}    ${invoice_uuid}
    
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Quantity    ${quantity}
    ${total_price}=    Evaluate    ${price} * ${quantity}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})

    # Tạo thanh toán tiền mặt
    ${payment_data}=    Deep Copy    ${payment_body}
    ${payment_data_currency}=    Deep Copy    ${payment_body}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Method    ${PAYMENT_CASH}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Amount    ${total_price}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${PAYMENT_CASH}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${total_price}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    1
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    VND
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount    ${total_price}

    ${payment_data}=    Create List    ${payment_data}
    ${payment_data_currency}=    Create List    ${payment_data_currency}

    # Cập nhật request với UUID và các thông tin khác
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Uuid    ${invoice_uuid}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails    ${payment_data_currency}
    
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá ${price} VND Số Lượng ${quantity} Với Hình Thức Giao Hàng
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá và số lượng tùy chỉnh, thanh toán bằng tiền mặt, tự động tạo UUID
    ${request}=    Deep Copy    ${delivery_detail_body}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    # Tạo UUID mới
    ${invoice_uuid}=    Evaluate    str(uuid.uuid4())    uuid
    Set Test Variable    ${INVOICE_UUID}    ${invoice_uuid}
    
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Quantity    ${quantity}
    ${total_price}=    Evaluate    ${price} * ${quantity}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})

    # Tạo thanh toán tiền mặt
    ${payment_data}=    Deep Copy    ${payment_body}
    ${payment_data_currency}=    Deep Copy    ${payment_body}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Method    ${PAYMENT_CASH}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Amount    ${total_price}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${PAYMENT_CASH}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${total_price}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    1
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    VND
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount    ${total_price}

    ${payment_data}=    Create List    ${payment_data}
    ${payment_data_currency}=    Create List    ${payment_data_currency}

    # Cập nhật request với UUID và các thông tin khác
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Uuid    ${invoice_uuid}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails    ${payment_data_currency}
    
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử 
    [Documentation]    Chuẩn bị dữ liệu hóa đơn điện tử với các tham số cố định
    ...    Includes, PartnerType, EInvoiceTemplateId luôn cố định trong mọi request
    # Tạo includes array từ string
    ${includes_list}=    Split String    ${INCLUDES_ARRAY}    ,
    # Tạo request body với các giá trị cố định
    ${e_invoice_request}=    Create Dictionary
    ...    InvoiceId=${INVOICE_ID}
    ...    EInvoiceTemplateId=${E_INVOICE_TEMPLATE_ID}
    ...    Includes=${includes_list}
    ...    PartnerType=${PARTNER_TYPE}
    Set Test Variable    ${E_INVOICE_REQUEST_DATA}    ${e_invoice_request}
    RETURN    ${e_invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Không Template
    [Documentation]    Chuẩn bị dữ liệu hóa đơn điện tử không truyền template
    ...    Chỉ truyền InvoiceId, Includes, PartnerType - không có EInvoiceTemplateId
    # Tạo includes array từ string
    ${includes_list}=    Split String    ${INCLUDES_ARRAY}    ,
    # Tạo request body không có template
    ${e_invoice_request}=    Create Dictionary
    ...    InvoiceId=${INVOICE_ID}
    ...    Includes=${includes_list}
    ...    PartnerType=${PARTNER_TYPE}
    Set Test Variable    ${E_INVOICE_REQUEST_DATA}    ${e_invoice_request}
    RETURN    ${e_invoice_request}

Nội Dung Phản Hồi Phải Tồn Tại Code HDDT 
    Dictionary Should Contain Key    ${RESPONSE.json()}    id
    ${id}=    Set Variable    ${RESPONSE.json()["id"]}
    Should Be True    ${id} == 0


Cập Nhật Hóa Đơn Sang Trạng Thái Hủy
    [Documentation]    Cập nhật hóa đơn sang trạng thái hủy
    ...    - Dữ liệu đầu vào: Hóa đơn đã tạo
    ...    - Logic kiểm tra: Cập nhật hóa đơn sang trạng thái hủy
    ...    - Kỳ vọng: Cập nhật thành công hóa đơn sang trạng thái hủy
    ${query}=    Set Variable    UPDATE Invoice SET Status = 2 WHERE Id = ?
    execute_query    ${query}    ${INVOICE_ID}
    
    # Kiểm tra xác nhận hóa đơn đã được cập nhật thành công
    ${verify_query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${result}=    fetch_one    ${verify_query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    2

Cập Nhật Hóa Đơn Sang Hình Thức Giao Hàng
    [Documentation]    Cập nhật hóa đơn sang hình thức giao hàng
    ...    - Dữ liệu đầu vào: Hóa đơn đã tạo
    ...    - Logic kiểm tra: Cập nhật hóa đơn sang hình thức giao hàng
    ...    - Kỳ vọng: Cập nhật thành công hóa đơn sang hình thức giao hàng
    ${query}=    Set Variable    UPDATE Invoice SET Status = 6 WHERE Id = ?
    execute_query    ${query}    ${INVOICE_ID}
    
    # Kiểm tra xác nhận hóa đơn đã được cập nhật thành công
    ${verify_query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${result}=    fetch_one    ${verify_query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    6

Xác Thực Hóa Đơn Điện Tử Đã Tạo Thành Công
    [Documentation]    Xác thực hóa đơn điện tử đã tạo thành công
    ...    - Dữ liệu đầu vào: Hóa đơn đã tạo
    ...    - Logic kiểm tra: Xác thực hóa đơn điện tử đã tạo thành công
    ...    - Kỳ vọng: Xác thực thành công hóa đơn điện tử đã tạo (Status = 1 hoặc 2)
    ${query}=    Set Variable    SELECT Status FROM EInvoice WHERE Code = ?
    ${result}=    fetch_one    ${query}    ${INVOICE_UUID}
    Should Be True    ${result[0]} == 1 or ${result[0]} == 2

Nội Dung Phản Hồi Trả Về Phải Tồn Tại Id
    [Documentation]    Kiểm tra response có chứa Id và Id > 0
    Dictionary Should Contain Key    ${RESPONSE.json()}    Id
    ${id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Should Be True    ${id} > 0
    Log    Invoice ID found: ${id}

Thiết Lập Session Cho User Autotest
    [Documentation]    Thiết lập session cho user autotest
    [Arguments]    ${username}=autotest    ${password}=Autotest1
    ${token}=    Get BearerToken by user    ${username}    ${password}
    Log    Token for user ${username}: ${token}
    
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${token}
    ...    Retailer=${RETAILER_CODE}
    ...    Branchid=${BRANCH_ID}
    
    ${session_name}=    Set Variable    autotest_session_${username}
    Create Session    ${session_name}    ${API_URL}    headers=${headers}    verify=True
    
    Set Test Variable    ${AUTOTEST_SESSION}    ${session_name}
    Set Test Variable    ${AUTOTEST_HEADERS}    ${headers}
    Set Test Variable    ${AUTOTEST_TOKEN}    ${token}
    Return From Keyword    ${session_name}    ${headers}

Gửi Yêu Cầu Tạo Hóa Đơn Với User Autotest
    [Documentation]    Gửi yêu cầu tạo hóa đơn với user autotest
    ${resp}=    POST On Session    ${AUTOTEST_SESSION}    invoices    json=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${resp}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Return From Keyword    ${resp}

Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với User Autotest
    [Documentation]    Gửi yêu cầu tạo hóa đơn điện tử với user autotest
    ${resp}=    POST On Session    ${AUTOTEST_SESSION}    e-invoice/publishEInvoice    json=${E_INVOICE_REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${resp}
    Return From Keyword    ${resp}

Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản Chi Nhánh ${branch_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn giao hàng cơ bản với thông tin giao hàng tiêu chuẩn
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_CODE}
    ${invoice_uuid}=    Evaluate    str(uuid.uuid4())    uuid
    Set Test Variable    ${INVOICE_UUID}    ${invoice_uuid}
    
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${delivery_detail_body}=    Deep Copy    ${default_delivery_detail_body}
    ${delivery_detail_body}=    Update Nested Dictionary Property    ${delivery_detail_body}    DeliveryBy    ${DELIVERY_PARTNER_CODE}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    DeliveryDetail    ${delivery_detail_body}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    UsingCod    1
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Uuid    ${invoice_uuid}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    BranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=   Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Lấy Thông tin Sản Phẩm  
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${product_code}    ${RETAILER_ID}
    RETURN    ${result[0]}
