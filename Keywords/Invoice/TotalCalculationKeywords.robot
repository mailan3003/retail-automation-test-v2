*** Settings ***
Documentation     Keywords cho các test cases tính tổng tiền hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/TotalCalculationData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Evaluate    dict(${STANDARD_TOTAL_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    100000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    0
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Nhiều Sản Phẩm
    ${data}=    Evaluate    dict(${MULTI_PRODUCT_INVOICE_DATA})
    ${details}=    Create List    ${PRODUCT_1_DETAIL}    ${PRODUCT_2_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    400000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    400000
    Set Test Variable    ${EXPECTED_DISCOUNT}    0
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Sản Phẩm
    ${data}=    Evaluate    dict(${DISCOUNTED_INVOICE_DATA})
    ${details}=    Create List    ${PRODUCT_WITH_DISCOUNT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    90000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    10000
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm Sản Phẩm
    ${data}=    Evaluate    dict(${DISCOUNTED_INVOICE_DATA})
    ${details}=    Create List    ${PRODUCT_WITH_PERCENT_DISCOUNT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    90000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    10000
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT
    ${data}=    Evaluate    dict(${VAT_INVOICE_DATA})
    ${details}=    Create List    ${PRODUCT_WITH_VAT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    110000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    0
    Set Test Variable    ${EXPECTED_VATAMOUNT}    10000
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT Bao Gồm
    ${data}=    Evaluate    dict(${VAT_INCLUDED_INVOICE_DATA})
    ${details}=    Create List    ${PRODUCT_WITH_VAT}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    100000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    90909
    Set Test Variable    ${EXPECTED_DISCOUNT}    0
    Set Test Variable    ${EXPECTED_VATAMOUNT}    9091
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Tổng
    ${data}=    Evaluate    dict(${INVOICE_DISCOUNT_AMOUNT_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    50000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    50000
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Tổng Phần Trăm
    ${data}=    Evaluate    dict(${INVOICE_DISCOUNT_PERCENT_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    90000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    10000
    Set Test Variable    ${EXPECTED_VATAMOUNT}    0
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Kết Hợp Thuế Và Chiết Khấu
    ${data}=    Evaluate    dict(${DISCOUNTED_INVOICE_DATA})
    &{product_with_vat_and_discount}=    Create Dictionary
    ...    ProductId=${product_with_vat}
    ...    Quantity=1
    ...    Price=100000
    ...    Discount=10000
    ...    VatRate=${VAT_RATE}
    
    ${details}=    Create List    ${product_with_vat_and_discount}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    Set Test Variable    ${EXPECTED_TOTAL}    99000
    Set Test Variable    ${EXPECTED_SUBTOTAL}    100000
    Set Test Variable    ${EXPECTED_DISCOUNT}    10000
    Set Test Variable    ${EXPECTED_VATAMOUNT}    9000
    RETURN    ${data}

Gửi Yêu Cầu Tạo Hóa Đơn    
    ${response}=    Call API    invoices    ${REQUEST_DATA} 
    Set Test Variable    ${RESPONSE}     ${response}

# DB Validation Keywords
Xác Thực Tổng Tiền Trong DB
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    
    ${query}=    Set Variable    SELECT Id, SubTotal, Total, Discount, VatAmount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Log    Found invoice: ${result}
    
    ${db_id}=    Set Variable    ${result[0]}
    ${db_subtotal}=    Set Variable    ${result[1]}
    ${db_total}=    Set Variable    ${result[2]}
    ${db_discount}=    Set Variable    ${result[3]}
    ${db_vatamount}=    Set Variable    ${result[4]}
    
    Should Be Equal As Numbers    ${db_subtotal}    ${EXPECTED_SUBTOTAL}    SubTotal không khớp với giá trị mong đợi
    Should Be Equal As Numbers    ${db_total}    ${EXPECTED_TOTAL}    Total không khớp với giá trị mong đợi
    Should Be Equal As Numbers    ${db_discount}    ${EXPECTED_DISCOUNT}    Discount không khớp với giá trị mong đợi
    Should Be Equal As Numbers    ${db_vatamount}    ${EXPECTED_VATAMOUNT}    VatAmount không khớp với giá trị mong đợi

Xác Thực Chi Tiết Hóa Đơn
    [Arguments]    ${invoice_id}    ${product_id}    ${quantity}    ${price}    ${discount}=0    ${vat_amount}=0
    ${query}=    Set Variable    SELECT InvoiceId, ProductId, Quantity, Price, Discount, VatAmount FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Log    Found invoice detail: ${result}
    
    ${db_invoice_id}=    Set Variable    ${result[0]}
    ${db_product_id}=    Set Variable    ${result[1]}
    ${db_quantity}=    Set Variable    ${result[2]}
    ${db_price}=    Set Variable    ${result[3]}
    ${db_discount}=    Set Variable    ${result[4]}
    ${db_vat_amount}=    Set Variable    ${result[5]}
    
    Should Be Equal As Numbers    ${db_quantity}    ${quantity}    Số lượng sản phẩm không khớp
    Should Be Equal As Numbers    ${db_price}    ${price}    Giá sản phẩm không khớp
    Should Be Equal As Numbers    ${db_discount}    ${discount}    Chiết khấu sản phẩm không khớp
    Should Be Equal As Numbers    ${db_vat_amount}    ${vat_amount}    Thuế VAT sản phẩm không khớp 