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
${GET_CUSTOMER_INFO_ENDPOINT}   api/customers?format=json&UsingStoreProcedure=false&FindString={0}

*** Keywords ***
Gửi Yêu Cầu Get Thông Tin Khách Hàng
    [Arguments]    ${customer_code}
    ${endpoint}=    Format String    ${GET_CUSTOMER_INFO_ENDPOINT}    ${customer_code}
    ${response}=    Get Data From API    ${endpoint}  
    RETURN    ${response}

Lấy Thông tin KYC Của Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${response}=    Gửi Yêu Cầu Get Thông Tin Khách Hàng    ${customer_code}
    ${customer_phone}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].ContactNumber
    ${customer_subnumber}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].SubNumber
    ${customer_identification}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].IdentificationNumber
    ${customer_email}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].Email
    ${customer_phone}=    Set Variable If    ${customer_phone} == []    0    ${customer_phone}[0]
    ${customer_subnumber}=    Set Variable If    ${customer_subnumber} == []    0    ${customer_subnumber}[0]  
    ${customer_identification}=    Set Variable If    ${customer_identification} == []    0    ${customer_identification}[0]
    ${customer_email}=    Set Variable If    ${customer_email} == []    0    ${customer_email}[0]
    RETURN    ${customer_phone}    ${customer_subnumber}    ${customer_identification}    ${customer_email}

Lấy Thông tin Địa Chỉ Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${response}=    Gửi Yêu Cầu Get Thông Tin Khách Hàng    ${customer_code}
    ${customer_address}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].Address
    ${customer_address_location}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].LocationId
    ${customer_address_ward}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].WardId
    ${customer_address}=    Set Variable If    ${customer_address} == []    ${EMPTY}    ${customer_address}[0]
    ${customer_address_location}=    Set Variable If    ${customer_address_location} == []    ${EMPTY}    ${customer_address_location}[0]
    ${customer_address_ward}=    Set Variable If    ${customer_address_ward} == []    ${EMPTY}    ${customer_address_ward}[0]
    RETURN    ${customer_address}    ${customer_address_location}    ${customer_address_ward}


Xác Thực Khách Hàng Có SDT1 ${sdt1} SDT2 ${sdt2} Cùng CMTND ${cmtnd} Và Email ${email}
    ${customer_phone}    ${customer_subnumber}    ${customer_identification}    ${customer_email}=    Lấy Thông tin KYC Của Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    Should Be Equal    ${customer_phone}    ${sdt1}
    Should Be Equal    ${customer_subnumber}    ${sdt2}
    Should Be Equal    ${customer_identification}    ${cmtnd}
    Should Be Equal    ${customer_email}    ${email}

Xác Thực Khách Hàng Có Địa Chỉ ${address} Tỉnh Thành Phố ${province_id} Phường/Xã ${ward_id}
    ${province_id}       Convert To Number   ${province_id}
    ${ward_id}       Convert To Number    ${ward_id}
    ${customer_address}    ${customer_address_location}    ${customer_address_ward}=    Lấy Thông tin Địa Chỉ Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    Should Be Equal    ${customer_address}    ${address}
    Should Be Equal    ${customer_address_location}    ${province_id}
    Should Be Equal    ${customer_address_ward}    ${ward_id}





