*** Settings ***
Documentation     Keywords cho test cases API phần tạo phiếu thu khi tạo hóa đơn
Resource          ../../TestData/Invoice/ReceiptCreationData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/CommonData.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String
Library           DateTime

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Với Thanh Toán
    [Arguments]    ${payment_method}=${PAYMENT_CASH}    ${payment_amount}=${STANDARD_RECEIPT_AMOUNT}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${payments}=    Create List
    IF    '${payment_method}' == '${PAYMENT_CASH}'
        ${payment}=    Set Variable   ${CASH_RECEIPT_PAYMENT}
    ELSE IF    '${payment_method}' == '${PAYMENT_CARD}'
        ${payment}=    Set Variable    ${CARD_RECEIPT_PAYMENT}
    ELSE IF    '${payment_method}' == '${PAYMENT_TRANSFER}'
        ${payment}=    Set Variable    ${TRANSFER_RECEIPT_PAYMENT}
    ELSE
        ${payment}=    Set Variable    ${CASH_RECEIPT_PAYMENT}
    END
        
    # Cập nhật số tiền nếu khác mặc định
    IF    ${payment_amount} != ${STANDARD_RECEIPT_AMOUNT}
        Set To Dictionary    ${payment}    Amount=${payment_amount}
    END
    Append To List    ${payments}    ${payment}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payments}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Phương Thức Thanh Toán
    [Arguments]    ${cash_amount}=${MULTIPLE_PAYMENT_AMOUNT}    ${card_amount}=${MULTIPLE_PAYMENT_AMOUNT}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Set Variable    ${MULTIPLE_PAYMENT_METHODS}
    # Cập nhật số tiền nếu khác mặc định
    IF    ${cash_amount} != ${MULTIPLE_PAYMENT_AMOUNT}
        Set To Dictionary    ${data[0]}    Amount=${cash_amount}
    END
    
    IF    ${card_amount} != ${MULTIPLE_PAYMENT_AMOUNT}
        Set To Dictionary    ${data[1]}    Amount=${card_amount}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments     ${data}
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request} 

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Thừa
    [Arguments]    ${excess_amount}=${EXCESS_RECEIPT_AMOUNT}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Set Variable    @{OVERPAYMENT_METHODS}
    # Cập nhật số tiền nếu khác mặc định
    IF    ${excess_amount} != ${EXCESS_RECEIPT_AMOUNT}
        Set To Dictionary    ${data.Payments[0]}    Amount=${excess_amount}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.addToAccount    1
    Set Test Variable    ${REQUEST_DATA}    ${request} 
    RETURN    ${request} 

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Thiếu
    [Arguments]    ${partial_amount}=${PARTIAL_RECEIPT_AMOUNT}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data}=    Set Variable    @{UNDERPAYMENT_METHODS}
    
    # Cập nhật số tiền nếu khác mặc định
    IF    ${partial_amount} != ${PARTIAL_RECEIPT_AMOUNT}
        Set To Dictionary    ${data.Payments[0]}    Amount=${partial_amount}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    Set Test Variable    ${REQUEST_DATA}     ${request}  
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Thanh Toán Trực Tiếp
    [Arguments]    ${customer_id}=${RECEIPT_CUSTOMER_ID}    ${amount}=${STANDARD_RECEIPT_AMOUNT}    ${description}=${RECEIPT_DESCRIPTION}
    ${data}=    Set Variable    ${DIRECT_RECEIPT_REQUEST}
    
    # Cập nhật thông tin nếu khác mặc định
    IF    ${customer_id} != ${RECEIPT_CUSTOMER_ID}
        Set To Dictionary    ${data.Receipt}    CustomerId=${customer_id}
    END
    
    IF    ${amount} != ${STANDARD_RECEIPT_AMOUNT}
        Set To Dictionary    ${data.Receipt}    Amount=${amount}
        Set To Dictionary    ${data.Payment}    Amount=${amount}
    END
    
    IF    '${description}' != '${RECEIPT_DESCRIPTION}'
        Set To Dictionary    ${data.Receipt}    Description=${description}
        Set To Dictionary    ${data.Payment}    Description=${description}
    END
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Thanh Toán Công Nợ
    [Arguments]    ${customer_id}=${RECEIPT_CUSTOMER_ID}    ${amount}=${STANDARD_RECEIPT_AMOUNT}    ${description}=${RECEIPT_DESCRIPTION}
    ${data}=    Set Variable    ${DEBT_PAYMENT_RECEIPT_REQUEST}
    
    # Cập nhật thông tin nếu khác mặc định
    IF    ${customer_id} != ${RECEIPT_CUSTOMER_ID}
        Set To Dictionary    ${data.Receipt}    CustomerId=${customer_id}
    END
    
    IF    ${amount} != ${STANDARD_RECEIPT_AMOUNT}
        Set To Dictionary    ${data.Receipt}    Amount=${amount}
        Set To Dictionary    ${data.Payment}    Amount=${amount}
    END
    
    IF    '${description}' != '${RECEIPT_DESCRIPTION}'
        Set To Dictionary    ${data.Receipt}    Description=${description}
        Set To Dictionary    ${data.Payment}    Description=${description}
    END
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Thanh Toán Với Mô Tả Chi Tiết
    [Arguments]    ${description}=Thu tiền hóa đơn bán hàng chi tiết cho khách ${RECEIPT_CUSTOMER_NAME}
    ${data}=    Set Variable    ${RECEIPT_WITH_DETAILS_REQUEST}
    
    # Cập nhật mô tả
    Set To Dictionary    ${data.Payments[0]}    Description=${description}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi Yêu Cầu Tạo Phiếu Thu Trực Tiếp
    ${response}=    Call API    receipts    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Xác Thực Phiếu Thu Được Tạo
    [Arguments]    ${invoice_id}=None    ${expected_amount}=${STANDARD_RECEIPT_AMOUNT}
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy phiếu thu cho hóa đơn ID ${invoice_id}
    
    # Kiểm tra số tiền phiếu thu
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền phiếu thu không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}

