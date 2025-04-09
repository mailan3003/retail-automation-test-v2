*** Settings ***
Documentation     Keywords for Gift Processing API Tests
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/CommonInvoiceData.robot
Resource          ../../TestData/Invoice/GiftProcessingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Resource          ../Utilities/DataUtilities.robot
Library           ../../Resources/DatabaseLibrary.py
Library           json

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng sản phẩm
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_PRODUCT_GIFT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Sản Phẩm Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng sản phẩm theo sản phẩm cụ thể
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_PRODUCT_GIFT_BY_PRODUCT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Voucher
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng voucher
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_VOUCHER_GIFT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Voucher Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng voucher theo sản phẩm cụ thể
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_VOUCHER_GIFT_BY_PRODUCT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Điểm
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng điểm thưởng
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_POINT_GIFT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Điểm Theo Sản Phẩm
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng điểm thưởng theo sản phẩm cụ thể
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_POINT_GIFT_BY_PRODUCT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Quà Tặng
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với nhiều loại quà tặng cùng lúc
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_MULTIPLE_GIFTS}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Quà Tặng Số Lượng Lớn
    [Arguments]    ${quantity}=3
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với quà tặng sản phẩm số lượng lớn
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_LARGE_QUANTITY_GIFT}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    
    # Cập nhật số lượng quà tặng trong promotion data
    ${promotions}=    Get From Dictionary    ${invoice_request}    SalePromotions
    ${promotion}=    Get From List    ${promotions}    0
    ${promotion_data}=    Get From Dictionary    ${promotion}    PromotionData
    ${gift_products}=    Get From Dictionary    ${promotion_data}    GiftProducts
    ${gift_product}=    Get From List    ${gift_products}    0
    Set To Dictionary    ${gift_product}    Quantity=${quantity}
    
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Voucher
    [Arguments]    ${quantity}=3
    [Documentation]    Chuẩn bị dữ liệu cho hóa đơn với nhiều voucher quà tặng
    ${invoice_request}=    Set Variable    ${INVOICE_WITH_MULTIPLE_VOUCHERS}
    ${invoice_code}=    Generate Random String    10    [LETTERS][NUMBERS]
    Set To Dictionary    ${invoice_request}    Code=HD_TEST_GIFT_${invoice_code}
    
    # Cập nhật số lượng voucher trong promotion data
    ${promotions}=    Get From Dictionary    ${invoice_request}    SalePromotions
    ${promotion}=    Get From List    ${promotions}    0
    ${promotion_data}=    Get From Dictionary    ${promotion}    PromotionData
    Set To Dictionary    ${promotion_data}    VoucherQuantity=${quantity}
    
    Set Test Variable    ${INVOICE_REQUEST}    ${invoice_request}

Gửi Yêu Cầu Tạo Hóa Đơn Với Quà Tặng
    [Documentation]    Gửi yêu cầu API để tạo hóa đơn với quà tặng
    ${response}=    Call API    invoices    ${INVOICE_REQUEST}
    Set Test Variable    ${RESPONSE}    ${response}
    
    # Lấy ID của hóa đơn vừa tạo từ response
    ${invoice_id}=    Get From Response    Id
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}

Xác Thực Quà Tặng Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng đã được thêm vào hóa đơn với giá 0đ
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra số lượng
    ${actual_quantity}=    Set Variable    ${results[0][4]}
    Should Be Equal As Numbers    ${actual_quantity}    ${expected_quantity}
    
    # Kiểm tra ghi chú sản phẩm
    ${query}=    Set Variable    SELECT Note FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    ${note}=    Set Variable    ${results[0][0]}
    Should Contain    ${note}    Quà tặng từ khuyến mãi

Xác Thực Quà Tặng Sản Phẩm Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=1
    [Documentation]    Kiểm tra sản phẩm quà tặng theo sản phẩm đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    6    Type khuyến mãi không phải ProductGift

