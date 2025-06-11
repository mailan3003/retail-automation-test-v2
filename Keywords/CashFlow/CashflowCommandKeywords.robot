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


*** Keywords ***
Lấy Id bank account theo mã bank account
    [Arguments]    ${bank_account_code}
    ${sql_query}=    Set Variable    SELECT Id FROM BankAccount WHERE Account = ? AND RetailerId = ?
    ${bank_account_id}=    Fetch One    ${sql_query}    ${bank_account_code}    ${RETAILER_ID}
    Should Not Be Equal    ${bank_account_id}    ${None}    Tài khoản ngân hàng không tồn tại trong CSDL
    Set Test Variable    ${BANK_ACCOUNT_ID}    ${bank_account_id[0]}
    RETURN    ${BANK_ACCOUNT_ID}
