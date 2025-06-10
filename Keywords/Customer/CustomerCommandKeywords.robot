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
