*** Settings ***
Documentation     Keywords cho test cases API của RoundingTotalAmount
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/RoundingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime

*** Keywords ***

Chuẩn Bị Dữ Liệu Hóa Đơn Quốc Tế Với Sản Phẩm Đơn Giá ${price} PHP Số Lượng ${quantity} Phương Thức Thanh Toán ${PAYMENT_CASH} Với Rounding Amount ${rounding_amount}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá, số lượng và 1 phương thức thanh toán (Cash/Transfer/Card), tự động tính amount
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
    # Xử lý 1 phương thức thanh toán
    ${payment_data}=    Deep Copy    ${payment_body}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Method    ${PAYMENT_CASH}
    ${payment_data}=    Update Nested Dictionary Property    ${payment_data}    Amount    ${total_price}
    ${payment_data_list}=    Create List    ${payment_data}
    ${payment_data_currency}=    Deep Copy    ${payment_body}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Method    ${PAYMENT_CASH}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    Amount    ${total_price}
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    CurrencyCode    VND
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeRate    1
    ${payment_data_currency}=    Update Nested Dictionary Property    ${payment_data_currency}    ExchangeAmount    ${total_price}
    ${payment_data_currency_list}=    Create List    ${payment_data_currency}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payment_data_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PaymentDetails    ${payment_data_currency_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RoundAmount    ${rounding_amount}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Xác Thực Tổng Tiền Hóa Đơn Trước Làm Tròn ${after_expected_total}
    [Documentation]    Kiểm tra tổng tiền hóa đơn trước khi làm tròn
    ${query}=    Set Variable    SELECT TotalPaymentOld FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    ${actual_total}=    Convert To Number    ${result[0]}
    ${after_expected_total}=    Convert To Number    ${after_expected_total}
    Should Be Equal As Numbers    ${actual_total}    ${after_expected_total}    Tổng tiền hóa đơn không đúng, kỳ vọng ${after_expected_total} nhưng nhận được ${actual_total}

Xác Thực Tổng Tiền Hóa Đơn Sau Khi Làm Tròn Phải ${expected_total}
    [Documentation]    Kiểm tra tổng tiền hóa đơn trong CSDL
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    ${actual_total}=    Convert To Number    ${result[0]}
    ${expected_total}=    Convert To Number    ${expected_total}
    
    # So sánh với biên độ sai số nhỏ do làm tròn
    ${diff}=    Evaluate    abs(${actual_total} - ${expected_total})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Tổng tiền hóa đơn không đúng, kỳ vọng ${expected_total} nhưng nhận được ${actual_total}

Xác Thực Chênh lệch làm tròn ${round_amount}
    [Documentation]    Kiểm tra chênh lệch làm tròn
    ${query}=    Set Variable    SELECT RoundAmount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

    IF    '${round_amount}' in ['NULL', 'None', 'null']
        Should Be Equal    ${result[0]}    ${None}    Chênh lệch làm tròn phải là NULL
    ELSE
        ${actual_round_amount}=    Convert To Number    ${result[0]}
        ${expected_round_amount}=    Convert To Number    ${round_amount}
        Should Be Equal As Numbers    ${actual_round_amount}    ${expected_round_amount}    Chênh lệch làm tròn không đúng. Kỳ vọng: ${expected_round_amount}, Thực tế: ${actual_round_amount}
    END
 