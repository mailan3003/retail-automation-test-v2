*** Settings ***
Documentation     Keywords for handling VAT-related invoice operations
Library           ../../Resources/DatabaseLibrary.py
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot    
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../Keywords/Invoice/GiftProcessingKeywords.robot
*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Mặc Định Với Sản Phẩm ${product_code}
    [Documentation]    Prepares invoice data with default VAT rate (5%)
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_detail_tax_body}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${tax_value}=    Evaluate    ${price} * 5 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   DetailTax    ${tax_value}
    ${invoice_detail_tax_body}  Create List    ${invoice_detail_tax_body}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    InvoiceDetailTaxs    ${invoice_detail_tax_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    ${tax_value}
    Log    ${request}
    Set Test Variable    ${TOTAL_TAX}    ${tax_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Hàng Hóa ${product_code} Giảm Giá ${discount_value}
    [Documentation]    Prepares invoice data with a product having a discount
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_detail_tax_body}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${discount_value}=    Convert To Number    ${discount_value}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Discount    ${discount_value}
    ${tax_value}=    Evaluate    (${price} - ${discount_value}) * 5 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   DetailTax    ${tax_value}
    ${invoice_detail_tax_body}  Create List    ${invoice_detail_tax_body}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    InvoiceDetailTaxs    ${invoice_detail_tax_body}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    ${tax_value}
    Log    ${request}
    Set Test Variable    ${TOTAL_TAX}    ${tax_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code} có ${number_line} Dòng
    [Documentation]    Prepares invoice data with a product having a discount
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_detail_tax_body_master}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    IsMaster    ${TRUE}
    ${tax_value}=    Evaluate    ${price} * 5 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body_master}  DetailTax    ${tax_value}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    InvoiceDetailTaxs    ${invoice_detail_tax_body}
    ${invoice_detail_tax_body_list}  Create List    ${invoice_detail_tax_body}
    ${data_product_list}=    Create List    ${invoice_data}
    FOR  ${item_number_line}    IN RANGE    ${number_line}
        ${data_product_new}=    Deep Copy    ${invoice_data}
        ${invoice_detail_tax_body_new}=    Deep Copy    ${invoice_detail_tax_body}
        ${data_product_new}=    Update Nested Dictionary Property    ${data_product_new}    IsMaster    ${FALSE}
        ${tax_value_new}=    Evaluate    ${price} * 5 / 100
        ${tax_value_new}=    Evaluate    round(${tax_value_new}, 0)
        ${tax_value}=    Evaluate    ${tax_value_new} + ${tax_value}
        ${invoice_detail_tax_body_new}=    Update Nested Dictionary Property  ${invoice_detail_tax_body_new}   DetailTax   ${tax_value_new}
        ${invoice_detail_tax_body_new}  Create List    ${invoice_detail_tax_body_new}
        ${data_product_new}=    Update Nested Dictionary Property    ${data_product_new}    InvoiceDetailTaxs    ${invoice_detail_tax_body_new}
        Append To List    ${data_product_list}    ${data_product_new}
        Append To List    ${invoice_detail_tax_body_list}    ${invoice_detail_tax_body_new}
    END
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    ${tax_value}
    Set Test Variable    ${TOTAL_TAX}    ${tax_value}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code} Và ${product_code_2} Có Thuế VAT Khác Nhau
    [Documentation]    Prepares invoice data with multiple products having different VAT rates
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${product_info_2}=    Thông tin hàng hóa    ${product_code_2}
    ${price}=    Convert To Number    ${product_info[2]}
    ${price_2}=    Convert To Number    ${product_info_2[2]}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data_2}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${invoice_data_2}=    Update Nested Dictionary Property    ${invoice_data_2}    ProductId    ${product_info_2[0]}
    ${invoice_data_2}=    Update Nested Dictionary Property    ${invoice_data_2}    Price    ${price_2}
    ${tax_value}=    Evaluate    ${price} * 10 / 100
    ${tax_value_2}=    Evaluate    ${price_2} * 5 / 100
    ${invoice_detail_tax_body_master}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_detail_tax_body_2}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property    ${invoice_detail_tax_body}    DetailTax    ${tax_value}
    ${invoice_detail_tax_body_2}=    Update Nested Dictionary Property    ${invoice_detail_tax_body_2}    DetailTax    ${tax_value_2}
    ${invoice_detail_tax_body_list}  Create List    ${invoice_detail_tax_body}
    ${invoice_detail_tax_body_list_2}  Create List    ${invoice_detail_tax_body_2}
    ${data_product_list}=    Create List    ${invoice_data}    ${invoice_data_2}
    ${invoice_detail_tax_body_list}=    Create List    ${invoice_detail_tax_body}    ${invoice_detail_tax_body_2}
    ${total_tax_value}=    Evaluate    ${tax_value} + ${tax_value_2}
    ${total_tax_value}=    Evaluate    round(${total_tax_value}, 0)
    ${request}=        Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetailTaxs    ${invoice_detail_tax_body_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    ${total_tax_value}
    Set Test Variable    ${TOTAL_TAX}    ${total_tax_value}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}




Xác Thực Thông Tin Thuế ${tax_value}
    [Documentation]    Verifies VAT information in invoice
    ${query}=    Set Variable    SELECT TotalTax FROM Invoice WHERE Id= ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    ${tax_value}
