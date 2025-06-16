*** Settings ***
Documentation     Keywords cho test cases API phần cập nhật tồn kho
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../Keywords/Product/ProductCommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Variables ***
*** Keywords ***
Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=   Deep Copy   ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${request}  Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Delete Invoice From API
    Delete Data    /invoices/${INVOICE_ID}?IsVoidPayment=true