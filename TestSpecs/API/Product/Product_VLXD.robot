*** Settings ***
Documentation     Test API tạo sản phẩm
Suite Setup       Init Test Environment   ${ENV}   MHQL
Resource          ../../../Keywords/Login/Login.robot 
Resource          ../../../Keywords/Product/CreateProductKeywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_vlxd_Keywords.robot
Resource          ../../../Keywords/Product/ProductCommonKeywords.robot

*** Variables ***
@{list_unit}    cm    mm    m
@{list_value}   1    5.355    20
@{list_attribute_name}    L    M
&{dict_attribute_name}    SIZE=@{list_attribute_name}
*** Test Cases ***
RT-PRODUCT-036 Tạo Sản Phẩm Với Kích Thước
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd  
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Gạch Có Kích Thước 10x20 cm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 10x20 cm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-037 Tạo Sản Phẩm Với Kích Thước mm
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd  
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Viên Có Kích Thước 5x7 mm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 5x7 mm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-038 Tạo Sản Phẩm Với Kích Thước m
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd  
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Viên Có Kích Thước 7.88x5.999 m
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 7.88x5.999 m
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-039 Tạo Sản Phẩm Series Với Kích Thước m
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd  
    Given Chuẩn Bị Dữ Liệu Hàng Serial Gạch Có Kích Thước 60x60 m
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 60x60 m
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 

RT-PRODUCT-040 Tạo Sản Phẩm Lô Với Kích Thước mm
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd  
    Given Chuẩn Bị Dữ Liệu Hàng Lô Viên Có Kích Thước 60x5.22 mm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 60x5.22 mm
    [Teardown]     Xóa Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-041 Tạo Sản Phẩm Đơn Vị Với Kích Thước cm
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive    Dimensions    vlxd     
    Given Chuẩn Bị Dữ Liệu Hàng DVQD ${list_unit} Và ${list_value} Có Kích Thước 5.355x20 cm
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Kích Thước 5.355x20 cm
    And Xác Thực Sản Phẩm Có ${LIST_PRODUCT_CODE} Được Tạo Ra Có Đơn Vị ${list_unit} Và ${list_value}
    [Teardown]     Delete Nhiều Sản Phẩm  ${DB_PRODUCT_CODE} 
RT-PRODUCT-042 Tạo Sản Phẩm Thuộc Tính Với Kích Thước m
    [Documentation]    Test tạo sản phẩm có thông tin kích thước
    [Tags]    AIGenerated    CreateProduct    Positive        vlxd  
    Given Chuẩn Bị Dữ Liệu Hàng Thuộc Tính ${dict_attribute_name} Có Kích Thước 5x6 m
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có ${list_product_code} Được Tạo Ra Có ${dict_attribute_name}
    And Xác Thực Sản Phẩm ${LIST_PRODUCT_CODE} Có Kích Thước 5x6 m
    [Teardown]     Delete Nhiều Sản Phẩm  ${LIST_PRODUCT_CODE} 
