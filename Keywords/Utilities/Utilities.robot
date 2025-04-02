*** Settings ***
Resource        Env.robot 
Documentation     Utility keywords for API testing
Library           Collections
Library           String
Library           RequestsLibrary
Library           OperatingSystem
Library           json

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