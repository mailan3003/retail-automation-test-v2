*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
POST
    [Arguments]    ${url}    ${json}=${None}    ${headers}=${None}
    ${headers}=    Run Keyword If    ${headers} == ${None}    Create Dictionary    Content-Type=application/json
    ...    ELSE    Set Variable    ${headers}
    
    Create Session    kvpos    ${url}    verify=True
    ${response}=    RequestsLibrary.POST On Session    kvpos    ${url}    json=${json}    headers=${headers}    expected_status=anything
    RETURN    ${response}

Delete
    [Arguments]    ${url}    ${headers}=${None}
    ${headers}=    Run Keyword If    ${headers} == ${None}    Create Dictionary    Content-Type=application/json
    ...    ELSE    Set Variable    ${headers}
    Create Session    kvpos    ${url}    verify=True
    ${response}=    RequestsLibrary.DELETE On Session    kvpos    ${url}    headers=${headers}    expected_status=anything
    RETURN    ${response}