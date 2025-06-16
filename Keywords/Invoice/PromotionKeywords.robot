*** Settings ***
Documentation     Keywords cho test cases API phần áp dụng khuyến mãi
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/InvoiceVLXDData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../Customer/CustomerCommonKeywords.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/Databasepromotion.py
Library           Collections
Library           String
Library           DateTime

*** Keywords ***
# ==============================================
# Data Preparation Keywords
# ==============================================

Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${STANDARD_INVOICE}
    Set Test Variable    ${REQUEST_DATA}    &{EMPTY}
    &{request}=    Create Dictionary    Invoice=${data}    Payments=@{EMPTY}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định ${discount_value}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${PROMOTION_CODE_FIXED} 
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount     ${discount_value}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    10
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  ${discount_value}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  ${discount_value}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm Với KM ${promotion_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${discount_amount}=    Evaluate     ${value_promotion} * ${info_promotion[3]} / 100
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi HH HĐ Giảm Giá Hóa Đơn Chiết Khẩu Với KM ${promotion_code} có Sản Phẩm ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${discount_amount}=    Evaluate     ${value_promotion} * ${info_promotion[3]} / 100
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    15
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    2
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${promotion_code} Có Tổng Hóa Đơn ${value_hoa_don}
    ${promotion_id}   Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${promotion_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy   ${promotion_body}   
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}  Create List    ${data_promo}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price   ${value_hoa_don}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${promotion_code} Cho Khách Hàng ${customer_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn  ${promotion_id}
    ${promotion_value}=    Convert To Number    ${info_promotion[1]}
    ${discount_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${promotion_value}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${discount_value}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     LimitPromotionUsageType    1
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  ${discount_value}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng    ${customer_code}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.CustomerId  ${customer_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  ${discount_value}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

 
Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${promotion_code} Cho Sản Phẩm ${product_code} 
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code} 
    ${price_product}=    Convert To Number    ${product_info[2]}
    ${promotion_value}=    Convert To Number    ${info_promotion[1]}
    ${discount_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_promotion}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId    ${product_id_standard}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price  ${promotion_value}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     ProductId  ${product_info[0]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Price  ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Discount   ${discount_value}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     SalePromotionId    ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type   3
    ${data_product}  Create List      ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${price_product_after_discount}=    Evaluate     ${price_product} - ${discount_value}
    ${total_invoice_value}=    Evaluate     ${promotion_value} + ${price_product_after_discount}
    Set Test Variable    ${total_invoice_value}    ${total_invoice_value}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyễn Mãi Hàng Hóa ${promotion_code} Mua Hàng ${product_code} Giảm Giá Hàng ${product_code_1}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${product_info_1}=    Thông tin hàng hóa    ${product_code_1}
    Set Test Variable    ${product_id_promotion}    ${product_info_1[0]}
    Set Test Variable    ${sale_promotion_id}    ${info_promotion[0]}
    ${price_product_1}=    Convert To Number    ${product_info_1[2]}
    ${value_promotion}  Run Keyword If    '${info_promotion[2]}' == 'None'    Evaluate    ${price_product_1} * ${info_promotion[3]} / 100
    ...    ELSE    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product_promotion}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId   ${product_info[0]}
    ${data_product_promotion}  Run Keyword If    '${info_promotion[2]}' == 'None'    Update Khuyến Mãi Hàng Hóa Phần Trăm    ${data_product_promotion}    ${product_id_promotion}    ${price_product_1}    ${value_promotion}    ${info_promotion[3]}    ${product_info}    ${sale_promotion_id}
    ...    ELSE    Update Khuyến Mãi Hàng Hóa Giá Cố Định    ${data_product_promotion}    ${product_id_promotion}    ${price_product_1}   ${value_promotion}    ${product_info}    ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId    ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    5
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_product}  Create List      ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount  ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
    
    
Update Khuyến Mãi Hàng Hóa Giá cố định
    [Arguments]  ${data_product_promotion}    ${product_id_promotion}    ${price_product_1}    ${value_promotion}    ${product_info}    ${sale_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     ProductId   ${product_id_promotion}  
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Price  ${price_product_1}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Discount   ${value_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     PromotionParentProductId    ${product_info[0]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     SalePromotionId    ${sale_promotion_id}
    RETURN    ${data_product_promotion}
    
Update Khuyến Mãi Hàng Hóa Phần Trăm
    [Arguments]  ${data_product_promotion}    ${product_id_promotion}    ${price_product_1}     ${value_discount}   ${value_promotion}    ${product_info}    ${sale_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     ProductId   ${product_id_promotion}  
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Price  ${price_product_1}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Discount      ${value_discount} 
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     DiscountRatio    ${value_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     PromotionParentProductId    ${product_info[0]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     SalePromotionId    ${sale_promotion_id}
    RETURN     ${data_product_promotion}
    
Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi ${promotion_code_1} Và ${promotion_code_2}
    ${promotion_id_1}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code_1}
    ${promotion_id_2}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code_2}
    ${info_promotion_1}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id_1}
    ${info_promotion_2}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id_2}
    ${promotion_discount_1}=    Convert To Number    ${info_promotion_1[2]}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${data_promo_2}=    Deep Copy    ${promotion_body}   
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${value_promotion}=    Convert To Number    ${info_promotion_1[1]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id_1}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion_1[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion_1[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${promotion_discount_1}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     PromotionId  ${promotion_id_2}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     SalePromotionId  ${info_promotion_2[0]}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     DiscountRatio  ${info_promotion_2[3]}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     Discount    0
    ${promotions}=    Create List    ${data_promo}    ${data_promo_2}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${promotions}
    ${promotion_discount_2}=    Evaluate    ${value_promotion}*${info_promotion_2[3]}/100
    ${total_discount}=    Evaluate    ${promotion_discount_1} + ${promotion_discount_2}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion      ${total_discount}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount     ${total_discount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${promotion_code} Giảm Giá Theo Số Lượng Mua ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    Set Test Variable    ${product_id_promotion}    ${product_info[0]}
    Set Test Variable    ${sale_promotion_id}    ${info_promotion[0]}
    ${price_product_1}=    Convert To Number    ${product_info[2]}

    ${value_promotion}  Run Keyword If    '${info_promotion[2]}' == 'None'    Evaluate    (${price_product_1} * ${info_promotion[3]} / 100)*${info_promotion[4]}
    ...    ELSE     Evaluate       ${info_promotion[2]}*${info_promotion[4]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=  Run Keyword If    '${info_promotion[2]}' == 'None'   Update Product Giá Bán Theo Sản Phẩm    ${data_product}    ${product_id_promotion}    ${price_product_1}    ${value_promotion}    ${info_promotion[3]}    ${product_info[0]}    ${sale_promotion_id}    ${info_promotion[4]}
    ...    ELSE    Update Product Giá Bán Theo Sản Phẩm    ${data_product}    ${product_id_promotion}    ${price_product_1}    ${value_promotion}    0   ${product_info[0]}    ${sale_promotion_id}    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId    ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    8
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${info_promotion[4]}
    ${data_product}  Create List      ${data_product}   
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount  ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${total_invoice_value}=    Evaluate    ${price_product_1}*${info_promotion[4]}-${value_promotion}
    Set Test Variable    ${total_invoice_value}    ${total_invoice_value}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi ${promotion_code} Giá Bán Theo Số Lượng Mua ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    Set Test Variable    ${product_id_promotion}    ${product_info[0]}
    Set Test Variable    ${sale_promotion_id}    ${info_promotion[0]}
    ${price_product_1}=    Convert To Number    ${product_info[2]}
    ${price_promotion}     Convert To Number    ${info_promotion[5]}
    ${discount}    Evaluate    ${price_product_1}-${price_promotion} 
    ${total_discount}    Evaluate    ${discount}*${info_promotion[4]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId   ${product_id_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Quantity      ${info_promotion[4]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price  ${price_product_1}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Discount   ${discount}  
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     PriceByPromotion    ${price_promotion} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     PromotionParentProductId   ${product_id_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     SalePromotionId    ${sale_promotion_id}

    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId    ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    8
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetProductId    ${product_id_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductPrice    ${price_product_1}
    ${data_product}  Create List      ${data_product}   
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount  ${total_discount} 
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Set Test Variable    ${total_discount}    ${total_discount}  
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Update Product Giá Bán Theo Sản Phẩm
    [Arguments]    ${data_product}    ${product_id_promotion}    ${price_product_1}    ${value_promotion}    ${promotion_discount_ratio}    ${product_info}    ${sale_promotion_id}    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId   ${product_id_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Quantity    ${quantity}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price  ${price_product_1}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Discount   ${value_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     DiscountRatio   ${promotion_discount_ratio}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     PromotionParentProductId    ${product_info}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     SalePromotionId    ${sale_promotion_id}
    RETURN    ${data_product}



# ==============================================

Xác Thực Chiết Khấu Khuyến Mãi Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT DiscountByPromotion FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu khuyến mãi không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}

Xác Thực ID Khuyến Mãi Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${promotion_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${query}=    Set Variable    SELECT PromotionId FROM InvoicePromotion WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${promotion_id}    ID khuyến mãi không chính xác. Mong đợi: ${promotion_id}, Thực tế: ${result[0]}

Xác Thực Thông Tin Khuyến Mãi
    [Arguments]    ${invoice_id}    ${promotion_type}
    ${query}=    Set Variable    SELECT Type FROM InvoicePromotion WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal    ${result[0]}    ${promotion_type}    Loại khuyến mãi không chính xác. Mong đợi: ${promotion_type}, Thực tế: ${result[0]}

Xác Thực Khuyến Mãi Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_code}    ${expected_discount}     ${sale_promotion_id}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${query}=    Set Variable    SELECT Discount , SalePromotionId FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho sản phẩm trong hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giá trị khuyến mãi theo sản phẩm không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}
    Should Be Equal As Numbers    ${result[1]}    ${sale_promotion_id}    ID khuyến mãi không chính xác. Mong đợi: ${sale_promotion_id}, Thực tế: ${result[1]}

Xác Thực Sản Phẩm Quà Tặng
    [Arguments]    ${invoice_id}    ${gift_product_code}    ${gift_quantity}=1
    ${gift_product_id}=    Lấy Thông Tin Sản Phẩm    ${gift_product_code}
    ${query}=    Set Variable    SELECT ProductId, Quantity, Price FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Note LIKE '%Quà tặng%'
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${gift_product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy sản phẩm quà tặng trong hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${gift_product_id}    ID sản phẩm quà tặng không chính xác
    Should Be Equal As Numbers    ${result[1]}    ${gift_quantity}    Số lượng sản phẩm quà tặng không chính xác
    Should Be Equal As Numbers    ${result[2]}    0    Giá sản phẩm quà tặng không bằng 0

Xác Thực Voucher Được Tạo
    [Arguments]    ${invoice_id}    ${expected_value}
    ${query}=    Set Variable    SELECT v.Value FROM Voucher v INNER JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy voucher được tạo cho hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_value}    Giá trị voucher không chính xác. Mong đợi: ${expected_value}, Thực tế: ${result[0]}

Xác Thực Nhiều Khuyến Mãi Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${promotion_count}
    ${query}=    Set Variable    SELECT COUNT(*) FROM InvoicePromotion WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${promotion_count}    Số lượng khuyến mãi không chính xác. Mong đợi: ${promotion_count}, Thực tế: ${result[0]}

Xác Thực Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi
    [Arguments]    ${invoice_id}    ${expected_total}
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng giá trị đơn hàng không chính xác. Mong đợi: ${expected_total}, Thực tế: ${result[0]}

# ==============================================


Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là ${expected_discount} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Chiết Khấu Khuyến Mãi Trong Hóa Đơn    ${invoice_id}    ${expected_discount}

ID Khuyến Mãi Trong Hóa Đơn Là ${promotion_code}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực ID Khuyến Mãi Trong Hóa Đơn    ${invoice_id}    ${promotion_code}

Thông Tin Khuyến Mãi Có Loại ${promotion_type}
    ${promotion_type}=    Convert To Integer    ${promotion_type}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Thông Tin Khuyến Mãi    ${invoice_id}    ${promotion_type}

Sản Phẩm ${product_id} Có Khuyến Mãi ${expected_discount} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Khuyến Mãi Theo Sản Phẩm    ${invoice_id}    ${product_id}    ${expected_discount}    ${sale_promotion_id}

Sản Phẩm ${product_code} Có Chiết Khấu Khuyến Mãi ${expected_discount}%
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT DiscountRatio FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho sản phẩm trong hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giá trị khuyến mãi theo sản phẩm không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}

Sản Phẩm Quà Tặng ${gift_product_code} Có Trong Hóa Đơn Với Số Lượng ${gift_quantity}
    ${gift_product_id}=    Lấy Thông Tin Sản Phẩm    ${gift_product_code}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Sản Phẩm Quà Tặng    ${invoice_id}    ${gift_product_id}    ${gift_quantity}

Voucher Được Tạo Với Giá Trị ${expected_value} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Voucher Được Tạo    ${invoice_id}    ${expected_value}

Hóa Đơn Có ${promotion_count} Khuyến Mãi Được Áp Dụng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Nhiều Khuyến Mãi Trong Hóa Đơn    ${invoice_id}    ${promotion_count}

Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi Là ${expected_total} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Tổng Giá Trị Đơn Hàng Sau Khuyến Mãi    ${invoice_id}    ${expected_total} 






# ==============================================
# Keywords for AI Generated Test Cases
# ==============================================

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Hóa Đơn
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo hóa đơn
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${invoice_promotion_point_gift}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${VALID_PROMOTION_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    12
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Value   10
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPointType    1
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPoint_MoneyPerPoint    10000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Điểm Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng điểm theo sản phẩm
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${PRODUCT_PROMOTION_POINT_GIFT}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${VALID_PROMOTION_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    13
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Value   20
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductId  ${PRODUCT_1}
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPointType    1
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPoint_MoneyPerPoint    10000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Không Kết Hợp 
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với voucher không cho phép kết hợp với khuyến mãi
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}  ProductId  ${PRODUCT_ID_VLXD} 
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   91926
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount   10000
    ${data_promo}  Create List    ${data_promo}
    ${data}=    Deep Copy    ${payment_body} 
    ${data}=    Update Nested Dictionary Property    ${data}    Method    ${PAYMENT_VOUCHER}
    ${data}=    Update Nested Dictionary Property    ${data}    Amount    100000
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherId    1000008358
    ${data}=    Update Nested Dictionary Property    ${data}    VoucherCampaignId     1000000030
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.InvoicePromotions  ${data_promo}
    ${request}    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${data}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Voucher Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi tặng voucher theo sản phẩm
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${VALID_PROMOTION_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    10
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductId  ${PRODUCT_1}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Value   50000
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giới Hạn Sử Dụng
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi có giới hạn sử dụng
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${VALID_PROMOTION_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount   10000
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     LimitPromotionUsage  ${TRUE}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     LimitPromotionUsageType  1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.CustomerId  ${CUSTOMER_GROUP_PROMOTION_ID}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Kết Hợp Nhiều Loại Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với nhiều loại khuyến mãi (giảm giá, điểm thưởng, voucher)
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${promo1}=    Deep Copy    ${promotion_body}    
    ${promo2}=    Deep Copy    ${invoice_promotion_point_gift}
    ${promo3}=    Deep Copy    ${promotion_body}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    
    # Khuyến mãi 1: Giảm giá 10,000đ
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     PromotionId  ${PROMOTION_ID_FIXED}
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     Type    1
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     Discount   10000
    
    # Khuyến mãi 2: Tặng 10 điểm
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     PromotionId  ${PROMOTION_ID_POINT}
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     Type    12
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     Value   10
    
    # Khuyến mãi 3: Tặng voucher 30,000đ
    ${promo3}=    Update Nested Dictionary Property     ${promo3}     PromotionId  ${PROMOTION_ID_VOUCHER}
    ${promo3}=    Update Nested Dictionary Property     ${promo3}     Type    9
    ${promo3}=    Update Nested Dictionary Property     ${promo3}     Value   30000
    
    ${promotions}=    Create List    ${promo1}    ${promo2}    ${promo3}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${promotions}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  10000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  10000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    90000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPointType    1
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.RewardPoint_MoneyPerPoint    10000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giới Hạn Chiết Khấu Voucher
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với voucher có giới hạn chiết khấu tối đa
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherCampaignId   ${VOUCHER_CAMPAIGN_ID}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherId   ${VOUCHER_ID}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherCode   TESTMAXLIMIT
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherValue   15000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherMaxValue   15000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.VoucherRatio   20
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chế Độ Ưu Tiên Giá Trị Lớn Nhất
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với chế độ ưu tiên khuyến mãi theo giá trị lớn nhất
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${promo1}=    Deep Copy    ${promotion_body}    
    ${promo2}=    Deep Copy    ${promotion_body}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    
    # Khuyến mãi 1: Giảm giá 10,000đ
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     PromotionId  ${PROMOTION_ID_FIXED}
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     Type    1
    ${promo1}=    Update Nested Dictionary Property     ${promo1}     Discount   10000
    
    # Khuyến mãi 2: Giảm giá 20,000đ
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     PromotionId  ${PROMOTION_ID_FIXED_2}
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     Type    1
    ${promo2}=    Update Nested Dictionary Property     ${promo2}     Discount   20000
    
    ${promotions}=    Create List    ${promo1}    ${promo2}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${promotions}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  20000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  20000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    80000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.PromotionPriorityType    1
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Số Lượng Tối Thiểu
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi yêu cầu số lượng sản phẩm tối thiểu
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    5
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    20000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${PROMOTION_ID_MIN_QUANTITY}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    7
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio   20
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductId  ${PRODUCT_1}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     MinQuantity  5
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount  20000
    Set Test Variable    ${product_id_promotion}    ${PRODUCT_1}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Xác Thực Điểm Thưởng Hóa Đơn
    [Arguments]    ${expected_points}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    ${query}=    Set Variable    SELECT Point FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_points}    Điểm thưởng không chính xác. Mong đợi: ${expected_points}, Thực tế: ${result[0]}

Xác Thực Quà Tặng Voucher Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_value}    ${expected_count}
    ${query}=    Set Variable    SELECT COUNT(*), v.Value FROM Voucher v INNER JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? GROUP BY v.Value
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy voucher được tạo cho hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_count}    Số lượng voucher không chính xác. Mong đợi: ${expected_count}, Thực tế: ${result[0]}
    Should Be Equal As Numbers    ${result[1]}    ${expected_value}    Giá trị voucher không chính xác. Mong đợi: ${expected_value}, Thực tế: ${result[1]}

Xác Thực Chiết Khấu Voucher Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT VoucherValue FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu voucher không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}

Response Phải Có Lỗi
    [Arguments]    ${expected_message}
    ${response_body}=    Convert To String    ${RESPONSE.text}
    Should Contain    ${response_body}    ${expected_message}    Response không chứa thông báo lỗi "${expected_message}"

# Các keywords mới cho test case promotion đã bị xóa
Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Đã Bị Xóa
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi đã bị xóa
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}

    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${DELETE_PROMOTION_CODE}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Name    Giảm giá 50%: CT001
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount   10000
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  10000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  10000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    90000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Hợp Lệ Và Khuyến Mãi Đã Bị Xóa
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với khuyến mãi hợp lệ và khuyến mãi đã bị xóa
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo_valid}=    Deep Copy    ${promotion_body}   
    ${data_promo_deleted}=    Deep Copy    ${promotion_body}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    1
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    100000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    
    # Khuyến mãi hợp lệ
    ${data_promo_valid}=    Update Nested Dictionary Property     ${data_promo_valid}     PromotionId  ${VALID_PROMOTION_ID}
    ${data_promo_valid}=    Update Nested Dictionary Property     ${data_promo_valid}     Type    1
    ${data_promo_valid}=    Update Nested Dictionary Property     ${data_promo_valid}     Discount   10000
    
    # Khuyến mãi đã bị xóa
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${DELETE_PROMOTION_CODE}
    ${data_promo_deleted}=    Update Nested Dictionary Property     ${data_promo_deleted}     PromotionId  ${promotion_id}
    ${data_promo_deleted}=    Update Nested Dictionary Property     ${data_promo_deleted}     Type    1
    ${data_promo_deleted}=    Update Nested Dictionary Property     ${data_promo_deleted}     Name    Tặng quà: CT002
    ${data_promo_deleted}=    Update Nested Dictionary Property     ${data_promo_deleted}     Discount   5000
    
    ${promotions}=    Create List    ${data_promo_valid}    ${data_promo_deleted}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${promotions}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Discount  15000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.DiscountByPromotion  15000
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.Total    85000
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
