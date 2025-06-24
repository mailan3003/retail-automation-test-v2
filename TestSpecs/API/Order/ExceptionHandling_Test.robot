*** Settings ***
Documentation    Test cases cho chức năng xử lý ngoại lệ và lỗi trong hệ thống KiotViet

Suite Setup       Init Test Environment    ${ENV}    MHBH
Resource         ../../../Keywords/Order/OrderCommonKeywords.robot
Resource         ../../../Keywords/Order/CreateOrderKeywords.robot
Resource         ../../../TestData/CommonData.robot
Resource         ../../../Keywords/Utilities/Utilities.robot
Resource    ../../../Keywords/Login/Login.robot
Resource    ../../../TestData/Invoice/InvoiceVLXDData.robot
*** Variables ***
${CUSTOMER_BR}   KH000004
*** Test Cases ***

RT-EXC-001 Tạo Đơn Hàng Trùng Lặp Hàng Hóa
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm trùng lặp trong đơn hàng (loại trừ sản phẩm khuyến mãi)
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Trùng Lặp ${PRODUCT_1_CODE}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Sản phẩm bị trùng"

Tạo Đơn Hàng Với Hàng Hóa Số Lượng Bằng 0
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm có số lượng = 0
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_1_CODE} Có Số Lượng Đặt Hàng 0
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vui lòng nhập số lượng lớn hơn 0 cho sản phẩm "

Tạo Đơn Hàng Với Hàng Hóa Số Lượng Âm
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm có số lượng = 0
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${PRODUCT_1_CODE} Có Số Lượng Đặt Hàng -5
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vui lòng nhập số lượng lớn hơn 0 cho sản phẩm "
Tạo Đơn Hàng Với Sản Phẩm Ngừng Kinh Doanh
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateException với nhiều điều kiện:
    ...    - Sản phẩm không tồn tại trong hệ thống
    ...    - Không có quyền tạo đơn hàng (Order._Create)
    ...    - Không có quyền cập nhật đơn hàng (Order._Update)
    ...    - Trả về mã lỗi 420 với thông báo cụ thể từ KVMessage
    [Tags]    AIGenerated    ExceptionHandling    KvValidateException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Sản Phẩm ${INACTIVE_PRODUCT_CODE} Có Số Lượng Đặt Hàng 1
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Một số hàng hóa có trong đơn hàng đã ngừng kinh doanh ở chi nhánh hiện tại: ${INACTIVE_PRODUCT_CODE}"

RT-EXC-002 Tạo Đơn Hàng Với Khách Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Khách hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng ${PRODUCT_1_CODE} Có Khách Hàng KH808887
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."

RT-EXC-003 Tạo Đơn Hàng Với Khách Hàng Không Tồn Tại
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Khách hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với ID Khách Hàng ${NONEXISTENT_CUSTOMER_ID}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không hoạt động hoặc đã bị xóa khỏi hệ thống."

Tạo Đơn Hàng Với Khách Hàng Ở Chi Nhánh Khác
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateCustomerException với nhiều điều kiện:
    ...    - Gian hàng Bật quản lý khách hàng theo chi nhánh
    ...    - Khách hàng không tồn tại trong chi nhánh hiện tại
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về khách hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateCustomerException    vlxd
    Given Chuẩn Bị Dữ Liệu Đơn Hàng ${PRODUCT_CODE_VLXD} Có Khách Hàng ${CUSTOMER_BR}
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Khách hàng không thuộc chi nhánh hiện tại."

RT-EXC-003 Tạo Đơn Hàng Với Nhân Viên Nhận Đặt Không Tồn Tại
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateUserException với nhiều điều kiện:
    ...    - Nhân viên bán hàng không tồn tại trong hệ thống
    ...    - Hiển thị tên nhân viên cụ thể trong thông báo lỗi
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về nhân viên
        [Tags]    AIGenerated    ExceptionHandling    KvValidateUserException    regression
    # user_condition                               expected_error_message
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có ID Người Nhận Đặt 9999999
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Người bán không tồn tại hoặc đã bị xóa khỏi hệ thống"

Tạo Đơn Hàng Nhân Viên Đặt Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateUserException với nhiều điều kiện:
    ...    - Nhân viên bán hàng không tồn tại trong hệ thống
    ...    - Hiển thị tên nhân viên cụ thể trong thông báo lỗi
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về nhân viên
    [Tags]    AIGenerated    ExceptionHandling    KvValidateUserException   regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng ${PRODUCT_1_CODE} Có Người Nhận Đặt inactiveuser
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Người bán inactiveuser đã bị ngừng hoạt động"


RT-EXC-005 Tạo Đơn Hàng Với Kênh Bán Hàng Không Tồn Tại
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateSaleChannelException với nhiều điều kiện:
    ...    - Kênh bán hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về kênh bán hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateSaleChannelException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Có ID Kênh Bán 646654654
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán không tồn tại"


Tạo Đơn Hàng Với Kênh Bán Hàng Ngừng Hoạt Động
    [Documentation]    Kiểm tra xử lý ngoại lệ KvValidateSaleChannelException với nhiều điều kiện:
    ...    - Kênh bán hàng không tồn tại trong hệ thống
    ...    - Trả về mã lỗi 420 với thông báo cụ thể về kênh bán hàng
    [Tags]    AIGenerated    ExceptionHandling    KvValidateSaleChannelException    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng ${PRODUCT_1_CODE} Có Kênh Bán Kênh 4
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Kênh bán không tồn tại"




RT-EXC-013 Tạo Hóa Đơn Với Người Dùng Không Có Quyền
    [Documentation]    Kiểm tra xử lý ngoại lệ với kiểm tra quyền sớm:
    ...    - Lỗi quyền hạn cần được kiểm tra sớm để tránh xử lý không cần thiết
    ...    - Kiểm tra quyền trước khi thực hiện các validation khác
    ...    - Xác thực không có side effect khi thiếu quyền
    [Tags]    AIGenerated    ExceptionHandling    EarlyPermissionCheck    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản ${PRODUCT_1_CODE}
    When Get BearerToken by user    anh.nk     Kiotviet123456
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 403





*** Keywords ***