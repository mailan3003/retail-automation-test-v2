*** Settings ***
Documentation     Test cases API cho phần tạo phiếu thu khi tạo hóa đơn
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../Keywords/Login/Login.robot
Library    Collections
Library    ../../Resources/DatabaseLibrary.py
Resource    ../../TestData/LanTest/Branch_data.robot

Resource    ../Utilities/Utilities.robot
Resource    ../Utilities/DataUtilities.robot


*** Keywords ***
Chuẩn bị dữ liệu tạo chi nhánh
    [Arguments]    ${branch_name}=${CREATE_BRANCH_NAME}
    Set To Dictionary    ${BRANCH_BODY}    Name=${branch_name}
    Set Test Variable    ${REQUEST_DATA}    ${BRANCH}
    RETURN    ${BRANCH}

Chuẩn bị dữ liệu tạo chi nhánh với tên đã tồn tại
    [Arguments]    ${branch_name}=${INVALID_BRANCH_NAME}   
    ${body}=    Copy Dictionary    ${BRANCH_BODY} 
    Set To Dictionary    ${body}    Name=${branch_name}
    ${branch}=    Update Dictionary Property    ${BRANCH}    Branch    ${body}
    Set Test Variable    ${REQUEST_DATA}    ${branch}
    RETURN    ${branch}

Chuẩn bị dữ liệu tạo chi nhánh với trường tên rỗng
    [Arguments]    ${branch_name}=${EMPTY}
    ${body}=    Copy Dictionary    ${BRANCH_BODY} 
    Set To Dictionary    ${body}    Name=${branch_name}
    ${branch}=    Update Dictionary Property    ${BRANCH}    Branch    ${body}
    Set Test Variable    ${REQUEST_DATA}    ${branch}
    RETURN    ${branch}

Chuẩn bị dữ liệu tạo chi nhánh với trường sđt rỗng
    [Arguments]    ${contact_phone}=${EMPTY}
    ${body}=    Copy Dictionary    ${BRANCH_BODY} 
    Set To Dictionary    ${body}    ContactNumber=${contact_phone}
    ${branch}=    Copy Dictionary    ${BRANCH}
    Update Dictionary Property    ${branch}    Branch    ${body}
    Set Test Variable    ${REQUEST_DATA}    ${branch}
    RETURN    ${branch}
Chuẩn bị dữ liệu tạo chi nhánh với field lỗi
    [Arguments]    ${field_name}    ${field_value} 
    ${body}=    Copy Dictionary    ${BRANCH_BODY}
    Set To Dictionary    ${body}    ${field_name}=${field_value}
    ${branch}=    Copy Dictionary    ${BRANCH}
    Update Dictionary Property    ${branch}    Branch    ${body}
    Set Test Variable    ${REQUEST_DATA}    ${branch}
    RETURN    ${branch}

Chuẩn bị dữ liệu chi nhánh
    [Arguments]    ${branch_id}    ${limit_access}
    ${request}=    Copy Dictionary    ${Branch_Active}
    Set To Dictionary    ${request}    Id=${branch_id}
    Set To Dictionary    ${request}    LimitAccess=${limit_access}
    ${request_active}=    Copy Dictionary    ${Branchs_Active}
    Update Dictionary Property    ${request_active}    Branch    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request_active}
    RETURN    ${request_active}


Gửi yêu cầu chuyển trạng thái chi nhánh
    ${response}=    Call API    branchs/active    ${REQUEST_DATA}    ${AUTH_TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

Gửi yêu cầu tạo chi nhánh
    ${response}=    Call API    branchs    ${REQUEST_DATA}    ${AUTH_TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}
    ${branch_id}=    Set Variable If    ${RESPONSE.status_code}==200    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${BRANCH_ID}    ${branch_id}
    RETURN    ${branch_id}

Chuyển trạng thái hoạt động thành công
    [Arguments]    ${branch_id}    ${limit_access}
    ${query}=    Set Variable    SELECT LimitAccess FROM Branch WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${branch_id}
    ${limit_access}=    Convert To Integer    ${limit_access}
    ${result[0]}=    Convert To Integer    ${result[0]}
    Should Be Equal As Strings    ${result[0]}    ${limit_access}

Trả lại trạng thái chi nhánh ban đầu
    [Arguments]    ${branch_id}    ${limit_access}
    ${query}=    Set Variable    UPDATE Branch SET LimitAccess = ? WHERE Id = ?
    Execute Query    ${query}    ${limit_access}    ${branch_id}

Trong db tồn tại chi nhánh với tên vừa tạo
    ${query}=    Set Variable    SELECT Name FROM Branch WHERE Id = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${BRANCH_ID}    ${RETAILER_ID}
    Should Be Equal As Strings    ${result[0]}    ${CREATE_BRANCH_NAME}    Tên chi nhánh không khớp

Kiểm tra message lỗi
    [Arguments]    ${error_message}
    Should Be Equal As Strings    ${RESPONSE.json()["ResponseStatus"]["Message"]}    ${error_message}


Xóa chi nhánh vừa tạo
    # Delete Data    branchs?Id=${BRANCH_ID}&CompareBranchName=${CREATE_BRANCH_NAME}
    ${query}=    Set Variable    DELETE FROM Branch WHERE Id = ${BRANCH_ID}
    Execute Query    ${query}