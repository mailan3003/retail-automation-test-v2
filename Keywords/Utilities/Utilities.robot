*** Settings ***
Documentation     Utility keywords for API testing
Library           Collections
Library           String
Library           RequestsLibrary
Library           OperatingSystem
#Resource          ../../Config/Env.robot
#Resource          ../../Config/Env_currency.robot
#Resource          ../../Config/Env_nhathuoc.robot
Resource          ../../Config/Env_dakho.robot
#Resource          ../../Config/Env_vlxd.robot
*** Keywords ***
Create Auth Headers
    [Arguments]    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json      Retailer=${RETAILER_CODE}
    RETURN    ${headers}

Call API
    [Arguments]    ${endpoint}    ${data}    ${token}=${AUTH_TOKEN}    ${method}=POST
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    POST    ${API_URL}${endpoint}    headers=${headers}    json=${data}
    RETURN    ${response}

Should Have Nested Property
    [Arguments]    ${data}    ${property_path}    ${expected_value}=${None}
    @{parts}=    Split String    ${property_path}    .
    ${current}=    Set Variable    ${data}
    FOR    ${part}    IN    @{parts}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    Run Keyword If    '${expected_value}' != '${None}'    Should Be Equal    ${current}    ${expected_value}
    RETURN    ${current}

Delete Data
    [Arguments]    ${endpoint}    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    DELETE    ${API_URL}${endpoint}    headers=${headers}    
    RETURN    ${response}