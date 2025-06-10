*** Settings ***
Documentation     Test cases cho chức năng xử lý giao hàng trong đơn hàng
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/DeliveryProcessingData.robot
Resource          ../../../Keywords/Order/DeliveryProcessingKeywords.robot
Resource          ../../../Keywords/Utilities/Utilities.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Order/OrderCommandKeywords.robot
Library           ../../../Resources/DatabaseLibrary.py

*** Test Cases ***

# Test Cases cho Tạo Đơn Hàng với Xử lý Giao hàng

RT-DELIVERY-001 Tạo đơn hàng thành công với thông tin giao hàng COD sử dụng đối tác mặc định
    [Documentation]    Kiểm tra tạo đơn hàng thành công với thông tin giao hàng COD sử dụng đối tác mặc định:
    ...    - UsingCod = 1, UseDefaultPartner = true
    ...    - Có thông tin DeliveryDetail đầy đủ
    ...    - Đối tác giao hàng hoạt động và hỗ trợ COD
    ...    - Cấu hình Settings.UseCodByKvCarrier = true
    [Tags]    AIGenerated    CreateOrder    Positive    COD    DefaultPartner    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng COD Với Đối Tác Mặc Định
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Thông Tin Giao Hàng Đối Tác Mặc Định

RT-DELIVERY-002 Tạo đơn hàng thành công với thông tin giao hàng tự vận chuyển
    [Documentation]    Kiểm tra tạo đơn hàng thành công với thông tin giao hàng tự vận chuyển:
    ...    - UsingCod = 1, UseDefaultPartner = false
    ...    - Có thông tin DeliveryDetail đầy đủ
    ...    - Không sử dụng đối tác giao hàng bên ngoài
    [Tags]    AIGenerated    CreateOrder    Positive    SelfDelivery    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng COD Tự Vận Chuyển
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Thông Tin Giao Hàng Tự Vận Chuyển

RT-DELIVERY-003 Tạo đơn hàng với thông tin địa điểm từ tên LocationName và WardName
    [Documentation]    Kiểm tra tạo đơn hàng với ánh xạ thông tin địa điểm từ tên:
    ...    - Có LocationName và WardName thay vì LocationId và WardId
    ...    - Hệ thống tự động ánh xạ từ tên sang ID
    ...    - Cập nhật thông tin LocationId và WardId sau khi ánh xạ
    [Tags]    AIGenerated    CreateOrder    Positive    LocationMapping    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Ánh Xạ Địa Điểm
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực LocationId Và WardId Được Ánh Xạ Đúng

RT-DELIVERY-004 Tạo đơn hàng với ngày giao hàng dự kiến ExpectedDelivery
    [Documentation]    Kiểm tra tạo đơn hàng với ngày giao hàng dự kiến:
    ...    - Có ExpectedDelivery được chỉ định
    ...    - Xử lý đúng timezone UTC
    ...    - Lưu trữ ngày giao hàng dự kiến chính xác
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDelivery    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Ngày Giao Hàng Dự Kiến
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Ngày Giao Hàng Dự Kiến Được Lưu Đúng

RT-DELIVERY-005 Tạo đơn hàng với nhiều gói hàng (ListDeliveryPackage)
    [Documentation]    Kiểm tra tạo đơn hàng với nhiều gói hàng:
    ...    - DeliveryDetail có ListDeliveryPackage với nhiều gói
    ...    - Mỗi gói có thông tin riêng biệt
    ...    - Liên kết các gói hàng với đơn hàng
    [Tags]    AIGenerated    CreateOrder    Positive    MultiplePackages    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Nhiều Gói Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Nhiều Gói Hàng Được Lưu

RT-DELIVERY-006 Tạo đơn hàng với thanh toán phí giao hàng (DeliveryPayment)
    [Documentation]    Kiểm tra tạo đơn hàng với thanh toán phí giao hàng:
    ...    - DeliveryDetail có DeliveryPayment
    ...    - Phí giao hàng được tính vào tổng tiền đơn hàng
    ...    - Thông tin thanh toán giao hàng được lưu riêng biệt
    [Tags]    AIGenerated    CreateOrder    Positive    DeliveryPayment    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Thanh Toán Phí Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Thanh Toán Phí Giao Hàng Được Lưu

RT-DELIVERY-007 Lỗi khi tạo đơn hàng với đối tác giao hàng không hoạt động
    [Documentation]    Kiểm tra lỗi khi tạo đơn hàng với đối tác giao hàng không hoạt động:
    ...    - UseDefaultPartner = true nhưng đối tác không hoạt động
    ...    - Phát sinh KvValidatePartnerDeliveryException
    ...    - Trả về lỗi 420 với thông báo phù hợp
    [Tags]    AIGenerated    CreateOrder    Negative    InactivePartner    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Đối Tác Không Hoạt Động
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Đối tác giao hàng không hoạt động"

