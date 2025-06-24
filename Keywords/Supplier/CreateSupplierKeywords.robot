*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Supplier/SupplierCommonData.robot
Resource          SupplierCommonKeywords.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Tạo Nhà Cung Cấp
    ${request}=    Deep Copy    ${STANDARD_SUPPLIER_REQUEST}
    ${sdt_random}=    Generate Random String    10    [NUMBERS]
    Set To Dictionary    ${request["Supplier"]}    Phone=${sdt_random}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}