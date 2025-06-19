*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../Login/Login.robot
Library    ../../Resources/DatabaseLibrary.py
Library    DateTime

*** Keywords ***
Chuẩn bị hóa đơn tiêu chuẩn
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    Set Test Variable    ${REQUEST_DATA}    ${request}    

Chuẩn bị hóa đơn tiêu chuẩn với trạng thái ${status}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Status    ${status}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với người bán ${seller_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.SoldById    ${seller_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với kênh bán ${channel_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.SaleChannelId    ${channel_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn Bị Dữ Liệu Thay Đổi Thời Gian Lùi ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC    
    ${purchase_date}=   Subtract Time From Date   ${current_date}    ${days} days
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate    ${purchase_date}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với ngày bán không đúng định dạng
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${current_date}=    Get Current Date    UTC   7 hours     result_format=%Y-%m-%d %H:%M:%S
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PurchaseDate  0000/20/20
    Set Test Variable    ${PURCHASE_DATE}    ${current_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với bảng giá ${pricebook_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PricebookId    ${pricebook_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với bảng giá ${pricebook_id} theo chi nhánh ${branch_id}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.PricebookId    ${pricebook_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BranchId    ${branch_id}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Tạo hóa đơn với user ${username} và password ${password}
    ${bearer_token}=    Get BearerToken by user    ${username}    ${password}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.BearerToken    ${bearer_token}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Thông tin người bán ${seller_id} trong hóa đơn được lưu trong CSDL
    ${query}=    Set Variable    SELECT SoldbyId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Strings    ${result[0]}    ${seller_id}

Thông tin kênh bán ${channel_id} trong hóa đơn được lưu trong CSDL
    ${query}=    Set Variable    SELECT SaleChannelId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Strings    ${result[0]}    ${channel_id}
Thông tin ngày bán ${purchase_date} trong hóa đơn được lưu trong CSDL
    ${query}=    Set Variable    SELECT PurchaseDate FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    ${actual_date_str}=    Convert To String    ${result[0]}
    ${actual_date_str}=    Fetch From Left    ${actual_date_str}    .
    ${expected_date_obj}=    Convert Date    ${purchase_date} 
    ${actual_date_obj}=    Convert Date    ${actual_date_str}
    ${diff}=    Subtract Date From Date    ${actual_date_obj}    ${expected_date_obj}
    ${abs_diff}=    Evaluate    abs(${diff})
    Should Be True    ${abs_diff} < 2    Ngày giờ tạo hóa đơn lệch quá 2 giây (lệch ${abs_diff} giây)

Thông tin bảng giá ${pricebook_id} trong hóa đơn được lưu trong CSDL
    ${query}=    Set Variable    SELECT PricebookId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Strings    ${result[0]}    ${pricebook_id}

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

