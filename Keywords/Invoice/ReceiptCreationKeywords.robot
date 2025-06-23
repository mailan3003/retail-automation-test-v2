*** Settings ***
Documentation     Keywords cho test cases API phần tạo phiếu thu khi tạo hóa đơn
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../CashFlow/CashflowCommonKeywords.robot
Resource          InvoiceCommonKeywords.robot
Resource          ../Product/ProductCommonKeywords.robot
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
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${payment_method} Với Số Tiền ${payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${payment_method} Tài khoản ${bank_account} Với Số Tiền ${payment_amount} 
    ${bank_account_id}=    Lấy Id Bank Account Theo Mã Bank Account    ${bank_account}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=     Deep Copy   ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    AccountId    ${bank_account_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${payment_method} Với Id Tài Khoản ${bank_account_id}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    AccountId    ${bank_account_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Log    ${REQUEST_DATA}  
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phương Thức ${list_payment_method} Với Số Tiền ${list_payment_amount}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payments}=    Create List
    
    ${length}=    Get Length    ${list_payment_method}
    FOR    ${index}    IN RANGE    ${length}
        ${payment_method}=    Get From List    ${list_payment_method}    ${index}
        ${payment_amount}=    Get From List    ${list_payment_amount}    ${index}
        
        ${payment}=    Deep Copy    ${payment_body}
        Set To Dictionary    ${payment}    Method=${payment_method}    Amount=${payment_amount}
        Append To List    ${payments}    ${payment}
    END
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request} 

Chuẩn Bị Hóa Đơn Thanh Toán Số Tiền ${payment_amount} Sử Dụng Điểm ${reward_point}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_POINT}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    UsePoint   ${reward_point}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt ${Voucher_campain}
    ${voucher_campaign_id}    ${voucher_price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign   ${Voucher_campain}
    ${voucher_id}    ${voucher_code}=    Lấy ID Mã Voucher Theo Trạng Thái   ${voucher_campaign_id}    Đã Phát Hành
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=    Deep Copy     ${payment_body} 
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request_invoice}=    Update Nested Dictionary Property     ${request_invoice}     InvoiceDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${voucher_price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${VOUCHER_CODE}    ${voucher_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Với Mã Voucher Ở Trạng Thái ${status}
    ${voucher_campaign_id}    ${voucher_price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign   ${Voucher_campain}
    ${voucher_id}    ${voucher_code}=    Lấy ID Mã Voucher Theo Trạng Thái    ${voucher_campaign_id}    ${status}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=     Deep Copy    ${payment_body} 
    ${data_product}=     Deep Copy     ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${voucher_price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${VOUCHER_CODE}    ${voucher_code}
    RETURN    ${request}


Chuẩn Bị Hóa Đơn Thanh Toán Bằng Voucher Đợt ${Voucher_campain} Khi Chưa Đủ Điều Kiện
    ${voucher_campaign_id}    ${voucher_price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign   ${Voucher_campain}
    ${voucher_id}    ${voucher_code}=    Lấy ID Mã Voucher Theo Trạng Thái    ${voucher_campaign_id}    Đã Phát Hành
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${voucher_price}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id}
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${VOUCHER_CODE}    ${voucher_code}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Với ${number_of_voucher} Voucher Đợt ${Voucher_campain}
    ${voucher_campaign_id}    ${voucher_price}=    Lấy Thông Tin ID, PRICE Của Voucher Campaign   ${Voucher_campain}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${request_invoice}=    Update Nested Dictionary Property     ${request_invoice}     InvoiceDetails  ${data_product}
    ${payments}=    Create List
    ${list_voucher_id}=    Create List
    FOR    ${index}    IN RANGE    ${number_of_voucher}
        ${voucher_id}=    Lấy List ID Mã Voucher ở Trạng Thái Đã Phát Hành    ${voucher_campaign_id}    ${number_of_voucher}
        ${data}=     Deep Copy     ${payment_body} 
        ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
        ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${voucher_price}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherId   ${voucher_id[${index}][0]}
        ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId   ${voucher_campaign_id}
        Append To List    ${payments}    ${data}
        Append To List    ${list_voucher_id}    ${voucher_id[${index}][0]}
    END
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${list_voucher_id}    ${list_voucher_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Xác Thực Tài Khoản ${bank_account} Được Sử Dụng Khi Thanh Toán Hóa Đơn
    ${bank_account_id}=    Lấy Id Bank Account Theo Mã Bank Account    ${bank_account}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND AccountId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${bank_account_id}
    Should Be Equal As Numbers    ${result[0]}    1    Tài khoản ngân hàng không được sử dụng trong thanh toán hóa đơn






Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn ${expected_total_payment}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tổng tiền thanh toán không đúng. Kỳ vọng: ${expected_total_payment}, Thực tế: ${result[0]}


Xác Thực Công Nợ Của Hóa Đơn ${expected_debt}
    Wait Until Keyword Succeeds    10x    1s    Xác Thực Công Nợ Hóa Đơn    ${INVOICE_ID}    ${expected_debt}

Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${payment_method} Với Số Tiền ${expected_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy thanh toán ${payment_method} cho hóa đơn ID ${invoice_id}
    
    # Kiểm tra số tiền thanh toán
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền thanh toán không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}
Xác Thực Thanh Toán Được Ghi Nhận ${number_of_payment_method} Phương Thức ${list_payment_method} Thanh Toán ${list_payment_amount}
    ${query}=    Set Variable    SELECT Method, Amount FROM Payment WHERE InvoiceId = ? 
    ${result}=    Fetch All    ${query}    ${invoice_id}  
    FOR    ${index}    IN RANGE  0  ${number_of_payment_method}
        ${payment_method}=    Get From List    ${list_payment_method}    ${index}
        ${payment_amount}=    Get From List    ${list_payment_amount}    ${index}
        Should Be Equal    ${result[${index}][0]}    ${payment_method}    Phương thức thanh toán không đúng. Kỳ vọng: ${payment_method}, Thực tế: ${result[${index}][0]}
        Should Be Equal As Numbers    ${result[${index}][1]}    ${payment_amount}    Số tiền thanh toán không đúng. Kỳ vọng: ${payment_amount}, Thực tế: ${result[${index}][1]}
    END
   


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

Xác Thực Công Nợ Hóa Đơn
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

Xác Thực Trạng Thái Thanh Toán Của Hóa Đơn ${expected_status}
     ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
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

Chuẩn Bị Dữ Liệu Hóa Đơn Với Điểm Thưởng Và Tiền Mặt
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payments}=    Create List
    
    # Tạo thanh toán bằng điểm
    ${payment_point}=    Create Dictionary
    ...    Method=${PAYMENT_POINT}
    ...    Amount=25000
    ...    UsePoint=25
    
    # Tạo thanh toán bằng tiền mặt
    ${payment_cash}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=75000
    
    Append To List    ${payments}    ${payment_point}
    Append To List    ${payments}    ${payment_cash}
    
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Và Thẻ
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payments}=    Create List
    
    # Tạo thanh toán bằng voucher
    ${payment_voucher}=    Create Dictionary
    ...    Method=${PAYMENT_VOUCHER}
    ...    Amount=30000
    ...    VoucherCode=VOUCHER001
    ...    VoucherId=${VOUCHER_ID}
    ...    VoucherCampaignId=${VOUCHER_CAMPAIGN_ID}
    
    # Tạo thanh toán bằng thẻ
    ${payment_card}=    Create Dictionary
    ...    Method=${PAYMENT_CARD}
    ...    Amount=70000
    ...    AccountId=${BANK_ACCOUNT_ID}
    
    Append To List    ${payments}    ${payment_voucher}
    Append To List    ${payments}    ${payment_card}
    
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Tài Khoản Chuyển Khoản
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payments}=    Create List
    
    # Tạo thanh toán chuyển khoản tài khoản 1
    ${payment_transfer_1}=    Create Dictionary
    ...    Method=${PAYMENT_TRANSFER}
    ...    Amount=50000
    ...    AccountId=${BANK_ACCOUNT_ID}
    
    # Tạo thanh toán chuyển khoản tài khoản 2
    ${payment_transfer_2}=    Create Dictionary
    ...    Method=${PAYMENT_TRANSFER}
    ...    Amount=50000
    ...    AccountId=${BANK_WALLET_ID}
    
    Append To List    ${payments}    ${payment_transfer_1}
    Append To List    ${payments}    ${payment_transfer_2}
    
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Ba Phương Thức Thanh Toán
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${payments}=    Create List
    
    # Tạo thanh toán tiền mặt
    ${payment_cash}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=40000
    
    # Tạo thanh toán thẻ
    ${payment_card}=    Create Dictionary
    ...    Method=${PAYMENT_CARD}
    ...    Amount=30000
    ...    AccountId=${BANK_ACCOUNT_ID}
    
    # Tạo thanh toán chuyển khoản
    ${payment_transfer}=    Create Dictionary
    ...    Method=${PAYMENT_TRANSFER}
    ...    Amount=30000
    ...    AccountId=${BANK_ACCOUNT_ID}
    
    Append To List    ${payments}    ${payment_cash}
    Append To List    ${payments}    ${payment_card}
    Append To List    ${payments}    ${payment_transfer}
    
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Thanh Toán Chuyển Khoản Nhiều Tài Khoản
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    # Kiểm tra thanh toán tài khoản 1
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ? AND AccountId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_TRANSFER}    ${BANK_ACCOUNT_ID}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy thanh toán chuyển khoản tài khoản 1
    
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ? AND AccountId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_TRANSFER}    ${BANK_ACCOUNT_ID}
    Should Be Equal As Numbers    ${result[0]}    50000    Số tiền thanh toán tài khoản 1 không đúng
    
    # Kiểm tra thanh toán tài khoản 2
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ? AND AccountId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_TRANSFER}    ${BANK_WALLET_ID}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy thanh toán chuyển khoản tài khoản 2
    
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ? AND AccountId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_TRANSFER}    ${BANK_WALLET_ID}
    Should Be Equal As Numbers    ${result[0]}    50000    Số tiền thanh toán tài khoản 2 không đúng

