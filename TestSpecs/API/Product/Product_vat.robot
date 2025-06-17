*** Settings ***
Documentation     Test API tạo sản phẩm
Suite Setup       Init Test Environment   ${ENV}     MHQL
Resource          ../../../Keywords/Login/Login.robot
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_VAT_Keywords.robot
Resource          ../../../Keywords/Product/ProductCommonKeywords.robot


*** Variables ***
@{value_attribute_1}   L  M   S
&{dict_attribute_name_1}    SIZE=@{value_attribute_1}
@{name_unit}     Một    nửa
@{value}    1    2
*** Test Cases ***


RT-PRODUCT-009 Tạo Sản Phẩm Với Thuế
    [Documentation]    Test tạo sản phẩm có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Khấu Trừ Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 5 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-010 Tạo Sản Phẩm Với Thuế 0%
    [Documentation]    Test tạo sản phẩm có thuế 0%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Khấu Trừ Với 0 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 0 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-011 Tạo Sản Phẩm Dịch Vụ Với Thuế 8%
    [Documentation]    Test tạo sản phẩm dịch vụ có thuế 8%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Thuế Khấu Trừ Với 8 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 8 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-012 Tạo Sản Phẩm Serial Với Thuế 10%
    [Documentation]    Test tạo sản phẩm serial có thuế 10%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial Thuế Khấu Trừ Với 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 10 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-013 Tạo Sản Phẩm Lô Và Hạn Sử Dụng Không Chịu Thuế
    [Documentation]    Test tạo sản phẩm không chịu thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng Thuế Khấu Trừ Với KCT %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với KCT Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-014 Tạo Sản Phẩm Loại Hàng Sản Xuất Với Thuế 5%
    [Documentation]    Test tạo sản phẩm loại hàng sản xuất có thuế 5%
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Product      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Thuế Khấu Trừ Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 5 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Có Loại Là Hàng Sản Xuất Và Có Hàng ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-015 Tạo Sản Phẩm Combo Với Thuế Khấu Trừ Với KKKNT %
    [Documentation]    Test tạo sản phẩm combo có thuế
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Service      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Thuế Khấu Trừ Với KKKNT %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với KKKNT Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-017 Tạo Sản Phẩm Với Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive   VAT       vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Trực Tiếp Với 2 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 2 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

T-PRODUCT-011 Tạo Sản Phẩm Dịch Vụ Với Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm dịch vụ có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     vlxd
    Given Chuẩn Bị Dữ Liệu Hàng Dịch Vụ Thuế Trực Tiếp Với 3 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Loại Là Dịch Vụ   
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 3 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-012 Tạo Sản Phẩm Serial Với Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm serial có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Serial Thuế Trực Tiếp Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Serial
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 5 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-013 Tạo Sản Phẩm Lô Và Hạn Sử Dụng Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm lô và hạn sử dụng có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Quản Lý Lô Và Hạn Sử Dụng Thuế Trực Tiếp Với 3 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Được Cấu Hình Quản Lý Lô Và Hạn Sử Dụng
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 3 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-018 Tạo Sản Phẩm Combo Với Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm combo có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT    Combo      vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Thuế Trực Tiếp Với 1 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 1 Theo Dữ Liệu Đã Gửi
    And Xác Thực Sản Phẩm Combo Có Chứa Các Thành Phần ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-019 Tạo Sản Phẩm Loại Hàng Sản Xuất Với Thuế Trực Tiếp
    [Documentation]    Test tạo sản phẩm loại hàng sản xuất có thuế trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT24   Product      vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Loại Hàng Sản Xuất Thuế Trực Tiếp Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 5 Theo Dữ Liệu Đã Gửi   
    And Xác Thực Sản Phẩm Có Loại Là Hàng Sản Xuất Và Có Hàng ${PRODUCT_ID_MATERIAL} Với Số Lượng 5
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-022 Tạo Sản Phẩm Với Thuế và Đơn Vị Quy Đổi
    [Documentation]    Test tạo sản phẩm có thuế và đơn vị quy đổi
    [Tags]    AIGenerated    CreateProduct    Positive    VAT   Units      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Khấu Trừ Với 10 % Và Đơn Vị Quy Đổi ${name_unit} Với ${value}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}
    And Xác Thực Tất Cả Sản Phẩm ${LIST_PRODUCT_CODE} Có Thuế Khấu Trừ Với 10 %
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 


