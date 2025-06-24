*** Settings ***
Documentation     Test cases API cho phần xử lý thông tin giao hàng
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Invoice/DeliveryProcessingKeywords.robot
Resource          ../../../Keywords/Invoice/InvoiceCommonKeywords.robot
Resource          ../../../Keywords/Utilities/DataUtilities.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/RequestHelper.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Keywords ***

*** Test Cases ***
RT-DP-001 Tạo hóa đơn COD thành công với thông tin giao hàng đầy đủ
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với thông tin giao hàng đầy đủ
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Cơ Bản
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    And Xác Thực Thông Tin Người Nhận   Hung   0988673523
    And Xác Thực Địa Chỉ Giao Hàng     1B
    And Xác Thực Khu Vực Giao Hàng    ${DEFAULT_LOCATION_ID}   ${DEFAULT_WARD_ID_1} 
    And Xác Thực Phí Giao Hàng     ${DEFAULT_DELIVERY_PRICE}
    [Teardown]    Delete Invoice From API


RT-DP-006 Tạo hóa đơn COD thành công với đối tác giao hàng Để trống
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với đối tác giao hàng Để trống
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STD001"
    ...    - UsingCod: 1 (bật chế độ COD)
    ...    - Phương thức thanh toán: COD, 100,000đ
    ...    - Thông tin giao hàng với đối tác Để trống:
    ...      + Tên người nhận: "Nguyễn Văn A"
    ...      + SĐT: "0987654321"
    ...      + Địa chỉ: "123 Đường Nguyễn Huệ, Q1"
    ...      + Phương thức giao: Đối tác Để trống (DeliveryBy=None)
    ...      + PartnerId: None
    ...      + Phí ship: 30,000đ
    ...    - Logic kiểm tra: DeliveryService xử lý thông tin đối tác giao hàng
    ...    - Kỳ vọng:
    ...    - Status code: 200
    ...    - Hóa đơn COD được lưu vào CSDL với thông tin đối tác giao hàng
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Đối Tác Để trống
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Giao Hàng Trong DB
    [Teardown]    Delete Invoice From API

RT-DP-007 Tạo hóa đơn giao hàng thay đổi thông tin gói hàng
    [Documentation]    Kiểm tra tạo hóa đơn giao hàng thay đổi thông tin gói hàng
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Có khối lượng 1000 g Và Kích thước 20x10x15 cm
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Sử Dụng Thông Tin Trọng Lượng 1000 Và Kích Thước 20x10x15 cm
    [Teardown]    Delete Invoice From API

RT-DP-008 Tạo hóa đơn Giao hàng gắn với Khách hàng và miễn phí giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn Giao hàng với miễn phí giao hàng
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
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Gắn Với Khách Hàng ${CUSTOMER_CODE} Và Phí Giao Hàng 0
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Phí Giao Hàng   0
    And Xác Thực Khách Hàng ${CUSTOMER_CODE}
    [Teardown]    Delete Invoice From API

