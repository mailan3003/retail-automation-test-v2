*** Settings ***
Documentation     Keywords cho test cases API xử lý giảm giá hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Promotion/PromotionComnonKeywords.robot
Resource          ../CommonKeywords.robot
Resource           InvoiceCommonKeywords.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String
Library           json

*** Variables ***
# Các biến cố định cho test cases
${STANDARD_DISCOUNT_AMOUNT}    10000
${STANDARD_DISCOUNT_RATIO}     10
${PROMOTION_DISCOUNT_AMOUNT}   20000
${PROMOTION_ID_1}              1001
${PRODUCT_PRICE_100K}          100000
${CURRENCY_DECIMAL_PLACE}      2
${CURRENCY_DECIMAL_PLACE_FOR_PRODUCT}    4

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá ${discount_amount}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá cơ bản
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    ${discount_amount}
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá Tỷ Lệ ${discount_ratio} %
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giá trị và tỷ lệ giảm giá tùy chỉnh
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${discount}     Evaluate    ${PRODUCT_PRICE_100K} * ${discount_ratio} / 100
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    ${discount}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    DiscountRatio    ${discount_ratio}
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Áp Coupon Đợt ${coupon_campaign_code}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với mã coupon giảm giá 20000
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    CouponCode    ${coupon_campaign_code}
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}


# Keywords xác thực
Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Giảm Giá ${expected_discount}
    [Documentation]    Kiểm tra giá trị giảm giá hóa đơn trong CSDL
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_discount}=    Convert To Number    ${expected_discount}
    ${expected_discount_rounded}=    Evaluate    round(${expected_discount}, ${CURRENCY_DECIMAL_PLACE})
    ${actual_discount}=    Convert To Number    ${result[0]}
    
    Should Be Equal    ${actual_discount}    ${expected_discount_rounded}    Giá trị giảm giá không đúng
    RETURN    ${actual_discount}

Xác Thực Giảm Giá Hóa Đơn Trong CSDL Với Tỷ Lệ Giảm Giá ${expected_discount_ratio}
    [Documentation]    Kiểm tra giá trị giảm giá hóa đơn trong CSDL
    ${query}=    Set Variable    SELECT DiscountRatio FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_discount_ratio}=    Convert To Number    ${expected_discount_ratio}
    ${actual_discount_ratio}=    Convert To Number    ${result[0]}
    
    Should Be Equal    ${actual_discount_ratio}    ${expected_discount_ratio}    Tỷ lệ giảm giá không đúng
    RETURN    ${actual_discount_ratio}

Tổng tiền hóa đơn phải bằng ${expected_total}
    [Documentation]    Kiểm tra tổng tiền hóa đơn trong CSDL
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${INVOICE_ID}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    ${actual_total}=    Convert To Number    ${result[0]}
    ${expected_total}=    Convert To Number    ${expected_total}
    
    # So sánh với biên độ sai số nhỏ do làm tròn
    ${diff}=    Evaluate    abs(${actual_total} - ${expected_total})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Tổng tiền hóa đơn không đúng, kỳ vọng ${expected_total} nhưng nhận được ${actual_total}

Xác Thực Tỷ Lệ Giảm Giá Trong CSDL
    [Documentation]    Kiểm tra tỷ lệ giảm giá hóa đơn trong CSDL
    [Arguments]    ${invoice_id}    ${expected_ratio}
    
    ${query}=    Set Variable    SELECT DiscountRatio FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn tỷ lệ mong đợi theo cấu hình số chữ số thập phân cho sản phẩm
    ${expected_ratio_rounded}=    Evaluate    round(${expected_ratio}, ${CURRENCY_DECIMAL_PLACE_FOR_PRODUCT})
    ${actual_ratio}=    Convert To Number    ${result[0]}
    
    Should Be Equal    ${actual_ratio}    ${expected_ratio_rounded}    Tỷ lệ giảm giá không đúng
    RETURN    ${actual_ratio}

