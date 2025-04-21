*** Settings ***
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../../TestData/Invoice/Invoice_Validation_Data.robot
Library     Collections
Library     String
Library     DateTime


*** Keywords ***
Chuẩn Bị Hóa Đơn Tiêu Chuẩn Với Sản Phẩm ${product_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_product}=     Update Nested Dictionary Property     ${data_product}    ProductId=${product_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${DEFAULT_CUSTOMER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Hóa Đơn Tiêu Chuẩn Với A ${product_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_product}=     Update Nested Dictionary Property     ${data_product}    ProductId=${product_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    ${DEFAULT_CUSTOMER_ID}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    ${data}=    Evaluate    dict(${NO_DETAILS_INVOICE_DATA})
    ${empty_details}=    Create List
    Set To Dictionary    ${data}    InvoiceDetails=${empty_details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Duplicate Code
    ${data}=    Evaluate    dict(${DUPLICATE_CODE_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Long Code
    ${data}=    Evaluate    dict(${LONG_CODE_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Missing Branch
    ${data}=    Evaluate    dict(${MISSING_BRANCH_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Invalid Branch
    ${data}=    Evaluate    dict(${INVALID_BRANCH_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Customer From Other Branch
    ${data}=    Evaluate    dict(${OTHER_BRANCH_CUSTOMER_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Missing Sold By
    ${data}=    Evaluate    dict(${MISSING_SOLD_BY_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Invalid Sold By
    ${data}=    Evaluate    dict(${INVALID_SOLD_BY_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Future Date
    ${data}=    Evaluate    dict(${FUTURE_DATE_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Debt Customer
    ${data}=    Evaluate    dict(${DEBT_CUSTOMER_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Debt Limit Customer
    ${data}=    Evaluate    dict(${DEBT_LIMIT_CUSTOMER_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Missing Product Detail
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${MISSING_PRODUCT_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Zero Quantity
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${ZERO_QUANTITY_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Negative Quantity
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${NEGATIVE_QUANTITY_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Negative Price
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${NEGATIVE_PRICE_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Inactive Product
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${INACTIVE_PRODUCT_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Invalid Product
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${INVALID_PRODUCT_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Out Of Stock Product
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${OUT_OF_STOCK_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Prescription Drug
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${PRESCRIPTION_DRUG_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Combo Product
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${COMBO_PRODUCT_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${STANDARD_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Negative Payment Amount
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${NEGATIVE_AMOUNT_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Zero Payment Amount
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${ZERO_AMOUNT_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Card Payment Missing Account
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    ${payments}=    Create List    ${CARD_WITHOUT_ACCOUNT_PAYMENT}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Prepare Invoice With Insufficient Payment
    ${data}=    Evaluate    dict(${STANDARD_INVOICE_DATA})
    ${details}=    Create List    ${STANDARD_INVOICE_DETAIL}
    Set To Dictionary    ${data}    InvoiceDetails=${details}
    
    # Create payment with insufficient amount
    &{insufficient_payment}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=50000
    
    ${payments}=    Create List    ${insufficient_payment}
    Set To Dictionary    ${data}    Payments=${payments}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

