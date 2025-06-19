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
Library           json
*** Keywords ***
Get Info Số Điện Thoại Khách Hàng Theo Từ API
    ${endpoint}=    Set Variable    ${CUSTOMER_ENDPOINT}/${CUSTOMER_ID}
    ${response}=    Call API Man    ${endpoint}    ${None}    ${AUTH_TOKEN}      GET   
    RETURN    ${response}



