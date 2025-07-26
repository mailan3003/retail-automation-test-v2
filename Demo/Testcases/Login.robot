*** Settings ***
Resource    ../Env_live.robot
Resource    ../Keywords/Login_keywords.robot



*** Test Cases ***
RT-Login-001 Đăng nhập thành công
    [Tags]    lan_test_login
    Given Chuẩn bị dữ liệu đăng nhập vào gian hàng
    When Gửi yêu cầu đăng nhập
    Then Xác nhận trả về token

RT-PRODUCT-001 Xoa hang hoa
    Given Lay thong tin hang hoa
    When Xoa hang hoa


RT Suite setup
    Given Get token