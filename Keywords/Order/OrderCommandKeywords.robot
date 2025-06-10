*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/Product_KeywordsCommand.robot
Resource          ../Pricebook/PricebookCommandKeywords.robot
Resource          ../Customer/CustomerCommandKeywords.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           jsonlibrary

*** Variables ***
${ORDER_ENDPOINT}    orders

*** Keywords ***
Gửi Yêu Cầu Tạo Đơn Hàng
    ${response}=    Call API With BranchId   ${ORDER_ENDPOINT}     ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Order Id From Response
    RETURN    ${response}

Gửi Yêu Cầu Cập Nhật Đơn Hàng
    ${response}=    Call API Man   ${ORDER_ENDPOINT}     ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Order Id From Response
    RETURN    ${response}

Set Order Id From Response
    ${order_id}=    Get From Dictionary    ${RESPONSE_JSON}    Id
    Set Test Variable    ${CREATED_ORDER_ID}    ${order_id}


Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    ${query}=   Set Variable   SELECT * FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}     ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL

Xác Thực Thông Tin Chi Tiết Đơn Hàng
    ${query}=   Set Variable   SELECT * FROM OrderDetail WHERE OrderId = ? 
    ${details}=    Fetch All    ${query}    ${CREATED_ORDER_ID}        
    Should Not Be Empty    ${details}    Chi tiết đơn hàng không tồn tại trong CSDL
    ${count}=    Get Length    ${details}
    Should Be Equal As Numbers    ${count}    ${1}    Số lượng chi tiết đơn hàng không khớp

Xác Thực Tổng Tiền Đơn Hàng Được Tính Đúng                                                                                                                                            
    ${query}=   Set Variable    SELECT Total FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    ${total_in_db}=    Set Variable    ${result[0]}
    
    ${total_expected}=    Evaluate    0
    FOR    ${detail}    IN    @{REQUEST_DATA["Order"]["OrderDetails"]}
        ${item_total}=    Evaluate    ${detail["Quantity"]} * ${detail["Price"]}
        ${total_expected}=    Evaluate    ${total_expected} + ${item_total}
    END
    
    # Áp dụng chiết khấu nếu có
    ${discount_value}=    Set Variable    ${REQUEST_DATA["Order"]["Discount"]}
    ${total_expected}=    Evaluate    ${total_expected} - ${discount_value}

    
    Should Be Equal As Numbers    ${total_in_db}    ${total_expected}    Tổng tiền đơn hàng không khớp

Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng
    ${query}=   Set Variable   SELECT Discount, DiscountRatio FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    ${discount_value_in_db}=    Set Variable    ${result[0]}
    ${discount_type_in_db}=    Set Variable    ${result[1]}
    
    ${expected_discount_value}=    Set Variable    ${REQUEST_DATA["Order"]["Discount"]}
    
    Should Be Equal As Numbers    ${discount_value_in_db}    ${expected_discount_value}    Giá trị chiết khấu không khớp

Xác Thực Thông Tin Giao Hàng Được Lưu Đúng
    ${query}=   Set Variable   SELECT Receiver,ContactNumber,Address FROM DeliveryPackage WHERE OrderId = ? 
    ${delivery}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${delivery}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    
    ${expected_receiver_name}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Receiver"]}
    ${expected_receiver_phone}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["ContactNumber"]}
    ${expected_receiver_address}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Address"]}
    
    Should Be Equal    ${delivery[0]}    ${expected_receiver_name}    Tên người nhận không khớp
    Should Be Equal    ${delivery[1]}    ${expected_receiver_phone}    Số điện thoại người nhận không khớp
    Should Be Equal    ${delivery[2]}    ${expected_receiver_address}    Địa chỉ người nhận không khớp

Xác Thực Phí Giao Hàng Được Cập Nhật Đúng
    ${query}=   Set Variable   SELECT Price FROM DeliveryInfo WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${price_in_db}=    Set Variable    ${result[0]}
    ${expected_price}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Price"]}
    Should Be Equal As Numbers    ${price_in_db}    ${expected_price}    Phí giao hàng không khớp

Xác Thực Đơn Hàng ${status} Thu Hộ
    ${using_price_cod}=    Set Variable If    '${status}'=='Có'    1    0
    ${query}=   Set Variable   SELECT UsingCod FROM DeliveryPackage WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${using_price_cod_in_db}=    Set Variable    ${result[0]}
    Should Be Equal As Numbers    ${using_price_cod_in_db}    ${using_price_cod}    Đơn hàng không có thu hộ


