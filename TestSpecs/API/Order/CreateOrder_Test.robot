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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng Cơ Bản HH0115
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Thông Tin Chi Tiết Đơn Hàng
    [Teardown]    Delete Order From Api

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
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Chiết Khấu 10 %
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng
    [Teardown]    Delete Order From Api

Tạo Đơn Giảm Giá VND
    
    [Tags]    AIGenerated    CreateOrder    Positive    Discount   regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Giảm Giá 10000
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Chiết Khấu Đơn Hàng Được Tính Đúng
    [Teardown]    Delete Order From Api

Tạo Đơn Với Khách Hàng 
    [Documentation]    Test tạo đơn hàng mới với khách hàng 
    [Tags]    AIGenerated    CreateOrder    Negative    InvalidCustomer    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Khách Hàng CTKH264
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Khách Hàng Trong Đơn Đặt Hàng Là CTKH264
    [Teardown]    Delete Order From Api



RT-ORDER-008 Tạo Đơn Hàng Với Mô Tả Đơn Hàng
    [Documentation]    Test tạo đơn hàng mới có mô tả đơn hàng
    [Tags]    AIGenerated    CreateOrder    Positive    Description    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Mô Tả Đơn Hàng 200 Ký Tự
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Mô Tả Đơn Hàng Được Cập Nhật Đúng
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Với Người Nhận Đặt Hợp Lệ
    
    [Tags]    AIGenerated    CreateOrder    Positive    ValidReceiver    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Người Nhận Đặt son.dx
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Người Nhận Đặt Trong Đơn Hàng là son.dx
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Với Kênh Bán Hợp Lệ
    [Documentation]    Test tạo đơn hàng mới có kênh bán hợp lệ
    [Tags]    AIGenerated    CreateOrder    Positive    ValidSaleChannel    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Kênh Bán Kênh 3
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    And Xác Thực Kênh Bán Trong Đơn Đặt Hàng Là Kênh 3
    [Teardown]    Delete Order From Api

RT-ORDER-005 Tạo Đơn Hàng Bảng Giá
    
    [Tags]    AIGenerated    CreateOrder    Positive    ValidPriceBook    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Bảng Giá Bảng giá chi nhánh
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Đơn Hàng Đã Được Tạo Trong Database
    [Teardown]    Delete Order From Api

Tạo Đơn Hàng Với Ngày Dự Kiến Giao Hàng Thời Gian Tương Lai
    [Documentation]    Test tạo đơn hàng mới có ngày dự kiến giao hàng thời gian tương lai
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDeliveryDate    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thời Gian Giao Hàng Sau 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Thời Gian Giao Hàng Đã Được Cập Nhật Thành Sau 2 Ngày So Với Ngày Hiện Tại

RT-ORDER-009 Tạo Đơn Hàng Với Ngày Dự Kiến Giao Hàng
    [Documentation]    Test tạo đơn hàng mới có ngày dự kiến giao hàng về quá khứ
    [Tags]    AIGenerated    CreateOrder    Positive    ExpectedDeliveryDate    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thời Gian Giao Hàng Trước 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Ngày dự kiến giao phải ở trong tương lai"


RT-ORDER-029 Tạo Đơn Hàng Thay Đổi Ngày Bán Về Quá Khứ
    [Documentation]    Test tạo đơn hàng mới với các trường ngày tháng UTC
    [Tags]    AIGenerated    CreateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Ngày Bán Trước 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Ngày Bán Hàng Đã Được Cập Nhật Thành Trước 2 Ngày So Với Ngày Hiện Tại

RT-ORDER-029 Tạo Đơn Hàng Thay Đổi Ngày Bán Tương Lai
    [Documentation]    Test tạo đơn hàng mới với các trường ngày tháng UTC
    [Tags]    AIGenerated    CreateOrder    Positive    UTCDates    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Ngày Bán Sau 2 Ngày So Với Ngày Hiện Tại
    When Gửi Yêu Cầu Tạo Đơn Hàng
    Then Mã Trạng Thái Phải Là 420
    And Phản Hồi Phải Chứa Lỗi "Vượt quá thời gian hiện tại"

