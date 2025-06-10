*** Settings ***
Resource          ../../Config/Env_${ENV}.robot
Resource          ../../TestData/CommonData.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Library           BuiltIn
Library           Collections
Library           DateTime
Library           ../../Resources/DatabaseLibrary.py
Library           json

*** Variables ***
${PRICEBOOK_ENDPOINT}    pricebooks

*** Keywords ***
Lấy Id Bảng Giá Theo Tên Bảng Giá
    [Arguments]    ${pricebook_name}
    ${query}=   Set Variable   SELECT Id FROM PriceBook WHERE Name = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${pricebook_name}    ${RETAILER_ID}
    RETURN    ${result[0]}