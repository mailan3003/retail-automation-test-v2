*** Settings ***
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Product/Product_KeywordsCommand.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           json

*** Variables ***
${CREATE_ORDER_ENDPOINT}    orders

*** Keywords ***
Gửi Yêu Cầu Tạo Đơn Hàng
    ${response}=    Call API With BranchId   ${CREATE_ORDER_ENDPOINT}    ${REQUEST_DATA}
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
    ${expected_count}=    Get Length    ${REQUEST_DATA["Order"]["OrderDetails"]}
    Should Be Equal As Numbers    ${count}    ${expected_count}    Số lượng chi tiết đơn hàng không khớp

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
    ${query}=   Set Variable   SELECT * FROM DeliveryInfo WHERE OrderId = ? 
    ${delivery}=    Fetch One    ${query}    ${CREATED_ORDER_ID}
    Should Not Be Equal    ${delivery}    ${None}    Thông tin giao hàng không tồn tại trong CSDL
    
    ${receiver_name_in_db}=    Set Variable    ${delivery[4]}
    ${receiver_phone_in_db}=    Set Variable    ${delivery[5]}
    ${receiver_address_in_db}=    Set Variable    ${delivery[6]}
    
    ${expected_receiver_name}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryInfo"]["ReceiverName"]}
    ${expected_receiver_phone}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryInfo"]["ReceiverPhone"]}
    ${expected_receiver_address}=    Set Variable    ${REQUEST_DATA["Order"]["DeliveryInfo"]["ReceiverAddress"]}
    
    Should Be Equal    ${receiver_name_in_db}    ${expected_receiver_name}    Tên người nhận không khớp
    Should Be Equal    ${receiver_phone_in_db}    ${expected_receiver_phone}    Số điện thoại người nhận không khớp
    Should Be Equal    ${receiver_address_in_db}    ${expected_receiver_address}    Địa chỉ người nhận không khớp

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

    
    
    
