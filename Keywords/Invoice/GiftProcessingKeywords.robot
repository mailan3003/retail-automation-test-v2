*** Settings ***
Documentation     Keywords for Gift Processing API Tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/Databasepromotion.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến mãi ${Id_promotion} Với Quà Tặng Sản Phẩm ${product_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${Id_promotion}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    Set Test Variable  ${product_promotion_id}   ${info_product[0]}
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product[2]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable   ${quantity_promotion}  ${info_promotion[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Price    ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    ProductId    ${product_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Discount   ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Quantity    ${quantity_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    SalePromotionId    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${Id_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    2
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product}*${info_promotion[2]}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn bị dữ liệu khuyến mãi ${promotion_id} mua hàng ${product_code} tặng sản phẩm ${product_code_1}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code_1}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${price_product_1}=    Convert To Number    ${info_product_1[2]}
    Set Test Variable  ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable  ${quantity_promotion}  ${info_promotion[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${info_promotion[3]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    ProductId    ${product_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Price    ${price_product_1}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Discount   ${price_product_1}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Quantity    ${quantity_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    PromotionParentProductId    ${info_product[0]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    SalePromotionId    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductQty   ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    6
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product_1}*${quantity_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_id} Với Quà Tặng Voucher
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${query_2}=    Set Variable    SELECT top(1) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${Voucher_Id}=    Fetch One    ${query_2}    ${info_promotion[4]}
    Set Test Variable    ${Voucher_Code}    ${Voucher_Id[1]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${info_promotion[1]}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    9
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCode    ${Voucher_Code}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds    ${Voucher_Id[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}

    

Xác Thực Quà Tặng Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng đã được thêm vào hóa đơn với giá 0đ
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = Discount
    ${results}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra số lượng
    ${actual_quantity}=    Set Variable    ${results[3]}
    Should Be Equal As Numbers    ${actual_quantity}    ${expected_quantity}
    
    # Kiểm tra ghi chú sản phẩm
    ${query}=    Set Variable    SELECT SalePromotionId FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    ${sale_promotion_id_detail}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${sale_promotion_id_detail}    ${sale_promotion_id}

Xác Thực Quà Tặng Sản Phẩm Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng theo sản phẩm đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=  Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=   Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    6    Type khuyến mãi không phải ProductGift

Xác Thực Ghi Chú Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}
    [Documentation]    Kiểm tra ghi chú quà tặng trong chi tiết hóa đơn
    ${query}=    Set Variable    SELECT Note FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${results}=     Fetch One     ${query}    ${invoice_id}    ${product_id}
    ${note}=    Set Variable    ${results[0][0]}
    Should Contain    ${note}    Quà tặng từ khuyến mãi

Xác Thực Quà Tặng Voucher
    [Arguments]    ${invoice_id}    ${expected_value}=50000   ${expected_quantity}=1
    [Documentation]    Kiểm tra voucher quà tặng đã được tạo và liên kết với hóa đơn
    ${query}=    Set Variable    SELECT * FROM InvoicePromotion WHERE InvoiceId = ? AND ProductId = ? AND ReceivedVoucherCode = ?
    ${results}=  Fetch One    ${query}    ${invoice_id}    ${Voucher_Code}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng
    
    # Kiểm tra trạng thái voucher
    ${query}=    Set Variable    SELECT top(1) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${results}=    Fetch One    ${query}    ${invoice_id}
    ${status}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${status}    1    Trạng thái voucher không phải là Kích hoạt

Xác Thực Quà Tặng Voucher Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_value}=50000    ${expected_quantity}=1
    [Documentation]    Kiểm tra voucher quà tặng theo sản phẩm đã được tạo và liên kết
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? AND v.Value = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}    ${expected_value}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    10    Type khuyến mãi không phải ProductVoucherGift

Xác Thực Quà Tặng Điểm
    [Arguments]    ${invoice_id}    ${expected_points}=20
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    4    Type khuyến mãi không phải InvoicePointGift

Xác Thực Quà Tặng Điểm Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_points}=15
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi theo sản phẩm đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    7    Type khuyến mãi không phải ProductPointGift

Xác Thực Nhiều Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_points}=20
    [Documentation]    Kiểm tra nhiều loại quà tặng đã được thêm vào hóa đơn
    # Kiểm tra sản phẩm quà tặng
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=     Fetch One     ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra điểm thưởng
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=    Fetch One   ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra có nhiều loại khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT COUNT(DISTINCT PromotionType) FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Fetch One    ${query}    ${invoice_id}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    2    Không có đủ loại khuyến mãi

Xác Thực Số Lượng Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=3
    [Documentation]    Kiểm tra số lượng sản phẩm quà tặng
    ${query}=    Set Variable    SELECT Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=    Fetch One   ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    ${quantity}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${quantity}    ${expected_quantity}    Số lượng quà tặng không đúng

Xác Thực Số Lượng Voucher
    [Arguments]    ${invoice_id}    ${expected_quantity}=3
    [Documentation]    Kiểm tra số lượng voucher quà tặng
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ?
    ${results}=    Fetch One   ${query}    ${invoice_id}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng

Get From Response
    [Documentation]    Extrait une valeur de la réponse JSON
    [Arguments]    ${property_name}
    ${response_json}=    Evaluate    json.loads('''${RESPONSE.content.decode('utf-8')}''')
    ${value}=    Get From Dictionary    ${response_json}    ${property_name}
    RETURN    ${value} 

Thông Tin Khuyến Mãi Hóa Đơn Tặng 
    [Arguments]    ${Id_promotion}
    ${query}=    Set Variable    SELECT Id, InvoiceValue, ReceivedQuantity,PrereqQuantity,ReceivedVoucherCampaignIds FROM SalePromotion WHERE CampaignId = ?
    ${result}=    Select One Promotion    ${query}    ${Id_promotion}
    RETURN    ${result}

Thông tin hàng hóa
    [Arguments]    ${product_code}
    ${query}=    Set Variable    SELECT Id, Name, BasePrice FROM Product WHERE Code = ?
    ${result}=   Fetch One    ${query}    ${product_code}
    RETURN    ${result}