Xác thực tổng thanh toán hóa đơn 
    [Arguments]       ${expected_total_payment}=${STANDARD_RECEIPT_AMOUNT}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tổng tiền thanh toán không đúng. Kỳ vọng: ${expected_total_payment}, Thực tế: ${result[0]}


Xác Thực Phiếu Thu Được Tạo Với Số Tiền ${expected_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Phiếu Thu Được Tạo    ${invoice_id}    ${expected_amount}

Xác Thực Thanh Toán Được Ghi Nhận
    [Arguments]    ${invoice_id}=None    ${payment_method}=${PAYMENT_CASH}    ${expected_amount}=${STANDARD_RECEIPT_AMOUNT}
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy thanh toán ${payment_method} cho hóa đơn ID ${invoice_id}
    
    # Kiểm tra số tiền thanh toán
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền thanh toán không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}

Xác Thực Phiếu Thu Có Mã Phù Hợp
    [Arguments]    ${invoice_id}=None
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT Code FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result[0]}    ${None}    Mã phiếu thu không được tạo
    
    # Kiểm tra mã phiếu thu có tiền tố PT
    Should Start With    ${result[0]}    ${RECEIPT_PREFIX}    Mã phiếu thu không bắt đầu bằng tiền tố ${RECEIPT_PREFIX}

Xác Thực Phiếu Thu Có Mô Tả Chính Xác
    [Arguments]    ${invoice_id}=None    ${expected_description}=${RECEIPT_DESCRIPTION}
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT Description FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal    ${result[0]}    ${expected_description}    Mô tả phiếu thu không đúng. Kỳ vọng: ${expected_description}, Thực tế: ${result[0]}

Xác Thực Ngày Tạo Phiếu Thu Là Ngày Hiện Tại
    [Arguments]    ${invoice_id}=None
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT CONVERT(date, CreatedDate) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${receipt_date}=    Convert To String    ${result[0]}
    
    Should Be Equal    ${receipt_date}    ${current_date}    Ngày tạo phiếu thu không phải là ngày hiện tại. Kỳ vọng: ${current_date}, Thực tế: ${receipt_date}

Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn
    [Arguments]    ${invoice_id}=None    ${expected_total_payment}=${STANDARD_RECEIPT_AMOUNT}
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tổng tiền thanh toán không đúng. Kỳ vọng: ${expected_total_payment}, Thực tế: ${result[0]}

Xác Thực Công Nợ Của Hóa Đơn
    [Arguments]    ${invoice_id}=None    ${expected_debt}=0
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Công nợ không đúng. Kỳ vọng: ${expected_debt}, Thực tế: ${result[0]}

Xác Thực Tiền Thừa Của Hóa Đơn
    [Arguments]    ${invoice_id}=None    ${expected_overpayment}=0
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    # Tính toán tiền thừa
    ${overpayment}=    Evaluate    ${expected_overpayment}
    
    ${query}=    Set Variable    SELECT Overpayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${overpayment}    Tiền thừa không đúng. Kỳ vọng: ${overpayment}, Thực tế: ${result[0]}

Xác Thực Trạng Thái Thanh Toán Của Hóa Đơn
    [Arguments]    ${invoice_id}=None    ${expected_status}=1
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_status}    Trạng thái thanh toán không đúng. Kỳ vọng: ${expected_status}, Thực tế: ${result[0]}

Xác Thực Phiếu Thu Trực Tiếp Được Tạo
    [Arguments]    ${receipt_id}=None    ${expected_amount}=${STANDARD_RECEIPT_AMOUNT}    ${expected_type}=${RECEIPT_TYPE_OTHER}
    
    # Lấy receipt_id từ response nếu không được cung cấp
    IF    '${receipt_id}' == 'None'
        ${receipt_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    # Kiểm tra loại phiếu thu
    ${query}=    Set Variable    SELECT system FROM Payment WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${receipt_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_type}    Loại phiếu thu không đúng. Kỳ vọng: ${expected_type}, Thực tế: ${result[0]}
    
    # Kiểm tra số tiền
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${receipt_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền phiếu thu không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}

Xác Thực Không Có Phiếu Thu Được Tạo
    [Arguments]    ${invoice_id}=None
    
    # Lấy invoice_id từ response nếu không được cung cấp
    IF    '${invoice_id}' == 'None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    0    Phiếu thu được tạo mặc dù không kỳ vọng 