*** Settings ***
Documentation     Keywords cho test cases API tính tổng tiền hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/InvoiceTotalData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String

*** Variables ***
${COMBO_PRODUCT_ID}    SP0003
${TAX_DETAIL}    {"TaxPercentage": 10, "TaxType": "VAT"}
${SURCHARGE_ITEM}    {"Id": "SC001", "Name": "Phụ phí vận chuyển", "Value": 10000, "SurchargeType": "FIXED"}
${SURCHARGE_1_ID}    SC001

*** Keywords ***
# Chuẩn bị dữ liệu hóa đơn cơ bản
Chuẩn Bị Dữ Liệu Hóa Đơn Với Một Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với một sản phẩm để tính tổng tiền
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    # Thêm chi tiết sản phẩm
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    0
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Có Giảm Giá
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với một sản phẩm có giảm giá
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Thêm chi tiết sản phẩm có giảm giá
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_WITH_DISCOUNT_1}    1    100000    10000
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với nhiều sản phẩm
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}    
    # Thêm chi tiết sản phẩm
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    0
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_2}    1    200000    0
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá tổng hóa đơn
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Cập nhật mã hóa đơn và giảm giá
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    20000
    # Thêm chi tiết sản phẩm
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    0
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_2}    1    200000    0
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Cố Định
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với phụ phí cố định
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Thêm chi tiết sản phẩm
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    0
    
    # Thêm phụ phí
    ${surcharge}=    Deep Copy    ${surcharge_item_body}
    ${invoice_surcharges}=    Create List    ${surcharge}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceOrderSurcharges    ${invoice_surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Phần Trăm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với phụ phí phần trăm
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Thêm chi tiết sản phẩm
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    0
    
    # Thêm phụ phí phần trăm
    ${surcharge}=    Deep Copy    ${surcharge_percent_item_body}
    ${invoice_surcharges}=    Create List    ${surcharge}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceOrderSurcharges    ${invoice_surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có thuế VAT
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Cập nhật mã hóa đơn và kích hoạt tính thuế    
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.EnableVATToggle    ${TRUE}
    
    # Thêm chi tiết sản phẩm có thuế
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${detail}=    Create Invoice Detail    ${PRODUCT_WITH_VAT_1_ID}    1    100000    0
    
    # Tạo và thêm thông tin thuế
    ${tax_detail}=    Deep Copy    ${tax_detail_body}
    ${tax_details}=    Create List    ${tax_detail}
    ${detail}=    Update Dictionary Property    ${detail}    InvoiceDetailTaxs    ${tax_details}
    
    # Thêm vào invoice details
    ${invoice_details}=    Create List    ${detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm combo
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Thêm sản phẩm combo
    ${combo_detail}=    Deep Copy    ${combo_product_detail_body}
    
    # Tạo thông tin các thành phần con của combo
    ${formulas}=    Create List    ${combo_product_1_matterial_1_body}    ${combo_product_1_matterial_2_body}
    ${combo_detail}=    Update Dictionary Property    ${combo_detail}    Formulas    ${formulas}
    
    # Thêm vào invoice details
    ${invoice_details}=    Create List    ${combo_detail}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Số Lượng Nhiều
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với số lượng sản phẩm lớn hơn 1
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Thêm chi tiết sản phẩm
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    2    100000    0
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Phức Hợp
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với tất cả các thành phần
    ${request}=    Deep Copy    ${STANDARD_INVOICE_REQUEST}
    # Cập nhật mã hóa đơn và giảm giá
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_COMPLEX_TEST
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    20000
    
    # Thêm chi tiết sản phẩm
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_1}    1    100000    10000
    ${request}=    Add Invoice Detail    ${request}    ${PRODUCT_2}    1    200000    0
    
    # Thêm phụ phí cố định
    ${surcharge}=    Deep Copy    ${SURCHARGE_ITEM}
    ${invoice_surcharges}=    Create List    ${surcharge}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceOrderSurcharges    ${invoice_surcharges}
    
    # Thêm thuế VAT cho cả hóa đơn
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.EnableVATToggle    ${TRUE}
    
    # Thêm thuế chi tiết cho từng sản phẩm
    ${tax_detail}=    Deep Copy    ${TAX_DETAIL}
    
    # Áp dụng thuế cho sản phẩm 1
    ${invoice_detail1}=    Get Nested Property    ${request}    Invoice.InvoiceDetails[0]
    ${tax_details1}=    Create List    ${tax_detail}
    ${invoice_detail1}=    Update Dictionary Property    ${invoice_detail1}    InvoiceDetailTaxs    ${tax_details1}
    
    # Áp dụng thuế cho sản phẩm 2
    ${invoice_detail2}=    Get Nested Property    ${request}    Invoice.InvoiceDetails[1]
    ${tax_details2}=    Create List    ${tax_detail}
    ${invoice_detail2}=    Update Dictionary Property    ${invoice_detail2}    InvoiceDetailTaxs    ${tax_details2}
    
    # Cập nhật lại danh sách chi tiết hóa đơn
    ${invoice_details}=    Create List    ${invoice_detail1}    ${invoice_detail2}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${invoice_details}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Gửi Yêu Cầu Tạo Hóa Đơn
    [Documentation]    Gửi yêu cầu tạo hóa đơn và lưu response
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    Log    Trạng thái phản hồi: ${response.status_code}
    Log    Dữ liệu phản hồi: ${response.text}
    RETURN    ${response}

# DB Validation Keywords
Xác Thực Hóa Đơn Trong DB
    [Documentation]    Xác thực hóa đơn tồn tại trong CSDL và lấy ID
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Xác Thực Hóa Đơn Tồn Tại    ${invoice_id}

Xác Thực Hóa Đơn Tồn Tại
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

Xác Thực Tổng Tiền Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_total}
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng tiền không khớp với giá trị mong đợi

Xác Thực Chi Tiết Giá Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_price}    ${expected_discount}=${0}
    ${query}=    Set Variable    SELECT Price, Discount FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_price}    Giá sản phẩm không khớp
    Should Be Equal As Numbers    ${result[1]}    ${expected_discount}    Giảm giá sản phẩm không khớp

Xác Thực Phụ Phí Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_surcharge}
    ${query}=    Set Variable    SELECT Surcharge FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL    
    Should Be Equal As Numbers    ${result[0]}    ${expected_surcharge}    Phụ phí không khớp với giá trị mong đợi

Xác Thực Chi Tiết Phụ Phí
    [Arguments]    ${invoice_id}    ${surcharge_id}    ${expected_price}
    ${query}=    Set Variable    SELECT Price FROM InvoiceOrderSurcharge WHERE InvoiceId = ? AND SurchargeId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${surcharge_id}
    Should Not Be Equal    ${result}    None    Chi tiết phụ phí không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_price}    Giá trị phụ phí không khớp

Xác Thực Tổng Thuế
    [Arguments]    ${invoice_id}    ${expected_tax}
    ${query}=    Set Variable    SELECT TotalTax FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_tax}    Tổng thuế không khớp

Xác Thực Giảm Giá Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giảm giá hóa đơn không khớp

Xác Thực Sản Phẩm Combo
    [Arguments]    ${invoice_id}    ${combo_id}    ${expected_price}
    ${query}=    Set Variable    SELECT Price FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${combo_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn combo không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_price}    Giá sản phẩm combo không khớp    