Xác Thực Giảm Giá Khuyến Mãi Trong CSDL
    [Documentation]    Kiểm tra giá trị giảm giá từ khuyến mãi trong CSDL
    [Arguments]    ${invoice_id}    ${expected_promotion_discount}
    
    ${query}=    Set Variable    SELECT DiscountByPromotion FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_discount_rounded}=    Evaluate    round(${expected_promotion_discount}, ${CURRENCY_DECIMAL_PLACE})
    ${actual_discount}=    Convert To Number    ${result[0]}
    
    Should Be Equal    ${actual_discount}    ${expected_discount_rounded}    Giá trị giảm giá khuyến mãi không đúng
    RETURN    ${actual_discount}

Xác Thực Chi Tiết Khuyến Mãi Trong CSDL
    [Documentation]    Kiểm tra chi tiết khuyến mãi được lưu trong CSDL
    [Arguments]    ${invoice_id}    ${promotion_id}
    
    ${query}=    Set Variable    SELECT PromotionId FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Fetch All    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi cho hóa đơn
    
    ${found}=    Set Variable    ${FALSE}
    FOR    ${result}    IN    @{results}
        ${current_promotion_id}=    Convert To Integer    ${result[0]}
        Run Keyword If    ${current_promotion_id} == ${promotion_id}    Set Variable    ${found}    ${TRUE}
    END
    
    Should Be True    ${found}    Không tìm thấy khuyến mãi với ID ${promotion_id} cho hóa đơn

Xác Thực Phân Bổ Giảm Giá Sản Phẩm Trong CSDL
    [Documentation]    Kiểm tra phân bổ giảm giá cho các sản phẩm trong hóa đơn
    [Arguments]    ${invoice_id}
    
    # Lấy tổng giảm giá hóa đơn
    ${query_invoice}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${invoice_result}=    Fetch One    ${query_invoice}    ${invoice_id}
    ${total_discount}=    Convert To Number    ${invoice_result[0]}
    
    # Lấy tổng giảm giá của các sản phẩm
    ${query_details}=    Set Variable    SELECT SUM(Discount) FROM InvoiceDetail WHERE InvoiceId = ?
    ${details_result}=    Fetch One    ${query_details}    ${invoice_id}
    ${details_discount}=    Convert To Number    ${details_result[0]}
    
    # So sánh (có thể có chênh lệch nhỏ do làm tròn)
    ${diff}=    Evaluate    abs(${total_discount} - ${details_discount})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Tổng giảm giá phân bổ cho sản phẩm không khớp với giảm giá hóa đơn (chênh ${diff})
    
    # Kiểm tra tất cả các sản phẩm đều có phân bổ giảm giá
    ${query_count}=    Set Variable    SELECT COUNT(*) FROM InvoiceDetail WHERE InvoiceId = ? AND Discount > 0
    ${count_result}=    Fetch One    ${query_count}    ${invoice_id}
    
    ${query_total_count}=    Set Variable    SELECT COUNT(*) FROM InvoiceDetail WHERE InvoiceId = ?
    ${total_count_result}=    Fetch One    ${query_total_count}    ${invoice_id}
    
    # Nếu có giảm giá, tất cả sản phẩm phải được phân bổ
    Run Keyword If    ${total_discount} > 0    Should Be Equal    ${count_result[0]}    ${total_count_result[0]}    Không phải tất cả sản phẩm đều được phân bổ giảm giá 

