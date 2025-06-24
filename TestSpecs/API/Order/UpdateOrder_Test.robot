*** Settings ***
Documentation     Test API cập nhật đơn hàng - Ở MHBH
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/UpdateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Invoice/Invoice_Validation_Data.robot


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
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0117 Để Cập Nhật
    When Chuẩn Bị Dữ Liệu Cập Nhật Mô Tả Cho Đơn Hàng
    And Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng


RT-ORDER-UPDATE-002 Cập Nhật Thông Tin Khách Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin khách hàng trong đơn hàng:
    ...    - Thay đổi khách hàng từ khách hàng mặc định sang khách hàng khác
    ...    - Xác thực thông tin khách hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Customer    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0172 Để Cập Nhật
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
    And Chuẩn Bị Dữ Liệu Cập Nhật Khách Hàng 99999993444 Trong Hệ Thống
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."

RT-ORDER-UPDATE-005 Cập Nhật Đơn Hàng Thường Thành Đơn Có Giao Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng thường thành đơn có giao hàng:
    ...    - Cập nhật đơn hàng thường thành đơn có giao hàng
    ...    - Xác thực đơn hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Delivery    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0177 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Thường Thành Đơn Có Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thông Tin Giao Hàng Được Lưu Đúng

RT-ORDER-UPDATE-005 Cập Nhật Thông Tin Giao Hàng Trong Đơn Hàng
    [Documentation]    Kiểm tra cập nhật thông tin giao hàng trong đơn hàng:
    ...    - Cập nhật tên, số điện thoại, địa chỉ người nhận
    ...    - Xác thực thông tin giao hàng được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    Delivery    regression
    Given Chuẩn Bị Đơn Hàng HH0264 Có Thông Tin Giao Hàng Để Cập Nhật
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

Cập Nhật Đơn Hàng Thu Hộ MHBH
    [Documentation]    Cập Nhật Đơn Hàng Thu Hộ
    [Tags]    AIGenerated    UpdateOrder    Positive    DeliveryFee    regression
    Given Chuẩn Bị Đơn Hàng HH0055 Có Thông Tin Giao Hàng Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Đơn Hàng Không Thu Hộ MHBH
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
    Given Chuẩn Bị Đơn Hàng HH0262 Có Thông Tin Giao Hàng Để Cập Nhật
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
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0178 Để Cập Nhật
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Thành Kênh 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là Kênh 3
    [Teardown]    Delete Order From Api

# =============================================================================


RT-ORDER-UPDATE-018 Cập Nhật Đơn Hàng Thời Gian Giao Hàng Sau Thời Gian Hiện Tại
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0057 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Sau 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Sau 1 Ngày So Với Ngày Hiện Tại


RT-ORDER-UPDATE-019 Cập Nhật Đơn Hàng Thời Gian Giao Hàng Trước Thời Gian Hiện Tại
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0058 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Trước 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Ngày dự kiến giao phải ở trong tương lai"

Cập Nhật Đơn Hàng Thời Gian Giao Hàng Trùng Ngày Khác giờ
    [Documentation]    Kiểm tra cập nhật đơn hàng với các trường ngày tháng UTC:
    ...    - PurchaseDate và ExpectedDeliveryDate ở định dạng UTC
    ...    - Hệ thống xử lý chuyển đổi múi giờ đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0059 Để Cập Nhật
    And Chuẩn Bị Cập Nhật Thời Gian Giao Hàng Cho Đơn Hàng Thành Trùng 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Cập Nhật Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Giao Dự Kiến Được Cập Nhật Đúng Đơn Không Có Giao Hàng


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
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản HH0272 Để Cập Nhật
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


Cập Nhật Đơn Hàng Thay Đổi Người Nhận Đặt Hàng
    [Documentation]    Kiểm tra cập nhật đơn hàng với UpdateCustomerIdInPayments = true:
    ...    - Cập nhật ID khách hàng trong thông tin thanh toán
    ...    - Xác thực thông tin thanh toán được cập nhật đúng
    [Tags]    AIGenerated    UpdateOrder    Positive    UpdateCustomerIdInPayments    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0054 Với Khách Hàng DHDPT001
    And Chuẩn Bị Cập Nhập Người Bán Cho Đơn Hàng Thành son.dx
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Người Nhận Đặt Trong Đơn Hàng là son.dx
    [Teardown]    Delete Order From Api


# =============================================================================
# Test Cases Lỗi - Validation Errors
# =============================================================================

