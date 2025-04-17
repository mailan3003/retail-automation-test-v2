*** Settings ***
Documentation     Keywords for handling VAT-related invoice operations
Library           ../Libraries/API/InvoiceAPI.py
Library           ../Libraries/Database/DatabaseLibrary.py
Library           ../Libraries/Common/CommonLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Mặc Định
    [Documentation]    Prepares invoice data with default VAT rate (10%)
    Set Suite Variable    ${PRODUCT_CODE}    SP040943
    Set Suite Variable    ${QUANTITY}    1
    Set Suite Variable    ${PRICE}    100000
    Set Suite Variable    ${VAT_RATE}    10
    ${invoice_data}=    Create Dictionary
    ...    product_code=${PRODUCT_CODE}
    ...    quantity=${QUANTITY}
    ...    price=${PRICE}
    Set Suite Variable    ${INVOICE_DATA}    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Tùy Chỉnh
    [Arguments]    ${vat_rate}
    [Documentation]    Prepares invoice data with custom VAT rate
    Set Suite Variable    ${PRODUCT_CODE}    SP040943
    Set Suite Variable    ${QUANTITY}    1
    Set Suite Variable    ${PRICE}    100000
    Set Suite Variable    ${VAT_RATE}    ${vat_rate}
    ${invoice_data}=    Create Dictionary
    ...    product_code=${PRODUCT_CODE}
    ...    quantity=${QUANTITY}
    ...    price=${PRICE}
    ...    vat_rate=${VAT_RATE}
    Set Suite Variable    ${INVOICE_DATA}    ${invoice_data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Thuế Khác Nhau
    [Documentation]    Prepares invoice data with multiple products having different VAT rates
    Set Suite Variable    ${PRODUCT_1}    SP040943
    Set Suite Variable    ${PRODUCT_2}    SP040944
    ${product1}=    Create Dictionary
    ...    product_code=${PRODUCT_1}
    ...    quantity=1
    ...    price=100000
    ...    vat_rate=10
    ${product2}=    Create Dictionary
    ...    product_code=${PRODUCT_2}
    ...    quantity=1
    ...    price=200000
    ...    vat_rate=5
    ${products}=    Create List    ${product1}    ${product2}
    ${invoice_data}=    Create Dictionary    products=${products}
    Set Suite Variable    ${INVOICE_DATA}    ${invoice_data}

Gửi Yêu Cầu Tạo Hóa Đơn
    [Documentation]    Sends request to create invoice
    ${response}=    Create Invoice    ${INVOICE_DATA}
    Set Suite Variable    ${RESPONSE}    ${response}
    Set Suite Variable    ${INVOICE_ID}    ${response.json()['id']}

Response Status Code Should Be
    [Arguments]    ${expected_status}
    [Documentation]    Verifies response status code
    Should Be Equal As Strings    ${RESPONSE.status_code}    ${expected_status}

Response Should Have Id exist
    [Documentation]    Verifies response contains invoice ID
    Dictionary Should Contain Key    ${RESPONSE.json()}    id

Response Should Have Error
    [Arguments]    ${expected_error}
    [Documentation]    Verifies response contains expected error message
    Dictionary Should Contain Key    ${RESPONSE.json()}    error
    Should Be Equal As Strings    ${RESPONSE.json()['error']}    ${expected_error}

Xác Thực Hóa Đơn Trong CSDL
    [Documentation]    Verifies invoice exists in database
    ${db_invoice}=    Get Invoice From Database    ${INVOICE_ID}
    Should Not Be Empty    ${db_invoice}

Xác Thực Thông Tin Thuế
    [Arguments]    ${invoice_id}    ${vat_rate}    ${subtotal}    ${vat_amount}    ${total}
    [Documentation]    Verifies VAT information in invoice
    ${db_invoice}=    Get Invoice From Database    ${invoice_id}
    Should Be Equal As Numbers    ${db_invoice['vat_rate']}    ${vat_rate}
    Should Be Equal As Numbers    ${db_invoice['subtotal']}    ${subtotal}
    Should Be Equal As Numbers    ${db_invoice['vat_amount']}    ${vat_amount}
    Should Be Equal As Numbers    ${db_invoice['total']}    ${total}

Xác Thực Chi Tiết Thuế Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_code}    ${vat_rate}    ${vat_amount}
    [Documentation]    Verifies VAT information for specific product in invoice
    ${db_invoice_detail}=    Get Invoice Detail From Database    ${invoice_id}    ${product_code}
    Should Be Equal As Numbers    ${db_invoice_detail['vat_rate']}    ${vat_rate}
    Should Be Equal As Numbers    ${db_invoice_detail['vat_amount']}    ${vat_amount} 