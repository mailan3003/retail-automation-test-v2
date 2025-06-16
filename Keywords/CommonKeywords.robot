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