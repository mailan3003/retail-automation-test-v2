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
${DELIVERY_ENDPOINT}    delivery

*** Keywords ***
Lấy Id Đối Tác Giao Hàng Theo Mã
    [Arguments]    ${delivery_code}
    ${sql_query}=    Set Variable    SELECT Id FROM PartnerDelivery WHERE Code = ? AND RetailerId = ?
    ${delivery_id}=    Fetch One    ${sql_query}    ${delivery_code}    ${RETAILER_ID}
    Should Not Be Equal    ${delivery_id}    ${None}    Đối tác giao hàng không tồn tại trong CSDL
    Set Test Variable    ${DELIVERY_ID}    ${delivery_id[0]}
    RETURN    ${DELIVERY_ID}