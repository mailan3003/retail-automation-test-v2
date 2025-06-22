*** Settings ***
Documentation     Keywords for Gift Processing API Tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Product/ProductCommonKeywords.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../Customer/CustomerCommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           ../../Resources/Databasepromotion.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến mãi ${promotion_code} Với Quà Tặng Sản Phẩm ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
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
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
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

Chuẩn bị dữ liệu khuyến mãi ${promotion_code} mua hàng ${product_code} tặng sản phẩm ${product_code_1}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
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
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product_1}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    PromotionParentProductId    ${info_product[0]}
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

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Với Quà Tặng Voucher
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${Voucher_Id}    ${Voucher_Code}=    Lấy ID Mã Voucher Theo Trạng Thái    ${info_promotion[4]}   Chưa Sử Dụng
    Set Test Variable    ${Voucher_CODE}    ${Voucher_Code}
    Set Test Variable    ${Voucher_ID}    ${Voucher_Id}
    Set Test Variable    ${Voucher_CAMPAIGN_ID}    ${info_promotion[4]}
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    9
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes    ${Voucher_CODE}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${Voucher_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_CAMPAIGN_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${invoice_voucher}=    Create List   
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Hàng Hóa ${product_code} Quà Tặng Voucher
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${Voucher_Id}    ${Voucher_Code}=    Lấy ID Mã Voucher Theo Trạng Thái    ${info_promotion[4]}   Chưa Sử Dụng
    Set Test Variable    ${Voucher_CODE}    ${Voucher_Code}
    Set Test Variable    ${Voucher_ID}    ${Voucher_Id}
    Set Test Variable    ${Voucher_CAMPAIGN_ID}    ${info_promotion[4]}
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    SalePromotionId    ${info_promotion[0]}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    10
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes    ${Voucher_CODE}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${Voucher_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_CAMPAIGN_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductId     ${info_product[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

    
Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Tặng Điểm
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    4
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     GiftPoint    ${info_promotion[5]}
    ${data_promo}  Create List    ${data_promo}
    ${customer_id}=    Lấy ID Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
    
Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Tặng Điểm Theo Sản Phẩm ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    SalePromotionId    ${sale_promotion_id}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    7
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductId    ${info_product[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     GiftPoint    ${info_promotion[5]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductIds    ${info_product[0]}
    ${data_promo}  Create List    ${data_promo}
    ${customer_id}=    Lấy ID Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.CustomerId    ${customer_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}
    
    
Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến mãi ${promotion_code} Tặng ${qly1} Sản Phẩm ${product_code_1} Và ${qly2} Sản phẩm ${product_code_2}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code_1}
    ${info_product_2}=   Thông tin hàng hóa    ${product_code_2}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_product_promotion_1}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable  ${product_promotion_id_1}   ${info_product_2[0]}
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product_1[2]}
    ${price_product_1}=    Convert To Number    ${info_product_2[2]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable   ${quantity_promotion}  ${info_promotion[2]}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${qly1}    ${sale_promotion_id}
    ${data_product_promotion_1}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion_1}    ${price_product_1}    ${product_promotion_id_1}    ${qly2}    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}     ${data_product_promotion_1}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    2
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product}*${qly1} + ${price_product_1}*${qly2}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Tặng Sản Phẩm ${product_code} Và Khuyến Mãi Tặng Điểm ${promotion_code_point}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${promotion_id_point}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code_point}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_promotion_point}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id_point}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}
    ${data_promo_point}=    Deep Copy    ${promotion_body}
    ${data_product_promotion}   Deep Copy    ${STANDARD_INVOICE_DETAIL}     
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product_1[2]}
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable   ${sale_promotion_id_point}  ${info_promotion_point[0]}
    Set Test Variable   ${quantity_promotion}  ${info_promotion[2]}
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    2
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     PromotionId   ${promotion_id_point}
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     SalePromotionId  ${sale_promotion_id_point}
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     ProductQty   ${quantity_promotion}
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     Discount    0
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     Type    4
    ${data_promo_point}=    Update Nested Dictionary Property     ${data_promo_point}     GiftPoint    ${info_promotion_point[5]}
    ${data_promo_mix}  Create List    ${data_promo}     ${data_promo_point}    
    ${discount_amount}=    Evaluate    ${price_product}*${quantity_promotion}
    ${customer_id}=    Lấy ID Khách Hàng Theo Mã Khách Hàng    ${CUSTOMER_CODE}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo_mix}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.ProductDiscount    ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.CustomerId    ${CUSTOMER_ID}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


    
    

