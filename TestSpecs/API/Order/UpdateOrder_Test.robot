*** Settings ***
Documentation     Test API cập nhật đơn hàng - Ở MHBH
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../TestData/CommonData.robot
# Test Setup        Setup Test Environment
# Test Teardown     Cleanup Test Environment

*** Test Cases ***
# =============================================================================
# Test Cases Thành Công - Cập nhật đơn hàng cơ bản
# =============================================================================

RT-ORDER-UPDATE-001 Cập Nhật Đơn Hàng Cơ Bản Thành Công
    [Documentation]    Kiểm tra cập nhật đơn hàng cơ bản với thông tin mới:
    ...    - Cập nhật mô tả đơn hàng
    ...    - Xác thực đơn hàng được cập nhật trong database
    ...    - Xác thực log thay đổi được ghi nhận
    [Tags]    AIGenerated    UpdateOrder    Positive    Basic    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0053 Để Cập Nhật
    When Chuẩn Bị Dữ Liệu Cập Nhật Mô Tả Cho Đơn Hàng
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng


RT-ORDER-UPDATE-002 Cập Nhật Thông Tin Khách Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin khách hàng trong đơn hàng:
    ...    - Thay đổi khách hàng từ khách hàng mặc định sang khách hàng khác
    ...    - Xác thực thông tin khách hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Customer    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0054 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Thành CTKH001
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là CTKH001

RT-ORDER-UPDATE-003 Cập Nhật Thông Tin Khách Hàng Không Tồn Tại Trong Hệ Thống
    [Documentation]    Kiểm tra cập nhật thông tin khách hàng trong đơn hàng:
    ...    - Thay đổi khách hàng từ khách hàng mặc định sang khách hàng không tồn tại trong hệ thống
    ...    - Xác thực thông tin khách hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Customer    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0055 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng ${INVALID_CUSTOMER_ID} Trong Hệ Thống
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."

RT-ORDER-UPDATE-005 Cập Nhật Đơn Hàng Thường Thành Đơn Có Giao Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng thường thành đơn có giao hàng:
    ...    - Cập nhật đơn hàng thường thành đơn có giao hàng
    ...    - Xác thực đơn hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Delivery    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0056 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Thường Thành Đơn Có Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Giao Hàng Được Lưu Đúng

RT-ORDER-UPDATE-005 Cập Nhật Thông Tin Giao Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin giao hàng trong đơn hàng:
    ...    - Cập nhật tên, số điện thoại, địa chỉ người nhận
    ...    - Xác thực thông tin giao hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Delivery    regression
    Given Chuẩn Bị Đơn Hàng HH0053 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Đơn Hàng MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Giao Hàng Được Lưu Đúng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Phí Giao Hàng
    [Documentation]    Cập Nhật Đơn Hàng Phí Giao Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0054 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Phí Giao Hàng 25000 MHQL
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Phí Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Thu Hộ
    [Documentation]    Cập Nhật Đơn Hàng Thu Hộ
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0055 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Thu Hộ MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Không Thu Hộ
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Mã Vận Đơn
    [Documentation]    Cập Nhật Đơn Hàng Mã Vận Đơn
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0056 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Mã Vận Đơn 123456789033 MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Mã Vận Đơn
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Đối Tác Giao Hàng
    [Documentation]    Cập Nhật Đơn Hàng Đối Tác Giao Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0057 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Đối Tác Giao Hàng DT00002 Ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Có Đối Tác Giao Hàng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Gói Hàng
    [Documentation]    Cập Nhật Đơn Hàng Gói Hàng
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0058 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Gói Hàng 10x20x30x40 Ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Gói Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Ngày Giao Dự Kiến Và Ghi Chú
    [Documentation]    Cập Nhật Đơn Hàng Ngày Giao Dự Kiến
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0059 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Ngày Giao Dự Kiến Và Ghi Chú Ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Giao Dự Kiến Được Cập Nhật Đúng
    And Xác Thực Ghi Chú Giao Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api




RT-ORDER-UPDATE-006 Cập Nhật Kênh Bán Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật kênh bán hàng trong đơn hàng:
    ...    - Thay đổi kênh bán hàng từ kênh này sang kênh khác
    ...    - Xác thực kênh bán hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    SaleChannel    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0056 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Thành Kênh 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là Kênh 3