Xác Thực Điểm Khách Hàng Sử Dụng ${expected_points}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT UsePoint FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_POINT}
    Should Be Equal As Numbers    ${result[0]}    ${expected_points}    Số điểm sử dụng không đúng. Kỳ vọng: ${expected_points}, Thực tế: ${result[0]}



Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Điểm Không Đủ
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    
    # Tạo thanh toán bằng điểm nhiều hơn số điểm hiện có
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_POINT}
    ...    Amount=100000
    ...    UsePoint=100
    
    ${payments}=    Create List    ${payment}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Xác Thực Công Nợ Khách Hàng Tăng ${expected_debt_increase}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    # Lấy customerId của hóa đơn
    ${query}=    Set Variable    SELECT CustomerId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    ${customer_id}=    Set Variable    ${result[0]}
    
    # Kiểm tra công nợ khách hàng đã tăng
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    
    # Lấy công nợ hiện tại
    ${current_debt}=    Set Variable    ${result[0]}
    
    # Lấy công nợ trước đó
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    ${invoice_debt}=    Set Variable    ${result[0]}
    
    # Kiểm tra công nợ đã tăng đúng số tiền
    Should Be Equal As Numbers    ${invoice_debt}    ${expected_debt_increase}    Công nợ hóa đơn không đúng. Kỳ vọng: ${expected_debt_increase}, Thực tế: ${invoice_debt}

