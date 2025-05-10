*** Settings ***
Documentation     Utility keywords for API testing
Library           Collections
Library           String
Library           RequestsLibrary
Library           OperatingSystem
#Resource          ../../Config/Env.robot
#Resource          ../../Config/Env_currency.robot
#Resource          ../../Config/Env_nhathuoc.robot
Resource          ../../Config/Env_${ENV}.robot
#Resource          ../../Config/Env_vlxd.robot
*** Keywords ***
Create Auth Headers
    [Arguments]    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json      Retailer=${RETAILER_CODE}     
    RETURN    ${headers}

Create Auth Headers With File
    [Arguments]    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/x-www-form-urlencoded      Retailer=${RETAILER_CODE}     BranchId=${BRANCH_ID}
    RETURN    ${headers}

Create Auth Headers With BranchId
    [Arguments]    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}    Content-Type=application/json      Retailer=${RETAILER_CODE}    BranchId=${BRANCH_ID}
    RETURN    ${headers}

Call API
    [Arguments]    ${endpoint}    ${data}    ${token}=${AUTH_TOKEN}    ${method}=POST
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    POST    ${API_URL}${endpoint}    headers=${headers}    json=${data}
    RETURN    ${response}

Call API With Form Data
    [Arguments]    ${endpoint}    ${data}    ${token}=${AUTH_TOKEN}    ${method}=POST
    ${headers}=    Create Auth Headers With File    ${token}
    ${response}=    POST With File   ${API_URL}${endpoint}    headers=${headers}    data=${data}
    RETURN    ${response}

Call API Man
    [Arguments]    ${endpoint}    ${data}    ${token}=${AUTH_TOKEN}    ${method}=POST
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    POST    ${API_MAN_URL}${endpoint}    headers=${headers}    json=${data}
    RETURN    ${response}

Call API With BranchId
    [Arguments]    ${endpoint}    ${data}    ${token}=${AUTH_TOKEN}    ${method}=POST
    ${headers}=    Create Auth Headers With BranchId    ${token}
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

Should Contain Nested Property
    [Arguments]    ${data}    ${property_path}    ${expected_value}=${None}
    @{parts}=    Split String    ${property_path}    .
    ${current}=    Set Variable    ${data}
    FOR    ${part}    IN    @{parts}
        ${current}=    Get From Dictionary    ${current}    ${part}
    END
    Run Keyword If    '${expected_value}' != '${None}'    Should Contain    ${current}    ${expected_value}
    RETURN    ${current}


Delete Data
    [Arguments]    ${endpoint}    ${token}=${AUTH_TOKEN}
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    DELETE    ${API_URL}${endpoint}    headers=${headers}    
    RETURN    ${response}