*** Settings ***
Documentation     Keywords cho test cases API của DiscountTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/DiscountData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${STANDARD_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Cố Định
    ${data}=    Set Variable    ${FIXED_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm
    ${data}=    Set Variable    ${PERCENT_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi
    ${data}=    Set Variable    ${PROMOTION_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher
    ${data}=    Set Variable    ${VOUCHER_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Chiết Khấu
    ${data}=    Set Variable    ${PRODUCT_DISCOUNT_INVOICE_REQUEST}
    @{details}=    Create List    ${PRODUCT_WITH_DISCOUNT}
    Set To Dictionary    ${data['Invoice']}    InvoiceDetails=@{details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Chiết Khấu Phần Trăm
    ${data}=    Set Variable    ${PRODUCT_DISCOUNT_INVOICE_REQUEST}
    @{details}=    Create List    ${PRODUCT_WITH_DISCOUNT_RATE}
    Set To Dictionary    ${data['Invoice']}    InvoiceDetails=@{details}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Kết Hợp
    ${data}=    Set Variable    ${COMBINED_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Voucher Không Kết Hợp
    ${data}=    Set Variable    ${NON_COMBINABLE_VOUCHER_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi Theo Sản Phẩm
    ${data}=    Set Variable    ${PROMOTION_ON_PRODUCT_INVOICE_REQUEST}
    @{promotions}=    Create List    ${PRODUCT_PROMOTION}
    Set To Dictionary    ${data}    Promotions=@{promotions}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Giới Hạn Chiết Khấu Voucher
    ${data}=    Set Variable    ${VOUCHER_MAX_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Làm Tròn
    ${data}=    Set Variable    ${ROUNDING_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm Làm Tròn
    ${data}=    Set Variable    ${ROUNDING_PERCENT_DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Gửi Yêu Cầu Tạo Hóa Đơn    
    ${response}=    Call API    invoices    ${REQUEST_DATA} 
    Set Test Variable    ${RESPONSE}     ${response}

# DB Validation Keywords
Xác Thực Hóa Đơn Trong DB
    [Documentation]    Xác thực hóa đơn tồn tại trong CSDL và các thông tin chi tiết
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

Xác Thực Chiết Khấu Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu hóa đơn không khớp

Xác Thực Tỉ Lệ Chiết Khấu Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_ratio}
    ${query}=    Set Variable    SELECT DiscountRatio FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_ratio}    Tỉ lệ chiết khấu hóa đơn không khớp

Xác Thực Chiết Khấu Khuyến Mãi Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_promotion_discount}
    ${query}=    Set Variable    SELECT DiscountByPromotion FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_promotion_discount}    Chiết khấu khuyến mãi không khớp

Xác Thực Chiết Khấu Voucher Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_voucher_discount}
    ${query}=    Set Variable    SELECT DiscountByCoupon FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_voucher_discount}    Chiết khấu voucher không khớp

Xác Thực Chiết Khấu Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu sản phẩm không khớp

Xác Thực Tỉ Lệ Chiết Khấu Sản Phẩm
    [Arguments]    ${invoice_id}    ${product_id}    ${expected_ratio}
    ${query}=    Set Variable    SELECT DiscountRatio FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_ratio}    Tỉ lệ chiết khấu sản phẩm không khớp

Xác Thực Thông Tin Khuyến Mãi
    [Arguments]    ${invoice_id}    ${promotion_type}
    ${query}=    Set Variable    SELECT Type FROM InvoicePromotion WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Thông tin khuyến mãi không tồn tại trong CSDL
    Should Be Equal    ${result[0]}    ${promotion_type}    Loại khuyến mãi không khớp

Xác Thực Thông Tin Voucher
    [Arguments]    ${invoice_id}    ${voucher_code}
    ${query}=    Set Variable    SELECT CouponCode FROM InvoiceVoucher WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Thông tin voucher không tồn tại trong CSDL
    Should Be Equal    ${result[0]}    ${voucher_code}    Mã voucher không khớp

Xác Thực Tổng Tiền Sau Chiết Khấu
    [Arguments]    ${invoice_id}    ${expected_total}
    ${query}=    Set Variable    SELECT Total, SubTotal, Discount, DiscountByPromotion, DiscountByCoupon FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    
    # Tính tổng tiền sau khi trừ các loại chiết khấu
    ${total}=    Set Variable    ${result[0]}
    ${subtotal}=    Set Variable    ${result[1]}
    ${discount}=    Set Variable    ${result[2]}
    ${promotion_discount}=    Set Variable    ${result[3]}
    ${voucher_discount}=    Set Variable    ${result[4]}
    
    # Tổng tiền phải bằng tổng tiền hàng trừ đi các loại chiết khấu
    ${calculated_total}=    Evaluate    ${subtotal} - ${discount} - ${promotion_discount} - ${voucher_discount}
    Should Be Equal As Numbers    ${calculated_total}    ${expected_total}    Tổng tiền sau chiết khấu không khớp 