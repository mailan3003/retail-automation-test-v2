*** Settings ***
Documentation     Test API hoàn thiện đơn hàng - Comprehensive test cases for order completion functionality
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CompleteOrderKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../TestData/Order/CompleteOrderData.robot
Resource          ../../../TestData/CommonData.robot

*** Test Cases ***
# =============================================================================
# Test Cases Thành Công - Hoàn thiện đơn hàng cơ bản
# =============================================================================

RT-ORDER-COMPLETE-001 Hoàn Thiện Đơn Hàng Cơ Bản Thành Công
    [Documentation]    Kiểm tra hoàn thiện đơn hàng cơ bản thành công:
    ...    - Đơn hàng có trạng thái Draft hoặc Verified
    ...    - Complete = true để hoàn thiện đơn hàng
    ...    - Trạng thái đơn hàng được cập nhật thành Finalized (3)
    ...    - Tồn kho được cập nhật
    ...    - Doanh thu được tính toán
    [Tags]    AIGenerated    CompleteOrder    Positive    Basic    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    And Xác Thực Thông Tin Chi Tiết Đơn Hàng Trong Database
    And Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${PRODUCT_1}" Chi Nhánh "${DEFAULT_BRANCH_ID}"

RT-ORDER-COMPLETE-002 Hoàn Thiện Đơn Hàng Và Tạo Hóa Đơn
    [Documentation]    Kiểm tra hoàn thiện đơn hàng và tạo hóa đơn:
    ...    - Complete = true và MakeInvoice = true
    ...    - Đơn hàng được hoàn thiện
    ...    - Hóa đơn được tạo từ đơn hàng
    ...    - Thông tin thanh toán được xử lý
    [Tags]    AIGenerated    CompleteOrder    Positive    MakeInvoice    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Và Tạo Hóa Đơn
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Và Tạo Hóa Đơn
    And Xác Thực Thông Tin Thanh Toán Trong Database

RT-ORDER-COMPLETE-003 Hoàn Thiện Đơn Hàng COD
    [Documentation]    Kiểm tra hoàn thiện đơn hàng COD:
    ...    - Đơn hàng sử dụng COD (UsingCod = 1)
    ...    - Thông tin giao hàng được đính kèm trong response
    ...    - Thông tin giao hàng được chuyển đổi sang InvoiceDelivery
    [Tags]    AIGenerated    CompleteOrder    Positive    COD    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng COD
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Đã Được Hoàn Thiện

RT-ORDER-COMPLETE-004 Hoàn Thiện Đơn Hàng Có Thanh Toán
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có thanh toán:
    ...    - Đơn hàng có nhiều phương thức thanh toán
    ...    - Thông tin thanh toán được lấy từ PaymentService
    ...    - Thanh toán được đính kèm trong response
    [Tags]    AIGenerated    CompleteOrder    Positive    Payment    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Thanh Toán
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Thanh Toán Đã Được Hoàn Thiện

RT-ORDER-COMPLETE-005 Hoàn Thiện Đơn Hàng Có Khuyến Mãi
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có khuyến mãi:
    ...    - Đơn hàng có áp dụng khuyến mãi
    ...    - Chiết khấu được tính toán đúng
    ...    - Doanh thu được tính trên giá sau chiết khấu
    [Tags]    AIGenerated    CompleteOrder    Positive    Promotion    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Khuyến Mãi
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Khuyến Mãi Đã Được Hoàn Thiện

RT-ORDER-COMPLETE-006 Hoàn Thiện Đơn Hàng Có Sản Phẩm Serial
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có sản phẩm quản lý theo serial:
    ...    - Sản phẩm có quản lý theo serial number
    ...    - Serial được cập nhật trạng thái đã bán
    ...    - Tồn kho serial được cập nhật
    [Tags]    AIGenerated    CompleteOrder    Positive    Serial    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Serial
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Sản Phẩm Serial Đã Được Hoàn Thiện