RT-DP-009 Tạo hóa đơn giao hàng có thanh toán 
    [Documentation]    Kiểm tra tạo hóa đơn giao hàng có thanh toán COD
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
     [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Thu Hộ và Thanh Toán 30000
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Số Tiền Thu Hộ   ${ORIGINAL_COD} 
    [Teardown]    Delete Invoice From API

RT-DP-010 Tạo hóa đơn giao hàng có thời gian giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn giao hàng có thời gian giao hàng
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Thời Gian 4 Ngày Sau Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Trạng Thái Giao Hàng   1
    And Xác Thực Thời Gian Giao Hàng  ${date_time}
    [Teardown]    Delete Invoice From API

RT-DP-011 Tạo hóa đơn COD thành công với trạng thái đang giao hàng
    [Documentation]    Kiểm tra tạo hóa đơn COD thành công với trạng thái đang giao hàng
    ...    - Dữ liệu đầu vào: 
    ...    - Mã hóa đơn: "HD_DELIVERY_STS001"
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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Trạng Thái Đang Giao Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Trạng Thái Giao Hàng   2
    [Teardown]    Delete Invoice From API

RT-DP-012 Tạo hóa đơn giao hàng thành công không thu hộ
    [Documentation]    Kiểm tra tạo hóa đơn giao hàng thành công không thu hộ
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
    [Tags]    apiinvoice    delivery    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Không Thu Hộ
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 200
    And Nội dung phản hồi trả về phải tồn tại Id
    And Xác Thực Hóa Đơn Giao Hàng Trong DB Không Thu Hộ
    And Xác Thực Trạng Thái Giao Hàng    1
    [Teardown]    Delete Invoice From API

RT-DP-013 Tạo hóa đơn thất bại khi thời gian giao hàng sớm hơn thời gian hóa đơn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi thời gian giao hàng sớm hơn thời gian hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Invoice.UsingCod: 1 (bật chế độ COD)
    ...    - Invoice.PurchaseDate: "2023-08-15T14:00:00"
    ...    - Invoice.DeliveryDetail.ExpectedDelivery: "2023-08-15T10:00:00" (sớm hơn thời gian hóa đơn)
    ...    - IsValid: false (cần kiểm tra validation)
    ...    - Logic kiểm tra: Logic xác thực thời gian giao hàng trong CreateInvoice
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Thời gian giao hàng phải sau thời gian hóa đơn"
    [Tags]    apiinvoice    delivery    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thời Gian Giao Hàng Sớm So Với Thời Gian Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Thời gian giao hàng phải sau thời gian hóa đơn"

RT-DP-014 Tạo hóa đơn thất bại khi thời gian giao hàng trùng với thời gian hóa đơn
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi thời gian giao hàng trùng với thời gian hóa đơn
    ...    - Dữ liệu đầu vào: 
    ...    - Invoice.UsingCod: 1 (bật chế độ COD)
    ...    - Invoice.PurchaseDate: "2023-08-15T14:00:00"
    ...    - Invoice.DeliveryDetail.ExpectedDelivery: "2023-08-15T14:00:00" (trùng với thời gian hóa đơn)
    ...    - IsValid: false (cần kiểm tra validation)
    ...    - Logic kiểm tra: Logic xác thực thời gian giao hàng trong CreateInvoice
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Thời gian giao hàng phải sau thời gian hóa đơn"
    [Tags]    apiinvoice    delivery    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Với Thời Gian Giao Hàng Trùng So Với Thời Gian Hóa Đơn
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Thời gian giao hàng phải sau thời gian hóa đơn"

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
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Đối Tác Không Hoạt Động
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

RT-DP-016 Tạo hóa đơn thất bại khi đối tác giao hàng không hỗ trợ nhà bán hàng
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi đối tác giao hàng không hỗ trợ nhà bán hàng
    ...    - Dữ liệu đầu vào: 
    ...    - Invoice.UsingCod: 1 (bật chế độ COD)
    ...    - Invoice.DeliveryDetail.UseDefaultPartner: true
    ...    - Invoice.DeliveryDetail.PartnerCode: "${KV_PARTNER_DELIVERY_CODE_WRONG_SCOPE}"
    ...    - Invoice.DeliveryDetail.ServiceAdd: "S1"
    ...    - Logic kiểm tra: Xác thực đối tác vận chuyển trong CreateInvoice
    ...    - Mô phỏng điều kiện:
    ...    - Đối tác không hỗ trợ nhà bán hàng hiện tại (currentCarrierCom.Scope không chứa CurrentRetailerCode)
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."
    [Tags]    apiinvoice    delivery123    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Đối Tác Không Hỗ Trợ Nhà Bán Hàng
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

RT-DP-017 Tạo hóa đơn thất bại khi thiết lập nhà bán hàng không cho phép sử dụng COD qua đối tác KiotViet
    [Documentation]    Kiểm tra tạo hóa đơn thất bại khi thiết lập nhà bán hàng không cho phép sử dụng COD qua đối tác KiotViet
    ...    - Dữ liệu đầu vào: 
    ...    - Invoice.UsingCod: 1 (bật chế độ COD)
    ...    - Invoice.DeliveryDetail.UseDefaultPartner: true
    ...    - Invoice.DeliveryDetail.PartnerCode: "GHN"
    ...    - Invoice.DeliveryDetail.ServiceAdd: "S1"
    ...    - Logic kiểm tra: Xác thực đối tác vận chuyển trong CreateInvoice
    ...    - Mô phỏng điều kiện:
    ...    - Thiết lập của nhà bán hàng: PosSetting.UseCodByKvCarrier = true
    ...    - Kỳ vọng:
    ...    - Status code: 420
    ...    - Thông báo lỗi: "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."
    [Tags]    apiinvoice    delivery123    AIGenerated    regression
    Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Với Thiết Lập Không Cho Phép COD Qua KiotViet
    When Gửi Yêu Cầu Tạo Hóa Đơn
    Then Mã trạng thái phải là 420
    And Phản hồi phải chứa lỗi "Đối tác giao hàng không hợp lệ. Vui lòng kiểm tra lại."

# RT-DP-018 Tạo hóa đơn thất bại khi thiếu thông tin bên trả phí vận chuyển
#     [Documentation]    Kiểm tra tạo hóa đơn thất bại khi thiếu thông tin bên trả phí vận chuyển
#     ...    - Dữ liệu đầu vào: 
#     ...    - Invoice.UsingCod: 1 (bật chế độ COD)
#     ...    - Invoice.DeliveryDetail.UseDefaultPartner: true
#     ...    - Invoice.DeliveryDetail.PartnerCode: "GHN"
#     ...    - Invoice.DeliveryDetail.ServiceAdd: "" (trống)
#     ...    - Logic kiểm tra: Kiểm tra thông tin bên trả phí vận chuyển trong CreateInvoice
#     ...    - Kỳ vọng:
#     ...    - Status code: 420
#     ...    - Thông báo lỗi: "Vui lòng chọn bên trả phí"
#     [Tags]    apiinvoice    delivery    AIGenerated    
#     Given Chuẩn Bị Dữ Liệu Hóa Đơn Giao Hàng Thiếu Thông Tin Bên Trả Phí
#     When Gửi Yêu Cầu Tạo Hóa Đơn
#     Then Mã trạng thái phải là 420
#     And Phản hồi phải chứa lỗi "Vui lòng chọn bên trả phí"