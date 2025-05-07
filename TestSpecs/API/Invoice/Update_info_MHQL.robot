*** Settings ***
Documentation     Test cases API cho phần cập nhật thông tin giao hàng
Resource          ../../../Keywords/Invoice/DeliveryUpdateKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Variables ***
${SELLER_ID}    1000000490
${CHANNEL_ID}   1000000042
${DELIVERY_PARTNER_2}    1000000119

*** Test Cases ***
RT-DU-001 Cập nhật trạng thái giao hàng thành công
    [Documentation]    Kiểm tra cập nhật trạng thái giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái cập nhật: 2 (Processing)
    ...    - Ghi chú: "Đang giao hàng"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Trạng thái giao hàng được cập nhật thành "Processing" (2) trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng ${STATUS_PROCESSING}
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${STATUS_PROCESSING}


RT-DU-002 Cập nhật thông tin người nhận thành công
    [Documentation]    Kiểm tra cập nhật thông tin người nhận thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Thông tin người nhận mới:
    ...      + Tên: "Nguyễn Thị B"
    ...      + SĐT: "0912345678"
    ...      + Địa chỉ: "456 Đường Lê Lợi, Q3"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật thông tin người nhận
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thông tin người nhận được cập nhật trong CSDL
    ...    - Cột ReceiverName, ReceiverPhone, ReceiverAddress được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Thông Tin Người Nhận Được Cập Nhật Thành Nguyễn Thị B, 0912345678, 456 Đường Lê Lợi, Q3

RT-DU-003 Cập nhật phí giao hàng thành công
    [Documentation]    Kiểm tra cập nhật phí giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Phí giao hàng mới: 35,000đ
    ...    - Ghi chú: "Điều chỉnh phí do khu vực xa"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật phí giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phí giao hàng được cập nhật trong CSDL thành 35,000đ
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery     
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng 
    And Chuẩn Bị Dữ Liệu Cập Nhật Phí Giao Hàng 35000
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Phí Giao Hàng Được Cập Nhật Thành 35000 Đồng

RT-DU-004 Cập nhật thu hộ
    [Documentation]    Kiểm tra cập nhật miễn phí giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Phí giao hàng: 0đ
    ...    - IsFreeShip: true
    ...    - Ghi chú: "Khách VIP, miễn phí giao hàng"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật phí và cờ miễn phí
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phí giao hàng được cập nhật thành 0đ trong CSDL
    ...    - Cờ IsFreeShip được bật (1)
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Thu Hộ 
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Hóa Đơn Được Cập Nhật Thu Hộ


RT-DU-005 Cập nhật trạng thái đã giao hàng thành công
    [Documentation]    Kiểm tra cập nhật trạng thái đã giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: 3 (Completed)
    ...    - Ghi chú: "Đã giao hàng thành công"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật trạng thái hoàn thành
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Trạng thái giao hàng được cập nhật thành "Completed" (3) trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng ${STATUS_COMPLETED}
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${STATUS_COMPLETED}

RT-DU-006 Cập nhật trạng thái hủy giao hàng thành công
    [Documentation]    Kiểm tra cập nhật trạng thái hủy giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: 4 (Cancelled)
    ...    - Ghi chú: "Đã hủy giao hàng theo yêu cầu khách"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật trạng thái hủy
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Trạng thái giao hàng được cập nhật thành "Cancelled" (4) trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
   Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng ${STATUS_CANCELLED}
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${STATUS_CANCELLED}

RT-DU-007 Cập nhật mã vận đơn thành công
    [Documentation]    Kiểm tra cập nhật mã vận đơn thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Mã vận đơn: "TRACK123456789"
    ...    - Ghi chú: "Đã cập nhật mã vận đơn mới"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật mã vận đơn
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Mã vận đơn được cập nhật trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
     [Tags]    apiinvoice    update_invoice    update_delivery     
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn TRACK123456789
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Mã Vận Đơn Được Cập Nhật Thành TRACK123456789


