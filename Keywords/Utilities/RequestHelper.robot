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


Post request from data  
    [Arguments]    ${url}    ${payload}   
    ${headers}=    Create Dictionary     Authorization=Bearer ${AUTH_TOKEN}    Content-Type=multipart/form-data    Retailer=${RETAILER_CODE}      BranchId=${BRANCH_ID}
    Create Session     lolo     ${API_MAN_URL}   verify=True
    ${response}=    POST On Session   lolo    ${API_MAN_URL}${url}        files=${payload}      headers=${headers}     expected_status=anything
    RETURN    ${response}

POST Form Data
    [Arguments]    ${url}    ${data}=${None}    ${files}=${None}    ${headers}=${None}
    Create Session    kvpos    ${url}    verify=True
    IF    "${files}" == "${None}"
        ${response}=    POST On Session    kvpos    ${url}    data=${data}    headers=${headers}    expected_status=anything
    ELSE
        ${response}=    POST On Session    kvpos    ${url}    data=${data}    files=${files}    headers=${headers}    expected_status=anything
    END
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

Gửi Yêu Cầu Tạo Hóa Đơn Với BranchId
    ${response}=    Call API With BranchId   invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    

Gửi Yêu Cầu Cập Nhật Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử
    ${response}=    Call API With BranchId    e-invoice/publishEInvoice    ${E_INVOICE_REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    ${e_invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["invoice_ref_id"]}    0
    Set Test Variable    ${E_INVOICE_ID}    ${e_invoice_id}

Gửi Yêu Cầu Tạo Hóa Đơn Điện Tử Với Custom BranchId
    [Arguments]    ${branch_id}
    ${response}=    Call API With Custom BranchId    e-invoice/publishEInvoice    ${E_INVOICE_REQUEST_DATA}    ${branch_id}
    Set Test Variable    ${RESPONSE}    ${response}
    ${e_invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["invoice_ref_id"]}    0
    Set Test Variable    ${E_INVOICE_ID}    ${e_invoice_id}
    Set Test Variable    ${BRANCH_ID_USED}    ${branch_id}
    RETURN    ${response}

Gửi Yêu Cầu Tạo Hóa Đơn Với Custom BranchId
    [Arguments]    ${branch_id}
    ${response}=    Call API With Custom BranchId    invoices    ${REQUEST_DATA}    ${branch_id}
    Set Test Variable    ${RESPONSE}    ${response}
    ${invoice_id}=    Set Variable If    ${RESPONSE.status_code} == 200    ${RESPONSE.json()["Id"]}    0
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Set Test Variable    ${BRANCH_ID_USED}    ${branch_id}
    RETURN    ${response}