Xác Thực Đơn Hàng Có Mã Vận Đơn
    ${query}=   Set Variable   SELECT DeliveryCode FROM DeliveryInfo WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${delivery_code_in_db}=    Set Variable    ${result[0]}
    Should Be Equal    ${delivery_code_in_db}    ${REQUEST_DATA["Order"]["DeliveryDetail"]["DeliveryCode"]}    Mã vận đơn không khớp

Xác Thực Đơn Hàng Có Đối Tác Giao Hàng
    ${query}=   Set Variable   SELECT DeliveryBy FROM DeliveryInfo WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${delivery_by_in_db}=    Set Variable    ${result[0]}
    Should Be Equal    ${delivery_by_in_db}    ${REQUEST_DATA["Order"]["DeliveryDetail"]["DeliveryBy"]}    Đối tác giao hàng không khớp

Xác Thực Thông Tin Gói Giao Hàng Được Cập Nhật Đúng
    ${query}=   Set Variable   SELECT Weight,Length,Width,Height FROM DeliveryPackage WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${weight_in_db}=    Set Variable    ${result[0]}
    ${length_in_db}=    Set Variable    ${result[1]}
    ${width_in_db}=    Set Variable    ${result[2]}
    ${height_in_db}=    Set Variable    ${result[3]}
    ${expected_weight}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Weight"]}
    ${expected_length}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Length"]}
    ${expected_width}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Width"]}
    ${expected_height}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Height"]}
    Should Be Equal As Numbers    ${weight_in_db}    ${expected_weight}    Trọng lượng gói hàng không khớp
    Should Be Equal As Numbers    ${length_in_db}    ${expected_length}    Chiều dài gói hàng không khớp
    Should Be Equal As Numbers    ${width_in_db}    ${expected_width}    Chiều rộng gói hàng không khớp
    Should Be Equal As Numbers    ${height_in_db}    ${expected_height}    Chiều cao gói hàng không khớp

Xác Thực Ngày Giao Dự Kiến Được Cập Nhật Đúng
    ${query}=   Set Variable   SELECT ExpectedDelivery FROM DeliveryInfo WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${expected_delivery_in_db}=    Set Variable    ${result[0]}
    ${expected_delivery}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryDetail"]["ExpectedDelivery"]}
    ${expected_delivery_in_db}=    Convert Date    ${expected_delivery_in_db}    result_format=%Y-%m-%d %H:%M:%S
    ${expected_delivery}=    Convert Date    ${expected_delivery}    result_format=%Y-%m-%d %H:%M:%S
    Should Be Equal    ${expected_delivery_in_db}    ${expected_delivery}    Ngày giao dự kiến không khớp

Xác Thực Ghi Chú Giao Hàng Được Cập Nhật Đúng
    ${query}=   Set Variable   SELECT Comments FROM DeliveryPackage WHERE OrderId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    ${comments_in_db}=    Set Variable    ${result[0]}
    Should Be Equal    ${comments_in_db}    ${REQUEST_DATA["Order"]["DeliveryDetail"]["Comments"]}    Ghi chú giao hàng không khớp

Xác Thực Khuyến Mãi Được Áp Dụng Đúng
    ${query}=   Set Variable   SELECT * FROM OrderPromotion WHERE OrderId = ? 
    ${promotions}=    Fetch All    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${promotions}    Khuyến mãi không tồn tại trong CSDL
    
    ${promotion_id_in_db}=    Set Variable    ${promotions[0][2]}
    ${expected_promotion_id}=    Set Variable    ${REQUEST_DATA["Order"]["Promotions"][0]["PromotionId"]}
    
    Should Be Equal As Numbers    ${promotion_id_in_db}    ${expected_promotion_id}    ID khuyến mãi không khớp

Xác Thực Thông Tin Thanh Toán Được Lưu Đúng
    ${query}=   Set Variable   SELECT * FROM Payment WHERE OrderId = ? 
    ${payments}=    Fetch All    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Empty    ${payments}    Thanh toán không tồn tại trong CSDL
    ${payment_method_in_db}=    Set Variable    ${payments[0][2]}
    ${payment_amount_in_db}=    Set Variable    ${payments[0][3]}
    
    ${expected_payment_method}=    Set Variable    ${REQUEST_DATA["Order"]["Payments"][0]["Method"]}
    ${expected_payment_amount}=    Set Variable    ${REQUEST_DATA["Order"]["Payments"][0]["Amount"]}

