*** Settings ***
Resource    ../Env_live.robot
Resource    ../../Keywords/Utilities/DataUtilities.robot

Library    RequestsLibrary

*** Variables ***
${ENDPOINT_PRODUCT}    branchs/{0}/masterproducts?format=json&Includes=ProductAttributes&ForSummaryRow=true
${ENDPOINT_DELETE}    products/{0}
${AUTH}

*** Keywords ***
Chuẩn bị dữ liệu đăng nhập vào gian hàng
    ${headers}=    Deep Copy    ${HEADERS}
    ${model}=    Deep Copy    ${MODEL}
    ${body}=    Create Dictionary
    Update Dictionary Property    ${body}    Model    ${model}
    Update Dictionary Property    ${body}    IsManageSide    ${IsManageSide}
    Update Dictionary Property    ${body}    $FingerPrintKey    ${FingerPrintKey}
    Set Suite Variable    ${REQUEST_DATA}    ${body}
    RETURN    ${body}


Gửi yêu cầu đăng nhập
    Create Session    login    ${URL}    headers=${HEADERS}
    ${response}=    Post On Session    login    ${URL}${ENDPOINT}    headers=${HEADERS}    json=${REQUEST_DATA}
    Set Suite Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Xác nhận trả về token
    ${token}=    Get From Dictionary    ${RESPONSE.json()}    token
    Should Not Be Empty    ${token}
    ${auth}=    Set Variable    Bearer ${token}
    # Set Test Variable    ${AUTH}    ${auth}
    RETURN    ${auth}

Get token
    ${body}=    Chuẩn bị dữ liệu đăng nhập vào gian hàng
    ${response}=    Gửi yêu cầu đăng nhập
    ${auth}=    Xác nhận trả về token
    Set Suite Variable    ${AUTH}    ${auth}
    RETURN    ${auth}

Lay thong tin hang hoa
    ${endpoint_product}     Format String    ${ENDPOINT_PRODUCT}    ${DEFAULT_BRANCH_ID}
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=${RETAILER}     Authorization=${AUTH}   BranchId=${DEFAULT_BRANCH_ID}
    Create Session    get    ${URL}    headers=${headers}
    ${response}=    GET On Session    get    ${URL}${endpoint_product}    headers=${headers}
    ${PRODUCT_ID}=    Set Variable    ${response.json()}[Data][1][ProductId]
    Set Test Variable    ${PRODUCT_ID}    ${PRODUCT_ID}
    [Return]    ${PRODUCT_ID}    

Xoa hang hoa
    ${ENDPOINT_DELETE}   Format String    ${ENDPOINT_DELETE}    ${PRODUCT_ID}
    ${headers}=    Create Dictionary    Content-Type=application/json     Retailer=${RETAILER}     Authorization=${AUTH}   BranchId=${DEFAULT_BRANCH_ID}
    Create Session    delete    ${URL}    headers=${headers}
    ${response}=    Delete On Session    delete    ${URL}${ENDPOINT_DELETE}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200