RT-DU-008 Cập nhật đối tác giao hàng khác
    [Documentation]    Kiểm tra cập nhật đối tác giao hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Phương thức giao: 2 (Đối tác)
    ...    - Mã đối tác: ${DELIVERY_PARTNER_2}
    ...    - Ghi chú: "Chuyển sang đối tác giao hàng khác"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật đối tác giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phương thức giao hàng và mã đối tác được cập nhật trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Đối Tác Giao Hàng ${DELIVERY_PARTNER_2}
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Đối tác giao hàng được cập nhật thành ${DELIVERY_PARTNER_2}

RT-DU-009 Cập nhật thông tin gói hàng
    [Documentation]    Kiểm tra cập nhật thông tin gói hàng thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - IsPartialDelivery: true
    ...    - PartialDeliveryAmount: 50,000đ
    ...    - Ghi chú: "Giao một phần sản phẩm"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật thông tin giao một phần
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Cờ IsPartialDelivery được bật (1) trong CSDL
    ...    - Số tiền giao một phần được cập nhật thành 50,000đ
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Gói Hàng 100x100x100x100
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Xác Thực Sử Dụng Thông Tin Trọng Lượng 100 Và Kích Thước 100x100x100 cm

RT-DU-010 Cập nhật ngày giao dự kiến thành công
    [Documentation]    Kiểm tra cập nhật ngày giao dự kiến thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Ngày giao dự kiến: "2024-06-15"
    ...    - Ghi chú: "Dự kiến giao vào ngày 15/06/2024"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật ngày giao dự kiến
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Ngày giao dự kiến được cập nhật trong CSDL
    ...    - Ghi chú giao hàng được cập nhật
    [Tags]    apiinvoice    update_invoice    update_delivery    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Ngày Giao Dự Kiến và Ghi Chú
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    And Xác Thực Cập Nhật Ngày Giao Dự Kiến 
    And Xác Thực Ghi Chú Giao Hàng ${EXPECTED_NOTE}

RT-DU-011 Cập nhật giao hàng thất bại với mã hóa đơn không tồn tại
    [Documentation]    Kiểm tra cập nhật giao hàng thất bại với mã hóa đơn không tồn tại
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn không tồn tại: ID không có trong CSDL
    ...    - Trạng thái: 2 (Processing)
    ...    - Logic kiểm tra: DeliveryService.UpdateDelivery kiểm tra hóa đơn tồn tại
    ...    - Kỳ vọng:
    ...    - Status code: 404
    ...    - Response chứa thông báo lỗi "Không tìm thấy hóa đơn"
    Given Chuẩn Bị Dữ Liệu Cập Nhật Với Hóa Đơn Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Giao Hàng
    Then Response Status Code Should Be 404
    And Response Should Have Error "Không tìm thấy hóa đơn"

RT-DU-012 Cập nhật giao hàng thất bại với trạng thái không hợp lệ
    [Documentation]    Kiểm tra cập nhật giao hàng thất bại với trạng thái không hợp lệ
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: 20 (không hợp lệ, chỉ có 1-5)
    ...    - Logic kiểm tra: DeliveryService.UpdateDelivery kiểm tra trạng thái hợp lệ
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Response chứa thông báo lỗi "Trạng thái giao hàng không hợp lệ"
    [Tags]    
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Để Cập Nhật Giao Hàng
    And Chuẩn Bị Dữ Liệu Cập Nhật Trạng Thái Giao Hàng 20
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã trạng thái phải là 200
    Then Response Status Code Should Be 420
    And Response Should Have Error "Trạng thái giao hàng không hợp lệ"

RT-DU-013 Cập nhật giao hàng nhiều thông tin cùng lúc thành công
    [Documentation]    Kiểm tra cập nhật nhiều thông tin giao hàng cùng lúc thành công
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Nhiều thông tin cập nhật:
    ...      + Người nhận: "Trần Văn C", "0969696969"
    ...      + Địa chỉ: "789 Đường Nguyễn Du, Q5"
    ...      + Trạng thái: 2 (Processing)
    ...      + Mã vận đơn: "VN789123456"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật nhiều thông tin
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Tất cả thông tin được cập nhật đồng thời trong CSDL
    Given Chuẩn Bị Dữ Liệu Cập Nhật Người Nhận Với Tên Trần Văn C SĐT 0969696969 Và Địa Chỉ "789 Đường Nguyễn Du, Q5"
    Set To Dictionary    ${REQUEST_DATA.DeliveryInfo}    Status=${STATUS_PROCESSING}    TrackingCode=VN789123456
    When Gửi Yêu Cầu Cập Nhật Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Thông Tin Người Nhận Được Cập Nhật Thành Trần Văn C, 0969696969, 789 Đường Nguyễn Du, Q5
    And Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${STATUS_PROCESSING}
    And Mã Vận Đơn Được Cập Nhật Thành VN789123456

