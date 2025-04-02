*** Settings ***
Documentation     Keywords cho test cases API xử lý giảm giá hóa đơn
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/DiscountProcessingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           Collections
Library           String
Library           json

*** Keywords ***
# Keywords chuẩn bị dữ liệu
Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Cơ Bản
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá cơ bản
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá ${discount_amount} Và Tỷ Lệ Giảm ${discount_ratio}
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giá trị và tỷ lệ giảm giá tùy chỉnh
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật giá trị giảm giá và tỷ lệ giảm
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount_amount}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    ${discount_ratio}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm Và Giảm Giá
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với nhiều sản phẩm và giảm giá
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${detail_2}=    Deep Copy    ${INVOICE_DETAIL_200K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_2}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 0 Và Tỷ Lệ Giảm 0
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá 0 đồng và tỷ lệ 0%
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật giá trị giảm giá và tỷ lệ giảm thành 0
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    0
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    0
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Khuyến Mãi
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá từ khuyến mãi
    ${request}=    Deep Copy    ${PROMOTION_DISCOUNT_INVOICE_REQUEST}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    # Thêm thông tin khuyến mãi
    ${promotion_1}=    Deep Copy    ${PROMOTION_INFO_1}
    ${request}=    Add List Item    ${request}    Invoice.InvoicePromotions    ${promotion_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Khuyến Mãi Nhiều Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá từ khuyến mãi và nhiều sản phẩm
    ${request}=    Deep Copy    ${PROMOTION_DISCOUNT_INVOICE_REQUEST}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${detail_2}=    Deep Copy    ${INVOICE_DETAIL_200K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_2}
    
    # Thêm thông tin khuyến mãi
    ${promotion_1}=    Deep Copy    ${PROMOTION_INFO_1}
    ${request}=    Add List Item    ${request}    Invoice.InvoicePromotions    ${promotion_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá Thập Phân
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá có giá trị thập phân
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật giá trị giảm giá thập phân
    ${discount_decimal}=    Set Variable    10500.75
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${discount_decimal}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tỷ Lệ Giảm Giá Thập Phân
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với tỷ lệ giảm giá có giá trị thập phân
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật tỷ lệ giảm giá thập phân
    ${discount_ratio_decimal}=    Set Variable    10.5678
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    ${discount_ratio_decimal}
    
    # Tính lại giá trị giảm giá dựa trên tỷ lệ mới
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    ${new_discount}=    Evaluate    ${PRODUCT_PRICE_100K} * ${discount_ratio_decimal} / 100
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${new_discount}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 150000 Và Tỷ Lệ Giảm 150
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá lớn hơn giá trị sản phẩm
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật giá trị giảm giá và tỷ lệ giảm
    ${large_discount}=    Set Variable    150000
    ${large_ratio}=    Set Variable    150
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${large_discount}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    ${large_ratio}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giảm Giá 100000 Và Tỷ Lệ Giảm 100
    [Documentation]    Chuẩn bị dữ liệu hóa đơn với giảm giá bằng 100% giá trị sản phẩm
    ${request}=    Deep Copy    ${DISCOUNT_INVOICE_REQUEST}
    
    # Cập nhật giá trị giảm giá và tỷ lệ giảm
    ${full_discount}=    Set Variable    100000
    ${full_ratio}=    Set Variable    100
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.Discount    ${full_discount}
    ${request}=    Update Nested Dictionary Property    ${request}    Invoice.DiscountRatio    ${full_ratio}
    
    # Thêm chi tiết sản phẩm vào hóa đơn
    ${detail_1}=    Deep Copy    ${INVOICE_DETAIL_100K}
    ${request}=    Add List Item    ${request}    Invoice.InvoiceDetails    ${detail_1}
    
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

# Keywords thực thi API
Gửi Yêu Cầu Tạo Hóa Đơn Với Giảm Giá
    [Documentation]    Gửi yêu cầu tạo hóa đơn với giảm giá
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

# Keywords xác thực
Xác Thực Giảm Giá Hóa Đơn Trong CSDL
    [Documentation]    Kiểm tra giá trị giảm giá hóa đơn trong CSDL
    [Arguments]    ${invoice_id}    ${expected_discount}
    
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Làm tròn giá trị mong đợi theo cấu hình số chữ số thập phân
    ${expected_discount_rounded}=    Evaluate    round(${expected_discount}, ${CURRENCY_DECIMAL_PLACE})
    ${actual_discount}=    Convert To Number    ${result[0]}
    
    Should Be Equal    ${actual_discount}    ${expected_discount_rounded}    Giá trị giảm giá không đúng
    RETURN    ${actual_discount}

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