*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Supplier/SupplierCommonData.robot
Resource          SupplierCommonKeywords.robot
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
${GET_SUPPLIER_INFO_ENDPOINT}   suppliers?format=json&%24inlinecount=allpages&FindString={0}

*** Keywords ***
Gửi Yêu Cầu Get Thông Tin Nhà Cung Cấp
    [Arguments]    ${supplier_code}
    ${endpoint}=    Format String    ${GET_SUPPLIER_INFO_ENDPOINT}    ${supplier_code}
    ${response}=    Call API Man With BranchId    ${endpoint}    ${None}    ${AUTH_TOKEN}      GET   
    RETURN    ${response}

Lấy Số Điện Thoại Nhà Cung Cấp Theo Mã Nhà Cung Cấp
    [Arguments]    ${supplier_code}
    ${response}=    Gửi Yêu Cầu Get Thông Tin Nhà Cung Cấp    ${supplier_code}
    ${supplier_phone}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${supplier_code}')].Phone
    RETURN    ${supplier_phone}
