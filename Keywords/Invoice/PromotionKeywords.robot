*** Settings ***
Documentation     Keywords cho test cases API phần áp dụng khuyến mãi
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py

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

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định
    ${request}     Deep Copy    ${invoice_request_body_not_delivery} 
    ${data_product}=    Set Variable    ${STANDARD_INVOICE_DETAIL} 
    ${data_product}=    Update Nested Dictionary Property     ${data_product}    Quantity    10
    Log    ${request}
    ${request}=    Update Nested Dictionary Property     ${request}     Invoice.InvoiceDetails  ${data_product}
    Set Test Variable    ${REQUEST_DATA}    ${request}
    RETURN    ${request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm
    [Arguments]    ${percent_value}=10    ${max_value}=50000
    ${data}=    Set Variable    ${PERCENTAGE_PROMOTION_REQUEST}
    # Cập nhật giá trị phần trăm khuyến mãi
    Set To Dictionary    ${data.Promotions}    Value=${percent_value}    MaxDiscountValue=${max_value}
    # Tính toán giá trị khuyến mãi dự kiến
    ${base_amount}=    Set Variable    ${100000}
    ${discount_amount}=    Evaluate    ${base_amount} * ${percent_value} / 100
    # Kiểm tra xem giá trị có vượt quá giá trị tối đa không
    ${actual_discount}=    Set Variable If    ${discount_amount} > ${max_value}    ${max_value}    ${discount_amount}
    Set To Dictionary    ${data.Invoice}    DiscountByPromotion=${actual_discount}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Có Điều Kiện Tổng Tối Thiểu
    [Arguments]    ${min_subtotal}=200000    ${invoice_total}=200000    ${promotion_value}=20000
    ${data}=    Set Variable    ${MIN_SUBTOTAL_PROMOTION_REQUEST}
    # Cập nhật điều kiện tối thiểu
    Set To Dictionary    ${data.Promotions}    MinSubtotalCondition=${min_subtotal}    Value=${promotion_value}
    # Cập nhật tổng tiền hóa đơn
    Set To Dictionary    ${data.Invoice}    Total=${invoice_total}    SubTotal=${invoice_total}    DiscountByPromotion=${promotion_value}
    # Cập nhật giá sản phẩm để phù hợp với tổng tiền
    ${details}=    Set Variable    ${data.Invoice.InvoiceDetails}
    Set To Dictionary    ${details[0]}    Price=${invoice_total}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng
    [Arguments]    ${customer_group_id}=1001    ${promotion_value}=15000
    ${data}=    Set Variable    ${CUSTOMER_GROUP_PROMOTION_REQUEST}
    # Cập nhật nhóm khách hàng và giá trị khuyến mãi
    Set To Dictionary    ${data.Promotions}    CustomerGroupIds=${customer_group_id}    Value=${promotion_value}
    Set To Dictionary    ${data.Invoice}    CustomerGroupId=${customer_group_id}    DiscountByPromotion=${promotion_value}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Sản Phẩm
    [Arguments]    ${product_id}=${PRODUCT_1}    ${promotion_value}=10000
    ${data}=    Set Variable    ${PRODUCT_PROMOTION_REQUEST}
    # Cập nhật thông tin sản phẩm và giá trị khuyến mãi
    Set To Dictionary    ${data.Promotions}    ApplyForProductIds=${product_id}    Value=${promotion_value}
    
    # Tính lại tổng tiền sau khi áp dụng khuyến mãi
    ${product_price}=    Set Variable    ${100000}
    ${total_after_discount}=    Evaluate    ${product_price} - ${promotion_value}
    Set To Dictionary    ${data.Invoice}    Total=${total_after_discount}
    
    # Tạo chi tiết hóa đơn
    ${detail_promotion}=    Create Dictionary    
    ...    Type=PROMOTION_INVOICE_DISCOUNT_ON_PRODUCT    
    ...    Value=${promotion_value}    
    ...    ProductId=${product_id}
    
    @{promotions}=    Create List    ${detail_promotion}
    Set To Dictionary    ${data}    InvoiceDetailPromotions=@{promotions}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Mua X Tặng Y
    [Arguments]    ${min_quantity}=2    ${gift_ratio}=1
    ${data}=    Set Variable    ${BUY_X_GET_Y_PROMOTION_REQUEST}
    # Cập nhật thông tin điều kiện và tỷ lệ
    Set To Dictionary    ${data.Promotions}    MinQuantityCondition=${min_quantity}    Value=${gift_ratio}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Sản Phẩm
    [Arguments]    ${gift_product_id}=${PRODUCT_2}    ${gift_quantity}=1
    ${data}=    Set Variable    ${PRODUCT_GIFT_PROMOTION_REQUEST}
    # Cập nhật thông tin sản phẩm quà tặng
    Set To Dictionary    ${data.Promotions}    GiftProductId=${gift_product_id}    GiftQuantity=${gift_quantity}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher
    [Arguments]    ${voucher_value}=50000    ${voucher_quantity}=1
    ${data}=    Set Variable    ${VOUCHER_GIFT_PROMOTION_REQUEST}
    # Cập nhật thông tin voucher
    Set To Dictionary    ${data.Promotions}    VoucherValue=${voucher_value}    VoucherQuantity=${voucher_quantity}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Khuyến Mãi
    [Arguments]    ${promotion_id_1}=${promotion_1}    ${promotion_id_2}=${promotion_2}
    ${data}=    Set Variable    ${MULTIPLE_PROMOTIONS_REQUEST}
    
    # Tạo các khuyến mãi
    ${promo1}=    Set Variable    ${PROMOTION_1}
    ${promo2}=    Set Variable    ${PROMOTION_2}
    
    @{promotions}=    Create List    ${promo1}    ${promo2}
    Set To Dictionary    ${data}    Promotions=@{promotions}
    
    # Tính tổng chiết khấu từ các khuyến mãi
    ${total_discount}=    Evaluate    ${promo1['Value']} + ${promo2['Value']}
    Set To Dictionary    ${data.Invoice}    DiscountByPromotion=${total_discount}
    
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Hết Hạn
    ${data}=    Set Variable    ${FIXED_PROMOTION_REQUEST}
    Set To Dictionary    ${data.Promotions}    Id=${EXPIRED_PROMOTION_ID}    StartDate=2022-01-01    EndDate=2022-12-31
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Không Hoạt Động
    ${data}=    Set Variable    ${FIXED_PROMOTION_REQUEST}
    Set To Dictionary    ${data.Promotions}    Id=${INACTIVE_PROMOTION_ID}    Status=0    IsActive=False
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN    ${data}

# ==============================================
# API Request Keywords
# ==============================================

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}    ${response}
    RETURN    ${response}

