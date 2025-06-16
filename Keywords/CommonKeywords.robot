*** Settings ***
Resource          ../Config/Env_${ENV}.robot
Resource          ../TestData/CommonData.robot
Resource          Utilities/Utilities.robot
Resource          Utilities/DataUtilities.robot
Resource          Utilities/RequestHelper.robot
Resource          Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../Resources/DatabaseLibrary.py
Library           ../Resources/Databasepromotion.py
Library           json

*** Keywords ***
Lấy Id Kênh Bán Hàng Theo Tên ${channel_name}
    ${query}=   Set Variable   SELECT Id FROM SaleChannel WHERE Name = '${channel_name}' AND RetailerId = ${RETAILER_ID}
    ${result}=    Fetch One    ${query}
    Should Not Be Equal    ${result}    ${None}    Kênh bán không tồn tại trong CSDL
    Set Test Variable    ${CHANNEL_ID}    ${result[0]}
    Return From Keyword    ${CHANNEL_ID}


Lấy Thông tin Người Dùng Theo Tên
    [Arguments]    ${user_name}
    ${query}=   Set Variable   SELECT Id FROM [User] Where UserName=? AND RetailerId=?
    ${result}=    Fetch One    ${query}    ${user_name}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    ${None}    Người dùng không tồn tại trong CSDL
    ${user_id}=    Set Variable    ${result[0]}
    Return From Keyword    ${user_id}

Lấy Thông Tin Thu Khác Theo Code
    [Arguments]    ${code}
    ${query}=   Set Variable   SELECT Id,Value,ValueRatio FROM Surcharge Where Code=? AND RetailerId=?
    ${result}=    Fetch One    ${query}    ${code}    ${RETAILER_ID}
    Should Not Be Equal    ${result}    ${None}    Thu khác không tồn tại trong CSDL
    ${surcharge_id}=    Set Variable    ${result[0]}
    ${surcharge_value}=  Run Keyword If    '${result[1]}' == 'None'    Set Variable   0   ELSE    Convert To Number    ${result[1]}
    ${surcharge_value_ratio}=  Run Keyword If    '${result[2]}' == 'None'    Set Variable   0   ELSE    Convert To Number    ${result[2]}
    Return From Keyword    ${surcharge_id}    ${surcharge_value}    ${surcharge_value_ratio}