# Thêm các keywords mới (AIgen) cho việc kiểm tra tính tổng tiền hàng
# Các keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code} Đơn Giá ${price} Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá và số lượng tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Nested Dictionary Property     ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property  ${product_detail}    Quantity    ${quantity}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code} Đơn Giá ${price} Giảm Giá ${discount} Số Lượng ${quantity}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá, giảm giá và số lượng tùy chỉnh
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}

    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${product_code}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Nested Dictionary Property     ${product_detail}    Price    ${price}
    ${product_detail}=    Update Nested Dictionary Property   ${product_detail}    Discount    ${discount}
    ${product_detail}=   Update Nested Dictionary Property   ${product_detail}    Quantity    ${quantity}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm ${product_code_1} Và ${product_code_2} Và Giảm Giá Hóa Đơn ${discount}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với hai sản phẩm và giảm giá hóa đơn
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount}
    
    # Thêm chi tiết sản phẩm 1
    ${product_detail1}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id_1}=    Lấy Thông Tin Sản Phẩm    ${product_code_1}
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    ProductId    ${product_id_1}
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    Price    100000
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    Quantity    1
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail1}
    
    # Thêm chi tiết sản phẩm 2
    ${product_detail2}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id_2}=    Lấy Thông Tin Sản Phẩm    ${product_code_2}
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    ProductId    ${product_id_2}
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    Price    200000
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    Quantity    1
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail2}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá ${discount} Phụ Phí ${surcharge_code}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có giảm giá và phụ phí cố định
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    ${discount}

    ${surcharge_id}    ${surcharge_value}    ${surcharge_value_ratio}      Lấy Thông Tin Thu Khác Theo Code    ${surcharge_code}
    ${quantity}=    Convert To Number    ${STANDARD_INVOICE_DETAIL}[Quantity]
    ${price}=    Convert To Number   ${STANDARD_INVOICE_DETAIL}[Price]
    ${subtotal}=    Evaluate    ${price} * ${quantity} - ${discount}
    ${surcharge_amount}=    Run Keyword If    '${surcharge_value_ratio}' != '0'
    ...    Evaluate    ${subtotal} * ${surcharge_value_ratio} / 100
    ...    ELSE    Set Variable    ${surcharge_value}
    ${total}=    Evaluate    ${subtotal} + ${surcharge_amount}
    ${surcharge_item_body}=    Deep Copy    ${surcharge_item_body}
    ${surcharge_item_body}=   Update Nested Dictionary Property   ${surcharge_item_body}    SurchargeId    ${surcharge_id}
    ${surcharge_item_body}=   Run Keyword If    '${surcharge_value_ratio}' == '0'    Update Nested Dictionary Property   ${surcharge_item_body}    Price    ${surcharge_value}    ELSE   Update Surcharge Percentage Invoice     ${surcharge_item_body}      ${surcharge_value_ratio}    ${surcharge_amount}
    ${request_invoice_surcharges}=    Create List    ${surcharge_item_body}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    InvoiceOrderSurcharges    ${request_invoice_surcharges}
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${TOTAL_SURCHARGE}    ${surcharge_value}
    Set Test Variable    ${TOTAL_INVOICE}    ${total}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Update Surcharge Percentage Invoice
    [Arguments]    ${surcharge_item_body}    ${surcharge_value_ratio}    ${price}
    ${surcharge_item_body}    Update Nested Dictionary Property   ${surcharge_item_body}    ValueRatio    ${surcharge_value_ratio}
    ${surcharge_item_body}    Update Nested Dictionary Property   ${surcharge_item_body}    Price    ${price}
    RETURN    ${surcharge_item_body}