RT-DU-014 Cập nhật giao hàng với đầy đủ tham số sử dụng template
    [Documentation]    Kiểm tra cập nhật giao hàng với đầy đủ tham số sử dụng template
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Các tham số cập nhật:
    ...      + Trạng thái: 2 (Processing)
    ...      + Ghi chú: "Đơn hàng đang được giao tới khách"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật theo template
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thông tin giao hàng được cập nhật theo template
    Given Chuẩn Bị Dữ Liệu Cập Nhật Giao Hàng Với Mã Hóa Đơn ${EXISTENT_INVOICE_ID} Và Trạng Thái ${STATUS_PROCESSING} Và Ghi Chú "Đơn hàng đang được giao tới khách"
    When Gửi Yêu Cầu Cập Nhật Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Thông Tin Cập Nhật Giao Hàng Được Lưu Với Trạng Thái ${STATUS_PROCESSING}
    And Ghi Chú Giao Hàng Được Cập Nhật Thành "Đơn hàng đang được giao tới khách"

RT-DU-015 Cập nhật phí giao hàng sử dụng tham số nhúng
    [Documentation]    Kiểm tra cập nhật phí giao hàng sử dụng tham số nhúng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Phí giao hàng: 45,000đ
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật phí giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Phí giao hàng được cập nhật thành 45,000đ trong CSDL
    Given Chuẩn Bị Dữ Liệu Cập Nhật Phí Giao Hàng Thành 45000 Đồng
    When Gửi Yêu Cầu Cập Nhật Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Phí Giao Hàng Được Cập Nhật Thành 45000 Đồng

RT-DU-016 Cập nhật mã vận đơn sử dụng tham số nhúng
    [Documentation]    Kiểm tra cập nhật mã vận đơn sử dụng tham số nhúng
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Mã vận đơn: "EXPRESS123456789"
    ...    - Logic cập nhật: DeliveryService.UpdateDelivery cập nhật mã vận đơn
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Mã vận đơn được cập nhật thành "EXPRESS123456789" trong CSDL
    Given Chuẩn Bị Dữ Liệu Cập Nhật Mã Vận Đơn Thành EXPRESS123456789
    When Gửi Yêu Cầu Cập Nhật Giao Hàng
    Then Response Status Code Should Be 200
    And Response Should Have Id exist
    And Mã Vận Đơn Được Cập Nhật Thành EXPRESS123456789 

Cập nhật người bán từ MHQL
   [Documentation]    Kiểm tra cập nhật người bán từ MHQL
   ...    - Dữ liệu đầu vào:
   ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
   ...    - Người bán: ${SELLER_ID}
   ...    - Kỳ vọng:
   ...    - Status code: 200
   ...    - Người bán được cập nhật thành ${SELLER_ID}
   [Tags]    apiinvoice    smoke   
   Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
   And Chuẩn Bị Dữ Liệu Cập Nhật Người Bán ${SELLER_ID}
   When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
   Then Mã Trạng Thái Phải Là 200
   And Người Bán Được Cập Nhật Thành ${SELLER_ID}
Cập nhật thời gian từ MHQL
    [Documentation]    Kiểm tra cập nhật thời gian từ MHQL
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: ${STATUS}
    ...    - Thời gian: ${TIME_DELTA} ngày
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thời gian được cập nhật thành ${TIME}
    [Tags]    apiinvoice    smoke   
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian Trừ 3 Ngày
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL    
    Then Mã Trạng Thái Phải Là 200
    And Thời Gian Được Cập Nhật Thành ${PURCHASE_DATE}

