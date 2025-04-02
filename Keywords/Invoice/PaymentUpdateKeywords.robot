*** Settings ***
Documentation     Keywords cho phần API cập nhật thanh toán
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/PaymentUpdateData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String
Library           DateTime

*** Keywords ***
Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    ${request_data}=    Create Dictionary    
    ...    InvoiceId=${EXISTING_INVOICE_ID}
    ...    Payments=@{EMPTY}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Tiền Mặt
    [Arguments]    ${amount}=${PAYMENT_UPDATE_AMOUNT}    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=${amount}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Bằng Thẻ
    [Arguments]    ${amount}=${PAYMENT_UPDATE_AMOUNT}    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CARD}
    ...    Amount=${amount}
    ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Bằng Chuyển Khoản
    [Arguments]    ${amount}=${PAYMENT_UPDATE_AMOUNT}    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_TRANSFER}
    ...    Amount=${amount}
    ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Bằng Điểm
    [Arguments]    ${amount}=${PAYMENT_UPDATE_AMOUNT}    ${points}=50    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_POINT}
    ...    Amount=${amount}
    ...    Points=${points}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Bằng Voucher
    [Arguments]    ${amount}=${PAYMENT_UPDATE_AMOUNT}    ${voucher_code}=VOUCHER001    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_VOUCHER}
    ...    Amount=${amount}
    ...    VoucherCode=${voucher_code}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Nhiều Phương Thức
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment_cash}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=20000
    ...    Description=Thanh toán tiền mặt
    
    ${payment_card}=    Create Dictionary
    ...    Method=${PAYMENT_CARD}
    ...    Amount=30000
    ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    ...    Description=Thanh toán thẻ
    
    ${payments}=    Create List    ${payment_cash}    ${payment_card}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Vượt Quá Công Nợ
    [Arguments]    ${amount}=200000    ${description}=${PAYMENT_DESCRIPTION_1}
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=${amount}
    ...    Description=${description}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Với Hóa Đơn Không Tồn Tại
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    # Thay đổi ID thành ID không tồn tại
    Set To Dictionary    ${request_data}    InvoiceId=${INVALID_INVOICE_ID}
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=${PAYMENT_UPDATE_AMOUNT}
    ...    Description=${PAYMENT_DESCRIPTION_1}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền Âm
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=-10000
    ...    Description=Hoàn tiền
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán Với Số Tiền 0
    ${request_data}=    Chuẩn Bị Dữ Liệu Thanh Toán Tiêu Chuẩn
    
    ${payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=0
    ...    Description=Ghi chú
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

# Embedded parameter keywords
Chuẩn Bị Dữ Liệu Thanh Toán ${invoice_id} với phương thức ${method} số tiền ${amount}
    ${request_data}=    Create Dictionary    
    ...    InvoiceId=${invoice_id}
    ...    Payments=@{EMPTY}
    
    ${payment}=    Create Dictionary
    ...    Method=${method}
    ...    Amount=${amount}
    ...    Description=${PAYMENT_DESCRIPTION_1}
    
    # Thêm AccountId nếu cần cho payment method is Card or Transfer
    Run Keyword If    '${method}' == '${PAYMENT_CARD}' or '${method}' == '${PAYMENT_TRANSFER}'
    ...    Set To Dictionary    ${payment}    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
    
    ${payments}=    Create List    ${payment}
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Chuẩn Bị Dữ Liệu Thanh Toán ${invoice_id} với ${count} phương thức thanh toán tổng ${total_amount}
    ${request_data}=    Create Dictionary    
    ...    InvoiceId=${invoice_id}
    ...    Payments=@{EMPTY}
    
    ${payments}=    Create List
    
    IF    ${count} == 2
        ${amount1}=    Evaluate    ${total_amount} / 2
        ${amount2}=    Evaluate    ${total_amount} - ${amount1}
        
        ${payment1}=    Create Dictionary
        ...    Method=${PAYMENT_CASH}
        ...    Amount=${amount1}
        ...    Description=Thanh toán tiền mặt
        
        ${payment2}=    Create Dictionary
        ...    Method=${PAYMENT_CARD}
        ...    Amount=${amount2}
        ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
        ...    Description=Thanh toán thẻ
        
        Append To List    ${payments}    ${payment1}
        Append To List    ${payments}    ${payment2}
    ELSE IF    ${count} == 3
        ${amount1}=    Evaluate    ${total_amount} / 3
        ${amount2}=    Evaluate    ${total_amount} / 3
        ${amount3}=    Evaluate    ${total_amount} - ${amount1} - ${amount2}
        
        ${payment1}=    Create Dictionary
        ...    Method=${PAYMENT_CASH}
        ...    Amount=${amount1}
        ...    Description=Thanh toán tiền mặt
        
        ${payment2}=    Create Dictionary
        ...    Method=${PAYMENT_CARD}
        ...    Amount=${amount2}
        ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
        ...    Description=Thanh toán thẻ
        
        ${payment3}=    Create Dictionary
        ...    Method=${PAYMENT_TRANSFER}
        ...    Amount=${amount3}
        ...    AccountId=${DEFAULT_BANK_ACCOUNT_ID}
        ...    Description=Thanh toán chuyển khoản
        
        Append To List    ${payments}    ${payment1}
        Append To List    ${payments}    ${payment2}
        Append To List    ${payments}    ${payment3}
    END
    
    Set To Dictionary    ${request_data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${request_data}
    RETURN    ${request_data}

Gửi Yêu Cầu Cập Nhật Thanh Toán
    ${headers}=    Create Auth Headers
    # Sử dụng PUT request cho cập nhật thanh toán
    ${response}=    PUT    ${API_BASE_URL}/api/invoices/payment    ${REQUEST_DATA}    ${headers}
    Set Test Variable    ${RESPONSE}    ${response}
    Log    Response: ${response.text}
    RETURN    ${response}

# Các Keywords kiểm tra trong database
Xác Thực Thanh Toán Trong CSDL
    [Arguments]    ${invoice_id}    ${method}    ${amount}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = ? AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}    ${amount}
    Should Be Equal As Integers    ${result[0]}    1    Không tìm thấy thanh toán phù hợp trong CSDL

Xác Thực Số Lượng Thanh Toán Trong CSDL
    [Arguments]    ${invoice_id}    ${expected_count}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Integers    ${result[0]}    ${expected_count}    Số lượng thanh toán không đúng trong CSDL

Xác Thực Tổng Tiền Thanh Toán Trong CSDL
    [Arguments]    ${invoice_id}    ${expected_total}
    ${query}=    Set Variable    SELECT SUM(Amount) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng số tiền thanh toán không đúng

Xác Thực Công Nợ Hóa Đơn Trong CSDL
    [Arguments]    ${invoice_id}    ${expected_debt}
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Công nợ hóa đơn không đúng

Xác Thực Trạng Thái Hóa Đơn Trong CSDL
    [Arguments]    ${invoice_id}    ${expected_status}
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Integers    ${result[0]}    ${expected_status}    Trạng thái hóa đơn không đúng

Xác Thực Thông Tin Chi Tiết Thanh Toán Trong CSDL
    [Arguments]    ${invoice_id}    ${method}    ${amount}    ${description}=${PAYMENT_DESCRIPTION_1}
    ${query}=    Set Variable    SELECT Description FROM Payment WHERE InvoiceId = ? AND Method = ? AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}    ${amount}
    Should Be Equal    ${result[0]}    ${description}    Mô tả thanh toán không đúng