Chuẩn Bị Dữ Liệu Hóa Đơn Giảm Giá ${discount} Có Nhiều Thu Khác ${surcharge_code}
    [Documentation]    Chuẩn bị dữ liệu đơn hàng với sản phẩm có giảm giá và phụ phí tính theo phần trăm
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    ${discount}

    ${order_surcharges}=    Create List
    ${total_surcharge}=    Set Variable    ${0}
    ${total_invoice}=    Set Variable    ${0}
    FOR    ${surcharge_code}    IN    @{surcharge_code}
        ${surcharge_id}    ${surcharge_value}    ${surcharge_value_ratio}      Lấy Thông Tin Thu Khác Theo Code    ${surcharge_code}
        ${price}=    Convert To Number   ${STANDARD_INVOICE_DETAIL}[Price]
        ${quantity}=    Convert To Number    ${STANDARD_INVOICE_DETAIL}[Quantity]
        ${subtotal}=    Evaluate    ${price} * ${quantity} - ${discount}
        ${surcharge_amount}=    Run Keyword If    '${surcharge_value_ratio}' != '0'
        ...    Evaluate    ${subtotal} * ${surcharge_value_ratio} / 100
        ...    ELSE    Set Variable    ${surcharge_value}
        ${total_surcharge}=    Evaluate    ${total_surcharge} + ${surcharge_amount}
        ${total_invoice}=    Evaluate    ${subtotal} + ${total_surcharge} 
        ${surcharge_item_body}=    Deep Copy    ${surcharge_item_body}
        ${surcharge_item_body}=      Update Nested Dictionary Property     ${surcharge_item_body}   SurchargeId    ${surcharge_id}
        ${surcharge_item_body}=  Run Keyword If    '${surcharge_value_ratio}' == '0'    Update Nested Dictionary Property   ${surcharge_item_body}    Price    ${surcharge_value}    ELSE     Update Surcharge Percentage Invoice     ${surcharge_item_body}      ${surcharge_value_ratio}    ${surcharge_amount}
        Append To List    ${order_surcharges}    ${surcharge_item_body}
    END
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    InvoiceOrderSurcharges    ${order_surcharges}
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${TOTAL_SURCHARGE}    ${total_surcharge}
    Set Test Variable    ${TOTAL_INVOICE}    ${total_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords xác thực
Xác Thực Tổng Tiền Hóa Đơn Trong CSDL
    [Documentation]    Kiểm tra tổng tiền hóa đơn trong CSDL
    [Arguments]    ${invoice_id}    ${expected_total}
    
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_total_rounded}=    Evaluate    round(float(${expected_total}), ${CURRENCY_DECIMAL_PLACE})
    ${actual_total}=    Convert To Number    ${result[0]}
    
    # So sánh với biên độ sai số nhỏ do làm tròn
    ${diff}=    Evaluate    abs(${actual_total} - ${expected_total_rounded})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Tổng tiền hóa đơn không đúng, kỳ vọng ${expected_total_rounded} nhưng nhận được ${actual_total}
    
    RETURN    ${actual_total}
    
Xác Thực Phụ Phí Trong CSDL
    [Documentation]    Kiểm tra phụ phí hóa đơn trong CSDL
    [Arguments]    ${invoice_id}    ${expected_surcharge}
    
    ${query}=    Set Variable    SELECT Surcharge FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_surcharge_rounded}=    Evaluate    round(float(${expected_surcharge}), ${CURRENCY_DECIMAL_PLACE})
    ${actual_surcharge}=    Convert To Number    ${result[0]}
    
    # So sánh với biên độ sai số nhỏ do làm tròn
    ${diff}=    Evaluate    abs(${actual_surcharge} - ${expected_surcharge_rounded})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Phụ phí hóa đơn không đúng, kỳ vọng ${expected_surcharge_rounded} nhưng nhận được ${actual_surcharge}
    
    RETURN    ${actual_surcharge}
    
Xác Thực Thuế VAT Trong CSDL
    [Documentation]    Kiểm tra thuế VAT hóa đơn trong CSDL
    [Arguments]    ${invoice_id}    ${expected_tax}
    
    ${query}=    Set Variable    SELECT TotalTax FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Kiểm tra nếu giá trị là NULL
    Run Keyword If    ${result[0]} == ${None}    Fail    Thuế VAT không được tính cho hóa đơn
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_tax_rounded}=    Evaluate    round(float(${expected_tax}), ${CURRENCY_DECIMAL_PLACE})
    ${actual_tax}=    Convert To Number    ${result[0]}
    
    # So sánh với biên độ sai số nhỏ do làm tròn
    ${diff}=    Evaluate    abs(${actual_tax} - ${expected_tax_rounded})
    ${epsilon}=    Set Variable    0.01
    Should Be True    ${diff} < ${epsilon}    Thuế VAT hóa đơn không đúng, kỳ vọng ${expected_tax_rounded} nhưng nhận được ${actual_tax}
    
    RETURN    ${actual_tax}

