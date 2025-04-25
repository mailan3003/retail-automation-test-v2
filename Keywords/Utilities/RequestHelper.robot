*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    Utilities.robot

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

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
