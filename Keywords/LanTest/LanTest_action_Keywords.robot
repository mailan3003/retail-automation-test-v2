

*** Settings ***
Resource    ../../Config/Env_${ENV}.robot
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../TestData/LanTest/Lan_testdata.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           json
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/Utilities.robot
Library           JSONLibrary

*** Variables ***
${Customer_Endpoint}    customers
${Get_Customer_Info_Endpoint}   api/customers?format=json&UsingStoreProcedure=false&FindString={0}


*** Keywords ***
Gửi yêu cầu tạo mới khách hàng
    ${response}=     Call API Man With BranchId    ${Customer_Endpoint}    ${REQUEST_DATA}
    Run Keyword If    ${response.status_code} == 200    Set Test Variable    ${Customer_Id}    ${response.json()["Id"]}
    Log    Customer_Id: ${Customer_Id}
    Log    hihihi
    Run Keyword If    ${response.status_code} == 200    Set Test Variable    ${Customer_Code}    ${response.json()["Code"]}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}


Gửi Yêu Cầu Get Thông Tin Khách Hàng
    [Arguments]    ${customer_code}
    ${endpoint}=    Format String    ${Get_Customer_Info_Endpoint}    ${customer_code}
    ${response}=    Get Data From API    ${endpoint}  
    RETURN    ${response}

Lấy Thông tin KYC Của Khách Hàng Theo Mã Khách Hàng
    [Arguments]    ${customer_code}
    ${response}=    Gửi Yêu Cầu Get Thông Tin Khách Hàng    ${customer_code}
    ${customer_phone}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].ContactNumber
    ${customer_email}=    Get Value From Json    ${response.json()}    $.Data[?(@.Code=='${customer_code}')].Email
    ${customer_phone}=    Set Variable If    ${customer_phone} == []    0    ${customer_phone}[0]
    ${customer_email}=    Set Variable If    ${customer_email} == []    0    ${customer_email}[0]
    RETURN    ${customer_phone}    ${customer_email}


Xác Thực Khách Hàng Có SDT ${sdt} Email ${email}
    ${customer_phone}    ${customer_email}=    Lấy Thông tin KYC Của Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    Should Be Equal    ${customer_phone}    ${sdt}
    Should Be Equal    ${customer_email}    ${email}

Xác thực thông tin khách hàng đã được tạo với tên ${name} facebook ${facebook}
    ${query}=    Set Variable    SELECT Name, Facebook FROM Customer WHERE Id = ? AND RetailerId = ?
    Log    Customer_Id: ${Customer_Id}
    ${result}=    Fetch One    ${query}    ${Customer_Id}    ${RETAILER_ID}
    Log Many    Response tra ve: ${result[0]}    ${result[1]}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khách hàng
    Should Be Equal    ${result[0]}    ${name}    Tên khách hàng không khớp
    Should Be Equal    ${result[1]}    ${facebook}    Facebook không khớp

Xóa khách hàng được tạo từ API
    ${endpoint}=     Set Variable    ${Customer_Endpoint}/${Customer_Id}
    ${response}=     Delete Data    ${endpoint}
    RETURN     ${response}

