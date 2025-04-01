*** Settings ***
Documentation     Keywords cho test cases API của DataProcessingTest
Resource          ../../TestData/CommonData.robot
Resource          ../../TestData/Invoice/DataProcessingData.robot
Resource          ../Utilities/RequestHelper.robot
Resource          ../Utilities/ResponseHelper.robot
Resource          ../Utilities/Utilities.robot
Library           ../../Resources/DatabaseLibrary.py

*** Keywords ***
Chuẩn Bị Dữ Liệu Hóa Đơn Tiêu Chuẩn
    ${data}=    Set Variable    ${STANDARD_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Làm Tròn Lên
    @{details}=    Create List    ${ROUNDING_UP_PRODUCT}
    ${invoice}=    Set Variable    ${ROUNDING_UP_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${ROUNDING_UP_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Làm Tròn Xuống
    @{details}=    Create List    ${ROUNDING_DOWN_PRODUCT}
    ${invoice}=    Set Variable    ${ROUNDING_DOWN_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${ROUNDING_DOWN_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thuế
    @{details}=    Create List    ${PRODUCT_WITH_TAX}
    ${invoice}=    Set Variable    ${TAX_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${TAX_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Phần Trăm
    @{details}=    Create List    ${PERCENT_DISCOUNT_PRODUCT}
    ${invoice}=    Set Variable    ${DISCOUNT_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Chiết Khấu Cố Định
    @{details}=    Create List    ${FIXED_DISCOUNT_PRODUCT}
    ${invoice}=    Set Variable    ${DISCOUNT_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${DISCOUNT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khuyến Mãi
    ${data}=    Set Variable    ${PROMOTION_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Phương Thức Thanh Toán
    ${data}=    Set Variable    ${MULTIPLE_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Cập Nhật Tồn Kho
    @{details}=    Create List    ${INVENTORY_UPDATE_PRODUCT}
    ${invoice}=    Set Variable    ${INVENTORY_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${INVENTORY_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ
    ${data}=    Set Variable    ${DEBT_CUSTOMER_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ Vượt Hạn Mức
    ${data}=    Set Variable    ${DEBT_LIMIT_CUSTOMER_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Khách Hàng Nợ Không Cảnh Báo
    ${data}=    Set Variable    ${DEBT_WARNING_OFF_CUSTOMER_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Sản Phẩm Combo
    @{details}=    Create List    ${COMBO_PRODUCT_DETAILS}
    ${invoice}=    Set Variable    ${COMBO_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{details}
    ${data}=    Set Variable    ${COMBO_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Điểm Thưởng Theo Hóa Đơn
    ${data}=    Set Variable    ${POINT_REWARD_TYPE_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Điểm Thưởng Theo Sản Phẩm
    ${data}=    Set Variable    ${POINT_REWARD_TYPE_PRODUCT_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thanh Toán Bằng Điểm
    ${data}=    Set Variable    ${POINT_PAYMENT_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tiền Thừa
    ${data}=    Set Variable    ${INVOICE_WITH_EXCESS_PAYMENT_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Tự Động Phân Bổ Thanh Toán
    ${data}=    Set Variable    ${PAYMENT_ALLOCATION_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Thông Báo Zalo
    ${data}=    Set Variable    ${ZALO_NOTIFICATION_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Chuẩn Bị Dữ Liệu Hóa Đơn Với Nhiều Sản Phẩm
    ${invoice}=    Set Variable    ${MULTIPLE_PRODUCTS_INVOICE}
    Set To Dictionary    ${invoice}    InvoiceDetails=@{MULTIPLE_PRODUCTS_DETAILS}
    ${data}=    Set Variable    ${MULTIPLE_PRODUCTS_INVOICE_REQUEST}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    RETURN     ${data}

Gửi Yêu Cầu Tạo Hóa Đơn
    ${response}=    Call API    invoices    ${REQUEST_DATA}
    Set Test Variable    ${RESPONSE}     ${response}

# Các hàm kiểm tra kết quả với DB
Xác Thực Hóa Đơn Trong DB
    [Documentation]    Xác thực hóa đơn tồn tại trong CSDL và các thông tin chi tiết
    ${invoice_id}=    Set Variable    ${RESPONSE.json()["Id"]}
    Set Test Variable    ${INVOICE_ID}    ${invoice_id}
    Xác Thực Hóa Đơn Tồn Tại    ${invoice_id}

Xác Thực Hóa Đơn Tồn Tại
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT Id FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL

Xác Thực Chi Tiết Hóa Đơn
    [Arguments]    ${invoice_id}    ${product_id}    ${quantity}
    ${query}=    Set Variable    SELECT InvoiceId, ProductId, Quantity FROM InvoiceDetail WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Chi tiết hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${quantity}    Số lượng sản phẩm không khớp

Xác Thực Tổng Tiền Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_total}
    ${query}=    Set Variable    SELECT Total FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng tiền hóa đơn không khớp

Xác Thực Thuế Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_vat}
    ${query}=    Set Variable    SELECT VAT, IsVAT FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_vat}    Thuế VAT không khớp
    Should Be Equal As Numbers    ${result[1]}    1    Cờ thuế VAT không được bật

Xác Thực Chiết Khấu Hóa Đơn
    [Arguments]    ${invoice_id}    ${expected_discount}
    ${query}=    Set Variable    SELECT Discount FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${expected_discount}    Chiết khấu hóa đơn không khớp

Xác Thực Khuyến Mãi Hóa Đơn
    [Arguments]    ${invoice_id}    ${promotion_id}
    ${query}=    Set Variable    SELECT PromotionId FROM Invoice WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Hóa đơn không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[0]}    ${promotion_id}    ID khuyến mãi không khớp

Xác Thực Thanh Toán Hóa Đơn
    [Arguments]    ${invoice_id}    ${method}    ${amount}
    ${query}=    Set Variable    SELECT InvoiceId, Method, Value FROM Payment WHERE InvoiceId = ? AND Method = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${method}
    Should Not Be Equal    ${result}    None    Thanh toán không tồn tại trong CSDL
    Should Be Equal As Numbers    ${result[2]}    ${amount}    Số tiền thanh toán không khớp

Xác Thực Nhiều Phương Thức Thanh Toán
    [Arguments]    ${invoice_id}
    ${query}=    Set Variable    SELECT COUNT(*) FROM Payment WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có thanh toán trong CSDL
    Should Be True    ${result[0]} > 1    Không có nhiều phương thức thanh toán

Xác Thực Cập Nhật Tồn Kho
    [Arguments]    ${invoice_id}    ${product_id}    ${quantity}
    Xác Thực Chi Tiết Hóa Đơn    ${invoice_id}    ${product_id}    ${quantity}
    
    ${query}=    Set Variable    SELECT QuantitySold FROM InventoryHistory WHERE InvoiceId = ? AND ProductId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
    Should Not Be Equal    ${result}    None    Không có lịch sử cập nhật tồn kho
    Should Be Equal As Numbers    ${result[0]}    ${quantity}    Số lượng bán không khớp

Xác Thực Công Nợ Khách Hàng
    [Arguments]    ${invoice_id}    ${customer_id}    ${expected_debt}
    ${query}=    Set Variable    SELECT Debt FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Khách hàng không tồn tại trong CSDL
    
    ${query}=    Set Variable    SELECT Total, TotalPayment FROM Invoice WHERE Id = ?
    ${invoice}=    Fetch One    ${query}    ${invoice_id}
    ${invoice_debt}=    Evaluate    ${invoice[0]} - ${invoice[1]}
    
    ${total_debt}=    Evaluate    ${result[0]}
    Should Be True    ${total_debt} >= ${expected_debt}    Nợ khách hàng không khớp

Xác Thực Sản Phẩm Combo
    [Arguments]    ${invoice_id}    ${combo_id}
    # Xác thực combo chính
    Xác Thực Chi Tiết Hóa Đơn    ${invoice_id}    ${combo_id}    1
    
    # Xác thực sản phẩm con trong combo
    ${query}=    Set Variable    SELECT COUNT(*) FROM ComboMapping WHERE ProductId = ?
    ${result}=    Fetch One    ${query}    ${combo_id}
    Should Not Be Equal    ${result}    None    Không tìm thấy mapping combo
    Should Be True    ${result[0]} > 0    Combo không có sản phẩm con
    
    # Xác thực tồn kho của sản phẩm con đã được cập nhật
    ${query}=    Set Variable    SELECT ProductId FROM ComboMapping WHERE ProductId = ?
    ${combo_items}=    Fetch All    ${query}    ${combo_id}
    
    FOR    ${item}    IN    @{combo_items}
        ${product_id}=    Set Variable    ${item[0]}
        ${query}=    Set Variable    SELECT Value FROM InventoryTracking WHERE DocumentId = ? AND ProductId = ? AND DocumentType = 3
        ${result}=    Fetch One    ${query}    ${invoice_id}    ${product_id}
        Should Not Be Equal    ${result}    None    Không có cập nhật tồn kho cho sản phẩm con ${product_id}
    END

Xác Thực Điểm Tích Lũy Của Khách Hàng
    [Arguments]    ${invoice_id}    ${customer_id}    ${expected_points}
    # Kiểm tra điểm đã được cộng vào khách hàng
    ${query}=    Set Variable    SELECT Point FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Khách hàng không tồn tại trong CSDL
    ${customer_points}=    Set Variable    ${result[0]}
    Should Be True    ${customer_points} >= ${expected_points}    Điểm tích lũy khách hàng không khớp
    
    # Kiểm tra PointTracking
    ${query}=    Set Variable    SELECT Value FROM PointTracking WHERE DocumentId = ? AND DocumentType = 1
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có tracking điểm tích lũy
    Should Be Equal As Numbers    ${result[0]}    ${expected_points}    Điểm tích lũy không khớp

Xác Thực Thanh Toán Bằng Điểm
    [Arguments]    ${invoice_id}    ${customer_id}    ${points_used}
    # Kiểm tra đã tạo payment với method = Point
    ${query}=    Set Variable    SELECT Value, PointUsed FROM Payment WHERE InvoiceId = ? AND Method = 'Point'
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có thanh toán bằng điểm
    
    # Kiểm tra tracking sử dụng điểm
    ${query}=    Set Variable    SELECT Value FROM PointTracking WHERE DocumentId = ? AND DocumentType = 2
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có tracking sử dụng điểm
    Should Be Equal As Numbers    ${result[0]}    -${points_used}    Số điểm sử dụng không khớp

Xác Thực Tiền Thừa
    [Arguments]    ${invoice_id}    ${customer_id}
    # Kiểm tra payment âm với tiền thừa
    ${query}=    Set Variable    SELECT Method, Value FROM Payment WHERE InvoiceId = ? AND Value < 0
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có payment ghi nhận tiền thừa
    
    # Kiểm tra CustomerSurplus
    ${query}=    Set Variable    SELECT CustomerSurplus FROM Customer WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${customer_id}
    Should Not Be Equal    ${result}    None    Khách hàng không tồn tại trong CSDL
    Should Be True    ${result[0]} > 0    Tiền thừa không được cập nhật vào khách hàng

Xác Thực Phân Bổ Thanh Toán
    [Arguments]    ${invoice_id}    ${payment_id}
    # Kiểm tra có tạo PaymentAllocation
    ${query}=    Set Variable    SELECT COUNT(*) FROM PaymentAllocation WHERE PaymentId = ?
    ${result}=    Fetch One    ${query}    ${payment_id}
    Should Not Be Equal    ${result}    None    Không có thông tin phân bổ thanh toán
    Should Be True    ${result[0]} > 0    Không có phân bổ thanh toán
    
    # Kiểm tra PaymentAllocationStatus đã được cập nhật
    ${query}=    Set Variable    SELECT PaymentAllocationStatus FROM Payment WHERE Id = ?
    ${result}=    Fetch One    ${query}    ${payment_id}
    Should Not Be Equal    ${result}    None    Payment không tồn tại
    Should Be Equal As Numbers    ${result[0]}    1    Trạng thái phân bổ thanh toán không được cập nhật

Xác Thực Thông Báo Zalo
    [Arguments]    ${invoice_id}    ${customer_id}
    # Kiểm tra có ghi log ZaloMessageLog
    ${query}=    Set Variable    SELECT COUNT(*) FROM ZaloMessageLog WHERE DocumentId = ? AND DocumentType = 'Invoice'
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không thể kiểm tra log thông báo Zalo
    Should Be True    ${result[0]} > 0    Không có log thông báo Zalo

Xác Thực Tổng Nhiều Sản Phẩm
    [Arguments]    ${invoice_id}    ${expected_total}
    # Xác thực tổng tiền hóa đơn
    Xác Thực Tổng Tiền Hóa Đơn    ${invoice_id}    ${expected_total}
    
    # Xác thực tổng số lượng sản phẩm 
    ${query}=    Set Variable    SELECT COUNT(*) FROM InvoiceDetail WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không có chi tiết hóa đơn
    Should Be Equal As Numbers    ${result[0]}    2    Số lượng sản phẩm không đúng
    
    # Tính tổng từ chi tiết và so sánh với tổng hóa đơn
    ${query}=    Set Variable    SELECT SUM(Quantity * Price) FROM InvoiceDetail WHERE InvoiceId = ?
    ${result}=    Fetch One    ${query}    ${invoice_id}
    Should Not Be Equal    ${result}    None    Không thể tính tổng từ chi tiết
    Should Be Equal As Numbers    ${result[0]}    ${expected_total}    Tổng tiền từ chi tiết không khớp với tổng hóa đơn 