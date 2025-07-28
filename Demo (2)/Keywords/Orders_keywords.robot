*** Settings ***
Resource    ../../Keywords/Utilities/DataUtilities.robot
Resource    ../Data/Orders_data.robot
Library    RequestsLibrary

*** Variables ***
${endpoint_list_orders}    orders?format=json&Includes=Branch&BranchIds=%5B30%5D&%24filter=(BranchId+eq+30+and+PurchaseDate+eq+%27month%27+and+PurchaseDate+eq+%27month%27)



*** Keywords ***

Chuẩn bị dữ liệu tạo đơn đặt hàng
    ${request}=    Deep Copy    ${ORDER}
    ${request_body}=    Create Dictionary
    ${request_body}=    Update Nested Dictionary Property    ${request_body}    Order    ${request}
    Log    ${request_body}
    Set Test Variable    ${REQUEST_DATA}    ${request_body}

Gửi yêu cầu tạo đơn đặt hàng
    ${response_data}=    POST On Session    session    url=orders    json=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response_data}
    Set Test Variable    ${ORDERS_ID}    ${response_data.json()["Id"]}
    Set Test Variable    ${ORDERS_CODE}    ${response_data.json()["Code"]}

Kiểm tra đơn đặt hàng được tạo qua danh sách đơn đặt hàng
    ${list_order}=    GET On Session    session    url=${endpoint_list_orders}
    # Kiểm tra id đơn đặt hàng
    Should Be Equal As Numbers    ${ORDERS_ID}    ${list_order.json()["Data"][0]["Id"]}
    # Kiểm tra mã đơn đặt hàng
    Should Be Equal As Strings    ${ORDERS_CODE}    ${list_order.json()["Data"][0]["Code"]}
    # Kiểm tra thông tin khách hàng
    Should Be Equal As Strings    ${RESPONSE.json()["CustomerId"]}       ${list_order.json()["Data"][0]["CustomerId"]}
    # Kiểm tra tổng tiền hàng
    Should Be Equal As Numbers    ${RESPONSE.json()["SubTotal"]}       ${list_order.json()["Data"][0]["SubTotal"]}
    # Kiểm tra tiền khách cần trả
    Should Be Equal As Numbers    ${RESPONSE.json()["Total"]}       ${list_order.json()["Data"][0]["Total"]}
    # Kiểm tra trường khách đã trả
    Should Be Equal As Numbers    ${RESPONSE.json()["TotalPayment"]}       ${list_order.json()["Data"][0]["TotalPayment"]}
    # Kiểm tra hàng hóa trong đơn
    ${length}=    Get Length    ${RESPONSE.json()["OrderDetails"]}
    FOR    ${index}    IN RANGE    0    ${length}    
        Log    ${index}
        Should Be Equal As Numbers    ${RESPONSE.json()["OrderDetails"][${index}]["ProductId"]}       ${list_order.json()["Data"][0]["OrderDetails"][${index}]["ProductId"]}
    END

    