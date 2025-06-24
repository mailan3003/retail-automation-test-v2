*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../../TestData/Invoice/EInvoice_VLXD_Data.robot
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../Login/Login.robot
Library    ../../Resources/DatabaseLibrary.py
Library    DateTime
Library    uuid

*** Keywords ***

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá ${price} VND Số Lượng ${quantity} Chi Nhánh ${branch_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn quốc tế với các thông tin cơ bản
    ...    - Tham số đầu vào:
    ...    - price: Đơn giá sản phẩm (VND)
    ...    - quantity: Số lượng sản phẩm
    ...    - branch_id: ID chi nhánh để tạo hóa đơn
    ...    - Chức năng:
    ...    - Tạo UUID duy nhất cho hóa đơn để tránh trùng lặp
    ...    - Tính toán tổng tiền = price * quantity
    ...    - Thiết lập thanh toán tiền mặt với tỷ giá VND
    ...    - Cập nhật thông tin chi nhánh trong hóa đơn
    ...    - Kết quả: Trả về request body hoàn chỉnh cho API tạo hóa đơn
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    
    # Tạo UUID mới
    ${invoice_uuid}=    Evaluate    str(uuid.uuid4())    uuid
    Set Test Variable    ${INVOICE_UUID}    ${invoice_uuid}
    
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID}
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

    # Cập nhật request với UUID, chi nhánh và các thông tin khác
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Uuid    ${invoice_uuid}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails    ${payment_data_currency}
    
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Điện Tử Với NCC HDDT ${PARTNER_TYPE} Và Template HDDT ${E_INVOICE_TEMPLATE_ID}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn điện tử với nhà cung cấp và template cụ thể
    ...    - Tham số đầu vào:
    ...    - PARTNER_TYPE: Loại đối tác cung cấp dịch vụ hóa đơn điện tử
    ...    - E_INVOICE_TEMPLATE_ID: ID template hóa đơn điện tử
    ...    - Chức năng:
    ...    - Tạo request body cho API tạo hóa đơn điện tử
    ...    - Bao gồm InvoiceId, EInvoiceTemplateId, Includes, PartnerType
    ...    - Chuyển đổi includes từ string thành array
    ...    - Kết quả: Trả về request body cho API publishEInvoice
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

Thiết Lập Session Cho User Autotest with branch_id
    [Documentation]    Thiết lập session cho user autotest
    [Arguments]    ${username}=autotest    ${password}=Autotest1    ${branch_id}=${branch_id}
    ${token}=    Get BearerToken by user with branch_id    ${username}    ${password}    ${branch_id}
    Log    Token for user ${username}: ${token}
    
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${token}
    ...    Retailer=${RETAILER_CODE}
    ...    Branchid=${branch_id}
    
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

Gửi Yêu Cầu API Với BranchId
    [Documentation]    Gửi yêu cầu API với branch_id được chỉ định
    ...    - Tham số đầu vào:
    ...    - endpoint: Đường dẫn API endpoint
    ...    - data: Dữ liệu JSON để gửi
    ...    - branch_id: ID chi nhánh (tùy chọn, mặc định: ${BRANCH_ID})
    ...    - token: Token xác thực (tùy chọn, mặc định: ${AUTH_TOKEN})
    ...    - Chức năng:
    ...    - Tạo headers với branch_id được chỉ định
    ...    - Gửi request POST đến API
    ...    - Trả về response object
    [Arguments]    ${endpoint}    ${data}    ${branch_id}=${BRANCH_ID}    ${token}=${AUTH_TOKEN}
    
    # Tạo headers với branch_id được chỉ định
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ...    Content-Type=application/json
    ...    Retailer=${RETAILER_CODE}
    ...    BranchId=${branch_id}
    
    # Gửi request
    Create Session    kvpos    ${API_URL}    verify=True
    ${response}=    POST On Session    kvpos    ${endpoint}    json=${data}    headers=${headers}    expected_status=anything
    
    RETURN    ${response}

Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    [Documentation]    Gửi yêu cầu tạo hóa đơn với branch_id được chỉ định
    ...    - Tham số đầu vào:
    ...    - branch_id: ID chi nhánh (tùy chọn, mặc định: ${BRANCH_ID})
    ...    - Chức năng:
    ...    - Sử dụng Create Auth Headers With BranchId để tạo headers
    ...    - Gọi API tạo hóa đơn với branch_id cụ thể
    ...    - Lưu response và invoice_id vào biến test
    ...    - Kết quả: Trả về response object
    [Arguments]    ${branch_id}=${BRANCH_ID}
    
    # Tạo headers với branch_id được chỉ định
    ${headers}=    Create Auth Headers With BranchId    ${branch_id}
    
    # Gửi request
    Create Session    kvpos    ${API_URL}    verify=True
    ${response}=    POST On Session    kvpos    invoices    json=${REQUEST_DATA}    headers=${headers}    expected_status=anything
    
    # Lưu response và invoice_id
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Set Test Variable    ${BRANCH_ID_USED}    ${branch_id}
    
    RETURN    ${response}

Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với BranchId
    [Documentation]    Gửi yêu cầu tạo hóa đơn điện tử với branch_id được chỉ định
    ...    - Tham số đầu vào:
    ...    - branch_id: ID chi nhánh (tùy chọn, mặc định: ${BRANCH_ID})
    ...    - Chức năng:
    ...    - Sử dụng Create Auth Headers With BranchId để tạo headers
    ...    - Gọi API tạo hóa đơn điện tử với branch_id cụ thể
    ...    - Lưu response và e_invoice_id vào biến test
    ...    - Kết quả: Trả về response object
    [Arguments]    ${branch_id}=${BRANCH_ID}
    
    # Tạo headers với branch_id được chỉ định
    ${headers}=    Create Auth Headers With BranchId    ${branch_id}
    
    # Gửi request
    Create Session    kvpos    ${API_URL}    verify=True
    ${response}=    POST On Session    kvpos    e-invoice/publishEInvoice    json=${E_INVOICE_REQUEST_DATA}    headers=${headers}    expected_status=anything
    
    # Lưu response và e_invoice_id
    Set Test Variable    ${RESPONSE}    ${response}
    ${e_invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["invoice_ref_id"]}    0
    Set Test Variable    ${E_INVOICE_ID}    ${e_invoice_id}
    Set Test Variable    ${BRANCH_ID_USED}    ${branch_id}
    
    RETURN    ${response}



