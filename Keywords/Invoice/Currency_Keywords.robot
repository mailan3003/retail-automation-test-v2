*** Settings ***
Documentation     Keywords cho test cases API của DiscountTest
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/InvoiceCurrencyData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Gian Quốc Tế Với Sản Phẩm Đơn Giá ${price} Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá và số lượng tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Quantity    ${quantity}
    ${request}=   Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${total_price}=    Evaluate    ${price} * ${quantity}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá ${price} Giảm Giá ${discount} Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá, giảm giá và số lượng tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}

    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Discount    ${discount}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    Quantity    ${quantity}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${total_price}=    Evaluate    (${price} - ${discount}) * ${quantity}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Chiết Khấu Cố Định ${discount}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với chiết khấu cố định tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}

    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
     ${product_price}=    Get From Dictionary    ${product_detail}    Price
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount}
    ${total_price}=    Evaluate    ${product_price} - ${discount}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Chiết Khấu Tỷ Lệ ${discount_ratio} %
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với chiết khấu tỷ lệ tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${product_price}=    Get From Dictionary    ${product_detail}    Price
    ${discount}=    Evaluate    ${product_price} * ${discount_ratio} / 100
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    ${discount_ratio}
    ${total_price}=    Evaluate    ${product_price} - ${discount}
    ${total_price}=    Evaluate    round(${total_price}, ${CURRENCY_DECIMAL_PLACE})
    Set Test Variable    ${TOTAL_PRICE}    ${total_price}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Gian Quốc Tế Chi Nhánh Có Timezone ${BRANCH_ID_TIMEZONE}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với chi nhánh có múi giờ khác nhau
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${BRANCH_ID_TIMEZONE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh toán ${payment_amount} ${currency_code} Phương thức ${payment_method} Khách hàng ${customer_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với đơn vị tiền tệ tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${payment_data}=    Deep Copy     ${payment_body} 
    ${payment_data_currency}=    Deep Copy     ${payment_body} 
    ${currency_rate}=    Thông tin quy đổi tiền tệ ${currency_code}
    ${payment_amount_exchange}=    Evaluate    ${payment_amount} * ${currency_rate}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${payment_method}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${payment_amount}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    ${currency_rate}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    ${currency_code} 
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount    ${payment_amount_exchange}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Method     ${payment_method}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Amount   ${payment_amount_exchange}
    ${payment_data_currency}=    Create List  ${payment_data_currency}
    ${payment_data}=    Create List  ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails   ${payment_data_currency}
    Log    ${request}
    Set Test Variable   ${PAYMENT_EXCHANGE_AMOUNT}    ${payment_amount_exchange}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Tiền Tệ Mặc Định ${payment_amount} Phương thức ${payment_method} Khách hàng lẻ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với đơn vị tiền tệ tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${payment_data}=    Deep Copy     ${payment_body} 
    ${payment_data_currency}=    Deep Copy     ${payment_body} 
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${payment_method}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${payment_amount}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    1
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    PHP
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount  ${payment_amount}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Method     ${payment_method}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Amount  ${payment_amount}
    ${payment_data_currency}=    Create List  ${payment_data_currency}
    ${payment_data}=    Create List  ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails   ${payment_data_currency}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp ${payment_amount_1} ${currency_code_1} Và ${payment_amount_2} ${currency_code_2} Khách hàng ${customer_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thanh toán kết hợp 2 loại tiền tệ
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${payment_data_1}=    Deep Copy     ${payment_body} 
    ${payment_data_2}=    Deep Copy     ${payment_body} 
    ${payment_data_currency_1}=    Deep Copy     ${payment_body} 
    ${payment_data_currency_2}=    Deep Copy     ${payment_body} 
    ${currency_rate_1}=   Run Keyword If    '${currency_code_1}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code_1}
    ${currency_rate_2}=    Run Keyword If    '${currency_code_2}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code_2}
    ${payment_amount_exchange_1}=    Evaluate    ${payment_amount_1} * ${currency_rate_1}
    ${payment_amount_exchange_2}=    Evaluate    ${payment_amount_2} * ${currency_rate_2}
    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY} 
    ${payment_data_1}=    Update Nested Dictionary Property    ${payment_data_1}    Amount   ${payment_amount_exchange_1}
    ${payment_data_2}=    Update Nested Dictionary Property    ${payment_data_2}    Amount     ${payment_amount_exchange_2}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    Amount    ${payment_amount_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    ExchangeRate    ${currency_rate_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    CurrencyCode    ${currency_code_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    ExchangeAmount    ${payment_amount_exchange_1}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    Amount    ${payment_amount_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    ExchangeRate    ${currency_rate_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    CurrencyCode    ${currency_code_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    ExchangeAmount    ${payment_amount_exchange_2}
    ${payment_data_currency}=    Create List  ${payment_data_currency_1}    ${payment_data_currency_2}
    ${payment_data}=    Create List  ${payment_data_1}    ${payment_data_2}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails   ${payment_data_currency}    
    ${total_payment}=    Evaluate     ${payment_amount_exchange_1} + ${payment_amount_exchange_2}
    Set Test Variable    ${TOTAL_PAYMENT}    ${total_payment}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    
Xác Thực Ngày Tạo Hóa Đơn Theo Múi Giờ 
    [Documentation]    Xác thực ngày tạo hóa đơn theo múi giờ
    ${expected_date}=    Get Current Date      UTC     + 7 hours
    ${expected_date_str}=    Convert Date    ${expected_date}    result_format=%Y-%m-%d %H:%M:%S
    ${query}=    Set Variable    SELECT PurchaseDate FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    ${actual_date_str}=    Convert To String    ${result[0]}
    ${actual_date_str}=    Fetch From Left    ${actual_date_str}    .
    ${expected_date_obj}=    Convert Date    ${expected_date_str}
    ${actual_date_obj}=    Convert Date    ${actual_date_str}
    ${diff}=    Subtract Date From Date    ${actual_date_obj}    ${expected_date_obj}
    ${abs_diff}=    Evaluate    abs(${diff})
    Should Be True    ${abs_diff} < 2    Ngày giờ tạo hóa đơn lệch quá 2 giây (lệch ${abs_diff} giây)

# DB Validation Keywords

Thông tin quy đổi tiền tệ ${currency_code}
    [Documentation]    Xác thực thông tin quy đổi tiền tệ trong setting
    ${query}=    Set Variable    Select id,ExchangeRate From CurrencyExchangeRate Where IsCurrent=1 AND CurrencyCode= ?
    ${result}=    Fetch One    ${query}    ${currency_code}
    ${rate}    Convert To Number   ${result[1]}
    RETURN    ${rate}    

Xác Thực Phiếu Thu Được Tạo ${payment_amount} Phương thức ${payment_method}
    [Documentation]    Xác thực phiếu thu được tạo với số tiền và đơn vị tiền tệ tùy chỉnh
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}     ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    1    Không tìm thấy phiếu thu cho hóa đơn ID ${invoice_id}
    # Kiểm tra số tiền phiếu thu
    ${query}=    Set Variable    SELECT Amount,Method,Id FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${payment_amount}     Số tiền phiếu thu không đúng. Kỳ vọng: ${payment_amount}  Thực tế: ${result[0]}
    Should Be Equal   ${result[1]}    ${payment_method}    Phương thức phiếu thu không đúng. Kỳ vọng: ${payment_method}  Thực tế: ${result[1]}
    Set Test Variable    ${PAYMENT_ID}    ${result[2]}


Xác thực tổng thanh toán hóa đơn ${expected_total_payment}
    ${query}=    Set Variable    SELECT TotalPayment FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${expected_total_payment}    Tổng tiền thanh toán không đúng. Kỳ vọng: ${expected_total_payment}, Thực tế: ${result[0]}

Xác Thực Công Nợ Của Hóa Đơn ${expected_debt}
    ${query}=    Set Variable    SELECT Debt FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${expected_debt}    Công nợ không đúng. Kỳ vọng: ${expected_debt}, Thực tế: ${result[0]}


Xác Định Công Nợ Của Khách Hàng ${customer_id} Giảm ${expected_debt}
    ${query}=    Set Variable    SELECT Value FROM BalanceTracking WHERE PartnerId = ? AND DocumentId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}   ${PAYMENT_ID} 
    Should Be Equal As Numbers    ${result[0]}    -${expected_debt}    Công nợ không đúng. Kỳ vọng: ${expected_debt}, Thực tế: ${result[0]}

Xác Thực Thanh Toán ${amount} Tiền Tệ ${currency_code} Được Lưu Trong Sổ Quỹ
    ${query}=    Set Variable    SELECT CurrencyCode,Amount FROM CashflowDetail WHERE DocumentId = ?
    ${result}=    Fetch One    ${query}     ${PAYMENT_ID} 
    Should Be Equal    ${result[0]}    ${currency_code}    Đơn vị tiền tệ không đúng. Kỳ vọng: ${currency_code}, Thực tế: ${result[0]}
    Should Be Equal As Numbers    ${result[1]}    ${amount}    Số tiền không đúng. Kỳ vọng: ${amount}, Thực tế: ${result[1]}


Lấy thông Tin công nợ khách hàng ${customer_id} trước khi thanh toán
    ${query}=    Set Variable    SELECT Debt FROM CustomerSummary WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id} 
    Set Test Variable    ${DEBT_BEFORE_PAYMENT}    ${result[0]}

Xác Thực Công Nợ Của Khách Hàng ${customer_id} Sau khi thanh toán ${payment_amount}
    ${query}=    Set Variable    SELECT Debt FROM CustomerSummary WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id} 
    ${debt_after_payment}=    Evaluate    ${DEBT_BEFORE_PAYMENT} - ${payment_amount}
    Should Be Equal As Numbers    ${result[0]}    ${debt_after_payment}    Công nợ không đúng. Kỳ vọng: ${debt_after_payment}, Thực tế: ${result[0]}

Xác Thực Tỉ Lệ Chiết Khấu Hóa Đơn ${expected_discount_ratio}
    ${query}=    Set Variable    SELECT DiscountRatio FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount_ratio}    Tỉ lệ chiết khấu không đúng. Kỳ vọng: ${expected_discount_ratio}, Thực tế: ${result[0]}

Xác Thực Chiết Khấu Hóa Đơn ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu không đúng. Kỳ vọng: ${expected_discount}, Thực tế: ${result[0]}

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp ${payment_amount_1} ${currency_code_1} ${PAYMENT_TRANSFER} Và ${payment_amount_2} ${currency_code_2} ${PAYMENT_TRANSFER} Và ${payment_amount_3} ${currency_code_3} ${PAYMENT_TRANSFER} Khách hàng ${customer_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thanh toán kết hợp 3 loại tiền tệ
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${payment_data_1}=    Deep Copy     ${payment_body} 
    ${payment_data_2}=    Deep Copy     ${payment_body} 
    ${payment_data_3}=    Deep Copy     ${payment_body} 
    ${payment_data_currency_1}=    Deep Copy     ${payment_body} 
    ${payment_data_currency_2}=    Deep Copy     ${payment_body} 
    ${payment_data_currency_3}=    Deep Copy     ${payment_body} 

    ${currency_rate_1}=   Run Keyword If    '${currency_code_1}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code_1}
    ${currency_rate_2}=    Run Keyword If    '${currency_code_2}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code_2}
    ${currency_rate_3}=    Run Keyword If    '${currency_code_3}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code_3}

    ${payment_amount_exchange_1}=    Evaluate    ${payment_amount_1} * ${currency_rate_1}
    ${payment_amount_exchange_2}=    Evaluate    ${payment_amount_2} * ${currency_rate_2}
    ${payment_amount_exchange_3}=    Evaluate    ${payment_amount_3} * ${currency_rate_3}

    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId       ${PRODUCT_ID_CURRENCY}   
    
    ${payment_data_1}=    Update Nested Dictionary Property    ${payment_data_1}    Amount   ${payment_amount_exchange_1}
    ${payment_data_1}=    Update Nested Dictionary Property    ${payment_data_1}    Method   ${PAYMENT_TRANSFER}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    Amount    ${payment_amount_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    ExchangeRate    ${currency_rate_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    CurrencyCode    ${currency_code_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    ExchangeAmount    ${payment_amount_exchange_1}
    ${payment_data_currency_1}=    Update Nested Dictionary Property    ${payment_data_currency_1}    Method    ${PAYMENT_TRANSFER}

    ${payment_data_2}=    Update Nested Dictionary Property    ${payment_data_2}    Amount     ${payment_amount_exchange_2}
    ${payment_data_2}=    Update Nested Dictionary Property    ${payment_data_2}    Method   ${PAYMENT_TRANSFER}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    Amount    ${payment_amount_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    ExchangeRate    ${currency_rate_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    CurrencyCode    ${currency_code_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    ExchangeAmount    ${payment_amount_exchange_2}
    ${payment_data_currency_2}=    Update Nested Dictionary Property    ${payment_data_currency_2}    Method   ${PAYMENT_TRANSFER}
   
    ${payment_data_3}=    Update Nested Dictionary Property    ${payment_data_3}    Amount     ${payment_amount_exchange_3}
    ${payment_data_3}=    Update Nested Dictionary Property    ${payment_data_3}    Method   ${PAYMENT_TRANSFER}
    ${payment_data_currency_3}=    Update Nested Dictionary Property    ${payment_data_currency_3}    Amount    ${payment_amount_3}
    ${payment_data_currency_3}=    Update Nested Dictionary Property    ${payment_data_currency_3}    ExchangeRate    ${currency_rate_3}
    ${payment_data_currency_3}=    Update Nested Dictionary Property    ${payment_data_currency_3}    CurrencyCode    ${currency_code_3}
    ${payment_data_currency_3}=    Update Nested Dictionary Property    ${payment_data_currency_3}    ExchangeAmount    ${payment_amount_exchange_3}
    ${payment_data_currency_3}=    Update Nested Dictionary Property    ${payment_data_currency_3}    Method    ${PAYMENT_TRANSFER}
   
    ${payment_data_currency}=    Create List  ${payment_data_currency_1}    ${payment_data_currency_2}      ${payment_data_currency_3}
    ${payment_data}=    Create List  ${payment_data_1}    ${payment_data_2}     ${payment_data_3}
    
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails   ${payment_data_currency}    
    ${total_payment}=    Evaluate     ${payment_amount_exchange_1} + ${payment_amount_exchange_2} + ${payment_amount_exchange_3}
    Set Test Variable    ${TOTAL_PAYMENT}    ${total_payment}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Xác Thực Số Lượng Phiếu Thu Được Tạo
    [Documentation]    Xác thực phiếu thu được tạo với số tiền và đơn vị tiền tệ tùy chỉnh
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}     ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    3    Không tìm thấy phiếu thu cho hóa đơn ID ${invoice_id}

    ${query}=    Set Variable    SELECT SUM(Amount) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Set Test Variable    ${PAYMENT_AMOUNT}    ${result[0]}

    ${query}=    Set Variable    SELECT Id FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch All    ${query}    ${INVOICE_ID}
    FOR    ${index}    IN RANGE    3
        Set Test Variable    ${PAYMENT_ID_${index+1}}    ${result[${index}][0]}
    END

Xác Định Số Lượng Phiếu Thu Của Khách Hàng ${customer_id}
    ${query}=    Set Variable    SELECT DocumentType FROM BalanceTracking WHERE PartnerId = ? AND DocumentId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}   ${INVOICE_ID}
    Should Be Equal As Numbers    3    ${result[0]}    Số lượng phiếu thu không đúng. Kỳ vọng: 3, Thực tế: ${result[0]}

Xác Định Số Phiếu Công Nợ Của Khách Hàng ${customer_id} Số phiếu ${expected_debt_count} Trong Sổ Quỹ
    ${total_rows}=    Set Variable    0
    FOR    ${index}    IN RANGE    3
        ${query}=    Set Variable    SELECT COUNT(*) FROM BalanceTracking WHERE PartnerId = ? AND DocumentId = ?
        ${result}=    Fetch One    ${query}    ${customer_id}   ${PAYMENT_ID_${index+1}} 
        ${total_rows}=    Evaluate    ${total_rows} + ${result[0]}
    END
    Set Test Variable    ${total_rows}    ${total_rows}
    Should Be Equal As Numbers    ${total_rows}    ${expected_debt_count}    Số lượng phiếu công nợ không đúng. Kỳ vọng: ${expected_debt_count}, Thực tế: ${total_rows}

# Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Kết Hợp ${payment_amount} ${currency_code} Và Voucher ${voucher_campaign_id} Khách Hàng ${customer_id}
#     [Documentation]    Chuẩn bị dữ liệu hóa đơn bằng tiền mặt và voucher
#     ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
#     ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
#     ${payment_data_1}=    Deep Copy     ${payment_body} 
#     ${payment_data_currency}=    Deep Copy     ${payment_body} 
#     ${currency_rate}=   Run Keyword If    '${currency_code}' == 'PHP'    Set Variable    1   
#     ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code}
#     ${payment_amount_exchange}=    Evaluate    ${payment_amount} * ${currency_rate}

    
#     ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId       ${PRODUCT_ID_CURRENCY}   
    
#     ${payment_data_1}=    Update Nested Dictionary Property    ${payment_data_1}    Amount   ${payment_amount_exchange}
#     ${payment_data_1}=    Update Nested Dictionary Property    ${payment_data_1}    Method   ${PAYMENT_CASH}
#     ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${payment_amount}
#     ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    ${currency_rate}
#     ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    ${currency_code}
#     ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount    ${payment_amount_exchange}
#     ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${PAYMENT_CASH}

#     ${query}=    Set Variable    SELECT top(1) Id, Code, VoucherCampaignId FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
#     ${voucher}=    Fetch One    ${query}    ${voucher_campaign_id}
#     Set Test Variable    ${voucher_id}    ${voucher[0]}
#     Set Test Variable    ${voucher_code}    ${voucher[1]}
    
#     ${payments}=    Create List    ${payment_voucher}    ${PAYMENT_CASH}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payments}
#     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${voucher_code}
    
#     Set Test Variable    ${REQUEST_DATA}    ${request}
#     RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Thanh Toán Kết Hợp ${payment_amount} ${currency_code} Và Voucher ${voucher_campaign_id} Khách Hàng ${customer_id}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn bằng tiền mặt và voucher
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    
    # Tính tỷ giá và số tiền quy đổi
    ${currency_rate}=   Run Keyword If    '${currency_code}' == 'PHP'    Set Variable    1   
    ...    ELSE    Thông tin quy đổi tiền tệ ${currency_code}
    ${payment_amount_exchange}=    Evaluate    ${payment_amount} * ${currency_rate}

    ${product_detail}=    Update Nested Dictionary Property    ${product_detail}    ProductId    ${PRODUCT_ID_CURRENCY}

    # Tạo payment tiền mặt
    ${payment_cash}=    Deep Copy    ${payment_body}
    ${payment_cash}=    Update Nested Dictionary Property    ${payment_cash}    Method    Cash
    ${payment_cash}=    Update Nested Dictionary Property    ${payment_cash}    Amount    ${payment_amount_exchange}
    ${payment_cash}=    Update Nested Dictionary Property    ${payment_cash}    ExchangeRate    ${currency_rate}
    ${payment_cash}=    Update Nested Dictionary Property    ${payment_cash}    CurrencyCode    ${currency_code}
    ${payment_cash}=    Update Nested Dictionary Property    ${payment_cash}    ExchangeAmount    ${payment_amount_exchange}

    # Lấy voucher hợp lệ
    ${query}=    Set Variable    SELECT top(1) Id, Code, Price FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1
    ${voucher}=    Fetch One    ${query}    ${voucher_campaign_id}
    Set Test Variable    ${voucher_id}    ${voucher[0]}
    Set Test Variable    ${voucher_code}    ${voucher[1]}
    Set Test Variable    ${voucher_price}   ${voucher[2]}
    ${voucher_price}=    Convert To Number    ${voucher_price}

    # Tạo payment voucher
    ${payment_voucher}=    Deep Copy    ${payment_body}
    ${payment_voucher}=    Update Nested Dictionary Property    ${payment_voucher}    Method    Voucher
    ${payment_voucher}=    Update Nested Dictionary Property    ${payment_voucher}    Amount    ${voucher_price}
    ${payment_voucher}=    Update Nested Dictionary Property    ${payment_voucher}    VoucherId    ${voucher_id}

    # Tạo list payments đúng định dạng
    ${payments}=    Create List    ${payment_voucher}    ${payment_cash}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    ${voucher_code}

    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
    
Xác Thực Thanh Toán Voucher Hóa Đơn
    [Arguments]    ${invoice_id}    ${voucher_id}    ${amount}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = 'Voucher' AND VoucherId = ? AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${voucher_id}    ${amount}
    Should Be Equal As Numbers    ${result[0]}    1    Thanh toán bằng voucher không được ghi nhận đúng

Xác Thực Thanh Toán Tiền Mặt Hóa Đơn
    [Arguments]    ${invoice_id}    ${amount}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = 'Cash' AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${amount}
    Should Be Equal As Numbers    ${result[0]}    1    Thanh toán bằng tiền mặt không được ghi nhận đúng

Xác Thực Tổng Tiền Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${amount}
    ${query}=    Set Variable    SELECT SUM(Amount) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${amount}    Tổng tiền thanh toán không khớp

Xác Thực Trạng Thái Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${status}
    ${query}=    Set Variable    SELECT Status FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${status}    Trạng thái thanh toán không đúng
