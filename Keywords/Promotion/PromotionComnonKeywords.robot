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


Lấy Thông Tin ID, PRICE Của Voucher Campaign
    [Arguments]    ${Voucher_campain}
    ${query_1}=    Set Variable    SELECT ID, Price FROM VoucherCampaign WHERE Code = ?
    ${result}=    Fetch One    ${query_1}    ${Voucher_campain}
    ${price}=    Convert To Number    ${result[1]}
    RETURN    ${result[0]}    ${price}


Lấy ID Mã Voucher ở Trạng Thái Đã Phát Hành
    [Arguments]    ${Voucher_campain}   
    ${query_2}=    Set Variable    SELECT top(1) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1 
    ${result}=    Fetch One    ${query_2}    ${Voucher_campain}
    RETURN    ${result[0]}    

Lấy ID Mã Voucher Mới Nhất ở Trạng Thái Đã Phát Hành
    [Arguments]    ${Voucher_campain}
    ${query_2}=    Set Variable    SELECT top(1) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1 ORDER BY Id DESC
    ${result}=    Fetch One    ${query_2}    ${Voucher_campain}
    RETURN    ${result[0]}    

Lấy List ID Mã Voucher ở Trạng Thái Đã Phát Hành
    [Arguments]    ${Voucher_campain}    ${number_of_voucher}
    ${query_3}=    Set Variable    SELECT TOP(${number_of_voucher}) Id FROM Voucher WHERE VoucherCampaignId = ? AND Status = 1
    ${result}=    Fetch All    ${query_3}    ${Voucher_campain}
    RETURN    ${result}

Lấy ID Mã Voucher Theo Trạng Thái 
    [Documentation]    Lấy ID Mã Voucher Theo Trạng Thái(chưa sử dụng, đã sử dụng, đã hết hạn)
    [Arguments]    ${Voucher_campain_id}    ${status}
    ${status}=    Run Keyword If    '${status}'=='Chưa Sử Dụng'    Set Variable    0   
    ...     ELSE IF    '${status}'=='Đã Sử Dụng'    Set Variable    3
    ...     ELSE IF    '${status}'=='Đã Phát Hành'    Set Variable    1
    ${query_3}=    Set Variable    SELECT top(1) Id, Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = ?
    ${result}=    Fetch One    ${query_3}    ${Voucher_campain_id}    ${status}
    RETURN    ${result[0]}    ${result[1]}


Update Trạng thái Voucher Đã Phát Hành ${list_voucher_id}
    FOR    ${voucher_id}    IN    @{list_voucher_id}
        ${query}=    Set Variable    UPDATE Voucher SET Status = 1 WHERE Id = ?
        Execute Query    ${query}    ${voucher_id}
    END

Xác Thực Trạng Thái Voucher Đã Sử Dụng ${list_voucher_id}
    ${number_of_voucher}=    Get Length    ${list_voucher_id}
    FOR    ${index}    IN RANGE   ${number_of_voucher}
        ${query}=    Set Variable    SELECT Status FROM Voucher WHERE Id = ?
        ${result}=    Fetch One    ${query}    ${list_voucher_id[${index}]}
        Should Be Equal As Numbers    ${result[0]}    2    Voucher đã được sử dụng
    END
Update Trạng thái ${voucher_id} Sang Trạng Thái ${status}
    [Documentation]    Update trạng thái voucher sang trạng thái ${status} (Trạng Thái 0: Chưa Sử Dụng, Trạng Thái 1: Đã Phát Hành)
    ${status}=    Run Keyword If    '${status}'=='Chưa Sử Dụng'    Set Variable    0   
    ...     ELSE IF    '${status}'=='Đã Sử Dụng'    Set Variable    3
    ...     ELSE IF    '${status}'=='Đã Phát Hành'    Set Variable    1
    ${query}=    Set Variable    UPDATE Voucher SET Status = ? WHERE Id = ?
    Execute Query    ${query}    ${status}    ${voucher_id}
    

Update Trạng thái List Voucher ${list_voucher_id} Sang Trạng Thái ${status}
    [Documentation]    Update trạng thái voucher sang trạng thái ${status} (Trạng Thái 0: Chưa Sử Dụng, Trạng Thái 1: Đã Phát Hành)
    ${status}=    Run Keyword If    '${status}'=='Chưa Sử Dụng'    Set Variable    0   
    ...     ELSE IF    '${status}'=='Đã Sử Dụng'    Set Variable    3
    ...     ELSE IF    '${status}'=='Đã Phát Hành'    Set Variable    1
    ${number_of_voucher}=    Get Length    ${list_voucher_id}
    FOR    ${index}    IN RANGE   ${number_of_voucher}
        ${query}=    Set Variable    UPDATE Voucher SET Status = ? WHERE Id = ?
        Execute Query    ${query}    ${status}    ${list_voucher_id[${index}]}
    END


#Coupon
Lấy Thông Tin Coupon Theo Mã Coupon Campaign
   [Arguments]    ${coupon_campaign_code}
    ${query}=    Set Variable    SELECT Id,PriceRatio,PriceMax FROM CouponCampaign WHERE Code = ? AND RetailerId = ?
    ${result}=    Fetch One    ${query}    ${coupon_campaign_code}    ${RETAILER_ID}
    ${price_ratio}=    Convert To Number    ${result[1]}
    ${price_max}=    Convert To Number    ${result[2]}
    RETURN    ${result[0]}    ${price_ratio}    ${price_max}

Lấy Id Mã Coupon ở Trạng Thái 
    [Arguments]    ${coupon_campaign_id}    ${status}
    ${status}=    Run Keyword If    '${status}'=='Chưa Sử Dụng'    Set Variable    0   
    ...     ELSE IF    '${status}'=='Đã Sử Dụng'    Set Variable    2
    ...     ELSE IF    '${status}'=='Đã Phát Hành'    Set Variable    1
    ${query}=    Set Variable    SELECT Id,Code FROM Coupon WHERE CouponCampaignId = ? AND Status = ?
    ${result}=    Fetch One    ${query}    ${coupon_campaign_id}    ${status}
    RETURN    ${result[0]}    ${result[1]}

