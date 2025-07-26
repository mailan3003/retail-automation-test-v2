*** Settings ***
Resource    ../Data/env_live.robot
Resource    ../Keywords/Login_keywords.robot
Suite Setup   Tạo session    testz23    admin    Kiotviet123456
Resource    ../Keywords/Purchase_keywords.robot

*** Test Cases ***
Nhập hàng thành công với nhiều hàng hóa
    Given Chuẩn bị dữ liệu phiếu nhập hàng với nhiều hàng hóa
    When Gửi yêu cầu nhập hàng
    Then Mã trạng thái trả về là 200
    And Kiểm tra phiếu nhập hàng được tạo thông qua list danh sách

Nhập hàng thất bại do Id sản phẩm = 0
    Given Chuẩn bị dữ liệu phiếu nhập hàng với Id hàng hóa = 0
    When Gửi yêu cầu nhập hàng thất bại
#     # Then Kiểm tra mã lỗi trả về là 420
#     # And Kiểm tra message lỗi