Xác Thực Dữ Liệu Thanh Toán Thẻ Trong CSDL
    [Arguments]    ${invoice_id}    ${amount}    ${account_id}=${DEFAULT_BANK_ACCOUNT_ID}
    ${query}=    Set Variable    SELECT AccountId FROM Payment WHERE InvoiceId = ? AND Method = ? AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${PAYMENT_CARD}    ${amount}
    Should Be Equal As Integers    ${result[0]}    ${account_id}    AccountId của thanh toán thẻ không đúng

Xác Thực Điểm Khả Dụng Của Khách Hàng
    [Arguments]    ${customer_id}    ${expected_points}
    ${query}=    Set Variable    SELECT AvailablePoint FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Be Equal As Numbers    ${result[0]}    ${expected_points}    Điểm khả dụng của khách hàng không đúng

# Keywords với embedded parameters
Thanh toán ${invoice_id} với phương thức ${method} số tiền ${amount} được lưu trong CSDL
    Xác Thực Thanh Toán Trong CSDL    ${invoice_id}    ${method}    ${amount}

Hóa đơn ${invoice_id} có công nợ là ${debt}
    Xác Thực Công Nợ Hóa Đơn Trong CSDL    ${invoice_id}    ${debt}

Hóa đơn ${invoice_id} có trạng thái là ${status}
    Xác Thực Trạng Thái Hóa Đơn Trong CSDL    ${invoice_id}    ${status}

Hóa đơn ${invoice_id} có tổng ${count} phương thức thanh toán
    Xác Thực Số Lượng Thanh Toán Trong CSDL    ${invoice_id}    ${count}

Hóa đơn ${invoice_id} có tổng tiền thanh toán là ${total}
    Xác Thực Tổng Tiền Thanh Toán Trong CSDL    ${invoice_id}    ${total} 