RT-ORDER-COMPLETE-007 Hoàn Thiện Đơn Hàng Có Sản Phẩm Lô
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có sản phẩm quản lý theo lô:
    ...    - Sản phẩm có quản lý theo batch/lot
    ...    - Tồn kho lô được cập nhật theo chiến lược FIFO/FEFO
    ...    - Thông tin lô được ghi nhận
    [Tags]    AIGenerated    CompleteOrder    Positive    Batch    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Lô
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Sản Phẩm Lô Đã Được Hoàn Thiện

RT-ORDER-COMPLETE-008 Hoàn Thiện Đơn Hàng Có Combo
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có sản phẩm combo:
    ...    - Sản phẩm combo gồm nhiều sản phẩm thành phần
    ...    - Tồn kho các sản phẩm thành phần được cập nhật
    ...    - Giá combo được tính toán đúng
    [Tags]    AIGenerated    CompleteOrder    Positive    Combo    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Combo
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Combo Đã Được Hoàn Thiện

# =============================================================================
# Test Cases Thành Công - Các trường hợp đặc biệt
# =============================================================================

RT-ORDER-COMPLETE-009 Hoàn Thiện Đơn Hàng Với Nhiều Điều Kiện
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với nhiều điều kiện khác nhau
    [Template]    Test Hoàn Thiện Đơn Hàng Với Điều Kiện
    [Tags]    AIGenerated    CompleteOrder    Positive    Template    regression
    # customer_id                total      complete
    ${DEFAULT_CUSTOMER_ID}       100000     ${TRUE}
    ${DEBT_CUSTOMER_ID}          200000     ${TRUE}
    ${CUSTOMER_ID_REWARD_POINT}  150000     ${TRUE}

RT-ORDER-COMPLETE-010 Hoàn Thiện Đơn Hàng Cập Nhật Dư Nợ Khách Hàng
    [Documentation]    Kiểm tra hoàn thiện đơn hàng cập nhật dư nợ khách hàng:
    ...    - Khách hàng có dư nợ trước đó
    ...    - Dư nợ được cập nhật sau khi hoàn thiện đơn hàng
    ...    - Kiểm tra giới hạn nợ không bị vượt quá
    [Tags]    AIGenerated    CompleteOrder    Positive    CustomerDebt    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Với Khách Hàng "${DEBT_CUSTOMER_ID}" Tổng Tiền 300000 Và Complete ${TRUE}
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    And Xác Thực Dư Nợ Khách Hàng Đã Được Cập Nhật Cho Khách Hàng "${DEBT_CUSTOMER_ID}"

RT-ORDER-COMPLETE-011 Hoàn Thiện Đơn Hàng Với Thuế VAT
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có sản phẩm chịu thuế VAT:
    ...    - Sản phẩm có thuế VAT
    ...    - Thuế được tính toán và cập nhật
    ...    - Tổng tiền bao gồm thuế
    [Tags]    AIGenerated    CompleteOrder    Positive    VAT    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    TaxPercentage    ${DEFAULT_TAX_RATE}
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    TaxAmount    10000
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

RT-ORDER-COMPLETE-012 Hoàn Thiện Đơn Hàng Với Phụ Thu
    [Documentation]    Kiểm tra hoàn thiện đơn hàng có phụ thu:
    ...    - Đơn hàng có các khoản phụ thu (phí dịch vụ, phí giao hàng)
    ...    - Phụ thu được tính vào tổng tiền
    ...    - Doanh thu bao gồm phụ thu
    [Tags]    AIGenerated    CompleteOrder    Positive    Surcharge    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Surcharge    20000
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Total    220000
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

# =============================================================================
# Test Cases Lỗi - Các trường hợp không thành công
# =============================================================================

RT-ORDER-COMPLETE-013 Lỗi Khi Hoàn Thiện Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng đã hoàn thiện:
    ...    - Đơn hàng có trạng thái Finalized (3)
    ...    - API phải trả về lỗi business logic
    ...    - Thông báo lỗi rõ ràng
    [Tags]    AIGenerated    CompleteOrder    Negative    AlreadyFinalized    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Đã Hoàn Thiện
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Xác Thực Lỗi Đơn Hàng Đã Hoàn Thiện