# Keywords chuẩn bị dữ liệu mới cho các test case thêm
Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế VAT
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với thuế VAT
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.EnableVATToggle    ${TRUE}
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Price    100000
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Quantity    1
    
    # Thêm thuế VAT cho sản phẩm
    ${tax_detail}=    Deep Copy    ${tax_detail_body}
    ${tax_details}=    Create List    ${tax_detail}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    InvoiceDetailTaxs    ${tax_details}
    
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm combo
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    
    # Thêm sản phẩm combo
    ${combo_detail}=    Deep Copy    ${combo_product_detail_body}
    ${combo_material_1}=    Deep Copy    ${combo_product_1_matterial_1_body}
    ${combo_material_2}=    Deep Copy    ${combo_product_1_matterial_2_body}
    
    # Tạo danh sách thành phần combo
    ${combo_materials}=    Create List    ${combo_material_1}    ${combo_material_2}
    ${combo_detail}=    Update Dictionary Property    ${combo_detail}    ComboProducts    ${combo_materials}
    
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${combo_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Phụ Phí Âm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với phụ phí âm (chiết khấu)
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    
    # Thêm chi tiết sản phẩm
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Price    100000
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Quantity    1
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail}
    
    # Thêm phụ phí âm
    ${surcharge_negative}=    Deep Copy    ${surcharge_item_body}
    ${surcharge_negative}=    Update Dictionary Property    ${surcharge_negative}    Price    -10000
    ${invoice_surcharges}=    Create List    ${surcharge_negative}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceOrderSurcharges    ${invoice_surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Đơn Giá Thập Phân
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với sản phẩm có đơn giá thập phân
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    
    # Thêm chi tiết sản phẩm với giá thập phân
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Price    100000.678
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Quantity    1
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Phức Hợp
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với tất cả các thành phần
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${empty_list} =    Create List
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails       ${empty_list}
    
    # Cập nhật giảm giá hóa đơn
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    20000
    
    # Thêm sản phẩm 1 (có giảm giá)
    ${product_detail1}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id_1}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    ProductId    ${product_id_1}
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    Price    100000
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    Discount    10000
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    Quantity    1
    
    # Thêm sản phẩm 2 (không giảm giá)
    ${product_detail2}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id_2}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_2_CODE}
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    ProductId    ${product_id_2}
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    Price    200000
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    Quantity    1
    
    # Thêm thuế VAT cho cả hai sản phẩm
    ${tax_detail}=    Deep Copy    ${tax_detail_body}
    ${tax_details1}=    Create List    ${tax_detail}
    ${tax_details2}=    Create List    ${tax_detail}
    ${product_detail1}=    Update Dictionary Property    ${product_detail1}    InvoiceDetailTaxs    ${tax_details1}
    ${product_detail2}=    Update Dictionary Property    ${product_detail2}    InvoiceDetailTaxs    ${tax_details2}
    
    # Bật VAT cho hóa đơn
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.EnableVATToggle    ${TRUE}
    
    # Thêm sản phẩm vào request
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail1}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${product_detail2}
    
    # Thêm phụ phí 
    ${surcharge}=    Deep Copy    ${surcharge_item_body}
    ${invoice_surcharges}=    Create List    ${surcharge}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceOrderSurcharges    ${invoice_surcharges}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon ${ma_coupon_campaign}
    [Documentation]  Chuẩn bị dữ liệu hóa đơn áp đợt coupon
   $ 
    ${couponcampaign_id}   ${price_ratio}    ${price_max}   Lấy Thông Tin Coupon Theo Mã Coupon Campaign    ${ma_coupon_campaign}
    ${coupon_id}   ${coupon_code}=    Lấy Id Mã Coupon ở Trạng Thái    ${couponcampaign_id}    Đã Phát Hành
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${coupon_data}=    Deep Copy    ${STANDARD_COUPON}
    ${coupon_data}=  Update Nested Dictionary Property    ${coupon_data}    CouponCampaignId    ${couponcampaign_id}
    ${coupon_data}=  Update Nested Dictionary Property     ${coupon_data}    Id    ${coupon_id}
    ${coupon_data}=  Update Nested Dictionary Property  ${coupon_data}    Code    ${coupon_code}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Coupon    ${coupon_data}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    DiscountByCoupon     5000
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    5000
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${COUPON_CODE}    ${coupon_code}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon ${ma_coupon_campaign} Và Trạng Thái ${status}
    [Documentation]  Chuẩn bị dữ liệu hóa đơn áp đợt coupon
    ${couponcampaign_id}   ${price_ratio}    ${price_max}   Lấy Thông Tin Coupon Theo Mã Coupon Campaign    ${ma_coupon_campaign}
    ${coupon_id}   ${coupon_code}=    Lấy Id Mã Coupon ở Trạng Thái    ${couponcampaign_id}   ${status}
    ${coupon_data}=    Deep Copy    ${STANDARD_COUPON}
    ${coupon_data}=  Update Nested Dictionary Property    ${coupon_data}    CouponCampaignId    ${couponcampaign_id}
    ${coupon_data}=  Update Nested Dictionary Property     ${coupon_data}    Id    ${coupon_id}
    ${coupon_data}=  Update Nested Dictionary Property  ${coupon_data}    Code    ${coupon_code}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Coupon    ${coupon_data}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    DiscountByCoupon     5000
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    5000
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${COUPON_CODE}    ${coupon_code}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Áp Đợt Coupon ${ma_coupon_campaign} Và Giảm Giá ${discount}
    [Documentation]  Chuẩn bị dữ liệu hóa đơn áp đợt coupon và giảm giá
    ${couponcampaign_id}   ${price_ratio}    ${price_max}   Lấy Thông Tin Coupon Theo Mã Coupon Campaign    ${ma_coupon_campaign}
    ${coupon_id}   ${coupon_code}=    Lấy Id Mã Coupon ở Trạng Thái    ${couponcampaign_id}   Đã Phát Hành
    ${coupon_data}=    Deep Copy    ${STANDARD_COUPON}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    CouponCampaignId    ${couponcampaign_id}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    Id    ${coupon_id}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    Code    ${coupon_code}
    ${request}=    Chuẩn Bị Dữ Liệu Cơ Bản Hóa Đơn Với Sản Phẩm ${PRODUCT_1_CODE} 
    ${request_invoice}    Get From Dictionary      ${request}    Invoice
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Coupon    ${coupon_data}
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    DiscountByCoupon     5000
    ${request_invoice}  Update Dictionary Property    ${request_invoice}    Discount    100000
    ${request}  Update Dictionary Property    ${request}    Invoice    ${request_invoice}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${COUPON_CODE}    ${coupon_code}
    RETURN    ${request}