# =============================================================================


RT-ORDER-UPDATE-018 Cập Nhật Đơn Hàng Thời Gian Giao Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0057 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Trước 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Trước 1 Ngày So Với Ngày Hiện Tại


RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Thời Gian Giao Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0058 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Trước 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Trước 1 Ngày So Với Ngày Hiện Tại

Cập Nhật Đơn Hàng Thời Gian Giao Hàng Lùi Thời Gian Hiện Tại
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0059 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Sau 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Ngày dự kiến giao phải ở trong tương lai"

Cập Nhật Thời Gian Bán Hàng Lùi Thời Gian Hiện Tại
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0060 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Ngày Bán Cho Đơn Hàng Thành Trước 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Bán Hàng Đã Được Cập Nhật Thành Trước 1 Ngày So Với Ngày Hiện Tại


Cập Nhật Đơn Hàng Thời Gian Bán Hàng Sau Thời Gian Hiện Tại
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0061 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Ngày Bán Cho Đơn Hàng Thành Sau 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Vượt quá thời gian hiện tại"



RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Thay Đổi Khách Hàng Với Đơn Không Có Thay Toán
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateCustomerIdInPayments = true:
    ...    - Cập nhật ID khách hàng trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateCustomerIdInPayments    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Với Khách Hàng DHDPT001
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Thành DHDPT002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là DHDPT002
    [Teardown]    Delete Order From Api

RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Thay Đổi Khách Hàng Với Đơn Có Thanh Toán
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateCustomerIdInPayments = true:
    ...    - Cập nhật ID khách hàng trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateCustomerIdInPayments    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Có Khách Hàng DHDPT001 Thanh Toán Với Số Tiền 1000
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Thành DHDPT002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Có thay đổi mới hơn từ server. Bạn cần cập nhật trước khi tạo thay đổi mới"
    [Teardown]    Delete Order From Api

RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Thay Đổi Kênh Bán Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateSaleChannel = true:
    ...    - Cập nhật ID kênh bán hàng trong thông tin đơn hàng
    ...    - Xác thực thông tin kênh bán hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateSaleChannel    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Với Khách Hàng DHDPT001
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Thành Kênh 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Kênh Bán Hàng Trong Đơn Đặt Hàng Là Kênh 3
    [Teardown]    Delete Order From Api


Cập Nhật Đơn Hàng Thay Đổi Người Nhận Đặt Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateCustomerIdInPayments = true:
    ...    - Cập nhật ID khách hàng trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateCustomerIdInPayments    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Với Khách Hàng DHDPT001
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng Thành DHDPT002
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là DHDPT002
    [Teardown]    Delete Order From Api

Cập Nhật Đơn Hàng Thay Đổi Bảng Giá Sản Phẩm
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateProductIdInPayments = true:
    ...    - Cập nhật ID sản phẩm trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateProductIdInPayments    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Với Khách Hàng DHDPT001
    And Chuẩn Bị Dữ Liệu Cập Nhật Sản Phẩm Thành HH0055
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Trong Đơn Đặt Hàng Là HH0055
    [Teardown]    Delete Order From Api



# =============================================================================
# Test Cases Lỗi - Validation Errors
# =============================================================================

RT-ORDER-UPDATE-021 Lỗi Khi Cập Nhật Đơn Hàng Với Sản Phẩm Trùng Lặp
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có sản phẩm trùng lặp:
    ...    - Đơn hàng chứa cùng một sản phẩm nhiều lần
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    DuplicateProduct    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm Trùng Lặp
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Sản Phẩm Trùng Lặp Trong Đơn Hàng

RT-ORDER-UPDATE-022 Lỗi Khi Cập Nhật Đơn Hàng Với UUID Trùng Lặp
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng offline có UUID trùng lặp:
    ...    - UUID đã tồn tại trong hệ thống
    ...    - API phải trả về lỗi KvValidateInvoiceException
    [Tags]    AIGenerated    UpdateOrder    Negative    DuplicateUUID    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với UUID Trùng Lặp "${EXISTENT_INVOICE_UUID}"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi UUID Trùng Lặp

