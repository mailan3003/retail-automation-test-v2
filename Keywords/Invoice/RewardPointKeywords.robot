*** Settings ***
Documentation     Keywords cho test cases API tính điểm thưởng hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/RewardPointData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo hóa đơn
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.IsRewardPointUsingPriceAfterDiscount    ${TRUE}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn Có Chiết Khấu
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo hóa đơn có chiết khấu
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.IsRewardPointUsingPriceAfterDiscount    ${TRUE}
    
    # Thêm thông tin sản phẩm và chiết khấu
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    10000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    90000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Hóa Đơn Có Chiết Khấu Tính Trên Giá Gốc
    [Documentation]    Chuẩn bị dữ liệu hóa đơn có chiết khấu nhưng tính điểm trên giá gốc
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.IsRewardPointUsingPriceAfterDiscount    ${FALSE}
    
    # Thêm thông tin sản phẩm và chiết khấu
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    10000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    90000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo sản phẩm
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_PRODUCT}
    
    # Thêm sản phẩm có tích điểm
    ${product}=    Deep Copy    ${PRODUCT_WITH_REWARD_POINT}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm Có Điểm Cố Định
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo sản phẩm có điểm cố định
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_PRODUCT}
    
    # Thêm sản phẩm có điểm cố định
    ${product}=    Deep Copy    ${fixed_point_product_detail}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm Số Lượng Nhiều
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với cấu hình tích điểm theo sản phẩm có số lượng lớn
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_PRODUCT}
    
    # Thêm sản phẩm có điểm cố định với số lượng lớn
    ${product}=    Deep Copy    ${fixed_point_product_detail}
    ${product}=    Update Dictionary Property    ${product}    Quantity    5
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    500000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tích Điểm Theo Sản Phẩm Hỗn Hợp
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có tích điểm và không tích điểm
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_PRODUCT}
    
    # Thêm sản phẩm có tích điểm
    ${product1}=    Deep Copy    ${PRODUCT_WITH_REWARD_POINT}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product1}
    
    # Thêm sản phẩm không tích điểm
    ${product2}=    Deep Copy    ${no_reward_product_detail}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product2}
    
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    200000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Tích Điểm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn có cấu hình không tích điểm
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_NONE}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Không Có Khách Hàng
    [Documentation]    Chuẩn bị dữ liệu hóa đơn không có khách hàng (không tích điểm)
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Cập nhật thông tin khách hàng vãng lai
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.CustomerId    0
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo hóa đơn
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    # Thêm khuyến mãi tặng điểm theo hóa đơn
    ${promotion}=    Deep Copy    ${invoice_promotion_point_gift}
    @{promotions}=    Create List    ${promotion}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoicePromotions    ${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo sản phẩm
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    # Thêm khuyến mãi tặng điểm theo sản phẩm
    ${promotion}=    Deep Copy    ${PRODUCT_PROMOTION_POINT_GIFT}
    @{promotions}=    Create List    ${promotion}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoicePromotions    ${promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Và Thuế
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với phụ phí và thuế (không tính điểm cho phụ phí và thuế)
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    
    # Thêm phụ phí và thuế
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Surcharge    10000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.TotalTax    5000
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    115000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tổng Tiền Lẻ
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với tổng tiền lẻ để kiểm tra làm tròn điểm
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Thêm thông tin sản phẩm
    ${product}=    Create Invoice Detail    ${PRODUCT_1}    1    105000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    105000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Giá Bằng 0
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có giá bằng 0
    ${request}=    Deep Copy    ${invoice_request_body}
    
    # Cập nhật cấu hình tích điểm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPointType    ${REWARD_TYPE_INVOICE}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.RewardPoint_MoneyPerPoint    ${REWARD_POINTS_MONEY_RATIO}
    
    # Thêm sản phẩm giá 0đ
    ${product1}=    Deep Copy    ${zero_price_product_detail}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product1}
    
    # Thêm sản phẩm giá thông thường
    ${product2}=    Create Invoice Detail    ${PRODUCT_2}    1    100000    0
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product2}
    
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Total    100000
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Gửi Yêu Cầu Tạo Hóa Đơn    
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    #Log To Console    Response: ${response.status_code} - ${response.text}
    Set Test Variable    ${RESPONSE}     ${response}

Xác Thực Điểm Thưởng Hóa Đơn
    [Arguments]    ${expected_point}
    [Documentation]    Xác thực điểm tích lũy của hóa đơn trong response
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    
    # Xác thực điểm thưởng trong response
    ${actual_point}=    Set Variable    ${RESPONSE.json()["Point"]}
    Should Be Equal As Numbers    ${actual_point}    ${expected_point}    Điểm thưởng của hóa đơn không đúng mong đợi
    
    # Xác thực điểm thưởng trong database
    ${query}=    Set Variable    SELECT Point FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm thưởng trong CSDL không đúng với giá trị mong đợi

Xác Thực Không Có Điểm Thưởng
    [Documentation]    Xác thực hóa đơn không có điểm thưởng hoặc có điểm thưởng bằng 0
    Xác Thực Điểm Thưởng Hóa Đơn    0

Xác Thực Bản Ghi Điểm Thưởng Được Tạo
    [Arguments]    ${expected_point}
    [Documentation]    Xác thực bản ghi tích điểm đã được tạo trong database
    ${invoice_id}=    Set Variable    ${INVOICE_ID}
    ${customer_id}=    Get Nested Property    ${REQUEST_DATA}    Invoice.CustomerId
    
    # Kiểm tra trong bảng PointTracking
    ${query}=    Set Variable    SELECT Point FROM PointTracking WHERE InvoiceId = ? AND CustomerId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${customer_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy bản ghi tích điểm trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_point}    Điểm tích lũy trong bảng PointTracking không đúng với giá trị mong đợi

Xác Thực Không Có Bản Ghi Điểm Thưởng
    [Documentation]    Xác thực không có bản ghi tích điểm được tạo
    ${invoice_id}=    Set Variable    ${INVOICE_ID}
    
    # Kiểm tra trong bảng PointTracking
    ${query}=    Set Variable    SELECT COUNT(*) FROM PointTracking WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
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

Call API PUT
    [Arguments]    ${endpoint}    ${request_data}
    [Documentation]    Gửi yêu cầu PUT API đến endpoint được chỉ định
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${TOKEN}
    ${url}=    Set Variable    ${API_URL}/${endpoint}
    ${response}=    PUT    ${url}    json=${request_data}    headers=${headers}
    Log To Console    Response: ${response.status_code} - ${response.text}
    RETURN    ${response} 