Cập Nhập Thời Gian Có Thanh Toán Không Thay Đổi Thời gian Phiếu Thanh Toán
    [Documentation]    Kiểm tra cập nhập thời gian có thanh toán không thay đổi thời gian phiếu thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: ${STATUS}
    ...    - Thời gian: ${TIME_DELTA} ngày
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thời gian được cập nhật thành ${TIME}
    [Tags]    apiinvoice    smoke     test36635
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Có Thanh Toán
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian 5 Ngày Không Thay Đổi Phiếu Thanh Toán
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã Trạng Thái Phải Là 200
    And Thời Gian Được Cập Nhật Thành ${PURCHASE_DATE}
    And Thời Gian Phiếu Thanh Toán ${CURRENT_DATE_PAYMENT}  
    
 Cập Nhập Thời Gian Có Thanh Toán Có Thay Đổi Thời gian Phiếu Thanh Toán
    [Documentation]    Kiểm tra cập nhập thời gian có thanh toán có thay đổi thời gian phiếu thanh toán
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: ${STATUS}
    ...    - Thời gian: ${TIME_DELTA} ngày
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Thời gian được cập nhật thành ${TIME}
    [Tags]    apiinvoice    smoke     test36635
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật Có Thanh Toán
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian 5 Ngày Có Thay Đổi Phiếu Thanh Toán
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã Trạng Thái Phải Là 200
    And Thời Gian Được Cập Nhật Thành ${PURCHASE_DATE}
    And Thời Gian Phiếu Thanh Toán ${PURCHASE_DATE}

Cập nhật thời gian tương lai từ MHQL
    [Documentation]    Kiểm tra cập nhật thời gian tương lai từ MHQL
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Trạng thái: ${STATUS}
    ...    - Thời gian: ${TIME_DELTA} ngày
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thời gian được cập nhật thành ${TIME}
    [Tags]    apiinvoice    smoke      
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    And Chuẩn Bị Dữ Liệu Cập Nhật Thời Gian Thêm 3 Ngày
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL        
    Then Mã Trạng Thái Phải Là 420
    And Response Should Have Error "Bạn chỉ được cập nhật giao dịch trong vòng 12 tháng."


Cập nhập kênh bán từ MHQL
    [Documentation]    Kiểm tra cập nhập kênh bán từ MHQL
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Kênh bán: ${CHANNEL_ID}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Kênh bán được cập nhật thành ${CHANNEL_ID}
    [Tags]    apiinvoice    smoke      test4243
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    And Chuẩn Bị Dữ Liệu Cập Nhật Kênh Bán ${CHANNEL_ID}
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã Trạng Thái Phải Là 200
    And Kênh Bán Được Cập Nhật Thành ${CHANNEL_ID}
Cập nhật ghi chú từ MHQL
    [Documentation]    Kiểm tra cập nhập ghi chú từ MHQL
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Ghi chú: ${NOTE}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Ghi chú được cập nhật thành ${NOTE}
    [Tags]    apiinvoice    smoke     
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    And Chuẩn Bị Dữ Liệu Cập Nhật Ghi Chú 50 Kí Tự
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã Trạng Thái Phải Là 200
    And Ghi Chú Được Cập Nhật Thành ${NOTE}

Cập nhật ghi chú quá nhiều kí tự từ MHQL
    [Documentation]    Kiểm tra cập nhập ghi chú quá nhiều kí tự từ MHQL
    ...    - Dữ liệu đầu vào:
    ...    - Mã hóa đơn hiện có: ID hóa đơn có trong CSDL
    ...    - Ghi chú: ${NOTE}
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Ghi chú được cập nhật thành ${NOTE}
    [Tags]    apiinvoice    smoke     
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Cập Nhật 
    And Chuẩn Bị Dữ Liệu Cập Nhật Ghi Chú 5000 Kí Tự
    When Gửi Yêu Cầu Cập Nhật Hóa Đơn Từ MHQL
    Then Mã Trạng Thái Phải Là 200
    And Ghi Chú Được Cập Nhật Thành ${NOTE}





