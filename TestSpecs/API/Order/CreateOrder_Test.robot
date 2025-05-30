*** Settings ***
Documentation     Test API tạo đơn hàng mới
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/CreateOrderData.robot

*** Variables ***
@{list_product_code}    HH0040     HH0041   
@{list_payment_method}    Cash    Transfer
@{list_payment_amount}    100000    200000

*** Test Cases ***
RT-ORDER-001 Tạo Đơn Hàng Mới Thành Công Với Thông Tin Cơ Bản
    [Documentation]    Test tạo đơn hàng mới thành công với thông tin cơ bản: sản phẩm, khách hàng, nhân viên bán hàng
    [Tags]    AIGenerated    CreateOrder    Positive    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Chi Tiết Đơn Hàng

RT-ORDER-002 Tạo Đơn Hàng Với Nhiều Sản Phẩm
    [Documentation]    Test tạo đơn hàng mới với nhiều sản phẩm khác nhau
    [Tags]    AIGenerated    CreateOrder    Positive    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Sản Phẩm ${list_product_code}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Tổng Tiền Đơn Hàng Được Tính Đúng

RT-ORDER-003 Tạo Đơn Hàng Với Chiết Khấu
    [Documentation]    Test tạo đơn hàng mới có áp dụng chiết khấu
    [Tags]    AIGenerated    CreateOrder    Positive    Discount    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Chiết Khấu 10%
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng

RT-ORDER-004 Tạo Đơn Hàng Với Thông Tin Giao Hàng
    [Documentation]    Test tạo đơn hàng mới có thông tin giao hàng
    [Tags]    AIGenerated    CreateOrder    Positive    Delivery    regression34
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Thông Tin Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Đúng

RT-ORDER-005 Tạo Đơn Hàng Với Khuyến Mãi
    [Documentation]    Test tạo đơn hàng mới có áp dụng khuyến mãi
    [Tags]    AIGenerated    CreateOrder    Positive    Promotion    regression34
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Khuyến Mãi Được Áp Dụng Đúng

RT-ORDER-006 Tạo Đơn Hàng Với Thông Tin Thanh Toán
    [Documentation]    Test tạo đơn hàng mới có thông tin thanh toán
    [Tags]    AIGenerated    CreateOrder    Positive    Payment    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Thanh Toán 50000 Phương Thức Cash
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Thanh Toán Được Lưu Đúng

RT-ORDER-007 Tạo Đơn Hàng Với Nhiều Phương Thức Thanh Toán
    [Documentation]    Test tạo đơn hàng mới có nhiều phương thức thanh toán
    [Tags]    AIGenerated    CreateOrder    Positive    MultiplePayments    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Nhiều Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Các Phương Thức Thanh Toán ${list_payment_method} Với Số Tiền ${list_payment_amount} Được Lưu Đúng

RT-ORDER-008 Tạo Đơn Hàng Với Sản Phẩm Có Thuế VAT
    [Documentation]    Test tạo đơn hàng mới có sản phẩm với thuế VAT
    [Tags]    AIGenerated    CreateOrder    Positive    VAT    regression123456
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Có Thuế VAT
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thuế VAT Được Tính Đúng

RT-ORDER-009 Tạo Đơn Hàng Với Ngày Dự Kiến Giao Hàng
    [Documentation]    Test tạo đơn hàng mới có ngày dự kiến giao hàng
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDeliveryDate    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Ngày Dự Kiến Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Ngày Dự Kiến Giao Hàng Được Lưu Đúng

RT-ORDER-010 Tạo Đơn Hàng Với Kênh Bán Hàng
    [Documentation]    Test tạo đơn hàng mới có kênh bán hàng
    [Tags]    AIGenerated    CreateOrder    Positive    SaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Kênh Bán Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Kênh Bán Hàng Được Lưu Đúng

RT-ORDER-011 Tạo Đơn Hàng Sử Dụng COD
    [Documentation]    Test tạo đơn hàng mới sử dụng COD
    [Tags]    AIGenerated    CreateOrder    Positive    COD    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Sử Dụng COD
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Phương Thức Thanh Toán COD Được Lưu Đúng

RT-ORDER-012 Tạo Đơn Hàng Với Sản Phẩm Serial
    [Documentation]    Test tạo đơn hàng mới có sản phẩm quản lý theo serial
    [Tags]    AIGenerated    CreateOrder    Positive    Serial    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Serial
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Serial Sản Phẩm Được Lưu Đúng

RT-ORDER-013 Tạo Đơn Hàng Với Sản Phẩm Quản Lý Theo Lô
    [Documentation]    Test tạo đơn hàng mới có sản phẩm quản lý theo lô
    [Tags]    AIGenerated    CreateOrder    Positive    Batch    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Quản Lý Theo Lô
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Lô Sản Phẩm Được Lưu Đúng

RT-ORDER-014 Tạo Đơn Hàng Với Sản Phẩm Combo
    [Documentation]    Test tạo đơn hàng mới có sản phẩm combo
    [Tags]    AIGenerated    CreateOrder    Positive    Combo    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Combo
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Sản Phẩm Combo Được Lưu Đúng

RT-ORDER-015 Tạo Đơn Hàng Kết Hợp (IsCombine=true)
    [Documentation]    Test tạo đơn hàng mới kết hợp (IsCombine=true)
    [Tags]    AIGenerated    CreateOrder    Positive    Combine    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Kết Hợp
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng

RT-ORDER-016 Tạo Đơn Hàng Với TransGuid Để Theo Dõi
    [Documentation]    Test tạo đơn hàng mới với TransGuid để theo dõi
    [Tags]    AIGenerated    CreateOrder    Positive    TransGuid    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có TransGuid
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực TransGuid Được Lưu Đúng

RT-ORDER-017 Lỗi Khi Tạo Đơn Hàng Với Sản Phẩm Trùng Lặp
    [Documentation]    Test lỗi khi tạo đơn hàng mới với sản phẩm trùng lặp
    [Tags]    AIGenerated    CreateOrder    Negative    DuplicateProduct    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Sản Phẩm Trùng Lặp
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Sản phẩm trùng lặp trong đơn hàng"

RT-ORDER-018 Lỗi Khi Tạo Đơn Hàng Với Khuyến Mãi Đã Bị Xóa
    [Documentation]    Test lỗi khi tạo đơn hàng mới với khuyến mãi đã bị xóa
    [Tags]    AIGenerated    CreateOrder    Negative    DeletedPromotion    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khuyến Mãi Đã Bị Xóa
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khuyến mãi đã bị xóa"

RT-ORDER-019 Lỗi Khi Tạo Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    [Documentation]    Test lỗi khi tạo đơn hàng mới với đối tác giao hàng không hợp lệ
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidDeliveryPartner    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Đối Tác Giao Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Đối tác giao hàng không hợp lệ hoặc không hoạt động"

RT-ORDER-020 Lỗi Khi Tạo Đơn Hàng Với Phương Thức Thanh Toán COD Không Hợp Lệ
    [Documentation]    Test lỗi khi tạo đơn hàng mới với phương thức thanh toán COD không hợp lệ
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidCOD    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Phương Thức Thanh Toán COD Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Phương thức thanh toán COD không hợp lệ"

RT-ORDER-021 Lỗi Khi Tạo Đơn Hàng Với Khách Hàng Không Tồn Tại
    [Documentation]    Test lỗi khi tạo đơn hàng mới với khách hàng không tồn tại
    [Tags]    AIGenerated    CreateOrder    Negative    NonExistentCustomer    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khách Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không tồn tại hoặc không hoạt động"

RT-ORDER-022 Lỗi Khi Tạo Đơn Hàng Với Khách Hàng Không Hoạt Động
    [Documentation]    Test lỗi khi tạo đơn hàng mới với khách hàng không hoạt động
    [Tags]    AIGenerated    CreateOrder    Negative    InactiveCustomer    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Khách Hàng Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không tồn tại hoặc không hoạt động"

RT-ORDER-023 Lỗi Khi Tạo Đơn Hàng Với ID Khách Hàng Không Hợp Lệ
    [Documentation]    Test lỗi khi tạo đơn hàng mới với ID khách hàng không hợp lệ
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidCustomerId    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có ID Khách Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "ID khách hàng không hợp lệ"

RT-ORDER-024 Lỗi Khi Tạo Đơn Hàng Với Nhân Viên Bán Hàng Không Tồn Tại
    [Documentation]    Test lỗi khi tạo đơn hàng mới với nhân viên bán hàng không tồn tại
    [Tags]    AIGenerated    CreateOrder    Negative    NonExistentSalesperson    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Nhân Viên Bán Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Nhân viên bán hàng không tồn tại"

RT-ORDER-025 Lỗi Khi Tạo Đơn Hàng Với Nhân Viên Bán Hàng Không Hoạt Động
    [Documentation]    Test lỗi khi tạo đơn hàng mới với nhân viên bán hàng không hoạt động
    [Tags]    AIGenerated    CreateOrder    Negative    InactiveSalesperson    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Nhân Viên Bán Hàng Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Nhân viên bán hàng không hoạt động"

RT-ORDER-026 Lỗi Khi Tạo Đơn Hàng Khi Không Có Quyền
    [Documentation]    Test lỗi khi tạo đơn hàng mới khi người dùng không có quyền
    [Tags]    AIGenerated    CreateOrder    Negative    NoPermission    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Và Người Dùng Không Có Quyền Tạo Đơn Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 403
    And Phản Hồi Phải Chứa Lỗi "Không có quyền tạo đơn hàng"

RT-ORDER-027 Lỗi Khi Tạo Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Test lỗi khi tạo đơn hàng mới với kênh bán hàng không tồn tại
    [Tags]    AIGenerated    CreateOrder    Negative    NonExistentSaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Kênh Bán Hàng Không Tồn Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán hàng không tồn tại"

RT-ORDER-028 Lỗi Khi Tạo Đơn Hàng Với Kênh Bán Hàng Không Hoạt Động
    [Documentation]    Test lỗi khi tạo đơn hàng mới với kênh bán hàng không hoạt động
    [Tags]    AIGenerated    CreateOrder    Negative    InactiveSaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Kênh Bán Hàng Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán hàng không hoạt động hoặc không thuộc retailer"

RT-ORDER-029 Tạo Đơn Hàng Với Các Trường Ngày Tháng UTC
    [Documentation]    Test tạo đơn hàng mới với các trường ngày tháng UTC
    [Tags]    AIGenerated    CreateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Các Trường Ngày Tháng UTC
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Các Trường Ngày Tháng Được Xử Lý Đúng

RT-ORDER-030 Lỗi Khi Tạo Đơn Hàng Với Thông Tin Giao Hàng Không Hợp Lệ
    [Documentation]    Test lỗi khi tạo đơn hàng mới với thông tin giao hàng không hợp lệ
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidDeliveryInfo    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có Thông Tin Giao Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Thông tin giao hàng không hợp lệ" 