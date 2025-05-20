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
@{value_attribute_1}   L  M   
@{value_attribute_2}   Đỏ  Xanh
&{dict_attribute_name}    SIZE=@{value_attribute_1}    COLOUR=@{value_attribute_2}
@{attribute_kho_hang}     Kho bán hàng    Kho 1    Kho 2    
@{attribute_ton_kho}       1,2,3       2.5,1,0     0,55,1       5,11.334,9.88     
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
     [Tags]    AIGenerated    CreateProduct    Positive     dakho 
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
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Đơn Vị Tính ${name_unit} Có ${value} Kho Chính Tồn 2 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Quản Lý Lô Và Hạn Sử Dụng

RT-PRODUCT-027 Tạo Sản Phẩm Đa Kho Có Thuộc Tính
    [Documentation]    Test tạo sản phẩm đa kho có thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse     Serial
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Kho Chính Tồn 5 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Quản Lý Serial

RT-PRODUCT-028 Tạo Sản Phẩm Đa Kho Có Đơn Vị Tính Và Thuộc Tính
    [Documentation]    Test tạo sản phẩm đa kho có đơn vị tính và thuộc tính
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Đơn Vị ${name_unit} Có ${value} Và Kho Chính Tồn 1 Kho Phụ ${list_kho_hang} Tồn ${list_ton_kho}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Nhiều Chi Nhánh Kho

RT-PRODUCT-029 Tạo Sản Phẩm Đa Kho Thuộc Tính Mỗi Loại Có Tồn Kho khác nhau
    [Documentation]    Test tạo sản phẩm đa kho thuộc tính mỗi loại có tồn kho khác nhau
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse1    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Thuộc Tính ${dict_attribute_name} Có Tồn Kho ${attribute_ton_kho} Tương Ứng với Các Kho ${attribute_kho_hang}
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm ${LIST_PRODUCTS_CODE} Tồn ${attribute_ton_kho} Ở Kho ${attribute_kho_hang}

Tạo Sản Phẩm Đa Kho Với Tồn Kho Tất Cả Các Kho Bằng 0
    [Documentation]    Test tạo sản phẩm đa kho với tồn kho tương ứng với các kho
    [Tags]    AIGenerated    CreateProduct    Positive    Warehouse    MultiBranch
    Given Chuẩn Bị Dữ Liệu Sản Phẩm Với Kho Chính Tồn 0 Và Kho Phụ ${list_kho_hang} Tồn 0
    When Gửi Yêu Cầu Tạo Sản Phẩm
    Then Mã Trạng Thái Phải Là 200
    And Xác Thực Sản Phẩm Đã Được Tạo Trong Database
    And Xác Thực Sản Phẩm Có Tồn Kho 0 Ở Chi Nhánh Kho 1
    And Xác Thực Sản Phẩm Có Tồn Kho 0 Ở Chi Nhánh Kho 2
    And Xác Thực Sản Phẩm Ở Kho Bán Hàng Có Tồn Kho 0 Và ${TOTAL_ONHAND}

*** Keywords ***