RT-PRODUCT-023 Tạo Sản Phẩm Với Thuế và Thuộc Tính
    [Documentation]    Test tạo sản phẩm có thuế và thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    VAT2    Attributes      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Khấu Trừ Với 8 % Và Thuộc Tính ${dict_attribute_name_1}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra
    And Xác Thực Tất Cả Sản Phẩm ${LIST_PRODUCTS_CODE} Có Thuế Khấu Trừ Với 8 %
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-024 Tạo Sản Phẩm Với Thuế và Đơn Vị Quy Đổi Trực Tiếp
    [Documentation]    Test tạo sản phẩm có thuế và đơn vị quy đổi trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT   Units      vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Trực Tiếp Với 1 % Và Đơn Vị Quy Đổi ${name_unit} Với ${value}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200   
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Con Được Tạo Với Đúng Tỷ Lệ Quy Đổi ${value}
    And Xác Thực Tất Cả Sản Phẩm ${LIST_PRODUCT_CODE} Có Thuế Trực Tiếp Với 1 %
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 


RT-PRODUCT-025 Tạo Sản Phẩm Với Thuế và Thuộc Tính Trực Tiếp
    [Documentation]    Test tạo sản phẩm có thuế và thuộc tính trực tiếp
    [Tags]    AIGenerated    CreateProduct    Positive    VAT2    Attributes    vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuế Trực Tiếp Với 2 % Và Thuộc Tính ${dict_attribute_name_1}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCTS_CODE} Được Tạo Ra
    And Xác Thực Tất Cả Sản Phẩm ${LIST_PRODUCTS_CODE} Có Thuế Trực Tiếp Với 2 %
    [Teardown]     Delete Nhiều Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-026 Tạo Sản Phẩm Với Mã Thuế Không Hợp Lệ
    [Documentation]    Test tạo sản phẩm với mã thuế không tồn tại
    [Tags]    AIGenerated    CreateProduct    Negative    VAT     regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Combo Thuế Khấu Trừ Với null %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 420
    And Xác Thực Lỗi "Có lỗi khi cập nhật dữ liệu"


RT-PRODUCT-027 Tạo Sản Phẩm Thế Trực Tiếp Từ From Khác
    [Documentation]    Test tạo sản phẩm thế trực tiếp từ from khác
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form Khác Với Thuế Trực Tiếp Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 5 Theo Dữ Liệu Đã Gửi 
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-028 Tạo Sản Phẩm Thế Khấu Trừ Từ From Khác
    [Documentation]    Test tạo sản phẩm thế khấu trừ từ from khác
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form Khác Với Thuế Khấu Trừ Với 8 %
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 8 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-029 Tạo Sản Phẩm Thuế Trực Tiếp Từ MHBH
    [Documentation]    Test tạo sản phẩm thuế trực tiếp từ mhbh
    [Tags]    AIGenerated    CreateProduct    Positive    VAT     vlxd
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form MHBH Với Thuế Trực Tiếp Với 5 %
    When Gửi Yêu Cầu Tạo Sản Phẩm Từ MHBH
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Trực Tiếp Với 5 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-030 Tạo Sản Phẩm Thuế Khấu Trừ Từ MHBH
    [Documentation]    Test tạo sản phẩm thuế khấu trừ từ mhbh
    [Tags]    AIGenerated    CreateProduct    Positive    VAT      regression
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Tạo Từ Form MHBH Với Thuế Khấu Trừ Với 10 %
    When Gửi Yêu Cầu Tạo Sản Phẩm Từ MHBH
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Thuế Khấu Trừ Với 10 Theo Dữ Liệu Đã Gửi
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

*** Keywords ***