Xác Thực Các Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount} Được Lưu Đúng
    FOR    ${payment_method}   ${payment_amount}   IN ZIP    ${list_payment_method}    ${list_payment_amount}
        ${query}=   Set Variable   SELECT Amount,Method FROM Payment WHERE OrderId = ? AND Method = ? 
        ${payments}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${payment_method}
        Should Not Be Empty    ${payments}    Thanh toán không tồn tại trong CSDL
        Should Be Equal As Numbers    ${payments[0]}    ${payment_amount}    Số tiền thanh toán không khớp
        Should Be Equal    ${payments[1]}    ${payment_method}    Phương thức thanh toán không khớp
    END

    
Xác Thực Số Lượng Đặt Hàng ${quantity} Của Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query}=   Set Variable   SELECT Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ? 
    ${result}=    Fetch One    ${query}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    ${None}    Sản phẩm không tồn tại trong CSDL
    ${reserved_in_db}=    Set Variable    ${result[0]}
    Should Be Equal As Numbers    ${reserved_in_db}    ${quantity}    Số lượng đặt hàng không khớp

Xác Thực Số Lượng Đặt Hàng Của Sản Phẩm ${product_code} Được Cập Nhập Thêm ${quantity}
    ${on_order}=   Evaluate    ${RESERVED_IN_DB} + ${quantity}
    Wait Until Keyword Succeeds    20x    1s    Xác Thực Số Lượng Đặt Hàng ${on_order} Của Sản Phẩm ${product_code}
    Set Test Variable    ${ON_ORDER_IN_DB}    ${on_order}
    

Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query}=   Set Variable   SELECT Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ? 
    ${result}=    Fetch One    ${query}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    ${None}    Sản phẩm không tồn tại trong CSDL
    ${reserved_in_db}=    Set Variable    ${result[0]}
    Set Test Variable    ${RESERVED_IN_DB}    ${reserved_in_db}
    Return From Keyword    ${reserved_in_db}

Lấy Số Lượng Đặt Hàng ${list_product_code}
    ${list_quantity}=    Create List
    FOR    ${product_code}    IN    @{list_product_code}
        ${quantity}=    Lấy Số Lượng Đặt Hàng Của Sản Phẩm ${product_code}
        Append To List    ${list_quantity}    ${quantity}
    END
    Set Test Variable    ${LIST_RESERVED_IN_DB}    ${list_quantity}

Xác Thực Số Lượng Đặt Hàng Của ${list_product_code} Được Cập Nhập Thêm ${list_quantity}
    ${list_on_order}=    Create List
    FOR    ${product_code}    ${quantity}  ${item_reserved_in_db}   IN ZIP    ${list_product_code}    ${list_quantity}    ${LIST_RESERVED_IN_DB}
        ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
        ${on_order}=   Evaluate    ${item_reserved_in_db} + ${quantity}
        Wait Until Keyword Succeeds    20x    1s    Xác Thực Số Lượng Đặt Hàng ${on_order} Của Sản Phẩm ${product_code}
        Append To List    ${list_on_order}    ${on_order}
    END
    Set Test Variable    ${LIST_ON_ORDER}    ${list_on_order}

Xác Định Order Tracking ${product_code} Có ${quantity} 
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${query}=   Set Variable   SELECT Quantity,EndReserved FROM OrderTracking WHERE DocumentId = ? AND ProductId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${quantity}    Số lượng đặt hàng không khớp


