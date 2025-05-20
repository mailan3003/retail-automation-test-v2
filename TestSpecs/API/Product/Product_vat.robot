*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_VAT_Keywords.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot


*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     hai    nửa
@{value}    2    3
@{tax_rates}    0    5    8    10    Không chịu thuế
@{invalid_tax_ids}    999    -1    0
*** Test Cases ***


RT-PRODUCT-009 Tạo Sản Phẩm Với Thuế
    [Documentation]    Test tạo sản phẩm có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT2
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-010 Tạo Sản Phẩm Với Thuế 0%
    [Documentation]    Test tạo sản phẩm có thuế 0%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 0 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 0 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-011 Tạo Sản Phẩm Với Thuế 8%
    [Documentation]    Test tạo sản phẩm có thuế 8%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 8 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 8 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-012 Tạo Sản Phẩm Với Thuế 10%
    [Documentation]    Test tạo sản phẩm có thuế 10%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-013 Tạo Sản Phẩm Không Chịu Thuế
    [Documentation]    Test tạo sản phẩm không chịu thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế Không chịu thuế %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Không chịu thuế Theo Dữ Liệu Đã Gửi

RT-PRODUCT-014 Tạo Nhiều Sản Phẩm Với Các Mức Thuế Khác Nhau
    [Documentation]    Test tạo nhiều sản phẩm với các mức thuế khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Template
    [Template]    Tạo Sản Phẩm Và Xác Thực Thuế
    # tax_rate
    0 %
    5 %
    8 %
    10 %
    Không chịu thuế %

RT-PRODUCT-015 Tạo Sản Phẩm Dịch Vụ Với Thuế
    [Documentation]    Test tạo sản phẩm dịch vụ có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Service
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ

RT-PRODUCT-016 Cập Nhật Thuế Cho Sản Phẩm
    [Documentation]    Test cập nhật mức thuế cho sản phẩm đã tạo
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Update
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    When Chuẩn Bị Dữ Liệu Cập Nhật Thuế 10 % Cho Sản Phẩm
    And Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi

RT-PRODUCT-017 Tạo Sản Phẩm Với Mã Thuế Không Hợp Lệ
    [Documentation]    Test tạo sản phẩm với mã thuế không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Mã Thuế Không Hợp Lệ 999
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mã thuế không tồn tại"

RT-PRODUCT-018 Tạo Sản Phẩm Combo Với Thuế
    [Documentation]    Test tạo sản phẩm combo có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Combo
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Với Thuế 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Có Loại Là Combo

RT-PRODUCT-019 Cập Nhật Thuế Sản Phẩm Không Tồn Tại
    [Documentation]    Test cập nhật thuế với sản phẩm không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Cập Nhật Thuế Cho Sản Phẩm Không Tồn Tại
    When Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Không tìm thấy sản phẩm"

RT-PRODUCT-020 Cập Nhật Thuế Không Hợp Lệ Cho Sản Phẩm
    [Documentation]    Test cập nhật mã thuế không hợp lệ
    [Tags]    AIGenerated    CreateProduct    Negative    VAT    InvalidData
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    When Chuẩn Bị Dữ Liệu Cập Nhật Thuế Không Hợp Lệ Cho Sản Phẩm
    And Gửi Yêu Cầu Cập Nhật Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Mã thuế không tồn tại"

RT-PRODUCT-021 Tạo Sản Phẩm Thuốc Với Thuế
    [Documentation]    Test tạo sản phẩm thuốc có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Medicine
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuốc Với Thuế 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 5 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Là Thuốc Với Thông Tin Chính Xác

RT-PRODUCT-022 Tạo Sản Phẩm Với Thuế và Đơn Vị Quy Đổi
    [Documentation]    Test tạo sản phẩm có thuế và đơn vị quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Units
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 10 % Và Đơn Vị Quy Đổi
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế 10 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}

RT-PRODUCT-023 Tạo Sản Phẩm Với Thuế và Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuế và thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Attributes
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Thuế 5 % Và Thuộc Tính
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra
    And Xác Thực Tất Cả Sản Phẩm Con Có Thuế 5 %

*** Keywords ***

