*** Settings ***
Resource          ../Utilities/RequestHelper.robot
Resource          ../../Config/Env_${ENV}.robot
Library           StringFormat
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Library           JSONLibrary
*** Keywords ***
Get BearerToken from API
    [Timeout]    5 minutes
    # post to get bearer token
    ${credential}=    Create Dictionary    UserName=${USER_NAME}    Password=${PASSWORD}         FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}        Branchid=${DEFAULT_BRANCH_ID}
    Create Session    ali       ${API_URL}    headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    ${bearertoken}=     set variable if   ${bearertoken}      ${bearertoken}[0]      0
    Set Global Variable   ${AUTH_TOKEN}    ${bearertoken}
    Return From Keyword    ${AUTH_TOKEN} 

Get BearerToken by user
    [Arguments]    ${username}    ${password}
    ${credential}=    Create Dictionary    UserName=${username}    Password=${password}         FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}       Branchid=${DEFAULT_BRANCH_ID}
    Create Session    ali     ${API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    ${bearertoken}=     set variable if   ${bearertoken}      ${bearertoken}[0]      0
    Set Global Variable    ${AUTH_TOKEN}    ${bearertoken}
    Return From Keyword    ${bearertoken}

Get BearerToken MHQL
    ${model}=    Create Dictionary    RememberMe=${TRUE}    ShowCaptcha=${FALSE}    UserName=${USER_NAME}    Password=${PASSWORD}    Language=vi-VN    LatestBranchId=${DEFAULT_BRANCH_ID}
    ${credential}=    Create Dictionary    model=${model}    IsManageSide=${TRUE}    FingerPrintKey=4a8fafc3cfc372c6d68c09367d2a8b24_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}    Branchid=${DEFAULT_BRANCH_ID}
    Create Session    ali     ${API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali   account/login    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${AUTH_TOKEN}     Set Variable    ${resp.json()}[token]
    Return From Keyword    ${AUTH_TOKEN}


Init Test Environment
    [Arguments]    ${env}    ${role}
    ${bearer_token}=  Run Keyword If    "${role}" == "MHQL"    Get BearerToken MHQL    ELSE   Get BearerToken from API
    Set Global Variable    ${AUTH_TOKEN}    ${bearer_token}

Get BearerToken by user with branch_id
    [Arguments]    ${username}    ${password}   ${branch_id}
    ${credential}=    Create Dictionary    UserName=${username}    Password=${password}         FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}        Branchid=${branch_id}
    Create Session    ali     ${API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali   account/login    data=${credential}
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    /auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${AUTH_TOKEN}     Set Variable    ${resp.json()}[BearerToken]
    Return From Keyword    ${AUTH_TOKEN}




