*** Settings ***
Documentation     Keywords cho test cases API của DataProcessingTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/InvoiceVLXDDATA.robot
Resource          ../../Keywords/Invoice/InvoiceVATKeywords.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id} Và Kích Thước ${x}x${y}x${z}x${w} 
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_data}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${materials_data}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}mx${w} 
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute3   ${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type1    1
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type2    8
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Gạch ${product_id} Và Kích Thước ${x}x${y}x${z}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_data}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${materials_data}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}

    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id_1} Kích Thước ${x}x${y}x${z}x${w} Và ${product_id_2} Kích Thước ${x2}x${y2}x${z2}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_data}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${product_data_2}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${materials_data}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
    ${materials_data_2}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id_1}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${x}mx${y}mx${z}x${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute3   ${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${w}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type1   1
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Type2   8
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    ProductId   ${product_id_2}
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    Note    ${x2}mx${y2}mx${z2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute1   ${x2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute2   ${y2}
    ${materials_data_2}    Update Nested Dictionary Property    ${materials_data_2}    Attribute4   ${z2}

    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${product_data_2}    Update Nested Dictionary Property    ${product_data_2}    TransactionDetailMaterials      ${materials_data_2} 
    ${list_product_data}=    Create List    ${product_data}    ${product_data_2}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${list_product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}





Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id} Có ${n} Gợi ý và Kích Thước ${x}x${y}${z}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_data}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${dimension_string}=    Set Variable    ${EMPTY}
    FOR    ${i}    IN RANGE    ${n}+1
        ${dimension_string}=    Set Variable    ${dimension_string} ${x}mx${y}mx${z}
    END
    Log    Chuỗi kích thước: ${dimension_string}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note    ${dimension_string}
    ${list_materials_data}=    Create List
    FOR    ${i}    IN RANGE    ${n}+1
            ${materials_data}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
            ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}    
            Append To List    ${list_materials_data}    ${materials_data}
    END
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${list_materials_data} 
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_data}   
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id} Có ${n} Dòng Với Kích Thước ${x}x${y}x${z}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_data}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
    ${materials_data}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    ProductId   ${product_id}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    IsMaster    ${True}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    Note  ${x}mx${y}mx${z}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute1   ${x}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute2   ${y}
    ${materials_data}    Update Nested Dictionary Property    ${materials_data}    Attribute4   ${z}
    ${product_data}    Update Nested Dictionary Property    ${product_data}    TransactionDetailMaterials      ${materials_data} 
    ${list_product_data}=    Create List   ${product_data}
    FOR    ${i}    IN RANGE    ${n}
        ${product_data_child}     Deep Copy   ${STANDARD_INVOICE_DETAIL}  
        ${materials_data_child}     Deep Copy    ${STANDARD_MATERIALS_DETAIL}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    ProductId   ${product_id}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    IsMaster    ${False}
        ${product_data_child}    Update Nested Dictionary Property    ${product_data_child}    Note  ${x}mx${y}mx${z}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute1   ${x}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute2   ${y}
        ${materials_data_child}    Update Nested Dictionary Property    ${materials_data_child}    Attribute4   ${z}
        ${materials_data_child}     Update Nested Dictionary Property    ${product_data_child}    TransactionDetailMaterials      ${materials_data_child} 
        Append To List    ${list_product_data}    ${product_data_child}
    END
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${list_product_data}   
    
    Set Test Variable    ${REQUEST_DATA}   ${request} 
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế Trực Tiếp Mặc Định Với Sản Phẩm ${product_code}
    [Documentation]    Prepares invoice data with default VAT rate (2%)
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_detail_tax_body}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${tax_value}=    Evaluate    ${price} * 0.02*20 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   DetailTax   ${tax_value}
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   TaxId    7
    ${invoice_detail_tax_body}  Create List    ${invoice_detail_tax_body}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    InvoiceDetailTaxs    ${invoice_detail_tax_body}
    ${invoice_data}   Create List    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    -${tax_value}
    Log    ${request}
    Set Test Variable    ${TOTAL_TAX}    ${tax_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Gía ${discount_value} Với Thuế Trực Tiếp Mặc Định Với Sản Phẩm ${product_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_detail_tax_body}=    Deep Copy    ${invoice_detail_tax_body}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price}=    Convert To Number    ${product_info[2]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_info[0]}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    ${price}
    ${tax_value}=    Evaluate    ${price} * 0.02*20 / 100
    ${tax_value}=    Evaluate    round(${tax_value}, 0)
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   DetailTax    700
    ${invoice_detail_tax_body}=    Update Nested Dictionary Property  ${invoice_detail_tax_body}   TaxId    7
    ${invoice_detail_tax_body}  Create List    ${invoice_detail_tax_body}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    InvoiceDetailTaxs    ${invoice_detail_tax_body}
    ${invoice_data}   Create List    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount_value}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    -700
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_id} Với Khách Hàng ${customer_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_id}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    1000000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId     ${customer_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Tích Điểm Với Sản Phẩm ${product_id} Có Giảm Giá ${discount_value} và Khách Hàng ${customer_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${invoice_data}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    ProductId    ${product_id}
    ${invoice_data}=    Update Nested Dictionary Property    ${invoice_data}    Price    1000000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_data}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId     ${customer_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount_value}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Kích Thước ${x}x${y}x${z}x${w} Sản Phẩm ${product_id} Trong DB
    ${x}=    Convert To Number    ${x}
    ${y}=    Convert To Number    ${y}
    ${z}=    Convert To Number    ${z}
    ${w}=    Convert To Number    ${w}
    ${type1}=    Convert To Number    1
    ${type2}=    Convert To Number    8
    ${query}=    Set Variable    Select * from TransactionDetailMaterial where TransactionId= ? And ProductId= ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm VLXD với ID ${product_id} trong DB
    Should Be Equal    ${result[10]}    ${x}    Kích thước sản phẩm không đúng. Kỳ vọng: ${x}, Thực tế: ${result[10]}
    Should Be Equal    ${result[11]}    ${y}    Kích thước sản phẩm không đúng. Kỳ vọng: ${y}, Thực tế: ${result[11]}
    Should Be Equal    ${result[12]}    ${z}    Kích thước sản phẩm không đúng. Kỳ vọng: ${z}, Thực tế: ${result[12]}
    Should Be Equal    ${result[13]}    ${w}    Kích thước sản phẩm không đúng. Kỳ vọng: ${w}, Thực tế: ${result[13]}
    Should Be Equal    ${result[15]}    ${type1}    Kích thước sản phẩm không đúng. Kỳ vọng: ${type1}, Thực tế: ${result[14]}
    Should Be Equal    ${result[16]}    ${type2}    Kích thước sản phẩm không đúng. Kỳ vọng: ${type2}, Thực tế: ${result[15]}

Xác thực Sản Phẩm Gạch ${product_id} Có Kích Thước ${x}x${y}x${z} Trong DB
    ${x}=    Convert To Number    ${x}
    ${y}=    Convert To Number    ${y}
    ${z}=    Convert To Number    ${z}
    ${type1}=    Convert To Number    2
    ${type2}=    Convert To Number    1
    ${query}=    Set Variable    Select * from TransactionDetailMaterial where TransactionId= ? And ProductId= ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm VLXD với ID ${product_id} trong DB
    Should Be Equal    ${result[10]}    ${x}    Kích thước sản phẩm không đúng. Kỳ vọng: ${x}, Thực tế: ${result[10]}
    Should Be Equal    ${result[11]}    ${y}    Kích thước sản phẩm không đúng. Kỳ vọng: ${y}, Thực tế: ${result[11]}
    Should Be Equal    ${result[13]}    ${z}    Kích thước sản phẩm không đúng. Kỳ vọng: ${z}, Thực tế: ${result[13]}
    Should Be Equal    ${result[15]}    ${type1}    Kích thước sản phẩm không đúng. Kỳ vọng: ${type1}, Thực tế: ${result[14]}
    Should Be Equal    ${result[16]}    ${type2}    Kích thước sản phẩm không đúng. Kỳ vọng: ${type2}, Thực tế: ${result[15]}


Xác Thực Sản Phẩm ${product_id} Có ${n} Dòng Với Kích Thước ${x}x${y}x${z} Trong DB
    ${n_expected}=    Evaluate    ${n} + 1
    ${query}=    Set Variable    Select COUNT(Id) from TransactionDetailMaterial where TransactionId= ? And ProductId= ? 
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}   
    Should Be Equal    ${result[0]}    ${n_expected}    Số lượng dòng hàng không đúng. Kỳ vọng: ${n_expected}, Thực tế: ${result}