Chuẩn Bị Dữ Liệu Hóa Đơn Khuyến Mãi ${promotion_code} Với Nhiều Voucher    
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi    ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${quantity_promotion}=    Convert To Integer    ${info_promotion[2]}
    Set Test Variable    ${Voucher_CAMPAIGN_ID}     ${info_promotion[4]}
    ${query_2}=    Set Variable    SELECT top(${quantity_promotion}) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${voucher_list}=    Fetch All    ${query_2}   ${Voucher_CAMPAIGN_ID}
    
    # Join voucher IDs and codes into comma-separated strings
    ${voucher_ids_str}=    Evaluate    ','.join([str(voucher[0]) for voucher in $voucher_list])
    ${voucher_codes_str}=    Evaluate    ','.join([voucher[1] for voucher in $voucher_list])

    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${invoice_request_body_not_delivery}
    ${data_product}=    Deep Copy   ${STANDARD_INVOICE_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${product_id_standard}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id_standard}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    9
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes     ${voucher_codes_str}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${voucher_ids_str}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_CAMPAIGN_ID}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${quantity_promotion}
    ${data_promo}  Create List    ${data_promo}
    ${invoice_voucher}=    Create List   
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoicePromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Update Quà Tặng Sản Phẩm
    [Arguments]    ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Price    ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    ProductId    ${product_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Discount   ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    Quantity    ${quantity_promotion}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    SalePromotionId    ${sale_promotion_id}
    RETURN    ${data_product_promotion}

Xác Thực Quà Tặng Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_code}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng đã được thêm vào hóa đơn với giá 0đ
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
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
    [Arguments]    ${invoice_id}    ${product_code}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng theo sản phẩm đã được thêm vào hóa đơn
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
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
    [Arguments]    ${invoice_id}    ${product_code}
    [Documentation]    Kiểm tra ghi chú quà tặng trong chi tiết hóa đơn
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${query}=    Set Variable    SELECT Note FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${results}=     Fetch One     ${query}    ${invoice_id}    ${product_id}
    ${note}=    Set Variable    ${results[0][0]}
    Should Contain    ${note}    Quà tặng từ khuyến mãi

