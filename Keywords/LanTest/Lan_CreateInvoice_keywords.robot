

*** Settings ***
Documentation     Test cases API cho phần tạo phiếu thu khi tạo hóa đơn
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../Keywords/Login/Login.robot
Resource          ../../TestData/CommonData.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../../TestData/LanTest/Lan_CreateInvoice_data.robot
Resource    ../Utilities/Utilities.robot
Library    ../../Resources/DatabaseLibrary.py
Library    DateTime

*** Variables ***
# @{list_payment_method}   ${PAYMENT_CASH}    ${PAYMENT_CARD}
# @{list_payment_amount}   50000      50000
# @{list_payment_amount_1}   30000      30000
# @{list_payment_method_voucher}  ${PAYMENT_VOUCHER}   ${PAYMENT_VOUCHER}  
# @{list_payment_amount_voucher}  100000      100000

*** Keywords ***
Chuẩn bị dữ liệu tạo hóa đơn với phương thức thanh toán ${payment_method} và số tiền ${payment_amount}
    ${request}=    Chuẩn bị dữ liệu cơ bản hóa đơn với sản phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice    
    ${data}=    Deep Copy    ${payment_body}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${query_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn bị dữ liệu tạo hóa đơn với phương thức ${payment_method} tài khoản ${bank_account} với số tiền ${payment_amount}
    ${bank_account_id}=    Lấy Bank Account Id theo Bank Account    ${bank_account}
    ${request}=    Chuẩn bị dữ liệu cơ bản hóa đơn với sản phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice    
    ${data}=    Deep Copy    ${payment_body}
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
    ${data}=    Update Nested Dictionary Property    ${data}    AccountId    ${bank_account_id}
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Lấy Bank Account Id theo Bank Account
    [Arguments]    ${bank_account_code}
    ${bank_account_id}=    Set Variable    SELECT Id FROM BankAccount WHERE Account = ? AND RetailerId = ?
    ${result}=    Fetch One    ${bank_account_id}    ${bank_account_code}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    None    Khong tim thay tai khoan ngan hang
    Set Test Variable    ${BANK_ACCOUNT_ID}    ${result[0]}
    RETURN    ${BANK_ACCOUNT_ID}

Xác thực thanh toán được ghi nhận với phương thức ${payment_method} và số tiền ${expect_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    1    Khong tim thay phieu thanh toan
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=     Fetch One    ${query}    ${invoice_id}    ${payment_method}
    Should Be Equal As Numbers    ${result[0]}    ${expect_amount}    So tien khong khop

Xác thực phiếu thu được tạo với các phương thức ${payment_list} và số tiền ${list_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${length}=    Get Length    ${payment_list}
    FOR    ${index}    IN RANGE    ${length}
        ${payment_method}=    Get From List    ${payment_list}    ${index}
        ${payment_amount}=    Get From List    ${list_amount}    ${index}
        ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
        ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
        Should Be Equal As Numbers    ${result[0]}    1    Khong tim thay phieu thanh toan
        ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
        ${result}=     Fetch One    ${query}    ${invoice_id}    ${payment_method}
        Should Be Equal As Numbers    ${result[0]}    ${payment_amount}    So tien khong khop
    END

Chuẩn bị dữ liệu cơ bản hóa đơn với sản phẩm ${product_code}
    ${product_id}=    Lấy thông tin sản phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Dictionary Property    ${data_product}    Id    ${product_id}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Lấy thông tin sản phẩm
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id FROM PRODUCT WHERE Code = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${product_code}    ${RETAILER_ID}
    RETURN    ${result[0]}

Gửi yêu cầu tạo hóa đơn cơ bản
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Nội dung phản hồi trả về phải tồn tại Id
    Dictionary Should Contain Key    ${RESPONSE.json()}    Id
    ${id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Should Be True    ${id} > 0

Xác thực phiếu thu được tạo với số tiền ${expect_amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác thực phiếu thu được tạo    ${invoice_id}    ${expect_amount}

Xác thực phiếu thu được tạo
    [Arguments]    ${invoice_id}=None    ${expect_amount}=${STANDARD_RECEIPT_AMOUNT}
    #Lay invoice_id neu khong duoc cung cap
    IF    '${invoice_id}'=='None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    1    Khong tim thay phieu thu cho hoa don ID ${invoice_id}
    #Kiem tra so tien trong phieu thu
    ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expect_amount}    So tien phieu thu khong dung. Expect: ${expect_amount}, Result: ${result[0]}

Xác thực phiếu thu có mã phù Hợp
    [Arguments]    ${invoice_id}=None
    #lay thong tin invoice_id neu khong duoc cung cap
    IF    '${invoice_id}'=='None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    ${query}=    Set Variable    SELECT Code FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result[0]}    ${None}    Ma phieu khong duoc tao
    #Kiem tra tien to cua ma phieu thu
    Should Start With    ${result[0]}    ${RECEIPT_PREFIX}    Ma phieu thu khong bat dau bang tien to: ${RECEIPT_PREFIX}

Xác thực ngày tạo phiếu thu là ngày hiện tại
    [Arguments]    ${invoice_id}=None
    #Lay thong tin invoice_id neu khong duoc cung cap
    IF    '${invoice_id}'=='None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    ${query}=    Set Variable    SELECT CONVERT(date, CreatedDate) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${receipt_date}=    Convert To String    ${result[0]}
    Should Be Equal    ${current_date}    ${receipt_date}    Ngay tao khong phai la ngay hien tai. Expect: ${current_date}, Result: ${receipt_date}

Xác thực tổng thanh toán của hóa đơn là ${expected_total_payment}
    ${invoice_id}    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tong tien thanh toan khong dung. Expect: ${expected_total_payment}, Result: ${result[0]}

Xác thực công nợ của hóa đơn là ${expect_debt}
    Wait Until Keyword Succeeds    10x    1s    Xác thực công nợ hóa đơn    ${INVOICE_ID}    ${expect_debt}
    
Xác thực công nợ hóa đơn
    [Arguments]    ${invoice_id}=None    ${expected_debt}=0
    #Lay thong tin invoice_id neu khong duoc cung cap
    IF    '${invoice_id}'=='None'
        ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    END
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Cong no khong dung. Expected: ${expected_debt}, Result: ${result[0]}

Xóa hóa đơn vừa tạo
    Delete Data    invoices/${INVOICE_ID}?IsVoidPayment=true

Chuẩn bị dữ liệu tạo hóa đơn với các phương thức thanh toán ${payment_list} và số tiền ${list_amount}
    ${request}=    Chuẩn bị dữ liệu cơ bản hóa đơn với sản phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice   
    ${payments}=    Create List
    ${length}=    Get Length    ${payment_list}
    FOR    ${index}    IN RANGE    ${length}
        ${payment_method}=    Get From List    ${payment_list}    ${index}
        ${payment_amount}=    Get From List    ${list_amount}    ${index}
        ${payment}=    Deep Copy    ${payment_body}
        Set To Dictionary    ${payment}    Method=${payment_method}    Amount=${payment_amount}
        Append To List    ${payments}    ${payment}
    END
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request} 



# RT-RC-001 Tạo phiếu thu tiền mặt khi tạo hóa đơn
#     [Documentation]    Kiểm tra tạo phiếu thu tiền mặt khi tạo hóa đơn
#     ...    - Dữ liệu đầu vào:
#     ...    - Hóa đơn có tổng tiền = 100,000đ
#     ...    - Phương thức thanh toán: tiền mặt
#     ...    - Số tiền thanh toán: 100,000đ
#     ...    - Kỳ vọng:
#     ...    - Status code: 200
#     ...    - Phiếu thu được tạo trong DB với số tiền 100,000đ
#     ...    - Mã phiếu thu bắt đầu với tiền tố "PT"
#     ...    - Ngày tạo phiếu thu là ngày hiện tại
#     ...    - Tổng tiền thanh toán của hóa đơn = 100,000đ
#     ...    - Công nợ của hóa đơn = 0
#     [Tags]    payment    smoke    apiinvoice    regression    Lantesttt
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${PAYMENT_CASH} Với Số Tiền 100000
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã trạng thái phải là 200
#     And Nội dung phản hồi trả về phải tồn tại Id
#     And Xác Thực Phiếu Thu Được Tạo Với Số Tiền 100000
#     And Xác Thực Phiếu Thu Có Mã Phù Hợp
#     And Xác Thực Ngày Tạo Phiếu Thu Là Ngày Hiện Tại
#     And Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn 100000
#     And Xác Thực Công Nợ Của Hóa Đơn 0
#     [Teardown]    Delete Invoice From API

# Lấy Thông tin Sản Phẩm  
#     [Arguments]    ${product_code}
#     ${query}=    Set Variable    SELECT Id FROM Product WHERE Code = ? AND RetailerId = ?
#     ${result}=    Fetch One    ${query}    ${product_code}    ${RETAILER_ID}
#     RETURN    ${result[0]}

# Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${product_code}
#     ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
#     ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
#     ${data_product}=   Deep Copy   ${STANDARD_INVOICE_DETAIL}
#     ${data_product}=    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
#     ${request}  Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
#     Set Test Variable    ${REQUEST_DATA}    ${request}
#     RETURN    ${request}

# #invoice/RecieptCreationKeywords.robot
# Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn Thanh Toán Phương Thức ${payment_method} Với Số Tiền ${payment_amount}
#     ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
#     ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
#     ${data}=    Deep Copy    ${payment_body} 
#     ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
#     ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
#     ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
#     Set Test Variable    ${REQUEST_DATA}    ${request}
#     Log    ${REQUEST_DATA}  
#     RETURN    ${request}

#Ultilities/RequestHelper.robot
# Gửi Yêu Cầu Tạo Hóa Đơn
#     ${response}=    Call API    invoices    ${REQUEST_DATA}
#     Set Test Variable    ${RESPONSE}    ${response}
#     ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
#     Set Test Variable    ${INVOICE_ID}    ${invoice_id}

# Invoice/InputValidationKeywords.robot   
# Nội dung phản hồi trả về phải tồn tại Id
#     Dictionary Should Contain Key    ${RESPONSE.json()}    Id
#     ${id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     Should Be True    ${id} > 0

# Xác Thực Phiếu Thu Được Tạo
#     [Arguments]    ${invoice_id}=None    ${expected_amount}=${STANDARD_RECEIPT_AMOUNT}
#     # Lấy invoice_id từ response nếu không được cung cấp
#     IF    '${invoice_id}' == 'None'
#         ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     END
#     ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}
#     Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy phiếu thu cho hóa đơn ID ${invoice_id}
#     # Kiểm tra số tiền phiếu thu
#     ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}
#     Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền phiếu thu không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}

# Xác Thực Phiếu Thu Được Tạo Với Số Tiền ${expected_amount}
#     ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     Xác Thực Phiếu Thu Được Tạo    ${invoice_id}    ${expected_amount}

# Xác Thực Phiếu Thu Có Mã Phù Hợp
#     [Arguments]    ${invoice_id}=None
#     # Lấy invoice_id từ response nếu không được cung cấp
#     IF    '${invoice_id}' == 'None'
#         ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     END
#     ${query}=    Set Variable    SELECT Code FROM Payment WHERE InvoiceId = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}
#     Should Not Be Equal    ${result[0]}    ${None}    Mã phiếu thu không được tạo
#     # Kiểm tra mã phiếu thu có tiền tố PT
#     Should Start With    ${result[0]}    ${RECEIPT_PREFIX}    Mã phiếu thu không bắt đầu bằng tiền tố ${RECEIPT_PREFIX}

# Xác Thực Ngày Tạo Phiếu Thu Là Ngày Hiện Tại
#     [Arguments]    ${invoice_id}=None  
#     # Lấy invoice_id từ response nếu không được cung cấp
#     IF    '${invoice_id}' == 'None'
#         ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     END  
#     ${query}=    Set Variable    SELECT CONVERT(date, CreatedDate) FROM Payment WHERE InvoiceId = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}   
#     ${current_date}=    Get Current Date    result_format=%Y-%m-%d
#     ${receipt_date}=    Convert To String    ${result[0]}  
#     Should Be Equal    ${receipt_date}    ${current_date}    Ngày tạo phiếu thu không phải là ngày hiện tại. Kỳ vọng: ${current_date}, Thực tế: ${receipt_date}

# Xác Thực Tổng Tiền Thanh Toán Của Hóa Đơn ${expected_total_payment}
#     ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}
#     Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tổng tiền thanh toán không đúng. Kỳ vọng: ${expected_total_payment}, Thực tế: ${result[0]}

# Xác Thực Công Nợ Hóa Đơn
#     [Arguments]    ${invoice_id}=None    ${expected_debt}=0
#     # Lấy invoice_id từ response nếu không được cung cấp
#     IF    '${invoice_id}' == 'None'
#         ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     END  
#     ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}
#     Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Công nợ không đúng. Kỳ vọng: ${expected_debt}, Thực tế: ${result[0]}

# Xác Thực Công Nợ Của Hóa Đơn ${expected_debt}
#     Wait Until Keyword Succeeds    10x    1s    Xác Thực Công Nợ Hóa Đơn    ${INVOICE_ID}    ${expected_debt}

# Delete Invoice From API
#     Delete Data    invoices/${INVOICE_ID}?IsVoidPayment=true

# Lấy Id bank account theo mã bank account
#     [Arguments]    ${bank_account_code}
#     ${sql_query}=    Set Variable    SELECT Id FROM BankAccount WHERE Account = ? AND RetailerId = ?
#     ${bank_account_id}=    Fetch One    ${sql_query}    ${bank_account_code}    ${RETAILER_ID}
#     Should Not Be Equal    ${bank_account_id}    ${None}    Tài khoản ngân hàng không tồn tại trong CSDL
#     Set Test Variable    ${BANK_ACCOUNT_ID}    ${bank_account_id[0]}
#     RETURN    ${BANK_ACCOUNT_ID}

# Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Phương Thức ${payment_method} Tài khoản ${bank_account} Với Số Tiền ${payment_amount} 
#     ${bank_account_id}=    Lấy Id Bank Account Theo Mã Bank Account    ${bank_account}
#     ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
#     ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
#     ${data}=     Deep Copy   ${payment_body} 
#     ${data}=    Update Nested Dictionary Property    ${data}    Method    ${payment_method}
#     ${data}=    Update Nested Dictionary Property    ${data}    Amount    ${payment_amount}
#     ${data}=    Update Nested Dictionary Property    ${data}    AccountId    ${bank_account_id}
#     ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Payments    ${data}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
#     Set Test Variable    ${REQUEST_DATA}    ${request}
#     Log    ${REQUEST_DATA}  
#     RETURN    ${request}

# Xác Thực Thanh Toán Được Ghi Nhận Phương Thức ${payment_method} Với Số Tiền ${expected_amount}
#     ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
#     ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
#     Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy thanh toán ${payment_method} cho hóa đơn ID ${invoice_id}
#     # Kiểm tra số tiền thanh toán
#     ${query}=    Set Variable    SELECT Amount FROM Payment WHERE InvoiceId = ? AND Method = ?
#     ${result}=    Fetch One    ${query}    ${invoice_id}    ${payment_method}
#     Should Be Equal As Numbers    ${result[0]}    ${expected_amount}    Số tiền thanh toán không đúng. Kỳ vọng: ${expected_amount}, Thực tế: ${result[0]}