Xác Thực Số Lượng ${product_code} Đặt Hàng Giảm ${quantity}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${expected_onorder}=    Evaluate    ${RESERVED_IN_DB} - ${quantity}
    ${query}=    Set Variable    SELECT Reserved FROM ProductBranch WHERE ProductId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${product_id}    ${DEFAULT_BRANCH_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin đặt hàng
    Should Be Equal As Numbers    ${result[0]}    ${expected_onorder}    Số lượng đặt hàng không giảm đúng

Xác Thực Số Lượng Hàng ${product_code} Đặt Hàng Giảm ${quantity}
    Wait Until Keyword Succeeds    20x    1s    Xác Thực Số Lượng ${product_code} Đặt Hàng Giảm ${quantity}

Xác Định Order Tracking ${product_code} Đặt Hàng Thêm ${quantity} Được Lưu Trong Database
    Wait Until Keyword Succeeds    20x    1s    Xác Định Order Tracking ${product_code} Có ${quantity} 

Xác Thực Số Lượng Đặt Hàng ${list_quantity} Của ${list_product_code} Được Hoàn Lại
    FOR    ${product_code}    ${quantity}   ${item_reserved_in_db}   IN ZIP    ${list_product_code}    ${list_quantity}    ${LIST_ON_ORDER}
        ${on_order}=   Evaluate    ${item_reserved_in_db} - ${quantity}
        Wait Until Keyword Succeeds    20x    1s    Xác Thực Số Lượng Đặt Hàng ${on_order} Của Sản Phẩm ${product_code}
    END

Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng
    ${query}=   Set Variable   SELECT Description FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal    ${result[0]}    ${REQUEST_DATA["Order"]["Description"]}    Mô tả đơn hàng không khớp


Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là ${channel_name}
    ${channel_id}=    Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${query}=   Set Variable   SELECT SaleChannelId FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${channel_id}    Kênh bán không khớp

Xác Thực Người Nhận Đặt Trong Đơn Hàng là ${user_name}
    ${user_id}=    Lấy Thông tin Người Dùng Theo Tên    ${user_name}
    ${query}=   Set Variable   SELECT SoldById FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Be Equal As Numbers    ${result[0]}    ${user_id}    Người nhận đặt không khớp


Xác Thực Bảng Giá Trong Đơn Đặt Hàng Là ${pricebook_name}
    ${pricebook_id}=    Lấy Id Bảng Giá Theo Tên Bảng Giá  ${pricebook_name}
    ${query}=   Set Variable   SELECT Extra FROM [Order] WHERE Id = ${CREATED_ORDER_ID}
    ${result}=    Fetch One    ${query}
    ${extra_json}=    Evaluate    json.loads('''${result[0]}''')    json 
    ${actual_pricebook_id}=    Evaluate    $extra_json.get('PriceBookId', {}).get('Id')
    Should Be Equal As Numbers    ${actual_pricebook_id}    ${pricebook_id}    Bảng giá không khớp

Xác Thực Chi Nhánh Xử Lý Đã Được Chuyển Thành ${branch_name}    
    ${branch_id}=    Lấy Thông tin Chi nhánh    ${branch_name}
    ${query}=   Set Variable   SELECT BranchId FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${branch_id}    Chi nhánh không khớp
        
Delete Order From Api
    ${endpoint}=    Set Variable    ${ORDER_ENDPOINT}/${CREATED_ORDER_ID}
    ${response}=    Delete Data   ${endpoint}     
    Set Test Variable    ${RESPONSE}    ${response}
    ${response_json}=    Set Variable If    ${response.status_code} < 400    ${response.json()}    ${None}
    Set Test Variable    ${RESPONSE_JSON}    ${response_json}
    Run Keyword If    ${response.status_code} == 200    Set Order Id From Response
    RETURN    ${response}


Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${query}=   Set Variable   SELECT Id FROM SaleChannel WHERE Name = '${channel_name}' AND RetailerId = ${RETAILER_ID}
    ${result}=    Fetch One    ${query}
    Should Not Be Equal    ${result}    ${None}    Kênh bán không tồn tại trong CSDL
    Set Test Variable    ${CHANNEL_ID}    ${result[0]}
    Return From Keyword    ${CHANNEL_ID}



Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là ${customer_code}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${customer_code}
    ${query}=   Set Variable   SELECT CustomerId FROM [Order] WHERE Id = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${customer_id}    Khách hàng không khớp

   
Xác Thực Thuế VAT Được Tính Đúng 
    ${query}=   Set Variable   SELECT TaxId, DetailTax FROM OrderDetailTax WHERE DetailId = ? 
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Đơn hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}   3
    Should Be Equal As Numbers    ${result[1]}   10000


Lấy Thông tin Người Dùng Theo Tên
    [Arguments]    ${user_name}
    ${query}=   Set Variable   SELECT Id FROM [User] Where UserName=? AND RetailerId=?
    ${result}=    Fetch One    ${query}    ${user_name}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    ${None}    Người dùng không tồn tại trong CSDL
    ${user_id}=    Set Variable    ${result[0]}
    Return From Keyword    ${user_id}

