*** Settings ***
Library    Collections
Library    String

*** Keywords ***
Status Should Be
    [Arguments]    ${expected_status}    ${response}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

Response Should Contain
    [Arguments]    ${response}    ${expected_text}
    Should Contain    ${response.text}    ${expected_text}

# above are deprecated


Response Status Code Should Be ${expected_status_code}
    Status Should Be    ${expected_status_code}    ${RESPONSE}

Response Should Have Error ${expected_error}        
    Log     ${RESPONSE.json()}    
    ${cleaned_error}=    Replace String    ${expected_error}    "    ${EMPTY}
    Should Have Nested Property     ${RESPONSE.json()}  ResponseStatus.Message  ${cleaned_error}


Response Should Have ${path} With value ${expected_value}    
    ${keys}=    Split String    ${path}    .
    ${actual_value}=    Set Variable    ${RESPONSE.json()}

    FOR    ${key}    IN    @{keys}
        ${actual_value}=    Get From Dictionary    ${actual_value}    ${key}
    END

    Should Be Equal    ${actual_value}    ${expected_value}


Response Should Have ${path} exist
    ${keys}=    Split String    ${path}    .
    ${current}=    Set Variable    ${RESPONSE.json()}
    FOR    ${key}    IN    @{keys}
        ${current}=    Evaluate    ${current}.get("${key}", None) if isinstance(${current}, dict) else None
        Run Keyword If    '${current}' == 'None'    Fail    Key '${path}' not found in dictionary
    END