*** Settings ***
Resource        Env.robot 

*** Keywords ***
Should Have Nested Property
    [Arguments]    ${dictionary}    ${path}    ${expected_value}
    ${keys}=    Split String    ${path}    .
    ${actual_value}=    Set Variable    ${dictionary}

    FOR    ${key}    IN    @{keys}
        ${actual_value}=    Get From Dictionary    ${actual_value}    ${key}
    END

    Should Be Equal    ${actual_value}    ${expected_value}


Create Auth Headers
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${AUTH_TOKEN}
    ...    Content-Type=application/json
    ...    Retailer=${RETAILER_CODE}
    RETURN    ${headers}

Call API 
    [Arguments]    ${path}  ${json}  
    ${headers}=    Create Auth Headers
    ${response}=    POST    ${API_URL}/${path}    json=${json}    headers=${headers}
    Log    Response: ${response}
    RETURN    ${response}