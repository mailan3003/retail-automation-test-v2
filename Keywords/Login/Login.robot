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
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_NAME}       Branchid=${BRANCH_ID}
    Create Session    ali     ${SALE_API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    /auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    Log    ${bearertoken}
    ${bearertoken}=    Evaluate    ${bearertoken}[0] if ${bearertoken} else 0    modules=random, sys
    ${bearertoken}=    Catenate    Bearer    ${bearertoken}
    Log    ${bearertoken}
    Return From Keyword    ${bearertoken}    ${resp.cookies}

Get BearerToken by user
    [Arguments]    ${username}    ${password}
    ${credential}=    Create Dictionary    UserName=${username}    Password=${password}         FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}        Branchid=${BRANCH_ID}
    Create Session    ali     ${API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    /auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    ${bearertoken}=     set variable if   ${bearertoken}      ${bearertoken}[0]      0
    Set Test Variable    ${AUTH_TOKEN}    ${bearertoken}
    Return From Keyword    ${bearertoken}

Get BearerToken by user with branch_id
    [Arguments]    ${username}    ${password}   ${branch_id}
    ${credential}=    Create Dictionary    UserName=${username}    Password=${password}         FingerPrintKey=9260aa1de596f0d80658143cbe38c670_Chrome_Desktop_MÃ¡ytÃ­nh Windows
    ${headers1}=    Create Dictionary    Content-Type=application/json    Retailer=${RETAILER_CODE}        Branchid=${branch_id}
    Create Session    ali     ${API_URL}     headers=${headers1}    verify=True
    ${resp}=    Wait Until Keyword Succeeds    3x    0s   Post Request    ali    /auth/salelogin    data=${credential}
    Log    ${resp.json()}
    Should Be Equal As Strings    ${resp.status_code}    200
    Log    ${resp.cookies}
    ${bearertoken}    Get Value From Json    ${resp.json()}    $..BearerToken
    ${bearertoken}=     set variable if   ${bearertoken}      ${bearertoken}[0]      0
    Set Test Variable    ${AUTH_TOKEN}    ${bearertoken}
    Return From Keyword    ${bearertoken}