RT-ORDER-COMPLETE-014 Lỗi Khi Hoàn Thiện Đơn Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng không tồn tại:
    ...    - ID đơn hàng không có trong hệ thống
    ...    - API phải trả về lỗi not found
    ...    - Thông báo lỗi rõ ràng
    [Tags]    AIGenerated    CompleteOrder    Negative    OrderNotFound    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Không Tồn Tại
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Xác Thực Lỗi Đơn Hàng Không Tồn Tại

RT-ORDER-COMPLETE-015 Lỗi Khi Hoàn Thiện Đơn Hàng Có Sản Phẩm Hết Hàng
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng có sản phẩm hết hàng:
    ...    - Sản phẩm không đủ tồn kho để hoàn thiện
    ...    - API phải trả về lỗi business logic
    ...    - Thông báo lỗi về tồn kho
    [Tags]    AIGenerated    CompleteOrder    Negative    OutOfStock    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Hết Hàng
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Xác Thực Lỗi Sản Phẩm Hết Hàng

RT-ORDER-COMPLETE-016 Lỗi Khi Hoàn Thiện Đơn Hàng ID Không Hợp Lệ
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng với ID không hợp lệ:
    ...    - ID đơn hàng <= 0
    ...    - API phải trả về lỗi validation
    ...    - Thông báo lỗi về ID không hợp lệ
    [Tags]    AIGenerated    CompleteOrder    Negative    InvalidOrderId    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng ID Không Hợp Lệ
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Xác Thực Lỗi ID Đơn Hàng Không Hợp Lệ

RT-ORDER-COMPLETE-017 Lỗi Khi Hoàn Thiện Đơn Hàng Khách Hàng Vượt Hạn Mức Nợ
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng khiến khách hàng vượt hạn mức nợ:
    ...    - Khách hàng có giới hạn nợ
    ...    - Tổng nợ sau hoàn thiện vượt quá giới hạn
    ...    - API phải trả về lỗi business logic
    [Tags]    AIGenerated    CompleteOrder    Negative    DebtLimitExceeded    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Với Khách Hàng "${DEBT_LIMIT_CUSTOMER_ID}" Tổng Tiền 999999999 Và Complete ${TRUE}
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 420
    And CompleteOrderKeywords.Phản Hồi Phải Chứa Lỗi "Vượt quá hạn mức nợ"

RT-ORDER-COMPLETE-018 Lỗi Khi Hoàn Thiện Đơn Hàng Có Sản Phẩm Không Hoạt Động
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng có sản phẩm không hoạt động:
    ...    - Sản phẩm bị vô hiệu hóa
    ...    - API phải trả về lỗi business logic
    ...    - Thông báo lỗi về sản phẩm không hoạt động
    [Tags]    AIGenerated    CompleteOrder    Negative    InactiveProduct    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    ProductId    ${INACTIVE_PRODUCT_ID}
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 420
    And CompleteOrderKeywords.Phản Hồi Phải Chứa Lỗi "Sản phẩm không hoạt động"

RT-ORDER-COMPLETE-019 Lỗi Khi Hoàn Thiện Đơn Hàng Có Serial Đã Sử Dụng
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng có serial đã được sử dụng:
    ...    - Serial number đã được bán trong đơn hàng khác
    ...    - API phải trả về lỗi business logic
    ...    - Thông báo lỗi về serial đã sử dụng
    [Tags]    AIGenerated    CompleteOrder    Negative    UsedSerial    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Serial
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    SerialNumbers    USED_SERIAL_001
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And CompleteOrderKeywords.Phản Hồi Phải Chứa Lỗi "Serial đã được sử dụng"

RT-ORDER-COMPLETE-020 Lỗi Khi Hoàn Thiện Đơn Hàng Có Lô Hết Hạn
    [Documentation]    Kiểm tra lỗi khi hoàn thiện đơn hàng có lô hết hạn:
    ...    - Lô sản phẩm đã hết hạn sử dụng
    ...    - API phải trả về lỗi business logic
    ...    - Thông báo lỗi về lô hết hạn
    [Tags]    AIGenerated    CompleteOrder    Negative    ExpiredBatch    regression
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Có Sản Phẩm Lô
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    BatchName    EXPIRED_BATCH_001
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 420
    And CompleteOrderKeywords.Phản Hồi Phải Chứa Lỗi "Lô sản phẩm đã hết hạn"