Xác Thực Ghi Chú Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}
    [Documentation]    Kiểm tra ghi chú quà tặng trong chi tiết hóa đơn
    ${query}=    Set Variable    SELECT Note FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    ${note}=    Set Variable    ${results[0][0]}
    Should Contain    ${note}    Quà tặng từ khuyến mãi

Xác Thực Quà Tặng Voucher
    [Arguments]    ${invoice_id}    ${expected_value}=50000    ${expected_quantity}=1
    [Documentation]    Kiểm tra voucher quà tặng đã được tạo và liên kết với hóa đơn
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? AND v.Value = ?
    ${results}=    Query Database    ${query}    ${invoice_id}    ${expected_value}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng
    
    # Kiểm tra trạng thái voucher
    ${query}=    Set Variable    SELECT Status FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? LIMIT 1
    ${results}=    Query Database    ${query}    ${invoice_id}
    ${status}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${status}    1    Trạng thái voucher không phải là Kích hoạt

Xác Thực Quà Tặng Voucher Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_value}=50000    ${expected_quantity}=1
    [Documentation]    Kiểm tra voucher quà tặng theo sản phẩm đã được tạo và liên kết
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ? AND v.Value = ?
    ${results}=    Query Database    ${query}    ${invoice_id}    ${expected_value}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    10    Type khuyến mãi không phải ProductVoucherGift

Xác Thực Quà Tặng Điểm
    [Arguments]    ${invoice_id}    ${expected_points}=20
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    4    Type khuyến mãi không phải InvoicePointGift

Xác Thực Quà Tặng Điểm Theo Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_points}=15
    [Documentation]    Kiểm tra điểm thưởng khuyến mãi theo sản phẩm đã được thêm vào hóa đơn
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra type khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT PromotionType FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin khuyến mãi
    ${promotion_type}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_type}    7    Type khuyến mãi không phải ProductPointGift

Xác Thực Nhiều Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_points}=20
    [Documentation]    Kiểm tra nhiều loại quà tặng đã được thêm vào hóa đơn
    # Kiểm tra sản phẩm quà tặng
    ${query}=    Set Variable    SELECT * FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    
    # Kiểm tra điểm thưởng
    ${query}=    Set Variable    SELECT PromotionPoint FROM Invoice WHERE Id = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    Should Not Be Empty    ${results}    Không tìm thấy thông tin điểm thưởng
    ${promotion_points}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${promotion_points}    ${expected_points}    Số điểm thưởng không đúng
    
    # Kiểm tra có nhiều loại khuyến mãi trong bảng InvoicePromotion
    ${query}=    Set Variable    SELECT COUNT(DISTINCT PromotionType) FROM InvoicePromotion WHERE InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    2    Không có đủ loại khuyến mãi

Xác Thực Số Lượng Quà Tặng
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_quantity}=3
    [Documentation]    Kiểm tra số lượng sản phẩm quà tặng
    ${query}=    Set Variable    SELECT Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ? AND Price = 0
    ${results}=    Query Database    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Empty    ${results}    Không tìm thấy sản phẩm quà tặng trong hóa đơn
    ${quantity}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${quantity}    ${expected_quantity}    Số lượng quà tặng không đúng

Xác Thực Số Lượng Voucher
    [Arguments]    ${invoice_id}    ${expected_quantity}=3
    [Documentation]    Kiểm tra số lượng voucher quà tặng
    ${query}=    Set Variable    SELECT COUNT(*) FROM Voucher v JOIN InvoiceVoucher iv ON v.Id = iv.VoucherId WHERE iv.InvoiceId = ?
    ${results}=    Query Database    ${query}    ${invoice_id}
    ${count}=    Set Variable    ${results[0][0]}
    Should Be Equal As Numbers    ${count}    ${expected_quantity}    Số lượng voucher không đúng

Get From Response
    [Documentation]    Extrait une valeur de la réponse JSON
    [Arguments]    ${property_name}
    ${response_json}=    Evaluate    json.loads('''${RESPONSE.content.decode('utf-8')}''')
    ${value}=    Get From Dictionary    ${response_json}    ${property_name}
    RETURN    ${value} 