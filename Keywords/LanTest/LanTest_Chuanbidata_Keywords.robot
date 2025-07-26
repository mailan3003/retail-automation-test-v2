*** Settings ***
Resource    ../../TestData/LanTest/Lan_testdata.robot
Library    ../../Resources/DatabaseLibrary.py
Library           BuiltIn
Library           Collections
Library           DateTime
Library           json
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/DataUtilities.robot





Library    Collections

*** Variables ***


*** Keywords ***
Chuẩn bị dữ liệu khách hàng với tên ${name} Số điện thoại ${phone} email ${email} facebook ${facebook}
    ${request}=    Deep Copy     ${STANDARD_CUSTOMER_REQUEST}
    Set To Dictionary    ${request["Customer"]}    Name=${name}    ContactNumber=${phone}    Email=${email}    Facebook=${facebook}
    Log    ${request}    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