Chuẩn Bị Dữ Liệu Hóa Đơn Đơn Giá ${price} Áp Đợt Coupon ${ma_coupon_campaign}
    ${couponcampaign_id}   ${price_ratio}    ${price_max}   Lấy Thông Tin Coupon Theo Mã Coupon Campaign    ${ma_coupon_campaign}
    ${coupon_id}   ${coupon_code}=    Lấy Id Mã Coupon ở Trạng Thái    ${couponcampaign_id}   Đã Phát Hành
    ${coupon_data}=    Deep Copy    ${STANDARD_COUPON}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    CouponCampaignId    ${couponcampaign_id}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    Id    ${coupon_id}
    ${coupon_data}=    Update Dictionary Property    ${coupon_data}    Code    ${coupon_code}
    ${request}=    Deep Copy    ${invoice_request_body_not_delivery}
    ${product_detail}=    Deep Copy    ${STANDARD_INVOICE_DETAIL}
    ${product_id}=    Lấy Thông Tin Sản Phẩm    ${PRODUCT_1_CODE}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    ProductId    ${product_id}
    ${product_detail}=    Update Dictionary Property    ${product_detail}    Price    ${price}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.InvoiceDetails    ${product_detail}
    ${request}=     Update Nested Dictionary Property     ${request}    Invoice.Coupon    ${coupon_data}
     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountByCoupon     100000
     ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    100000
    Set Test Variable    ${REQUEST_DATA}    ${request}
    Set Test Variable    ${COUPON_CODE}    ${coupon_code}
    RETURN    ${request}




