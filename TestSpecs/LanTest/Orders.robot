


*** Settings ***
Resource    ../../Keywords/Utilities/RequestHelper.robot
Resource    ../../Keywords/Utilities/ResponseHelper.robot
Resource    ../../Keywords/LanTest/Order_keywords.robot

*** Test Cases ***

RT-ORDERS-001 Tạo đơn đặt hàng thành công không thanh toán với hàng hóa thường
    [Tags]    lanorders
    Given Chuẩn bị dữ liệu đơn hàng
    When Gửi yêu cầu tạo đơn hàng
    Then Mã trạng thái phải là 200
    And Kiểm tra đơn hàng đã tạo thành công
    And Kiểm tra hàng hóa trong chi tiết đơn đặt hàng
    And Kiểm tra khách hàng trong chi tiết đơn đặt hàng
    [Teardown]    Xóa đơn hàng sau khi kiểm tra




