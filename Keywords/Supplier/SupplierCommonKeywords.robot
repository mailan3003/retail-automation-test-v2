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
${SUPPLIER_ENDPOINT}    suppliers

*** Keywords ***

Gửi Yêu Cầu Tạo Nhà Cung Cấp
    ${response}=    Call API Man    ${SUPPLIER_ENDPOINT}    ${REQUEST_DATA}    
    Set Test Variable    ${RESPONSE}    ${response}

Lấy Id Nhà Cung Cấp Theo Mã Nhà Cung Cấp
    [Arguments]    ${supplier_code}
    ${sql_query}=    Set Variable    SELECT Id FROM Supplier WHERE Code = ? AND RetailerId = ?
    ${supplier_id}=    Fetch One    ${sql_query}    ${supplier_code}    ${RETAILER_ID}
    Should Not Be Equal    ${supplier_id}    ${None}    Nhà cung cấp không tồn tại trong CSDL
    Set Test Variable    ${SUPPLIER_ID}    ${supplier_id[0]}
    RETURN    ${SUPPLIER_ID}