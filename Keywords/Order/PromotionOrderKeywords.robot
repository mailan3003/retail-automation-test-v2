*** Settings ***
Documentation     Keywords for Order Promotion Processing API Tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Order/CreateOrderData.robot
Resource          ../Invoice/PromotionKeywords.robot
Resource          ../Invoice/GiftProcessingKeywords.robot
Resource          ../Promotion/PromotionComnandKeywords.robot
Resource          OrderCommandKeywords.robot
Resource          CreateOrderKeywords.robot
Resource          ../../Config/Env_api.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           DateTime

*** Keywords ***
# ===== CHUẨN BỊ DỮ LIỆU =====


Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm ${product_code} Với Khuyến Mãi ${promotion_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${discount}       Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    10
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}  Create List    ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${discount}  
    ${data_promo}  Create List    ${data_promo}

    ${request}=    Update Nested Dictionary Property     ${request}     Order.Discount  ${discount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotion    ${discount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotionValue     ${discount}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm ${product_code} Với Khuyến Mãi Giảm Giá Chiết Khấu ${promotion_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${discount_amount}=    Evaluate     ${value_promotion} * ${info_promotion[3]} / 100
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${discount_amount}
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.Discount  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotion  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotionValue  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotionRatio  ${info_promotion[3]}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount_amount}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi HH HĐ Giảm Giá Hóa Đơn Chiết Khẩu ${promotion_code} Có Sản Phẩm ${product_code}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${promotion_body}   
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${discount_amount}=    Evaluate     ${value_promotion} * ${info_promotion[3]} / 100
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${discount_amount}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    15
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    2
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.Discount  ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotion  ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount_amount}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${promotion_code} Có Tổng Hóa Đơn ${value_hoa_don}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id}
    ${promotion_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price   ${value_hoa_don}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${promotion_code} Cho Khách Hàng ${customer_code}
    ${customer_id}=    Lấy Id Khách Hàng Theo Mã Khách Hàng   ${customer_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông Tin Khuyến Mãi Hóa Đơn      ${promotion_id}
    ${promotion_value}=    Convert To Number    ${info_promotion[1]}
    ${discount_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${promotion_value}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${discount_value}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     LimitPromotionUsageType    1
    ${request}=    Update Nested Dictionary Property     ${request}     Order.Discount  ${discount_value}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.CustomerId  ${customer_id}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotion  ${discount_value}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotionValue  ${discount_value}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount_value}
    RETURN    ${request}

 
Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${promotion_code} Cho Sản Phẩm ${product_code} 
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code} 
    ${price_product}=    Convert To Number    ${product_info[2]}
    ${promotion_value}=    Convert To Number    ${info_promotion[1]}
    ${discount_value}=    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_product_promotion}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price  ${promotion_value}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     ProductId   ${product_info[0]}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Price  ${price_product}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     Discount   ${discount_value}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}     SalePromotionId    ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type   3
    ${data_product}  Create List      ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    ${price_product_after_discount}=    Evaluate     ${price_product} - ${discount_value}
    ${total_invoice_value}=    Evaluate     ${promotion_value} + ${price_product_after_discount}
    Set Test Variable    ${TOTAL_ORDER_VALUE}    ${total_invoice_value}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${product_info[0]}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount_value}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Khuyễn Mãi Hàng Hóa ${promotion_code} Mua Hàng ${product_code} Giảm Giá Hàng ${product_code_1}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${product_info_1}=    Thông tin hàng hóa    ${product_code_1}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${product_info_1[0]}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    ${price_product_1}=    Convert To Number    ${product_info_1[2]}
    ${value_promotion}  Run Keyword If    '${info_promotion[2]}' == 'None'    Evaluate    ${price_product_1} * ${info_promotion[3]} / 100
    ...    ELSE    Convert To Number    ${info_promotion[2]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product_promotion}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${data_product}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}    
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
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount  ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PROMOTION_VALUE}    ${value_promotion}
    RETURN    ${request}
    
    
Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Khuyến Mãi ${promotion_code_1} Và ${promotion_code_2}
    ${promotion_id_1}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code_1}
    ${promotion_id_2}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code_2}
    ${info_promotion_1}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id_1}
    ${info_promotion_2}=    Thông Tin Khuyến Mãi Hóa Đơn    ${promotion_id_2}
    ${promotion_discount_1}=    Convert To Number    ${info_promotion_1[2]}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_promo_2}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${value_promotion}=    Convert To Number    ${info_promotion_1[1]}
    ${promotion_discount_2}=    Evaluate    ${value_promotion}*${info_promotion_2[3]}/100
    ${total_discount}=    Evaluate    ${promotion_discount_1} + ${promotion_discount_2}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id_1}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion_1[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     DiscountRatio  ${info_promotion_1[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    ${promotion_discount_1}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     PromotionId  ${promotion_id_2}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     SalePromotionId  ${info_promotion_2[0]}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     DiscountRatio  ${info_promotion_2[3]}
    ${data_promo_2}=    Update Nested Dictionary Property     ${data_promo_2}     Discount    ${promotion_discount_2}
    ${promotions}=    Create List    ${data_promo}    ${data_promo_2}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${promotions}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.DiscountByPromotion      ${total_discount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.Discount     ${total_discount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION1_ID}    ${promotion_id_1}
    Set Test Variable    ${PROMOTION2_ID}    ${promotion_id_2}
    Set Test Variable    ${PROMOTION_VALUE}   ${promotion_discount_1}
    Set Test Variable    ${TOTAL_DISCOUNT}    ${total_discount}
    RETURN    ${request}

    
Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${promotion_code} Giảm Giá Theo Số Lượng Mua ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price_product_1}=    Convert To Number    ${product_info[2]}
    ${value_promotion}  Run Keyword If    '${info_promotion[2]}' == 'None'    Evaluate    (${price_product_1} * ${info_promotion[3]} / 100)
    ...    ELSE     Evaluate       ${info_promotion[2]}*${info_promotion[4]}
    ${value_order_promotion}=    Evaluate    ${value_promotion}*${info_promotion[4]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}

    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}    
    ${data_product}=  Run Keyword If    '${info_promotion[2]}' == 'None'   Update Product Giá Bán Theo Sản Phẩm    ${data_product}    ${product_info[0]}   ${price_product_1}    ${value_promotion}    ${info_promotion[3]}    ${product_info[0]}    ${info_promotion[0]}    ${info_promotion[4]}
    ...    ELSE    Update Product Giá Bán Theo Sản Phẩm    ${data_product}   ${product_info[0]}    ${price_product_1}    ${value_promotion}    0   ${product_info[0]}    ${info_promotion[0]}    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId       ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    8
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductPrice    ${price_product_1}
    ${data_product}  Create List      ${data_product}   
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount  ${value_order_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${total_invoice_value}=    Evaluate    ${price_product_1}*${info_promotion[4]}-${value_order_promotion}
    Set Test Variable    ${TOTAL_ORDER_VALUE}    ${total_invoice_value}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}        ${product_info[0]}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${value_promotion}
    Set Test Variable    ${PROMOTION_RATIO_VALUE}   ${info_promotion[3]}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng Với Khuyến Mãi ${promotion_code} Giá Bán Theo Số Lượng Mua ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=    Thông tin khuyến mãi hàng hóa    ${promotion_id}
    ${product_info}=    Thông tin hàng hóa    ${product_code}
    ${price_product_1}=    Convert To Number    ${product_info[2]}
    ${price_promotion}     Convert To Number    ${info_promotion[5]}
    ${discount}    Evaluate    ${price_product_1}-${price_promotion} 
    ${total_discount}    Evaluate    ${discount}*${info_promotion[4]}
    ${total_order_value}    Evaluate    ${price_product_1}*${info_promotion[4]}-${total_discount}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}    
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     ProductId   ${product_info[0]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Quantity      ${info_promotion[4]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Price  ${price_product_1}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     Discount   ${discount}  
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     PriceByPromotion    ${price_promotion} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     PromotionParentProductId   ${product_info[0]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}     SalePromotionId    ${info_promotion[0]}

    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId   ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId    ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    8
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Target    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetProductId    ${product_info[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${info_promotion[4]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductPrice    ${price_product_1}
    ${data_product}  Create List      ${data_product}   
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount  ${total_discount} 
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Set Test Variable    ${TOTAL_ORDER_VALUE}    ${total_order_value} 
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${product_info[0]}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}   ${discount}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến mãi ${promotion_code} Với Quà Tặng Sản Phẩm ${product_code}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng khuyến mãi ${promotion_code} với quà tặng sản phẩm ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${info_product[0]}    ${info_promotion[2]}    ${info_promotion[0]}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${info_promotion[2]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    2
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product}*${info_promotion[2]}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${info_promotion[0]}
    Set Test Variable    ${PROMOTION_VALUE}    ${discount_amount}
    Set Test Variable    ${PROMOTION_QUANTITY}    ${info_promotion[2]}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${info_product[0]}
    RETURN    ${request}

Chuẩn bị dữ liệu đơn hàng khuyến mãi ${promotion_code} mua hàng ${product_code} tặng sản phẩm ${product_code_1}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code_1}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${price_product_1}=    Convert To Number    ${info_product_1[2]}
    Set Test Variable  ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable  ${quantity_promotion}  ${info_promotion[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    ${info_promotion[3]}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product_1}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product_promotion}=    Update Nested Dictionary Property     ${data_product_promotion}    PromotionParentProductId    ${info_product[0]}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductQty   ${info_promotion[3]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    6
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product_1}*${quantity_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${product_promotion_id}
    Set Test Variable    ${PROMOTION_QUANTITY}    ${quantity_promotion}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Với Quà Tặng Voucher
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${query_2}=    Set Variable    SELECT top(1) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${Voucher_Id}=    Fetch One    ${query_2}    ${info_promotion[4]}
    Set Test Variable    ${Voucher_Code}    ${Voucher_Id[1]}
    Set Test Variable    ${Voucher_Id}    ${Voucher_Id[0]}
    Set Test Variable    ${Voucher_Campaign_Id}    ${info_promotion[4]}
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
     ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    9
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes    ${Voucher_Code}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${Voucher_Id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_Campaign_Id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${invoice_voucher}=    Create List   
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Hàng Hóa ${product_code} Quà Tặng Voucher
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    ${query_2}=    Set Variable    SELECT top(1) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${Voucher_Id}=    Fetch One    ${query_2}    ${info_promotion[4]}
    Set Test Variable    ${Voucher_Code}    ${Voucher_Id[1]}
    Set Test Variable    ${Voucher_Id}    ${Voucher_Id[0]}
    Set Test Variable    ${Voucher_Campaign_Id}    ${info_promotion[4]}
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    SalePromotionId    ${info_promotion[0]}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    10
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes    ${Voucher_Code}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${Voucher_Id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_Campaign_Id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductId     ${info_product[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    1
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
        
    RETURN    ${request}

    
Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Tặng Điểm
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    4
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     GiftPoint    ${info_promotion[5]}
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.CustomerId    ${CUSTOMER_ID}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    RETURN    ${request}
    
Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Tặng Điểm Theo Sản Phẩm ${product_code}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product}=   Thông tin hàng hóa    ${product_code}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    ProductId    ${info_product[0]}
    ${data_product}   Update Nested Dictionary Property     ${data_product}    SalePromotionId    ${sale_promotion_id}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    7
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    1
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductId    ${info_product[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     GiftPoint    ${info_promotion[5]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     RelatedProductIds    ${info_product[0]}
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.CustomerId    ${CUSTOMER_ID}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${sale_promotion_id}

    RETURN    ${request}
    
    
Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến mãi ${promotion_code} Tặng ${qly1} Sản Phẩm ${product_code_1} Và ${qly2} Sản phẩm ${product_code_2}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code_1}
    ${info_product_2}=   Thông tin hàng hóa    ${product_code_2}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_product_promotion}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_product_promotion_1}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable  ${product_promotion_id_1}   ${info_product_2[0]}
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product_1[2]}
    ${price_product_1}=    Convert To Number    ${info_product_2[2]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable   ${quantity_promotion}  ${info_promotion[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${qly1}    ${sale_promotion_id}
    ${data_product_promotion_1}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion_1}    ${price_product_1}    ${product_promotion_id_1}    ${qly2}    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}     ${data_product_promotion_1}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${sale_promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty   ${quantity_promotion}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Discount    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    2
    ${data_promo}  Create List    ${data_promo}
    ${discount_amount}=    Evaluate    ${price_product}*${qly1} + ${price_product_1}*${qly2}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount    ${discount_amount}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    RETURN    ${request}
Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Tặng Sản Phẩm ${product_code} Và Khuyến Mãi Tặng điểm ${promotion_code_point}
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${promotion_id_point}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code_point}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${info_promotion_point}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id_point}
    ${info_product_1}=   Thông tin hàng hóa    ${product_code}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}
    ${data_promo_point}=    Deep Copy    ${BASIC_PROMOTION_ORDER}
    ${data_product_promotion}   Deep Copy    ${PRODUCT_ORDER_DETAIL}     
    ${value_promotion}=    Convert To Number    ${info_promotion[1]}
    ${price_product}=    Convert To Number    ${info_product_1[2]}
    Set Test Variable  ${product_promotion_id}   ${info_product_1[0]}
    Set Test Variable   ${sale_promotion_id}  ${info_promotion[0]}
    Set Test Variable   ${sale_promotion_id_point}  ${info_promotion_point[0]}
    Set Test Variable   ${quantity_promotion}  ${info_promotion[2]}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Price    ${value_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_product_promotion}=    Update Quà Tặng Sản Phẩm        ${data_product_promotion}    ${price_product}    ${product_promotion_id}    ${quantity_promotion}    ${sale_promotion_id}
    ${data_product}  Create List    ${data_product}     ${data_product_promotion}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
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
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo_mix}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.ProductDiscount    ${discount_amount}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.CustomerId    ${CUSTOMER_ID}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${PROMOTION_ID}    ${promotion_id}
    Set Test Variable    ${PROMOTION_ID_POINT}    ${promotion_id_point}
    Set Test Variable    ${SALE_PROMOTION_ID}    ${sale_promotion_id}
    Set Test Variable    ${SALE_PROMOTION_ID_POINT}    ${sale_promotion_id_point}
    Set Test Variable    ${PRODUCT_ID_PROMOTION}    ${product_promotion_id}
    Set Test Variable    ${PROMOTION_QUANTITY}    ${quantity_promotion}
    RETURN    ${request}


    
    

Chuẩn Bị Dữ Liệu Đơn Hàng Khuyến Mãi ${promotion_code} Với Nhiều Voucher    
    ${promotion_id}=    Lấy Thông Tin Khuyến Mãi Theo Mã Khuyến Mãi  ${promotion_code}
    ${info_promotion}=   Thông Tin Khuyến Mãi Hóa Đơn Tặng   ${promotion_id}
    ${quantity_promotion}=    Convert To Integer    ${info_promotion[2]}
    Set Test Variable    ${Voucher_Campaign_Id}     ${info_promotion[4]}
    ${query_2}=    Set Variable    SELECT top(${quantity_promotion}) Id,Code FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${voucher_list}=    Fetch All    ${query_2}   ${Voucher_Campaign_Id}
    
    # Join voucher IDs and codes into comma-separated strings
    ${voucher_ids_str}=    Evaluate    ','.join([str(voucher[0]) for voucher in $voucher_list])
    ${voucher_codes_str}=    Evaluate    ','.join([voucher[1] for voucher in $voucher_list])

    ${price_promotion}=    Convert To Number    ${info_promotion[1]}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}   
    ${data_product}   Update Nested Dictionary Property     ${data_product}    Price    ${price_promotion}
    ${data_product}   Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     Type    9
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     TargetType    0
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     SalePromotionId  ${info_promotion[0]}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCodes     ${voucher_codes_str}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherIds     ${voucher_ids_str}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ReceivedVoucherCampaignIds     ${Voucher_Campaign_Id}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     ProductQty    ${quantity_promotion}
    ${data_promo}  Create List    ${data_promo}
    ${invoice_voucher}=    Create List   
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Log    ${request}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


# Keywords cho phần xử lý thanh toán bằng Voucher
Chuẩn Bị Dữ Liệu Hóa Đơn Thanh Toán Bằng Voucher Kết Hợp Khuyến Mãi
    ${query}=    Set Variable    SELECT top(1) Id, Code, VoucherCampaignId FROM Voucher WHERE VoucherCampaignId = ? AND Status = 0
    ${voucher}=    Fetch One    ${query}    ${VOUCHER_CAMPAIGN_ID_2}
    Set Test Variable    ${voucher_id}    ${voucher[0]}
    Set Test Variable    ${voucher_code}    ${voucher[1]}
    
    ${query_2}=    Set Variable    SELECT Price FROM VoucherCampaign WHERE Id = ?
    ${campaign}=    Fetch One    ${query_2}    ${VOUCHER_CAMPAIGN_ID_2}
    ${voucher_value}=    Convert To Number    ${campaign[0]}
    
    ${request}=    Deep Copy    ${BASE_ORDER_REQUEST}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Deep Copy    ${PRODUCT_ORDER_DETAIL}
    ${data_product}=    Update Nested Dictionary Property    ${data_product}    Price    150000
    ${data_product}=    Create List    ${data_product}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderDetails    ${data_product}
    
    # Thêm thông tin khuyến mãi
    ${data_promo}=    Deep Copy    ${promotion_body}
    ${data_promo}=    Update Nested Dictionary Property    ${data_promo}    Discount    30000
    ${data_promo}=    Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.OrderPromotions    ${data_promo}
    ${request}=    Update Nested Dictionary Property    ${request}    Order.Discount    30000
    
    ${payment_voucher}=    Create Dictionary
    ...    Method=${PAYMENT_VOUCHER}
    ...    Amount=${voucher_value}
    ...    VoucherCode=${voucher_code}
    ...    VoucherId=${voucher_id}
    ...    VoucherCampaignId=${VOUCHER_CAMPAIGN_ID_2}
    
    ${payment_cash}=    Create Dictionary
    ...    Method=${PAYMENT_CASH}
    ...    Amount=70000
    
    ${payments}=    Create List    ${payment_voucher}    ${payment_cash}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Payments    ${payments}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Code    HD_TEST_VOUCHER006
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


Chuẩn Bị Dữ Liệu Đơn Hàng Sản Phẩm ${product_code} Có Khuyến Mãi ${promotion_id}
    ${product_id}=    Lấy Thông tin Sản Phẩm    ${product_code}
    ${request}     Deep Copy    ${BASE_ORDER_REQUEST}
    ${data_product}=    Deep Copy   ${PRODUCT_ORDER_DETAIL} 
    ${data_promo}=    Deep Copy    ${BASIC_PROMOTION_ORDER}
    ${purchase_date}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    ${request}  Update Nested Dictionary Property    ${request}    Order.PurchaseDate    ${purchase_date}
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    10
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    ProductId    ${product_id}
    ${data_product}  Create List    ${data_product}
    ${data_promo}=    Update Nested Dictionary Property     ${data_promo}     PromotionId  ${promotion_id}
    ${data_promo}  Create List    ${data_promo}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderDetails  ${data_product}
    ${request}=    Update Nested Dictionary Property     ${request}     Order.OrderPromotions  ${data_promo}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

