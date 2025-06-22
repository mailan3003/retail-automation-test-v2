*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
Resource          CustomerCommonKeywords.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           JSONLibrary
*** Variables ***
${GET_CUSTOMER_INFO_ENDPOINT}   customers?format=json&%24inlinecount=allpages&FindString={0}

*** Keywords ***
Gửi Yêu Cầu Get Thông Tin Khách Hàng
    [Arguments]    ${customer_code}
    ${endpoint}=    Format String    ${GET_CUSTOMER_INFO_ENDPOINT}    ${customer_code}
    ${response}=    Call API Man With BranchId    ${endpoint}    ${None}    ${AUTH_TOKEN}      GET   
    RETURN    ${response}

Lấy Thông tin KYC Của Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${response}=    Gửi Yêu Cầu Get Thông Tin Khách Hàng    ${customer_code}
    ${customer_phone}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].ContactNumber
    ${customer_subnumber}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].SubNumber
    ${customer_identification}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].Identification
    RETURN    ${customer_phone}    ${customer_subnumber}    ${customer_identification}