RT-EXC-001 Cập Nhật Đơn Hàng có Trùng Hàng Hóa
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm trùng lặp trong đơn hàng (loại trừ sản phẩm khuyến mãi)
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0057 Với Khách Hàng DHDPT001
    And Chuẩn Bị Câp Nhật Đơn Hàng Với Sản Phẩm Trùng Ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Sản phẩm bị trùng"

Cập nhật Đơn Hàng Có Số Lượng Bằng 0
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm có số lượng = 0
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0057 Với Khách Hàng DHDPT002
    And Chuẩn Bị Cập Nhật Đơn Hàng Với Sản Phẩm Có Số Lượng 0
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vui lòng nhập số lượng lớn hơn 0 cho sản phẩm "

Cập nhật Đơn Hàng Có Số Lượng Âm
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm có số lượng = 0
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0058 Với Khách Hàng DHDPT002
    And Chuẩn Bị Cập Nhật Đơn Hàng Với Sản Phẩm Có Số Lượng -5
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vui lòng nhập số lượng lớn hơn 0 cho sản phẩm "
Cập nhật Đơn Hàng Với Sản Phẩm Ngừng Kinh Doanh
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm không tồn tại trong hệ thống
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0059 Với Khách Hàng DHDPT002
    And Chuẩn Bị Cập Nhật Đơn Hàng Với Sản Phẩm ${INACTIVE_PRODUCT_CODE} Ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Một số hàng hóa có trong đơn hàng đã ngừng kinh doanh ở chi nhánh hiện tại: ${INACTIVE_PRODUCT_CODE}"

RT-EXC-002 Cập nhật Đơn Hàng Với Khách Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Khách hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException43    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0059 Với Khách Hàng DHDPT001
    And Chuẩn Bị Cập Nhật Khách Hàng ${INACTIVE_CUSTOMER_CODE} Cho Đơn Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."


Cập nhật Đơn Hàng Với Khách Hàng Ở Chi Nhánh Khác
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Gian hàng Bật quản lý khách hàng theo chi nhánh
    ...    - Khách hàng không tồn tại trong chi nhánh hiện tại
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException    vlxd
    Given Chuẩn Bị Tạo Đơn Đặt Hàng Cơ Bản ${PRODUCT_CODE_VLXD} Để Cập Nhật
    And Chuẩn Bị Cập Nhật Khách Hàng KH000004 Cho Đơn Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không thuộc chi nhánh hiện tại."

RT-EXC-003 Cập nhật Đơn Hàng Với Nhân Viên Nhận Đặt Không Tồn Tại
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateUserException với nhiều điều kiện:
    ...    - Nhân viên bán hàng không tồn tại trong hệ thống
    ...    - Hiển thị tên nhân viên cụ thể trong thông báo lỗi
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về nhân viên
    [Tags]    AIGenerated    ExceptionHandling    KvValidateUserException   regression
    # user_condition                               expected_error_message
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0060 Với Khách Hàng DHDPT001
    And Chuẩn Bị Cập Nhật Người Nhận Đặt Với ID Người Nhận Đặt 9999999 ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"

Cập nhật Đơn Hàng Nhân Viên Đặt Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateUserException với nhiều điều kiện:
    ...    - Nhân viên bán hàng không tồn tại trong hệ thống
    ...    - Hiển thị tên nhân viên cụ thể trong thông báo lỗi
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về nhân viên
    [Tags]   MHBH VAN TAO DUOC
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0060 Với Khách Hàng DHDPT002
    And Chuẩn Bị Cập Nhập Người Bán Cho Đơn Hàng Thành inactiveuser
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Người bán inactiveuser đã bị ngừng hoạt động"


RT-EXC-005 Tạo Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateSaleChannelException với nhiều điều kiện:
    ...    - Kênh bán hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về kênh bán hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateSaleChannelException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0061 Với Khách Hàng DHDPT002
    And Chuẩn Bị Cập Nhật Đơn Hàng Với ID Kênh Bán Hàng 999999 ở MHBH
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán không tồn tại"


Tạo Đơn Hàng Với Kênh Bán Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateSaleChannelException với nhiều điều kiện:
    ...    - Kênh bán hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về kênh bán hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateSaleChannelException    regression
    Given Chuẩn Bị Đơn Hàng Sản Phẩm HH0061 Với Khách Hàng DHDPT001
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán Hàng Thành Kênh 4
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán không tồn tại"



