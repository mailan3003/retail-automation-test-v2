*** Settings ***
Documentation    Tạo hàng hóa
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    ../../Resources/DatabaseLibrary.py
Library    String
*** Variables ***
${URL}    https://api-man1.kiotviet.vn/api/
${ENDPOINT}    account/login
${ENDPOINT_PRODUCT}    branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true
${ENDPOINT_DELETE}    products/{0}
${ENDPOINT_CUSTOMER_CREATE}    customers
${BRANCH_ID}    152624
${RETAILER_ID}    366523
${GET_CUSTOMER_INFO_ENDPOINT}   customers?format=json&UsingStoreProcedure=false&FindString={0}
*** Test Cases ***
Lấy thông tin hàng hóa
    Given Đăng Nhập Gian Hàng    auto3    Admin      Kiotviet12345678
    When Get Thông Tin Hàng Hóa 
    Then Delete hàng hóa

Tạo Khách Hàng
    Given Đăng Nhập Gian Hàng    auto3    Admin      Kiotviet12345678
    When Tạo Khách Hàng
    And Lấy thông tin khách hàng   ${CUSTOMER_CODE}
    Then Verify Thông Tin Khách Hàng
    # Then Verify Thông Tin Hàng Hóa
    # [Teardown]    Delete hàng hóa

*** Keywords ***
Đăng Nhập Gian Hàng
    [Arguments]    ${retailer}   ${username}    ${password}  
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=${retailer}
    ${model}=  Create Dictionary    UserName=${username}    Password=${password}    Captcha=false    RememberMe=true    ShowCaptcha=false    LatestBranchId=${BRANCH_ID}
    ${body}=    Create Dictionary    Model=${model}
    Create Session    login    ${URL}    headers=${headers}
    ${response}=    Post On Session    login    ${URL}${ENDPOINT}    headers=${headers}    json=${body}
    Log    ${response.json()}
    ${AUTH_TOKEN}     Set Variable    ${response.json()}[token]
    Set Test Variable    ${AUTH_TOKEN}    ${AUTH_TOKEN}
    [Return]    ${AUTH_TOKEN}


Get Thông Tin Hàng Hóa  
    ${ABC}   Format String    ${ENDPOINT_PRODUCT}    ${BRANCH_ID}     
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=auto3     Authorization=Bearer ${AUTH_TOKEN}   BranchId=${BRANCH_ID}
    Create Session    get    ${URL}    headers=${headers}
    ${response}=    Get On Session    get    ${URL}${ABC}    headers=${headers}
    Log    ${response.json()}
    ${PRODUCT_ID}=    Set Variable    ${response.json()}[Data][1][ProductId]
    Log    ${PRODUCT_ID}
    Set Test Variable    ${PRODUCT_ID}    ${PRODUCT_ID}
    [Return]    ${PRODUCT_ID}


Delete hàng hóa
    ${ENDPOINT_DELETE}   Format String    ${ENDPOINT_DELETE}    ${PRODUCT_ID}
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=auto3     Authorization=Bearer ${AUTH_TOKEN}   BranchId=${BRANCH_ID}
    Create Session    delete    ${URL}    headers=${headers}
    ${response}=    Delete On Session    delete    ${URL}${ENDPOINT_DELETE}    headers=${headers}
    Log    ${response.json()}
    Log    ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    200


Tạo Khách Hàng 
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=auto3     Authorization=Bearer ${AUTH_TOKEN}   BranchId=${BRANCH_ID}
    Create Session    create    ${URL}    headers=${headers}
    ${Customer_body}=    Create Dictionary       BranchId=${BRANCH_ID}
    ...  Name=Tạo Khách Hàng
    ...  Code=
    ...  RetailerId=${RETAILER_ID}
    ${body}=    Create Dictionary    Customer=${Customer_body}      isMergedSupplier=false    isCreateNewSupplier=true    MergedSupplierId=0
    ${response}=    Post On Session    create    ${URL}${ENDPOINT_CUSTOMER_CREATE}    headers=${headers}   json=${body}
    Log    ${response.json()}
    Log    ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    200
    Set Test Variable    ${RESPONSE}    ${response.json()}
    ${CUSTOMER_CODE}=    Set Variable    ${RESPONSE}[Code]
    Log    ${CUSTOMER_CODE}
    Set Test Variable    ${CUSTOMER_CODE}    ${CUSTOMER_CODE}
    Set Test Variable    ${REQUEST_DATA}   ${body}
    [Return]    ${RESPONSE}


Lấy thông tin khách hàng
    [Arguments]    ${customer_code}
    ${endpoint}=    Format String    ${GET_CUSTOMER_INFO_ENDPOINT}    ${customer_code}
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=auto3     Authorization=Bearer ${AUTH_TOKEN}   BranchId=${BRANCH_ID}
    Create Session    create    ${URL}    headers=${headers}
    ${response}=    Get On Session    create    ${URL}${endpoint}    headers=${headers}
    Log    ${response.json()}
    Log    ${response.status_code}
    Should Be Equal As Strings    ${response.status_code}    200
    Set Test Variable    ${RESPONSE}    ${response.json()}
    ${CUSTOMER_NAME}=    Set Variable    ${RESPONSE}[Data][0][Name]
    
    ${customer_phone}=    Get Value From Json    ${RESPONSE}    $.Data[?(@.Code=='${customer_code}')].ContactNumber
    ${customer_subnumber}=    Get Value From Json    ${RESPONSE}    $.Data[?(@.Code=='${customer_code}')].SubNumber
    ${customer_identification}=    Get Value From Json    ${RESPONSE}    $.Data[?(@.Code=='${customer_code}')].IdentificationNumber
    ${customer_email}=    Get Value From Json    ${RESPONSE}    $.Data[?(@.Code=='${customer_code}')].Email
    RETURN    ${CUSTOMER_NAME}    ${customer_phone}    ${customer_subnumber}    ${customer_identification}    ${customer_email}

Verify Thông Tin Khách Hàng
    ${CUSTOMER_NAME}    ${customer_phone}    ${customer_subnumber}    ${customer_identification}    ${customer_email}=    Lấy thông tin khách hàng   ${CUSTOMER_CODE}
    Should Be Equal    ${CUSTOMER_NAME}    ${REQUEST_DATA}[Customer][Name]
    # Should Be Equal    ${customer_phone}    ${REQUEST_DATA}[Customer][ContactNumber]
    # Should Be Equal    ${customer_subnumber}    ${REQUEST_DATA}[Customer][SubNumber]
    # Should Be Equal    ${customer_identification}    ${REQUEST_DATA}[Customer][IdentificationNumber]
    # Should Be Equal    ${customer_email}    ${REQUEST_DATA}[Customer][Email]
   