# ==============================================
# Verification Keywords
# ==============================================

Xác Thực Chiết Khấu Khuyến Mãi Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT DiscountByPromotion FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu khuyến mãi không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}

Xác Thực ID Khuyến Mãi Trong Hóa Đơn
    [Arguments]    ${invoice_id}    ${promotion_id}
    ${query}=    Set Variable    SELECT PromotionId FROM Invoice WHERE Id = ?
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
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT Value FROM InvoiceDetailPromotion WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy thông tin khuyến mãi cho sản phẩm trong hóa đơn ID ${invoice_id} trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Giá trị khuyến mãi theo sản phẩm không chính xác. Mong đợi: ${expected_discount}, Thực tế: ${result[0]}

Xác Thực Sản Phẩm Quà Tặng
    [Arguments]    ${invoice_id}    ${gift_product_id}    ${gift_quantity}=1
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
# Keywords with embedded parameters (for more readable tests)
# ==============================================

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giảm ${discount_value} Đồng
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giá Trị Cố Định    ${discount_value}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Giảm ${percent_value} Phần Trăm Và Giới Hạn Tối Đa ${max_value} Đồng
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Phần Trăm    ${percent_value}    ${max_value}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Điều Kiện Tổng Tối Thiểu ${min_subtotal} Đồng Và Giảm ${discount_value} Đồng
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Có Điều Kiện Tổng Tối Thiểu    ${min_subtotal}    ${min_subtotal}    ${discount_value}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng ${customer_group_id} Giảm ${discount_value} Đồng
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Cho Nhóm Khách Hàng    ${customer_group_id}    ${discount_value}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Mua ${min_quantity} Tặng ${gift_quantity} Cho Sản Phẩm ${product_id}
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Mua X Tặng Y    ${min_quantity}    ${gift_quantity}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Sản Phẩm ${gift_product_id} Với Số Lượng ${gift_quantity}
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Sản Phẩm    ${gift_product_id}    ${gift_quantity}
    RETURN    ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher Trị Giá ${voucher_value} Đồng
    ${data}=    Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Tặng Voucher    ${voucher_value}    1
    RETURN    ${data}

Giá Trị Chiết Khấu Khuyến Mãi Trong Hóa Đơn Là ${expected_discount} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Chiết Khấu Khuyến Mãi Trong Hóa Đơn    ${invoice_id}    ${expected_discount}

ID Khuyến Mãi Trong Hóa Đơn Là ${promotion_id}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực ID Khuyến Mãi Trong Hóa Đơn    ${invoice_id}    ${promotion_id}

Thông Tin Khuyến Mãi Có Loại ${promotion_type}
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Thông Tin Khuyến Mãi    ${invoice_id}    ${promotion_type}

Sản Phẩm ${product_id} Có Khuyến Mãi ${expected_discount} Đồng
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Xác Thực Khuyến Mãi Theo Sản Phẩm    ${invoice_id}    ${product_id}    ${expected_discount}

Sản Phẩm Quà Tặng ${gift_product_id} Có Trong Hóa Đơn Với Số Lượng ${gift_quantity}
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