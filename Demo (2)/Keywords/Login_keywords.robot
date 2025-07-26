*** Settings ***
Resource    ../Data/env_live.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot
Library    RequestsLibrary
Library    Collections

*** Keywords ***

Chuẩn bị dữ liệu gian hàng
    ${headers}=    Create Dictionary     
    ...    content-type=application/json;charset=utf-8
    ...    retailer=${RETAILER}
    ${body}=    Create Dictionary    
    ...    RememberMe=true
    ...    ShowCaptcha=false
    ...    UserName=${username}
    ...    Password=${password}
    ...    Language=vi-VN
    ${request}=    Create Dictionary
    Update Dictionary Property   ${request}    model    ${body}  
    Update Dictionary Property   ${request}    IsManageSide    true
    Update Dictionary Property   ${request}    FingerPrintKey    9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_Máy tính Windows 
    Set Test Variable    ${HEADERS_LOGIN}    ${headers}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${REQUEST_DATA}

Gửi yêu cầu đăng nhập
    Create Session    login    ${URL}    headers=${HEADERS_LOGIN}
    ${response}=    POST On Session    login    url=account/login?quan-ly=true    json=${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}    
    RETURN    ${RESPONSE}

Xác thực đăng nhập thành công
    Should Not Be Empty    ${RESPONSE.json()["token"]}
    ${auth}=    Set Variable    ${RESPONSE.json()["token"]}
    Set Global Variable    ${AUTH}    Bearer ${auth}

Tạo session
    [Arguments]    ${retailer}    ${username}    ${password}        
    # Chuẩn bị dữ liệu đăng nhập
    ${headers}=    Create Dictionary     
    ...    content-type=application/json;charset=utf-8
    ...    retailer=${RETAILER}
    ${body}=    Create Dictionary    
    ...    RememberMe=true
    ...    ShowCaptcha=false
    ...    UserName=${username}
    ...    Password=${password}
    ...    Language=vi-VN
    ...    LatestBranchId=30
    ${request}=    Create Dictionary
    Update Dictionary Property   ${request}    model    ${body}  
    Update Dictionary Property   ${request}    IsManageSide    true
    Update Dictionary Property   ${request}    FingerPrintKey    9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_Máy tính Windows 
    # Gửi yêu cầu đăng nhập
    Create Session    login    ${URL}    headers=${headers}
    ${response}=    POST On Session    login    url=account/login?quan-ly=true    json=${request}
    ${auth}=    Set Variable    ${response.json()["token"]}
    ${headers}=    Update Dictionary Property    ${headers}    Authorization    Bearer ${auth}
    ${headers}=    Update Dictionary Property    ${headers}    BranchId    ${DEFAULT_BRANCH_ID} 
    Create Session    session    ${URL}    ${headers}

    Set Global Variable    ${AUTH_TOKEN}    Bearer ${auth}
    Set Global Variable    ${HEADERS}       ${headers}