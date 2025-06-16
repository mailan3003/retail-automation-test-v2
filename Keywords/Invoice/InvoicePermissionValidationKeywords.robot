*** Settings ***
Resource    ../Utilities/RequestHelper.robot
Resource    ../Utilities/ResponseHelper.robot
Resource    ../../TestData/CommonData.robot
Resource    ../../TestData/Invoice/CommonInvoiceData.robot
Resource    ../CommonKeywords.robot
Resource    ../Promotion/PromotionComnonKeywords.robot
Resource    ../Product/ProductCommonKeywords.robot
Resource    ../Customer/CustomerCommonKeywords.robot
Resource    ../PriceBook/PriceBookCommonKeywords.robot
Resource    InvoiceCommonKeywords.robot
Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/DataUtilities.robot
Resource    ../Login/Login.robot
Library    ../../Resources/DatabaseLibrary.py
Library    DateTime

*** Keywords ***
Chuẩn bị hóa đơn tiêu chuẩn
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    Set Test Variable    ${REQUEST_DATA}    ${request}    

Chuẩn bị hóa đơn tiêu chuẩn với trạng thái ${status}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    Status    ${status}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với người bán ${seller_id}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    SoldById    ${seller_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với người bán là ${seller_name}
    ${seller_id}=    Lấy Thông tin Người Dùng Theo Tên    ${seller_name}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    SoldById    ${seller_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với kênh bán ${channel_id}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    SaleChannelId    ${channel_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với kênh bán là ${channel_name}
    ${channel_id}=    Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    SaleChannelId    ${channel_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
Chuẩn Bị Dữ Liệu Thay Đổi Thời Gian Lùi ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC    
    ${purchase_date}=   Subtract Time From Date   ${current_date}    ${days} days
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PurchaseDate    ${purchase_date}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${PURCHASE_DATE}    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với ngày bán không đúng định dạng
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${current_date}=    Get Current Date    UTC   7 hours     result_format=%Y-%m-%d %H:%M:%S
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PurchaseDate  0000/20/20
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${PURCHASE_DATE}    ${current_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với bảng giá ${pricebook_id}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PricebookId    ${pricebook_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}


Chuẩn bị dữ liệu hóa đơn với bảng giá là ${pricebook_name}
    ${pricebook_id}=    Lấy Id Bảng Giá Theo Tên Bảng Giá   ${pricebook_name}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PricebookId    ${pricebook_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Chuẩn bị dữ liệu hóa đơn với bảng giá ${pricebook_name} theo chi nhánh ${branch_name}
    ${pricebook_id}=    Lấy Id Bảng Giá Theo Tên Bảng Giá   ${pricebook_name}
    ${branch_id}=    Lấy Thông tin Chi Nhánh  ${branch_name}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    PricebookId    ${pricebook_id}    
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    BranchId    ${branch_id}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Tạo hóa đơn với user ${username} và password ${password}
    ${bearer_token}=    Get BearerToken by user    ${username}    ${password}
    ${request}=   Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE}
    ${request_invoice}=    Get From Dictionary    ${REQUEST_DATA}    Invoice
    ${request_invoice}=    Update Nested Dictionary Property    ${request_invoice}    BearerToken    ${bearer_token}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}

Thông tin người bán ${seller_name} trong hóa đơn được lưu trong CSDL
    ${seller_id}=    Lấy Thông tin Người Dùng Theo Tên    ${seller_name}
    ${query}=    Set Variable    SELECT SoldbyId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Strings    ${result[0]}    ${seller_id}    Người bán không đúng

Thông tin kênh bán ${channel_name} trong hóa đơn được lưu trong CSDL
    ${channel_id}=    Lấy Id Kênh Bán Hàng Theo Tên    ${channel_name}
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
    Should Be True    ${abs_diff} < 5    Ngày giờ tạo hóa đơn lệch quá 2 giây (lệch ${abs_diff} giây)

Thông tin bảng giá ${pricebook_name} trong hóa đơn được lưu trong CSDL
    ${pricebook_id}=   Lấy Id Bảng Giá Theo Tên Bảng Giá   ${pricebook_name}
    ${query}=    Set Variable    SELECT PricebookId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Strings    ${result[0]}    ${pricebook_id}    Bảng giá không đúng
