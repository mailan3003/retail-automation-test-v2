*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
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
${CUSTOMER_ENDPOINT}    customers

*** Keywords ***
Lấy Id Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${sql_query}=    Set Variable    SELECT Id FROM Customer WHERE Code = ? AND RetailerId = ?
    ${customer_id}=    Fetch One    ${sql_query}    ${customer_code}    ${RETAILER_ID}
    Should Not Be Equal    ${customer_id}    ${None}    Khách hàng không tồn tại trong CSDL
    Set Test Variable    ${CUSTOMER_ID}    ${customer_id[0]}
    RETURN    ${CUSTOMER_ID}


Lấy Công Nợ Của Khách Hàng
    [Arguments]    ${customer_code}
    ${sql_query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${sql_query}    ${customer_code}    ${RETAILER_ID}
    Should Not Be Equal    ${debt}    ${None}    Khách hàng không tồn tại trong CSDL
    Set Test Variable    ${DEBT_CUSTOMER}    ${debt[0]}
    RETURN   ${debt[0]}

Công Nợ Của Khách Hàng ${customer_code} Phải Là ${expected_debt}
    [Documentation]    Kiểm tra công nợ của khách hàng
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${query}    ${customer_code}    ${RETAILER_ID}
    Should Be Equal As Numbers    ${debt[0]}    ${expected_debt}    Công nợ của khách hàng không phải là ${expected_debt}


Công Nợ Của Khách Hàng ${customer_code} Sau Thanh Toán ${payment_amount}
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Code = ? AND RetailerId = ?
    ${debt}=    Fetch One    ${query}    ${customer_code}    ${RETAILER_ID}
    ${debt_after_payment}=    Evaluate   ${DEBT_CUSTOMER} - ${payment_amount}
    Should Be Equal As Numbers    ${debt_after_payment}    ${debt[0]}    Công nợ của khách hàng không phải là ${DEBT_CUSTOMER}

Điểm Của Khách Hàng ${customer_code} Giảm ${reward_point} Sau Khi Thực Hiện Giao Dịch ${document_id}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    ${query}=    Set Variable    SELECT Value FROM PointTracking WHERE PartnerId = ? AND DocumentId = ?
    ${result}=    Fetch One    ${query}    ${customer_id}     ${document_id}
    Should Not Be Equal    ${result}    ${None}    Điểm khách hàng không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}  -${reward_point}   Điểm khách hàng không phải là ${result[0]}