# =============================================================================
# Test Cases Đặc Biệt - Edge Cases và Performance
# =============================================================================

RT-ORDER-COMPLETE-021 Hoàn Thiện Đơn Hàng Với Số Lượng Lớn Sản Phẩm
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với số lượng lớn sản phẩm:
    ...    - Đơn hàng có nhiều sản phẩm khác nhau
    ...    - Kiểm tra performance và tính toán đúng
    ...    - Tồn kho được cập nhật cho tất cả sản phẩm
    [Tags]    AIGenerated    CompleteOrder    Positive    LargeOrder    performance
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Quantity    1000
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Total    100000000
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Total    100000000
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

RT-ORDER-COMPLETE-022 Hoàn Thiện Đơn Hàng Với Giá Trị Lớn
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với giá trị lớn:
    ...    - Đơn hàng có tổng giá trị rất lớn
    ...    - Kiểm tra xử lý số lớn và tính toán chính xác
    ...    - Doanh thu được ghi nhận đúng
    [Tags]    AIGenerated    CompleteOrder    Positive    LargeValue    edge
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Price    999999999
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Total    1999999998
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Total    1999999998
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

RT-ORDER-COMPLETE-023 Hoàn Thiện Đơn Hàng Với Chiết Khấu 100%
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với chiết khấu 100%:
    ...    - Đơn hàng có chiết khấu bằng tổng giá trị
    ...    - Tổng tiền sau chiết khấu = 0
    ...    - Doanh thu được tính đúng
    [Tags]    AIGenerated    CompleteOrder    Positive    FullDiscount    edge
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Discount    200000
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    DiscountRatio    100
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Total    0
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

RT-ORDER-COMPLETE-024 Hoàn Thiện Đơn Hàng Với Số Lượng Thập Phân
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với số lượng thập phân:
    ...    - Sản phẩm có số lượng thập phân (0.5, 1.25)
    ...    - Tính toán tổng tiền chính xác
    ...    - Tồn kho được cập nhật đúng
    [Tags]    AIGenerated    CompleteOrder    Positive    DecimalQuantity    edge
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Quantity    2.5
    And Set To Dictionary    ${REQUEST_DATA["Order"]["OrderDetails"][0]}    Total    250000
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    Total    250000
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database

RT-ORDER-COMPLETE-025 Hoàn Thiện Đơn Hàng Với Nhiều Chi Nhánh
    [Documentation]    Kiểm tra hoàn thiện đơn hàng với sản phẩm từ nhiều chi nhánh:
    ...    - Sản phẩm có tồn kho tại nhiều chi nhánh
    ...    - Tồn kho được cập nhật đúng chi nhánh
    ...    - Doanh thu được phân bổ đúng chi nhánh
    [Tags]    AIGenerated    CompleteOrder    Positive    MultiBranch    edge
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA["Order"]}    BranchId    ${BRANCH_ID_NHANH_A}
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database
    And Xác Thực Tồn Kho Đã Được Cập Nhật Cho Sản Phẩm "${PRODUCT_1}" Chi Nhánh "${BRANCH_ID_NHANH_A}"

*** Keywords ***
Test Hoàn Thiện Đơn Hàng Với Điều Kiện
    [Arguments]    ${customer_id}    ${total}    ${complete}
    Given Chuẩn Bị Dữ Liệu Hoàn Thiện Đơn Hàng Với Khách Hàng "${customer_id}" Tổng Tiền ${total} Và Complete ${complete}
    When Gửi Yêu Cầu Hoàn Thiện Đơn Hàng
    Then CompleteOrderKeywords.Mã Trạng Thái Phải Là 200
    And Xác Thực Response Chứa Thông Tin Đơn Hàng Đã Hoàn Thiện
    And Xác Thực Đơn Hàng Đã Được Hoàn Thiện Trong Database 