Xác Thực Phiếu Thanh Toán Ở ${branch_name}
    ${branch_id}=    Lấy Thông tin Chi nhánh    ${branch_name}
    ${query}=   Set Variable   SELECT * FROM Payment WHERE OrderId = ? AND BranchId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${branch_id}
    Should Not Be Equal    ${result}    ${None}    Phiếu thanh toán không tồn tại trong CSDL



Xác Thực Ngày Bán Hàng Đã Được Cập Nhật Thành ${status} ${days} Ngày So Với Ngày Hiện Tại
    [Documentation]    Xác thực ngày bán hàng đã được cập nhật thành trước 1 ngày so với ngày hiện tại
    ${current_date}=    Get Current Date    UTC
    ${expected_date}=   Run Keyword If    "${status}" == "Trước"    Subtract Time From Date    ${current_date}    ${days} days   
    ...   ELSE  Add Time To Date    ${current_date}    ${days} days
    ${query}=    Set Variable    SELECT PurchaseDate FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}  
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    ${actual_purchase_date}=    Set Variable    ${result[0]}
    # So sánh ngày (bỏ qua giờ phút giây để tránh sai số thời gian)
    ${expected_date_str}=    Convert Date    ${expected_date}    result_format=%Y-%m-%d
    ${actual_date_str}=    Convert Date    ${actual_purchase_date}    result_format=%Y-%m-%d
    Should Be Equal As Strings    ${actual_date_str}    ${expected_date_str}    Ngày bán hàng không được cập nhật đúng


Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành ${status} ${days} Ngày So Với Ngày Hiện Tại
    ${current_date}=    Get Current Date    UTC
    ${expected_date}=   Run Keyword If    "${status}" == "Trước"    Subtract Time From Date    ${current_date}    ${days} days   
    ...   ELSE  Add Time To Date    ${current_date}    ${days} days
    ${query}=    Set Variable    SELECT ExpectedDeliveryDate FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}  
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    ${actual_expected_delivery_date}=    Set Variable    ${result[0]}
    ${expected_date_str}=    Convert Date    ${expected_date}    result_format=%Y-%m-%d
    ${actual_date_str}=    Convert Date    ${actual_expected_delivery_date}    result_format=%Y-%m-%d
    Should Be Equal As Strings    ${actual_date_str}    ${expected_date_str}    Thời gian giao hàng không được cập nhật đúng

Xác Thực Trạng Thái Đơn Hàng Đã Được Cập Là ${status}
    ${query}=    Set Variable    SELECT Status FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}  
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}    ${status}    Trạng thái đơn hàng không được cập nhật đúng
    
# thông tin chung đặt Hàng
Xác Thực Giảm Giá Đặt Hàng Trong Đơn Đặt Hàng ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giảm giá đặt hàng không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}


# Khuyến mãi 
Xác Thực Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    ${query}=    Set Variable    SELECT Discount FROM OrderPromotion WHERE OrderId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}    ${PROMOTION_VALUE}    Chiết khấu khuyến mãi không chính xác. Mong đợi: ${PROMOTION_VALUE}, Thực tế: ${result[0]}

Xác Định Chiết Khẩu Giảm Giá Khuyến Mãi Trong Đơn Đặt Hàng
    ${query}=    Set Variable    SELECT Discount, DiscountRatio FROM OrderPromotion WHERE OrderId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    ${None}    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}    ${PROMOTION_VALUE}    Chiết khấu giảm giá không chính xác. Mong đợi: ${PROMOTION_VALUE}, Thực tế: ${result[0]}
    Should Be Equal As Numbers    ${result[1]}    ${PROMOTION_RATIO}    Tỷ lệ giảm giá không chính xác. Mong đợi: ${PROMOTION_RATIO}, Thực tế: ${result[1]}

Xác Thực ID Khuyến Mãi Trong Đơn Đặt Hàng
    [Arguments]    ${expected_promotion_id}
    ${query}=    Set Variable    SELECT PromotionId FROM OrderPromotion WHERE OrderId = ? AND PromotionId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${expected_promotion_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}     ${expected_promotion_id}   ID khuyến mãi không chính xác. Mong đợi:  ${expected_promotion_id}, Thực tế: ${result[0]}

Xác Thực Tổng Giá Trị Đặt Hàng Sau Khuyến Mãi Là ${expected_total}
    ${query}=    Set Variable    SELECT Total FROM [Order] WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${result}    None    Không tìm thấy đơn hàng
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng giá trị đơn hàng không chính xác. Mong đợi: ${expected_total}, Thực tế: ${result[0]}


