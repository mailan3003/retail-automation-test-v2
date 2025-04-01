*** Settings ***
Documentation     Test cases API cho phần xử lý thông tin giao hàng
Resource          ../../../Keywords/Invoice/DeliveryProcessingKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py
Suite Setup       Suite Setup

*** Keywords ***
Suite Setup
    Set Suite Variable    ${SUITE_NAME}    DeliveryProcessingTest

*** Test Cases ***
RT-DP-001 Tạo hóa đơn COD thành công với thông tin giao hàng đầy đủ
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với thông tin giao hàng đầy đủ
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng đầy đủ:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Mã khu vực: 1, Mã phường: 1
    ...      + Phương thức giao: Đối tác mặc định (DeliveryBy=1)
    ...      + Phí ship: 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với thông tin giao hàng đầy đủ
    ...    - UsingCod được bật trong hóa đơn
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Thông Tin Người Nhận    ${INVOICE_ID}    Nguyễn Văn A    0987654321
    And Xác Thực Địa Chỉ Giao Hàng    ${INVOICE_ID}    123 Đường Nguyễn Huệ, Q1
    And Xác Thực Khu Vực Giao Hàng    ${INVOICE_ID}    ${DEFAULT_LOCATION_ID}    ${DEFAULT_WARD_ID}
    And Xác Thực Sử Dụng Đối Tác Mặc Định    ${INVOICE_ID}    1
    And Xác Thực Phí Giao Hàng    ${INVOICE_ID}    ${DEFAULT_DELIVERY_PRICE}

RT-DP-002 Tạo hóa đơn COD thất bại khi thiếu số điện thoại người nhận
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu số điện thoại người nhận
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng thiếu SĐT:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: [không có]
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...    - Logic kiểm tra: DeliveryService.ValidateDeliveryInfo kiểm tra SĐT người nhận bắt buộc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Số điện thoại người nhận không được để trống"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không SĐT
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Số điện thoại người nhận không được để trống"

RT-DP-003 Tạo hóa đơn COD thất bại khi thiếu tên người nhận
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu tên người nhận
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng thiếu tên:
    ...      + Tên người nhận: [không có]
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...    - Logic kiểm tra: DeliveryService.ValidateDeliveryInfo kiểm tra tên người nhận bắt buộc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Tên người nhận không được để trống"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Tên
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Tên người nhận không được để trống"

RT-DP-004 Tạo hóa đơn COD thất bại khi thiếu địa chỉ người nhận
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu địa chỉ người nhận
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng thiếu địa chỉ:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: [không có]
    ...    - Logic kiểm tra: DeliveryService.ValidateDeliveryInfo kiểm tra địa chỉ người nhận bắt buộc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Địa chỉ người nhận không được để trống"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Địa Chỉ
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Địa chỉ người nhận không được để trống"

RT-DP-005 Tạo hóa đơn COD thất bại khi thiếu thông tin khu vực
    [Documentation]    Kiểm tra tạo hóa đơn COD thất bại khi thiếu thông tin khu vực
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng thiếu khu vực:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Mã khu vực: [không có]
    ...    - Logic kiểm tra: DeliveryService.ValidateDeliveryInfo kiểm tra khu vực giao hàng bắt buộc
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Khu vực giao hàng không được để trống"
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Khu Vực
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 420
    And Response Should Have Error "Khu vực giao hàng không được để trống"

RT-DP-006 Tạo hóa đơn COD thành công với đối tác giao hàng khác
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với đối tác giao hàng khác
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với đối tác khác:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phương thức giao: Đối tác khác (DeliveryBy=2)
    ...      + PartnerId: 8888
    ...      + Phí ship: 30,000đ
    ...    - Logic kiểm tra: DeliveryService xử lý thông tin đối tác giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với thông tin đối tác giao hàng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Đối Tác Khác
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Đối Tác Giao Hàng    ${INVOICE_ID}    ${DELIVERY_PARTNER_2}
    And Xác Thực Phí Giao Hàng    ${INVOICE_ID}    30000

RT-DP-007 Tạo hóa đơn COD thành công với phí giao hàng cao
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với phí giao hàng cao
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với phí cao:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phí ship: 100,000đ (bằng với giá trị hóa đơn)
    ...    - Logic kiểm tra: DeliveryService xử lý phí giao hàng cao
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với phí giao hàng cao
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Phí Cao
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Phí Giao Hàng    ${INVOICE_ID}    100000

RT-DP-008 Tạo hóa đơn COD thành công với miễn phí giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với miễn phí giao hàng
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng miễn phí:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phí ship: 0đ
    ...      + IsFreeShip: true
    ...    - Logic kiểm tra: DeliveryService xử lý miễn phí giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với phí giao hàng = 0 và cờ IsFreeShip = true
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Miễn Phí
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Miễn Phí Giao Hàng    ${INVOICE_ID}    1

RT-DP-009 Tạo hóa đơn COD thành công với trạng thái đang chờ xử lý
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với trạng thái đang chờ xử lý
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STS001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với trạng thái Pending:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Status: 1 (Pending)
    ...    - Logic kiểm tra: DeliveryService xử lý trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với trạng thái giao hàng Pending
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái    ${DELIVERY_INFO_PENDING}
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng    ${INVOICE_ID}    ${STATUS_PENDING}

RT-DP-010 Tạo hóa đơn COD thành công với trạng thái đang xử lý
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với trạng thái đang xử lý
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STS001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với trạng thái Processing:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Status: 2 (Processing)
    ...    - Logic kiểm tra: DeliveryService xử lý trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với trạng thái giao hàng Processing
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái    ${DELIVERY_INFO_PROCESSING}
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng    ${INVOICE_ID}    ${STATUS_PROCESSING}

RT-DP-011 Tạo hóa đơn COD thành công với trạng thái đã hoàn thành
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với trạng thái đã hoàn thành
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STS001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với trạng thái Completed:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Status: 3 (Completed)
    ...    - Logic kiểm tra: DeliveryService xử lý trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với trạng thái giao hàng Completed
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái    ${DELIVERY_INFO_COMPLETED}
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng    ${INVOICE_ID}    ${STATUS_COMPLETED}

RT-DP-012 Tạo hóa đơn COD thành công với trạng thái đã hủy
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với trạng thái đã hủy
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STS001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với trạng thái Cancelled:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Status: 4 (Cancelled)
    ...    - Logic kiểm tra: DeliveryService xử lý trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với trạng thái giao hàng Cancelled
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái    ${DELIVERY_INFO_CANCELLED}
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng    ${INVOICE_ID}    ${STATUS_CANCELLED}

RT-DP-013 Tạo hóa đơn COD thành công với ghi chú giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với ghi chú giao hàng
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với ghi chú:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Ghi chú: "Giao hàng ngoài giờ hành chính"
    ...    - Logic kiểm tra: DeliveryService xử lý ghi chú giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với ghi chú giao hàng
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Ghi Chú
    When Gửi Yêu Cầu Tạo Hóa Đơn Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Ghi Chú Giao Hàng    ${INVOICE_ID}    Giao hàng ngoài giờ hành chính 