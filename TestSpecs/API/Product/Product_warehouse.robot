*** Settings ***
Documentation     Test API tạo sản phẩm
Resource          ../../../Keywords/Product/Product_dakho_Keywords.robot
Resource          ../../../Keywords/Product/InputValidationKeywords.robot
Resource          ../../../Keywords/Utilities/ResponseHelper.robot
Resource          ../../../Keywords/Product/Product_KeywordsCommand.robot


*** Variables ***
@{list_kho_hang}    Kho 1    Kho 2    
@{list_ton_kho}    100    22.777    
@{name_unit}    Cái     Hộp   Nửa Hộp   
@{value}    1      6           0.5
@{value_attribute_1}   L  M   S
@{value_attribute_2}   Đỏ  Xanh
&{dict_attribute_name}    SIZE=@{value_attribute_1}    COLOUR=@{value_attribute_2}

*** Test Cases ***

RT-PRODUCT-024 Tạo Sản Phẩm Với Quản Lý Đa Kho
    [Documentation]    Test tạo sản phẩm có quản lý đa kho
    [Tags]    AIGenerated    CreateProduct    Positive    dakho
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có 5.75 Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 100 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 22.777 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 5.75 Và ${TOTAL_ONHAND}

RT-PRODUCT-025 Tạo Sản Phẩm Đa kho Kho chính =0
     [Tags]    AIGenerated    CreateProduct    Positive    
    [Documentation]    Test tạo sản phẩm có cấu hình tồn kho tối thiểu và tối đa
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Có 0 Và Kho Phụ ${list_kho_hang} Với Tồn Kho ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 100 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 22.777 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 0 Và ${TOTAL_ONHAND}
RT-PRODUCT-026 Tạo Sản Phẩm Đơn Vị Tính Và Quy Đổi Đa Kho
    [Documentation]    Test tạo sản phẩm có quản lý lô và hạn sử dụng
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Đơn Vị Tính Và Quy Đổi ${name_unit} Có ${value} Kho Chính Tồn 2 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-027 Tạo Sản Phẩm Với Quản Lý Serial
    [Documentation]    Test tạo sản phẩm có quản lý serial
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse     Serial
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Kho Chính Tồn 5 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Quản Lý Serial

RT-PRODUCT-028 Tạo Sản Phẩm Với Nhiều Chi Nhánh Kho
    [Documentation]    Test tạo sản phẩm có nhiều chi nhánh kho
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse1    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Đơn Vị ${name_unit} Có ${value} Và Kho Chính Tồn 1 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Nhiều Chi Nhánh Kho

*** Keywords ***



