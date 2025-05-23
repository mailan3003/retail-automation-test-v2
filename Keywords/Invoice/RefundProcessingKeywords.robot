*** Settings ***
Documentation     Keywords liên quan đến xử lý hoàn tiền khi tạo hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           Collections
Library           OperatingSystem
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Cơ Bản
    ${invoice_data}=    Set Variable    ${STANDARD_INVOICE}
    ${invoice_data}=    Change Field Value In Dictionary    ${invoice_data}    CustomerId    ${DEFAULT_CUSTOMER_ID}
    ${invoice_detail_list}=    Set Variable    ${STANDARD_INVOICE_DETAILS}
    ${payment_list}=    Set Variable    ${PAYMENT_CASH_100000}
    
    ${request_data}=    Create Dictionary
    ...    Invoice    ${invoice_data}
    ...    InvoiceDetails    ${invoice_detail_list}
    ...    PaymentList    ${payment_list}
    
    Set Suite Variable    ${REQUEST_DATA}    ${request_data}
    Log    ${REQUEST_DATA}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Tiền ${total} Và Thanh Toán ${payment_amount} Cho Khách Hàng ${customer_type}
    ${invoice_data}=    Set Variable    ${STANDARD_INVOICE}
    ${invoice_data}=    Change Field Value In Dictionary    ${invoice_data}    Total    ${total}
    
    # Xác định CustomerId dựa trên customer_type
    ${customer_id}=    Run Keyword If    '${customer_type}' == 'khách lẻ'    Set Variable    ${0}
    ...    ELSE    Set Variable    ${DEFAULT_CUSTOMER_ID}
    
    ${invoice_data}=    Change Field Value In Dictionary    ${invoice_data}    CustomerId    ${customer_id}
    
    # Tạo list thanh toán tiền mặt với giá trị được chỉ định
    ${payment_cash}=    Create Dictionary
    ...    Method    ${PAYMENT_METHOD_CASH}
    ...    Amount    ${payment_amount}
    
    ${payment_list}=    Create List    ${payment_cash}
    
    ${request_data}=    Create Dictionary
    ...    Invoice    ${invoice_data}
    ...    InvoiceDetails    ${STANDARD_INVOICE_DETAILS}
    ...    PaymentList    ${payment_list}
    
    Set Suite Variable    ${REQUEST_DATA}    ${request_data}
    Set Suite Variable    ${CUSTOMER_ID}    ${customer_id}
    Set Suite Variable    ${TOTAL_AMOUNT}    ${total}
    Set Suite Variable    ${PAYMENT_AMOUNT}    ${payment_amount}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Vượt Quá Nhiều Phương Thức
    [Arguments]    ${cash_amount}    ${card_amount}
    ${invoice_data}=    Set Variable    ${STANDARD_INVOICE}
    ${invoice_data}=    Change Field Value In Dictionary    ${invoice_data}    CustomerId    ${DEFAULT_CUSTOMER_ID}
    
    # Tạo list thanh toán với nhiều phương thức
    ${payment_cash}=    Create Dictionary
    ...    Method    ${PAYMENT_METHOD_CASH}
    ...    Amount    ${cash_amount}
    
    ${payment_card}=    Create Dictionary
    ...    Method    ${PAYMENT_METHOD_CARD}
    ...    Amount    ${card_amount}
    
    ${payment_list}=    Create List    ${payment_cash}    ${payment_card}
    
    ${request_data}=    Create Dictionary
    ...    Invoice    ${invoice_data}
    ...    InvoiceDetails    ${STANDARD_INVOICE_DETAILS}
    ...    PaymentList    ${payment_list}
    
    Set Suite Variable    ${REQUEST_DATA}    ${request_data}
    Set Suite Variable    ${TOTAL_PAYMENT}    ${${cash_amount} + ${card_amount}}

Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Vượt Quá Bằng Phương Thức Card Với Số Tiền ${card_amount}
    ${invoice_data}=    Set Variable    ${STANDARD_INVOICE}
    ${invoice_data}=    Change Field Value In Dictionary    ${invoice_data}    CustomerId    ${DEFAULT_CUSTOMER_ID}
    
    # Tạo list thanh toán với thẻ
    ${payment_card}=    Create Dictionary
    ...    Method    ${PAYMENT_METHOD_CARD}
    ...    Amount    ${card_amount}
    
    ${payment_list}=    Create List    ${payment_card}
    
    ${request_data}=    Create Dictionary
    ...    Invoice    ${invoice_data}
    ...    InvoiceDetails    ${STANDARD_INVOICE_DETAILS}
    ...    PaymentList    ${payment_list}
    
    Set Suite Variable    ${REQUEST_DATA}    ${request_data}
    Set Suite Variable    ${PAYMENT_AMOUNT}    ${card_amount}

Thiết Lập Cấu Hình ChangeToDebt
    [Arguments]    ${value}
    # Thiết lập cấu hình ChangeToDebt trong database
    Update Config    ChangeToDebt    ${value}

Thiết Lập Cấu Hình Chuyển Tiền Thừa Thành Công Nợ Là ${value}
    ${bool_value}=    Run Keyword If    '${value}' == 'bật'    Set Variable    ${TRUE}
    ...    ELSE    Set Variable    ${FALSE}
    
    Thiết Lập Cấu Hình ChangeToDebt    ${bool_value}

Xác Thực Hóa Đơn Được Tạo Thành Công
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    # Kiểm tra hóa đơn tồn tại trong database
    ${invoice_exists}=    Check Invoice Exists    ${invoice_id}
    Should Be True    ${invoice_exists}
    
    RETURN    ${invoice_id}

