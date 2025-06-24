*** Settings ***
Documentation     Test cases cho chức năng xử lý giao hàng trong đơn hàng
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../Keywords/Order/DeliveryProcessingKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Order/OrderCommonKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Test Cases ***

RT-DP-001 Tạo Đơn Hàng COD thành công với thông tin giao hàng đầy đủ
    [Documentation]    Kiểm tra tạo đơn hàng COD thành công với thông tin giao hàng đầy đủ
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng đầy đủ:
    ...      + Tên người nhận: "Hung"
    ...      + SĐT: "0988673523"
    ...      + Địa chỉ: "1B"
    ...      + Mã khu vực: 1, Mã phường: 1
    ...      + Phương thức giao: Đối tác mặc định (DeliveryBy=1)
    ...      + Phí ship: 20,000đ
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với thông tin giao hàng đầy đủ
    ...    - UsingCod được bật trong hóa đơn
    [Tags]        delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0170 Có Thông Tin Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Thông Tin Người Nhận Trong Đơn Đặt Hàng   Hung   0988673523
    And Xác Thực Địa Chỉ Giao Hàng Trong Đơn Đặt Hàng     1B
    And Xác Thực Khu Vực Giao Hàng Trong Đơn Đặt Hàng    ${DEFAULT_LOCATION_ID}   ${DEFAULT_WARD_ID_1} 
    And Xác Thực Phí Giao Hàng Trong Đơn Đặt Hàng     ${DEFAULT_DELIVERY_PRICE}
    [Teardown]    Delete Order From Api


RT-DP-006 Tạo đơn hàng COD thành công với đối tác giao hàng 
    [Documentation]    Kiểm tra tạo đơn hàng COD thành công với đối tác giao hàng Để trống
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với đối tác :
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phương thức giao: Đối tác 
    ...      + PartnerId: None
    ...      + Phí ship: 30,000đ
    ...    - Logic kiểm tra: DeliveryService xử lý thông tin đối tác giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với thông tin đối tác giao hàng
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Đối Tác Giao Hàng DT00005
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Đơn Hàng Có Đối Tác Giao Hàng
    [Teardown]    Delete Order From Api

RT-DP-007 Tạo đơn hàng giao hàng thay đổi thông tin gói hàng
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng thay đổi thông tin gói hàng
    ...    - Dữ liệu đầu vào: 
    ...    - Thông tin gói hàng:
    ...      + Khối lượng: 1000 g
    ...      + Kích thước: 20x10x15 cm
    ...    - Thông tin giao hàng:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phí ship: 100,000đ (bằng với giá trị hóa đơn)
    ...    - Logic kiểm tra: DeliveryService xử lý phí giao hàng cao
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với phí giao hàng cao
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0291 Có khối lượng 1000 g Và Kích thước 20x10x15 cm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Thông Tin Gói Giao Hàng Được Cập Nhật Đúng

RT-DP-008 Tạo đơn hàng giao hàng gắn với Khách hàng và miễn phí giao hàng
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng gắn với Khách hàng và miễn phí giao hàng
    ...    - Dữ liệu đầu vào: 
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
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Gắn Với Khách Hàng CTKH148 Và Phí Giao Hàng 0
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Phí Giao Hàng Trong Đơn Đặt Hàng    0
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là CTKH148
    [Teardown]    Delete Order From Api

RT-DP-009 Tạo đơn hàng giao hàng có thanh toán 
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng có thanh toán COD
    ...    - Dữ liệu đầu vào: 
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
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Với Thu Hộ và Thanh Toán 30000
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    [Teardown]    Delete Order From Api

RT-DP-010 Tạo đơn hàng giao hàng có thời gian giao hàng
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng có thời gian giao hàng
    ...    - Dữ liệu đầu vào: 
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Thời Gian Sau 4 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng Trong Đơn Đặt Hàng   1
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Sau 4 Ngày So Với Ngày Hiện Tại
    [Teardown]    Delete Order From Api

RT-DP-011 Tạo đơn hàng giao hàng thành công với trạng thái đang giao hàng
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng thành công với trạng thái đang giao hàng
    ...    - Dữ liệu đầu vào: 
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với trạng thái Đang giao hàng:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Status: 3 (Đang giao hàng)
    ...    - Logic kiểm tra: DeliveryService xử lý trạng thái giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với trạng thái giao hàng Đang giao hàng
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Với Trạng Thái Đang Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Trạng Thái Giao Hàng Trong Đơn Đặt Hàng   2
    [Teardown]    Delete Order From Api

RT-DP-012 Tạo đơn hàng giao hàng thành công không thu hộ
    [Documentation]    Kiểm tra tạo đơn hàng giao hàng thành công không thu hộ
    ...    - Dữ liệu đầu vào: 
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Không Thu Hộ
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 200
    And Xác Thực Đặt Hàng Giao Hàng Trong DB
    And Xác Thực Đơn Hàng Không Thu Hộ
    And Xác Thực Trạng Thái Giao Hàng Trong Đơn Đặt Hàng    1
    [Teardown]    Delete Order From Api


RT-DP-013 Tạo đơn hàng thất bại khi thời gian giao hàng sớm hơn thời gian hóa đơn
    [Documentation]    Kiểm tra tạo đơn hàng thất bại khi thời gian giao hàng sớm hơn thời gian hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - PurchaseDate: "2023-08-15T14:00:00"
    ...    - DeliveryDetail.ExpectedDelivery: "2023-08-15T10:00:00" (sớm hơn thời gian hóa đơn)
    ...    - IsValid: false (cần kiểm tra validation)
    ...    - Logic kiểm tra: Logic xác thực thời gian giao hàng trong CreateOrder
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Thời gian giao hàng phải sau thời gian hóa đơn"
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Thời Gian Trước 1 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Thời gian giao hàng phải sau thời gian đặt hàng"

RT-DP-014 Tạo đơn hàng thất bại khi thời gian giao hàng trùng với thời gian hóa đơn
    [Documentation]    Kiểm tra tạo đơn hàng thất bại khi thời gian giao hàng trùng với thời gian hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - PurchaseDate: "2023-08-15T14:00:00"
    ...    - DeliveryDetail.ExpectedDelivery: "2023-08-15T14:00:00" (trùng với thời gian hóa đơn)
    ...    - IsValid: false (cần kiểm tra validation)
    ...    - Logic kiểm tra: Logic xác thực thời gian giao hàng trong CreateOrder
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Thời gian giao hàng phải sau thời gian hóa đơn"
    [Tags]    apiinvoice    delivery    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Thời Gian Trùng 0 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Thời gian giao hàng phải sau thời gian đặt hàng"

RT-DP-015 Tạo hóa đơn thất bại khi đối tác giao hàng không hợp lệ
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi đối tác giao hàng không hợp lệ
    ...    - Dữ liệu đầu vào: 
    ...    - Invoice.UsingCod: 1 (bật chế độ COD)
    ...    - Invoice.DeliveryDetail.UseDefaultPartner: true
    ...    - Invoice.DeliveryDetail.PartnerCode: "${NON_EXISTENT_KV_PARTNER_DELIVERY_CODE}"
    ...    - Invoice.DeliveryDetail.ServiceAdd: "S1"
    ...    - Logic kiểm tra: Xác thực đối tác vận chuyển trong CreateInvoice
    ...    - Mô phỏng điều kiện:
    ...    - Đối tác không hoạt động (currentCarrierCom.IsActive = false)
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."
    [Tags]    apiinvoice    delivery123    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giao Hàng Với Đối Tác COD Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."


