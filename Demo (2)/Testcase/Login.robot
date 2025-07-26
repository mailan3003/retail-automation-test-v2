*** Settings ***
Resource    ../Data/env_live.robot
Resource    ../Keywords/Login_keywords.robot

*** Test Cases ***

Đăng nhập vào gian hàng thành công
    [Tags]    login
    Given Chuẩn bị dữ liệu gian hàng
    When Gửi yêu cầu đăng nhập
    Then Xác thực đăng nhập thành công
    And Tạo session