Xác Thực Tổng Thanh Toán Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_total_payment}
    ${total_payment}=    Get Invoice Total Payment    ${invoice_id}
    Should Be Equal As Numbers    ${total_payment}    ${expected_total_payment}

Xác Thực Không Có Phiếu Chi Được Tạo
    [Arguments]    ${invoice_id}
    ${payment_receipts}=    Get Payment Receipts For Invoice    ${invoice_id}
    Should Be Empty    ${payment_receipts}

Tiền Thừa ${amount} Được Chuyển Thành Công Nợ Âm
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    # Kiểm tra hóa đơn tồn tại và có TotalPayment đúng
    ${total}=    Get Invoice Total    ${invoice_id}
    ${total_payment}=    Get Invoice Total Payment    ${invoice_id}
    
    ${expected_total}=    Set Variable    ${TOTAL_AMOUNT}
    ${expected_total_payment}=    Set Variable    ${PAYMENT_AMOUNT}
    
    Should Be Equal As Numbers    ${total}    ${expected_total}
    Should Be Equal As Numbers    ${total_payment}    ${expected_total_payment}
    
    # Kiểm tra không có phiếu chi
    Xác Thực Không Có Phiếu Chi Được Tạo    ${invoice_id}
    
    # Kiểm tra khách hàng có công nợ âm đúng số tiền
    ${customer_debt}=    Get Customer Debt    ${CUSTOMER_ID}
    ${expected_debt}=    Evaluate    -1 * ${amount}
    Should Be Equal As Numbers    ${customer_debt}    ${expected_debt}

Tiền Thừa Trả Lại Là ${amount}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    
    # Kiểm tra phiếu chi được tạo với số tiền đúng
    ${payment_receipts}=    Get Payment Receipts For Invoice    ${invoice_id}
    Length Should Be    ${payment_receipts}    1
    
    ${receipt}=    Set Variable    ${payment_receipts[0]}
    ${receipt_amount}=    Set Variable    ${receipt["Amount"]}
    ${expected_amount}=    Evaluate    -1 * ${amount}
    
    Should Be Equal As Numbers    ${receipt_amount}    ${expected_amount}
    Should Be Equal    ${receipt["Method"]}    ${PAYMENT_METHOD_CASH}
    
    # Kiểm tra tổng thanh toán trong hóa đơn
    ${total_payment}=    Get Invoice Total Payment    ${invoice_id}
    ${expected_total_payment}=    Evaluate    ${PAYMENT_AMOUNT} - ${amount}
    Should Be Equal As Numbers    ${total_payment}    ${expected_total_payment}

Tiền Thừa ${amount} Được Trả Lại Bằng Tiền Mặt
    Tiền Thừa Trả Lại Là ${amount}
    
    # Kiểm tra khách hàng không có công nợ âm
    ${customer_debt}=    Get Customer Debt    ${CUSTOMER_ID}
    Should Be Equal As Numbers    ${customer_debt}    0    precision=2

Xác Thực Tiền Thừa Khi Thanh Toán Nhiều Phương Thức
    [Arguments]    ${invoice_id}    ${total_payment}    ${invoice_total}
    # Tính tiền thừa
    ${overpayment}=    Evaluate    ${total_payment} - ${invoice_total}
    
    # Kiểm tra phiếu chi được tạo với số tiền đúng
    ${payment_receipts}=    Get Payment Receipts For Invoice    ${invoice_id}
    Length Should Be    ${payment_receipts}    1
    
    ${receipt}=    Set Variable    ${payment_receipts[0]}
    ${receipt_amount}=    Set Variable    ${receipt["Amount"]}
    ${expected_amount}=    Evaluate    -1 * ${overpayment}
    
    Should Be Equal As Numbers    ${receipt_amount}    ${expected_amount}
    Should Be Equal    ${receipt["Method"]}    ${PAYMENT_METHOD_CASH}
    
    # Kiểm tra tổng thanh toán trong hóa đơn
    ${total_payment_in_db}=    Get Invoice Total Payment    ${invoice_id}
    Should Be Equal As Numbers    ${total_payment_in_db}    ${invoice_total}

# Support methods for database verification
Update Config
    [Arguments]    ${config_name}    ${config_value}
    ${result}=    Execute Sql    UPDATE Configs SET Value = '${config_value}' WHERE [Key] = '${config_name}'
    Log    Updated config ${config_name} to ${config_value}

Check Invoice Exists
    [Arguments]    ${invoice_id}
    ${result}=    Query    SELECT COUNT(*) as count FROM Invoices WHERE Id = '${invoice_id}'
    ${count}=    Set Variable    ${result[0]['count']}
    ${exists}=    Evaluate    ${count} > 0
    RETURN    ${exists}

Get Invoice Total
    [Arguments]    ${invoice_id}
    ${result}=    Query    SELECT Total FROM Invoices WHERE Id = '${invoice_id}'
    ${total}=    Set Variable    ${result[0]['Total']}
    RETURN    ${total}

Get Invoice Total Payment
    [Arguments]    ${invoice_id}
    ${result}=    Query    SELECT TotalPayment FROM Invoices WHERE Id = '${invoice_id}'
    ${total_payment}=    Set Variable    ${result[0]['TotalPayment']}
    RETURN    ${total_payment}

Get Payment Receipts For Invoice
    [Arguments]    ${invoice_id}
    ${result}=    Query    SELECT * FROM PaymentReceipts WHERE InvoiceId = '${invoice_id}'
    RETURN    ${result}

Get Customer Debt
    [Arguments]    ${customer_id}
    ${result}=    Query    SELECT Debt FROM Customers WHERE Id = '${customer_id}'
    ${debt}=    Set Variable    ${result[0]['Debt']}
    RETURN    ${debt} 