Xác Thực Khuyến Mãi Theo Sản Phẩm ${product_id} Giảm Giá ${expected_discount} Đồng Và ID Khuyến Mãi ${sale_promotion_id}
    ${query}=    Set Variable    SELECT Discount , SalePromotionId FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho sản phẩm trong đơn hàng ID ${CREATED_ORDER_ID} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giá trị khuyến mãi theo sản phẩm không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}
    Should Be Equal As Numbers    ${result[1]}    ${sale_promotion_id}    ID khuyến mãi không chính xác. Mong đợi: ${sale_promotion_id}, Thực tế: ${result[1]}


Sản Phẩm ${product_id} Có Chiết Khấu Khuyến Mãi Đặt Hàng ${expected_discount}% 
    ${query}=    Set Variable    SELECT DiscountRatio FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho sản phẩm trong đơn hàng ID ${CREATED_ORDER_ID} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giá trị khuyến mãi theo sản phẩm không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}


Xác Thực Quà Tặng Sản Phẩm Đặt Hàng
    [Arguments]        ${product_id}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng đã được thêm vào hóa đơn với giá 0đ
    ${query}=    Set Variable    SELECT * FROM OrderDetail WHERE OrderId = ? AND ProductId = ? AND Price = Discount
    ${results}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra số lượng
    ${actual_quantity}=    Set Variable    ${results[3]}
    Should Be Equal As Numbers    ${actual_quantity}    ${expected_quantity}
    
    # Kiểm tra ghi chú sản phẩm
    ${query}=    Set Variable    SELECT SalePromotionId FROM OrderDetail WHERE OrderId = ? AND ProductId = ?
    ${results}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    ${sale_promotion_id_detail}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${sale_promotion_id_detail}    ${SALE_PROMOTION_ID}    ID khuyến mãi không chính xác. Mong đợi: ${SALE_PROMOTION_ID}, Thực tế: ${sale_promotion_id_detail}


Xác Thực Quà Tặng Voucher Trong Đơn Hàng 
    [Documentation]    Kiểm tra voucher quà tặng đã được tạo và liên kết với hóa đơn
    ${query}=    Set Variable    SELECT * FROM OrderPromotion WHERE OrderId = ? AND PromotionId = ?
    ${results}=  Fetch One    ${query}    ${CREATED_ORDER_ID}    ${PROMOTION_ID}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin khuyến mãi tặng voucher ${CREATED_ORDER_ID} trong CSDL
    
    # Kiểm tra trạng thái voucher
    ${query}=    Set Variable    SELECT Status FROM Voucher WHERE VoucherCampaignId = ? AND Id = ?
    ${results}=    Fetch One    ${query}    ${Voucher_Campaign_Id}     ${Voucher_Id}  
    ${status}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${status}    1    Trạng thái voucher không phải là Kích hoạt

Xác Thực Quà Tặng Voucher Theo Sản Phẩm Trong Đơn Hàng 
    [Arguments]    ${invoice_id}    ${expected_value}=50000    ${expected_quantity}=1
    [Documentation]    Kiểm tra voucher quà tặng theo sản phẩm đã được tạo và liên kết
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? AND v.Value = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}    ${expected_value}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    10    Type khuyến mãi không phải ProductVoucherGift

Xác Thực Quà Tặng Điểm Đặt Hàng
    [Arguments]    ${promotion_id}=${PROMOTION_ID}    ${expected_points}=20
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT GiftPoint FROM OrderPromotion WHERE OrderId = ? AND PromotionId = ?
    ${results}=     Fetch One    ${query}    ${CREATED_ORDER_ID}    ${promotion_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin điểm thưởng    
    ${promotion_points}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng


Xác Thực Số Lượng Quà Tặng ${product_id} Với Số Lượng ${expected_quantity} Trong Đơn Đặt Hàng
    [Documentation]    Kiểm tra số lượng sản phẩm quà tặng
    ${query}=    Set Variable    SELECT Quantity FROM OrderDetail WHERE OrderId = ? AND ProductId = ? AND Price = Discount
    ${results}=    Fetch One    ${query}    ${CREATED_ORDER_ID}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    ${quantity}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${quantity}    ${expected_quantity}    Số lượng quà tặng không đúng

    





