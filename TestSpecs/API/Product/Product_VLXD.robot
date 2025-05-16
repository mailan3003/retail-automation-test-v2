*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot



*** Variables ***
*** Test Cases ***
RT-PRODUCT-036 Tạo Sản Phẩm Với Kích Thước
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    regression  test43443
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Có Kích Thước 10x20 cm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 10x20 cm