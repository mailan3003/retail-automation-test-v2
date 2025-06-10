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
Library           ../../Resources/Databasepromotion.py
Library           json

*** Variables ***
${CUSTOMER_ENDPOINT}    customers

*** Keywords ***
Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi
    [Arguments]    ${promotion_code}
    ${query}=    Set Variable    SELECT Id FROM Campaign WHERE Code = ? AND RetailerId = ?
    ${result}=    Select One Promotion    ${query}    ${promotion_code}    ${RETAILER_ID}
    RETURN    ${result}[0]


Lấy ID Khuyến Mãi Không Hoạt Động
    ${query}=    Set Variable    SELECT TOP 1 Id FROM Campaign WHERE Status = 0 AND RetailerId = ? AND IsActive = 0
    ${result}=    Select One Promotion    ${query}    ${RETAILER_ID}
    RETURN    ${result}[0]

Lấy ID Khuyến Mãi Hết Hạn
    ${query}=    Set Variable    SELECT TOP 1 Id FROM Campaign WHERE Status = 0 AND RetailerId = ? AND EndDate < ?
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${result}=    Select One Promotion    ${query}    ${RETAILER_ID}    ${current_date}
    RETURN    ${result}[0]

Lấy ID Khuyến Mãi Đã Bị Xóa
    ${query}=    Set Variable    SELECT TOP 1 Id FROM Campaign WHERE Status = 0 AND RetailerId = ? AND IsDeleted = 1
    ${result}=    Select One Promotion    ${query}    ${RETAILER_ID}
    RETURN    ${result}[0]

Thông Tin Khuyến Mãi Hóa Đơn
    [Arguments]    ${Id_promotion}
    ${query}=    Set Variable    SELECT Id, InvoiceValue, Discount, DiscountRatio FROM SalePromotion WHERE CampaignId = ?
    ${result}=    Select One Promotion    ${query}    ${Id_promotion}    
    RETURN    ${result}

Thông tin khuyến mãi hàng hóa
    [Arguments]    ${Id_promotion}
    ${query}=    Set Variable    SELECT Id, InvoiceValue, ProductDiscount, ProductDiscountRatio, PrereqQuantity,ProductPrice FROM SalePromotion WHERE CampaignId = ?
    ${result}=    Select One Promotion    ${query}    ${Id_promotion}   
    RETURN    ${result}

Thông Tin Khuyến Mãi Hóa Đơn Tặng 
    [Arguments]    ${Id_promotion}
    ${query}=    Set Variable    SELECT Id, InvoiceValue, ReceivedQuantity,PrereqQuantity,ReceivedVoucherCampaignIds,GiftPoint FROM SalePromotion WHERE CampaignId = ?
    ${result}=    Select One Promotion    ${query}    ${Id_promotion}
    RETURN    ${result}


    