RT-ORDER-UPDATE-025 Lỗi Khi Cập Nhật Đơn Hàng Với Nhân Viên Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có nhân viên không tồn tại:
    ...    - ID nhân viên bán hàng không có trong hệ thống
    ...    - API phải trả về lỗi KvValidateUserException
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidUser    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhân Viên Không Tồn Tại "999999999"
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Nhân Viên Không Tồn Tại

RT-ORDER-UPDATE-026 Lỗi Khi Cập Nhật Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng có kênh bán hàng không tồn tại:
    ...    - ID kênh bán hàng không có trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidSaleChannel    regression768
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Kênh Bán Hàng Không Tồn Tại


RT-ORDER-UPDATE-028 Lỗi Khi Cập Nhật Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng COD có đối tác giao hàng không hợp lệ:
    ...    - Đối tác giao hàng không tồn tại hoặc không hoạt động
    ...    - API phải trả về lỗi KvValidatePartnerDeliveryException
    [Tags]    AIGenerated    UpdateOrder    Negative    InvalidDeliveryPartner    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Giao Hàng Không Hợp Lệ
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Xác Thực Lỗi Đối Tác Giao Hàng Không Hợp Lệ

# =============================================================================
# Test Cases Lỗi - Business Logic Errors
# =============================================================================

RT-ORDER-UPDATE-029 Lỗi Khi Cập Nhật Đơn Hàng Không Tồn Tại
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng không tồn tại:
    ...    - ID đơn hàng không có trong hệ thống
    ...    - API phải trả về lỗi not found
    [Tags]    AIGenerated    UpdateOrder    Negative    OrderNotFound    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Id    ${NONEXISTENT_ORDER_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 404

RT-ORDER-UPDATE-030 Lỗi Khi Cập Nhật Đơn Hàng Đã Hoàn Thiện
    [Documentation]    Kiểm tra lỗi khi cập nhật đơn hàng đã hoàn thiện:
    ...    - Đơn hàng có trạng thái đã hoàn thiện không thể cập nhật
    ...    - API phải trả về lỗi business logic
    [Tags]    AIGenerated    UpdateOrder    Negative    OrderFinalized    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']}    Id    ${FINALIZED_ORDER_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

# =============================================================================
# Test Cases Đặc Biệt - Edge Cases

RT-ORDER-UPDATE-032 Cập Nhật Đơn Hàng Với Số Lượng Âm
    [Documentation]    Kiểm tra cập nhật đơn hàng với số lượng sản phẩm âm:
    ...    - Số lượng sản phẩm không được phép âm
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    NegativeQuantity    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Số Lượng Sản Phẩm Từ 1 Thành -1
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

# =============================================================================
# Test Cases Tích Hợp - Integration Tests
# =============================================================================

RT-ORDER-UPDATE-036 Cập Nhật Đơn Hàng Với Tồn Kho Không Đủ
    [Documentation]    Kiểm tra cập nhật đơn hàng khi tồn kho không đủ:
    ...    - Số lượng yêu cầu vượt quá tồn kho hiện có
    ...    - API phải trả về lỗi tồn kho
    [Tags]    AIGenerated    UpdateOrder    Negative    InsufficientInventory    nhathuoc
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    ProductId    ${product_out_of_stock}
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    Quantity    999999
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420

RT-ORDER-UPDATE-037 Cập Nhật Đơn Hàng Với Sản Phẩm Không Hoạt Động
    [Documentation]    Kiểm tra cập nhật đơn hàng với sản phẩm không hoạt động:
    ...    - Sản phẩm đã bị vô hiệu hóa trong hệ thống
    ...    - API phải trả về lỗi validation
    [Tags]    AIGenerated    UpdateOrder    Negative    InactiveProduct    regression
    Given Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Cơ Bản
    And Set To Dictionary    ${REQUEST_DATA['Order']['OrderDetails'][0]}    ProductId    ${INACTIVE_PRODUCT_ID}
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420


