*** Settings ***
Documentation     Test API tạo đơn hàng mới
Suite Setup       Init Test Environment   ${ENV}    MHBH
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Order/CreateOrderKeywords.robot
Resource          ../../../Keywords/Order/OrderCommandKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../TestData/CommonData.robot
Resource          ../../../TestData/Order/CreateOrderData.robot
*** Test Cases ***
RT-ORDER-006 Tạo Đơn Hàng Với Thông Tin Thanh Toán
    [Documentation]    Test tạo đơn hàng mới có thông tin thanh toán
    [Tags]    AIGenerated    CreateOrder    Positive    Payment    regression
    Given Chuẩn Bị Dữ Liệu Đơn Hàng HH0115 Có Thanh Toán 50000 Phương Thức Cash
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






