*** Settings ***
Documentation     Keywords for Order Promotion Processing API Tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/PromotionOrderData.robot
Resource          ../../Config/Env_api.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime

*** Keywords ***
# ===== CHUẨN BỊ DỮ LIỆU =====

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi hợp lệ
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Đã Bị Xóa
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi đã bị xóa
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${DELETED_ORDER_PROMOTIONS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Nhiều Khuyến Mãi Hợp Lệ
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với nhiều khuyến mãi hợp lệ
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${MULTIPLE_VALID_PROMOTIONS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Cho Nhóm Khách Hàng
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi cho nhóm khách hàng
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    CustomerId    ${CUSTOMER_GROUP_PROMOTION_ID}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${CUSTOMER_GROUP_PROMOTIONS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Khuyến Mãi Trùng Lặp
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với sản phẩm khuyến mãi có thể trùng ProductId
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderDetails    ${PROMOTION_PRODUCTS_WITH_DUPLICATE}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Chiết Khấu "${discount}" Và Phụ Thu "${surcharge}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với chiết khấu và phụ thu cụ thể
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    Discount    ${discount}
    Set To Dictionary    ${request.Order}    Surcharge    ${surcharge}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${EXPECTED_DISCOUNT}    ${discount}
    Set Test Variable    ${EXPECTED_SURCHARGE}    ${surcharge}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Tổng Tiền Bằng 0
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với tổng tiền = 0 để test tính toán lại
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    Total    0
    Set To Dictionary    ${request.Order}    Discount    10000
    Set To Dictionary    ${request.Order}    Surcharge    2000
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Với PromotionId Null
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi có PromotionId null
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${INVALID_PROMOTIONS_NULL_ID}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Hết Hạn
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi hết hạn
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${EXPIRED_PROMOTIONS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Không Hoạt Động
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với khuyến mãi không hoạt động
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${INACTIVE_PROMOTIONS}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có PromotionInfo Với Định Dạng "${format_type}"
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với PromotionInfo có định dạng đặc biệt
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    
    ${promotion_info}=    Run Keyword If    '${format_type}' == 'complex'    Set Variable    ${COMPLEX_PROMOTION_INFO}
    ...    ELSE IF    '${format_type}' == 'with_colon'    Set Variable    ${PROMOTION_INFO_WITH_COLON}
    ...    ELSE IF    '${format_type}' == 'malformed'    Set Variable    ${MALFORMED_PROMOTION_INFO}
    ...    ELSE    Set Variable    ${COMPLEX_PROMOTION_INFO}
    
    ${promotion}=    Deep Copy    ${VALID_ORDER_PROMOTION}
    Set To Dictionary    ${promotion}    PromotionInfo    ${promotion_info}
    ${promotions}=    Create List    ${promotion}
    Set To Dictionary    ${request.Order}    OrderPromotions    ${promotions}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Có Giá Trị Tiền Tệ Thập Phân
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với giá trị tiền tệ thập phân để test làm tròn
    ${request}=    Deep Copy    ${BASE_PROMOTION_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    Set To Dictionary    ${request.Order}    PurchaseDate    ${purchase_date}
    Set To Dictionary    ${request.Order}    Discount    ${DECIMAL_DISCOUNT_AMOUNT}
    Set To Dictionary    ${request.Order}    Surcharge    ${DECIMAL_SURCHARGE_AMOUNT}
    
    ${product_detail}=    Deep Copy    ${PROMOTION_PRODUCT_DETAIL}
    Set To Dictionary    ${product_detail}    Price    ${DECIMAL_PRODUCT_PRICE}
    ${product_details}=    Create List    ${product_detail}
    Set To Dictionary    ${request.Order}    OrderDetails    ${product_details}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# ===== GỬI YÊU CẦU =====

Gửi Yêu Cầu Tạo Đơn Hàng Có Khuyến Mãi
    [Documentation]    Gửi yêu cầu tạo đơn hàng có khuyến mãi
    Call API    POST    orders    ${REQUEST_DATA}

# ===== XÁC THỰC =====

Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Tạo Trong Database
    [Documentation]    Xác thực đơn hàng có khuyến mãi đã được tạo thành công trong database
    ${order_id}=    Get Response Property    $.Id
    Should Not Be Empty    ${order_id}
    
    ${query}=    Set Variable    SELECT * FROM Orders WHERE Id = ${order_id} AND RetailerId = ${RETAILER_ID}
    ${result}=    Fetch One    ${query}
    Should Not Be Empty    ${result}
    Set Test Variable    ${CREATED_ORDER_ID}    ${order_id}

Xác Thực Khuyến Mãi Hợp Lệ Được Áp Dụng Đúng
    [Documentation]    Xác thực khuyến mãi hợp lệ được áp dụng đúng trong đơn hàng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT * FROM OrderPromotion WHERE OrderId = ${order_id} AND PromotionId = ${VALID_PROMOTION_ID}
    ${result}=    Fetch One    ${query}
    Should Not Be Empty    ${result}
    Should Be Equal As Numbers    ${result[3]}    ${VALID_PROMOTION_ID}

Xác Thực Nhiều Khuyến Mãi Được Áp Dụng Đúng
    [Documentation]    Xác thực nhiều khuyến mãi được áp dụng đúng trong đơn hàng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderPromotion WHERE OrderId = ${order_id}
    ${count}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${count[0]}    2

Xác Thực Khuyến Mãi Cho Nhóm Khách Hàng Được Áp Dụng
    [Documentation]    Xác thực khuyến mãi cho nhóm khách hàng được áp dụng đúng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT * FROM OrderPromotion WHERE OrderId = ${order_id} AND PromotionId = ${PROMOTION_ID_GROUP_CUSTOMER}
    ${result}=    Fetch One    ${query}
    Should Not Be Empty    ${result}

Xác Thực Sản Phẩm Khuyến Mãi Trùng Lặp Được Xử Lý Đúng
    [Documentation]    Xác thực sản phẩm khuyến mãi trùng lặp ProductId được xử lý đúng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderDetail WHERE OrderId = ${order_id} AND ProductId = ${PRODUCT_ID_PROMOTION}
    ${count}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${count[0]}    2

Xác Thực Chiết Khấu "${expected_discount}" Và Phụ Thu "${expected_surcharge}" Được Tính Đúng
    [Documentation]    Xác thực chiết khấu và phụ thu được tính toán đúng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT Discount, Surcharge FROM Orders WHERE Id = ${order_id}
    ${result}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}
    Should Be Equal As Numbers    ${result[1]}    ${expected_surcharge}

Xác Thực Tổng Tiền Đơn Hàng Được Tính Toán Lại Đúng
    [Documentation]    Xác thực tổng tiền đơn hàng được tính toán lại đúng khi Total = 0
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT Total, Discount, Surcharge FROM Orders WHERE Id = ${order_id}
    ${result}=    Fetch One    ${query}
    ${total}=    Set Variable    ${result[0]}
    ${discount}=    Set Variable    ${result[1]}
    ${surcharge}=    Set Variable    ${result[2]}
    
    Should Not Be Equal As Numbers    ${total}    0
    Should Be True    ${total} > 0

Xác Thực Giá Trị Tiền Tệ Được Làm Tròn Đúng Theo Cấu Hình
    [Documentation]    Xác thực giá trị tiền tệ được làm tròn đúng theo cấu hình CurrencyDecimalPlace
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT Total, Discount, Surcharge FROM Orders WHERE Id = ${order_id}
    ${result}=    Fetch One    ${query}
    ${total}=    Set Variable    ${result[0]}
    ${discount}=    Set Variable    ${result[1]}
    ${surcharge}=    Set Variable    ${result[2]}
    
    # Kiểm tra các giá trị đã được làm tròn (không có số thập phân)
    Should Be Equal As Numbers    ${total}    ${total.__int__()}
    Should Be Equal As Numbers    ${discount}    ${discount.__int__()}
    Should Be Equal As Numbers    ${surcharge}    ${surcharge.__int__()}

Xác Thực Log Khuyến Mãi Được Ghi Đúng
    [Documentation]    Xác thực thông tin khuyến mãi được ghi log đúng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT * FROM OrderLog WHERE OrderId = ${order_id} AND Action LIKE '%promotion%'
    ${result}=    Fetch All    ${query}
    Should Not Be Empty    ${result}

Phản Hồi Phải Chứa Lỗi Khuyến Mãi Đã Bị Xóa "${promotion_name}"
    [Documentation]    Xác thực phản hồi chứa lỗi khuyến mãi đã bị xóa với tên khuyến mãi
    ${error_message}=    Get Response Property    $.Message
    Should Contain    ${error_message}    ${promotion_name}
    Should Contain    ${error_message}    đã bị xóa

Phản Hồi Phải Chứa Lỗi "PromotionsAreDeletedNotification"
    [Documentation]    Xác thực phản hồi chứa lỗi PromotionsAreDeletedNotification
    ${error_code}=    Get Response Property    $.Code
    Should Be Equal As Strings    ${error_code}    PromotionsAreDeletedNotification

Xác Thực PromotionInfo Được Xử Lý Đúng Định Dạng
    [Documentation]    Xác thực PromotionInfo được xử lý đúng với định dạng có dấu hai chấm
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT PromotionInfo FROM OrderPromotion WHERE OrderId = ${order_id}
    ${result}=    Fetch One    ${query}
    Should Not Be Empty    ${result[0]}

Xác Thực Khuyến Mãi Không Được Áp Dụng Khi PromotionId Null
    [Documentation]    Xác thực khuyến mãi không được áp dụng khi PromotionId là null
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderPromotion WHERE OrderId = ${order_id} AND PromotionId IS NULL
    ${count}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${count[0]}    0

Xác Thực Khuyến Mãi Hết Hạn Không Được Áp Dụng
    [Documentation]    Xác thực khuyến mãi hết hạn không được áp dụng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderPromotion WHERE OrderId = ${order_id} AND PromotionId = ${EXPIRED_PROMOTION_ID}
    ${count}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${count[0]}    0

Xác Thực Khuyến Mãi Không Hoạt Động Không Được Áp Dụng
    [Documentation]    Xác thực khuyến mãi không hoạt động không được áp dụng
    ${order_id}=    Get Response Property    $.Id
    
    ${query}=    Set Variable    SELECT COUNT(*) FROM OrderPromotion WHERE OrderId = ${order_id} AND PromotionId = ${INACTIVE_PROMOTION_ID}
    ${count}=    Fetch One    ${query}
    Should Be Equal As Numbers    ${count[0]}    0 