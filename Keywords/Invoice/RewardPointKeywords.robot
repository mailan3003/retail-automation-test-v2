*** Settings ***
Documentation     Keywords cho test cases API tính điểm thưởng hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../Keywords/Product/ProductCommonKeywords.robot
Resource          ../../Keywords/Customer/CustomerCommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String

*** Keywords ***

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm ${product_code} Có Điểm Cố Định
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo sản phẩm có điểm cố định
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${data_product}=    Update Dictionary Property    ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Dictionary Property    ${data_product}    IsRewardPoint    ${True}
    ${request}=     Update Nested Dictionary Property   ${request}    Invoice.InvoiceDetails    ${data_product}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE_REWARD_POINT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId   ${customer_id}  
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code} Có Tích Điểm Với Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo sản phẩm có số lượng lớn
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${data_product}=     Update Nested Dictionary Property   ${data_product}    ProductId    ${product_id}
    ${data_product}=     Update Nested Dictionary Property   ${data_product}    IsRewardPoint    ${True}
    ${data_product}=     Update Nested Dictionary Property    ${data_product}    Quantity    ${quantity}
    ${request}=    Update Nested Dictionary Property   ${request}    Invoice.InvoiceDetails    ${data_product}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE_REWARD_POINT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId   ${customer_id}  
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với ${type_1} Sản Phẩm ${product_code_1} Và ${type_2} Sản Phẩm ${product_code_2}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có tích điểm và không tích điểm
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_product_2}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id_1}=    Lấy Thông Tin Sản Phẩm    ${product_code_1}
    ${product_id_2}=    Lấy Thông Tin Sản Phẩm    ${product_code_2}
    ${value_1}=   Set Variable If    "${type_1}" == "Tích Điểm"    ${True}    ${False}
    ${value_2}=   Set Variable If    "${type_2}" == "Tích Điểm"    ${True}    ${False}
    ${data_product}=    Update Dictionary Property    ${data_product}    ProductId    ${product_id_1}
    ${data_product}=    Update Dictionary Property    ${data_product}    IsRewardPoint    ${value_1}
    ${data_product_2}=    Update Dictionary Property    ${data_product_2}    ProductId    ${product_id_2}
    ${data_product_2}=    Update Dictionary Property    ${data_product_2}    IsRewardPoint    ${value_2}
    ${data_product_list}=    Create List    ${data_product}    ${data_product_2}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${data_product_list}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE_REWARD_POINT}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId   ${customer_id}  
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Khách Hàng
    [Documentation]    Chuẩn bị dữ liệu hóa đơn không có khách hàng (không tích điểm)
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${data_product}=    Update Dictionary Property    ${data_product}    ProductId   ${product_id}
    ${data_product}=    Update Dictionary Property    ${data_product}    IsRewardPoint    ${True}
    ${request}=    Update Nested Dictionary Property   ${request}    Invoice.InvoiceDetails    ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Xác Thực Điểm Thưởng Hóa Đơn ${expected_point}
    Wait Until Keyword Succeeds    20x    1s    Kiểm tra điểm thưởng hóa đơn ${expected_point}

Kiểm tra điểm thưởng hóa đơn ${expected_point}
    [Documentation]    Xác thực điểm tích lũy của hóa đơn trong response
    # Xác thực điểm thưởng trong response
    ${query}=    Set Variable    SELECT Point FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}      ${INVOICE_ID}   
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng trong CSDL không đúng với giá trị mong đợi

Xác Thực Không Có Điểm Thưởng
    [Documentation]    Xác thực hóa đơn không có điểm thưởng hoặc có điểm thưởng bằng 0
    Xác Thực Điểm Thưởng Hóa Đơn 0


Xác Thực Bản Ghi Điểm Thưởng Được Tạo ${expected_point}
    Wait Until Keyword Succeeds    15x    1s    Kiểm tra bản ghi điểm thưởng đã được tạo ${expected_point}

Kiểm tra bản ghi điểm thưởng đã được tạo ${expected_point}
    [Documentation]    Xác thực bản ghi tích điểm đã được tạo trong database
    ${customer_id}=    Get Nested Property    ${REQUEST_DATA}    Invoice.CustomerId
    
    # Kiểm tra trong bảng PointTracking
    ${query}=    Set Variable    SELECT Value FROM PointTracking WHERE DocumentId = ? AND PartnerId = ?
    ${result}=    Fetch One    ${query}   ${INVOICE_ID}   ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy bản ghi tích điểm trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm tích lũy trong bảng PointTracking không đúng với giá trị mong đợi

Xác Thực Không Có Bản Ghi Điểm Thưởng
    [Documentation]    Xác thực không có bản ghi tích điểm được tạo
    # Kiểm tra trong bảng PointTracking
    ${query}=    Set Variable    SELECT COUNT(*) FROM PointTracking WHERE DocumentId = ?
    ${result}=    Fetch One    ${query}   ${INVOICE_ID}
    Should Be Equal As Numbers    ${result[0]}    0    Tìm thấy bản ghi tích điểm khi không nên có

Thiết Lập Cấu Hình Tích Điểm
    [Arguments]    ${reward_type}    ${money_per_point}=10000    ${use_price_after_discount}=${TRUE}
    [Documentation]    Cập nhật cấu hình tích điểm trong database
    ${retailer_id}=    Set Variable    ${RETAILER_ID}
    
    # Cập nhật cấu hình tích điểm trong bảng PosSetting
    ${query_update}=    Set Variable    UPDATE PosSetting SET RewardPointType = ?, RewardPoint_MoneyPerPoint = ?, IsRewardPointUsingPriceAfterDiscount = ? WHERE RetailerId = ?
    Execute Sql    ${query_update}    ${reward_type}    ${money_per_point}    ${use_price_after_discount}    ${retailer_id}
    
    # Xác nhận cập nhật thành công
    ${query_check}=    Set Variable    SELECT RewardPointType, RewardPoint_MoneyPerPoint, IsRewardPointUsingPriceAfterDiscount FROM PosSetting WHERE RetailerId = ?
    ${result}=    Fetch One    ${query_check}    ${retailer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy bản ghi cấu hình trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${reward_type}    Cấu hình loại tích điểm không được cập nhật đúng
    Should Be Equal As Numbers    ${result[1]}    ${money_per_point}    Cấu hình tỷ lệ quy đổi điểm không được cập nhật đúng

Get Reward Point Product
    [Arguments]    ${product_code}
    [Documentation]    Lấy cấu hình tích điểm của sản phẩm trong database
    ${query}=    Set Variable    SELECT RewardPoint FROM Product WHERE Code = ?
    ${result}=    Fetch One    ${query}    ${product_code}
    RETURN    ${result[0]}