Xác Thực Quà Tặng Voucher
    [Arguments]    ${invoice_id}    
    [Documentation]    Kiểm tra voucher quà tặng đã được tạo và liên kết với hóa đơn
    ${query}=    Set Variable    SELECT * FROM InvoicePromotion WHERE InvoiceId = ? AND ReceivedVoucherCodes = ?
    ${results}=  Fetch One    ${query}    ${invoice_id}    ${Voucher_CODE}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin khuyến mãi tặng voucher ${invoice_id} trong CSDL
    
    # Kiểm tra trạng thái voucher
    ${query}=    Set Variable    SELECT Status FROM Voucher WHERE VoucherCampaignId = ? AND Id = ?
    ${results}=    Fetch One    ${query}    ${Voucher_CAMPAIGN_ID}     ${Voucher_ID}  
    ${status}=    Set Variable    ${results[0]}
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
    ${query}=    Set Variable    SELECT GiftPoint FROM InvoicePromotion WHERE InvoiceId = ? AND SalePromotionId = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}    ${sale_promotion_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin điểm thưởng    
    ${promotion_points}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    

Xác Thực Quà Tặng Điểm Theo ${sale_promotion_id} Với Điểm ${expected_points}
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT GiftPoint FROM InvoicePromotion WHERE InvoiceId = ? AND SalePromotionId = ?
    ${results}=     Fetch One    ${query}    ${invoice_id}    ${sale_promotion_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin điểm thưởng    
    ${promotion_points}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng

Xác Thực Tracking Điểm Theo ${invoice_id} Với Điểm ${expected_points}
    Wait Until Keyword Succeeds    3x    1s    Xác Thực Tracking Điểm    ${invoice_id}    ${expected_points}

Xác Thực Tracking Điểm
    [Arguments]    ${invoice_id}    ${expected_points}=20
    ${query}=    Set Variable    SELECT PartnerId,Value FROM PointTracking WHERE DocumentId= ?
    ${results}=     Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${results}    None    Không tìm thấy thông tin tracking điểm
    ${value}=    Set Variable    ${results[1]}
    Should Be Equal As Numbers    ${value}    ${expected_points}    Số điểm tracking không đúng
   
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
    [Arguments]    ${invoice_id}    ${product_code}    ${expected_points}=20
    [Documentation]    Kiểm tra nhiều loại quà tặng đã được thêm vào hóa đơn
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
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

Xác Thực Số Lượng Quà Tặng ${product_code} Với Số Lượng ${expected_quantity}
    [Documentation]    Kiểm tra số lượng sản phẩm quà tặng
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${query}=    Set Variable    SELECT Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = Discount
    ${results}=    Fetch One    ${query}    ${INVOICE_ID}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    ${quantity}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${quantity}    ${expected_quantity}    Số lượng quà tặng không đúng

Xác Thực Số Lượng Voucher
    [Arguments]    ${invoice_id}    ${expected_quantity}=3
    [Documentation]    Kiểm tra số lượng voucher quà tặng
    ${query}=    Set Variable    SELECT ProductQty FROM InvoicePromotion WHERE InvoiceId = ? AND Type = 9
    ${results}=    Fetch One   ${query}    ${invoice_id}
    ${count}=    Set Variable    ${results[0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng



# Các keywords kiểm tra kết quả
Xác Thực Thanh Toán Voucher Hóa Đơn
    [Arguments]    ${invoice_id}    ${voucher_id}    ${amount}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = 'Voucher' AND VoucherId = ? AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${voucher_id}    ${amount}
    Should Be Equal As Numbers    ${result[0]}    1    Thanh toán bằng voucher không được ghi nhận đúng

Xác Thực Thanh Toán Tiền Mặt Hóa Đơn
    [Arguments]    ${invoice_id}    ${amount}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ? AND Method = 'Cash' AND Amount = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${amount}
    Should Be Equal As Numbers    ${result[0]}    1    Thanh toán bằng tiền mặt không được ghi nhận đúng

Xác Thực Tổng Tiền Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${amount}
    ${query}=    Set Variable    SELECT SUM(Amount) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${amount}    Tổng tiền thanh toán không khớp

Xác Thực Trạng Thái Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${status}
    ${query}=    Set Variable    SELECT PaymentStatus FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${status}    Trạng thái thanh toán không đúng

Xác Thực Trạng Thái Voucher Đã Sử Dụng
    [Arguments]    ${voucher_id}
    ${query}=    Set Variable    SELECT Status FROM Voucher WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${voucher_id}
    Should Be Equal As Numbers    ${result[0]}    1    Voucher chưa được đánh dấu là đã sử dụng

Xác Thực Trạng Thái Nhiều Voucher Đã Sử Dụng
    ${query_1}=    Set Variable    SELECT Status FROM Voucher WHERE Id = ?
    ${result_1}=    Fetch One    ${query_1}    ${voucher_id_1}
    Should Be Equal As Numbers    ${result_1[0]}    1    Voucher 1 chưa được đánh dấu là đã sử dụng
    
    ${query_2}=    Set Variable    SELECT Status FROM Voucher WHERE Id = ?
    ${result_2}=    Fetch One    ${query_2}    ${voucher_id_2}
    Should Be Equal As Numbers    ${result_2[0]}    1    Voucher 2 chưa được đánh dấu là đã sử dụng

Xác Thực Giảm Giá Khuyến Mãi Hóa Đơn
    [Arguments]    ${invoice_id}    ${discount}
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Be Equal As Numbers    ${result[0]}    ${discount}    Giảm giá khuyến mãi không đúng

