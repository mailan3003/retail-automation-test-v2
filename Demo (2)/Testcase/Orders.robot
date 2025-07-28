*** Settings ***
Suite Setup    Tạo session    testz23    admin    Kiotviet123456
Resource    ../Keywords/Purchase_keywords.robot
Resource    ../Keywords/Login_keywords.robot
Resource    ../Keywords/Orders_keywords.robot

*** Test Cases ***

Tạo đơn đặt hàng thành công
    Given Chuẩn bị dữ liệu tạo đơn đặt hàng
    When Gửi yêu cầu tạo đơn đặt hàng
    Then Mã trạng thái trả về là 200
    And Kiểm tra đơn đặt hàng được tạo qua danh sách đơn đặt hàng

Xử lý đơn đặt hàng
    Given Chuẩn bị dữ liệu tạo đơn đặt hàng
    And Gửi yêu cầu tạo đơn đặt hàng
    When Xử lý đơn đặt hàng
    Then Mã trạng thái trả về là 200