RT-DELIVERY-008 Lỗi khi tạo đơn hàng COD với cấu hình không cho phép
    [Documentation]    Kiểm tra lỗi khi tạo đơn hàng COD với cấu hình không cho phép:
    ...    - UsingCod = 1 nhưng Settings.UseCodByKvCarrier = false
    ...    - Phát sinh KvValidatePartnerDeliveryException
    ...    - Trả về lỗi 420 với thông báo cấu hình
    [Tags]    AIGenerated    CreateOrder    Negative    CODNotAllowed    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng COD Không Được Phép
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Cấu hình COD không được phép"

RT-DELIVERY-009 Lỗi khi tạo đơn hàng với thông tin giao hàng thiếu bắt buộc
    [Documentation]    Kiểm tra lỗi khi tạo đơn hàng với thông tin giao hàng thiếu trường bắt buộc:
    ...    - UsingCod = 1 nhưng thiếu ReceiverName hoặc ReceiverPhone
    ...    - Thiếu địa chỉ giao hàng
    ...    - Trả về lỗi 420 với thông báo trường bắt buộc
    [Tags]    AIGenerated    CreateOrder    Negative    MissingRequiredFields    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Thiếu Thông Tin Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Thiếu thông tin bắt buộc"

RT-DELIVERY-010 Lỗi khi tạo đơn hàng với LocationName/WardName không tồn tại
    [Documentation]    Kiểm tra lỗi khi tạo đơn hàng với tên địa điểm không tồn tại:
    ...    - LocationName hoặc WardName không có trong hệ thống
    ...    - Không thể ánh xạ từ tên sang ID
    ...    - Trả về lỗi 420 với thông báo địa điểm không hợp lệ
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidLocationName    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Địa Điểm Không Tồn Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Địa điểm không hợp lệ"

# Test Cases cho Xử lý Ngoại lệ và Trường hợp Đặc biệt

RT-DELIVERY-020 Xử lý đơn hàng không có UsingCod nhưng có DeliveryDetail
    [Documentation]    Kiểm tra xử lý đơn hàng không sử dụng COD nhưng có thông tin giao hàng:
    ...    - UsingCod = 0 nhưng có DeliveryDetail
    ...    - Thông tin giao hàng không được xử lý
    ...    - Đơn hàng được tạo bình thường
    [Tags]    AIGenerated    CreateOrder    Edge    NoCODWithDelivery    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Không COD Có Thông Tin Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Không Có Thông Tin Giao Hàng Được Lưu

RT-DELIVERY-021 Xử lý đơn hàng COD không có DeliveryDetail
    [Documentation]    Kiểm tra xử lý đơn hàng COD không có thông tin giao hàng:
    ...    - UsingCod = 1 nhưng DeliveryDetail = null
    ...    - Thông tin giao hàng không được xử lý
    ...    - Đơn hàng được tạo bình thường
    [Tags]    AIGenerated    CreateOrder    Edge    CODNoDelivery    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng COD Không Có Thông Tin Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Không Có Thông Tin Giao Hàng Được Lưu

RT-DELIVERY-022 Xử lý log thông tin giao hàng chi tiết
    [Documentation]    Kiểm tra ghi log thông tin giao hàng chi tiết:
    ...    - Tạo đơn hàng COD với thông tin giao hàng đầy đủ
    ...    - Xác thực log WriteLogForDeliveryInfo được tạo
    ...    - Kiểm tra tất cả thông tin trong log
    [Tags]    AIGenerated    CreateOrder    Positive    DeliveryLogging    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Để Kiểm Tra Log Giao Hàng
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Log Giao Hàng Được Tạo
    And Xác Thực Log Chứa Thông Tin Chi Tiết Giao Hàng

RT-DELIVERY-023 Xử lý đơn hàng với thông tin giao hàng có ký tự đặc biệt
    [Documentation]    Kiểm tra xử lý đơn hàng với thông tin giao hàng chứa ký tự đặc biệt:
    ...    - ReceiverName, ReceiverAddress có ký tự đặc biệt
    ...    - Xử lý encoding đúng cách
    ...    - Lưu trữ thông tin chính xác
    [Tags]    AIGenerated    CreateOrder    Edge    SpecialCharacters    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Ký Tự Đặc Biệt
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Ký Tự Đặc Biệt Được Lưu Đúng

RT-DELIVERY-024 Xử lý đơn hàng với thông tin giao hàng có giá trị null
    [Documentation]    Kiểm tra xử lý đơn hàng với một số trường giao hàng có giá trị null:
    ...    - Các trường không bắt buộc có thể null
    ...    - Xử lý null values đúng cách
    ...    - Không gây lỗi hệ thống
    [Tags]    AIGenerated    CreateOrder    Edge    NullValues    DeliveryProcessing
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Với Giá Trị Null
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng COD Được Tạo Trong Database
    And Xác Thực Thông Tin Giao Hàng Được Lưu Trong Database
    And Xác Thực Các Trường Null Được Xử Lý Đúng 