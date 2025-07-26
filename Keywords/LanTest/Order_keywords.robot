*** Settings ***
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../Keywords/Login/Login.robot
Library        RequestsLibrary
Resource    ../../Keywords/Utilities/RequestHelper.robot
Resource    ../../Keywords/Utilities/ResponseHelper.robot
Resource    ../Utilities/DataUtilities.robot
Library    ../../Resources/DatabaseLibrary.py

*** Variables ***
${API_URL}      https://api-sale.kvpos.com:8443/api
${SESSION_ALIAS}    kvsession

*** Keywords ***

Chuẩn bị dữ liệu đơn hàng
    [Arguments]    ${branch_id}=${DEFAULT_BRANCH_ID}    ${retailer_id}=${NONE}    ${customer_id}=${NONE}    ${user_id}=${DEFAULT_USER_ID}    ${product_id}=${DEFAULT_PRODUCT_ID}    ${price}=6300000    ${quantity}=1
    ${retailer_id}=    Set Variable If
    ...    '${retailer_id}'=='${NONE}' or '${retailer_id}'=='' or '${retailer_id}'=='None'
    ...    ${DEFAULT_RETAILER_ID}
    ...    ${retailer_id}
    ${customer_id}=    Set Variable If
    ...    '${customer_id}'=='${NONE}' or '${customer_id}'=='' or '${customer_id}'=='None'
    ...    ${DEFAULT_CUSTOMER_ID}
    ...    ${customer_id}
    &{sold_by}=    Create Dictionary    Id=${user_id}
    &{seller}=     Create Dictionary    Id=${user_id}
    &{order_detail}=    Create Dictionary    Price=${price}    ProductId=${product_id}    Quantity=${quantity}
    @{order_details}=    Create List    ${order_detail}
    &{orders}=    Create Dictionary
    ...    BranchId=${branch_id}
    ...    RetailerId=${retailer_id}
    ...    CustomerId=${customer_id}
    ...    SoldById=${user_id}
    ...    SoldBy=${sold_by}
    ...    Seller=${seller}
    ...    OrderDetails=${order_details}
    ...    Status=1
    &{request}=    Create Dictionary    Order=${orders}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Gửi yêu cầu tạo đơn hàng
    [Arguments]    ${branch_id}=${DEFAULT_BRANCH_ID}    ${retailer_code}=${RETAILER_CODE}    ${cookie}=ss-id=abc; ss-pid=xyz
    # Set Environment Variable    HTTP_PROXY    http://127.0.0.1:8888
    # Set Environment Variable    HTTPS_PROXY    http://127.0.0.1:8888

    Create Session    ${SESSION_ALIAS}    ${API_URL}    verify=True

    ${headers}=    Create Dictionary
    ...    accept=application/json, text/plain, */*
    ...    authorization=Bearer ${AUTH_TOKEN}
    ...    branchid=${branch_id}
    ...    content-type=application/json;charset=utf-8
    ...    origin=https://testsb.kvpos.com:8443
    ...    referer=https://testsb.kvpos.com:8443/
    ...    retailer=${retailer_code}
    ...    Cookie=${cookie}

    ${response}=    POST On Session    ${SESSION_ALIAS}    orders    json=${REQUEST_DATA}    headers=${headers}
    Log    Response: ${response.status_code}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}



Kiểm tra đơn hàng đã tạo thành công
    [Documentation]    Kiểm tra đơn hàng đã tạo thành công với code trả về và query trong db trùng khớp
    ${order_code}=    Set Variable    ${RESPONSE.json()["Code"]}
    ${query}=    Set Variable    SELECT Code FROM [Order] WHERE RetailerId = ? AND Id = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${RESPONSE.json()["Id"]}
    Should Not Be Empty    ${result[0]}
    Should Be Equal As Strings    ${result[0]}    ${order_code}


Kiểm tra hàng hóa trong chi tiết đơn đặt hàng
    [Documentation]    Kiểm tra hàng hóa trong chi tiết đơn đặt hàng với code trả về và query trong db trùng khớp
    ${product_id}=    Set Variable    ${RESPONSE.json()["OrderDetails"][0]["ProductId"]}
    ${query}=    Set Variable    SELECT ProductId from OrderDetail WHERE RetailerId = ? AND OrderId = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${RESPONSE.json()["Id"]}
    Should Be Equal As Numbers    ${result[0]}    ${product_id}    Hang hoa khong khop

Kiểm tra khách hàng trong chi tiết đơn đặt hàng
    [Documentation]    Kiểm tra khách hàng trong chi tiết đơn đặt hàng với code trả về và query trong db trùng khớp
    ${customer_id}=    Set Variable    ${RESPONSE.json()["Customer"]["Id"]}
    ${query}=    Set Variable    SELECT CustomerId from [Order] WHERE RetailerId = ? AND Id = ?
    ${result}=    Fetch One    ${query}    ${RETAILER_ID}    ${RESPONSE.json()["Id"]}
    Should Be Equal As Numbers    ${result[0]}    ${customer_id}    Khach hang khong khop

Xóa đơn hàng sau khi kiểm tra
    [Documentation]    Xóa đơn hàng sau khi kiểm tra
    # ${query}=    Set Variable    DELETE FROM [Order] WHERE RetailerId = ? AND Id = ?
    # Execute Query    ${query}    ${RETAILER_ID}    ${RESPONSE.json()["Id"]}
    Delete Data    orders/${RESPONSE.json()["Id"]}?IsVoidPayment=false&CompareCode=${RESPONSE.json()["Code"]}